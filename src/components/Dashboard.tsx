import React, { useEffect, useMemo, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { 
  TrendingUp, 
  ArrowUpRight, 
  AlertTriangle, 
  Dog, 
  Cat, 
  Users,
  Calendar
} from 'lucide-react';
import { 
  BarChart, 
  Bar, 
  XAxis, 
  YAxis, 
  CartesianGrid, 
  Tooltip, 
  ResponsiveContainer,
  LineChart,
  Line,
  Cell,
  PieChart,
  Pie
} from 'recharts';
import { getDashboardData, type DashboardData } from '../lib/samis-api';
import { cn } from '../lib/utils';

const badgeClasses = {
  emerald: 'bg-emerald-100 text-emerald-700',
  blue: 'bg-blue-100 text-blue-700',
  amber: 'bg-amber-100 text-amber-700',
  slate: 'bg-slate-100 text-slate-700',
  rose: 'bg-rose-100 text-rose-700',
};

const formatNumber = (value: number) => new Intl.NumberFormat('tr-TR').format(value);

const StatCard = ({ title, value, subtext, color = "black", trend = "+12.4%", alert = false }: any) => {
  const { t } = useTranslation();
  return (
    <div className={`card-bold border-${color}`}>
      <div className="flex justify-between items-start mb-1">
        <p className="text-[10px] font-black text-slate-400 uppercase tracking-widest">{title}</p>
        <TrendingUp className="w-3 h-3 text-slate-300" />
      </div>
      <p className={`text-4xl font-black tracking-tighter ${alert ? 'text-rose-600' : ''}`}>{value}</p>
      <div className="mt-2 flex items-center gap-1 text-[10px] font-bold">
        {trend && <span className="text-emerald-600">{trend}</span>}
        <span className="text-slate-400 uppercase truncate">{subtext}</span>
      </div>
      {alert && (
        <div className="mt-3 px-2 py-0.5 bg-rose-100 text-rose-700 text-[10px] font-black inline-block rounded">
          {t('capacity_alert')}
        </div>
      )}
    </div>
  );
};

const Dashboard: React.FC = () => {
  const { t } = useTranslation();
  const [dashboard, setDashboard] = useState<DashboardData | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    let isMounted = true;

    getDashboardData()
      .then((data) => {
        if (isMounted) {
          setDashboard(data);
          setError(null);
        }
      })
      .catch((err) => {
        if (isMounted) setError(err instanceof Error ? err.message : 'Dashboard data could not be loaded.');
      })
      .finally(() => {
        if (isMounted) setIsLoading(false);
      });

    return () => {
      isMounted = false;
    };
  }, []);

  const dogCount = useMemo(
    () => dashboard?.species.find((item) => item.name.toLowerCase() === 'dog')?.value ?? 0,
    [dashboard?.species],
  );
  const catCount = useMemo(
    () => dashboard?.species.find((item) => item.name.toLowerCase() === 'cat')?.value ?? 0,
    [dashboard?.species],
  );

  if (isLoading) {
    return <div className="text-xs font-black uppercase tracking-widest text-slate-400">Dashboard verileri yükleniyor...</div>;
  }

  if (error || !dashboard) {
    return (
      <div className="bg-white border border-rose-200 p-6 text-sm">
        <p className="font-black uppercase text-rose-600">Backend bağlantısı hazır değil</p>
        <p className="mt-2 text-slate-500">{error}</p>
      </div>
    );
  }

  return (
    <div className="space-y-8 animate-in fade-in duration-500">
      {/* Stats Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        <StatCard title={t('total_animals')} value={formatNumber(dashboard.stats.totalAnimals)} subtext="live from animals" trend="" />
        <StatCard title={t('adopted')} value={formatNumber(dashboard.stats.adopted)} subtext="approved/completed" trend="" color="emerald-500" />
        <StatCard title={t('open_complaints')} value={formatNumber(dashboard.stats.openComplaints)} subtext="open and in progress" trend="" color="amber-500" />
        <StatCard title={t('shelter_capacity')} value={`${dashboard.stats.shelterCapacity}%`} subtext={dashboard.highestCapacityFacility?.name ?? 'No facility'} trend="" color="rose-500" alert={dashboard.stats.shelterCapacity >= 80} />
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
        {/* Main Table/Chart Area */}
        <div className="lg:col-span-2 space-y-8">
          <div className="bg-white border border-slate-200 flex flex-col h-full min-h-[400px]">
            <div className="p-4 border-b border-slate-100 flex items-center justify-between">
              <h3 className="font-black text-sm uppercase">Son Faaliyet Kayıtları</h3>
              <button className="text-[10px] font-bold text-slate-400 hover:text-black uppercase tracking-widest">
                Tümünü Gör
              </button>
            </div>
            <div className="flex-1 overflow-x-auto">
              <table className="w-full text-left">
                <thead>
                  <tr className="table-header">
                    <th className="px-4 py-3">Microchip ID</th>
                    <th className="px-4 py-3">Cins</th>
                    <th className="px-4 py-3">Konum</th>
                    <th className="px-4 py-3">Görevli</th>
                    <th className="px-4 py-3">Durum</th>
                  </tr>
                </thead>
                <tbody className="text-xs">
                  {dashboard.recentActivities.map((row, i) => (
                    <tr key={i} className="border-b border-slate-50 hover:bg-slate-50/50 group transition-colors">
                      <td className="px-4 py-4 font-mono font-bold">{row.microchipId}</td>
                      <td className="px-4 py-4">{row.species} ({row.breed})</td>
                      <td className="px-4 py-4 truncate max-w-[150px]">{row.location}</td>
                      <td className="px-4 py-4 text-slate-500">{row.officer}</td>
                      <td className="px-4 py-4">
                        <span className={cn('badge-bold', badgeClasses[row.color])}>{row.status}</span>
                      </td>
                    </tr>
                  ))}
                  {dashboard.recentActivities.length === 0 && (
                    <tr>
                      <td colSpan={5} className="px-4 py-8 text-center text-xs font-bold uppercase text-slate-400">
                        Henüz faaliyet kaydı yok
                      </td>
                    </tr>
                  )}
                </tbody>
              </table>
            </div>
          </div>
        </div>

        {/* Sidebar Alerts / Secondary Charts */}
        <div className="flex flex-col gap-6">
          <div className="bg-[#0f172a] text-white p-6 rounded-sm shadow-xl relative overflow-hidden group">
            <div className="absolute top-0 right-0 p-8 opacity-5 group-hover:opacity-10 transition-opacity">
              <AlertTriangle className="w-32 h-32" />
            </div>
            <div className="flex justify-between items-start relative z-10">
              <h3 className="text-xs font-black uppercase tracking-widest text-slate-400">{t('critical_alert')}</h3>
              <AlertTriangle className="w-4 h-4 text-rose-500" />
            </div>
            <p className="text-lg font-bold mt-4 leading-tight relative z-10">
              {dashboard.highestCapacityFacility
                ? `${dashboard.highestCapacityFacility.name} kapasitesi %${dashboard.highestCapacityFacility.percentage} seviyesinde.`
                : 'Aktif tesis kapasite verisi bulunamadı.'}
            </p>
            <p className="text-xs text-slate-400 mt-2 italic font-serif leading-relaxed relative z-10">
              "Transfer işlemleri başlatılmalı veya geçici kabul kararları canlı kapasiteye göre verilmelidir."
            </p>
            <button className="mt-6 w-full py-2 bg-rose-600 hover:bg-rose-700 text-xs font-black uppercase tracking-widest rounded-sm transition-colors relative z-10">
              Eyleme Geç
            </button>
          </div>

          <div className="bg-white border border-slate-200 p-6 flex flex-col flex-1 min-h-[300px]">
            <h3 className="font-black text-sm uppercase mb-4">Vax Risk Radar</h3>
            <div className="space-y-6 flex-1 flex flex-col justify-center">
              <div className="flex flex-col gap-2">
                <div className="flex justify-between text-[10px] font-black uppercase">
                  <span>Overdue Vaccinations</span>
                  <span>{dashboard.stats.overdueVaccinations}</span>
                </div>
                <div className="w-full h-2 bg-slate-100 rounded-full overflow-hidden">
                  <div className="w-[68%] h-full bg-black"></div>
                </div>
              </div>
              <div className="flex flex-col gap-2">
                <div className="flex justify-between text-[10px] font-black uppercase text-rose-600">
                  <span>Vaccination Risk</span>
                  <span>{dashboard.stats.overdueVaccinations > 0 ? 'Critical' : 'Normal'}</span>
                </div>
                <div className="w-full h-2 bg-slate-100 rounded-full overflow-hidden">
                  <div className={cn('h-full', dashboard.stats.overdueVaccinations > 0 ? 'w-[84%] bg-rose-600' : 'w-[8%] bg-emerald-600')}></div>
                </div>
              </div>
              <div className="pt-4 flex items-center justify-between border-t border-slate-50">
                <div className="flex items-center gap-2">
                  <Dog className="w-4 h-4 text-slate-400" />
                  <span className="text-[10px] font-bold text-slate-500 uppercase">Registered Dogs</span>
                </div>
                <span className="text-sm font-black tracking-tighter">{formatNumber(dogCount)}</span>
              </div>
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-2">
                  <Cat className="w-4 h-4 text-slate-400" />
                  <span className="text-[10px] font-bold text-slate-500 uppercase">Registered Cats</span>
                </div>
                <span className="text-sm font-black tracking-tighter">{formatNumber(catCount)}</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Dashboard;
