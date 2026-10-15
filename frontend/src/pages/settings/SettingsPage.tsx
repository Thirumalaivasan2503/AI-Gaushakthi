import React from 'react';
import { useAuth } from '../../context/AuthContext';
import { Moon, Sun, Globe } from 'lucide-react';

export const SettingsPage: React.FC = () => {
  const { theme, toggleTheme, language, setLanguage, t } = useAuth();

  return (
    <div className="max-w-2xl mx-auto space-y-6">
      <div>
        <h1 className="text-xl font-bold text-slate-900 dark:text-white">{t('settingsTitle')}</h1>
        <p className="text-xs text-slate-500 dark:text-slate-400">Configure theme appearance and language localization</p>
      </div>

      <div className="bg-white dark:bg-slate-900 rounded-3xl p-6 border border-slate-200 dark:border-slate-800 shadow-xs space-y-6">
        {/* Theme Settings */}
        <div className="flex items-center justify-between">
          <div className="flex items-center space-x-3">
            <div className="w-10 h-10 rounded-xl bg-amber-100 dark:bg-amber-950 text-amber-600 flex items-center justify-center">
              {theme === 'dark' ? <Sun className="w-5 h-5" /> : <Moon className="w-5 h-5" />}
            </div>
            <div>
              <h3 className="font-bold text-xs text-slate-900 dark:text-white">{t('appTheme')}</h3>
              <p className="text-[10px] text-slate-500">Toggle Light / Dark Mode</p>
            </div>
          </div>

          <button
            onClick={toggleTheme}
            className="px-4 py-2 bg-slate-100 dark:bg-slate-800 text-slate-900 dark:text-white text-xs font-semibold rounded-xl border border-slate-200 dark:border-slate-700 hover:bg-emerald-50 dark:hover:bg-slate-700 transition"
          >
            {theme === 'dark' ? 'Light Mode' : 'Dark Mode'}
          </button>
        </div>

        {/* Language Settings */}
        <div className="border-t border-slate-100 dark:border-slate-800 pt-4 flex items-center justify-between">
          <div className="flex items-center space-x-3">
            <div className="w-10 h-10 rounded-xl bg-emerald-100 dark:bg-emerald-950 text-emerald-600 flex items-center justify-center">
              <Globe className="w-5 h-5" />
            </div>
            <div>
              <h3 className="font-bold text-xs text-slate-900 dark:text-white">{t('languageSelect')}</h3>
              <p className="text-[10px] text-slate-500">English, தமிழ் (Tamil), हिंदी (Hindi)</p>
            </div>
          </div>

          <select
            value={language}
            onChange={(e) => setLanguage(e.target.value as any)}
            className="bg-slate-100 dark:bg-slate-800 text-xs font-bold text-slate-900 dark:text-white px-3 py-2 rounded-xl border border-slate-200 dark:border-slate-700 cursor-pointer"
          >
            <option value="en">English</option>
            <option value="ta">தமிழ் (Tamil)</option>
            <option value="hi">हिंदी (Hindi)</option>
          </select>
        </div>
      </div>
    </div>
  );
};
