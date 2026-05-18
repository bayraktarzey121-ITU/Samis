-- SAMIS - Stray Animals Management Information System Schema (Supabase PostgreSQL)
-- Türkiye Hayvan Yönetimi Bilgi Sistemi

-- Enable PostGIS for geo-boundary management
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS postgis;

-- 1. Municipalities
CREATE TABLE IF NOT EXISTS municipalities (
    mun_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    city TEXT NOT NULL,
    district TEXT NOT NULL,
    total_capacity INTEGER DEFAULT 0,
    geo_boundary GEOMETRY(MultiPolygon, 4326),
    contact_email TEXT,
    contact_phone TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. User Roles Enum
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'user_role') THEN
        CREATE TYPE user_role AS ENUM (
            'citizen',
            'shelter_worker',
            'field_officer',
            'veterinarian',
            'adoption_officer',
            'municipality_admin',
            'ministry_official',
            'sysadmin'
        );
    END IF;
END $$;

-- 3. Users (Extends auth.users)
CREATE TABLE IF NOT EXISTS users (
    user_id UUID PRIMARY KEY REFERENCES auth.users(id),
    full_name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    phone TEXT,
    role user_role NOT NULL DEFAULT 'citizen',
    auth_level INTEGER DEFAULT 1,
    is_active BOOLEAN DEFAULT TRUE,
    municipality_id UUID REFERENCES municipalities(mun_id),
    facility_id UUID, -- Will reference facilities later
    is_superadmin BOOLEAN DEFAULT FALSE,
    edevlet_subject_id TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. Citizens
CREATE TABLE IF NOT EXISTS citizens (
    user_id UUID PRIMARY KEY REFERENCES users(user_id),
    tc_kimlik_no CHAR(11) NOT NULL,
    address TEXT,
    district TEXT,
    housing_type TEXT, -- Enum-like values: apartment, house_no_garden, house_with_garden, farm
    has_garden BOOLEAN DEFAULT FALSE,
    responsible_training BOOLEAN DEFAULT FALSE,
    prev_ownership_exp INTEGER DEFAULT 0,
    financial_status TEXT,
    mernis_verified BOOLEAN DEFAULT FALSE
);

-- 5. Facilities
CREATE TABLE IF NOT EXISTS facilities (
    facility_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    facility_type TEXT NOT NULL, -- shelter, rehabilitation, vet_clinic
    capacity INTEGER NOT NULL DEFAULT 0,
    current_occupancy INTEGER NOT NULL DEFAULT 0,
    address TEXT,
    municipality_id UUID REFERENCES municipalities(mun_id),
    is_active BOOLEAN DEFAULT TRUE,
    alert_threshold INTEGER DEFAULT 80,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Update users (facility_id)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint WHERE conname = 'fk_user_facility'
    ) THEN
        ALTER TABLE users ADD CONSTRAINT fk_user_facility FOREIGN KEY (facility_id) REFERENCES facilities(facility_id);
    END IF;
END $$;

-- 6. Animals
CREATE TABLE IF NOT EXISTS animals (
    animal_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    microchip_id CHAR(15) UNIQUE NOT NULL,
    name TEXT,
    species TEXT NOT NULL, -- dog, cat, other
    breed TEXT,
    age_estimate NUMERIC,
    sex TEXT, -- male, female
    color_markings TEXT,
    sterilization_status BOOLEAN DEFAULT FALSE,
    status TEXT NOT NULL DEFAULT 'Active', -- Active, In Shelter, Adopted, Deceased, Released
    aggressive_flag BOOLEAN DEFAULT FALSE,
    municipality_id UUID REFERENCES municipalities(mun_id),
    current_facility_id UUID REFERENCES facilities(facility_id),
    registered_by UUID REFERENCES users(user_id),
    registration_date TIMESTAMPTZ DEFAULT NOW(),
    notes TEXT,
    version INTEGER DEFAULT 1,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 7. Animal Location History (Append-only)
CREATE TABLE IF NOT EXISTS animal_location_history (
    history_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    animal_id UUID REFERENCES animals(animal_id),
    event_type TEXT NOT NULL, -- Catch, Transfer, Release, Adoption, Return, Relocation
    event_date TIMESTAMPTZ DEFAULT NOW(),
    location_lat DOUBLE PRECISION,
    location_lng DOUBLE PRECISION,
    facility_id UUID REFERENCES facilities(facility_id),
    from_facility_id UUID REFERENCES facilities(facility_id),
    to_facility_id UUID REFERENCES facilities(facility_id),
    recorded_by UUID REFERENCES users(user_id),
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 8. Vaccinations
CREATE TABLE IF NOT EXISTS vaccinations (
    vaccination_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    animal_id UUID REFERENCES animals(animal_id),
    vet_id UUID REFERENCES users(user_id),
    vaccine_type TEXT NOT NULL,
    administered_at TIMESTAMPTZ DEFAULT NOW(),
    next_due_date TIMESTAMPTZ,
    batch_no TEXT,
    facility_id UUID REFERENCES facilities(facility_id),
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 9. Health Records
CREATE TABLE IF NOT EXISTS health_records (
    record_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    animal_id UUID REFERENCES animals(animal_id),
    vet_id UUID REFERENCES users(user_id),
    record_type TEXT NOT NULL, -- Diagnosis, Surgery, Medication, Checkup, ChronicNote
    record_date TIMESTAMPTZ DEFAULT NOW(),
    diagnosis TEXT,
    treatment TEXT,
    medication TEXT,
    facility_id UUID REFERENCES facilities(facility_id),
    follow_up_date TIMESTAMPTZ,
    cost_tl NUMERIC(12,2),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 10. Operations
CREATE TABLE IF NOT EXISTS operations (
    operation_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    animal_id UUID REFERENCES animals(animal_id),
    operation_type TEXT NOT NULL, -- CNVR, Treatment, Relocation, Euthanasia, Microchipping
    operation_date TIMESTAMPTZ DEFAULT NOW(),
    responsible_mun UUID REFERENCES municipalities(mun_id),
    staff_user_id UUID REFERENCES users(user_id),
    facility_id UUID REFERENCES facilities(facility_id),
    result TEXT,
    cost_tl NUMERIC(12,2),
    notes TEXT,
    location_lat DOUBLE PRECISION,
    location_lng DOUBLE PRECISION,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 11. Complaints
CREATE TABLE IF NOT EXISTS complaints (
    complaint_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    citizen_id UUID REFERENCES users(user_id),
    animal_id UUID REFERENCES animals(animal_id),
    incident_type TEXT NOT NULL, -- AggressiveBehavior, AnimalBite, SickInjured, Nuisance, Other
    description TEXT,
    location_lat DOUBLE PRECISION,
    location_lng DOUBLE PRECISION,
    priority_level TEXT DEFAULT 'Medium', -- Low, Medium, High, Critical
    status TEXT DEFAULT 'Open', -- Open, InProgress, Resolved, Closed
    responsible_mun UUID REFERENCES municipalities(mun_id),
    assigned_staff_id UUID REFERENCES users(user_id),
    submitted_at TIMESTAMPTZ DEFAULT NOW(),
    resolved_at TIMESTAMPTZ,
    photo_url TEXT,
    linked_operation UUID REFERENCES operations(operation_id),
    resolution_notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 12. Adoptions
CREATE TABLE IF NOT EXISTS adoptions (
    adoption_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    animal_id UUID REFERENCES animals(animal_id),
    adopter_id UUID REFERENCES users(user_id),
    staff_id UUID REFERENCES users(user_id),
    application_date TIMESTAMPTZ DEFAULT NOW(),
    approval_date TIMESTAMPTZ,
    status TEXT DEFAULT 'Pending', -- Pending, Approved, Rejected, Completed, Returned, Revoked
    compatibility_score NUMERIC(5,2),
    rejection_reason TEXT,
    next_checkin_date TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 13. Audit Log
CREATE TABLE IF NOT EXISTS audit_log (
    log_id BIGSERIAL PRIMARY KEY,
    user_id UUID REFERENCES users(user_id),
    action TEXT NOT NULL, -- INSERT, UPDATE, DELETE, LOGIN, EXPORT
    table_name TEXT NOT NULL,
    record_id UUID,
    previous_value JSONB,
    new_value JSONB,
    ip_address TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE OR REPLACE FUNCTION current_user_role()
RETURNS user_role
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
    SELECT role FROM users WHERE user_id = auth.uid()
$$;

-- RLS POLICIES (Example)
ALTER TABLE animals ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Adoption animals are visible to citizens" ON animals;
CREATE POLICY "Adoption animals are visible to citizens"
ON animals FOR SELECT
USING (status = 'Active' OR status = 'In Shelter');

DROP POLICY IF EXISTS "Municipal roles can read all animals" ON animals;
CREATE POLICY "Municipal roles can read all animals"
ON animals FOR SELECT
TO authenticated
USING (
    current_user_role() IN ('shelter_worker', 'field_officer', 'veterinarian', 'adoption_officer', 'municipality_admin', 'ministry_official', 'sysadmin')
);

ALTER TABLE municipalities ENABLE ROW LEVEL SECURITY;
ALTER TABLE facilities ENABLE ROW LEVEL SECURITY;
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE citizens ENABLE ROW LEVEL SECURITY;
ALTER TABLE animal_location_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE vaccinations ENABLE ROW LEVEL SECURITY;
ALTER TABLE health_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE operations ENABLE ROW LEVEL SECURITY;
ALTER TABLE complaints ENABLE ROW LEVEL SECURITY;
ALTER TABLE adoptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE audit_log ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Authenticated users can read municipalities" ON municipalities;
CREATE POLICY "Authenticated users can read municipalities"
ON municipalities FOR SELECT
TO authenticated
USING (TRUE);

DROP POLICY IF EXISTS "Authenticated users can read facilities" ON facilities;
CREATE POLICY "Authenticated users can read facilities"
ON facilities FOR SELECT
TO authenticated
USING (TRUE);

DROP POLICY IF EXISTS "Users can read their own profile" ON users;
CREATE POLICY "Users can read their own profile"
ON users FOR SELECT
TO authenticated
USING (
    auth.uid() = user_id
    OR current_user_role() IN ('municipality_admin', 'ministry_official', 'sysadmin')
);

DROP POLICY IF EXISTS "Citizens can read their own citizen record" ON citizens;
CREATE POLICY "Citizens can read their own citizen record"
ON citizens FOR SELECT
TO authenticated
USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Authenticated users can read animal activity" ON animal_location_history;
CREATE POLICY "Authenticated users can read animal activity"
ON animal_location_history FOR SELECT
TO authenticated
USING (TRUE);

DROP POLICY IF EXISTS "Authenticated users can read vaccinations" ON vaccinations;
CREATE POLICY "Authenticated users can read vaccinations"
ON vaccinations FOR SELECT
TO authenticated
USING (TRUE);

DROP POLICY IF EXISTS "Authenticated users can read health records" ON health_records;
CREATE POLICY "Authenticated users can read health records"
ON health_records FOR SELECT
TO authenticated
USING (TRUE);

DROP POLICY IF EXISTS "Authenticated users can read operations" ON operations;
CREATE POLICY "Authenticated users can read operations"
ON operations FOR SELECT
TO authenticated
USING (TRUE);

-- Demo/public read policies for published review environments.
-- Remove or restrict these policies before using production data.
DROP POLICY IF EXISTS "Demo visitors can read municipalities" ON municipalities;
CREATE POLICY "Demo visitors can read municipalities"
ON municipalities FOR SELECT
TO anon
USING (TRUE);

DROP POLICY IF EXISTS "Demo visitors can read facilities" ON facilities;
CREATE POLICY "Demo visitors can read facilities"
ON facilities FOR SELECT
TO anon
USING (TRUE);

DROP POLICY IF EXISTS "Demo visitors can read animal activity" ON animal_location_history;
CREATE POLICY "Demo visitors can read animal activity"
ON animal_location_history FOR SELECT
TO anon
USING (TRUE);

DROP POLICY IF EXISTS "Demo visitors can read vaccinations" ON vaccinations;
CREATE POLICY "Demo visitors can read vaccinations"
ON vaccinations FOR SELECT
TO anon
USING (TRUE);

DROP POLICY IF EXISTS "Demo visitors can read health records" ON health_records;
CREATE POLICY "Demo visitors can read health records"
ON health_records FOR SELECT
TO anon
USING (TRUE);

DROP POLICY IF EXISTS "Demo visitors can read operations" ON operations;
CREATE POLICY "Demo visitors can read operations"
ON operations FOR SELECT
TO anon
USING (TRUE);

DROP POLICY IF EXISTS "Demo visitors can read complaints" ON complaints;
CREATE POLICY "Demo visitors can read complaints"
ON complaints FOR SELECT
TO anon
USING (TRUE);

DROP POLICY IF EXISTS "Demo visitors can read adoptions" ON adoptions;
CREATE POLICY "Demo visitors can read adoptions"
ON adoptions FOR SELECT
TO anon
USING (TRUE);

DROP POLICY IF EXISTS "Users can read relevant complaints" ON complaints;
CREATE POLICY "Users can read relevant complaints"
ON complaints FOR SELECT
TO authenticated
USING (
    citizen_id = auth.uid()
    OR assigned_staff_id = auth.uid()
    OR current_user_role() IN ('municipality_admin', 'ministry_official', 'sysadmin')
);

DROP POLICY IF EXISTS "Users can read relevant adoptions" ON adoptions;
CREATE POLICY "Users can read relevant adoptions"
ON adoptions FOR SELECT
TO authenticated
USING (
    adopter_id = auth.uid()
    OR staff_id = auth.uid()
    OR current_user_role() IN ('adoption_officer', 'municipality_admin', 'ministry_official', 'sysadmin')
);

DROP POLICY IF EXISTS "Admins can read audit log" ON audit_log;
CREATE POLICY "Admins can read audit log"
ON audit_log FOR SELECT
TO authenticated
USING (
    current_user_role() IN ('municipality_admin', 'ministry_official', 'sysadmin')
);

CREATE INDEX IF NOT EXISTS idx_animals_status ON animals(status);
CREATE INDEX IF NOT EXISTS idx_animals_species ON animals(species);
CREATE INDEX IF NOT EXISTS idx_animals_municipality ON animals(municipality_id);
CREATE INDEX IF NOT EXISTS idx_animals_facility ON animals(current_facility_id);
CREATE INDEX IF NOT EXISTS idx_animal_location_animal_date ON animal_location_history(animal_id, event_date DESC);
CREATE INDEX IF NOT EXISTS idx_vaccinations_animal_due ON vaccinations(animal_id, next_due_date);
CREATE INDEX IF NOT EXISTS idx_complaints_status_priority ON complaints(status, priority_level);
CREATE INDEX IF NOT EXISTS idx_complaints_assigned_staff ON complaints(assigned_staff_id);
CREATE INDEX IF NOT EXISTS idx_adoptions_status ON adoptions(status);
CREATE INDEX IF NOT EXISTS idx_facilities_municipality ON facilities(municipality_id);

CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS set_animals_updated_at ON animals;
CREATE TRIGGER set_animals_updated_at
BEFORE UPDATE ON animals
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

DROP TRIGGER IF EXISTS set_adoptions_updated_at ON adoptions;
CREATE TRIGGER set_adoptions_updated_at
BEFORE UPDATE ON adoptions
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();
