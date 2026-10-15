import React, { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { useAuth } from '../../context/AuthContext';
import { GauShakthiLogo } from '../common/GauShakthiLogo';
import { 
  Sun, 
  Moon, 
  Globe, 
  Bell, 
  LogOut, 
  User as UserIcon,
  Bot,
  Menu,
  CheckCircle2
} from 'lucide-react';

interface NavbarProps {
  onToggleSidebar: () => void;
  onOpenAssistant: () => void;
}

export const Navbar: React.FC<NavbarProps> = ({ onToggleSidebar, onOpenAssistant }) => {
  const { user, language, setLanguage, theme, toggleTheme, logout, t, isOfflineMode } = useAuth();
  const [showUserMenu, setShowUserMenu] = useState(false);
  const navigate = useNavigate();

  return (
    <header className="sticky top-0 z-30 bg-white/90 dark:bg-slate-900/90 backdrop-blur-md border-b border-slate-200 dark:border-slate-800 transition-colors">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-16">
          {/* Left section: Mobile Toggle & Brand Logo */}
          <div className="flex items-center space-x-3 lg:pl-64">
            <button
              onClick={onToggleSidebar}
              className="p-2 rounded-lg text-slate-600 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800 lg:hidden"
            >
              <Menu className="w-5 h-5" />
            </button>

            <Link to="/home" className="flex items-center">
              <GauShakthiLogo size="md" showText={true} />
            </Link>
          </div>

          {/* Center section: Single Farmer Badge & Offline Status Indicator */}
          <div className="hidden md:flex items-center space-x-2">
            <div className="flex items-center space-x-2 bg-emerald-50 dark:bg-emerald-950/60 px-3 py-1.5 rounded-full border border-emerald-200 dark:border-emerald-800/80">
              <CheckCircle2 className="w-4 h-4 text-emerald-600 dark:text-emerald-400" />
              <span className="text-xs font-bold text-emerald-800 dark:text-emerald-300">
                🌾 {t('farmerPortal')}
              </span>
            </div>

            {isOfflineMode && (
              <div className="flex items-center space-x-1.5 bg-amber-500/20 px-3 py-1 rounded-full border border-amber-500/40 text-amber-400 text-xs font-bold animate-pulse">
                <span className="w-2 h-2 rounded-full bg-amber-400"></span>
                <span>Offline Mode</span>
              </div>
            )}
          </div>

          {/* Right section: Controls */}
          <div className="flex items-center space-x-2 sm:space-x-3">
            {/* AI Assistant Quick Drawer Toggle */}
            <button
              onClick={onOpenAssistant}
              className="flex items-center space-x-1.5 px-3 py-1.5 rounded-lg bg-emerald-600 hover:bg-emerald-500 text-white text-xs font-bold shadow-md shadow-emerald-500/20 transition-all"
            >
              <Bot className="w-4 h-4 animate-pulse" />
              <span className="hidden sm:inline">{t('voiceTitle')}</span>
            </button>

            {/* Language Switcher */}
            <div className="relative">
              <select
                value={language}
                onChange={(e) => setLanguage(e.target.value as any)}
                className="bg-slate-100 dark:bg-slate-800 text-xs font-semibold text-slate-700 dark:text-slate-200 px-2 py-1.5 rounded-lg border border-slate-200 dark:border-slate-700 cursor-pointer focus:outline-none"
              >
                <option value="en">English</option>
                <option value="ta">தமிழ் (Tamil)</option>
                <option value="hi">हिंदी (Hindi)</option>
              </select>
            </div>

            {/* Theme Toggle */}
            <button
              onClick={toggleTheme}
              className="p-2 rounded-lg text-slate-600 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800 transition"
              title="Toggle Light/Dark Theme"
            >
              {theme === 'dark' ? <Sun className="w-4 h-4 text-amber-400" /> : <Moon className="w-4 h-4 text-slate-600" />}
            </button>

            {/* Notification Bell */}
            <Link
              to="/notifications"
              className="p-2 rounded-lg text-slate-600 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800 relative transition"
            >
              <Bell className="w-4 h-4" />
              <span className="absolute top-1.5 right-1.5 w-2 h-2 rounded-full bg-emerald-500 ring-2 ring-white dark:ring-slate-900"></span>
            </Link>

            {/* User Profile Menu */}
            <div className="relative">
              <button
                onClick={() => setShowUserMenu(!showUserMenu)}
                className="flex items-center space-x-2 p-1 rounded-full hover:bg-slate-100 dark:hover:bg-slate-800 transition"
              >
                <div className="w-8 h-8 rounded-full bg-slate-200 dark:bg-slate-700 flex items-center justify-center text-slate-700 dark:text-slate-200 font-semibold text-xs border border-slate-300 dark:border-slate-600">
                  {user?.name ? user.name.charAt(0) : 'U'}
                </div>
              </button>

              {showUserMenu && (
                <div className="absolute right-0 mt-2 w-56 bg-white dark:bg-slate-900 rounded-xl shadow-xl border border-slate-200 dark:border-slate-800 py-2 z-50 animate-in fade-in slide-in-from-top-2">
                  <div className="px-4 py-2 border-b border-slate-100 dark:border-slate-800">
                    <p className="text-sm font-semibold text-slate-900 dark:text-white truncate">{user?.name}</p>
                    <p className="text-xs text-slate-500 dark:text-slate-400">{user?.phone}</p>
                  </div>

                  <Link
                    to="/profile"
                    onClick={() => setShowUserMenu(false)}
                    className="flex items-center space-x-2 px-4 py-2 text-xs text-slate-700 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800"
                  >
                    <UserIcon className="w-4 h-4" />
                    <span>{t('navProfile')}</span>
                  </Link>

                  <div className="border-t border-slate-100 dark:border-slate-800 mt-1 pt-1">
                    <button
                      onClick={() => {
                        setShowUserMenu(false);
                        logout();
                        navigate('/auth/login');
                      }}
                      className="w-full flex items-center space-x-2 px-4 py-2 text-xs text-rose-600 dark:text-rose-400 hover:bg-rose-50 dark:hover:bg-rose-950/40 font-semibold"
                    >
                      <LogOut className="w-4 h-4" />
                      <span>{t('signOut')}</span>
                    </button>
                  </div>
                </div>
              )}
            </div>
          </div>
        </div>
      </div>
    </header>
  );
};
