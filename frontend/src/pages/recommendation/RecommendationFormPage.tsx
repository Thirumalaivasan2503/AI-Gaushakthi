import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { RecommendationParams } from '../../types';
import { apiService } from '../../services/api';
import { useAuth } from '../../context/AuthContext';
import { ALL_INDIAN_STATES, getDistrictsForState } from '../../data/locationData';
import { Sparkles, MapPin, Sun, DollarSign, ArrowRight, Loader2 } from 'lucide-react';

export const RecommendationFormPage: React.FC = () => {
  const navigate = useNavigate();
  const { t } = useAuth();
  const [loading, setLoading] = useState(false);

  const [formData, setFormData] = useState<RecommendationParams>({
    district: 'Coimbatore',
    state: 'Tamil Nadu',
    annual_rainfall_mm: 720,
    max_temperature_c: 38.5,
    min_temperature_c: 21.0,
    altitude_m: 411,
    humidity_percent: 65,
    land_holding_acres: 3.5,
    primary_purpose: 'Draft',
    budget_inr: 75000,
    experience_years: 6,
    available_fodder_kg_per_day: 45,
    water_availability: 'Medium',
    housing_type: 'Free Range',
    market_distance_km: 12,
    veterinary_access: 'Good',
    target_species: 'Cattle',
  });

  const handleStateChange = (newState: string) => {
    const districts = getDistrictsForState(newState);
    const newDistrict = districts[0] || 'Coimbatore';
    setFormData({ ...formData, state: newState, district: newDistrict });
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);

    try {
      const result = await apiService.getRecommendation(formData);
      navigate('/prediction-details', { state: { result } });
    } catch (err) {
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="max-w-4xl mx-auto space-y-6">
      {/* Header */}
      <div className="bg-gradient-to-r from-emerald-800 to-teal-900 text-white p-6 sm:p-8 rounded-3xl shadow-xl space-y-2 relative overflow-hidden">
        <div className="flex items-center space-x-2">
          <span className="px-3 py-1 bg-emerald-700/80 rounded-full text-xs font-bold text-emerald-200 uppercase tracking-wider">
            LightGBM v2.1 Engine
          </span>
          <span className="text-xs text-emerald-300 font-mono">79.33% Accuracy</span>
        </div>
        <h1 className="text-2xl sm:text-3xl font-extrabold">{t('recommenderTitle')}</h1>
        <p className="text-xs sm:text-sm text-emerald-100/90 leading-relaxed">
          {t('recommenderSubtitle')}
        </p>
      </div>

      <form onSubmit={handleSubmit} className="space-y-6">
        {/* Section 1: Location & Target Species */}
        <div className="bg-white dark:bg-slate-900 p-6 rounded-3xl border border-slate-200 dark:border-slate-800 shadow-xs space-y-4">
          <div className="flex items-center space-x-2 text-emerald-600 dark:text-emerald-400">
            <MapPin className="w-5 h-5" />
            <h2 className="font-bold text-sm text-slate-900 dark:text-white">{t('secLocation')}</h2>
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
            <div>
              <label className="block text-xs font-semibold text-slate-700 dark:text-slate-300 mb-1">{t('targetSpecies')}</label>
              <select
                value={formData.target_species}
                onChange={(e) => setFormData({ ...formData, target_species: e.target.value as any })}
                className="w-full bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 text-slate-900 dark:text-white text-xs rounded-xl px-3 py-2.5 focus:outline-none"
              >
                <option value="Cattle">{t('cattle')}</option>
              </select>
            </div>

            <div>
              <label className="block text-xs font-semibold text-slate-700 dark:text-slate-300 mb-1">{t('state')}</label>
              <select
                value={formData.state}
                onChange={(e) => handleStateChange(e.target.value)}
                className="w-full bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 text-slate-900 dark:text-white text-xs rounded-xl px-3 py-2.5 focus:outline-none focus:ring-2 focus:ring-emerald-500 font-semibold"
              >
                {ALL_INDIAN_STATES.map((st) => (
                  <option key={st} value={st}>
                    {st}
                  </option>
                ))}
              </select>
            </div>

            <div>
              <label className="block text-xs font-semibold text-slate-700 dark:text-slate-300 mb-1">{t('district')}</label>
              <select
                value={formData.district}
                onChange={(e) => setFormData({ ...formData, district: e.target.value })}
                className="w-full bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 text-slate-900 dark:text-white text-xs rounded-xl px-3 py-2.5 focus:outline-none focus:ring-2 focus:ring-emerald-500 font-semibold"
              >
                {getDistrictsForState(formData.state).map((dist) => (
                  <option key={dist} value={dist}>
                    {dist}
                  </option>
                ))}
              </select>
            </div>
          </div>
        </div>

        {/* Section 2: Agro-Climate & THI Parameters */}
        <div className="bg-white dark:bg-slate-900 p-6 rounded-3xl border border-slate-200 dark:border-slate-800 shadow-xs space-y-4">
          <div className="flex items-center space-x-2 text-emerald-600 dark:text-emerald-400">
            <Sun className="w-5 h-5" />
            <h2 className="font-bold text-sm text-slate-900 dark:text-white">{t('secClimate')}</h2>
          </div>

          <div className="grid grid-cols-2 sm:grid-cols-4 gap-4">
            <div>
              <label className="block text-xs font-semibold text-slate-700 dark:text-slate-300 mb-1">{t('annualRainfall')}</label>
              <input
                type="number"
                value={formData.annual_rainfall_mm}
                onChange={(e) => setFormData({ ...formData, annual_rainfall_mm: Number(e.target.value) })}
                className="w-full bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 text-slate-900 dark:text-white text-xs rounded-xl px-3 py-2.5 focus:outline-none"
              />
            </div>

            <div>
              <label className="block text-xs font-semibold text-slate-700 dark:text-slate-300 mb-1">{t('maxTemp')}</label>
              <input
                type="number"
                value={formData.max_temperature_c}
                onChange={(e) => setFormData({ ...formData, max_temperature_c: Number(e.target.value) })}
                className="w-full bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 text-slate-900 dark:text-white text-xs rounded-xl px-3 py-2.5 focus:outline-none"
              />
            </div>

            <div>
              <label className="block text-xs font-semibold text-slate-700 dark:text-slate-300 mb-1">{t('humidity')}</label>
              <input
                type="number"
                value={formData.humidity_percent}
                onChange={(e) => setFormData({ ...formData, humidity_percent: Number(e.target.value) })}
                className="w-full bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 text-slate-900 dark:text-white text-xs rounded-xl px-3 py-2.5 focus:outline-none"
              />
            </div>

            <div>
              <label className="block text-xs font-semibold text-slate-700 dark:text-slate-300 mb-1">{t('altitude')}</label>
              <input
                type="number"
                value={formData.altitude_m}
                onChange={(e) => setFormData({ ...formData, altitude_m: Number(e.target.value) })}
                className="w-full bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 text-slate-900 dark:text-white text-xs rounded-xl px-3 py-2.5 focus:outline-none"
              />
            </div>
          </div>
        </div>

        {/* Section 3: Farm Capabilities & Purpose */}
        <div className="bg-white dark:bg-slate-900 p-6 rounded-3xl border border-slate-200 dark:border-slate-800 shadow-xs space-y-4">
          <div className="flex items-center space-x-2 text-emerald-600 dark:text-emerald-400">
            <DollarSign className="w-5 h-5" />
            <h2 className="font-bold text-sm text-slate-900 dark:text-white">{t('secEconomics')}</h2>
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
            <div>
              <label className="block text-xs font-semibold text-slate-700 dark:text-slate-300 mb-1">{t('primaryPurpose')}</label>
              <select
                value={formData.primary_purpose}
                onChange={(e) => setFormData({ ...formData, primary_purpose: e.target.value as any })}
                className="w-full bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 text-slate-900 dark:text-white text-xs rounded-xl px-3 py-2.5 focus:outline-none"
              >
                <option value="Draft">{t('purposeDraft')}</option>
                <option value="Dairy">{t('purposeDairy')}</option>
                <option value="Dual">{t('purposeDual')}</option>
                <option value="Meat">{t('purposeMeat')}</option>
              </select>
            </div>

            <div>
              <label className="block text-xs font-semibold text-slate-700 dark:text-slate-300 mb-1">{t('budget')}</label>
              <input
                type="number"
                value={formData.budget_inr}
                onChange={(e) => setFormData({ ...formData, budget_inr: Number(e.target.value) })}
                className="w-full bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 text-slate-900 dark:text-white text-xs rounded-xl px-3 py-2.5 focus:outline-none"
              />
            </div>

            <div>
              <label className="block text-xs font-semibold text-slate-700 dark:text-slate-300 mb-1">{t('landHolding')}</label>
              <input
                type="number"
                value={formData.land_holding_acres}
                onChange={(e) => setFormData({ ...formData, land_holding_acres: Number(e.target.value) })}
                className="w-full bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 text-slate-900 dark:text-white text-xs rounded-xl px-3 py-2.5 focus:outline-none"
              />
            </div>
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
            <div>
              <label className="block text-xs font-semibold text-slate-700 dark:text-slate-300 mb-1">{t('waterResource')}</label>
              <select
                value={formData.water_availability}
                onChange={(e) => setFormData({ ...formData, water_availability: e.target.value as any })}
                className="w-full bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 text-slate-900 dark:text-white text-xs rounded-xl px-3 py-2.5 focus:outline-none"
              >
                <option value="High">{t('waterHigh')}</option>
                <option value="Medium">{t('waterMedium')}</option>
                <option value="Low">{t('waterLow')}</option>
              </select>
            </div>

            <div>
              <label className="block text-xs font-semibold text-slate-700 dark:text-slate-300 mb-1">{t('dailyFodder')}</label>
              <input
                type="number"
                value={formData.available_fodder_kg_per_day}
                onChange={(e) => setFormData({ ...formData, available_fodder_kg_per_day: Number(e.target.value) })}
                className="w-full bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 text-slate-900 dark:text-white text-xs rounded-xl px-3 py-2.5 focus:outline-none"
              />
            </div>

            <div>
              <label className="block text-xs font-semibold text-slate-700 dark:text-slate-300 mb-1">{t('housingType')}</label>
              <select
                value={formData.housing_type}
                onChange={(e) => setFormData({ ...formData, housing_type: e.target.value as any })}
                className="w-full bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 text-slate-900 dark:text-white text-xs rounded-xl px-3 py-2.5 focus:outline-none"
              >
                <option value="Free Range">{t('housingFree')}</option>
                <option value="Semi-Intensive">{t('housingSemi')}</option>
                <option value="Intensive">{t('housingStall')}</option>
              </select>
            </div>
          </div>
        </div>

        {/* Submit Button */}
        <button
          type="submit"
          disabled={loading}
          className="w-full py-4 rounded-2xl bg-gradient-to-r from-emerald-600 to-teal-600 hover:from-emerald-500 hover:to-teal-500 text-white font-extrabold text-sm shadow-xl shadow-emerald-500/20 transition flex items-center justify-center space-x-2 disabled:opacity-50"
        >
          {loading ? (
            <>
              <Loader2 className="w-5 h-5 animate-spin" />
              <span>{t('processing')}</span>
            </>
          ) : (
            <>
              <Sparkles className="w-5 h-5" />
              <span>{t('executeBtn')}</span>
              <ArrowRight className="w-5 h-5" />
            </>
          )}
        </button>
      </form>
    </div>
  );
};
