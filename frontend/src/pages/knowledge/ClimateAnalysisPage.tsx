import React, { useState, useEffect } from 'react';
import { Sun, CloudRain, Droplets, Flame, AlertTriangle, ShieldCheck, MapPin, Sparkles, Award, ArrowUpRight } from 'lucide-react';
import { apiService } from '../../services/api';
import { ClimateMasterInfo } from '../../types';

export const ClimateAnalysisPage: React.FC = () => {
  const [climates, setClimates] = useState<ClimateMasterInfo[]>([]);
  const [selectedState, setSelectedState] = useState<string>('Tamil Nadu');
  const [selectedDistrict, setSelectedDistrict] = useState<string>('Erode');
  const [activeClimate, setActiveClimate] = useState<ClimateMasterInfo | null>(null);
  const [loading, setLoading] = useState<boolean>(true);

  useEffect(() => {
    fetchClimateData();
  }, []);

  const fetchClimateData = async () => {
    setLoading(true);
    try {
      const res = await apiService.getClimate();
      if (res && res.data) {
        setClimates(res.data);
        const match = res.data.find(
          (c: ClimateMasterInfo) => c.State.toLowerCase() === selectedState.toLowerCase() && c.District.toLowerCase() === selectedDistrict.toLowerCase()
        ) || res.data[0];
        setActiveClimate(match);
      }
    } catch (err) {
      console.error('Error fetching climate_master.csv:', err);
    } finally {
      setLoading(false);
    }
  };

  const handleLocationChange = async (state: string, district: string) => {
    setSelectedState(state);
    setSelectedDistrict(district);
    try {
      const res = await apiService.getClimateByStateAndDistrict(state, district);
      if (res && res.data) {
        setActiveClimate(res.data);
      }
    } catch (err) {
      console.error('Error fetching location climate:', err);
    }
  };

  return (
    <div className="space-y-6 max-w-5xl mx-auto font-sans">
      {/* Header Banner (Forest Green & Elegant Gold) */}
      <div className="bg-gradient-to-r from-emerald-950 via-slate-900 to-teal-950 rounded-3xl p-6 sm:p-8 text-white border-2 border-emerald-500/40 shadow-2xl space-y-4">
        <div className="flex items-center space-x-3">
          <div className="w-12 h-12 rounded-2xl bg-amber-400/20 text-amber-400 flex items-center justify-center shrink-0 border border-amber-400/40 shadow-lg">
            <Sun className="w-6 h-6 text-amber-400" />
          </div>
          <div>
            <span className="text-[10px] font-extrabold text-amber-300 uppercase tracking-wider block">
              Climate Knowledge Base (climate_master.csv)
            </span>
            <h1 className="text-2xl sm:text-3xl font-black text-white">
              Agri-Climate & Regional Adaptation Analysis
            </h1>
          </div>
        </div>
        <p className="text-xs text-emerald-200 leading-relaxed max-w-3xl">
          Automated district-level temperature thresholds, heat indices, rainfall patterns, water availability, and drought risk indexes cached directly from <code className="text-amber-300 font-mono">climate_master.csv</code>.
        </p>

        {/* Location Selectors */}
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 pt-2">
          <div>
            <label className="block text-[11px] font-bold text-amber-300 uppercase mb-1">State Location</label>
            <select
              value={selectedState}
              onChange={(e) => handleLocationChange(e.target.value, selectedDistrict)}
              className="w-full bg-white/10 text-xs px-3.5 py-2.5 rounded-xl border border-emerald-500/40 text-white font-semibold focus:outline-none focus:ring-2 focus:ring-amber-400"
            >
              <option value="Tamil Nadu" className="bg-slate-900 text-white">Tamil Nadu</option>
              <option value="Kerala" className="bg-slate-900 text-white">Kerala</option>
              <option value="Karnataka" className="bg-slate-900 text-white">Karnataka</option>
              <option value="Andhra Pradesh" className="bg-slate-900 text-white">Andhra Pradesh</option>
            </select>
          </div>

          <div>
            <label className="block text-[11px] font-bold text-amber-300 uppercase mb-1">District Location</label>
            <select
              value={selectedDistrict}
              onChange={(e) => handleLocationChange(selectedState, e.target.value)}
              className="w-full bg-white/10 text-xs px-3.5 py-2.5 rounded-xl border border-emerald-500/40 text-white font-semibold focus:outline-none focus:ring-2 focus:ring-amber-400"
            >
              <option value="Erode" className="bg-slate-900 text-white">Erode</option>
              <option value="Coimbatore" className="bg-slate-900 text-white">Coimbatore</option>
              <option value="Salem" className="bg-slate-900 text-white">Salem</option>
              <option value="Madurai" className="bg-slate-900 text-white">Madurai</option>
              <option value="Tiruppur" className="bg-slate-900 text-white">Tiruppur</option>
            </select>
          </div>
        </div>
      </div>

      {loading || !activeClimate ? (
        <div className="text-center py-12 text-xs text-slate-500">Loading climate analysis data...</div>
      ) : (
        <div className="space-y-6">
          {/* Main Active Climate Card (Forest Green & Elegant Gold) */}
          <div className="relative overflow-hidden bg-gradient-to-br from-emerald-950 via-slate-900 to-teal-950 rounded-3xl p-6 sm:p-8 text-white border-2 border-amber-400/40 shadow-2xl space-y-6">
            <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 border-b border-emerald-800/80 pb-4">
              <div className="flex items-center space-x-3">
                <div className="w-12 h-12 rounded-2xl bg-amber-400/20 text-amber-400 flex items-center justify-center shrink-0 border border-amber-400/40 shadow-lg">
                  <MapPin className="w-6 h-6 text-amber-400" />
                </div>
                <div>
                  <span className="text-[10px] font-extrabold text-amber-300 uppercase tracking-wider block">
                    District Climate Profile: {activeClimate.District}, {activeClimate.State}
                  </span>
                  <h2 className="text-2xl sm:text-3xl font-black text-white">
                    Climate Zone: {activeClimate.Climate_Type}
                  </h2>
                </div>
              </div>

              <div className="bg-amber-400/20 border border-amber-400/40 p-3 rounded-2xl text-center shadow-xl">
                <span className="text-[10px] font-bold text-amber-300 uppercase block">Sustainability Index</span>
                <span className="text-2xl font-black text-amber-400">{activeClimate.Sustainability_Score} / 100</span>
              </div>
            </div>

            {/* 11 Climate Parameters Grid */}
            <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 gap-3 text-xs">
              <div className="backdrop-blur-md bg-white/10 p-3.5 rounded-2xl border border-white/10">
                <span className="text-[10px] font-bold text-emerald-300 uppercase block flex items-center space-x-1">
                  <Flame className="w-3.5 h-3.5 text-amber-400" />
                  <span>Avg Temperature</span>
                </span>
                <strong className="text-white text-base font-extrabold block mt-0.5">{activeClimate.Avg_Temperature_C}°C</strong>
              </div>

              <div className="backdrop-blur-md bg-white/10 p-3.5 rounded-2xl border border-white/10">
                <span className="text-[10px] font-bold text-emerald-300 uppercase block flex items-center space-x-1">
                  <Droplets className="w-3.5 h-3.5 text-cyan-400" />
                  <span>Avg Humidity</span>
                </span>
                <strong className="text-cyan-300 text-base font-extrabold block mt-0.5">{activeClimate.Avg_Humidity_Percent}%</strong>
              </div>

              <div className="backdrop-blur-md bg-white/10 p-3.5 rounded-2xl border border-white/10">
                <span className="text-[10px] font-bold text-emerald-300 uppercase block flex items-center space-x-1">
                  <CloudRain className="w-3.5 h-3.5 text-blue-400" />
                  <span>Annual Rainfall</span>
                </span>
                <strong className="text-white text-base font-extrabold block mt-0.5">{activeClimate.Annual_Rainfall_mm} mm</strong>
              </div>

              <div className="backdrop-blur-md bg-white/10 p-3.5 rounded-2xl border border-white/10">
                <span className="text-[10px] font-bold text-amber-300 uppercase block">Heat Index</span>
                <strong className="text-amber-400 text-base font-extrabold block mt-0.5">{activeClimate.Heat_Index}</strong>
              </div>

              <div className="backdrop-blur-md bg-white/10 p-3.5 rounded-2xl border border-white/10">
                <span className="text-[10px] font-bold text-emerald-300 uppercase block">Water Availability</span>
                <strong className="text-white text-xs font-bold block mt-0.5">{activeClimate.Water_Availability}</strong>
              </div>

              <div className="backdrop-blur-md bg-white/10 p-3.5 rounded-2xl border border-white/10">
                <span className="text-[10px] font-bold text-amber-300 uppercase block">Drought Risk</span>
                <strong className="text-amber-300 text-xs font-bold block mt-0.5">{activeClimate.Drought_Risk}</strong>
              </div>

              <div className="backdrop-blur-md bg-white/10 p-3.5 rounded-2xl border border-white/10">
                <span className="text-[10px] font-bold text-emerald-300 uppercase block">Flood Risk</span>
                <strong className="text-white text-xs font-bold block mt-0.5">{activeClimate.Flood_Risk}</strong>
              </div>

              <div className="backdrop-blur-md bg-white/10 p-3.5 rounded-2xl border border-white/10">
                <span className="text-[10px] font-bold text-amber-300 uppercase block">Recommended Farming</span>
                <strong className="text-amber-400 text-xs font-extrabold block mt-0.5">
                  {activeClimate.Recommended_Farming || activeClimate.Recommended_Farming_Type}
                </strong>
              </div>
            </div>

            {/* Suitable Breeds Banner */}
            <div className="bg-emerald-900/50 p-4 rounded-2xl border border-emerald-500/40 text-xs space-y-2">
              <span className="text-[10px] font-extrabold text-amber-300 uppercase tracking-wider block">
                Climate-Compatible Indigenous & Exotic Breeds
              </span>
              <p className="text-white font-bold text-sm">
                {activeClimate.Suitable_Breeds}
              </p>
            </div>
          </div>

          {/* All Regional Climate Catalog Grid */}
          <div className="bg-white dark:bg-slate-900 rounded-3xl p-6 border border-slate-200 dark:border-slate-800 shadow-xl space-y-4">
            <h3 className="font-extrabold text-base text-slate-900 dark:text-white flex items-center space-x-2">
              <Sparkles className="w-5 h-5 text-emerald-600" />
              <span>All District Climate Records in Knowledge Base ({climates.length})</span>
            </h3>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-3 text-xs">
              {climates.map((c, i) => (
                <div
                  key={c.Climate_ID || `clim-${i}`}
                  onClick={() => setActiveClimate(c)}
                  className={`p-4 rounded-2xl border cursor-pointer transition ${
                    activeClimate.Climate_ID === c.Climate_ID
                      ? 'bg-emerald-950 text-white border-amber-400 shadow-lg'
                      : 'bg-slate-50 dark:bg-slate-800/60 text-slate-800 dark:text-slate-200 border-slate-200 dark:border-slate-700 hover:border-emerald-500'
                  }`}
                >
                  <div className="flex items-center justify-between font-bold">
                    <span>{c.District}, {c.State}</span>
                    <span className="text-[10px] bg-amber-400/20 text-amber-400 px-2 py-0.5 rounded-full">
                      {c.Climate_Type}
                    </span>
                  </div>
                  <p className="text-[11px] mt-1 text-slate-500 dark:text-slate-400">
                    Temp: {c.Avg_Temperature_C}°C • Humidity: {c.Avg_Humidity_Percent}% • Rainfall: {c.Annual_Rainfall_mm}mm
                  </p>
                </div>
              ))}
            </div>
          </div>
        </div>
      )}
    </div>
  );
};
