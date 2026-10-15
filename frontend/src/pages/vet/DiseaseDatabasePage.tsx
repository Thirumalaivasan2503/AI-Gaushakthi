import React, { useState, useEffect } from 'react';
import { Search, ShieldAlert, HeartPulse, Stethoscope, AlertTriangle, CheckCircle2, Shield, Thermometer, Coins, Leaf, Sparkles } from 'lucide-react';
import { apiService } from '../../services/api';
import { DiseaseMasterInfo } from '../../types';

export const DiseaseDatabasePage: React.FC = () => {
  const [search, setSearch] = useState('');
  const [diseases, setDiseases] = useState<DiseaseMasterInfo[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchDiseases();
  }, []);

  const fetchDiseases = async () => {
    setLoading(true);
    try {
      const res = await apiService.getDiseases();
      if (res && res.data) {
        setDiseases(res.data);
      }
    } catch (err) {
      console.error('Error loading diseases from disease_master.csv:', err);
    } finally {
      setLoading(false);
    }
  };

  const handleSearch = async (query: string) => {
    setSearch(query);
    if (!query.trim()) {
      fetchDiseases();
      return;
    }
    try {
      const res = await apiService.searchDiseases(query);
      if (res && res.data) {
        setDiseases(res.data);
      }
    } catch (err) {
      console.error('Error searching disease master dataset:', err);
    }
  };

  return (
    <div className="space-y-6 max-w-5xl mx-auto font-sans">
      {/* Header Banner (Forest Green & Elegant Gold) */}
      <div className="bg-gradient-to-r from-emerald-950 via-slate-900 to-teal-950 rounded-3xl p-6 sm:p-8 text-white border-2 border-emerald-500/40 shadow-2xl space-y-4">
        <div className="flex items-center space-x-3">
          <div className="w-12 h-12 rounded-2xl bg-amber-400/20 text-amber-400 flex items-center justify-center shrink-0 border border-amber-400/40 shadow-lg">
            <HeartPulse className="w-6 h-6 text-amber-400" />
          </div>
          <div>
            <span className="text-[10px] font-extrabold text-amber-300 uppercase tracking-wider block">
              Disease Knowledge Base (disease_master.csv)
            </span>
            <h1 className="text-2xl sm:text-3xl font-black text-white">
              Livestock Pathology & Disease Intelligence Catalog
            </h1>
          </div>
        </div>
        <p className="text-xs text-emerald-200 leading-relaxed max-w-3xl">
          Real-time disease diagnostics, vector transmission modes, prevention guidelines, vaccine availability, and estimated treatment costs cached directly from <code className="text-amber-300 font-mono">disease_master.csv</code>.
        </p>

        {/* Search Bar */}
        <div className="relative pt-2">
          <Search className="w-4 h-4 text-emerald-400 absolute left-4 top-5" />
          <input
            type="text"
            placeholder="Search disease by name, symptom, cause, category or breed (e.g. Foot and Mouth, Mastitis, Fever)..."
            value={search}
            onChange={(e) => handleSearch(e.target.value)}
            className="w-full bg-white/10 dark:bg-slate-900/80 text-xs px-4 pl-11 py-3.5 rounded-2xl border border-emerald-500/40 text-white placeholder-emerald-300/60 focus:outline-none focus:ring-2 focus:ring-amber-400 backdrop-blur-md shadow-xl"
          />
        </div>
      </div>

      {loading ? (
        <div className="text-center py-12 text-xs text-slate-500">
          Loading disease knowledge base...
        </div>
      ) : diseases.length === 0 ? (
        <div className="text-center py-12 text-xs text-slate-500 bg-white dark:bg-slate-900 rounded-3xl p-6 border border-slate-200 dark:border-slate-800">
          No matching diseases found for &quot;{search}&quot;.
        </div>
      ) : (
        <div className="space-y-6">
          {diseases.map((d, index) => (
            <div
              key={d.Disease_ID || `disease-${index}`}
              className="bg-white dark:bg-slate-900 rounded-3xl p-6 sm:p-8 border border-slate-200 dark:border-slate-800 shadow-xl space-y-6"
            >
              {/* Top Row Header */}
              <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-3 border-b border-slate-100 dark:border-slate-800 pb-4">
                <div>
                  <div className="flex items-center space-x-2">
                    <span className="px-3 py-1 bg-emerald-950 text-amber-300 border border-amber-400/40 text-[10px] font-extrabold rounded-full uppercase tracking-wider">
                      {d.Disease_Category || 'Infectious'}
                    </span>
                    <span className="text-xs text-slate-400 font-mono">
                      ID: {d.Disease_ID}
                    </span>
                    {d.Affected_Species && (
                      <span className="text-xs bg-slate-100 dark:bg-slate-800 text-slate-700 dark:text-slate-300 px-2.5 py-0.5 rounded-lg font-medium">
                        Species: {d.Affected_Species}
                      </span>
                    )}
                  </div>

                  <h2 className="text-2xl font-black text-slate-900 dark:text-white mt-1.5">
                    {d.Disease_Name}
                  </h2>
                </div>

                <div className="flex items-center space-x-2 shrink-0">
                  <span className={`px-3 py-1.5 rounded-xl text-xs font-black flex items-center space-x-1 ${
                    d.Risk_Level === 'Critical' || d.Risk_Level === 'Very High'
                      ? 'bg-rose-500/20 text-rose-500 border border-rose-500/40'
                      : d.Risk_Level === 'High'
                      ? 'bg-amber-500/20 text-amber-500 border border-amber-500/40'
                      : 'bg-emerald-500/20 text-emerald-600 border border-emerald-500/40'
                  }`}>
                    <AlertTriangle className="w-3.5 h-3.5" />
                    <span>Risk: {d.Risk_Level}</span>
                  </span>
                </div>
              </div>

              {/* 16 Required Attributes Grid */}
              <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 gap-3 text-xs">
                <div className="bg-slate-50 dark:bg-slate-800/60 p-3 rounded-2xl border border-slate-200 dark:border-slate-700 space-y-1">
                  <span className="text-[10px] font-bold text-slate-400 uppercase block">Severity</span>
                  <strong className="text-slate-900 dark:text-white font-extrabold">{d.Severity}</strong>
                </div>

                <div className="bg-slate-50 dark:bg-slate-800/60 p-3 rounded-2xl border border-slate-200 dark:border-slate-700 space-y-1">
                  <span className="text-[10px] font-bold text-slate-400 uppercase block">Transmission Mode</span>
                  <strong className="text-slate-900 dark:text-white font-extrabold">{d.Transmission_Mode}</strong>
                </div>

                <div className="bg-slate-50 dark:bg-slate-800/60 p-3 rounded-2xl border border-slate-200 dark:border-slate-700 space-y-1">
                  <span className="text-[10px] font-bold text-slate-400 uppercase block">Vaccine Available</span>
                  <strong className={`font-extrabold ${d.Vaccine_Available === 'Yes' ? 'text-emerald-600 dark:text-emerald-400' : 'text-amber-600 dark:text-amber-400'}`}>
                    {d.Vaccine_Available === 'Yes' ? '✓ Vaccine Available' : 'No Vaccine'}
                  </strong>
                </div>

                <div className="bg-slate-50 dark:bg-slate-800/60 p-3 rounded-2xl border border-slate-200 dark:border-slate-700 space-y-1">
                  <span className="text-[10px] font-bold text-slate-400 uppercase block">Recovery Period</span>
                  <strong className="text-slate-900 dark:text-white font-extrabold">{d.Recovery_Period_Days} Days</strong>
                </div>

                <div className="bg-slate-50 dark:bg-slate-800/60 p-3 rounded-2xl border border-slate-200 dark:border-slate-700 space-y-1">
                  <span className="text-[10px] font-bold text-slate-400 uppercase block">High Risk Breeds</span>
                  <strong className="text-slate-900 dark:text-white font-extrabold">{d.High_Risk_Breeds}</strong>
                </div>

                <div className="bg-slate-50 dark:bg-slate-800/60 p-3 rounded-2xl border border-slate-200 dark:border-slate-700 space-y-1">
                  <span className="text-[10px] font-bold text-slate-400 uppercase block">Climate Risk</span>
                  <strong className="text-slate-900 dark:text-white font-extrabold">{d.Climate_Risk}</strong>
                </div>

                <div className="bg-slate-50 dark:bg-slate-800/60 p-3 rounded-2xl border border-slate-200 dark:border-slate-700 space-y-1">
                  <span className="text-[10px] font-bold text-amber-600 dark:text-amber-400 uppercase block">Est. Treatment Cost</span>
                  <strong className="text-amber-600 dark:text-amber-400 font-black text-sm">₹{d.Estimated_Treatment_Cost_INR}</strong>
                </div>

                <div className="bg-slate-50 dark:bg-slate-800/60 p-3 rounded-2xl border border-slate-200 dark:border-slate-700 space-y-1">
                  <span className="text-[10px] font-bold text-slate-400 uppercase block">Sustainability Impact</span>
                  <strong className="text-slate-900 dark:text-white font-extrabold">{d.Sustainability_Impact}</strong>
                </div>
              </div>

              {/* Symptoms & Cause */}
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4 text-xs">
                <div className="bg-rose-50 dark:bg-rose-950/40 p-4 rounded-2xl border border-rose-200 dark:border-rose-900/60 space-y-1">
                  <span className="font-extrabold text-rose-700 dark:text-rose-400 uppercase tracking-wider block">
                    Clinical Symptoms
                  </span>
                  <p className="text-slate-800 dark:text-slate-200 font-medium leading-relaxed">
                    {d.Symptoms}
                  </p>
                </div>

                <div className="bg-slate-50 dark:bg-slate-800/60 p-4 rounded-2xl border border-slate-200 dark:border-slate-700 space-y-1">
                  <span className="font-extrabold text-slate-700 dark:text-slate-300 uppercase tracking-wider block">
                    Root Cause & Etiology
                  </span>
                  <p className="text-slate-600 dark:text-slate-400 font-medium leading-relaxed">
                    {d.Cause}
                  </p>
                </div>
              </div>

              {/* Treatment & Prevention Protocols */}
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4 text-xs">
                <div className="bg-emerald-50 dark:bg-emerald-950/40 p-4 rounded-2xl border border-emerald-200 dark:border-emerald-900/60 space-y-1">
                  <span className="font-extrabold text-emerald-800 dark:text-emerald-300 uppercase tracking-wider block flex items-center space-x-1">
                    <Stethoscope className="w-4 h-4 text-emerald-600" />
                    <span>Therapeutic Treatment Protocol</span>
                  </span>
                  <p className="text-slate-800 dark:text-slate-200 font-medium leading-relaxed">
                    {d.Treatment}
                  </p>
                </div>

                <div className="bg-teal-50 dark:bg-teal-950/40 p-4 rounded-2xl border border-teal-200 dark:border-teal-900/60 space-y-1">
                  <span className="font-extrabold text-teal-800 dark:text-teal-300 uppercase tracking-wider block flex items-center space-x-1">
                    <Shield className="w-4 h-4 text-teal-600" />
                    <span>Prevention & Biosecurity</span>
                  </span>
                  <p className="text-slate-800 dark:text-slate-200 font-medium leading-relaxed">
                    {d.Prevention}
                  </p>
                </div>
              </div>

              {/* Recommended Action Box */}
              <div className="bg-gradient-to-r from-emerald-950 to-slate-900 text-white p-4 rounded-2xl border border-amber-400/40 flex items-center justify-between gap-4 text-xs">
                <div className="space-y-0.5">
                  <span className="text-[10px] font-extrabold text-amber-300 uppercase tracking-wider block">
                    Recommended Clinical Action
                  </span>
                  <p className="text-slate-200 font-semibold">
                    {d.Recommended_Action}
                  </p>
                </div>
                <span className="text-[10px] bg-amber-400/20 text-amber-300 px-3 py-1 rounded-full border border-amber-400/40 font-mono shrink-0">
                  disease_master.csv
                </span>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
};
