import React, { useState } from 'react';
import { useParams, Link, useNavigate } from 'react-router-dom';
import { QRCodeSVG } from 'qrcode.react';
import { 
  ArrowLeft, 
  QrCode, 
  ShieldCheck, 
  Award, 
  Syringe, 
  Droplets, 
  Activity, 
  HeartPulse, 
  Calendar, 
  Scale, 
  MapPin, 
  DollarSign, 
  Info, 
  CheckCircle2, 
  AlertTriangle, 
  Download, 
  Camera, 
  Utensils, 
  Sparkles,
  Zap,
  Tag
} from 'lucide-react';

interface CowProfile {
  id: string;
  tag_number: string;
  unique_id: string;
  rfid_chip_id: string;
  insurance_policy_id: string;
  name: string;
  species: string;
  breed: string;
  origin_state: string;
  age_months: number;
  gender: string;
  weight_kg: number;
  health_status: 'Healthy' | 'Needs Attention' | 'In Treatment';
  image_url: string;
  // Quantity metrics
  daily_milk_yield_liters: number;
  peak_milk_yield_liters: number;
  total_lactation_yield_liters: number;
  lactation_stage: string;
  calving_count: number;
  last_calving_date: string;
  // Quality metrics
  milk_type: string;
  fat_percentage: number;
  protein_percentage: number;
  snf_percentage: number;
  somatic_cell_count: string;
  quality_grade: string;
  // Medical & Feed metrics
  disease_history: string;
  vaccination_status: string;
  last_vet_checkup: string;
  veterinarian_name: string;
  daily_feed_cost_inr: number;
  monthly_maintenance_inr: number;
  asset_value_inr: number;
  morning_feed: string;
  evening_feed: string;
  vaccinations: Array<{
    name: string;
    date: string;
    status: string;
    next_due: string;
  }>;
}

