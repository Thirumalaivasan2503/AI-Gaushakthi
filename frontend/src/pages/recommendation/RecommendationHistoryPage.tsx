import React from 'react';
import { Link } from 'react-router-dom';
import { History, Sparkles, Calendar, ArrowRight } from 'lucide-react';

export const RecommendationHistoryPage: React.FC = () => {
  const historyItems = [
    {
      id: 'pred-1001',
      date: 'Aug 02, 2026',
      district: 'Coimbatore',
      species: 'Cattle',
      topBreed: 'Kangayam Cattle',
      suitability: '94.8%',
      purpose: 'Draft & Dual',
    },
    {
      id: 'pred-1002',
      date: 'Jul 28, 2026',
      district: 'Tanjore',
      species: 'Cattle',
      topBreed: 'Umblachery Cattle',
      suitability: '88.5%',
      purpose: 'Wetland Ploughing',
    },
    {
      id: 'pred-1003',
      date: 'Jul 15, 2026',
      district: 'Salem',
      species: 'Cattle',
      topBreed: 'Sahiwal A2 Cow',
      suitability: '96.2%',
      purpose: 'High A2 Milk Yield',
    },
  ];

  return (
    <div className="space-y-6 max-w-4xl mx-auto">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-xl font-bold text-slate-900 dark:text-white">Recommendation History</h1>
          <p className="text-xs text-slate-500 dark:text-slate-400">Past AI breed predictions & environmental input logs</p>
        </div>

        <Link
          to="/recommendation"
          className="inline-flex items-center space-x-2 bg-emerald-600 hover:bg-emerald-500 text-white font-bold text-xs px-4 py-2.5 rounded-xl shadow-md shadow-emerald-500/20 transition"
        >
          <Sparkles className="w-4 h-4" />
          <span>New Recommendation Run</span>
        </Link>
      </div>

      <div className="bg-white dark:bg-slate-900 rounded-3xl border border-slate-200 dark:border-slate-800 shadow-xs divide-y divide-slate-100 dark:divide-slate-800">
        {historyItems.map((item) => (
          <div key={item.id} className="p-5 flex items-center justify-between hover:bg-slate-50 dark:hover:bg-slate-800/40 transition">
            <div className="flex items-center space-x-4">
              <div className="w-12 h-12 rounded-2xl bg-emerald-100 dark:bg-emerald-950 text-emerald-600 dark:text-emerald-400 flex items-center justify-center font-bold text-xs">
                <Sparkles className="w-6 h-6" />
              </div>
              <div>
                <div className="flex items-center space-x-2">
                  <span className="font-bold text-sm text-slate-900 dark:text-white">{item.topBreed}</span>
                  <span className="text-[10px] font-bold px-2 py-0.5 rounded-full bg-emerald-100 text-emerald-800 dark:bg-emerald-900 dark:text-emerald-200">
                    {item.suitability} Match
                  </span>
                </div>
                <p className="text-xs text-slate-500 dark:text-slate-400 mt-0.5">
                  District: {item.district} • Purpose: {item.purpose}
                </p>
                <div className="flex items-center space-x-1 text-[10px] text-slate-400 mt-1">
                  <Calendar className="w-3 h-3" />
                  <span>{item.date}</span>
                </div>
              </div>
            </div>

            <Link
              to="/recommendation"
              className="p-2 rounded-xl bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-300 hover:bg-emerald-600 hover:text-white transition"
            >
              <ArrowRight className="w-4 h-4" />
            </Link>
          </div>
        ))}
      </div>
    </div>
  );
};
