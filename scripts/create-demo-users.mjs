import { createClient } from '@supabase/supabase-js';

const supabaseUrl = process.env.VITE_SUPABASE_URL;
const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!supabaseUrl || !serviceRoleKey) {
  throw new Error('Set VITE_SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY before running this script.');
}

const supabase = createClient(supabaseUrl, serviceRoleKey, {
  auth: {
    autoRefreshToken: false,
    persistSession: false,
  },
});

const defaultPassword = process.env.SAMIS_DEMO_PASSWORD || 'DemoPass2026!';

const demoUsers = [
  ['demo.municipality@samis.local', 'Ayse Demir', 'municipality_admin', 3],
  ['demo.shelter@samis.local', 'Mert Kaya', 'shelter_worker', 2],
  ['demo.field@samis.local', 'Elif Yilmaz', 'field_officer', 2],
  ['demo.vet@samis.local', 'Dr. Can Arslan', 'veterinarian', 2],
  ['demo.adoption@samis.local', 'Zeynep Acar', 'adoption_officer', 2],
  ['demo.ministry@samis.local', 'Selim Ozkan', 'ministry_official', 4],
  ['demo.citizen@samis.local', 'Deniz Vatandas', 'citizen', 1],
  ['demo.admin@samis.local', 'System Admin', 'sysadmin', 5],
];

for (const [email, fullName, role, authLevel] of demoUsers) {
  const { data: existingUsers, error: listError } = await supabase.auth.admin.listUsers();
  if (listError) throw listError;

  const existingUser = existingUsers.users.find((user) => user.email === email);
  const userResult = existingUser
    ? { data: { user: existingUser }, error: null }
    : await supabase.auth.admin.createUser({
        email,
        password: defaultPassword,
        email_confirm: true,
        user_metadata: { full_name: fullName, role },
      });

  if (userResult.error) throw userResult.error;

  const user = userResult.data.user;
  if (!user) throw new Error(`Could not create or load user ${email}.`);

  const { error: profileError } = await supabase.from('users').upsert({
    user_id: user.id,
    full_name: fullName,
    email,
    role,
    auth_level: authLevel,
    is_active: true,
    municipality_id: role === 'ministry_official' || role === 'sysadmin' ? null : '00000000-0000-0000-0000-000000000101',
    facility_id: ['shelter_worker', 'veterinarian'].includes(role) ? '00000000-0000-0000-0000-000000000201' : null,
    is_superadmin: role === 'sysadmin',
  });

  if (profileError) throw profileError;
  console.log(`Ready: ${email}`);
}
