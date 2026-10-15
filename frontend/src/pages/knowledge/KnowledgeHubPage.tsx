import React, { useState } from 'react';
import { Link } from 'react-router-dom';
import { BookOpen, ShieldCheck, ArrowRight, Sparkles, Filter, Search, Award } from 'lucide-react';

export const KnowledgeHubPage: React.FC = () => {
  const [searchQuery, setSearchQuery] = useState('');
  const [filterType, setFilterType] = useState<string>('All');

  const breeds = [
    {
      id: 'kangayam',
      name: 'Kangayam Cattle',
      origin: 'Kongu Region, TN',
      type: 'Draft / Dual',
      yield: '600 - 900 L/lactation',
      desc: 'High endurance, extreme heat resilience (THI > 88), zero diesel tractor draft capability & natural FMD immunity.',
      badge: 'Protected Native',
    },
    {
      id: 'gir',
      name: 'Gir Cow',
      origin: 'Gir Hills, Gujarat',
      type: 'A2 Dairy Milch',
      yield: '1800 - 2500 L/lactation',
      desc: 'Premier A2 beta-casein milk producer with high fat content, humped heat dissipation, and gentle temperament.',
      badge: 'High A2 Yield',
    },
    {
      id: 'sahiwal',
      name: 'Sahiwal Cow',
      origin: 'Punjab & Haryana Belt',
      type: 'A2 Dairy Milch',
      yield: '2000 - 2800 L/lactation',
      desc: 'Top Indian milch breed with superior heat tolerance during peak summer, tick resistance, and low mastitis rate.',
      badge: 'Top Milch Breed',
    },
    {
      id: 'ongole',
      name: 'Ongole Cattle',
      origin: 'Prakasam, AP',
      type: 'Heavy Draft & Dairy',
      yield: '1000 - 1500 L/lactation',
      desc: 'World renowned heavy draft bull breed exported globally for tick resistance, eye infection immunity, and genetic hardiness.',
      badge: 'Global Heritage',
    },
    {
      id: 'bargur',
      name: 'Bargur Cattle',
      origin: 'Bargur Hills, Erode, TN',
      type: 'Hill Draft & Speed',
      yield: '450 - 700 L/lactation',
      desc: 'Agile hill pasture breed thriving on wild herbs & stubble with minimal water intake and high foot rot immunity.',
      badge: 'Lowest Feed Cost',
    },
    {
      id: 'umblachery',
      name: 'Umblachery Cattle',
      origin: 'Tanjore Delta, TN',
      type: 'Wetland Draft',
      yield: '500 - 800 L/lactation',
      desc: 'Compact indigenous breed specialized for paddy field ploughing in marshy delta soil and high coastal humidity.',
      badge: 'Paddy Field Master',
    },
    {
      id: 'pulikulam',
      name: 'Pulikulam Cattle',
      origin: 'Madurai & Sivagangai, TN',
      type: 'Dryland Draft',
      yield: '400 - 650 L/lactation',
      desc: 'Hardy drought survivor native breed known for strong herd defense, dryland scrub grazing, and rich organic pen manure.',
      badge: 'Heritage Tamil Native',
    },
    {
      id: 'hallikar',
      name: 'Hallikar Cattle',
      origin: 'Mysore Plateau, Karnataka',
      type: 'Premier Draft',
      yield: '550 - 850 L/lactation',
      desc: 'Origin of South Indian draft breeds with tough hooves for hard soil ploughing and long 20+ year productive lifespan.',
      badge: 'Premier Draft Breed',
    },
    {
      id: 'vechur',
      name: 'Vechur Cow',
      origin: 'Kottayam, Kerala',
      type: 'Medicinal Smallest A2 Cow',
      yield: '500 - 900 L/lactation',
      desc: 'Guinness record smallest cow breed with small fat globule easy-to-digest medicinal A2 milk and lowest feed cost (₹40/day).',
      badge: 'Medicinal A2 Milk',
    },
    {
      id: 'tharparkar',
      name: 'Tharparkar Cow',
      origin: 'Thar Desert, Rajasthan',
      type: 'Desert Dual Purpose',
      yield: '1800 - 2600 L/lactation',
      desc: 'Solar deflecting white coat breed thriving in extreme desert summer heat (up to 50°C) with high A2 milk volume.',
      badge: 'Extreme Drought Resilient',
    },
    {
      id: 'rathi',
      name: 'Rathi Cow',
      origin: 'Bikaner, Rajasthan',
      type: 'Desert Milch Breed',
      yield: '1600 - 2300 L/lactation',
      desc: 'Hardy desert milch cow surviving 2°C winter to 49°C summer with low feeding costs and strong disease immunity.',
      badge: 'Desert Milch Winner',
    },
    {
      id: 'red_sindhi',
      name: 'Red Sindhi Cow',
      origin: 'Pan-India Adapted',
      type: 'A2 Milch Cow',
      yield: '1700 - 2400 L/lactation',
      desc: 'Highly adaptable red-coat indigenous dairy cow producing rich butterfat A2 milk across diverse Indian states.',
      badge: 'High Butterfat A2',
    },
  ];

  const filteredBreeds = breeds.filter((b) => {
    const matchesSearch = b.name.toLowerCase().includes(searchQuery.toLowerCase()) || b.origin.toLowerCase().includes(searchQuery.toLowerCase()) || b.desc.toLowerCase().includes(searchQuery.toLowerCase());
    const matchesType = filterType === 'All' || b.type.includes(filterType);
    return matchesSearch && matchesType;
  });

  return (
    <div className="space-y-6 max-w-5xl mx-auto font-sans">
      {/* Banner */}
      <div className="bg-gradient-to-r from-emerald-800 via-teal-900 to-emerald-950 text-white p-6 sm:p-8 rounded-3xl shadow-xl space-y-2">
        <div className="flex items-center space-x-2">
          <span className="px-3 py-1 bg-amber-400/20 text-amber-300 border border-amber-400/30 rounded-full text-xs font-bold uppercase tracking-wider inline-flex items-center space-x-1">
            <Award className="w-3.5 h-3.5 text-amber-400" />
            <span>National Indigenous Livestock Database</span>
          </span>
        </div>
        <h1 className="text-2xl sm:text-3xl font-extrabold">Indigenous Cattle Encyclopedia</h1>
        <p className="text-xs sm:text-sm text-emerald-100/90 leading-relaxed font-medium">
          Comprehensive guide to 12+ Indian Native Cattle breeds (A2 Dairy, Heavy Draft, Hill Pasture & Desert Breeds) certified by NBAGR.
        </p>
      </div>

      {/* Filter & Search Controls */}
      <div className="flex flex-col sm:flex-row gap-3 justify-between items-center bg-white dark:bg-slate-900 p-4 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-xs">
        <div className="relative w-full sm:w-72">
          <Search className="w-4 h-4 text-slate-400 absolute left-3 top-3" />
          <input
            type="text"
            placeholder="Search breed, state, or traits..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="w-full bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 text-slate-900 dark:text-white text-xs rounded-xl pl-9 pr-3 py-2.5 focus:outline-none focus:ring-2 focus:ring-emerald-500"
          />
        </div>

        <div className="flex items-center space-x-2 w-full sm:w-auto overflow-x-auto">
          {['All', 'Dairy', 'Draft', 'Dual'].map((type) => (
            <button
              key={type}
              onClick={() => setFilterType(type)}
              className={`px-3 py-1.5 rounded-xl text-xs font-bold transition shrink-0 ${
                filterType === type
                  ? 'bg-emerald-600 text-white shadow-sm'
                  : 'bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-300 hover:bg-slate-200'
              }`}
            >
              {type === 'All' ? 'All Breeds' : `${type} Breeds`}
            </button>
          ))}
        </div>
      </div>

      {/* Grid of 12 Indigenous Breeds */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        {filteredBreeds.map((b) => (
          <div key={b.id} className="bg-white dark:bg-slate-900 rounded-3xl p-5 border border-slate-200 dark:border-slate-800 shadow-xs hover:border-emerald-500/50 transition space-y-3 flex flex-col justify-between">
            <div>
              <div className="flex items-center justify-between gap-1 mb-2">
                <span className="text-[10px] font-extrabold px-2.5 py-0.5 rounded-full bg-emerald-100 text-emerald-800 dark:bg-emerald-950 dark:text-emerald-300 border border-emerald-300 dark:border-emerald-800">
                  {b.type}
                </span>
                <span className="text-[10px] font-bold px-2 py-0.5 rounded-full bg-amber-50 text-amber-800 dark:bg-amber-950/60 dark:text-amber-300 border border-amber-200 dark:border-amber-900">
                  {b.badge}
                </span>
              </div>

              <h3 className="font-extrabold text-base text-slate-900 dark:text-white">{b.name}</h3>
              <p className="text-[11px] text-emerald-600 dark:text-emerald-400 font-semibold">{b.origin}</p>
              
              <div className="mt-2 bg-slate-50 dark:bg-slate-800/60 p-2 rounded-xl text-[11px] text-slate-700 dark:text-slate-300 font-medium">
                🥛 Milk Yield: <span className="font-bold text-slate-900 dark:text-white">{b.yield}</span>
              </div>

              <p className="text-xs text-slate-600 dark:text-slate-300 mt-2 leading-relaxed font-normal">{b.desc}</p>
            </div>

            <Link
              to="/recommendation"
              className="w-full py-2.5 bg-emerald-50 dark:bg-emerald-950/50 hover:bg-emerald-600 hover:text-white text-emerald-700 dark:text-emerald-300 text-xs font-bold rounded-xl flex items-center justify-center space-x-1 transition border border-emerald-200 dark:border-emerald-800/80"
            >
              <span>Get AI Recommendation</span>
              <ArrowRight className="w-3.5 h-3.5" />
            </Link>
          </div>
        ))}
      </div>
    </div>
  );
};
