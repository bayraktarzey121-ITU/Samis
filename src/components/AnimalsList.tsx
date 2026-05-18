import React, { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { Search, Filter, QrCode, ArrowUpDown } from 'lucide-react';
import { getAnimals, type AnimalListItem } from '../lib/samis-api';
import { cn } from '../lib/utils';

const badgeClasses: Record<AnimalListItem['color'], string> = {
  emerald: 'bg-emerald-100 text-emerald-700',
  blue: 'bg-blue-100 text-blue-700',
  amber: 'bg-amber-100 text-amber-700',
  slate: 'bg-slate-100 text-slate-700',
  rose: 'bg-rose-100 text-rose-700',
};

const AnimalsList: React.FC = () => {
  const { t } = useTranslation();
  const [searchTerm, setSearchTerm] = useState('');
  const [animals, setAnimals] = useState<AnimalListItem[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    let isMounted = true;
    const timeoutId = window.setTimeout(() => {
      setIsLoading(true);

      getAnimals(searchTerm)
        .then((data) => {
          if (isMounted) {
            setAnimals(data);
            setError(null);
          }
        })
        .catch((err) => {
          if (isMounted) setError(err instanceof Error ? err.message : 'Animal list could not be loaded.');
        })
        .finally(() => {
          if (isMounted) setIsLoading(false);
        });
    }, 250);

    return () => {
      isMounted = false;
      window.clearTimeout(timeoutId);
    };
  }, [searchTerm]);

  return (
    <div className="space-y-6 animate-in slide-in-from-bottom-4 duration-500">
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div className="relative flex-1 max-w-md">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
          <input 
            type="text" 
            placeholder="Microchip ID, Name or Breed..." 
            className="w-full pl-10 pr-4 py-2 bg-white border border-slate-200 rounded-sm text-sm focus:outline-none focus:border-black transition-colors font-medium"
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
          />
        </div>
        <div className="flex items-center gap-3">
          <button className="flex items-center gap-2 px-3 py-2 bg-white border border-slate-200 rounded-sm text-xs font-black uppercase tracking-widest hover:border-black transition-colors">
            <Filter className="w-3 h-3" />
            <span>Filtrele</span>
          </button>
          <button className="flex items-center gap-2 px-3 py-2 bg-white border border-slate-200 rounded-sm text-xs font-black uppercase tracking-widest hover:border-black transition-colors">
            <QrCode className="w-3 h-3" />
            <span>Tara</span>
          </button>
        </div>
      </div>

      <div className="bg-white border border-slate-200 shadow-sm overflow-hidden">
        <table className="w-full text-left">
          <thead>
            <tr className="table-header">
              <th className="px-6 py-4">
                <div className="flex items-center gap-2">
                  <span>Microchip ID</span>
                  <ArrowUpDown className="w-3 h-3" />
                </div>
              </th>
              <th className="px-6 py-4">Hayvan Bilgisi</th>
              <th className="px-6 py-4">Konum / Tesis</th>
              <th className="px-6 py-4">Aşı Durumu</th>
              <th className="px-6 py-4">Durum</th>
              <th className="px-6 py-4 text-right">İşlem</th>
            </tr>
          </thead>
          <tbody className="text-sm">
            {animals.map((animal) => (
              <tr key={animal.animalId} className="border-b border-slate-50 hover:bg-slate-50/50 transition-colors">
                <td className="px-6 py-4 font-mono font-bold text-xs">{animal.microchipId}</td>
                <td className="px-6 py-4">
                  <div className="flex flex-col">
                    <span className="font-bold">{animal.name}</span>
                    <span className="text-[10px] text-slate-500 uppercase font-black">{animal.species} • {animal.breed}</span>
                  </div>
                </td>
                <td className="px-6 py-4">
                  <div className="flex flex-col">
                    <span className="text-xs">{animal.facility}</span>
                    <span className="text-[10px] text-slate-400 font-bold uppercase">{animal.municipality}</span>
                  </div>
                </td>
                <td className="px-6 py-4">
                  <span className={cn(
                    "text-[10px] font-black uppercase",
                    animal.health === 'Tam' ? 'text-emerald-600' : 'text-rose-600'
                  )}>
                    {animal.health}
                  </span>
                </td>
                <td className="px-6 py-4">
                  <span className={cn('badge-bold', badgeClasses[animal.color])}>{animal.status}</span>
                </td>
                <td className="px-6 py-4 text-right">
                  <button className="text-[10px] font-black uppercase text-slate-400 hover:text-black tracking-widest transition-colors">
                    Detay
                  </button>
                </td>
              </tr>
            ))}
            {isLoading && (
              <tr>
                <td colSpan={6} className="px-6 py-8 text-center text-xs font-black uppercase tracking-widest text-slate-400">
                  Hayvan kayıtları yükleniyor...
                </td>
              </tr>
            )}
            {!isLoading && error && (
              <tr>
                <td colSpan={6} className="px-6 py-8 text-center text-xs font-bold text-rose-600">
                  {error}
                </td>
              </tr>
            )}
            {!isLoading && !error && animals.length === 0 && (
              <tr>
                <td colSpan={6} className="px-6 py-8 text-center text-xs font-black uppercase tracking-widest text-slate-400">
                  Kayıt bulunamadı
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default AnimalsList;