const mockCowProfiles: Record<string, CowProfile> = {
  '1': {
    id: '1',
    tag_number: 'TN-CBT-101',
    unique_id: 'INAPH-IND-994821',
    rfid_chip_id: 'RFID-982-10029381',
    insurance_policy_id: 'UIIC-LIVESTOCK-44021',
    name: 'Kangayam Cow #101',
    species: 'Cattle',
    breed: 'Kangayam',
    origin_state: 'Tamil Nadu',
    age_months: 36,
    gender: 'Female',
    weight_kg: 380,
    health_status: 'Healthy',
    image_url: '/images/kangayam_cow.png',
    daily_milk_yield_liters: 8.5,
    peak_milk_yield_liters: 10.5,
    total_lactation_yield_liters: 1950,
    lactation_stage: 'Mid Lactation (Month 4)',
    calving_count: 2,
    last_calving_date: '2026-02-14',
    milk_type: 'Pure A2 Beta-Casein',
    fat_percentage: 4.6,
    protein_percentage: 3.5,
    snf_percentage: 8.8,
    somatic_cell_count: '< 160,000 cells/mL',
    quality_grade: 'A2 Grade Superior',
    disease_history: 'None (High Immunity)',
    vaccination_status: 'Up to Date',
    last_vet_checkup: '2026-07-20',
    veterinarian_name: 'Dr. R. Arumugam, B.V.Sc',
    daily_feed_cost_inr: 125,
    monthly_maintenance_inr: 3750,
    asset_value_inr: 85000,
    morning_feed: '7 kg Green CO-4 Napier + 1.2 kg Cottonseed Cake',
    evening_feed: '6 kg Dry Paddy Straw + 800g Wheat Bran',
    vaccinations: [
      { name: 'FMD Polyvalent Vaccine', date: '2026-05-10', status: 'Completed', next_due: '2026-11-10' },
      { name: 'Black Quarter (BQ) Vaccine', date: '2026-04-15', status: 'Completed', next_due: '2027-04-15' },
      { name: 'Anthrax Spore Vaccine', date: '2026-02-01', status: 'Completed', next_due: '2027-02-01' },
    ],
  },
  '2': {
    id: '2',
    tag_number: 'TN-CBT-102',
    unique_id: 'INAPH-IND-994822',
    rfid_chip_id: 'RFID-982-10029382',
    insurance_policy_id: 'UIIC-LIVESTOCK-44022',
    name: 'Umblachery Cow #102',
    species: 'Cattle',
    breed: 'Umblachery',
    origin_state: 'Tamil Nadu',
    age_months: 28,
    gender: 'Female',
    weight_kg: 320,
    health_status: 'Needs Attention',
    image_url: '/images/kangayam_cow.png',
    daily_milk_yield_liters: 6.5,
    peak_milk_yield_liters: 8.0,
    total_lactation_yield_liters: 1450,
    lactation_stage: 'Mid Lactation (Month 4)',
    calving_count: 1,
    last_calving_date: '2026-03-12',
    milk_type: 'Pure A2 Beta-Casein',
    fat_percentage: 4.9,
    protein_percentage: 3.5,
    snf_percentage: 8.8,
    somatic_cell_count: '< 180,000 cells/mL',
    quality_grade: 'A2 Grade Superior',
    disease_history: 'Mild Mastitis (Under Treatment)',
    vaccination_status: 'Booster Pending',
    last_vet_checkup: '2026-08-01',
    veterinarian_name: 'Dr. K. Senthil, M.V.Sc',
    daily_feed_cost_inr: 110,
    monthly_maintenance_inr: 3300,
    asset_value_inr: 75000,
    morning_feed: '6 kg Hybrid Napier + 1.0 kg Groundnut Cake',
    evening_feed: '5 kg Dry Paddy Straw + 500g Mineral Mixture',
    vaccinations: [
      { name: 'FMD Polyvalent Vaccine', date: '2026-01-15', status: 'Completed', next_due: '2026-07-15' },
      { name: 'Brucellosis Strain 19', date: '2025-09-10', status: 'Completed', next_due: 'Lifetime' },
      { name: 'Haemorrhagic Septicaemia (HS)', date: '2026-05-20', status: 'Completed', next_due: '2027-05-20' },
    ],
  },
  '3': {
    id: '3',
    tag_number: 'TN-CBT-103',
    unique_id: 'INAPH-IND-994823',
    rfid_chip_id: 'RFID-982-10029383',
    insurance_policy_id: 'UIIC-LIVESTOCK-44023',
    name: 'Gir Cow #103',
    species: 'Cattle',
    breed: 'Gir',
    origin_state: 'Gujarat / Tamil Nadu Acclimatized',
    age_months: 32,
    gender: 'Female',
    weight_kg: 420,
    health_status: 'Healthy',
    image_url: '/images/gir_cow.png',
    daily_milk_yield_liters: 12.0,
    peak_milk_yield_liters: 14.5,
    total_lactation_yield_liters: 2850,
    lactation_stage: 'Peak Lactation (Month 3)',
    calving_count: 2,
    last_calving_date: '2026-04-10',
    milk_type: 'Certified A2 Premium Organic',
    fat_percentage: 4.8,
    protein_percentage: 3.6,
    snf_percentage: 8.9,
    somatic_cell_count: '< 140,000 cells/mL',
    quality_grade: 'A2 Gold Certified',
    disease_history: 'None (High Natural Immunity)',
    vaccination_status: 'Up to Date',
    last_vet_checkup: '2026-07-28',
    veterinarian_name: 'Dr. M. Lakshmi, B.V.Sc',
    daily_feed_cost_inr: 135,
    monthly_maintenance_inr: 4050,
    asset_value_inr: 110000,
    morning_feed: '10 kg Green Sorghum + 2.0 kg Cottonseed Cake',
    evening_feed: '8 kg Dry Paddy Straw + 1.2 kg Maize Crush',
    vaccinations: [
      { name: 'FMD Polyvalent Vaccine', date: '2026-06-01', status: 'Completed', next_due: '2026-12-01' },
      { name: 'Black Quarter (BQ) Vaccine', date: '2026-03-10', status: 'Completed', next_due: '2027-03-10' },
      { name: 'Anthrax Spore Vaccine', date: '2026-01-20', status: 'Completed', next_due: '2027-01-20' },
    ],
  },
};

