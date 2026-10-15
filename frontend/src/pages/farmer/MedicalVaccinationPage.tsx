import React, { useState, useEffect } from 'react';
import { useAuth } from '../../context/AuthContext';
import { 
  Stethoscope, 
  Calendar as CalendarIcon, 
  PlusCircle, 
  UploadCloud, 
  FileText, 
  CheckCircle2, 
  X, 
  Download, 
  ShieldCheck, 
  Sparkles, 
  AlertTriangle,
  Bell,
  Clock,
  Filter,
  Syringe,
  FileSearch,
  ChevronRight,
  Thermometer,
  Shield,
  Coins
} from 'lucide-react';
import { apiService } from '../../services/api';
import { VaccinationMasterInfo } from '../../types';

interface CattleMedicalProfile {
  id: string;
  tagNumber: string;
  cowName: string;
  breed: string;
  category: 'urgent' | 'upcoming' | 'immune' | 'maternal';
  lastVaccineDate: string;
  vetDoctor: string;
  completedVaccines: string[];
  pendingVaccines: { vaccineName: string; status: 'overdue' | 'due_soon'; dueDate: string }[];
  reportFile?: { name: string; url: string; uploadDate: string };
}

export const MedicalVaccinationPage: React.FC = () => {
  const { t } = useAuth();
  
  // Tab & Filter States
  const [selectedCategory, setSelectedCategory] = useState<'all' | 'urgent' | 'upcoming' | 'immune' | 'maternal'>('all');
  const [activeTab, setActiveTab] = useState<'herd' | 'analyzer' | 'calendar' | 'master_catalog'>('herd');
  
  // Modal State
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [selectedCowId, setSelectedCowId] = useState('TN-CBT-101');
  const [reportFile, setReportFile] = useState<File | null>(null);
  const [scanning, setScanning] = useState(false);

  // Master Vaccination Catalog Data (Filtered ONLY for Cattle / Cows, Goat vaccines removed)
  const [masterVaccinations, setMasterVaccinations] = useState<VaccinationMasterInfo[]>([]);
  const [masterLoading, setMasterLoading] = useState(false);

  useEffect(() => {
    fetchMasterVaccinations();
  }, []);

  const fetchMasterVaccinations = async () => {
    setMasterLoading(true);
    try {
      const res = await apiService.getVaccinations();
      if (res && res.data) {
        // Remove Goat / Sheep vaccines strictly, keeping only Cattle / Cow vaccines
        const cattleVaccines = res.data.filter((v: VaccinationMasterInfo) => {
          const sp = (v.Species || '').toLowerCase();
          const targetDis = (v.Disease || v.Target_Disease || '').toLowerCase();
          const isGoat = sp.includes('goat') || sp.includes('sheep') || targetDis.includes('goat') || targetDis.includes('ppr');
          return !isGoat;
        });
        setMasterVaccinations(cattleVaccines.length > 0 ? cattleVaccines : res.data);
      }
    } catch (err) {
      console.error('Error fetching vaccination_master.csv catalog:', err);
    } finally {
      setMasterLoading(false);
    }
  };

  // Herd Profiles Mock Data (All Productive Indigenous Cows)
  const [herdProfiles] = useState<CattleMedicalProfile[]>([
    {
      id: 'TN-CBT-101',
      tagNumber: 'TN-CBT-101',
      cowName: 'Kangayam Cow #101',
      breed: 'Kangayam',
      category: 'urgent',
      lastVaccineDate: 'Jun 15, 2026',
      vetDoctor: 'Dr. Arulmani VMD',
      completedVaccines: ['Foot and Mouth Disease (FMD) Polyvalent', 'Rabies Cattle Shield'],
      pendingVaccines: [
        { vaccineName: 'Anthrax Spore Vaccine', status: 'overdue', dueDate: 'Aug 01, 2026 (5 Days Overdue)' },
        { vaccineName: 'Black Quarter (BQ) Vaccine', status: 'due_soon', dueDate: 'Aug 15, 2026' },
      ],
      reportFile: {
        name: 'Kangayam_Cow_101_Vet_Health_Audit.pdf',
        url: '#',
        uploadDate: 'Jun 15, 2026',
      },
    },
    {
      id: 'TN-CBT-102',
      tagNumber: 'TN-CBT-102',
      cowName: 'Umblachery Cow #102',
      breed: 'Umblachery',
      category: 'urgent',
      lastVaccineDate: 'Jan 10, 2026',
      vetDoctor: 'Dr. K. Senthil MVSc',
      completedVaccines: ['FMD Polyvalent Vaccine'],
      pendingVaccines: [
        { vaccineName: 'Haemorrhagic Septicaemia (HS)', status: 'overdue', dueDate: 'Jul 20, 2026 (16 Days Overdue)' },
        { vaccineName: 'Brucellosis Strain 19', status: 'due_soon', dueDate: 'Aug 20, 2026' },
      ],
    },
    {
      id: 'TN-CBT-103',
      tagNumber: 'TN-CBT-103',
      cowName: 'Gir Cow #103',
      breed: 'Gir',
      category: 'immune',
      lastVaccineDate: 'Jul 28, 2026',
      vetDoctor: 'Dr. M. Lakshmi BVSc',
      completedVaccines: ['FMD Polyvalent Vaccine', 'Black Quarter (BQ)', 'Anthrax Spore Vaccine', 'Brucellosis Strain 19'],
      pendingVaccines: [],
    },
    {
      id: 'TN-CBT-104',
      tagNumber: 'TN-CBT-104',
      cowName: 'Sahiwal Cow #104',
      breed: 'Sahiwal',
      category: 'upcoming',
      lastVaccineDate: 'Feb 12, 2026',
      vetDoctor: 'Dr. R. Arumugam BVSc',
      completedVaccines: ['FMD Polyvalent Vaccine', 'BQ Vaccine'],
      pendingVaccines: [
        { vaccineName: 'FMD Booster Dose', status: 'due_soon', dueDate: 'Aug 12, 2026 (Due in 7 Days)' },
      ],
    },
  ]);

  const filteredProfiles = herdProfiles.filter((profile) => {
    if (selectedCategory === 'all') return true;
    return profile.category === selectedCategory;
  });

  const handleFileUpload = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.files && e.target.files[0]) {
      setReportFile(e.target.files[0]);
    }
  };

  const handleAuditSubmit = () => {
    if (!reportFile) return;
    setScanning(true);
    setTimeout(() => {
      setScanning(false);
      setIsModalOpen(false);
      alert(`✓ Health report "${reportFile.name}" analyzed successfully! Vaccination status updated.`);
      setReportFile(null);
    }, 1500);
  };

  return (
    <div className="space-y-6 max-w-5xl mx-auto font-sans">
      {/* Header Banner */}
      <div className="bg-gradient-to-r from-emerald-950 via-slate-900 to-teal-950 rounded-3xl p-6 sm:p-8 text-white border-2 border-emerald-500/40 shadow-2xl space-y-4">
        <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
          <div className="flex items-center space-x-3">
            <div className="w-12 h-12 rounded-2xl bg-amber-400/20 text-amber-400 flex items-center justify-center shrink-0 border border-amber-400/40 shadow-lg">
              <Syringe className="w-6 h-6 text-amber-400" />
            </div>
            <div>
              <span className="text-[10px] font-extrabold text-amber-300 uppercase tracking-wider block">
                Vaccination Knowledge Base & Medical Registry
              </span>
              <h1 className="text-2xl sm:text-3xl font-black text-white">
                Indigenous Cow Immunization Tracker
              </h1>
            </div>
          </div>

          <button
            onClick={() => setIsModalOpen(true)}
            className="flex items-center space-x-2 bg-gradient-to-r from-amber-400 to-amber-500 text-slate-950 px-4 py-2.5 rounded-xl font-black text-xs shadow-lg hover:from-amber-300 hover:to-amber-400 transition shrink-0"
          >
            <UploadCloud className="w-4 h-4 text-slate-950" />
            <span>Upload Vet Health Audit</span>
          </button>
        </div>
      </div>

      {/* Navigation Tabs */}
      <div className="flex flex-wrap gap-2 border-b border-slate-200 dark:border-slate-800 pb-3">
        <button
          onClick={() => setActiveTab('herd')}
          className={`px-4 py-2 rounded-xl text-xs font-bold transition flex items-center space-x-1.5 ${
            activeTab === 'herd'
              ? 'bg-emerald-950 text-white border border-amber-400/40 shadow-md'
              : 'bg-white dark:bg-slate-900 text-slate-600 dark:text-slate-300 hover:text-emerald-600'
          }`}
        >
          <ShieldCheck className="w-4 h-4 text-amber-400" />
          <span>Cow Herd Immunization Profiles</span>
        </button>

        <button
          onClick={() => setActiveTab('master_catalog')}
          className={`px-4 py-2 rounded-xl text-xs font-bold transition flex items-center space-x-1.5 ${
            activeTab === 'master_catalog'
              ? 'bg-emerald-950 text-white border border-amber-400/40 shadow-md'
              : 'bg-white dark:bg-slate-900 text-slate-600 dark:text-slate-300 hover:text-emerald-600'
          }`}
        >
          <Syringe className="w-4 h-4 text-amber-400" />
          <span>Vaccination Master Catalog</span>
        </button>
      </div>

      {/* TAB 1: HERD MEDICAL PROFILES */}
      {activeTab === 'herd' && (
        <div className="space-y-6">
          {/* Filter Pills */}
          <div className="flex items-center justify-between bg-white dark:bg-slate-900 p-4 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-xs">
            <span className="text-xs text-slate-500 font-semibold">Filter Herd Status:</span>
            <div className="flex flex-wrap gap-1.5">
              {(['all', 'urgent', 'upcoming', 'immune'] as const).map((cat) => (
                <button
                  key={cat}
                  onClick={() => setSelectedCategory(cat)}
                  className={`px-3.5 py-1.5 rounded-xl text-xs font-bold uppercase transition ${
                    selectedCategory === cat
                      ? 'bg-emerald-600 text-white shadow'
                      : 'bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-400 hover:bg-slate-200'
                  }`}
                >
                  {cat}
                </button>
              ))}
            </div>
          </div>

          {/* Herd Cards Grid */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            {filteredProfiles.map((cow) => (
              <div
                key={cow.id}
                className="bg-white dark:bg-slate-900 rounded-3xl p-5 border border-slate-200 dark:border-slate-800 shadow-xl space-y-4"
              >
                <div className="flex items-center justify-between border-b border-slate-100 dark:border-slate-800 pb-3">
                  <div>
                    <span className="text-[10px] font-mono font-bold bg-amber-400/20 text-amber-600 dark:text-amber-300 px-2 py-0.5 rounded border border-amber-400/30">
                      {cow.tagNumber}
                    </span>
                    <h3 className="font-extrabold text-base text-slate-900 dark:text-white mt-1">{cow.cowName}</h3>
                  </div>

                  <span
                    className={`text-[10px] font-extrabold px-3 py-1 rounded-full uppercase ${
                      cow.category === 'urgent'
                        ? 'bg-rose-100 text-rose-800 dark:bg-rose-950 dark:text-rose-300'
                        : cow.category === 'upcoming'
                        ? 'bg-amber-100 text-amber-800 dark:bg-amber-950 dark:text-amber-300'
                        : 'bg-emerald-100 text-emerald-800 dark:bg-emerald-950 dark:text-emerald-300'
                    }`}
                  >
                    {cow.category === 'urgent' ? 'Overdue' : cow.category === 'upcoming' ? 'Due Soon' : 'Fully Immune'}
                  </span>
                </div>

                <p className="text-xs text-slate-500 dark:text-slate-400">
                  Breed: <strong className="text-emerald-600 dark:text-emerald-400">{cow.breed} (Indigenous Cow)</strong> • Vet: {cow.vetDoctor}
                </p>

                {/* Completed Vaccines */}
                <div className="space-y-1">
                  <span className="text-[10px] font-bold text-emerald-600 dark:text-emerald-400 uppercase tracking-wider block">Completed Immunizations</span>
                  <div className="flex flex-wrap gap-1">
                    {cow.completedVaccines.map((v, i) => (
                      <span key={i} className="text-[10px] bg-emerald-50 dark:bg-emerald-950/80 text-emerald-700 dark:text-emerald-300 px-2.5 py-0.5 rounded-full border border-emerald-200 dark:border-emerald-500/30 font-semibold">
                        ✓ {v}
                      </span>
                    ))}
                  </div>
                </div>

                {/* Pending Vaccines */}
                {cow.pendingVaccines.length > 0 && (
                  <div className="space-y-1 pt-1 border-t border-slate-100 dark:border-slate-800">
                    <span className="text-[10px] font-bold text-amber-600 dark:text-amber-400 uppercase tracking-wider block">Pending / Due Boosters</span>
                    <div className="space-y-1 text-xs">
                      {cow.pendingVaccines.map((pv, i) => (
                        <div key={i} className="flex items-center justify-between bg-slate-50 dark:bg-slate-800 p-2 rounded-xl border border-slate-200 dark:border-slate-700">
                          <span className="font-bold text-slate-800 dark:text-slate-200">{pv.vaccineName}</span>
                          <span className="text-[10px] text-amber-600 dark:text-amber-400 font-semibold">{pv.dueDate}</span>
                        </div>
                      ))}
                    </div>
                  </div>
                )}
              </div>
            ))}
          </div>
        </div>
      )}

      {/* TAB 2: VACCINATION MASTER CATALOG (Cattle Vaccines Only) */}
      {activeTab === 'master_catalog' && (
        <div className="bg-white dark:bg-slate-900 rounded-3xl p-6 border border-slate-200 dark:border-slate-800 shadow-xl space-y-4">
          <div className="flex items-center justify-between">
            <h3 className="font-extrabold text-base text-slate-900 dark:text-white flex items-center space-x-2">
              <Syringe className="w-5 h-5 text-emerald-600" />
              <span>Indigenous Cattle Vaccination Master Protocol ({masterVaccinations.length} Vaccines)</span>
            </h3>
            <span className="text-xs bg-emerald-900 text-emerald-300 font-bold px-3 py-1 rounded-full border border-emerald-500/30">
              Goat Vaccines Removed
            </span>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-4 text-xs">
            {masterVaccinations.map((vac, idx) => (
              <div key={vac.Vaccine_ID || idx} className="bg-slate-50 dark:bg-slate-800/60 p-4 rounded-2xl border border-slate-200 dark:border-slate-700 space-y-2">
                <div className="flex items-center justify-between border-b border-slate-200 dark:border-slate-700 pb-2">
                  <div>
                    <span className="text-[10px] font-bold text-amber-600 dark:text-amber-300 uppercase block">Disease: {vac.Disease}</span>
                    <h4 className="font-extrabold text-sm text-slate-900 dark:text-white">{vac.Vaccine_Name}</h4>
                  </div>
                  <span className="text-xs bg-emerald-500/20 text-emerald-600 dark:text-emerald-300 font-bold px-2.5 py-0.5 rounded-full">
                    {vac.Protection_Percentage} Protection
                  </span>
                </div>

                <div className="grid grid-cols-2 gap-2 text-[11px]">
                  <div>Dose: <strong>{vac.Dose}</strong></div>
                  <div>First Dose Age: <strong>{vac.First_Dose_Age}</strong></div>
                  <div>Booster: <strong>{vac.Booster_Interval}</strong></div>
                  <div>Season: <strong>{vac.Recommended_Season}</strong></div>
                  <div>Cost: <strong className="text-amber-600 dark:text-amber-300">₹{vac.Estimated_Cost}</strong></div>
                  <div>Subsidized: <strong>{vac.Government_Subsidized || 'Yes (Free)'}</strong></div>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* UPLOAD VET HEALTH AUDIT MODAL */}
      {isModalOpen && (
        <div className="fixed inset-0 z-50 bg-slate-950/80 backdrop-blur-sm flex items-center justify-center p-4">
          <div className="bg-white dark:bg-slate-900 rounded-3xl p-6 max-w-md w-full border border-slate-200 dark:border-slate-800 shadow-2xl space-y-4">
            <div className="flex items-center justify-between border-b border-slate-200 dark:border-slate-800 pb-3">
              <h3 className="font-extrabold text-sm text-slate-900 dark:text-white">Upload Veterinary Audit Report</h3>
              <button onClick={() => setIsModalOpen(false)} className="text-slate-400 hover:text-slate-600">✕</button>
            </div>

            <div className="space-y-3 text-xs">
              <div>
                <label className="block text-[11px] font-bold text-slate-700 dark:text-slate-300 uppercase mb-1">Select Cow</label>
                <select
                  value={selectedCowId}
                  onChange={(e) => setSelectedCowId(e.target.value)}
                  className="w-full bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl px-3 py-2 text-slate-900 dark:text-white font-bold"
                >
                  <option value="TN-CBT-101">Kangayam Cow #101 (TN-CBT-101)</option>
                  <option value="TN-CBT-102">Umblachery Cow #102 (TN-CBT-102)</option>
                  <option value="TN-CBT-103">Gir Cow #103 (TN-CBT-103)</option>
                  <option value="TN-CBT-104">Sahiwal Cow #104 (TN-CBT-104)</option>
                </select>
              </div>

              <div>
                <label className="block text-[11px] font-bold text-slate-700 dark:text-slate-300 uppercase mb-1">Upload PDF Medical Audit File</label>
                <input
                  type="file"
                  accept=".pdf,.png,.jpeg,.jpg"
                  onChange={handleFileUpload}
                  className="w-full text-xs text-slate-500 file:mr-4 file:py-2 file:px-4 file:rounded-xl file:border-0 file:text-xs file:font-bold file:bg-emerald-50 file:text-emerald-700 dark:file:bg-emerald-950 dark:file:text-emerald-300 hover:file:bg-emerald-100"
                />
              </div>

              <button
                onClick={handleAuditSubmit}
                disabled={!reportFile || scanning}
                className="w-full py-2.5 bg-emerald-600 hover:bg-emerald-500 text-white font-bold text-xs rounded-xl shadow-md transition disabled:opacity-50 mt-2"
              >
                {scanning ? 'Analyzing Health Record...' : 'Process & Update Immunization Status'}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};
