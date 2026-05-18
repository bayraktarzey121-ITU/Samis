/**
 * @license
 * SPDX-License-Identifier: Apache-2.0
 */

import React, { useEffect, useState } from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import MainLayout from './components/layout/MainLayout';
import Dashboard from './components/Dashboard';
import AnimalsList from './components/AnimalsList';
import LoginScreen, { type DemoProfile } from './components/LoginScreen';
import { getCurrentUserProfile } from './lib/samis-api';
import type { UserProfile } from './lib/supabase';

const DEMO_PROFILE_STORAGE_KEY = 'samis.demoProfile';

const readDemoProfile = (): DemoProfile | null => {
  try {
    const storedProfile = window.localStorage.getItem(DEMO_PROFILE_STORAGE_KEY);
    return storedProfile ? (JSON.parse(storedProfile) as DemoProfile) : null;
  } catch {
    window.localStorage.removeItem(DEMO_PROFILE_STORAGE_KEY);
    return null;
  }
};

const useAuth = () => {
  const [user, setUser] = useState<UserProfile | null>(null);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    let isMounted = true;

    getCurrentUserProfile()
      .then((profile) => {
        if (isMounted) setUser(profile ?? readDemoProfile());
      })
      .catch(() => {
        if (isMounted) setUser(readDemoProfile());
      })
      .finally(() => {
        if (isMounted) setIsLoading(false);
      });

    return () => {
      isMounted = false;
    };
  }, []);

  const loginWithDemoProfile = (profile: DemoProfile) => {
    window.localStorage.setItem(DEMO_PROFILE_STORAGE_KEY, JSON.stringify(profile));
    setUser(profile);
  };

  return { isAuthenticated: Boolean(user), isLoading, loginWithDemoProfile, user };
};

const App: React.FC = () => {
  const { user, isLoading, loginWithDemoProfile } = useAuth();

  if (isLoading) {
    return <div className="min-h-screen grid place-items-center text-xs font-black uppercase tracking-widest text-slate-400">SAMIS yükleniyor...</div>;
  }

  if (!user) {
    return <LoginScreen onDemoLogin={loginWithDemoProfile} />;
  }

  return (
    <Router>
      <MainLayout user={user}>
        <Routes>
          <Route path="/" element={<Dashboard />} />
          <Route path="/dashboard" element={<Dashboard />} />
          <Route path="/animals" element={<AnimalsList />} />
          {/* Placeholder for other routes */}
          <Route path="*" element={<Navigate to="/" replace />} />
        </Routes>
      </MainLayout>
    </Router>
  );
};

export default App;
