import React, { useState } from 'react';
import { useAuth } from '../../context/AuthContext';
import { ALL_INDIAN_STATES, getDistrictsForState } from '../../data/locationData';
import { User as UserIcon, Phone, MapPin, CheckCircle2, Save } from 'lucide-react';

export const ProfilePage: React.FC = () => {
  const { user, setLanguage, language, t } = useAuth();
  
  const [selectedState, setSelectedState] = useState(user?.state || 'Tamil Nadu');
  const [selectedDistrict, setSelectedDistrict] = useState(user?.district || 'Coimbatore');
  const [farmerName, setFarmerName] = useState(user?.name || 'Thiru');
  const [saved, setSaved] = useState(false);

  const handleStateChange = (newState: string) => {
    setSelectedState(newState);
    const districts = getDistrictsForState(newState);
    setSelectedDistrict(districts[0] || '');
  };

  const handleSaveProfile = (e: React.FormEvent) => {
    e.preventDefault();
    if (user) {
      const updated = {
        ...user,
        name: farmerName,
        state: selectedState,
        district: selectedDistrict,
      };
      localStorage.setItem('gaushakthi_user', JSON.stringify(updated));
    }
    setSaved(true);
    setTimeout(() => setSaved(false), 2000);
  };

  return (
    <div className="max-w-2xl mx-auto space-y-6">
      <div className="bg-white dark:bg-slate-900 rounded-3xl p-6 sm:p-8 border border-slate-200 dark:border-slate-800 shadow-xl space-y-6">
        <div className="flex items-center space-x-4">
          <div className="w-16 h-16 rounded-full bg-gradient-to-tr from-emerald-600 to-teal-500 text-white flex items-center justify-center font-extrabold text-2xl border-4 border-emerald-100 dark:border-emerald-950 shadow-md">
            {farmerName ? farmerName.charAt(0) : 'U'}
          </div>
          <div>
            <h1 className="text-xl font-extrabold text-slate-900 dark:text-white">{farmerName}</h1>
            <span className="inline-block px-2.5 py-0.5 text-xs font-bold rounded-full bg-emerald-100 dark:bg-emerald-950 text-emerald-800 dark:text-emerald-300 capitalize mt-1">
              🌾 {t('farmerPortal')}
            </span>
          </div>
        </div>

        {saved && (
          <div className="p-3 bg-emerald-100 text-emerald-800 dark:bg-emerald-950 dark:text-emerald-300 rounded-xl text-xs font-bold flex items-center space-x-2 animate-in fade-in">
            <CheckCircle2 className="w-4 h-4 text-emerald-600" />
            <span>Farm profile & location preferences updated successfully!</span>
          </div>
        )}

        <form onSubmit={handleSaveProfile} className="space-y-4 border-t border-slate-100 dark:border-slate-800 pt-6 text-xs">
          <div>
            <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1">
              Farmer Full Name
            </label>
            <input
              type="text"
              value={farmerName}
              onChange={(e) => setFarmerName(e.target.value)}
              className="w-full bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 text-slate-900 dark:text-white text-xs rounded-xl px-3 py-2.5 font-semibold focus:outline-none focus:ring-2 focus:ring-emerald-500"
            />
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <div>
              <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1">
                State / Union Territory
              </label>
              <select
                value={selectedState}
                onChange={(e) => handleStateChange(e.target.value)}
                className="w-full bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 text-slate-900 dark:text-white text-xs rounded-xl px-3 py-2.5 font-semibold focus:outline-none focus:ring-2 focus:ring-emerald-500"
              >
                {ALL_INDIAN_STATES.map((st) => (
                  <option key={st} value={st}>
                    {st}
                  </option>
                ))}
              </select>
            </div>

            <div>
              <label className="block font-bold text-slate-700 dark:text-slate-300 mb-1">
                Agricultural District
              </label>
              <select
                value={selectedDistrict}
                onChange={(e) => setSelectedDistrict(e.target.value)}
                className="w-full bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 text-slate-900 dark:text-white text-xs rounded-xl px-3 py-2.5 font-semibold focus:outline-none focus:ring-2 focus:ring-emerald-500"
              >
                {getDistrictsForState(selectedState).map((dist) => (
                  <option key={dist} value={dist}>
                    {dist}
                  </option>
                ))}
              </select>
            </div>
          </div>

          <button
            type="submit"
            className="w-full py-3 rounded-xl bg-gradient-to-r from-emerald-600 to-teal-600 hover:from-emerald-500 hover:to-teal-500 text-white font-bold text-xs shadow-lg shadow-emerald-500/20 transition flex items-center justify-center space-x-2"
          >
            <Save className="w-4 h-4" />
            <span>Save Location Preferences</span>
          </button>
        </form>
      </div>
    </div>
  );
};
