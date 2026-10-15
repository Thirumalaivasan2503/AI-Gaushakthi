import React, { useState } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import { useAuth } from '../../context/AuthContext';
import { GauShakthiLogo } from '../../components/common/GauShakthiLogo';
import { ALL_INDIAN_STATES, getDistrictsForState } from '../../data/locationData';
import { User, Phone, MapPin, ArrowRight } from 'lucide-react';

export const RegisterPage: React.FC = () => {
  const [name, setName] = useState('');
  const [phone, setPhone] = useState('+91 ');
  const [selectedState, setSelectedState] = useState('Tamil Nadu');
  const [selectedDistrict, setSelectedDistrict] = useState('Coimbatore');
  const { login } = useAuth();
  const navigate = useNavigate();

  const handleStateChange = (newState: string) => {
    setSelectedState(newState);
    const districts = getDistrictsForState(newState);
    setSelectedDistrict(districts[0] || '');
  };

  const handleRegister = (e: React.FormEvent) => {
    e.preventDefault();
    login(phone);
    navigate('/home');
  };

  return (
    <div className="min-h-screen bg-slate-950 text-white flex items-center justify-center px-4 py-12">
      <div className="max-w-md w-full bg-slate-900 border border-slate-800 rounded-3xl p-8 shadow-2xl space-y-6">
        <div className="text-center space-y-2 flex flex-col items-center">
          <GauShakthiLogo size="lg" showText={true} />
          <p className="text-xs text-slate-400">Join the GauShakthi Agronomic AI Ecosystem</p>
        </div>

        <form onSubmit={handleRegister} className="space-y-4">
          <div>
            <label className="block text-xs font-semibold text-slate-300 mb-1">Full Name</label>
            <div className="relative">
              <User className="w-4 h-4 text-slate-500 absolute left-3 top-3" />
              <input
                type="text"
                placeholder="Thiru"
                value={name}
                onChange={(e) => setName(e.target.value)}
                required
                className="w-full bg-slate-800 border border-slate-700 text-white text-xs rounded-xl pl-9 pr-3 py-2.5 focus:ring-2 focus:ring-emerald-500 focus:outline-none font-semibold"
              />
            </div>
          </div>

          <div>
            <label className="block text-xs font-semibold text-slate-300 mb-1">Mobile Number</label>
            <div className="relative">
              <Phone className="w-4 h-4 text-slate-500 absolute left-3 top-3" />
              <input
                type="text"
                value={phone}
                onChange={(e) => setPhone(e.target.value)}
                required
                className="w-full bg-slate-800 border border-slate-700 text-white text-xs rounded-xl pl-9 pr-3 py-2.5 focus:ring-2 focus:ring-emerald-500 focus:outline-none font-semibold"
              />
            </div>
          </div>

          <div className="space-y-3">
            <div>
              <label className="block text-xs font-semibold text-slate-300 mb-1">State / Union Territory</label>
              <select
                value={selectedState}
                onChange={(e) => handleStateChange(e.target.value)}
                required
                className="w-full bg-slate-800 border border-slate-700 text-white text-xs rounded-xl px-3 py-2.5 focus:ring-2 focus:ring-emerald-500 focus:outline-none font-semibold"
              >
                {ALL_INDIAN_STATES.map((st) => (
                  <option key={st} value={st}>
                    {st}
                  </option>
                ))}
              </select>
            </div>

            <div>
              <label className="block text-xs font-semibold text-slate-300 mb-1">Agricultural District</label>
              <select
                value={selectedDistrict}
                onChange={(e) => setSelectedDistrict(e.target.value)}
                required
                className="w-full bg-slate-800 border border-slate-700 text-white text-xs rounded-xl px-3 py-2.5 focus:ring-2 focus:ring-emerald-500 focus:outline-none font-semibold"
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
            className="w-full bg-gradient-to-r from-emerald-600 to-teal-600 hover:from-emerald-500 hover:to-teal-500 text-white font-bold text-xs py-3 rounded-xl transition shadow-lg shadow-emerald-500/20 flex items-center justify-center space-x-2"
          >
            <span>Create Profile & Continue</span>
            <ArrowRight className="w-4 h-4" />
          </button>
        </form>

        <div className="text-center text-xs text-slate-400 border-t border-slate-800 pt-4">
          Already registered?{' '}
          <Link to="/auth/login" className="text-emerald-400 font-semibold hover:underline">
            Sign In Here
          </Link>
        </div>
      </div>
    </div>
  );
};
