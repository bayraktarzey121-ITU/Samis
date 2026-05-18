# SAMIS - Stray Animals Management Information System

React/Vite frontend with a Supabase backend structure for animal records, shelters, complaints, adoptions, health records, and audit logs.

## Local setup

1. Install dependencies:

   ```bash
   npm install
   ```

2. Create `.env.local` from `.env.example` and set:

   ```bash
   VITE_SUPABASE_URL="https://your-project.supabase.co"
   VITE_SUPABASE_ANON_KEY="your-anon-key"
   SUPABASE_SERVICE_ROLE_KEY="your-service-role-key"
   ```

3. In Supabase SQL Editor, run `schema.sql`. For starter records, run `supabase/seed.sql`.

4. Optional: create demo auth users for the fast access buttons:

   ```bash
   npm run seed:demo-users
   ```

   The default demo password is `DemoPass2026!`. Override it with `SAMIS_DEMO_PASSWORD` when running the script.

5. Start local development:

   ```bash
   npm run dev
   ```

## Vercel deployment

Add `VITE_SUPABASE_URL` and `VITE_SUPABASE_ANON_KEY` as Vercel environment variables, then deploy. The included `vercel.json` publishes the Vite build as a static app and routes client-side navigation back to `index.html`.

## Backend structure

- `schema.sql` contains the Supabase PostgreSQL schema, RLS policies, indexes, and update triggers.
- `supabase/seed.sql` contains starter dynamic data for dashboard and animal list screens.
- `src/lib/samis-api.ts` is the frontend data-access layer for Supabase.
- `server.ts` contains local Express API examples that use the Supabase service role key for server-side operations.
