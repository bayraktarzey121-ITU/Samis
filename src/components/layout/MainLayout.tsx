/**
 * @license
 * SPDX-License-Identifier: Apache-2.0
 */

import React, { useState } from 'react';
import { useTranslation } from 'react-i18next';
import { 
  BarChart3, 
  MapPin, 
  Dog, 
  MessageSquare, 
  Heart, 
  FileText, 
  ShieldCheck, 
  Bell,
  Plus,
  Globe,
  LogOut,
  User as UserIcon
} from 'lucide-react';
import type { UserProfile } from '../../lib/supabase';
import { cn } from '../../lib/utils';
import { useNavigate } from 'react-router-dom';

interface NavItemProps {
  icon: React.ReactNode;
  label: string;
  active?: boolean;
  onClick?: () => void;
}

const NavItem = ({ icon, label, active, onClick }: NavItemProps) => (
  <div 
    onClick={onClick}
    className={cn(
      "px-3 py-2 rounded-lg flex items-center justify-between cursor-pointer transition-all",
      active 
        ? "bg-white/10 text-white font-semibold shadow-inner" 
        : "text-slate-400 hover:text-white hover:bg-white/5"
    )}
  >
    <div className="flex items-center gap-3">
      {icon}
      <span className="text-sm uppercase tracking-wide">{label}</span>
    </div>
    {active && <div className="w-1 h-1 rounded-full bg-emerald-400"></div>}
  </div>
);

interface MainLayoutProps {
  children: React.ReactNode;
  user: UserProfile | null;
}

const MainLayout: React.FC<MainLayoutProps> = ({ children, user }) => {
  const { t, i18n } = useTranslation();
  const navigate = useNavigate();
  const [activeTab, setActiveTab] = useState('dashboard');
  const displayName = user?.full_name ?? 'Supabase kullanıcı bekleniyor';
  const initials = displayName
    .split(' ')
    .map((part) => part[0])
    .join('')
    .slice(0, 2)
    .toUpperCase();
  const userRole = user?.role ?? 'guest';

  const handleNav = (tab: string, path: string) => {
    setActiveTab(tab);
    navigate(path);
  };

  const toggleLanguage = () => {
    i18n.changeLanguage(i18n.language === 'tr' ? 'en' : 'tr');
  };

  return (
    <div className="flex h-screen w-full bg-[#f8fafc] text-slate-900 font-sans overflow-hidden">
      {/* Sidebar */}
      <aside className="w-64 bg-[#0f172a] text-white flex flex-col shrink-0">
        <div className="p-6 border-b border-slate-700">
          <h1 className="text-3xl font-black-italic">SAMIS</h1>
          <p className="text-[10px] uppercase tracking-widest text-slate-400 font-bold mt-1">
            {t('subtitle')}
          </p>
        </div>
        
        <nav className="flex-1 p-4 space-y-2 overflow-y-auto">
          <NavItem 
            icon={<BarChart3 className="w-4 h-4" />} 
            label={t('dashboard')} 
            active={activeTab === 'dashboard'} 
            onClick={() => handleNav('dashboard', '/dashboard')}
          />
          <NavItem 
            icon={<MapPin className="w-4 h-4" />} 
            label={t('shelters')} 
            active={activeTab === 'shelters'}
            onClick={() => handleNav('shelters', '/shelters')}
          />
          <NavItem 
            icon={<Dog className="w-4 h-4" />} 
            label={t('animals')} 
            active={activeTab === 'animals'}
            onClick={() => handleNav('animals', '/animals')}
          />
          <NavItem 
            icon={<MessageSquare className="w-4 h-4" />} 
            label={t('complaints')} 
            active={activeTab === 'complaints'}
            onClick={() => handleNav('complaints', '/complaints')}
          />
          <NavItem 
            icon={<Heart className="w-4 h-4" />} 
            label={t('adoption')} 
            active={activeTab === 'adoption'}
            onClick={() => handleNav('adoption', '/adoption')}
          />
          <NavItem 
            icon={<FileText className="w-4 h-4" />} 
            label={t('reports')} 
            active={activeTab === 'reports'}
            onClick={() => handleNav('reports', '/reports')}
          />
          <NavItem 
            icon={<ShieldCheck className="w-4 h-4" />} 
            label={t('audit_log')} 
            active={activeTab === 'audit'}
            onClick={() => handleNav('audit', '/audit')}
          />
        </nav>

        <div className="p-4 border-t border-slate-700 bg-slate-900/50">
          <div className="flex items-center gap-3">
            <div className="w-8 h-8 rounded bg-slate-700 flex items-center justify-center font-bold text-xs">
              {initials || 'SA'}
            </div>
            <div className="overflow-hidden">
              <p className="text-xs font-bold truncate">{displayName}</p>
              <p className="text-[10px] text-slate-500 uppercase font-black truncate">{userRole.replace('_', ' ')}</p>
            </div>
            <button className="ml-auto text-slate-500 hover:text-white">
              <LogOut className="w-4 h-4" />
            </button>
          </div>
        </div>
      </aside>

      {/* Main Content */}
      <main className="flex-1 flex flex-col min-w-0">
        <header className="h-16 bg-white border-b border-slate-200 px-8 flex items-center justify-between shrink-0">
          <div className="flex items-center gap-4">
            <button 
              onClick={toggleLanguage}
              className="px-2 py-1 bg-slate-100 text-[10px] font-black rounded uppercase border border-slate-200 hover:bg-slate-200 transition-colors"
            >
              {i18n.language.toUpperCase()}
            </button>
            <div className="h-4 w-px bg-slate-200"></div>
            <h2 className="heading-bold text-xl uppercase tracking-tight">
              {t(activeTab)}
            </h2>
          </div>
          
          <div className="flex items-center gap-6">
            <div className="relative cursor-pointer group">
              <span className="absolute -top-1 -right-1 w-2 h-2 bg-red-500 rounded-full border-2 border-white shadow-sm"></span>
              <Bell className="w-5 h-5 text-slate-400 group-hover:text-black transition-colors" />
            </div>
            <button className="btn-primary-bold flex items-center gap-2">
              <Plus className="w-4 h-4" />
              <span>{t('new_registration')}</span>
            </button>
          </div>
        </header>

        <div className="flex-1 overflow-y-auto p-8 relative">
          {children}
        </div>

        <footer className="h-10 bg-white border-t border-slate-200 px-8 flex items-center justify-between text-[10px] font-bold text-slate-400 uppercase shrink-0">
          <div>Version 1.0.4-PROD | DB: {user ? 'Connected' : 'Configuration required'}</div>
          <div>© 2026 SAMIS - T.C. Çevre Şehircilik ve İklim Değişikliği Bakanlığı</div>
        </footer>
      </main>
    </div>
  );
};

export default MainLayout;
