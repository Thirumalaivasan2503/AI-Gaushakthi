import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { offlineSyncService } from '../../services/offlineSync';
import { ALL_INDIAN_STATES, getDistrictsForState } from '../../data/locationData';
import { Save, ArrowLeft, CheckCircle } from 'lucide-react';

export const AddEditLivestockPage: React.FC = () => {
  const navigate = useNavigate();
  const [tagNumber, setTagNumber] = useState('TN-CBT-' + Math.floor(100 + Math.random() * 900));
  const [name, setName] = useState('');
  const [species, setSpecies] = useState<'Cattle'>('Cattle');
  const [breed, setBreed] = useState('Kangayam');
  const [ageMonths, setAgeMonths] = useState(24);
  const [weightKg, setWeightKg] = useState(350);
  const [farmState, setFarmState] = useState('Tamil Nadu');
  const [farmDistrict, setFarmDistrict] = useState('Coimbatore');
  const [savedSuccess, setSavedSuccess] = useState(false);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    const payload = {
      tag_number: tagNumber,
      name,
      species,
      breed,
      age_months: ageMonths,
      weight_kg: weightKg,
    };

    // Queue in offline storage & sync
    offlineSyncService.enqueueTask('ADD_LIVESTOCK', payload);
    setSavedSuccess(true);

    setTimeout(() => {
      navigate('/farmer/livestock');
    }, 1200);
  };

  return (
    <div className="max-w-2xl mx-auto space-y-6">
      <div className="flex items-center space-x-3">
        <button onClick={() => navigate(-1)} className="p-2 rounded-xl bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 text-slate-600 dark:text-slate-300">
          <ArrowLeft className="w-4 h-4" />
        </button>
        <div>
          <h1 className="text-xl font-bold text-slate-900 dark:text-white">Register New Productive Cow</h1>
          <p className="text-xs text-slate-500 dark:text-slate-400">Generate ear-tag QR code, record milk yield & A2 quality parameters</p>
        </div>
      </div>

      {savedSuccess && (
        <div className="bg-emerald-100 text-emerald-800 dark:bg-emerald-950 dark:text-emerald-300 p-4 rounded-2xl border border-emerald-300 flex items-center space-x-2 text-xs font-semibold">
          <CheckCircle className="w-5 h-5 text-emerald-600" />
          <span>Cow registered in PasuMitra registry & queued for background sync!</span>
        </div>
      )}

      <form onSubmit={handleSubmit} className="bg-white dark:bg-slate-900 rounded-3xl p-6 border border-slate-200 dark:border-slate-800 shadow-xs space-y-4">
        <div>
          <label className="block text-xs font-semibold text-slate-700 dark:text-slate-300 mb-1">Ear Tag Number</label>
          <input
            type="text"
            value={tagNumber}
            onChange={(e) => setTagNumber(e.target.value)}
            required
            className="w-full bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 text-slate-900 dark:text-white text-xs rounded-xl px-3 py-2.5 font-mono focus:outline-none focus:ring-2 focus:ring-emerald-500"
          />
        </div>

        <div>
          <label className="block text-xs font-semibold text-slate-700 dark:text-slate-300 mb-1">Cow Given Name / ID</label>
          <input
            type="text"
            placeholder="e.g. Kangayam Cow #101"
            value={name}
            onChange={(e) => setName(e.target.value)}
            required
            className="w-full bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 text-slate-900 dark:text-white text-xs rounded-xl px-3 py-2.5 focus:outline-none focus:ring-2 focus:ring-emerald-500"
          />
        </div>

        <div className="grid grid-cols-2 gap-4">
          <div>
            <label className="block text-xs font-semibold text-slate-700 dark:text-slate-300 mb-1">Species</label>
            <select
              value={species}
              onChange={(e) => setSpecies(e.target.value as any)}
              className="w-full bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 text-slate-900 dark:text-white text-xs rounded-xl px-3 py-2.5 focus:outline-none"
            >
              <option value="Cattle">Indigenous Cow (Female)</option>
            </select>
          </div>

          <div>
            <label className="block text-xs font-semibold text-slate-700 dark:text-slate-300 mb-1">Indigenous Cow Breed</label>
            <select
              value={breed}
              onChange={(e) => setBreed(e.target.value)}
              className="w-full bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 text-slate-900 dark:text-white text-xs rounded-xl px-3 py-2.5 focus:outline-none"
            >
              <option value="Kangayam">Kangayam Cow (Kongu A2 Milch)</option>
              <option value="Gir">Gir Cow (High A2 Dairy)</option>
              <option value="Sahiwal">Sahiwal Cow (High Yield A2 Dairy)</option>
              <option value="Ongole">Ongole Cow (Dual Purpose A2)</option>
              <option value="Bargur">Bargur Cow (Hill Terrain A2)</option>
              <option value="Umblachery">Umblachery Cow (Delta Region A2)</option>
              <option value="Pulikulam">Pulikulam Cow (Madurai Region A2)</option>
              <option value="Hallikar">Hallikar Cow (A2 Dairy)</option>
              <option value="Vechur">Vechur Cow (Kerala Medicinal A2 Dwarf)</option>
              <option value="Tharparkar">Tharparkar Cow (Desert Pearl A2)</option>
              <option value="Rathi">Rathi Cow (Rajasthan Desert A2)</option>
              <option value="Red Sindhi">Red Sindhi Cow (Red A2 Milch)</option>
            </select>
          </div>
        </div>

        <div className="grid grid-cols-2 gap-4">
          <div>
            <label className="block text-xs font-semibold text-slate-700 dark:text-slate-300 mb-1">Age (Months)</label>
            <input
              type="number"
              value={ageMonths}
              onChange={(e) => setAgeMonths(Number(e.target.value))}
              className="w-full bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 text-slate-900 dark:text-white text-xs rounded-xl px-3 py-2.5 focus:outline-none"
            />
          </div>

          <div>
            <label className="block text-xs font-semibold text-slate-700 dark:text-slate-300 mb-1">Weight (kg)</label>
            <input
              type="number"
              value={weightKg}
              onChange={(e) => setWeightKg(Number(e.target.value))}
              className="w-full bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 text-slate-900 dark:text-white text-xs rounded-xl px-3 py-2.5 focus:outline-none"
            />
          </div>
        </div>

        <div className="grid grid-cols-2 gap-4">
          <div>
            <label className="block text-xs font-semibold text-slate-700 dark:text-slate-300 mb-1">Farm State</label>
            <select
              value={farmState}
              onChange={(e) => {
                setFarmState(e.target.value);
                const dists = getDistrictsForState(e.target.value);
                setFarmDistrict(dists[0] || '');
              }}
              className="w-full bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 text-slate-900 dark:text-white text-xs rounded-xl px-3 py-2.5 focus:outline-none font-semibold"
            >
              {ALL_INDIAN_STATES.map((st) => (
                <option key={st} value={st}>
                  {st}
                </option>
              ))}
            </select>
          </div>

          <div>
            <label className="block text-xs font-semibold text-slate-700 dark:text-slate-300 mb-1">Farm District</label>
            <select
              value={farmDistrict}
              onChange={(e) => setFarmDistrict(e.target.value)}
              className="w-full bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 text-slate-900 dark:text-white text-xs rounded-xl px-3 py-2.5 focus:outline-none font-semibold"
            >
              {getDistrictsForState(farmState).map((dist) => (
                <option key={dist} value={dist}>
                  {dist}
                </option>
              ))}
            </select>
          </div>
        </div>

        <button
          type="submit"
          className="w-full bg-emerald-600 hover:bg-emerald-500 text-white font-bold text-xs py-3 rounded-xl transition shadow-lg shadow-emerald-500/20 flex items-center justify-center space-x-2"
        >
          <Save className="w-4 h-4" />
          <span>Save Animal to Farm Inventory</span>
        </button>
      </form>
    </div>
  );
};
