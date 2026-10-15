import React from 'react';
import { Link } from 'react-router-dom';
import { Stethoscope, FileSpreadsheet, HeartPulse, AlertTriangle, ArrowRight, ShieldCheck } from 'lucide-react';

export const VetDashboardPage: React.FC = () => {
  return (
    <div className="space-y-6">
      {/* Header Banner */}
      <div className="bg-gradient-to-r from-teal-800 to-cyan-900 text-white rounded-3xl p-6 sm:p-8 shadow-xl space-y-2">
        <span className="px-3 py-1 bg-teal-700/80 rounded-full text-xs font-semibold uppercase tracking-wider text-teal-200">
          Veterinary Doctor Portal
        </span>
        <h1 className="text-2xl sm:text-3xl font-extrabold">Clinical Telemetry & Disease Intelligence</h1>
        <p className="text-xs sm:text-sm text-teal-100/90 max-w-2xl leading-relaxed">
          Monitor regional livestock disease outbreaks, review farmer clinical lesion uploads, and perform remote diagnostic consultation triage.
        </p>
      </div>

      {/* Vet Stat Cards */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
        <div className="bg-white dark:bg-slate-900 p-5 rounded-3xl border border-slate-200 dark:border-slate-800 shadow-xs">
          <span className="block text-xs text-slate-500 font-medium">Pending Lesion Uploads</span>
          <span className="text-2xl font-black text-amber-600 mt-1 block">4 Cases</span>
          <span className="text-[10px] text-slate-400">Needs clinical validation</span>
        </div>

        <div className="bg-white dark:bg-slate-900 p-5 rounded-3xl border border-slate-200 dark:border-slate-800 shadow-xs">
          <span className="block text-xs text-slate-500 font-medium">Regional THI Risk</span>
          <span className="text-2xl font-black text-rose-600 mt-1 block">Level 3 (Alert)</span>
          <span className="text-[10px] text-slate-400">Coimbatore / Erode Belt</span>
        </div>

        <div className="bg-white dark:bg-slate-900 p-5 rounded-3xl border border-slate-200 dark:border-slate-800 shadow-xs">
          <span className="block text-xs text-slate-500 font-medium">Disease DB Records</span>
          <span className="text-2xl font-black text-emerald-600 mt-1 block">142 Diseases</span>
          <span className="text-[10px] text-slate-400">ICAR / TANUVAS catalog</span>
        </div>

        <div className="bg-white dark:bg-slate-900 p-5 rounded-3xl border border-slate-200 dark:border-slate-800 shadow-xs">
          <span className="block text-xs text-slate-500 font-medium">Active Vaccinations</span>
          <span className="text-2xl font-black text-teal-600 mt-1 block">89% Coverage</span>
          <span className="text-[10px] text-slate-400">FMD round completed</span>
        </div>
      </div>

      {/* Quick Action Navigation Grid */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <Link
          to="/vet/reports"
          className="bg-white dark:bg-slate-900 p-6 rounded-3xl border border-slate-200 dark:border-slate-800 hover:border-amber-500/80 transition space-y-3 group shadow-xs"
        >
          <div className="w-12 h-12 rounded-2xl bg-amber-100 dark:bg-amber-950 text-amber-600 dark:text-amber-400 flex items-center justify-center">
            <FileSpreadsheet className="w-6 h-6" />
          </div>
          <h3 className="font-bold text-sm text-slate-900 dark:text-white group-hover:text-amber-600 transition">
            Clinical Lesion & Report Reviews
          </h3>
          <p className="text-xs text-slate-500 dark:text-slate-400">
            Review uploaded animal photos for skin lesions, foot lesions, or fever symptoms flagged by computer vision.
          </p>
          <div className="flex items-center text-xs font-bold text-amber-600 space-x-1 pt-2">
            <span>Review Pending Queue</span>
            <ArrowRight className="w-4 h-4" />
          </div>
        </Link>

        <Link
          to="/vet/diseases"
          className="bg-white dark:bg-slate-900 p-6 rounded-3xl border border-slate-200 dark:border-slate-800 hover:border-teal-500/80 transition space-y-3 group shadow-xs"
        >
          <div className="w-12 h-12 rounded-2xl bg-teal-100 dark:bg-teal-950 text-teal-600 dark:text-teal-400 flex items-center justify-center">
            <HeartPulse className="w-6 h-6" />
          </div>
          <h3 className="font-bold text-sm text-slate-900 dark:text-white group-hover:text-teal-600 transition">
            Disease Intelligence Database
          </h3>
          <p className="text-xs text-slate-500 dark:text-slate-400">
            Search clinical diagnostic protocols, symptom cross-references, and recommended therapeutic regimens.
          </p>
          <div className="flex items-center text-xs font-bold text-teal-600 space-x-1 pt-2">
            <span>Explore Disease Database</span>
            <ArrowRight className="w-4 h-4" />
          </div>
        </Link>

        <Link
          to="/vet-telemetry"
          className="bg-white dark:bg-slate-900 p-6 rounded-3xl border border-slate-200 dark:border-slate-800 hover:border-cyan-500/80 transition space-y-3 group shadow-xs"
        >
          <div className="w-12 h-12 rounded-2xl bg-cyan-100 dark:bg-cyan-950 text-cyan-600 dark:text-cyan-400 flex items-center justify-center">
            <Stethoscope className="w-6 h-6" />
          </div>
          <h3 className="font-bold text-sm text-slate-900 dark:text-white group-hover:text-cyan-600 transition">
            Regional Telemetry & Outbreaks
          </h3>
          <p className="text-xs text-slate-500 dark:text-slate-400">
            View GIS cluster maps and heat stress THI trends to deploy preventive vaccination drives.
          </p>
          <div className="flex items-center text-xs font-bold text-cyan-600 space-x-1 pt-2">
            <span>View Health Telemetry</span>
            <ArrowRight className="w-4 h-4" />
          </div>
        </Link>
      </div>
    </div>
  );
};
