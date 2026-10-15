import React, { useState } from 'react';
import { Link } from 'react-router-dom';
import { useAuth } from '../../context/AuthContext';
import { LivestockAnimal } from '../../types';
import { PlusCircle, Search, Filter, ArrowRight } from 'lucide-react';

export const LivestockListPage: React.FC = () => {
  const { t, language } = useAuth();

  const [animals] = useState<LivestockAnimal[]>([
    {
      id: '1',
      tag_number: 'TN-CBT-101',
      name: 'Kangayam Cow #101',
      species: 'Cattle',
      breed: 'Kangayam',
      age_months: 36,
      gender: 'Female',
      weight_kg: 380,
      health_status: 'Healthy',
      lactation_stage: 'Mid Lactation',
      daily_milk_yield_liters: 8.5,
      qr_code_payload: 'https://pasumitra.agri.gov/animal/TN-CBT-101',
    },
    {
      id: '2',
      tag_number: 'TN-CBT-102',
      name: 'Umblachery Cow #102',
      species: 'Cattle',
      breed: 'Umblachery',
      age_months: 28,
      gender: 'Female',
      weight_kg: 320,
      health_status: 'Needs Attention',
      lactation_stage: 'Mid Lactation',
      daily_milk_yield_liters: 6.5,
      qr_code_payload: 'https://pasumitra.agri.gov/animal/TN-CBT-102',
    },
    {
      id: '3',
      tag_number: 'TN-CBT-103',
      name: 'Gir Cow #103',
      species: 'Cattle',
      breed: 'Gir',
      age_months: 32,
      gender: 'Female',
      weight_kg: 420,
      health_status: 'Healthy',
      lactation_stage: 'Peak Lactation',
      daily_milk_yield_liters: 12.0,
      qr_code_payload: 'https://pasumitra.agri.gov/animal/TN-CBT-103',
    },
    {
      id: '4',
      tag_number: 'TN-CBT-104',
      name: 'Sahiwal Cow #104',
      species: 'Cattle',
      breed: 'Sahiwal',
      age_months: 30,
      gender: 'Female',
      weight_kg: 410,
      health_status: 'Healthy',
      lactation_stage: 'Peak Lactation',
      daily_milk_yield_liters: 11.5,
      qr_code_payload: 'https://pasumitra.agri.gov/animal/TN-CBT-104',
    },
  ]);

  const [search, setSearch] = useState('');
  const [speciesFilter, setSpeciesFilter] = useState('All');

  const filtered = animals.filter((a) => {
    const matchesSearch = a.name.toLowerCase().includes(search.toLowerCase()) || a.tag_number.toLowerCase().includes(search.toLowerCase());
    const matchesSpecies = speciesFilter === 'All' || a.species === speciesFilter;
    return matchesSearch && matchesSpecies;
  });

  const getStatusText = (status: string) => {
    if (status === 'Healthy') return t('healthy');
    if (status === 'Needs Attention') return t('needsAttention');
    return status;
  };

  const getSpeciesText = (sp: string) => {
    if (sp === 'Cattle') return t('cattleName');
    if (sp === 'Goat') return t('goatName');
    if (sp === 'Sheep') return t('sheepName');
    return sp;
  };

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
        <div>
          <h1 className="text-xl font-bold text-slate-900 dark:text-white">{t('inventoryTitle')}</h1>
          <p className="text-xs text-slate-500 dark:text-slate-400">{t('inventorySubtitle')}</p>
        </div>

        <Link
          to="/farmer/livestock/add"
          className="inline-flex items-center space-x-2 bg-emerald-600 hover:bg-emerald-500 text-white font-bold text-xs px-4 py-2.5 rounded-xl transition shadow-md shadow-emerald-500/20"
        >
          <PlusCircle className="w-4 h-4" />
          <span>{t('registerAnimal')}</span>
        </Link>
      </div>

      {/* Filter Bar */}
      <div className="bg-white dark:bg-slate-900 p-4 rounded-2xl border border-slate-200 dark:border-slate-800 flex flex-col sm:flex-row gap-3">
        <div className="relative flex-1">
          <Search className="w-4 h-4 text-slate-400 absolute left-3 top-3" />
          <input
            type="text"
            placeholder={t('searchPlaceholder')}
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            className="w-full bg-slate-50 dark:bg-slate-800 text-xs px-3 pl-9 py-2.5 rounded-xl border border-slate-200 dark:border-slate-700 text-slate-900 dark:text-white focus:outline-none focus:ring-2 focus:ring-emerald-500"
          />
        </div>

        <div className="flex items-center space-x-2">
          <Filter className="w-4 h-4 text-slate-400" />
          <select
            value={speciesFilter}
            onChange={(e) => setSpeciesFilter(e.target.value)}
            className="bg-slate-50 dark:bg-slate-800 text-xs px-3 py-2.5 rounded-xl border border-slate-200 dark:border-slate-700 text-slate-900 dark:text-white focus:outline-none"
          >
            <option value="All">All Native Cattle Breeds</option>
            <option value="Cattle">Kangayam Cow</option>
            <option value="Cattle">Umblachery Cow</option>
            <option value="Cattle">Gir A2 Cow</option>
          </select>
        </div>
      </div>

      {/* Animal Cards Grid */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        {filtered.map((animal) => (
          <div key={animal.id} className="bg-white dark:bg-slate-900 rounded-3xl p-5 border border-slate-200 dark:border-slate-800 shadow-xs space-y-4 flex flex-col justify-between">
            <div>
              <div className="flex items-center justify-between">
                <span className="text-[10px] font-mono font-bold bg-slate-100 dark:bg-slate-800 px-2 py-0.5 rounded text-slate-600 dark:text-slate-300">
                  {animal.tag_number}
                </span>
                <span
                  className={`text-[10px] font-bold px-2 py-0.5 rounded-full ${
                    animal.health_status === 'Healthy'
                      ? 'bg-emerald-100 text-emerald-800 dark:bg-emerald-950 dark:text-emerald-300'
                      : 'bg-amber-100 text-amber-800 dark:bg-amber-950 dark:text-amber-300'
                  }`}
                >
                  {getStatusText(animal.health_status)}
                </span>
              </div>

              <h3 className="font-bold text-sm text-slate-900 dark:text-white mt-2">{animal.name}</h3>
              <p className="text-xs text-emerald-600 dark:text-emerald-400 font-medium">{animal.breed} ({getSpeciesText(animal.species)})</p>

              <div className="mt-3 grid grid-cols-2 gap-2 text-[11px] text-slate-500 dark:text-slate-400 border-t border-slate-100 dark:border-slate-800 pt-3">
                <div>
                  <span>{t('age')}:</span> <strong className="text-slate-700 dark:text-slate-200">{animal.age_months} {t('months')}</strong>
                </div>
                <div>
                  <span>{t('weight')}:</span> <strong className="text-slate-700 dark:text-slate-200">{animal.weight_kg} {t('kg')}</strong>
                </div>
              </div>
            </div>

            <Link
              to={`/farmer/livestock/${animal.id}`}
              className="w-full py-2.5 bg-gradient-to-r from-emerald-950 to-slate-900 hover:from-emerald-900 hover:to-slate-800 text-amber-300 font-extrabold text-xs rounded-xl flex items-center justify-center space-x-1.5 transition border border-amber-400/30 shadow-md"
            >
              <span>View QR & Cow Profile</span>
              <ArrowRight className="w-3.5 h-3.5 text-amber-400" />
            </Link>
          </div>
        ))}
      </div>
    </div>
  );
};
