import { isSupabaseConfigured, supabase, type UserProfile } from './supabase';

export type DashboardStats = {
  totalAnimals: number;
  adopted: number;
  openComplaints: number;
  shelterCapacity: number;
  overdueVaccinations: number;
};

export type RecentActivity = {
  microchipId: string;
  species: string;
  breed: string;
  location: string;
  officer: string;
  status: string;
  color: 'emerald' | 'blue' | 'amber' | 'slate' | 'rose';
};

export type SpeciesStat = {
  name: string;
  value: number;
  color: string;
};

export type AnimalListItem = {
  animalId: string;
  microchipId: string;
  name: string;
  species: string;
  breed: string;
  facility: string;
  municipality: string;
  status: string;
  health: 'Tam' | 'Eksik' | 'Günü Geçmiş';
  color: 'emerald' | 'blue' | 'amber' | 'slate' | 'rose';
};

export type DashboardData = {
  stats: DashboardStats;
  recentActivities: RecentActivity[];
  species: SpeciesStat[];
  highestCapacityFacility: {
    name: string;
    percentage: number;
  } | null;
};

const statusColor: Record<string, AnimalListItem['color']> = {
  Active: 'blue',
  'In Shelter': 'emerald',
  Adopted: 'slate',
  Released: 'blue',
  Deceased: 'rose',
  Rehab: 'emerald',
  Catch: 'blue',
  'In Vet': 'amber',
};

function requireSupabase() {
  if (!isSupabaseConfigured) {
    throw new Error('Supabase is not configured. Add VITE_SUPABASE_URL and VITE_SUPABASE_ANON_KEY to .env.local.');
  }
}

function countOrZero(count: number | null) {
  return count ?? 0;
}

function getStatusColor(status: string): AnimalListItem['color'] {
  return statusColor[status] ?? 'slate';
}

function getHealthStatus(vaccinations?: Array<{ next_due_date: string | null }>): AnimalListItem['health'] {
  if (!vaccinations || vaccinations.length === 0) return 'Eksik';

  const now = Date.now();
  return vaccinations.some((vaccination) => vaccination.next_due_date && new Date(vaccination.next_due_date).getTime() < now)
    ? 'Günü Geçmiş'
    : 'Tam';
}

export async function getCurrentUserProfile(): Promise<UserProfile | null> {
  requireSupabase();

  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) return null;

  const { data, error } = await supabase.from('users').select('*').eq('user_id', user.id).single();
  if (error) throw error;

  return data as UserProfile;
}

export async function getDashboardData(): Promise<DashboardData> {
  requireSupabase();

  const now = new Date().toISOString();
  const [
    totalAnimals,
    adopted,
    openComplaints,
    overdueVaccinations,
    facilitiesResult,
    speciesResult,
    activityResult,
  ] = await Promise.all([
    supabase.from('animals').select('animal_id', { count: 'exact', head: true }),
    supabase.from('adoptions').select('adoption_id', { count: 'exact', head: true }).in('status', ['Approved', 'Completed']),
    supabase.from('complaints').select('complaint_id', { count: 'exact', head: true }).in('status', ['Open', 'InProgress']),
    supabase.from('vaccinations').select('vaccination_id', { count: 'exact', head: true }).lt('next_due_date', now),
    supabase.from('facilities').select('name, capacity, current_occupancy').eq('is_active', true),
    supabase.from('animals').select('species'),
    supabase
      .from('animal_location_history')
      .select(
        'event_type, location_lat, location_lng, notes, animal:animals(microchip_id, species, breed, status), facility:facilities(name), officer:users(full_name)',
      )
      .order('event_date', { ascending: false })
      .limit(6),
  ]);

  const errors = [
    totalAnimals.error,
    adopted.error,
    openComplaints.error,
    overdueVaccinations.error,
    facilitiesResult.error,
    speciesResult.error,
    activityResult.error,
  ].filter(Boolean);

  if (errors.length > 0) throw errors[0];

  const facilities = facilitiesResult.data ?? [];
  const highestCapacityFacility = facilities.reduce<DashboardData['highestCapacityFacility']>((highest, facility) => {
    const percentage = facility.capacity > 0 ? Math.round((facility.current_occupancy / facility.capacity) * 100) : 0;
    if (!highest || percentage > highest.percentage) return { name: facility.name, percentage };
    return highest;
  }, null);

  const speciesCounts = (speciesResult.data ?? []).reduce<Record<string, number>>((acc, row) => {
    const label = row.species || 'Other';
    acc[label] = (acc[label] ?? 0) + 1;
    return acc;
  }, {});

  return {
    stats: {
      totalAnimals: countOrZero(totalAnimals.count),
      adopted: countOrZero(adopted.count),
      openComplaints: countOrZero(openComplaints.count),
      shelterCapacity: highestCapacityFacility?.percentage ?? 0,
      overdueVaccinations: countOrZero(overdueVaccinations.count),
    },
    highestCapacityFacility,
    species: Object.entries(speciesCounts).map(([name, value], index) => ({
      name,
      value,
      color: index === 0 ? '#000' : '#64748b',
    })),
    recentActivities: (activityResult.data ?? []).map((row: any) => {
      const animal = Array.isArray(row.animal) ? row.animal[0] : row.animal;
      const facility = Array.isArray(row.facility) ? row.facility[0] : row.facility;
      const officer = Array.isArray(row.officer) ? row.officer[0] : row.officer;
      const status = row.event_type || animal?.status || 'Active';

      return {
        microchipId: animal?.microchip_id ?? '-',
        species: animal?.species ?? 'Unknown',
        breed: animal?.breed ?? 'Unknown',
        location: facility?.name ?? row.notes ?? 'Field location',
        officer: officer?.full_name ?? 'Unassigned',
        status,
        color: getStatusColor(status),
      };
    }),
  };
}

export async function getAnimals(searchTerm = ''): Promise<AnimalListItem[]> {
  requireSupabase();

  let query = supabase
    .from('animals')
    .select(
      'animal_id, microchip_id, name, species, breed, status, vaccinations(next_due_date), facility:facilities(name, municipality:municipalities(name))',
    )
    .order('registration_date', { ascending: false })
    .limit(100);

  const term = searchTerm.trim();
  if (term) {
    query = query.or(`microchip_id.ilike.%${term}%,name.ilike.%${term}%,breed.ilike.%${term}%`);
  }

  const { data, error } = await query;
  if (error) throw error;

  return (data ?? []).map((row: any) => {
    const facility = Array.isArray(row.facility) ? row.facility[0] : row.facility;
    const municipality = Array.isArray(facility?.municipality) ? facility.municipality[0] : facility?.municipality;

    return {
      animalId: row.animal_id,
      microchipId: row.microchip_id,
      name: row.name ?? 'Unnamed',
      species: row.species ?? 'Unknown',
      breed: row.breed ?? 'Mixed',
      facility: facility?.name ?? 'Sokak (Başıboş)',
      municipality: municipality?.name ?? 'Belediye atanmadı',
      status: row.status ?? 'Active',
      health: getHealthStatus(row.vaccinations),
      color: getStatusColor(row.status ?? 'Active'),
    };
  });
}
