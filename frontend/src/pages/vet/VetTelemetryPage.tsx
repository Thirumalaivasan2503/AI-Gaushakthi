import React from 'react';
import { BarChart, Bar, XAxis, YAxis, Tooltip, ResponsiveContainer } from 'recharts';
import { Stethoscope, Activity, MapPin } from 'lucide-react';

export const VetTelemetryPage: React.FC = () => {
  const telemetryData = [
    { district: 'Coimbatore', fmdVaccinated: 92, thiAlerts: 14, cases: 3 },
    { district: 'Erode', fmdVaccinated: 88, thiAlerts: 22, cases: 5 },
    { district: 'Salem', fmdVaccinated: 95, thiAlerts: 8, cases: 1 },
    { district: 'Tiruppur', fmdVaccinated: 90, thiAlerts: 18, cases: 2 },
  ];

  return (
    <div className="space-y-6 max-w-4xl mx-auto">
      <div>
        <h1 className="text-xl font-bold text-slate-900 dark:text-white">Regional Health Telemetry & Outbreak Map</h1>
        <p className="text-xs text-slate-500 dark:text-slate-400">GIS telemetry monitoring and THI heat stress alert clusters</p>
      </div>

      <div className="bg-white dark:bg-slate-900 p-6 rounded-3xl border border-slate-200 dark:border-slate-800 shadow-xs space-y-4">
        <h3 className="font-bold text-sm text-slate-900 dark:text-white">District Vaccination vs. THI Heat Alerts</h3>
        <div className="h-64 w-full">
          <ResponsiveContainer width="100%" height="100%">
            <BarChart data={telemetryData}>
              <XAxis dataKey="district" tick={{ fontSize: 11 }} />
              <YAxis tick={{ fontSize: 11 }} />
              <Tooltip />
              <Bar dataKey="fmdVaccinated" fill="#10b981" name="FMD Vaccination Rate (%)" radius={[4, 4, 0, 0]} />
              <Bar dataKey="thiAlerts" fill="#f59e0b" name="THI Heat Stress Alerts" radius={[4, 4, 0, 0]} />
            </BarChart>
          </ResponsiveContainer>
        </div>
      </div>
    </div>
  );
};
