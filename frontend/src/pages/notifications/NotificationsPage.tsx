import React from 'react';
import { Bell, Sun, ShieldAlert, Sparkles } from 'lucide-react';

export const NotificationsPage: React.FC = () => {
  const notifications = [
    {
      id: 'notif-1',
      title: 'THI Heat Stress Warning (Level 3)',
      desc: 'THI threshold expected to reach 82.4 in Coimbatore region today between 12 PM - 4 PM. Ensure shaded pens & fresh drinking water.',
      time: '10 mins ago',
      type: 'warning',
    },
    {
      id: 'notif-2',
      title: 'FMD Vaccination Reminder',
      desc: 'Umblachery Cow #102 is due for Foot and Mouth Disease polyvalent vaccination booster.',
      time: '2 hours ago',
      type: 'medical',
    },
    {
      id: 'notif-3',
      title: 'Rashtriya Gokul Mission Subsidy Scheme Active',
      desc: 'New capital subsidy notification released for indigenous breed conservation.',
      time: '1 day ago',
      type: 'info',
    },
  ];

  return (
    <div className="max-w-2xl mx-auto space-y-6">
      <div>
        <h1 className="text-xl font-bold text-slate-900 dark:text-white">System Notifications</h1>
        <p className="text-xs text-slate-500 dark:text-slate-400">Heat stress alerts, medical reminders & government scheme updates</p>
      </div>

      <div className="space-y-3">
        {notifications.map((n) => (
          <div key={n.id} className="bg-white dark:bg-slate-900 rounded-3xl p-5 border border-slate-200 dark:border-slate-800 shadow-xs flex items-start space-x-4">
            <div className="w-10 h-10 rounded-2xl bg-amber-100 dark:bg-amber-950 text-amber-600 flex items-center justify-center shrink-0 mt-0.5">
              <Bell className="w-5 h-5" />
            </div>
            <div className="flex-1">
              <div className="flex items-center justify-between">
                <h3 className="font-bold text-xs text-slate-900 dark:text-white">{n.title}</h3>
                <span className="text-[10px] text-slate-400">{n.time}</span>
              </div>
              <p className="text-xs text-slate-600 dark:text-slate-300 mt-1 leading-relaxed">{n.desc}</p>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};