export const CowProfilePage: React.FC = () => {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const [showQRModal, setShowQRModal] = useState(false);
  const [isScanning, setIsScanning] = useState(false);
  const [scanResult, setScanResult] = useState<string | null>(null);

  const profile: CowProfile = (id && mockCowProfiles[id]) ? mockCowProfiles[id] : mockCowProfiles['3'];

  const handleSimulateScan = () => {
    setIsScanning(true);
    setTimeout(() => {
      setIsScanning(false);
      setScanResult(`Scanned RFID Ear Tag: ${profile.tag_number} | Unique INAPH ID: ${profile.unique_id} | Breed: ${profile.breed}`);
    }, 1500);
  };

  return (
    <div className="space-y-6 max-w-5xl mx-auto font-sans">
      {/* Top Back Navigation */}
      <div className="flex items-center justify-between">
        <button
          onClick={() => navigate('/farmer/livestock')}
          className="flex items-center space-x-2 text-xs font-semibold text-slate-600 dark:text-slate-300 hover:text-emerald-600 transition"
        >
          <ArrowLeft className="w-4 h-4" />
          <span>Back to Livestock Inventory</span>
        </button>

        <div className="flex items-center space-x-2">
          <button
            onClick={() => setShowQRModal(true)}
            className="flex items-center space-x-1.5 px-3.5 py-2 rounded-xl bg-amber-400/20 text-amber-300 border border-amber-400/40 hover:bg-amber-400/30 text-xs font-bold transition shadow-md"
          >
            <QrCode className="w-4 h-4 text-amber-400" />
            <span>Scan & View Official QR</span>
          </button>
        </div>
      </div>

      {/* Main Hero Cow Profile Banner (Forest Green & Elegant Gold Theme) */}
      <div className="relative overflow-hidden bg-gradient-to-r from-emerald-950 via-slate-900 to-teal-950 rounded-3xl p-6 sm:p-8 text-white border-2 border-emerald-500/40 shadow-2xl space-y-6">
        <div className="flex flex-col md:flex-row items-start md:items-center justify-between gap-6 border-b border-emerald-800/80 pb-6">
          <div className="flex items-start space-x-4">
            <div className="relative group shrink-0">
              <img
                src={profile.image_url}
                alt={profile.name}
                className="w-24 h-24 sm:w-28 sm:h-28 rounded-2xl object-cover border-2 border-amber-400 shadow-xl"
              />
              <span className="absolute -bottom-2 -right-2 bg-amber-400 text-slate-950 text-[10px] font-black px-2 py-0.5 rounded-full uppercase tracking-wider border border-amber-300 shadow">
                Pure A2
              </span>
            </div>

            <div>
              <div className="flex flex-wrap items-center gap-2">
                <span className="px-3 py-1 bg-amber-400/20 text-amber-300 border border-amber-400/40 text-[11px] font-mono font-black rounded-full uppercase tracking-wider flex items-center space-x-1">
                  <Tag className="w-3 h-3 text-amber-400" />
                  <span>Ear Tag: {profile.tag_number}</span>
                </span>
                <span
                  className={`text-[11px] font-extrabold px-3 py-1 rounded-full border ${
                    profile.health_status === 'Healthy'
                      ? 'bg-emerald-900/80 text-emerald-300 border-emerald-500/40'
                      : 'bg-amber-900/80 text-amber-300 border-amber-500/40'
                  }`}
                >
                  Status: {profile.health_status}
                </span>
              </div>

              <h1 className="text-2xl sm:text-3xl font-black text-white mt-2">
                {profile.name}
              </h1>

              <p className="text-xs sm:text-sm text-emerald-200 mt-1 flex flex-wrap items-center gap-2 font-medium">
                <MapPin className="w-3.5 h-3.5 text-amber-400" />
                <span>Breed: <strong>{profile.breed} ({profile.species})</strong></span>
                <span>•</span>
                <span>Origin: <strong>{profile.origin_state}</strong></span>
              </p>
            </div>
          </div>

          {/* Quick Identifier Cards */}
          <div className="bg-white/10 dark:bg-slate-900/50 p-4 rounded-2xl border border-amber-400/30 text-xs space-y-1.5 backdrop-blur-md shrink-0">
            <div className="flex items-center justify-between space-x-4">
              <span className="text-[10px] text-emerald-300 font-bold uppercase">INAPH Reg ID</span>
              <strong className="text-amber-300 font-mono font-extrabold">{profile.unique_id}</strong>
            </div>
            <div className="flex items-center justify-between space-x-4">
              <span className="text-[10px] text-emerald-300 font-bold uppercase">RFID Microchip</span>
              <strong className="text-white font-mono font-bold">{profile.rfid_chip_id}</strong>
            </div>
            <div className="flex items-center justify-between space-x-4">
              <span className="text-[10px] text-emerald-300 font-bold uppercase">Insurance Policy</span>
              <strong className="text-emerald-300 font-mono">{profile.insurance_policy_id}</strong>
            </div>
          </div>
        </div>

        {/* 4 Major Feature Highlight KPI Cards */}
        <div className="grid grid-cols-2 sm:grid-cols-4 gap-3 text-xs">
          <div className="backdrop-blur-md bg-white/10 p-3.5 rounded-2xl border border-white/10">
            <span className="text-[10px] font-bold text-amber-300 uppercase block">Daily Milk Quantity</span>
            <strong className="text-white text-base font-black block mt-0.5">{profile.daily_milk_yield_liters} L / Day</strong>
            <span className="text-[10px] text-emerald-200">Peak: {profile.peak_milk_yield_liters} L / Day</span>
          </div>

          <div className="backdrop-blur-md bg-white/10 p-3.5 rounded-2xl border border-white/10">
            <span className="text-[10px] font-bold text-emerald-300 uppercase block">Milk Quality Grade</span>
            <strong className="text-amber-400 text-sm font-extrabold block mt-0.5">{profile.quality_grade}</strong>
            <span className="text-[10px] text-emerald-200">Fat: {profile.fat_percentage}% • SNF: {profile.snf_percentage}%</span>
          </div>

          <div className="backdrop-blur-md bg-white/10 p-3.5 rounded-2xl border border-white/10">
            <span className="text-[10px] font-bold text-emerald-300 uppercase block">Age & Body Weight</span>
            <strong className="text-white text-base font-extrabold block mt-0.5">{profile.age_months} Months</strong>
            <span className="text-[10px] text-emerald-200">Weight: {profile.weight_kg} kg ({profile.gender})</span>
          </div>

          <div className="backdrop-blur-md bg-white/10 p-3.5 rounded-2xl border border-white/10">
            <span className="text-[10px] font-bold text-amber-300 uppercase block">Estimated Asset Value</span>
            <strong className="text-amber-300 text-base font-black block mt-0.5">₹{profile.asset_value_inr.toLocaleString('en-IN')}</strong>
            <span className="text-[10px] text-emerald-200">Maint: ₹{profile.daily_feed_cost_inr}/Day</span>
          </div>
        </div>
      </div>

      {/* Main Grid: Quantity & Quality Detailed Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        {/* 1. QUANTITY & LACTATION PROFILE CARD */}
        <div className="bg-white dark:bg-slate-900 rounded-3xl p-6 border border-slate-200 dark:border-slate-800 shadow-xl space-y-4">
          <div className="flex items-center space-x-2 border-b border-slate-200 dark:border-slate-800 pb-3">
            <div className="w-9 h-9 rounded-xl bg-emerald-100 dark:bg-emerald-950 text-emerald-600 dark:text-emerald-400 flex items-center justify-center">
              <Droplets className="w-5 h-5" />
            </div>
            <div>
              <h3 className="font-extrabold text-sm text-slate-900 dark:text-white">Production Quantity & Lactation Metrics</h3>
              <p className="text-[11px] text-slate-500">Yield tracking & calving history</p>
            </div>
          </div>

          <div className="grid grid-cols-2 gap-3 text-xs">
            <div className="bg-slate-50 dark:bg-slate-800/60 p-3.5 rounded-2xl border border-slate-200 dark:border-slate-700">
              <span className="text-[10px] font-bold text-slate-400 uppercase block">Current Daily Milk Yield</span>
              <strong className="text-emerald-600 dark:text-emerald-400 text-base font-black block mt-0.5">{profile.daily_milk_yield_liters} Liters / Day</strong>
            </div>

            <div className="bg-slate-50 dark:bg-slate-800/60 p-3.5 rounded-2xl border border-slate-200 dark:border-slate-700">
              <span className="text-[10px] font-bold text-slate-400 uppercase block">Peak Yield Capacity</span>
              <strong className="text-amber-500 text-base font-black block mt-0.5">{profile.peak_milk_yield_liters} Liters / Day</strong>
            </div>

            <div className="bg-slate-50 dark:bg-slate-800/60 p-3.5 rounded-2xl border border-slate-200 dark:border-slate-700">
              <span className="text-[10px] font-bold text-slate-400 uppercase block">Lactation Stage</span>
              <strong className="text-slate-900 dark:text-white font-extrabold block mt-0.5">{profile.lactation_stage}</strong>
            </div>

            <div className="bg-slate-50 dark:bg-slate-800/60 p-3.5 rounded-2xl border border-slate-200 dark:border-slate-700">
              <span className="text-[10px] font-bold text-slate-400 uppercase block">Total Cycle Yield</span>
              <strong className="text-slate-900 dark:text-white font-extrabold block mt-0.5">{profile.total_lactation_yield_liters} Liters</strong>
            </div>

            <div className="bg-slate-50 dark:bg-slate-800/60 p-3.5 rounded-2xl border border-slate-200 dark:border-slate-700">
              <span className="text-[10px] font-bold text-slate-400 uppercase block">Calving Count</span>
              <strong className="text-slate-900 dark:text-white font-extrabold block mt-0.5">{profile.calving_count} Calvings</strong>
            </div>

            <div className="bg-slate-50 dark:bg-slate-800/60 p-3.5 rounded-2xl border border-slate-200 dark:border-slate-700">
              <span className="text-[10px] font-bold text-slate-400 uppercase block">Last Calving Date</span>
              <strong className="text-slate-900 dark:text-white font-extrabold block mt-0.5">{profile.last_calving_date}</strong>
            </div>
          </div>
        </div>

        {/* 2. QUALITY & A2 CERTIFICATION CARD */}
        <div className="bg-white dark:bg-slate-900 rounded-3xl p-6 border border-slate-200 dark:border-slate-800 shadow-xl space-y-4">
          <div className="flex items-center space-x-2 border-b border-slate-200 dark:border-slate-800 pb-3">
            <div className="w-9 h-9 rounded-xl bg-amber-100 dark:bg-amber-950 text-amber-600 dark:text-amber-400 flex items-center justify-center">
              <Award className="w-5 h-5" />
            </div>
            <div>
              <h3 className="font-extrabold text-sm text-slate-900 dark:text-white">Milk Quality & Composition Analysis</h3>
              <p className="text-[11px] text-slate-500">Fat, Protein, SNF & A2 Beta-Casein testing</p>
            </div>
          </div>

          <div className="bg-gradient-to-r from-amber-400/20 to-emerald-500/10 p-4 rounded-2xl border border-amber-400/40 text-xs space-y-2">
            <div className="flex items-center justify-between">
              <span className="text-[11px] font-black text-amber-600 dark:text-amber-300 uppercase tracking-wider flex items-center space-x-1">
                <CheckCircle2 className="w-4 h-4 text-emerald-600" />
                <span>{profile.milk_type}</span>
              </span>
              <span className="text-[10px] bg-emerald-600 text-white font-bold px-2.5 py-0.5 rounded-full">Grade A+</span>
            </div>
            <p className="text-slate-700 dark:text-slate-300 text-[11px] leading-relaxed">
              Certified pure A2 Beta-Casein protein structure with high digestability and premium market price realization.
            </p>
          </div>

          <div className="grid grid-cols-2 gap-3 text-xs">
            <div className="bg-slate-50 dark:bg-slate-800/60 p-3.5 rounded-2xl border border-slate-200 dark:border-slate-700">
              <span className="text-[10px] font-bold text-slate-400 uppercase block">Milk Fat Percentage</span>
              <strong className="text-amber-500 text-base font-black block mt-0.5">{profile.fat_percentage}%</strong>
            </div>

            <div className="bg-slate-50 dark:bg-slate-800/60 p-3.5 rounded-2xl border border-slate-200 dark:border-slate-700">
              <span className="text-[10px] font-bold text-slate-400 uppercase block">Protein Percentage</span>
              <strong className="text-emerald-600 dark:text-emerald-400 text-base font-black block mt-0.5">{profile.protein_percentage}%</strong>
            </div>

            <div className="bg-slate-50 dark:bg-slate-800/60 p-3.5 rounded-2xl border border-slate-200 dark:border-slate-700">
              <span className="text-[10px] font-bold text-slate-400 uppercase block">SNF (Solids-Not-Fat)</span>
              <strong className="text-slate-900 dark:text-white font-extrabold block mt-0.5">{profile.snf_percentage}%</strong>
            </div>

            <div className="bg-slate-50 dark:bg-slate-800/60 p-3.5 rounded-2xl border border-slate-200 dark:border-slate-700">
              <span className="text-[10px] font-bold text-slate-400 uppercase block">Somatic Cell Count</span>
              <strong className="text-slate-900 dark:text-white font-extrabold block mt-0.5">{profile.somatic_cell_count}</strong>
            </div>
          </div>
        </div>
      </div>

      {/* 3. MEDICAL & VACCINATION PROTOCOL TABLE CARD */}
      <div className="bg-white dark:bg-slate-900 rounded-3xl p-6 border border-slate-200 dark:border-slate-800 shadow-xl space-y-4">
        <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-2 border-b border-slate-200 dark:border-slate-800 pb-3">
          <div className="flex items-center space-x-2">
            <div className="w-9 h-9 rounded-xl bg-emerald-100 dark:bg-emerald-950 text-emerald-600 dark:text-emerald-400 flex items-center justify-center">
              <Syringe className="w-5 h-5" />
            </div>
            <div>
              <h3 className="font-extrabold text-sm text-slate-900 dark:text-white">Medical & Immunization Protocol</h3>
              <p className="text-[11px] text-slate-500">Vaccination status & veterinary inspection records</p>
            </div>
          </div>

          <div className="text-xs text-slate-600 dark:text-slate-300 font-semibold bg-slate-100 dark:bg-slate-800 px-3 py-1.5 rounded-xl border border-slate-200 dark:border-slate-700">
            Attending Vet: <strong>{profile.veterinarian_name}</strong> (Last Visit: {profile.last_vet_checkup})
          </div>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-3 text-xs mb-4">
          <div className="bg-slate-50 dark:bg-slate-800/60 p-3 rounded-2xl border border-slate-200 dark:border-slate-700">
            <span className="text-[10px] font-bold text-slate-400 uppercase block">Disease History</span>
            <strong className="text-slate-900 dark:text-white font-extrabold mt-0.5 block">{profile.disease_history}</strong>
          </div>

          <div className="bg-slate-50 dark:bg-slate-800/60 p-3 rounded-2xl border border-slate-200 dark:border-slate-700">
            <span className="text-[10px] font-bold text-slate-400 uppercase block">Vaccination Status</span>
            <strong className="text-emerald-600 dark:text-emerald-400 font-extrabold mt-0.5 block">{profile.vaccination_status}</strong>
          </div>

          <div className="bg-slate-50 dark:bg-slate-800/60 p-3 rounded-2xl border border-slate-200 dark:border-slate-700">
            <span className="text-[10px] font-bold text-slate-400 uppercase block">Natural Disease Resistance</span>
            <strong className="text-amber-500 font-extrabold mt-0.5 block">High Tick & FMD Resistance</strong>
          </div>
        </div>

        <div className="overflow-x-auto">
          <table className="w-full text-xs text-left">
            <thead>
              <tr className="bg-slate-100 dark:bg-slate-800 text-slate-700 dark:text-slate-300 font-bold">
                <th className="p-3 rounded-l-xl">Vaccine Name</th>
                <th className="p-3">Administered Date</th>
                <th className="p-3">Status</th>
                <th className="p-3 rounded-r-xl">Next Booster Due</th>
              </tr>
            </thead>
            <tbody>
              {profile.vaccinations.map((vac, idx) => (
                <tr key={idx} className="border-b border-slate-100 dark:border-slate-800">
                  <td className="p-3 font-bold text-slate-900 dark:text-white">{vac.name}</td>
                  <td className="p-3 text-slate-600 dark:text-slate-400">{vac.date}</td>
                  <td className="p-3">
                    <span className="bg-emerald-100 dark:bg-emerald-950 text-emerald-800 dark:text-emerald-300 font-bold px-2.5 py-0.5 rounded-full text-[10px]">
                      {vac.status}
                    </span>
                  </td>
                  <td className="p-3 font-semibold text-amber-600 dark:text-amber-400">{vac.next_due}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>

      {/* 4. NUTRITIONAL RATION & FEED SCHEDULE CARD */}
      <div className="bg-white dark:bg-slate-900 rounded-3xl p-6 border border-slate-200 dark:border-slate-800 shadow-xl space-y-4">
        <div className="flex items-center space-x-2 border-b border-slate-200 dark:border-slate-800 pb-3">
          <div className="w-9 h-9 rounded-xl bg-amber-100 dark:bg-amber-950 text-amber-600 dark:text-amber-400 flex items-center justify-center">
            <Utensils className="w-5 h-5" />
          </div>
          <div>
            <h3 className="font-extrabold text-sm text-slate-900 dark:text-white">Nutritional Feed Schedule & Daily Costs</h3>
            <p className="text-[11px] text-slate-500">Precision feed allocation & monthly maintenance</p>
          </div>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-4 text-xs">
          <div className="bg-slate-50 dark:bg-slate-800/60 p-4 rounded-2xl border border-slate-200 dark:border-slate-700 space-y-1">
            <span className="text-[10px] font-bold text-amber-600 dark:text-amber-400 uppercase tracking-wider block">Morning Feed Ration (6:00 AM)</span>
            <p className="text-slate-900 dark:text-white font-semibold">{profile.morning_feed}</p>
          </div>

          <div className="bg-slate-50 dark:bg-slate-800/60 p-4 rounded-2xl border border-slate-200 dark:border-slate-700 space-y-1">
            <span className="text-[10px] font-bold text-emerald-600 dark:text-emerald-400 uppercase tracking-wider block">Evening Feed Ration (5:30 PM)</span>
            <p className="text-slate-900 dark:text-white font-semibold">{profile.evening_feed}</p>
          </div>
        </div>
      </div>

      {/* OFFICIAL QR CODE MODAL */}
      {showQRModal && (
        <div className="fixed inset-0 z-50 bg-slate-950/80 backdrop-blur-sm flex items-center justify-center p-4">
          <div className="bg-slate-900 text-white rounded-3xl p-6 max-w-sm w-full border-2 border-amber-400 shadow-2xl space-y-4 text-center">
            <div className="flex items-center justify-between border-b border-slate-800 pb-3">
              <h3 className="font-extrabold text-sm text-amber-400">Official PasuMitra Ear Tag QR</h3>
              <button onClick={() => setShowQRModal(false)} className="text-slate-400 hover:text-white font-bold">✕</button>
            </div>

            <div className="bg-white p-4 rounded-2xl inline-block shadow-inner">
              <QRCodeSVG value={`https://pasumitra.agri.gov/animal/${profile.tag_number}`} size={180} />
            </div>

            <div>
              <strong className="text-base font-black block text-white">{profile.name}</strong>
              <span className="text-xs text-amber-300 font-mono block">Ear Tag: {profile.tag_number}</span>
              <span className="text-[10px] text-slate-400 block">INAPH ID: {profile.unique_id}</span>
            </div>

            <div className="space-y-2 pt-2">
              <button
                onClick={handleSimulateScan}
                disabled={isScanning}
                className="w-full py-2.5 bg-gradient-to-r from-emerald-600 to-teal-700 text-white font-bold text-xs rounded-xl shadow-md hover:from-emerald-500 hover:to-teal-600 transition"
              >
                {isScanning ? 'Scanning Ear Tag Microchip...' : 'Simulate Ear Tag QR Scan'}
              </button>

              {scanResult && (
                <div className="p-3 bg-emerald-950 border border-emerald-500/40 rounded-xl text-[11px] text-emerald-200 text-left space-y-1">
                  <span className="font-bold text-amber-400 block">✓ Scan Successful</span>
                  <p>{scanResult}</p>
                </div>
              )}
            </div>
          </div>
        </div>
      )}
    </div>
  );
};
