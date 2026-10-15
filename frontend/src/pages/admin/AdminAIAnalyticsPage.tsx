import React, { useState, useEffect } from 'react';
import { BarChart, Bar, XAxis, YAxis, Tooltip, ResponsiveContainer, Cell } from 'recharts';
import { Cpu, Award, ShieldCheck, CheckCircle2, Activity, Layers } from 'lucide-react';
import { apiService } from '../../services/api';

export const AdminAIAnalyticsPage: React.FC = () => {
  const [metrics, setMetrics] = useState<any>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchMetrics();
  }, []);

  const fetchMetrics = async () => {
    setLoading(true);
    try {
      const res = await apiService.getModelMetrics();
      if (res && res.data) {
        setMetrics(res.data);
      }
    } catch (err) {
      console.error('Error fetching model evaluation metrics:', err);
    } finally {
      setLoading(false);
    }
  };

  const accuracy = metrics ? (metrics.accuracy * 100).toFixed(1) : '73.0';
  const precision = metrics ? (metrics.precision * 100).toFixed(1) : '66.1';
  const recall = metrics ? (metrics.recall * 100).toFixed(1) : '73.0';
  const f1 = metrics ? (metrics.f1_score * 100).toFixed(1) : '69.2';
  const rocAuc = metrics ? (metrics.roc_auc).toFixed(4) : '0.8836';
  const classes = metrics?.classes || ['Gir', 'Ongole', 'Kangayam', 'Sahiwal'];
  const confusionMatrix = metrics?.confusion_matrix || [
    [26, 0, 0, 1],
    [1, 6, 2, 1],
    [3, 1, 38, 18],
    [0, 0, 0, 3]
  ];

  const metricBarData = [
    { name: 'Accuracy', score: Number(accuracy) },
    { name: 'Precision', score: Number(precision) },
    { name: 'Recall', score: Number(recall) },
    { name: 'F1 Score', score: Number(f1) },
    { name: 'ROC-AUC', score: Number((Number(rocAuc) * 100).toFixed(1)) },
  ];

  return (
    <div className="space-y-6 max-w-5xl mx-auto font-sans">
      {/* Header Banner */}
      <div className="bg-gradient-to-r from-emerald-950 via-slate-900 to-teal-950 rounded-3xl p-6 sm:p-8 text-white border-2 border-emerald-500/40 shadow-2xl space-y-3">
        <div className="flex items-center space-x-3">
          <div className="w-12 h-12 rounded-2xl bg-amber-400/20 text-amber-400 flex items-center justify-center shrink-0 border border-amber-400/40 shadow-lg">
            <Cpu className="w-6 h-6 text-amber-400" />
          </div>
          <div>
            <span className="text-[10px] font-extrabold text-amber-300 uppercase tracking-wider block">
              Random Forest Model Evaluation Telemetry (backend/models/model_metrics.json)
            </span>
            <h1 className="text-2xl sm:text-3xl font-black text-white">
              Random Forest Classifier Benchmark Metrics
            </h1>
          </div>
        </div>
        <p className="text-xs text-emerald-200 leading-relaxed max-w-3xl">
          Trained on <code className="text-amber-300 font-mono">livestock_training_dataset.csv</code> using an 80:20 train-test split and 5-fold GridSearchCV hyperparameter optimization.
        </p>
      </div>

      {/* 5 Key Metric Cards */}
      <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-5 gap-3">
        <div className="bg-gradient-to-br from-emerald-950 to-slate-900 p-4 rounded-2xl border border-emerald-500/40 text-white shadow-xl space-y-1">
          <span className="text-[10px] font-bold text-emerald-300 uppercase block">Accuracy</span>
          <strong className="text-2xl font-black text-white block">{accuracy}%</strong>
          <span className="text-[10px] text-emerald-200">Test Set Evaluation</span>
        </div>

        <div className="bg-gradient-to-br from-emerald-950 to-slate-900 p-4 rounded-2xl border border-emerald-500/40 text-white shadow-xl space-y-1">
          <span className="text-[10px] font-bold text-amber-300 uppercase block">Precision</span>
          <strong className="text-2xl font-black text-amber-400 block">{precision}%</strong>
          <span className="text-[10px] text-emerald-200">Weighted Average</span>
        </div>

        <div className="bg-gradient-to-br from-emerald-950 to-slate-900 p-4 rounded-2xl border border-emerald-500/40 text-white shadow-xl space-y-1">
          <span className="text-[10px] font-bold text-emerald-300 uppercase block">Recall</span>
          <strong className="text-2xl font-black text-white block">{recall}%</strong>
          <span className="text-[10px] text-emerald-200">True Positive Rate</span>
        </div>

        <div className="bg-gradient-to-br from-emerald-950 to-slate-900 p-4 rounded-2xl border border-emerald-500/40 text-white shadow-xl space-y-1">
          <span className="text-[10px] font-bold text-amber-300 uppercase block">F1 Score</span>
          <strong className="text-2xl font-black text-amber-300 block">{f1}%</strong>
          <span className="text-[10px] text-emerald-200">Harmonic Mean</span>
        </div>

        <div className="bg-gradient-to-br from-emerald-950 to-slate-900 p-4 rounded-2xl border border-emerald-500/40 text-white shadow-xl space-y-1">
          <span className="text-[10px] font-bold text-emerald-300 uppercase block">ROC-AUC Score</span>
          <strong className="text-2xl font-black text-emerald-400 block">{rocAuc}</strong>
          <span className="text-[10px] text-emerald-200">Multiclass One-vs-Rest</span>
        </div>
      </div>

      {/* Model Performance Bar Chart */}
      <div className="bg-white dark:bg-slate-900 rounded-3xl p-6 border border-slate-200 dark:border-slate-800 shadow-xl space-y-4">
        <h3 className="font-extrabold text-base text-slate-900 dark:text-white flex items-center space-x-2">
          <Activity className="w-5 h-5 text-emerald-600" />
          <span>Evaluation Metrics Breakdown (%)</span>
        </h3>

        <div className="h-64 w-full">
          <ResponsiveContainer width="100%" height="100%">
            <BarChart data={metricBarData} margin={{ top: 10, right: 30, left: 20, bottom: 20 }}>
              <XAxis dataKey="name" tick={{ fontSize: 11 }} />
              <YAxis domain={[0, 100]} tick={{ fontSize: 11 }} />
              <Tooltip formatter={(val) => [`${val}%`, 'Score']} />
              <Bar dataKey="score" radius={[6, 6, 0, 0]}>
                {metricBarData.map((_, idx) => (
                  <Cell key={`cell-${idx}`} fill={idx % 2 === 0 ? '#10b981' : '#fbbf24'} />
                ))}
              </Bar>
            </BarChart>
          </ResponsiveContainer>
        </div>
      </div>

      {/* Confusion Matrix Table */}
      <div className="bg-white dark:bg-slate-900 rounded-3xl p-6 border border-slate-200 dark:border-slate-800 shadow-xl space-y-4">
        <h3 className="font-extrabold text-base text-slate-900 dark:text-white flex items-center space-x-2">
          <Layers className="w-5 h-5 text-emerald-600" />
          <span>Multiclass Confusion Matrix</span>
        </h3>

        <div className="overflow-x-auto">
          <table className="w-full text-xs text-center border-collapse">
            <thead>
              <tr className="bg-emerald-950 text-white font-bold">
                <th className="p-3 border border-emerald-800">Actual \ Predicted</th>
                {classes.map((clsName: string, idx: number) => (
                  <th key={idx} className="p-3 border border-emerald-800">{clsName}</th>
                ))}
              </tr>
            </thead>
            <tbody>
              {confusionMatrix.map((row: number[], rIdx: number) => (
                <tr key={rIdx} className="border-b border-slate-200 dark:border-slate-700">
                  <td className="p-3 font-extrabold bg-slate-100 dark:bg-slate-800 text-slate-900 dark:text-white border border-slate-200 dark:border-slate-700">
                    {classes[rIdx] || `Class ${rIdx}`}
                  </td>
                  {row.map((val: number, cIdx: number) => (
                    <td
                      key={cIdx}
                      className={`p-3 font-extrabold border border-slate-200 dark:border-slate-700 ${
                        rIdx === cIdx
                          ? 'bg-emerald-100 dark:bg-emerald-950/80 text-emerald-800 dark:text-emerald-300'
                          : val > 0
                          ? 'bg-amber-50 dark:bg-amber-950/40 text-amber-800 dark:text-amber-300'
                          : 'text-slate-400'
                      }`}
                    >
                      {val}
                    </td>
                  ))}
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
};
