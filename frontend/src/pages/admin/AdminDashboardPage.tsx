import React from 'react';
import { Link } from 'react-router-dom';
import { ShieldCheck, Server, Users, Cpu, BarChart3, ArrowRight } from 'lucide-react';

export const AdminDashboardPage: React.FC = () => {
  return (
    <div className="space-y-6">
      {/* Banner */}
      <div className="bg-gradient-to-r from-indigo-900 to-slate-900 text-white rounded-3xl p-6 sm:p-8 shadow-xl space-y-2">
        <span className="px-3 py-1 bg-indigo-800/80 rounded-full text-xs font-semibold uppercase tracking-wider text-indigo-200">
          System Operations & Administration
        </span>
        <h1 className="text-2xl sm:text-3xl font-extrabold">GauShakthi System Governance</h1>
        <p className="text-xs sm:text-sm text-indigo-100/90 max-w-2xl leading-relaxed">
          Monitor FastAPI microservices, LightGBM model telemetry, user roles, and economic impact metrics across Tamil Nadu districts.
        </p>
      </div>

      {/* Admin Stat Grid */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
        <div className="bg-white dark:bg-slate-900 p-5 rounded-3xl border border-slate-200 dark:border-slate-800 shadow-xs">
          <span className="block text-xs text-slate-500 font-medium">Registered Farmers</span>
          <span className="text-2xl font-black text-indigo-600 mt-1 block">12,480</span>
          <span className="text-[10px] text-slate-400">Across 38 Districts</span>
        </div>

        <div className="bg-white dark:bg-slate-900 p-5 rounded-3xl border border-slate-200 dark:border-slate-800 shadow-xs">
          <span className="block text-xs text-slate-500 font-medium">ML Recommendations Served</span>
          <span className="text-2xl font-black text-emerald-600 mt-1 block">45,120</span>
          <span className="text-[10px] text-slate-400">79.33% Model Accuracy</span>
        </div>

        <div className="bg-white dark:bg-slate-900 p-5 rounded-3xl border border-slate-200 dark:border-slate-800 shadow-xs">
          <span className="block text-xs text-slate-500 font-medium">FastAPI Backend Status</span>
          <span className="text-2xl font-black text-emerald-600 mt-1 block">99.98% Uptime</span>
          <span className="text-[10px] text-slate-400">Avg Latency: 42ms</span>
        </div>

        <div className="bg-white dark:bg-slate-900 p-5 rounded-3xl border border-slate-200 dark:border-slate-800 shadow-xs">
          <span className="block text-xs text-slate-500 font-medium">Active Subsidies Disbursed</span>
          <span className="text-2xl font-black text-amber-600 mt-1 block">₹4.2 Cr</span>
          <span className="text-[10px] text-slate-400">Rashtriya Gokul Mission</span>
        </div>
      </div>

      {/* Admin Quick Action Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        <Link
          to="/admin-ai-analytics"
          className="bg-white dark:bg-slate-900 p-6 rounded-3xl border border-slate-200 dark:border-slate-800 hover:border-indigo-500/80 transition space-y-3 group shadow-xs"
        >
          <div className="w-12 h-12 rounded-2xl bg-indigo-100 dark:bg-indigo-950 text-indigo-600 dark:text-indigo-400 flex items-center justify-center">
            <Cpu className="w-6 h-6" />
          </div>
          <h3 className="font-bold text-sm text-slate-900 dark:text-white group-hover:text-indigo-600 transition">
            AI Model Telemetry & Accuracy Monitoring
          </h3>
          <p className="text-xs text-slate-500 dark:text-slate-400">
            Inspect 5-fold cross validation scores, feature importance distributions, and model version releases.
          </p>
          <div className="flex items-center text-xs font-bold text-indigo-600 space-x-1 pt-2">
            <span>View AI Model Analytics</span>
            <ArrowRight className="w-4 h-4" />
          </div>
        </Link>

        <Link
          to="/economic-analysis"
          className="bg-white dark:bg-slate-900 p-6 rounded-3xl border border-slate-200 dark:border-slate-800 hover:border-emerald-500/80 transition space-y-3 group shadow-xs"
        >
          <div className="w-12 h-12 rounded-2xl bg-emerald-100 dark:bg-emerald-950 text-emerald-600 dark:text-emerald-400 flex items-center justify-center">
            <BarChart3 className="w-6 h-6" />
          </div>
          <h3 className="font-bold text-sm text-slate-900 dark:text-white group-hover:text-emerald-600 transition">
            Economic Impact & Farmer ROI Calculator
          </h3>
          <p className="text-xs text-slate-500 dark:text-slate-400">
            Calculate state-wide economic value generation from indigenous breed conservation and draft efficiency gains.
          </p>
          <div className="flex items-center text-xs font-bold text-emerald-600 space-x-1 pt-2">
            <span>View Economic Analytics</span>
            <ArrowRight className="w-4 h-4" />
          </div>
        </Link>
      </div>
    </div>
  );
};
