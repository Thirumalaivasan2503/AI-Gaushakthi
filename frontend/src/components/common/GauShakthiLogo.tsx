import React, { useState } from 'react';
import { useAuth } from '../../context/AuthContext';

interface GauShakthiLogoProps {
  className?: string;
  size?: 'sm' | 'md' | 'lg' | 'xl';
  showText?: boolean;
  textClassName?: string;
}

export const GauShakthiLogo: React.FC<GauShakthiLogoProps> = ({
  className = '',
  size = 'md',
  showText = true,
  textClassName = '',
}) => {
  const { language, t } = useAuth();
  const [imgError, setImgError] = useState(false);

  const dimensions = {
    sm: 'w-8 h-8',
    md: 'w-10 h-10',
    lg: 'w-12 h-12',
    xl: 'w-16 h-16',
  }[size];

  // Dynamic brand name display based on language
  const brandTitle = language === 'ta' ? 'கௌசக்தி' : language === 'hi' ? 'गौशक्ति' : 'GauShakthi';
  const brandTagline = language === 'ta' ? 'பாரம்பரிய கால்நடை AI' : language === 'hi' ? 'स्वदेशी पशुधन AI' : 'Indigenous Livestock AI';

  return (
    <div className={`flex items-center space-x-3 ${className}`}>
      {/* Logo Icon Container */}
      <div className={`relative ${dimensions} shrink-0 rounded-2xl bg-gradient-to-tr from-emerald-600 via-teal-500 to-amber-500 p-0.5 shadow-md shadow-emerald-500/25 transition-transform hover:scale-105`}>
        <div className="w-full h-full bg-white dark:bg-slate-900 rounded-[14px] flex items-center justify-center overflow-hidden p-1">
          {!imgError ? (
            <img
              src="/gaushakthi_logo.png"
              alt="GauShakthi Logo"
              className="w-full h-full object-contain drop-shadow-sm rounded-xl"
              onError={() => setImgError(true)}
            />
          ) : (
            <svg
              viewBox="0 0 100 100"
              fill="none"
              xmlns="http://www.w3.org/2000/svg"
              className="w-full h-full text-emerald-600 dark:text-emerald-400"
            >
              <circle cx="50" cy="50" r="42" stroke="url(#goldGrad)" strokeWidth="3" strokeDasharray="4 3" opacity="0.7" />
              <path
                d="M 28 36 C 24 22, 36 14, 42 24 C 44 27, 46 32, 50 34 C 54 32, 56 27, 58 24 C 64 14, 76 22, 72 36"
                stroke="url(#emeraldGrad)"
                strokeWidth="5"
                strokeLinecap="round"
              />
              <path d="M 26 44 C 14 42, 18 54, 30 52 Z" fill="url(#goldGrad)" />
              <path d="M 74 44 C 86 42, 82 54, 70 52 Z" fill="url(#goldGrad)" />
              <path
                d="M 32 40 L 68 40 C 68 40, 64 62, 58 72 C 54 78, 46 78, 42 72 C 36 62, 32 40, 32 40 Z"
                fill="url(#emeraldGrad)"
              />
              <path
                d="M 50 42 L 53 49 L 60 50 L 54 55 L 56 62 L 50 58 L 44 62 L 46 55 L 40 50 L 47 49 Z"
                fill="#F59E0B"
              />
              <circle cx="50" cy="68" r="4" fill="#10B981" />
              <defs>
                <linearGradient id="emeraldGrad" x1="0%" y1="0%" x2="100%" y2="100%">
                  <stop offset="0%" stopColor="#34D399" />
                  <stop offset="100%" stopColor="#059669" />
                </linearGradient>
                <linearGradient id="goldGrad" x1="0%" y1="0%" x2="100%" y2="100%">
                  <stop offset="0%" stopColor="#FBBF24" />
                  <stop offset="100%" stopColor="#D97706" />
                </linearGradient>
              </defs>
            </svg>
          )}
        </div>
      </div>

      {/* Brand Typography */}
      {showText && (
        <div className={textClassName}>
          <span className="font-extrabold text-base sm:text-lg text-slate-900 dark:text-white tracking-tight block leading-tight">
            {language === 'en' ? (
              <>
                Gau<span className="text-emerald-600 dark:text-emerald-400">Shakthi</span>{' '}
                <span className="text-xs bg-emerald-100 dark:bg-emerald-950 text-emerald-700 dark:text-emerald-300 font-bold px-1.5 py-0.5 rounded-md align-middle">
                  AI
                </span>
              </>
            ) : (
              <>
                {brandTitle}{' '}
                <span className="text-xs bg-emerald-100 dark:bg-emerald-950 text-emerald-700 dark:text-emerald-300 font-bold px-1.5 py-0.5 rounded-md align-middle">
                  AI
                </span>
              </>
            )}
          </span>
          <span className="block text-[10px] text-slate-500 dark:text-slate-400 font-bold tracking-wider">
            {brandTagline}
          </span>
        </div>
      )}
    </div>
  );
};
