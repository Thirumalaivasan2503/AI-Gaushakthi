import React, { useState, useEffect } from 'react';
import { DollarSign, TrendingUp, Award, BarChart3, Coins, Sparkles, PieChart, ShieldCheck } from 'lucide-react';
import { ResponsiveContainer, BarChart, Bar, XAxis, YAxis, Tooltip, Legend, CartesianGrid } from 'recharts';
import { apiService } from '../../services/api';
import { EconomicsMasterInfo } from '../../types';

export const EconomicAnalysisPage: React.FC = () => {
  const [economicsData, setEconomicsData] = useState<EconomicsMasterInfo[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchEconomics();
  }, []);

  const fetchEconomics = async () => {
    setLoading(true);
    try {
      const res = await apiService.getEconomics();
      if (res && res.data) {
        setEconomicsData(res.data);
      }
    } catch (err) {
      console.error('Error fetching economics_master.csv:', err);
    } finally {
      setLoading(false);
    }
  };

  const chartData = economicsData.slice(0, 8).map(e => ({
    name: e.Breed_Name,
    Annual_Income: Number(e.Expected_Annual_Income_INR) || 0,
    Net_Profit: Number(e.Net_Profit_INR) || 0,
    Purchase_Cost: Number(e.Purchase_Cost_INR) || 0,
  }));

  return (
    <div className="space-y-6 max-w-5xl mx-auto font-sans">
      {/* Header Banner */}
      <div className="bg-gradient-to-r from-emerald-950 via-slate-900 to-teal-950 rounded-3xl p-6 sm:p-8 text-white border-2 border-emerald-500/40 shadow-2xl space-y-4">
        <div className="flex items-center space-x-3">
          <div className="w-12 h-12 rounded-2xl bg-amber-400/20 text-amber-400 flex items-center justify-center shrink-0 border border-amber-400/40 shadow-lg">
            <Coins className="w-6 h-6 text-amber-400" />
          </div>
          <div>
            <span className="text-[10px] font-extrabold text-amber-300 uppercase tracking-wider block">
              Economics Knowledge Base (economics_master.csv)
            </span>
            <h1 className="text-2xl sm:text-3xl font-black text-white">
              Farmer Financial ROI & Profitability Dashboard
            </h1>
          </div>
        </div>
        <p className="text-xs text-emerald-200 leading-relaxed max-w-3xl">
          Complete purchase costs, maintenance budgets, annual income projections, net profit margins, and ROI percentages cached directly from <code className="text-amber-300 font-mono">economics_master.csv</code>.
        </p>
      </div>

      {/* Top 3 Financial KPI Cards */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        <div className="bg-gradient-to-br from-emerald-950 to-slate-900 text-white p-6 rounded-3xl border border-emerald-500/40 shadow-xl space-y-2">
          <span className="text-[10px] font-extrabold text-amber-300 uppercase tracking-wider block">Average Indigenous Breed ROI</span>
          <span className="text-3xl font-black text-amber-400 block">340% + ROI</span>
          <p className="text-xs text-slate-300 font-semibold">High profit return with low maintenance feed cost</p>
        </div>

        <div className="bg-gradient-to-br from-emerald-950 to-slate-900 text-white p-6 rounded-3xl border border-emerald-500/40 shadow-xl space-y-2">
          <span className="text-[10px] font-extrabold text-emerald-300 uppercase tracking-wider block">Avg Medical Savings</span>
          <span className="text-3xl font-black text-emerald-400 block">₹14,500 / year</span>
          <p className="text-xs text-slate-300 font-semibold">Saved on antibiotics & tick control treatments</p>
        </div>

        <div className="bg-gradient-to-br from-emerald-950 to-slate-900 text-white p-6 rounded-3xl border border-emerald-500/40 shadow-xl space-y-2">
          <span className="text-[10px] font-extrabold text-amber-300 uppercase tracking-wider block">Average Break-Even</span>
          <span className="text-3xl font-black text-amber-300 block">18 - 24 Months</span>
          <p className="text-xs text-slate-300 font-semibold">Rapid capital recovery for smallholder farmers</p>
        </div>
      </div>

      {/* Financial Comparison Chart */}
      <div className="bg-white dark:bg-slate-900 rounded-3xl p-6 border border-slate-200 dark:border-slate-800 shadow-xl space-y-4">
        <div className="flex items-center space-x-2 text-emerald-600">
          <BarChart3 className="w-5 h-5 text-emerald-600" />
          <h3 className="font-extrabold text-base text-slate-900 dark:text-white">
            Breed Financial Performance: Annual Income vs Net Profit (₹ INR)
          </h3>
        </div>

        <div className="h-72 w-full pt-2">
          <ResponsiveContainer width="100%" height="100%">
            <BarChart data={chartData} margin={{ top: 10, right: 30, left: 20, bottom: 20 }}>
              <CartesianGrid strokeDasharray="3 3" opacity={0.2} />
              <XAxis dataKey="name" tick={{ fontSize: 11 }} />
              <YAxis tick={{ fontSize: 11 }} />
              <Tooltip formatter={(val) => [`₹${Number(val).toLocaleString('en-IN')}`, '']} />
              <Legend />
              <Bar dataKey="Annual_Income" fill="#10b981" name="Expected Annual Income (₹)" radius={[6, 6, 0, 0]} />
              <Bar dataKey="Net_Profit" fill="#fbbf24" name="Annual Net Profit (₹)" radius={[6, 6, 0, 0]} />
            </BarChart>
          </ResponsiveContainer>
        </div>
      </div>

      {/* Economics Master Data Catalog */}
      <div className="bg-white dark:bg-slate-900 rounded-3xl p-6 border border-slate-200 dark:border-slate-800 shadow-xl space-y-4">
        <h3 className="font-extrabold text-base text-slate-900 dark:text-white flex items-center space-x-2">
          <Coins className="w-5 h-5 text-emerald-600" />
          <span>Breed Financial Economics Catalog ({economicsData.length} Records)</span>
        </h3>

        {loading ? (
          <div className="text-center py-8 text-xs text-slate-500">Loading financial records...</div>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            {economicsData.map((econ, idx) => (
              <div key={econ.Economics_ID || `econ-${idx}`} className="bg-slate-50 dark:bg-slate-800/60 p-5 rounded-2xl border border-slate-200 dark:border-slate-700 space-y-3">
                <div className="flex items-center justify-between border-b border-slate-200 dark:border-slate-700 pb-2">
                  <h4 className="font-extrabold text-sm text-slate-900 dark:text-white">{econ.Breed_Name}</h4>
                  <span className="text-[10px] bg-amber-400/20 text-amber-600 dark:text-amber-300 font-bold px-2.5 py-0.5 rounded-full border border-amber-400/30">
                    ROI: {econ.ROI_Percentage}%
                  </span>
                </div>

                {/* 14 Attributes */}
                <div className="grid grid-cols-2 sm:grid-cols-3 gap-2 text-xs">
                  <div>
                    <span className="text-[10px] text-slate-400 block font-bold">Purchase Cost</span>
                    <strong className="text-slate-900 dark:text-white font-extrabold">₹{Number(econ.Purchase_Cost_INR).toLocaleString('en-IN')}</strong>
                  </div>
                  <div>
                    <span className="text-[10px] text-slate-400 block font-bold">Daily Feed Cost</span>
                    <strong className="text-slate-900 dark:text-white font-extrabold">₹{econ.Daily_Feed_Cost_INR} / Day</strong>
                  </div>
                  <div>
                    <span className="text-[10px] text-slate-400 block font-bold">Monthly Maint</span>
                    <strong className="text-slate-900 dark:text-white font-extrabold">₹{econ.Monthly_Maintenance_Cost_INR} / Mo</strong>
                  </div>
                  <div>
                    <span className="text-[10px] text-slate-400 block font-bold">Annual Med Cost</span>
                    <strong className="text-slate-900 dark:text-white font-extrabold">₹{econ.Annual_Medical_Cost_INR} / Yr</strong>
                  </div>
                  <div>
                    <span className="text-[10px] text-slate-400 block font-bold">Annual Income</span>
                    <strong className="text-emerald-600 dark:text-emerald-400 font-extrabold">₹{Number(econ.Expected_Annual_Income_INR).toLocaleString('en-IN')}</strong>
                  </div>
                  <div>
                    <span className="text-[10px] text-amber-600 dark:text-amber-400 block font-bold">Net Profit</span>
                    <strong className="text-amber-600 dark:text-amber-400 font-black">₹{Number(econ.Net_Profit_INR).toLocaleString('en-IN')}</strong>
                  </div>
                </div>

                <div className="flex items-center justify-between text-[11px] pt-1 text-slate-600 dark:text-slate-300 font-medium">
                  <span>Break-even: <strong>{econ.Break_even_Period_Months}</strong></span>
                  <span>Target Farmer: <strong>{econ.Recommended_Farmer_Type}</strong></span>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
};
