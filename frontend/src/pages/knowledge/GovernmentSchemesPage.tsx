import React, { useState } from 'react';
import { Search, ShieldCheck, ExternalLink, Award, Sparkles, CheckCircle2, Globe, Copy, Check } from 'lucide-react';
import { GovernmentScheme } from '../../types';

export const GovernmentSchemesPage: React.FC = () => {
  const [search, setSearch] = useState('');
  const [copiedId, setCopiedId] = useState<string | null>(null);

  const schemes: (GovernmentScheme & { portal_name: string; portal_url: string })[] = [
    {
      id: 'sch-cow-portal',
      title: 'e-Pashuhaat - National Indian Cattle & Cow Breed Directory Portal',
      category: 'Official National Cattle Portal',
      funding_percentage: 'Direct Trade & Breed Registry',
      sponsoring_body: 'Department of Animal Husbandry & Dairying (DAHD), Govt of India',
      eligibility: 'All Indian dairy farmers, cattle breeders, and entrepreneurs specializing in indigenous cow breeds.',
      description: 'The official national web portal to facilitate direct connection between breeders and farmers for purchasing certified disease-free indigenous cattle breeds (Kangayam, Gir, Sahiwal, etc.), high-quality frozen bovine semen, and embryos.',
      portal_name: 'e-Pashuhaat Portal',
      portal_url: 'https://epashuhaat.gov.in/',
      apply_url: 'https://epashuhaat.gov.in/',
    },
    {
      id: 'sch-1',
      title: 'Rashtriya Gokul Mission (RGM) - Indigenous Breed Development',
      category: 'Indigenous Breed Development',
      funding_percentage: '50% Capital Subsidy (Up to ₹50 Lakhs)',
      sponsoring_body: 'Ministry of Fisheries, Animal Husbandry & Dairying, Govt of India',
      eligibility: 'Farmers, FPOs, and SHGs maintaining registered indigenous cattle breeds (Kangayam, Umblachery, Bargur, Gir, Sahiwal).',
      description: 'Promotes indigenous breed conservation, establishment of Gokul Grams, heifer rearing incentives, and high-quality A2 semen straw distribution.',
      portal_name: 'DAHD Official Portal (dahd.nic.in)',
      portal_url: 'https://dahd.nic.in/',
      apply_url: 'https://dahd.nic.in/schemes/programmes/rashtriya-gokul-mission',
    },
    {
      id: 'sch-2',
      title: 'National Livestock Mission (NLM) - Breed Entrepreneurship Scheme',
      category: 'Livestock Entrepreneurship Subsidy',
      funding_percentage: '50% Subsidy (Up to ₹50 Lakhs)',
      sponsoring_body: 'Department of Animal Husbandry & Dairying (DAHD) / Udyamimitra',
      eligibility: 'Individual Farmers, FPOs, JLGs, and Private Entrepreneurs setting up native cattle (cow) breeding units.',
      description: 'Capital subsidy for establishing indigenous cattle breeding farms, fodder production units, and artificial insemination centers.',
      portal_name: 'NLM Udyamimitra Official Portal',
      portal_url: 'https://nlm.udyamimitra.in/',
      apply_url: 'https://nlm.udyamimitra.in/',
    },
    {
      id: 'sch-3',
      title: 'Tamil Nadu Native Cattle Preservation Incentive & Heifer Assistance',
      category: 'A2 Native Cattle Subsidy',
      funding_percentage: '₹5,000 per indigenous calf + Free AI A2 Semen Straws',
      sponsoring_body: 'Tamil Nadu Department of Animal Husbandry & Veterinary Services',
      eligibility: 'Farmers rearing Kangayam, Umblachery, Bargur, or Pulikulam cows in Tamil Nadu (Coimbatore, Erode, Tiruppur, Tanjore, Salem).',
      description: 'Financial incentive for rearing pure indigenous cattle calves, free veterinary checkups, vaccination, and A2 milk promotion.',
      portal_name: 'TN Animal Husbandry Department Portal',
      portal_url: 'https://aah.tn.gov.in/',
      apply_url: 'https://www.tn.gov.in/department/1',
    },
    {
      id: 'sch-4',
      title: 'NABARD Livestock Development & Capital Subsidy Scheme',
      category: 'NABARD Agricultural Credit & Subsidy',
      funding_percentage: '25% to 33.33% Capital Subsidy',
      sponsoring_body: 'National Bank for Agriculture and Rural Development (NABARD)',
      eligibility: 'Small and marginal farmers, dairy cooperatives, and rural livestock breeders.',
      description: 'Provides low-interest credit and capital subsidy for purchasing native cows, constructing cattle sheds, and buying milking equipment.',
      portal_name: 'NABARD Official Portal',
      portal_url: 'https://www.nabard.org/',
      apply_url: 'https://www.nabard.org/',
    },
  ];

  const filtered = schemes.filter(
    (s) =>
      s.title.toLowerCase().includes(search.toLowerCase()) ||
      s.category.toLowerCase().includes(search.toLowerCase()) ||
      s.sponsoring_body.toLowerCase().includes(search.toLowerCase())
  );

  const handleCopyLink = (url: string, id: string) => {
    navigator.clipboard.writeText(url);
    setCopiedId(id);
    setTimeout(() => setCopiedId(null), 2000);
  };

  return (
    <div className="space-y-6 max-w-4xl mx-auto font-sans">
      {/* Title Header */}
      <div className="bg-gradient-to-r from-emerald-800 to-teal-800 p-6 sm:p-8 rounded-3xl text-white shadow-xl space-y-2">
        <div className="flex items-center space-x-2">
          <span className="px-3 py-1 bg-amber-400/20 text-amber-300 border border-amber-400/30 rounded-full text-xs font-bold uppercase tracking-wider">
            🏛️ Official Government Portal Directory
          </span>
        </div>
        <h1 className="text-xl sm:text-2xl font-black">Government Subsidies & Breed Schemes</h1>
        <p className="text-xs sm:text-sm text-emerald-100/90 font-medium">
          Access Rashtriya Gokul Mission (RGM), National Livestock Mission (NLM), TN Native Cattle Incentives, and NABARD Subsidies directly.
        </p>
      </div>

      {/* Search Input */}
      <div className="relative">
        <Search className="w-4 h-4 text-slate-400 absolute left-3.5 top-3.5" />
        <input
          type="text"
          placeholder="Search schemes by name, category, or government body..."
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          className="w-full bg-white dark:bg-slate-900 text-xs px-4 pl-10 py-3 rounded-2xl border border-slate-200 dark:border-slate-800 text-slate-900 dark:text-white focus:outline-none focus:ring-2 focus:ring-emerald-500 shadow-xs font-medium"
        />
      </div>

      {/* Scheme Cards List */}
      <div className="space-y-4">
        {filtered.map((sch) => (
          <div
            key={sch.id}
            className="bg-white dark:bg-slate-900 rounded-3xl p-6 border border-slate-200 dark:border-slate-800 shadow-sm space-y-4 hover:border-emerald-500/40 transition"
          >
            <div className="flex items-center justify-between flex-wrap gap-2">
              <span className="text-[10px] font-extrabold px-3 py-1 rounded-full bg-emerald-100 text-emerald-900 dark:bg-emerald-950 dark:text-emerald-300 border border-emerald-300/40">
                {sch.category}
              </span>
              <span className="text-xs font-black text-amber-600 dark:text-amber-400 bg-amber-50 dark:bg-amber-950/60 px-3 py-1 rounded-full border border-amber-400/30">
                {sch.funding_percentage}
              </span>
            </div>

            <h3 className="font-extrabold text-base text-slate-900 dark:text-white leading-snug">{sch.title}</h3>
            <p className="text-xs text-slate-500 font-semibold flex items-center space-x-1">
              <ShieldCheck className="w-3.5 h-3.5 text-emerald-600 dark:text-emerald-400" />
              <span>Sponsoring Authority: {sch.sponsoring_body}</span>
            </p>

            <p className="text-xs text-slate-600 dark:text-slate-300 leading-relaxed font-normal">{sch.description}</p>

            <div className="bg-slate-50 dark:bg-slate-800/70 p-3.5 rounded-2xl border border-slate-100 dark:border-slate-800 text-xs text-slate-600 dark:text-slate-300 space-y-1">
              <strong className="block font-bold text-slate-900 dark:text-white">Eligibility Criteria:</strong>
              <p className="text-[11px] text-slate-500 dark:text-slate-400 leading-normal">{sch.eligibility}</p>
            </div>

            {/* Application Portal Action Buttons */}
            <div className="pt-2 flex flex-wrap items-center gap-3">
              {/* Primary Direct Open Portal Link */}
              <a
                href={sch.apply_url || sch.portal_url}
                target="_blank"
                rel="noopener noreferrer"
                className="px-4 py-2.5 rounded-xl bg-gradient-to-r from-emerald-600 to-teal-600 hover:from-emerald-500 hover:to-teal-500 text-white font-extrabold text-xs shadow-md shadow-emerald-500/20 transition flex items-center space-x-2 cursor-pointer no-underline"
              >
                <span>🚀 Open Official Application Portal</span>
                <ExternalLink className="w-3.5 h-3.5" />
              </a>

              {/* Secondary Alternate Direct Link */}
              <a
                href={sch.portal_url}
                target="_blank"
                rel="noopener noreferrer"
                className="px-3 py-2.5 rounded-xl bg-slate-100 dark:bg-slate-800 hover:bg-slate-200 dark:hover:bg-slate-700 text-slate-700 dark:text-slate-200 font-bold text-xs border border-slate-200 dark:border-slate-700 transition flex items-center space-x-1.5 cursor-pointer no-underline"
              >
                <Globe className="w-3.5 h-3.5 text-emerald-500" />
                <span>{sch.portal_name}</span>
              </a>

              {/* Copy URL Option */}
              <button
                type="button"
                onClick={() => handleCopyLink(sch.apply_url || sch.portal_url, sch.id)}
                className="px-3 py-2.5 rounded-xl bg-slate-100 dark:bg-slate-800 hover:bg-slate-200 dark:hover:bg-slate-700 text-slate-500 dark:text-slate-400 hover:text-slate-800 dark:hover:text-white font-semibold text-xs transition flex items-center space-x-1 cursor-pointer"
                title="Copy Official Website URL"
              >
                {copiedId === sch.id ? (
                  <>
                    <Check className="w-3.5 h-3.5 text-emerald-500" />
                    <span className="text-emerald-600 dark:text-emerald-400 font-bold">Copied!</span>
                  </>
                ) : (
                  <>
                    <Copy className="w-3.5 h-3.5" />
                    <span>Copy Link</span>
                  </>
                )}
              </button>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

