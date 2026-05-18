import { createClient } from '@supabase/supabase-js';

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL;
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY;

export const isSupabaseConfigured = Boolean(
  supabaseUrl &&
    supabaseAnonKey &&
    !supabaseUrl.includes('your-project') &&
    supabaseAnonKey !== 'your-anon-key',
);

export const supabase = createClient(
  supabaseUrl || 'https://your-project.supabase.co',
  supabaseAnonKey || 'your-anon-key',
);

export type UserRole = 
  | 'citizen'
  | 'shelter_worker'
  | 'field_officer'
  | 'veterinarian'
  | 'adoption_officer'
  | 'municipality_admin'
  | 'ministry_official'
  | 'sysadmin';

export interface UserProfile {
  user_id: string;
  full_name: string;
  email: string;
  role: UserRole;
  municipality_id?: string;
  facility_id?: string;
  is_active: boolean;
}
