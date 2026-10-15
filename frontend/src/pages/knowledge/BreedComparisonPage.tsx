import React, { useState } from 'react';
import { useAuth } from '../../context/AuthContext';
import { Award, CheckCircle2, AlertTriangle, Sparkles, TrendingUp, HeartPulse } from 'lucide-react';

export const BreedComparisonPage: React.FC = () => {
  const { t } = useAuth();

  const [nativeBreed, setNativeBreed] = useState('kangayam');
  const [foreignBreed, setForeignBreed] = useState('hf');

  const nativeBreedsData: Record<string, any> = {
    kangayam: {
      name: 'Kangayam Cattle (Native Indigenous)',
      origin: 'Kongu Nadu, Tamil Nadu (Coimbatore, Erode, Tiruppur)',
      proteinType: 'A2 Beta-Casein (Non-inflammatory, premium health market value)',
      heatTolerance: 'Exceptional (Resistant to 48°C dry heat, THI threshold > 88)',
      feedCost: 'Low (₹120/day) - Efficient roughage & dry fodder converter',
      diseaseImmunity: 'Superior - Naturally immune to ticks, FMD, and tropical parasites',
      draftValue: 'High Draft - Unmatched endurance in hard soil ploughing',
      lactationCycles: '12 - 15 lactations over 20 year productive lifespan',
      recommendationVerdict: 'RECOMMENDED (100% Native Winner for Sustainable Farming)',
    },
    umblachery: {
      name: 'Umblachery Cattle (Native Indigenous)',
      origin: 'Tanjore Delta, Tamil Nadu (Thanjavur, Nagapattinam)',
      proteinType: 'A2 Beta-Casein (High SNF & digestible fat)',
      heatTolerance: 'Superior (Adapted to marshy, high humidity & coastal heat)',
      feedCost: 'Very Low (₹95/day) - Compact frame with minimal fodder',
      diseaseImmunity: 'Exceptional - Foot rot & flood infection resistant',
      draftValue: 'Wetland Draft - Specialized for paddy field ploughing',
      lactationCycles: '10 - 14 lactations over 18 year lifespan',
      recommendationVerdict: 'RECOMMENDED (Ideal for Coastal & Delta Regions)',
    },
    gir: {
      name: 'Gir Cow (Native Indigenous)',
      origin: 'Gir Hills, Gujarat',
      proteinType: 'A2 Beta-Casein (High milk yield up to 1800 - 2400 L/lactation)',
      heatTolerance: 'High (Tropical heat tolerant, humped heat dissipation)',
      feedCost: 'Moderate (₹160/day) - Low maintenance compared to exotics',
      diseaseImmunity: 'High natural disease & tick resistance',
      draftValue: 'Dual Purpose (Rich A2 Dairy & Good Draft)',
      lactationCycles: '10 - 12 lactations',
      recommendationVerdict: 'RECOMMENDED (Top Choice for A2 Dairy Revenue)',
    },
    sahiwal: {
      name: 'Sahiwal Cow (Native Indigenous)',
      origin: 'Punjab & Haryana Belt',
      proteinType: 'A2 Beta-Casein (High fat milk & gentle temperament)',
      heatTolerance: 'Exceptional (High thermotolerance during peak summer)',
      feedCost: 'Moderate (₹165/day) - High milk conversion ratio',
      diseaseImmunity: 'High resistance to mastitis & tick fever',
      draftValue: 'Milch & Dual Purpose',
      lactationCycles: '10 - 13 lactations',
      recommendationVerdict: 'RECOMMENDED (Best High-Yield Indigenous Milch Cow)',
    },
    bargur: {
      name: 'Bargur Cattle (Native Indigenous)',
      origin: 'Bargur Hills, Erode District, Tamil Nadu',
      proteinType: 'A2 Beta-Casein (Medicinal native milk properties)',
      heatTolerance: 'Exceptional (Adapted to stony hill slopes & drought)',
      feedCost: 'Very Low (₹90/day) - Thrives on forest grazing',
      diseaseImmunity: 'Superior - Foot rot and viral infection immune',
      draftValue: 'Hill Terrain Draft & Speed',
      lactationCycles: '12 - 16 lactations',
      recommendationVerdict: 'RECOMMENDED (Lowest Maintenance & High Hill Agility)',
    },
    pulikulam: {
      name: 'Pulikulam Cattle (Native Indigenous)',
      origin: 'Madurai, Sivagangai, Dindigul, Tamil Nadu',
      proteinType: 'A2 Beta-Casein Milk',
      heatTolerance: 'Exceptional (Survives severe dryland summer drought)',
      feedCost: 'Low (₹100/day) - Grazes on dry scrubland',
      diseaseImmunity: 'High natural resistance & aggressive herd protection',
      draftValue: 'Draught & Pen Manure Production',
      lactationCycles: '11 - 15 lactations',
      recommendationVerdict: 'RECOMMENDED (Heritage Tamil Native Breed)',
    },
    hallikar: {
      name: 'Hallikar Cattle (Native Indigenous)',
      origin: 'Mysore, Hassan, Mandya, Karnataka',
      proteinType: 'A2 Beta-Casein',
      heatTolerance: 'High (Semi-arid plateau heat resistant)',
      feedCost: 'Low (₹115/day)',
      diseaseImmunity: 'High resistance to tropical blood parasites',
      draftValue: 'Premier South Indian Trotter & Hard Soil Draft',
      lactationCycles: '11 - 14 lactations',
      recommendationVerdict: 'RECOMMENDED (Premier South Indian Draft Breed)',
    },
    vechur: {
      name: 'Vechur Cow (Native Indigenous)',
      origin: 'Kottayam, Kerala (Guinness Record Smallest Cow)',
      proteinType: 'Medicinal A2 Milk (Small fat globules for easy digestion)',
      heatTolerance: 'Superior (Thrives in hot humid tropical climate)',
      feedCost: 'Lowest (₹40/day) - Eats 1/4th fodder of standard cow',
      diseaseImmunity: 'Exceptional - Zero Mastitis & Respiratory Illness',
      draftValue: 'Household Dairy & Organic Farming',
      lactationCycles: '14 - 18 lactations over 22 year lifespan',
      recommendationVerdict: 'RECOMMENDED (Smallest Native Medicinal A2 Cow)',
    },
    tharparkar: {
      name: 'Tharparkar Cow (Native Indigenous)',
      origin: 'Thar Desert, Rajasthan & Kutch',
      proteinType: 'A2 White Pearl Protein',
      heatTolerance: 'Extreme (White coat reflects sun glare, survives 50°C)',
      feedCost: 'Low (₹135/day) - Converts dry desert vegetation',
      diseaseImmunity: 'Exceptional Tick & Parasite Immunity',
      draftValue: 'Dual Purpose (High Milk & Desert Draft)',
      lactationCycles: '12 - 15 lactations',
      recommendationVerdict: 'RECOMMENDED (Extreme Famine & Heat Resilient)',
    },
    rathi: {
      name: 'Rathi Cow (Native Indigenous)',
      origin: 'Bikaner & Jaisalmer, Rajasthan',
      proteinType: 'A2 Beta-Casein High Milch Yield',
      heatTolerance: 'Exceptional (Survives 2°C winter to 49°C summer)',
      feedCost: 'Low (₹130/day)',
      diseaseImmunity: 'High natural disease resistance',
      draftValue: 'Milch & Dual Purpose',
      lactationCycles: '10 - 13 lactations',
      recommendationVerdict: 'RECOMMENDED (Desert Milch Breed Winner)',
    },
    red_sindhi: {
      name: 'Red Sindhi Cow (Native Indigenous)',
      origin: 'Sindh / Pan-India Breeding Centers',
      proteinType: 'High Butterfat A2 Beta-Casein',
      heatTolerance: 'High Thermotolerance across all Indian states',
      feedCost: 'Moderate (₹150/day)',
      diseaseImmunity: 'High tick & mastitis resistance',
      draftValue: 'Dual Purpose Milch Breed',
      lactationCycles: '10 - 12 lactations',
      recommendationVerdict: 'RECOMMENDED (Highly Adaptable Native Dairy Cow)',
    },
  };

  const foreignBreedsData: Record<string, any> = {
    hf: {
      name: 'Holstein Friesian HF (Foreign Exotic)',
      origin: 'Netherlands / Europe',
      proteinType: 'A1 Protein (Linked to digestive intolerance & inflammation)',
      heatTolerance: 'Poor (Suffers severe heat stress above 30°C, sharp yield drop)',
      feedCost: 'Very High (₹350/day) - Requires costly green fodder & concentrates',
      diseaseImmunity: 'Low - Highly susceptible to Mastitis, Tick fever, and Foot rot',
      draftValue: 'Zero Draft Value (Unsuited for field ploughing)',
      lactationCycles: '3 - 5 short lactations due to early culling',
      recommendationVerdict: 'NOT RECOMMENDED for Indian Agro-Climate',
    },
    jersey: {
      name: 'Jersey Cross (Foreign Exotic)',
      origin: 'Jersey Island, UK',
      proteinType: 'A1 / Mixed Protein (Standard market milk)',
      heatTolerance: 'Moderate (Requires fans/mist coolers in hot summer)',
      feedCost: 'High (₹280/day) - Requires balanced concentrate ration',
      diseaseImmunity: 'Moderate - Prone to udder infections & tick infestation',
      draftValue: 'Zero Draft Value',
      lactationCycles: '4 - 6 lactations',
      recommendationVerdict: 'NOT RECOMMENDED (High Veterinary & Feed Costs)',
    },
    brown_swiss: {
      name: 'Brown Swiss (Foreign Exotic)',
      origin: 'Alpine Switzerland',
      proteinType: 'A1 Protein',
      heatTolerance: 'Poor (Alpine cold climate breed, heavy heat stress)',
      feedCost: 'High (₹320/day)',
      diseaseImmunity: 'Low - Prone to heat exhaustion and tick fever',
      draftValue: 'Zero Draft Value in tropics',
      lactationCycles: '4 - 5 lactations',
      recommendationVerdict: 'NOT RECOMMENDED (Requires Cold Climate Infrastructure)',
    },
  };

  const currentNative = nativeBreedsData[nativeBreed] || nativeBreedsData['kangayam'];
  const currentForeign = foreignBreedsData[foreignBreed] || foreignBreedsData['hf'];

  return (
    <div className="space-y-6 max-w-5xl mx-auto font-sans">
      {/* Banner */}
      <div className="bg-gradient-to-r from-emerald-800 via-emerald-900 to-teal-900 text-white p-6 sm:p-8 rounded-3xl shadow-xl space-y-3 relative overflow-hidden">
        <div className="flex items-center space-x-2">
          <span className="px-3 py-1 bg-amber-400/20 text-amber-300 border border-amber-400/30 rounded-full text-xs font-bold uppercase tracking-wider inline-flex items-center space-x-1">
            <Sparkles className="w-3.5 h-3.5 text-amber-400" />
            <span>Indigenous Breed Promotion & Genetic Analysis</span>
          </span>
        </div>
        <h1 className="text-2xl sm:text-3xl font-extrabold">{t('compareTitle')}</h1>
        <p className="text-xs sm:text-sm text-emerald-100/90 leading-relaxed font-medium">
          Compare 11+ Indigenous Native Cattle breeds against Foreign Exotic breeds. GauShakthi promotes native indigenous cattle for superior heat tolerance, low maintenance, A2 milk, and long-term farmer profitability.
        </p>
      </div>

      {/* Prominent Indigenous Winner Suggestion Banner */}
      <div className="bg-gradient-to-r from-emerald-950 via-slate-900 to-teal-950 border-2 border-emerald-500/60 rounded-3xl p-6 shadow-2xl text-white space-y-4">
        <div className="flex items-center justify-between flex-wrap gap-2">
          <div className="flex items-center space-x-3">
            <div className="w-12 h-12 rounded-2xl bg-amber-400/20 text-amber-400 flex items-center justify-center shrink-0 border border-amber-400/40">
              <Award className="w-6 h-6" />
            </div>
            <div>
              <span className="text-[10px] font-bold uppercase tracking-wider text-amber-300">
                GauShakthi AI Final Verdict
              </span>
              <h2 className="text-lg sm:text-xl font-black text-emerald-300">
                🏆 Indigenous Native Cattle Recommended!
              </h2>
            </div>
          </div>
          <span className="px-3 py-1 bg-emerald-500/20 text-emerald-300 rounded-full text-xs font-extrabold border border-emerald-400/40">
            100% Sustainable Choice
          </span>
        </div>

        <p className="text-xs text-slate-300 leading-relaxed font-medium">
          Our genetic model strongly suggests choosing **{currentNative.name}** over **{currentForeign.name}**. Native cattle require 40% less fodder cost, provide naturally healthy A2 Beta-Casein milk, suffer zero heat stress in hot climates, and live up to 3x longer productive lifespans.
        </p>

        <div className="grid grid-cols-1 sm:grid-cols-3 gap-3 pt-2">
          <div className="bg-emerald-900/40 p-3 rounded-2xl border border-emerald-500/30 text-xs">
            <div className="flex items-center space-x-1.5 text-emerald-300 font-bold mb-1">
              <CheckCircle2 className="w-4 h-4 text-emerald-400" />
              <span>A2 Health Milk</span>
            </div>
            <p className="text-[11px] text-slate-300">Non-inflammatory A2 beta-casein protein with high market value.</p>
          </div>

          <div className="bg-emerald-900/40 p-3 rounded-2xl border border-emerald-500/30 text-xs">
            <div className="flex items-center space-x-1.5 text-emerald-300 font-bold mb-1">
              <TrendingUp className="w-4 h-4 text-emerald-400" />
              <span>35% Lower Feed Cost</span>
            </div>
            <p className="text-[11px] text-slate-300">Converts dry roughage efficiently without expensive concentrates.</p>
          </div>

          <div className="bg-emerald-900/40 p-3 rounded-2xl border border-emerald-500/30 text-xs">
            <div className="flex items-center space-x-1.5 text-emerald-300 font-bold mb-1">
              <HeartPulse className="w-4 h-4 text-emerald-400" />
              <span>Zero Vet Bill Stress</span>
            </div>
            <p className="text-[11px] text-slate-300">High natural immunity to tick fever, FMD, and tropical diseases.</p>
          </div>
        </div>
      </div>

      {/* Selectors */}
      <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
        <div className="bg-white dark:bg-slate-900 p-5 rounded-3xl border-2 border-emerald-500 shadow-md space-y-2">
          <label className="block text-xs font-extrabold text-emerald-700 dark:text-emerald-400 uppercase tracking-wider flex items-center space-x-1">
            <CheckCircle2 className="w-4 h-4 text-emerald-500" />
            <span>Select Native Indigenous Cattle (Recommended)</span>
          </label>
          <select
            value={nativeBreed}
            onChange={(e) => setNativeBreed(e.target.value)}
            className="w-full bg-emerald-50 dark:bg-emerald-950/70 border border-emerald-300 dark:border-emerald-700 text-slate-900 dark:text-white text-xs rounded-xl px-3 py-2.5 font-bold focus:outline-none focus:ring-2 focus:ring-emerald-500"
          >
            <option value="kangayam">Kangayam Cattle (Kongu Region, TN / Draft & Dairy)</option>
            <option value="umblachery">Umblachery Cattle (Tanjore Delta, TN / Wetland Draft)</option>
            <option value="gir">Gir Cow (Gujarat / Premier A2 Dairy)</option>
            <option value="sahiwal">Sahiwal Cow (Punjab / High Yield A2 Milch)</option>
            <option value="bargur">Bargur Cattle (Erode Hills, TN / Low Feed Hill Agility)</option>
            <option value="pulikulam">Pulikulam Cattle (Madurai, TN / Drought Resilient)</option>
            <option value="hallikar">Hallikar Cattle (Karnataka / Premier South Indian Draft)</option>
            <option value="vechur">Vechur Cow (Kerala / Medicinal Smallest A2 Cow)</option>
            <option value="tharparkar">Tharparkar Cow (Rajasthan / Desert White Pearl A2)</option>
            <option value="rathi">Rathi Cow (Rajasthan Desert / High Milch)</option>
            <option value="red_sindhi">Red Sindhi Cow (Subtropical / Butterfat A2)</option>
          </select>
        </div>

        <div className="bg-white dark:bg-slate-900 p-5 rounded-3xl border border-rose-300 dark:border-rose-900 shadow-xs space-y-2 opacity-90">
          <label className="block text-xs font-bold text-rose-600 dark:text-rose-400 uppercase tracking-wider flex items-center space-x-1">
            <AlertTriangle className="w-4 h-4 text-rose-500" />
            <span>Select Foreign / Exotic Breed (For Comparison)</span>
          </label>
          <select
            value={foreignBreed}
            onChange={(e) => setForeignBreed(e.target.value)}
            className="w-full bg-rose-50 dark:bg-rose-950/60 border border-rose-300 dark:border-rose-900 text-slate-900 dark:text-white text-xs rounded-xl px-3 py-2.5 font-bold focus:outline-none"
          >
            <option value="hf">Holstein Friesian HF (Netherlands / Exotic A1)</option>
            <option value="jersey">Jersey Cross (UK / Exotic A1)</option>
            <option value="brown_swiss">Brown Swiss (Switzerland / Exotic A1)</option>
          </select>
        </div>
      </div>

      {/* Comparison Grid Matrix */}
      <div className="bg-white dark:bg-slate-900 rounded-3xl border border-slate-200 dark:border-slate-800 shadow-xl overflow-hidden divide-y divide-slate-100 dark:divide-slate-800">
        
        {/* Origin Region */}
        <div className="p-6 grid grid-cols-1 md:grid-cols-3 gap-4 items-center">
          <div>
            <span className="text-[10px] font-bold text-slate-400 uppercase tracking-wider block">Comparison Metric</span>
            <h4 className="font-extrabold text-sm text-slate-900 dark:text-white mt-0.5">Origin & Tract</h4>
          </div>
          <div className="bg-emerald-50 dark:bg-emerald-950/50 p-4 rounded-2xl border-2 border-emerald-500/60 text-xs shadow-xs">
            <span className="font-extrabold text-emerald-800 dark:text-emerald-300 block mb-1">🌿 {currentNative.name}</span>
            <p className="text-slate-700 dark:text-slate-200 font-medium">{currentNative.origin}</p>
          </div>
          <div className="bg-rose-50 dark:bg-rose-950/40 p-4 rounded-2xl border border-rose-200 dark:border-rose-900/60 text-xs">
            <span className="font-bold text-rose-800 dark:text-rose-300 block mb-1">🌍 {currentForeign.name}</span>
            <p className="text-slate-700 dark:text-slate-200">{currentForeign.origin}</p>
          </div>
        </div>

        {/* Metric 1: Protein Type */}
        <div className="p-6 grid grid-cols-1 md:grid-cols-3 gap-4 items-center">
          <div>
            <span className="text-[10px] font-bold text-slate-400 uppercase tracking-wider block">Comparison Metric</span>
            <h4 className="font-extrabold text-sm text-slate-900 dark:text-white mt-0.5">{t('compProteinType')}</h4>
          </div>
          <div className="bg-emerald-50 dark:bg-emerald-950/50 p-4 rounded-2xl border-2 border-emerald-500/60 text-xs shadow-xs">
            <span className="font-extrabold text-emerald-800 dark:text-emerald-300 block mb-1">✅ Healthy A2 Protein (Winner)</span>
            <p className="text-slate-700 dark:text-slate-200 font-medium">{currentNative.proteinType}</p>
          </div>
          <div className="bg-rose-50 dark:bg-rose-950/40 p-4 rounded-2xl border border-rose-200 dark:border-rose-900/60 text-xs">
            <span className="font-bold text-rose-800 dark:text-rose-300 block mb-1">❌ A1 Inflammatory Protein</span>
            <p className="text-slate-700 dark:text-slate-200">{currentForeign.proteinType}</p>
          </div>
        </div>

        {/* Metric 2: Heat Tolerance */}
        <div className="p-6 grid grid-cols-1 md:grid-cols-3 gap-4 items-center">
          <div>
            <span className="text-[10px] font-bold text-slate-400 uppercase tracking-wider block">Comparison Metric</span>
            <h4 className="font-extrabold text-sm text-slate-900 dark:text-white mt-0.5">{t('compHeatTolerance')}</h4>
          </div>
          <div className="bg-emerald-50 dark:bg-emerald-950/50 p-4 rounded-2xl border-2 border-emerald-500/60 text-xs shadow-xs">
            <span className="font-extrabold text-emerald-800 dark:text-emerald-300 block mb-1">☀️ Native Heat Resilience (Winner)</span>
            <p className="text-slate-700 dark:text-slate-200 font-medium">{currentNative.heatTolerance}</p>
          </div>
          <div className="bg-rose-50 dark:bg-rose-950/40 p-4 rounded-2xl border border-rose-200 dark:border-rose-900/60 text-xs">
            <span className="font-bold text-rose-800 dark:text-rose-300 block mb-1">🔥 High Heat Stress Vulnerability</span>
            <p className="text-slate-700 dark:text-slate-200">{currentForeign.heatTolerance}</p>
          </div>
        </div>

        {/* Metric 3: Daily Feed & Maintenance Cost */}
        <div className="p-6 grid grid-cols-1 md:grid-cols-3 gap-4 items-center">
          <div>
            <span className="text-[10px] font-bold text-slate-400 uppercase tracking-wider block">Comparison Metric</span>
            <h4 className="font-extrabold text-sm text-slate-900 dark:text-white mt-0.5">{t('compFeedCost')}</h4>
          </div>
          <div className="bg-emerald-50 dark:bg-emerald-950/50 p-4 rounded-2xl border-2 border-emerald-500/60 text-xs shadow-xs">
            <span className="font-extrabold text-emerald-800 dark:text-emerald-300 block mb-1">💰 Low Maintenance Cost (Winner)</span>
            <p className="text-slate-700 dark:text-slate-200 font-medium">{currentNative.feedCost}</p>
          </div>
          <div className="bg-rose-50 dark:bg-rose-950/40 p-4 rounded-2xl border border-rose-200 dark:border-rose-900/60 text-xs">
            <span className="font-bold text-rose-800 dark:text-rose-300 block mb-1">💸 Expensive Feed Ration</span>
            <p className="text-slate-700 dark:text-slate-200">{currentForeign.feedCost}</p>
          </div>
        </div>

        {/* Metric 4: Disease & Tick Resistance */}
        <div className="p-6 grid grid-cols-1 md:grid-cols-3 gap-4 items-center">
          <div>
            <span className="text-[10px] font-bold text-slate-400 uppercase tracking-wider block">Comparison Metric</span>
            <h4 className="font-extrabold text-sm text-slate-900 dark:text-white mt-0.5">{t('compDiseaseImmunity')}</h4>
          </div>
          <div className="bg-emerald-50 dark:bg-emerald-950/50 p-4 rounded-2xl border-2 border-emerald-500/60 text-xs shadow-xs">
            <span className="font-extrabold text-emerald-800 dark:text-emerald-300 block mb-1">🛡️ Superior Natural Immunity (Winner)</span>
            <p className="text-slate-700 dark:text-slate-200 font-medium">{currentNative.diseaseImmunity}</p>
          </div>
          <div className="bg-rose-50 dark:bg-rose-950/40 p-4 rounded-2xl border border-rose-200 dark:border-rose-900/60 text-xs">
            <span className="font-bold text-rose-800 dark:text-rose-300 block mb-1">💊 Frequent Medical Expenses</span>
            <p className="text-slate-700 dark:text-slate-200">{currentForeign.diseaseImmunity}</p>
          </div>
        </div>

        {/* Metric 5: Lifespan & Lactation Cycles */}
        <div className="p-6 grid grid-cols-1 md:grid-cols-3 gap-4 items-center">
          <div>
            <span className="text-[10px] font-bold text-slate-400 uppercase tracking-wider block">Comparison Metric</span>
            <h4 className="font-extrabold text-sm text-slate-900 dark:text-white mt-0.5">Productive Lifespan</h4>
          </div>
          <div className="bg-emerald-50 dark:bg-emerald-950/50 p-4 rounded-2xl border-2 border-emerald-500/60 text-xs shadow-xs">
            <span className="font-extrabold text-emerald-800 dark:text-emerald-300 block mb-1">⏳ Long Productive Life (Winner)</span>
            <p className="text-slate-700 dark:text-slate-200 font-medium">{currentNative.lactationCycles}</p>
          </div>
          <div className="bg-rose-50 dark:bg-rose-950/40 p-4 rounded-2xl border border-rose-200 dark:border-rose-900/60 text-xs">
            <span className="font-bold text-rose-800 dark:text-rose-300 block mb-1">⚠️ Short Productive Life</span>
            <p className="text-slate-700 dark:text-slate-200">{currentForeign.lactationCycles}</p>
          </div>
        </div>
      </div>

      {/* Recommended Breed Verdict Card at the Bottom */}
      <div className="bg-gradient-to-br from-teal-900 to-emerald-950 text-white rounded-3xl p-6 shadow-2xl border-2 border-amber-400/50 space-y-4">
        <div className="flex items-center space-x-3">
          <div className="w-10 h-10 rounded-xl bg-amber-400 text-teal-950 flex items-center justify-center shrink-0 font-extrabold text-lg">
            ★
          </div>
          <div>
            <span className="text-[10px] font-extrabold uppercase tracking-wider text-amber-300">GauShakthi AI Recommendation</span>
            <h3 className="text-base font-extrabold text-white">Recommended Choice: {currentNative.name}</h3>
          </div>
        </div>
        <p className="text-xs text-slate-200 leading-relaxed">
          Based on genetic traits and economic viability, **{currentNative.name}** is the recommended choice for your farm over **{currentForeign.name}**. 
          Originating from **{currentNative.origin}**, it yields **{currentNative.proteinType}** with **{currentNative.heatTolerance}**. 
          Its daily feeding cost of **{currentNative.feedCost}** is significantly cheaper than the foreign breed's **{currentForeign.feedCost}**, and it has **{currentNative.diseaseImmunity}** with **{currentNative.lactationCycles}** of productive lifespan.
        </p>
        <div className="pt-1 flex items-center space-x-2 text-xs font-bold text-amber-300">
          <Sparkles className="w-4 h-4" />
          <span>Verdict: {currentNative.recommendationVerdict}</span>
        </div>
      </div>
    </div>
  );
};
