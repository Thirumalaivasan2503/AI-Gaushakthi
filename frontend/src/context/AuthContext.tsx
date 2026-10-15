import React, { createContext, useContext, useState, useEffect } from 'react';
import { User, AppLanguage } from '../types';
import { translations, Language } from '../i18n/translations';

import { offlineSyncService } from '../services/offlineSync';

interface AuthContextType {
  user: User | null;
  token: string | null;
  refreshToken: string | null;
  language: AppLanguage;
  theme: 'light' | 'dark';
  isAuthenticated: boolean;
  isOfflineMode: boolean;
  setLanguage: (lang: AppLanguage) => void;
  toggleTheme: () => void;
  t: (key: keyof typeof translations.en) => string;
  loginWithJWT: (user: User, accessToken: string, refreshToken?: string) => void;
  login: (phone: string, name?: string) => void;
  logout: () => void;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export const AuthProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [token, setToken] = useState<string | null>(() => {
    return localStorage.getItem('gaushakthi_token');
  });

  const [refreshToken, setRefreshTokenState] = useState<string | null>(() => {
    return localStorage.getItem('gaushakthi_refresh_token');
  });

  const [user, setUser] = useState<User | null>(() => {
    const saved = localStorage.getItem('gaushakthi_user');
    return saved ? JSON.parse(saved) : null;
  });

  const [isOfflineMode, setIsOfflineMode] = useState<boolean>(!navigator.onLine);
  const [language, setLanguageState] = useState<AppLanguage>(user?.preferredLanguage || 'en');
  const [theme, setTheme] = useState<'light' | 'dark'>(() => {
    return (localStorage.getItem('gaushakthi_theme') as 'light' | 'dark') || 'light';
  });

  // Track online/offline status for offline session access
  useEffect(() => {
    const handleOnline = () => {
      setIsOfflineMode(false);
      // Synchronize pending offline changes when connection returns
      offlineSyncService.syncPendingQueue();
    };

    const handleOffline = () => {
      setIsOfflineMode(true);
    };

    window.addEventListener('online', handleOnline);
    window.addEventListener('offline', handleOffline);

    return () => {
      window.removeEventListener('online', handleOnline);
      window.removeEventListener('offline', handleOffline);
    };
  }, []);

  useEffect(() => {
    if (theme === 'dark') {
      document.documentElement.classList.add('dark');
    } else {
      document.documentElement.classList.remove('dark');
    }
    localStorage.setItem('gaushakthi_theme', theme);
  }, [theme]);

  const toggleTheme = () => {
    setTheme((prev) => (prev === 'light' ? 'dark' : 'light'));
  };

  const setLanguage = (newLang: AppLanguage) => {
    setLanguageState(newLang);
    if (user) {
      const updated = { ...user, preferredLanguage: newLang };
      setUser(updated);
      localStorage.setItem('gaushakthi_user', JSON.stringify(updated));
    }
  };

  // Translation helper function
  const t = (key: keyof typeof translations.en): string => {
    const langDict = translations[language as Language] || translations.en;
    return (langDict as any)[key] || translations.en[key] || key;
  };

  const loginWithJWT = (newUser: User, accessToken: string, newRefreshToken?: string) => {
    // Force role to 'farmer' - all users in system are Farmers
    const farmerUser = { ...newUser, role: 'farmer' as const };
    setUser(farmerUser);
    setToken(accessToken);
    localStorage.setItem('gaushakthi_user', JSON.stringify(farmerUser));
    localStorage.setItem('gaushakthi_token', accessToken);
    if (newRefreshToken) {
      setRefreshTokenState(newRefreshToken);
      localStorage.setItem('gaushakthi_refresh_token', newRefreshToken);
    }
  };

  const login = (phone: string, name?: string) => {
    const newUser: User = {
      id: 'farmer-' + Date.now(),
      name: name || 'Thiru',
      phone,
      role: 'farmer',
      district: 'Coimbatore',
      state: 'Tamil Nadu',
      preferredLanguage: language,
    };
    const mockToken = `jwt_access_token_${Date.now()}`;
    const mockRefresh = `jwt_refresh_token_${Date.now()}`;
    loginWithJWT(newUser, mockToken, mockRefresh);
  };

  const logout = () => {
    setUser(null);
    setToken(null);
    setRefreshTokenState(null);
    localStorage.removeItem('gaushakthi_user');
    localStorage.removeItem('gaushakthi_token');
    localStorage.removeItem('gaushakthi_refresh_token');
    localStorage.removeItem('pasumitra_user');
  };

  return (
    <AuthContext.Provider
      value={{
        user,
        token,
        refreshToken,
        language,
        theme,
        isAuthenticated: (!!token || isOfflineMode) && !!user,
        isOfflineMode,
        setLanguage,
        toggleTheme,
        t,
        loginWithJWT,
        login,
        logout,
      }}
    >
      {children}
    </AuthContext.Provider>
  );
};

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};
