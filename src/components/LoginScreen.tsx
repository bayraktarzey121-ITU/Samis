import React from 'react';
import {
  ArrowRight,
  Building2,
  ClipboardCheck,
  HeartHandshake,
  Map,
  PawPrint,
  ShieldCheck,
  Stethoscope,
  UserRound,
} from 'lucide-react';
import type { UserProfile, UserRole } from '../lib/supabase';

export type DemoProfile = UserProfile & {
  isDemo: true;
};

type DemoProfileOption = {
  role: UserRole;
  name: string;
  title: string;
  email: string;
  accent: string;
  icon: React.ReactNode;
  description: string;
};

interface LoginScreenProps {
  onDemoLogin: (profile: DemoProfile) => void;
}

const demoProfiles: DemoProfileOption[] = [
  {
    role: 'municipality_admin',
    name: 'Ayse Demir',
    title: 'Municipality Admin',
    email: 'demo.municipality@samis.local',
    accent: 'bg-black text-white',
    icon: <Building2 className="h-5 w-5" />,
    description: 'City-wide operations, facilities, complaints, and reporting.',
  },
  {
    role: 'shelter_worker',
    name: 'Mert Kaya',
    title: 'Shelter Worker',
    email: 'demo.shelter@samis.local',
    accent: 'bg-emerald-600 text-white',
    icon: <PawPrint className="h-5 w-5" />,
    description: 'Daily intake, capacity, care status, and animal records.',
  },
  {
    role: 'field_officer',
    name: 'Elif Yilmaz',
    title: 'Field Officer',
    email: 'demo.field@samis.local',
    accent: 'bg-blue-600 text-white',
    icon: <Map className="h-5 w-5" />,
    description: 'Capture events, street locations, observations, and dispatches.',
  },
  {
    role: 'veterinarian',
    name: 'Dr. Can Arslan',
    title: 'Veterinarian',
    email: 'demo.vet@samis.local',
    accent: 'bg-rose-600 text-white',
    icon: <Stethoscope className="h-5 w-5" />,
    description: 'Vaccinations, treatment notes, sterilization, and health risk.',
  },
  {
    role: 'adoption_officer',
    name: 'Zeynep Acar',
    title: 'Adoption Officer',
    email: 'demo.adoption@samis.local',
    accent: 'bg-amber-500 text-white',
    icon: <HeartHandshake className="h-5 w-5" />,
    description: 'Applications, matches, approvals, and adopter follow-up.',
  },
  {
    role: 'ministry_official',
    name: 'Selim Ozkan',
    title: 'Ministry Official',
    email: 'demo.ministry@samis.local',
    accent: 'bg-slate-700 text-white',
    icon: <ClipboardCheck className="h-5 w-5" />,
    description: 'National oversight, audit trails, compliance, and trends.',
  },
  {
    role: 'citizen',
    name: 'Deniz Vatandas',
    title: 'Citizen',
    email: 'demo.citizen@samis.local',
    accent: 'bg-cyan-600 text-white',
    icon: <UserRound className="h-5 w-5" />,
    description: 'Complaint tracking, adoption interest, and public requests.',
  },
  {
    role: 'sysadmin',
    name: 'System Admin',
    title: 'System Admin',
    email: 'demo.admin@samis.local',
    accent: 'bg-violet-600 text-white',
    icon: <ShieldCheck className="h-5 w-5" />,
    description: 'Platform configuration, user access, and integration health.',
  },
];

const createDemoProfile = (profile: DemoProfileOption): DemoProfile => ({
  user_id: `demo-${profile.role}`,
  full_name: profile.name,
  email: profile.email,
  role: profile.role,
  municipality_id: profile.role === 'ministry_official' || profile.role === 'sysadmin' ? undefined : 'demo-municipality',
  facility_id: profile.role === 'shelter_worker' || profile.role === 'veterinarian' ? 'demo-facility' : undefined,
  is_active: true,
  isDemo: true,
});

