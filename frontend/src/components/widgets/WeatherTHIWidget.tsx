import React, { useEffect, useState } from 'react';
import { apiService } from '../../services/api';
import { WeatherData } from '../../types';
import { Sun, Droplets, Thermometer, AlertTriangle, CheckCircle2, ShieldAlert } from 'lucide-react';

export const WeatherTHIWidget: React.FC = () => {
  const [weather, setWeather] = useState<WeatherData | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    apiService.getWeatherTHI().then((data) => {
      setWeather(data);
      setLoading(false);
    });
  }, []);

  if (loading || !weather) {
    return (
      <div className="bg-white dark:bg-slate-900 rounded-2xl p-4 border border-slate-200 dark:border-slate-800 animate-pulse flex items-center justify-between">
        <div className="h-4 bg-slate-200 dark:bg-slate-700 rounded w-1/3"></div>
        <div className="h-4 bg-slate-200 dark:bg-slate-700 rounded w-1/4"></div>
      </div>
    );
  }

  const getBadgeStyle = (level: WeatherData['heat_stress_level']) => {
    switch (level) {
      case 'Normal':
        return 'bg-emerald-100 text-emerald-800 dark:bg-emerald-900/60 dark:text-emerald-300 border-emerald-200';
      case 'Alert':
        return 'bg-amber-100 text-amber-800 dark:bg-amber-900/60 dark:text-amber-300 border-amber-200';
      case 'Warning':
        return 'bg-orange-100 text-orange-800 dark:bg-orange-900/60 dark:text-orange-300 border-orange-200';
      case 'Emergency':
        return 'bg-rose-100 text-rose-800 dark:bg-rose-900/60 dark:text-rose-300 border-rose-200';
    }
  };

  return (
    <div className="bg-gradient-to-br from-emerald-900 to-teal-950 text-white rounded-2xl p-4 sm:p-5 shadow-lg border border-emerald-800/60 relative overflow-hidden">
      {/* Background ambient lighting */}
      <div className="absolute -top-12 -right-12 w-40 h-40 bg-emerald-500/10 rounded-full blur-3xl"></div>

      <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 relative z-10">
        <div>
          <div className="flex items-center space-x-2">
            <span className="inline-flex items-center space-x-1 text-xs font-semibold px-2.5 py-0.5 rounded-full bg-emerald-800/80 text-emerald-200 border border-emerald-700">
              <Sun className="w-3 h-3 text-amber-400" />
              <span>{weather.location_name}</span>
            </span>
            <span className={`text-xs font-bold px-2.5 py-0.5 rounded-full border ${getBadgeStyle(weather.heat_stress_level)}`}>
              THI Heat Stress: {weather.heat_stress_level}
            </span>
          </div>

          <p className="text-xs text-emerald-200/90 mt-2 font-medium">
            {weather.forecast_summary}
          </p>
        </div>

        <div className="flex items-center space-x-4 bg-emerald-950/70 px-4 py-2.5 rounded-xl border border-emerald-800/80">
          <div className="flex items-center space-x-1.5">
            <Thermometer className="w-4 h-4 text-amber-400" />
            <div>
              <span className="block text-[10px] text-emerald-300 uppercase font-semibold">Temp</span>
              <span className="text-sm font-bold">{weather.temperature}°C</span>
            </div>
          </div>

          <div className="h-6 w-px bg-emerald-800"></div>

          <div className="flex items-center space-x-1.5">
            <Droplets className="w-4 h-4 text-cyan-400" />
            <div>
              <span className="block text-[10px] text-emerald-300 uppercase font-semibold">Humidity</span>
              <span className="text-sm font-bold">{weather.humidity}%</span>
            </div>
          </div>

          <div className="h-6 w-px bg-emerald-800"></div>

          <div>
            <span className="block text-[10px] text-emerald-300 uppercase font-semibold">THI Score</span>
            <span className="text-sm font-extrabold text-amber-300">{weather.thi_index}</span>
          </div>
        </div>
      </div>
    </div>
  );
};
