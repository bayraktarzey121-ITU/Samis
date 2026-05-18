# SAMIS Supabase Backend

1. Create a Supabase project.
2. Run `schema.sql` in the Supabase SQL editor.
3. Optionally run `supabase/seed.sql` for starter data that matches the frontend views.
4. Add `VITE_SUPABASE_URL` and `VITE_SUPABASE_ANON_KEY` to `.env.local` and to Vercel project environment variables.
5. Keep `SUPABASE_SERVICE_ROLE_KEY` only in server-side environments.

The frontend now reads dashboard, animal list, auth profile, and facility/vaccination status data through `src/lib/samis-api.ts`.