const LoginScreen: React.FC<LoginScreenProps> = ({ onDemoLogin }) => {
  return (
    <main className="min-h-screen bg-slate-950 text-white">
      <div className="grid min-h-screen lg:grid-cols-[0.9fr_1.1fr]">
        <section className="relative flex flex-col justify-between overflow-hidden border-b border-white/10 bg-[radial-gradient(circle_at_top_left,#155e75_0,#0f172a_38%,#020617_74%)] p-6 sm:p-10 lg:border-b-0 lg:border-r">
          <div className="absolute inset-x-0 bottom-0 h-40 bg-gradient-to-t from-slate-950 to-transparent" />
          <div className="relative z-10">
            <div className="flex items-center gap-3">
              <div className="grid h-11 w-11 place-items-center rounded bg-white text-slate-950 shadow-xl">
                <PawPrint className="h-6 w-6" />
              </div>
              <div>
                <h1 className="font-black-italic text-4xl leading-none tracking-tight">SAMIS</h1>
                <p className="mt-1 text-[10px] font-black uppercase tracking-[0.35em] text-cyan-100/70">
                  Stray Animal Management
                </p>
              </div>
            </div>

            <div className="mt-16 max-w-xl">
              <p className="text-xs font-black uppercase tracking-[0.35em] text-cyan-200/80">Demo access hub</p>
              <h2 className="mt-5 text-5xl font-black leading-[0.95] tracking-tight sm:text-6xl">
                Choose a role and enter the live dashboard flow.
              </h2>
              <p className="mt-6 max-w-lg text-sm leading-6 text-slate-300">
                Use a local demo profile when Supabase has no active session. No production credentials or secrets are stored here.
              </p>
            </div>
          </div>

          <div className="relative z-10 mt-12 grid gap-3 text-xs font-bold text-slate-300 sm:grid-cols-3">
            <div className="border border-white/10 bg-white/5 p-4">
              <span className="block text-2xl font-black text-white">8</span>
              dashboard profiles
            </div>
            <div className="border border-white/10 bg-white/5 p-4">
              <span className="block text-2xl font-black text-white">0</span>
              real secrets
            </div>
            <div className="border border-white/10 bg-white/5 p-4">
              <span className="block text-2xl font-black text-white">1</span>
              click to start
            </div>
          </div>
        </section>

        <section className="bg-slate-50 p-5 text-slate-950 sm:p-8 lg:p-10">
          <div className="mx-auto flex max-w-5xl flex-col gap-6">
            <div className="flex flex-col justify-between gap-3 border-b border-slate-200 pb-6 sm:flex-row sm:items-end">
              <div>
                <p className="text-[10px] font-black uppercase tracking-[0.3em] text-slate-400">Fast login</p>
                <h2 className="mt-2 text-2xl font-black tracking-tight">Select a dashboard role</h2>
              </div>
              <p className="max-w-sm text-xs font-bold uppercase leading-5 tracking-wide text-slate-500">
                Local demo profile only. Supabase sessions continue to take priority.
              </p>
            </div>

            <div className="grid gap-3 sm:grid-cols-2 xl:grid-cols-3">
              {demoProfiles.map((profile) => (
                <button
                  key={profile.role}
                  type="button"
                  onClick={() => onDemoLogin(createDemoProfile(profile))}
                  className="group flex min-h-44 flex-col justify-between border border-slate-200 bg-white p-5 text-left shadow-sm transition-all hover:-translate-y-0.5 hover:border-slate-950 hover:shadow-xl focus:outline-none focus:ring-4 focus:ring-cyan-200"
                >
                  <div className="flex items-start justify-between gap-4">
                    <div className={`grid h-11 w-11 place-items-center rounded ${profile.accent}`}>{profile.icon}</div>
                    <ArrowRight className="h-5 w-5 text-slate-300 transition-transform group-hover:translate-x-1 group-hover:text-slate-950" />
                  </div>
                  <div className="mt-6">
                    <p className="text-lg font-black tracking-tight">{profile.title}</p>
                    <p className="mt-1 text-xs font-bold uppercase tracking-wider text-slate-400">{profile.name}</p>
                    <p className="mt-3 text-sm leading-5 text-slate-600">{profile.description}</p>
                  </div>
                </button>
              ))}
            </div>
          </div>
        </section>
      </div>
    </main>
  );
};

export default LoginScreen;
