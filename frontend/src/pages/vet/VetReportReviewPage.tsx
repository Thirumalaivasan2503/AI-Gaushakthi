import React, { useState } from 'react';
import { FileSpreadsheet, CheckCircle, XCircle, AlertTriangle } from 'lucide-react';

export const VetReportReviewPage: React.FC = () => {
  const [reports, setReports] = useState([
    {
      id: 'rep-101',
      farmerName: 'Thiru',
      animalTag: 'TN-CBT-102',
      breed: 'Umblachery Cow',
      submissionDate: 'Aug 03, 2026',
      symptomDescription: 'Skin lesions observed near shoulder. Mild appetite drop.',
      status: 'Pending Clinical Review',
      flaggedCV: 'Lumpy Skin Disease Suspect (82% CV Confidence)',
    },
    {
      id: 'rep-102',
      farmerName: 'Karthik Raja',
      animalTag: 'TN-CBT-305',
      breed: 'Kangayam Bull',
      submissionDate: 'Aug 01, 2026',
      symptomDescription: 'Hoof swelling post ploughing.',
      status: 'Approved',
      flaggedCV: 'Physical Strain / Minor Inflammation',
    },
  ]);

  const handleReview = (id: string, action: 'approve' | 'flag') => {
    setReports((prev) =>
      prev.map((r) =>
        r.id === id
          ? { ...r, status: action === 'approve' ? 'Approved & Prescribed' : 'Flagged for On-Farm Vet Visit' }
          : r
      )
    );
  };

  return (
    <div className="space-y-6 max-w-4xl mx-auto">
      <div>
        <h1 className="text-xl font-bold text-slate-900 dark:text-white">Clinical Lesion & Report Reviews</h1>
        <p className="text-xs text-slate-500 dark:text-slate-400">Review computer vision lesion classifications submitted by farmers</p>
      </div>

      <div className="space-y-4">
        {reports.map((rep) => (
          <div key={rep.id} className="bg-white dark:bg-slate-900 rounded-3xl p-6 border border-slate-200 dark:border-slate-800 shadow-xs space-y-4">
            <div className="flex items-center justify-between">
              <div>
                <span className="font-bold text-sm text-slate-900 dark:text-white">{rep.animalTag}</span>
                <span className="text-xs text-slate-500 ml-2 font-medium">({rep.breed})</span>
              </div>

              <span
                className={`text-[10px] font-bold px-2.5 py-0.5 rounded-full ${
                  rep.status.includes('Approved')
                    ? 'bg-emerald-100 text-emerald-800 dark:bg-emerald-950 dark:text-emerald-300'
                    : 'bg-amber-100 text-amber-800 dark:bg-amber-950 dark:text-amber-300'
                }`}
              >
                {rep.status}
              </span>
            </div>

            <div className="bg-amber-50 dark:bg-amber-950/40 p-3 rounded-2xl border border-amber-200 dark:border-amber-800/60 flex items-center space-x-2 text-xs text-amber-800 dark:text-amber-300">
              <AlertTriangle className="w-4 h-4 text-amber-600 shrink-0" />
              <span>Computer Vision Automated Screening: <strong>{rep.flaggedCV}</strong></span>
            </div>

            <p className="text-xs text-slate-600 dark:text-slate-300">
              <strong>Farmer Note:</strong> {rep.symptomDescription}
            </p>

            {rep.status === 'Pending Clinical Review' && (
              <div className="flex items-center space-x-3 pt-2 border-t border-slate-100 dark:border-slate-800">
                <button
                  onClick={() => handleReview(rep.id, 'approve')}
                  className="px-4 py-2 bg-emerald-600 hover:bg-emerald-500 text-white font-bold text-xs rounded-xl flex items-center space-x-1 transition"
                >
                  <CheckCircle className="w-4 h-4" />
                  <span>Approve & Issue E-Prescription</span>
                </button>

                <button
                  onClick={() => handleReview(rep.id, 'flag')}
                  className="px-4 py-2 bg-rose-600 hover:bg-rose-500 text-white font-bold text-xs rounded-xl flex items-center space-x-1 transition"
                >
                  <XCircle className="w-4 h-4" />
                  <span>Dispatch Field Doctor Visit</span>
                </button>
              </div>
            )}
          </div>
        ))}
      </div>
    </div>
  );
};
