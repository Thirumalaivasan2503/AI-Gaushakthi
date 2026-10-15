import React from 'react';
import { NavLink } from 'react-router-dom';
import { useAuth } from '../../context/AuthContext';
import { GauShakthiLogo } from '../common/GauShakthiLogo';
import { 
  Home, 
  Sparkles, 
  BookOpen, 
  HeartPulse, 
  ShieldCheck, 
  History, 
  Bot, 
  Sliders, 
  X,
  PlusCircle,
  Stethoscope,
  Milk,
  Scale
} from 'lucide-react';

interface SidebarProps {
  isOpen: boolean;
  onClose: () => void;
}

export const Sidebar: React.FC<SidebarProps> = ({ isOpen, onClose }) => {
  const { t } = useAuth();

  interface SidebarLink {
    to: string;
    label: string;
    icon: React.ComponentType<{ className?: string }>;
    badge?: string;
  }

  const farmerLinks: SidebarLink[] = [
    { to: '/home', label: t('navHome'), icon: Home },
    { to: '/recommendation', label: t('navRecommender'), icon: Sparkles, badge: '26-ML' },
    { to: '/farmer/milk-analysis', label: t('navMilkAnalysis'), icon: Milk, badge: 'New' },
    { to: '/knowledge/compare', label: t('navCompareBreeds'), icon: Scale, badge: 'A2 vs A1' },
    { to: '/farmer/livestock', label: t('navLivestock'), icon: HeartPulse },
    { to: '/farmer/livestock/add', label: t('navAddLivestock'), icon: PlusCircle },
    { to: '/farmer/medical-vaccination', label: t('navVaccines'), icon: Stethoscope },
  ];

  const commonLinks: SidebarLink[] = [
    { to: '/ai-assistant', label: t('navAssistant'), icon: Bot },
    { to: '/knowledge', label: t('navBreeds'), icon: BookOpen },
    { to: '/government-schemes', label: t('navSchemes'), icon: ShieldCheck },
    { to: '/recommendation-history', label: t('navHistory'), icon: History },
    { to: '/settings', label: t('navSettings'), icon: Sliders },
  ];

  return (
    <>
      {/* Backdrop for mobile */}
      {isOpen && (
        <div
          onClick={onClose}
          className="fixed inset-0 bg-slate-900/50 backdrop-blur-xs z-40 lg:hidden"
        />
      )}

      <aside
        className={`fixed top-0 bottom-0 left-0 z-40 w-64 bg-white dark:bg-slate-900 border-r border-slate-200 dark:border-slate-800 transition-transform duration-300 ease-in-out transform ${
          isOpen ? 'translate-x-0' : '-translate-x-full lg:translate-x-0'
        } pt-3 flex flex-col justify-between`}
      >
        <div className="px-4 py-2 overflow-y-auto space-y-6">
          {/* Top Brand Logo Header inside Sidebar */}
          <div className="flex items-center justify-between pb-3 border-b border-slate-100 dark:border-slate-800">
            <GauShakthiLogo size="sm" showText={true} />
            <button onClick={onClose} className="p-1 rounded-lg text-slate-500 hover:bg-slate-100 dark:hover:bg-slate-800 lg:hidden">
              <X className="w-5 h-5" />
            </button>
          </div>

          {/* Farmer Portal Section */}
          <div>
            <p className="px-3 text-[11px] font-bold uppercase tracking-wider text-emerald-600 dark:text-emerald-400 mb-2">
              🌾 {t('farmerPortal')}
            </p>
            <nav className="space-y-1">
              {farmerLinks.map((link) => {
                const Icon = link.icon;
                return (
                  <NavLink
                    key={link.to}
                    to={link.to}
                    onClick={() => onClose()}
                    className={({ isActive }) =>
                      `flex items-center justify-between px-3 py-2.5 rounded-xl text-xs font-semibold transition-all ${
                        isActive
                          ? 'bg-emerald-600 text-white shadow-md shadow-emerald-500/20'
                          : 'text-slate-700 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800/60'
                      }`
                    }
                  >
                    <div className="flex items-center space-x-3">
                      <Icon className="w-4 h-4" />
                      <span>{link.label}</span>
                    </div>
                    {link.badge && (
                      <span className="px-1.5 py-0.5 text-[9px] font-bold rounded-full bg-emerald-100 dark:bg-emerald-900/80 text-emerald-800 dark:text-emerald-300">
                        {link.badge}
                      </span>
                    )}
                  </NavLink>
                );
              })}
            </nav>
          </div>

          {/* Ecosystem & Resources section */}
          <div>
            <p className="px-3 text-[11px] font-bold uppercase tracking-wider text-slate-400 dark:text-slate-500 mb-2">
              Ecosystem & Resources
            </p>
            <nav className="space-y-1">
              {commonLinks.map((link) => {
                const Icon = link.icon;
                return (
                  <NavLink
                    key={link.to}
                    to={link.to}
                    onClick={() => onClose()}
                    className={({ isActive }) =>
                      `flex items-center justify-between px-3 py-2.5 rounded-xl text-xs font-semibold transition-all ${
                        isActive
                          ? 'bg-emerald-600 text-white shadow-md shadow-emerald-500/20'
                          : 'text-slate-700 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800/60'
                      }`
                    }
                  >
                    <div className="flex items-center space-x-3">
                      <Icon className="w-4 h-4" />
                      <span>{link.label}</span>
                    </div>
                  </NavLink>
                );
              })}
            </nav>
          </div>
        </div>

        {/* Footer info box */}
        <div className="p-4 border-t border-slate-100 dark:border-slate-800/80">
          <div className="bg-slate-50 dark:bg-slate-800/50 rounded-xl p-3 border border-slate-200/60 dark:border-slate-700/60 text-center">
            <span className="inline-block w-2 h-2 rounded-full bg-emerald-500 animate-ping mr-1.5"></span>
            <span className="text-[11px] font-semibold text-slate-700 dark:text-slate-300">FastAPI ML Engine Online</span>
            <p className="text-[10px] text-slate-500 dark:text-slate-400 mt-0.5">LightGBM v2.1 • 79.33% Accuracy</p>
          </div>
        </div>
      </aside>
    </>
  );
};
