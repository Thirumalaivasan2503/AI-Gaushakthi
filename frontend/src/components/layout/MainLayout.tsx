import React, { useState } from 'react';
import { Outlet } from 'react-router-dom';
import { Navbar } from './Navbar';
import { Sidebar } from './Sidebar';
import { WeatherTHIWidget } from '../widgets/WeatherTHIWidget';
import { VoiceAssistantDrawer } from '../widgets/VoiceAssistantDrawer';

export const MainLayout: React.FC = () => {
  const [sidebarOpen, setSidebarOpen] = useState(false);
  const [assistantOpen, setAssistantOpen] = useState(false);

  return (
    <div className="min-h-screen bg-slate-50 dark:bg-slate-950 flex flex-col font-sans transition-colors">
      {/* Top Navbar */}
      <Navbar
        onToggleSidebar={() => setSidebarOpen(!sidebarOpen)}
        onOpenAssistant={() => setAssistantOpen(true)}
      />

      {/* Main Container */}
      <div className="flex-1 flex max-w-7xl w-full mx-auto px-4 sm:px-6 lg:px-8 py-6">
        {/* Navigation Sidebar */}
        <Sidebar isOpen={sidebarOpen} onClose={() => setSidebarOpen(false)} />

        {/* Content Body Area */}
        <main className="flex-1 lg:pl-64 space-y-6 w-full min-w-0">
          {/* Top Weather & THI Alert Banner */}
          <WeatherTHIWidget />

          {/* Page View Outlet */}
          <div className="animate-in fade-in duration-200">
            <Outlet />
          </div>
        </main>
      </div>

      {/* Slide-out Voice Assistant Drawer */}
      <VoiceAssistantDrawer
        isOpen={assistantOpen}
        onClose={() => setAssistantOpen(false)}
      />
    </div>
  );
};
