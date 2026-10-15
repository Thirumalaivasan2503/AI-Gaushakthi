import React from 'react';
import { Link } from 'react-router-dom';
import { useAuth } from '../../context/AuthContext';
import { GauShakthiLogo } from '../../components/common/GauShakthiLogo';
import { 
  Sparkles, 
  HeartPulse, 
  PlusCircle, 
  Stethoscope, 
  ShieldCheck, 
  ArrowRight,
  QrCode,
  Milk,
  Scale
} from 'lucide-react';

export const FarmerDashboardPage: React.FC = () => {
  const { user, t } = useAuth();

  const livestockSummary = [
    { id: '1', name: 'Kangayam Cow #101', breed: 'Kangayam', species: 'Cattle', status: t('healthy'), milkYield: '8.5 L/day' },
    { id: '2', name: 'Umblachery Cow #102', breed: 'Umblachery', species: 'Cattle', status: t('needsVaccine'), milkYield: '6.2 L/day' },
    { id: '3', name: 'Gir Cow #103', breed: 'Gir', species: 'Cattle', status: t('healthy'), milkYield: '12.0 L/day' },
  ];

  return (
    <div className="space-y-6">
      {/* Welcome Banner */}
      <div className="bg-gradient-to-r from-emerald-600 to-teal-600 rounded-3xl p-6 sm:p-8 text-white shadow-xl relative overflow-hidden">
        <div className="space-y-3 relative z-10">
          <div className="flex items-center justify-between flex-wrap gap-2">
            <span className="px-3 py-1 bg-white/20 rounded-full text-xs font-semibold uppercase tracking-wider backdrop-blur-xs">
              🌾 {t('farmerPortal')}
            </span>
            <div className="bg-white/10 backdrop-blur-md px-3 py-1 rounded-full border border-white/20">
              <GauShakthiLogo size="sm" showText={true} textClassName="text-white" />
            </div>
          </div>
          <h1 className="text-2xl sm:text-3xl font-extrabold tracking-tight">
            {t('welcome')}, {user?.name || 'Farmer'}!
          </h1>
          <p className="text-xs sm:text-sm text-emerald-100/90 leading-relaxed">
            Your farm in <strong className="text-white">{user?.district || 'Coimbatore'}</strong> is operating under optimal temperature-humidity index parameters today.
          </p>

          <div className="pt-2 flex flex-wrap gap-3">
            <Link
              to="/recommendation"
              className="inline-flex items-center space-x-2 bg-white text-emerald-800 hover:bg-emerald-50 px-4 py-2.5 rounded-xl font-bold text-xs shadow-md transition"
            >
              <Sparkles className="w-4 h-4 text-emerald-600" />
              <span>{t('navRecommender')}</span>
            </Link>

            <Link
              to="/farmer/milk-analysis"
              className="inline-flex items-center space-x-2 bg-emerald-700/90 hover:bg-emerald-700 text-white px-4 py-2.5 rounded-xl font-bold text-xs border border-emerald-400/50 shadow-md transition"
            >
              <Milk className="w-4 h-4 text-amber-300" />
              <span>{t('navMilkAnalysis')}</span>
            </Link>

            <Link
              to="/knowledge/compare"
              className="inline-flex items-center space-x-2 bg-teal-800/90 hover:bg-teal-700 text-white px-4 py-2.5 rounded-xl font-bold text-xs border border-teal-400/50 shadow-md transition"
            >
              <Scale className="w-4 h-4 text-emerald-300" />
              <span>{t('navCompareBreeds')}</span>
            </Link>
          </div>
        </div>
      </div>

      {/* Quick Action Grid */}
      <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-6 gap-3">
        <Link
          to="/recommendation"
          className="bg-white dark:bg-slate-900 p-4 rounded-2xl border border-slate-200 dark:border-slate-800 hover:border-emerald-500/80 transition group shadow-xs"
        >
          <div className="w-9 h-9 rounded-xl bg-emerald-100 dark:bg-emerald-950 text-emerald-600 dark:text-emerald-400 flex items-center justify-center mb-2">
            <Sparkles className="w-4 h-4" />
          </div>
          <h3 className="font-bold text-xs text-slate-900 dark:text-white group-hover:text-emerald-600 transition">
            {t('navRecommender')}
          </h3>
          <p className="text-[10px] text-slate-500 dark:text-slate-400 mt-1">26-Feature ML</p>
        </Link>

        <Link
          to="/farmer/milk-analysis"
          className="bg-white dark:bg-slate-900 p-4 rounded-2xl border border-slate-200 dark:border-slate-800 hover:border-amber-500/80 transition group shadow-xs"
        >
          <div className="w-9 h-9 rounded-xl bg-amber-100 dark:bg-amber-950 text-amber-600 dark:text-amber-400 flex items-center justify-center mb-2">
            <Milk className="w-4 h-4" />
          </div>
          <h3 className="font-bold text-xs text-slate-900 dark:text-white group-hover:text-amber-600 transition">
            {t('navMilkAnalysis')}
          </h3>
          <p className="text-[10px] text-slate-500 dark:text-slate-400 mt-1">A2 Protein & Feed</p>
        </Link>

        <Link
          to="/knowledge/compare"
          className="bg-white dark:bg-slate-900 p-4 rounded-2xl border border-slate-200 dark:border-slate-800 hover:border-teal-500/80 transition group shadow-xs"
        >
          <div className="w-9 h-9 rounded-xl bg-teal-100 dark:bg-teal-950 text-teal-600 dark:text-teal-400 flex items-center justify-center mb-2">
            <Scale className="w-4 h-4" />
          </div>
          <h3 className="font-bold text-xs text-slate-900 dark:text-white group-hover:text-teal-600 transition">
            {t('navCompareBreeds')}
          </h3>
          <p className="text-[10px] text-slate-500 dark:text-slate-400 mt-1">Native vs Exotic</p>
        </Link>

        <Link
          to="/farmer/livestock"
          className="bg-white dark:bg-slate-900 p-4 rounded-2xl border border-slate-200 dark:border-slate-800 hover:border-emerald-500/80 transition group shadow-xs"
        >
          <div className="w-9 h-9 rounded-xl bg-emerald-100 dark:bg-emerald-950 text-emerald-600 dark:text-emerald-400 flex items-center justify-center mb-2">
            <HeartPulse className="w-4 h-4" />
          </div>
          <h3 className="font-bold text-xs text-slate-900 dark:text-white group-hover:text-emerald-600 transition">
            {t('navLivestock')}
          </h3>
          <p className="text-[10px] text-slate-500 dark:text-slate-400 mt-1">3 Ear-tagged</p>
        </Link>

        <Link
          to="/farmer/medical-vaccination"
          className="bg-white dark:bg-slate-900 p-4 rounded-2xl border border-slate-200 dark:border-slate-800 hover:border-amber-500/80 transition group shadow-xs"
        >
          <div className="w-9 h-9 rounded-xl bg-amber-100 dark:bg-amber-950 text-amber-600 dark:text-amber-400 flex items-center justify-center mb-2">
            <Stethoscope className="w-4 h-4" />
          </div>
          <h3 className="font-bold text-xs text-slate-900 dark:text-white group-hover:text-amber-600 transition">
            {t('navVaccines')}
          </h3>
          <p className="text-[10px] text-slate-500 dark:text-slate-400 mt-1">1 Vaccine due</p>
        </Link>

        <Link
          to="/government-schemes"
          className="bg-white dark:bg-slate-900 p-4 rounded-2xl border border-slate-200 dark:border-slate-800 hover:border-indigo-500/80 transition group shadow-xs"
        >
          <div className="w-9 h-9 rounded-xl bg-indigo-100 dark:bg-indigo-950 text-indigo-600 dark:text-indigo-400 flex items-center justify-center mb-2">
            <ShieldCheck className="w-4 h-4" />
          </div>
          <h3 className="font-bold text-xs text-slate-900 dark:text-white group-hover:text-indigo-600 transition">
            {t('navSchemes')}
          </h3>
          <p className="text-[10px] text-slate-500 dark:text-slate-400 mt-1">Gokul Mission</p>
        </Link>
      </div>

      {/* Livestock Overview List */}
      <div className="bg-white dark:bg-slate-900 rounded-3xl p-6 border border-slate-200 dark:border-slate-800 shadow-xs space-y-4">
        <div className="flex items-center justify-between">
          <div>
            <h2 className="font-bold text-sm text-slate-900 dark:text-white">{t('activeLivestock')}</h2>
            <p className="text-xs text-slate-500 dark:text-slate-400">{t('earTagIdentity')}</p>
          </div>
          <Link to="/farmer/livestock" className="text-xs font-semibold text-emerald-600 hover:underline flex items-center space-x-1">
            <span>{t('viewAll')}</span>
            <ArrowRight className="w-3.5 h-3.5" />
          </Link>
        </div>

        <div className="divide-y divide-slate-100 dark:divide-slate-800">
          {livestockSummary.map((animal) => (
            <div key={animal.id} className="py-3 flex items-center justify-between">
              <div className="flex items-center space-x-3">
                <div className="w-10 h-10 rounded-xl bg-slate-100 dark:bg-slate-800 flex items-center justify-center text-slate-700 dark:text-slate-300 font-bold text-xs">
                  <QrCode className="w-5 h-5 text-emerald-600" />
                </div>
                <div>
                  <h4 className="font-semibold text-xs text-slate-900 dark:text-white">{animal.name}</h4>
                  <span className="text-[10px] text-slate-500 dark:text-slate-400">
                    {animal.breed} • Indigenous Cattle
                  </span>
                </div>
              </div>

              <div className="flex items-center space-x-3 text-right">
                <div>
                  <span className="block text-[10px] text-slate-400">{t('dailyMilk')}</span>
                  <span className="text-xs font-bold text-slate-700 dark:text-slate-200">{animal.milkYield}</span>
                </div>

                <span
                  className={`px-2.5 py-1 text-[10px] font-bold rounded-full ${
                    animal.status === t('healthy')
                      ? 'bg-emerald-100 text-emerald-800 dark:bg-emerald-950 dark:text-emerald-300'
                      : 'bg-amber-100 text-amber-800 dark:bg-amber-950 dark:text-amber-300'
                  }`}
                >
                  {animal.status}
                </span>

                <Link
                  to="/farmer/livestock"
                  className="p-1.5 rounded-lg bg-slate-100 dark:bg-slate-800 hover:bg-emerald-100 dark:hover:bg-emerald-900 text-slate-600 dark:text-slate-300 text-xs"
                >
                  <ArrowRight className="w-4 h-4" />
                </Link>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};
