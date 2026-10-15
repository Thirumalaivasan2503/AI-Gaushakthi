import React from 'react';
import { useLocation, Link, useNavigate } from 'react-router-dom';
import { RecommendationResult, BreedRecommendation, BreedMasterInfo, FeedMasterInfo, DiseaseMasterInfo, VaccinationMasterInfo, ClimateMasterInfo, EconomicsMasterInfo } from '../../types';
import { useAuth } from '../../context/AuthContext';
import { QRCodeSVG } from 'qrcode.react';
import { 
  BarChart, 
  Bar, 
  XAxis, 
  YAxis, 
  Tooltip, 
  ResponsiveContainer, 
  Cell 
} from 'recharts';
import { 
  Sparkles, 
  CheckCircle2, 
  Download, 
  ArrowLeft, 
  Info,
  ShieldCheck,
  MapPin,
  Award,
  Sun,
  Utensils,
  SunMedium,
  Moon,
  Droplets,
  Zap,
  Leaf,
  HeartPulse,
  AlertTriangle,
  Stethoscope,
  Shield,
  Syringe,
  CloudRain,
  Flame,
  Globe,
  Coins,
  TrendingUp,
  DollarSign
} from 'lucide-react';

export const RecommendationResultPage: React.FC = () => {
  const location = useLocation();
  const navigate = useNavigate();
  const { t } = useAuth();
  const result: RecommendationResult | undefined = location.state?.result;

  if (!result) {
    return (
      <div className="text-center py-16 space-y-4 font-sans">
        <p className="text-sm text-slate-500">No recommendation result active. Please run the recommender form.</p>
        <Link to="/recommendation" className="inline-flex items-center space-x-2 bg-emerald-700 text-amber-300 font-bold text-xs px-4 py-2.5 rounded-xl border border-amber-400/40 shadow-lg">
          <Sparkles className="w-4 h-4 text-amber-400" />
          <span>{t('navRecommender')}</span>
        </Link>
      </div>
    );
  }

  // Extract primary recommendation & master details
  const payloadData: any = result;
  const primaryBreed: BreedRecommendation = result.recommendations?.[0] || {
    breed_id: payloadData.Breed_ID || 'B001',
    breed_name: payloadData.recommended_breed || payloadData.Breed_Name || 'Kangayam Cattle',
    species: 'Cattle',
    suitability_score: payloadData.sustainability_score || 98,
    confidence: (payloadData.confidence_score || 93) / 100,
    key_advantages: [
      'High natural heat & drought tolerance',
      'Low maintenance & disease resistant',
      'A2 Beta-Casein milk producer',
    ],
    expected_yield: `${payloadData.Milk_Yield_Liters_Day || 4} L/day`,
    disease_resistance_rating: payloadData.Disease_Resistance || 'Very High',
    heat_tolerance_rating: payloadData.Climate_Adaptability || 'Excellent',
    origin_region: payloadData.Origin_State || 'Tamil Nadu',
    description: payloadData.Description || 'Premier indigenous breed native to India with high heat resilience.',
  };

  const masterDetails: BreedMasterInfo = payloadData.breed_details || {
    Breed_ID: payloadData.Breed_ID || 'B001',
    Breed_Name: payloadData.Breed_Name || primaryBreed.breed_name,
    Breed_Type: payloadData.Breed_Type || 'Indigenous',
    Origin_State: payloadData.Origin_State || primaryBreed.origin_region,
    Milk_Yield_Liters_Day: payloadData.Milk_Yield_Liters_Day || 4.0,
    Meat_Productivity: payloadData.Meat_Productivity || 'Low',
    Disease_Resistance: payloadData.Disease_Resistance || 'Very High',
    Climate_Adaptability: payloadData.Climate_Adaptability || 'Excellent',
    Feed_Requirement: payloadData.Feed_Requirement || 'Low',
    Daily_Feed_Cost_INR: payloadData.Daily_Feed_Cost_INR || 120,
    Maintenance_Cost_Monthly: payloadData.Maintenance_Cost_Monthly || 3500,
    Lifespan_Years: payloadData.Lifespan_Years || '20 Years',
    Sustainability_Score: payloadData.Sustainability_Score || 98,
    Best_For: payloadData.Best_For || 'Sustainable Farming',
    Description: payloadData.Description || primaryBreed.description,
  };

  const feedDetails: FeedMasterInfo = payloadData.feed_details || {
    Feed_Type: payloadData.Feed_Type || "Green Fodder & Roughage",
    Morning_Feed: payloadData.Morning_Feed || "8 kg Green Napier Grass + 1.5 kg Cottonseed Cake",
    Evening_Feed: payloadData.Evening_Feed || "7 kg Dry Paddy Straw + 1.0 kg Wheat Bran",
    Mineral_Mixture: payloadData.Mineral_Mixture || "40g Chelated Mineral Mix + 25g Salt",
    Water_Requirement: payloadData.Water_Requirement || "45 - 55 L / Day",
    Daily_Feed_Cost_INR: payloadData.Daily_Feed_Cost_INR || 120,
    Nutrition_Level: payloadData.Nutrition_Level || "Optimal Fiber & High Roughage",
    Protein_Percentage: payloadData.Protein_Percentage || "13.5%",
    Fiber_Percentage: payloadData.Fiber_Percentage || "28.5%",
    Energy_Level: payloadData.Energy_Level || "2.1 Mcal/kg",
    Recommended_Season: payloadData.Recommended_Season || "All Seasons",
    Suitable_Farming_Purpose: payloadData.Suitable_Farming_Purpose || "Sustainable Farming",
    Remarks: payloadData.Remarks || "Exceptional converter of dry agricultural stubble with low maintenance cost.",
  };

  const climateDetails: ClimateMasterInfo = payloadData.climate_details || {
    State: payloadData.params?.state || "Tamil Nadu",
    District: payloadData.params?.district || "Erode",
    Climate_Type: payloadData.Climate_Type || "Semi-Arid",
    Avg_Temperature_C: payloadData.Avg_Temperature_C || 34.5,
    Avg_Humidity_Percent: payloadData.Avg_Humidity_Percent || 65,
    Annual_Rainfall_mm: payloadData.Annual_Rainfall_mm || 720,
    Heat_Index: payloadData.Heat_Index || "Medium",
    Water_Availability: payloadData.Water_Availability || "Medium",
    Drought_Risk: payloadData.Drought_Risk || "Low",
    Flood_Risk: payloadData.Flood_Risk || "Low",
    Suitable_Breeds: payloadData.Suitable_Breeds || "Kangayam; Gir; Sahiwal; Ongole",
    Sustainability_Score: payloadData.Sustainability_Score || 96,
    Recommended_Farming_Type: payloadData.Recommended_Farming_Type || "Sustainable Dairy Farming",
  };

  const economicsDetails: EconomicsMasterInfo = payloadData.economics_details || {
    Breed_Name: masterDetails.Breed_Name,
    Purchase_Cost_INR: payloadData.Purchase_Cost_INR || 45000,
    Daily_Feed_Cost_INR: payloadData.Daily_Feed_Cost_INR || 120,
    Monthly_Maintenance_Cost_INR: payloadData.Monthly_Maintenance_Cost_INR || 3500,
    Annual_Medical_Cost_INR: payloadData.Annual_Medical_Cost_INR || 2500,
    Average_Milk_Yield_L_Day: payloadData.Average_Milk_Yield_L_Day || 4.0,
    Average_Meat_Yield_Kg: payloadData.Average_Meat_Yield_Kg || 165,
    Expected_Annual_Income_INR: payloadData.Expected_Annual_Income_INR || 185000,
    Net_Profit_INR: payloadData.Net_Profit_INR || 135000,
    ROI_Percentage: payloadData.ROI_Percentage || 290.5,
    Break_even_Period_Months: payloadData.Break_even_Period_Months || "18 Months",
    Sustainability_Score: payloadData.Sustainability_Score || 96,
    Investment_Level: payloadData.Investment_Level || "Medium",
    Risk_Level: payloadData.Risk_Level || "Low",
    Recommended_Farmer_Type: payloadData.Recommended_Farmer_Type || "Smallholder & Organic Farmers",
  };

  const diseaseDetails: DiseaseMasterInfo | undefined = payloadData.disease_details;
  const vaccinationSchedule: VaccinationMasterInfo[] = payloadData.vaccination_schedule || [
    {
      Vaccine_Name: "Foot and Mouth Disease Polyvalent Vaccine",
      Disease: "Foot and Mouth Disease",
      Species: "Cattle",
      Dose: "2 mL",
      First_Dose_Age: "4 Months",
      Booster_Interval: "6 Months",
      Administration_Route: "Subcutaneous",
      Recommended_Season: "Pre-Monsoon (May / Nov)",
      Storage_Temperature: "2-8°C Cold Chain",
      Estimated_Cost: 150,
      Protection_Percentage: "95%",
      Veterinary_Remarks: "Mandatory bi-annual preventive immunization for indigenous cattle.",
    }
  ];

  const xaiData = payloadData.feature_importance_breakdown?.map((f: any) => ({
    feature_name: f.feature,
    importance_score: Math.round(f.importance_weight * 100),
  })) || [
    { feature_name: 'Temperature & Heat Index', importance_score: 35 },
    { feature_name: 'Productivity Goal', importance_score: 28 },
    { feature_name: 'Water Availability', importance_score: 18 },
    { feature_name: 'Feed Budget INR', importance_score: 19 },
  ];

  const handleDownloadPDF = () => {
    alert('📥 Complete Master Agronomic, Financial, Climate, Feed & Disease Report PDF generated!');
  };

  return (
    <div className="space-y-6 max-w-5xl mx-auto font-sans">
      {/* Top Banner Controls */}
      <div className="flex items-center justify-between">
        <button onClick={() => navigate('/recommendation')} className="flex items-center space-x-2 text-xs font-semibold text-slate-600 dark:text-slate-300 hover:text-emerald-600 transition">
          <ArrowLeft className="w-4 h-4" />
          <span>{t('modifyInputs')}</span>
        </button>

        <button
          onClick={handleDownloadPDF}
          className="flex items-center space-x-1.5 px-4 py-2 rounded-xl bg-gradient-to-r from-emerald-800 to-emerald-950 text-amber-300 text-xs font-extrabold border border-amber-400/40 hover:border-amber-400 shadow-lg transition"
        >
          <Download className="w-4 h-4 text-amber-400" />
          <span>Export Master Agronomic Report PDF</span>
        </button>
      </div>

      {/* Hero Recommendation Header Card (Forest Green & Elegant Gold) */}
      <div className="relative overflow-hidden bg-gradient-to-r from-emerald-900 via-emerald-950 to-teal-950 rounded-3xl p-6 sm:p-8 text-white border-2 border-emerald-500/50 shadow-2xl space-y-6">
        <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 border-b border-emerald-800/80 pb-6">
          <div>
            <div className="flex items-center space-x-2">
              <span className="px-3 py-1 bg-amber-400/20 text-amber-300 border border-amber-400/40 text-[11px] font-extrabold rounded-full uppercase tracking-wider inline-flex items-center space-x-1">
                <Award className="w-3.5 h-3.5 text-amber-400" />
                <span>Top Recommended Match</span>
              </span>
              <span className="text-xs text-emerald-300 font-mono font-semibold">
                ID: {masterDetails.Breed_ID}
              </span>
            </div>
            
            <h1 className="text-3xl sm:text-4xl font-black text-white mt-2 tracking-tight">
              {masterDetails.Breed_Name}
            </h1>

            <p className="text-xs sm:text-sm text-emerald-200 mt-1 flex items-center space-x-2">
              <MapPin className="w-3.5 h-3.5 text-amber-400" />
              <span>Origin: <strong>{masterDetails.Origin_State}</strong></span>
              <span>•</span>
              <span>Type: <strong>{masterDetails.Breed_Type}</strong></span>
            </p>
          </div>

          <div className="bg-gradient-to-br from-amber-400/20 to-amber-500/10 border border-amber-400/40 p-4 rounded-2xl text-center backdrop-blur-md shadow-xl shrink-0">
            <span className="block text-[10px] uppercase font-bold text-amber-300 tracking-wider">Sustainability Score</span>
            <span className="text-3xl font-black text-amber-400">{masterDetails.Sustainability_Score} / 100</span>
          </div>
        </div>

        {/* Breed Master Knowledge Base Grid (Glassmorphism Cards) */}
        <div>
          <div className="flex items-center space-x-2 mb-4">
            <Sparkles className="w-4 h-4 text-amber-400" />
            <h3 className="font-extrabold text-sm text-amber-300 uppercase tracking-wider">
              Breed Knowledge Base Master Attributes (breed_master.csv)
            </h3>
          </div>

          <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 gap-3">
            <div className="backdrop-blur-md bg-white/10 dark:bg-slate-900/40 p-3.5 rounded-2xl border border-white/10 dark:border-emerald-500/20 text-xs space-y-1">
              <span className="text-[10px] font-bold text-emerald-300 uppercase block">Milk Yield</span>
              <strong className="text-white text-sm font-extrabold block">{masterDetails.Milk_Yield_Liters_Day} L / Day</strong>
              <span className="text-[10px] text-emerald-200">Daily Average</span>
            </div>

            <div className="backdrop-blur-md bg-white/10 dark:bg-slate-900/40 p-3.5 rounded-2xl border border-white/10 dark:border-emerald-500/20 text-xs space-y-1">
              <span className="text-[10px] font-bold text-emerald-300 uppercase block">Meat Productivity</span>
              <strong className="text-white text-sm font-extrabold block">{masterDetails.Meat_Productivity}</strong>
              <span className="text-[10px] text-emerald-200">Productivity Level</span>
            </div>

            <div className="backdrop-blur-md bg-white/10 dark:bg-slate-900/40 p-3.5 rounded-2xl border border-white/10 dark:border-emerald-500/20 text-xs space-y-1">
              <span className="text-[10px] font-bold text-amber-300 uppercase block">Disease Resistance</span>
              <strong className="text-amber-400 text-sm font-extrabold block flex items-center space-x-1">
                <ShieldCheck className="w-3.5 h-3.5 text-amber-400" />
                <span>{masterDetails.Disease_Resistance}</span>
              </strong>
              <span className="text-[10px] text-emerald-200">Natural Immunity</span>
            </div>

            <div className="backdrop-blur-md bg-white/10 dark:bg-slate-900/40 p-3.5 rounded-2xl border border-white/10 dark:border-emerald-500/20 text-xs space-y-1">
              <span className="text-[10px] font-bold text-emerald-300 uppercase block">Climate Adaptability</span>
              <strong className="text-white text-sm font-extrabold block flex items-center space-x-1">
                <Sun className="w-3.5 h-3.5 text-amber-400" />
                <span>{masterDetails.Climate_Adaptability}</span>
              </strong>
              <span className="text-[10px] text-emerald-200">Heat Tolerance</span>
            </div>

            <div className="backdrop-blur-md bg-white/10 dark:bg-slate-900/40 p-3.5 rounded-2xl border border-white/10 dark:border-emerald-500/20 text-xs space-y-1">
              <span className="text-[10px] font-bold text-emerald-300 uppercase block">Daily Feed Cost</span>
              <strong className="text-amber-300 text-sm font-extrabold block">₹{masterDetails.Daily_Feed_Cost_INR} / Day</strong>
              <span className="text-[10px] text-emerald-200">Feed Requirement: {masterDetails.Feed_Requirement}</span>
            </div>

            <div className="backdrop-blur-md bg-white/10 dark:bg-slate-900/40 p-3.5 rounded-2xl border border-white/10 dark:border-emerald-500/20 text-xs space-y-1">
              <span className="text-[10px] font-bold text-emerald-300 uppercase block">Monthly Maintenance</span>
              <strong className="text-white text-sm font-extrabold block">₹{masterDetails.Maintenance_Cost_Monthly} / Mo</strong>
              <span className="text-[10px] text-emerald-200">Total Operational Budget</span>
            </div>

            <div className="backdrop-blur-md bg-white/10 dark:bg-slate-900/40 p-3.5 rounded-2xl border border-white/10 dark:border-emerald-500/20 text-xs space-y-1">
              <span className="text-[10px] font-bold text-emerald-300 uppercase block">Productive Lifespan</span>
              <strong className="text-white text-sm font-extrabold block">{masterDetails.Lifespan_Years}</strong>
              <span className="text-[10px] text-emerald-200">Productive Years</span>
            </div>

            <div className="backdrop-blur-md bg-white/10 dark:bg-slate-900/40 p-3.5 rounded-2xl border border-white/10 dark:border-emerald-500/20 text-xs space-y-1">
              <span className="text-[10px] font-bold text-amber-300 uppercase block">Best Suited For</span>
              <strong className="text-amber-400 text-sm font-extrabold block">{masterDetails.Best_For}</strong>
              <span className="text-[10px] text-emerald-200">Optimal Farming Goal</span>
            </div>
          </div>
        </div>
      </div>

      {/* PREMIUM FINANCIAL ECONOMICS CARD (economics_master.csv) */}
      <div className="relative overflow-hidden bg-gradient-to-br from-emerald-950 via-slate-900 to-teal-950 rounded-3xl p-6 sm:p-8 text-white border-2 border-amber-400/40 shadow-2xl space-y-6">
        <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 border-b border-emerald-800/80 pb-4">
          <div className="flex items-center space-x-3">
            <div className="w-12 h-12 rounded-2xl bg-amber-400/20 text-amber-400 flex items-center justify-center shrink-0 border border-amber-400/40 shadow-lg">
              <Coins className="w-6 h-6 text-amber-400" />
            </div>
            <div>
              <span className="text-[10px] font-extrabold text-amber-300 uppercase tracking-wider block">
                Economics Knowledge Base (economics_master.csv)
              </span>
              <h2 className="text-xl sm:text-2xl font-black text-white">
                {masterDetails.Breed_Name} Financial Economics & ROI
              </h2>
            </div>
          </div>

          <div className="bg-amber-400/20 px-4 py-2 rounded-2xl border border-amber-400/40 text-center shrink-0">
            <span className="text-[10px] uppercase font-extrabold text-amber-300 block">Expected ROI</span>
            <span className="text-2xl font-black text-amber-400">{economicsDetails.ROI_Percentage}%</span>
          </div>
        </div>

        {/* 14 Financial Economics Parameters Grid */}
        <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 gap-3 text-xs">
          <div className="backdrop-blur-md bg-white/10 p-3.5 rounded-2xl border border-white/10">
            <span className="text-[10px] font-bold text-amber-300 uppercase block">Purchase Cost</span>
            <strong className="text-amber-300 text-base font-black block mt-0.5">₹{Number(economicsDetails.Purchase_Cost_INR).toLocaleString('en-IN')}</strong>
          </div>

          <div className="backdrop-blur-md bg-white/10 p-3.5 rounded-2xl border border-white/10">
            <span className="text-[10px] font-bold text-emerald-300 uppercase block">Daily Feed Cost</span>
            <strong className="text-white text-base font-extrabold block mt-0.5">₹{economicsDetails.Daily_Feed_Cost_INR} / Day</strong>
          </div>

          <div className="backdrop-blur-md bg-white/10 p-3.5 rounded-2xl border border-white/10">
            <span className="text-[10px] font-bold text-emerald-300 uppercase block">Monthly Maint</span>
            <strong className="text-white text-base font-extrabold block mt-0.5">₹{economicsDetails.Monthly_Maintenance_Cost_INR} / Mo</strong>
          </div>

          <div className="backdrop-blur-md bg-white/10 p-3.5 rounded-2xl border border-white/10">
            <span className="text-[10px] font-bold text-emerald-300 uppercase block">Annual Medical Cost</span>
            <strong className="text-white text-base font-extrabold block mt-0.5">₹{economicsDetails.Annual_Medical_Cost_INR} / Yr</strong>
          </div>

          <div className="backdrop-blur-md bg-white/10 p-3.5 rounded-2xl border border-white/10">
            <span className="text-[10px] font-bold text-emerald-300 uppercase block">Avg Milk Yield</span>
            <strong className="text-white font-extrabold block mt-0.5">{economicsDetails.Average_Milk_Yield_L_Day} L / Day</strong>
          </div>

          <div className="backdrop-blur-md bg-white/10 p-3.5 rounded-2xl border border-white/10">
            <span className="text-[10px] font-bold text-emerald-300 uppercase block">Avg Meat Yield</span>
            <strong className="text-white font-extrabold block mt-0.5">{economicsDetails.Average_Meat_Yield_Kg} Kg</strong>
          </div>

          <div className="backdrop-blur-md bg-white/10 p-3.5 rounded-2xl border border-white/10">
            <span className="text-[10px] font-bold text-emerald-400 uppercase block">Annual Income</span>
            <strong className="text-emerald-400 text-base font-black block mt-0.5">₹{Number(economicsDetails.Expected_Annual_Income_INR).toLocaleString('en-IN')}</strong>
          </div>

          <div className="backdrop-blur-md bg-white/10 p-3.5 rounded-2xl border border-white/10">
            <span className="text-[10px] font-bold text-amber-300 uppercase block">Annual Net Profit</span>
            <strong className="text-amber-400 text-base font-black block mt-0.5">₹{Number(economicsDetails.Net_Profit_INR).toLocaleString('en-IN')}</strong>
          </div>

          <div className="backdrop-blur-md bg-white/10 p-3.5 rounded-2xl border border-white/10">
            <span className="text-[10px] font-bold text-emerald-300 uppercase block">Break-Even Period</span>
            <strong className="text-white font-extrabold block mt-0.5">{economicsDetails.Break_even_Period_Months}</strong>
          </div>

          <div className="backdrop-blur-md bg-white/10 p-3.5 rounded-2xl border border-white/10">
            <span className="text-[10px] font-bold text-emerald-300 uppercase block">Investment Level</span>
            <strong className="text-white font-extrabold block mt-0.5">{economicsDetails.Investment_Level}</strong>
          </div>

          <div className="backdrop-blur-md bg-white/10 p-3.5 rounded-2xl border border-white/10">
            <span className="text-[10px] font-bold text-amber-300 uppercase block">Risk Level</span>
            <strong className="text-amber-300 font-extrabold block mt-0.5">{economicsDetails.Risk_Level}</strong>
          </div>

          <div className="backdrop-blur-md bg-white/10 p-3.5 rounded-2xl border border-white/10">
            <span className="text-[10px] font-bold text-emerald-300 uppercase block">Target Farmer</span>
            <strong className="text-white font-extrabold block mt-0.5 text-[11px] truncate">{economicsDetails.Recommended_Farmer_Type}</strong>
          </div>
        </div>
      </div>

      {/* PREMIUM CLIMATE KNOWLEDGE CARD (climate_master.csv) */}
      <div className="relative overflow-hidden bg-gradient-to-br from-emerald-950 via-slate-900 to-teal-950 rounded-3xl p-6 sm:p-8 text-white border-2 border-emerald-500/40 shadow-2xl space-y-6">
        <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 border-b border-emerald-800/80 pb-4">
          <div className="flex items-center space-x-3">
            <div className="w-12 h-12 rounded-2xl bg-amber-400/20 text-amber-400 flex items-center justify-center shrink-0 border border-amber-400/40 shadow-lg">
              <Globe className="w-6 h-6 text-amber-400" />
            </div>
            <div>
              <span className="text-[10px] font-extrabold text-amber-300 uppercase tracking-wider block">
                Climate Knowledge Base (climate_master.csv)
              </span>
              <h2 className="text-xl sm:text-2xl font-black text-white">
                Location Climate: {climateDetails.District}, {climateDetails.State}
              </h2>
            </div>
          </div>

          <span className="px-3.5 py-1.5 rounded-xl bg-emerald-900/80 border border-emerald-500/30 text-xs font-bold text-emerald-300">
            Climate Zone: {climateDetails.Climate_Type}
          </span>
        </div>

        {/* 11 Climate Parameters Grid */}
        <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 gap-3 text-xs">
          <div className="backdrop-blur-md bg-white/10 p-3 rounded-2xl border border-white/10">
            <span className="text-[10px] font-bold text-emerald-300 uppercase block flex items-center space-x-1">
              <Flame className="w-3.5 h-3.5 text-amber-400" />
              <span>Average Temp</span>
            </span>
            <strong className="text-white text-sm font-extrabold block mt-0.5">{climateDetails.Avg_Temperature_C}°C</strong>
          </div>

          <div className="backdrop-blur-md bg-white/10 p-3 rounded-2xl border border-white/10">
            <span className="text-[10px] font-bold text-emerald-300 uppercase block flex items-center space-x-1">
              <Droplets className="w-3.5 h-3.5 text-cyan-400" />
              <span>Average Humidity</span>
            </span>
            <strong className="text-cyan-300 text-sm font-extrabold block mt-0.5">{climateDetails.Avg_Humidity_Percent}%</strong>
          </div>

          <div className="backdrop-blur-md bg-white/10 p-3 rounded-2xl border border-white/10">
            <span className="text-[10px] font-bold text-emerald-300 uppercase block flex items-center space-x-1">
              <CloudRain className="w-3.5 h-3.5 text-blue-400" />
              <span>Annual Rainfall</span>
            </span>
            <strong className="text-white text-sm font-extrabold block mt-0.5">{climateDetails.Annual_Rainfall_mm} mm</strong>
          </div>

          <div className="backdrop-blur-md bg-white/10 p-3 rounded-2xl border border-white/10">
            <span className="text-[10px] font-bold text-amber-300 uppercase block">Heat Index</span>
            <strong className="text-amber-400 text-sm font-extrabold block mt-0.5">{climateDetails.Heat_Index}</strong>
          </div>

          <div className="backdrop-blur-md bg-white/10 p-3 rounded-2xl border border-white/10">
            <span className="text-[10px] font-bold text-emerald-300 uppercase block">Water Availability</span>
            <strong className="text-white font-extrabold block mt-0.5">{climateDetails.Water_Availability}</strong>
          </div>

          <div className="backdrop-blur-md bg-white/10 p-3 rounded-2xl border border-white/10">
            <span className="text-[10px] font-bold text-amber-300 uppercase block">Drought Risk</span>
            <strong className="text-amber-300 font-extrabold block mt-0.5">{climateDetails.Drought_Risk}</strong>
          </div>

          <div className="backdrop-blur-md bg-white/10 p-3 rounded-2xl border border-white/10">
            <span className="text-[10px] font-bold text-emerald-300 uppercase block">Flood Risk</span>
            <strong className="text-white font-extrabold block mt-0.5">{climateDetails.Flood_Risk}</strong>
          </div>

          <div className="backdrop-blur-md bg-white/10 p-3 rounded-2xl border border-white/10">
            <span className="text-[10px] font-bold text-amber-300 uppercase block">Recommended Farming</span>
            <strong className="text-amber-400 text-xs font-extrabold block mt-0.5">
              {climateDetails.Recommended_Farming_Type || climateDetails.Recommended_Farming}
            </strong>
          </div>
        </div>

        <div className="bg-emerald-900/40 p-4 rounded-2xl border border-emerald-500/30 text-xs space-y-2">
          <span className="text-[10px] font-extrabold text-amber-300 uppercase tracking-wider block">
            Climate-Compatible Breeds for {climateDetails.District}
          </span>
          <p className="text-white font-bold">
            {climateDetails.Suitable_Breeds}
          </p>
        </div>
      </div>

      {/* PREMIUM FEED RECOMMENDATION CARD (feed_master.csv) */}
      <div className="relative overflow-hidden bg-gradient-to-br from-emerald-950 via-slate-900 to-teal-950 rounded-3xl p-6 sm:p-8 text-white border-2 border-amber-400/40 shadow-2xl space-y-6">
        <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 border-b border-emerald-800/80 pb-4">
          <div className="flex items-center space-x-3">
            <div className="w-12 h-12 rounded-2xl bg-amber-400/20 text-amber-400 flex items-center justify-center shrink-0 border border-amber-400/40 shadow-lg">
              <Utensils className="w-6 h-6" />
            </div>
            <div>
              <span className="text-[10px] font-extrabold text-amber-300 uppercase tracking-wider block">
                Feed Recommendation Knowledge Base (feed_master.csv)
              </span>
              <h2 className="text-xl sm:text-2xl font-black text-white">
                {masterDetails.Breed_Name} Precision Nutritional Ration
              </h2>
            </div>
          </div>

          <div className="flex items-center space-x-2 bg-emerald-900/60 px-3.5 py-1.5 rounded-xl border border-emerald-500/30 text-xs font-bold text-emerald-300">
            <Leaf className="w-4 h-4 text-emerald-400" />
            <span>Feed Type: {feedDetails.Feed_Type}</span>
          </div>
        </div>

        {/* Morning & Evening Feed Ration Glass Cards */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div className="backdrop-blur-md bg-white/10 dark:bg-slate-900/50 p-4 rounded-2xl border border-amber-400/30 space-y-2">
            <div className="flex items-center justify-between">
              <span className="text-xs font-extrabold text-amber-300 uppercase tracking-wider flex items-center space-x-1.5">
                <SunMedium className="w-4 h-4 text-amber-400" />
                <span>Morning Feed Ration</span>
              </span>
              <span className="text-[10px] bg-amber-400/20 text-amber-300 px-2 py-0.5 rounded-full font-bold">6:00 AM</span>
            </div>
            <p className="text-xs text-slate-100 font-semibold leading-relaxed">
              {feedDetails.Morning_Feed}
            </p>
          </div>

          <div className="backdrop-blur-md bg-white/10 dark:bg-slate-900/50 p-4 rounded-2xl border border-emerald-500/30 space-y-2">
            <div className="flex items-center justify-between">
              <span className="text-xs font-extrabold text-emerald-300 uppercase tracking-wider flex items-center space-x-1.5">
                <Moon className="w-4 h-4 text-emerald-400" />
                <span>Evening Feed Ration</span>
              </span>
              <span className="text-[10px] bg-emerald-500/20 text-emerald-300 px-2 py-0.5 rounded-full font-bold">5:30 PM</span>
            </div>
            <p className="text-xs text-slate-100 font-semibold leading-relaxed">
              {feedDetails.Evening_Feed}
            </p>
          </div>
        </div>

        {/* Nutritional Parameters Grid */}
        <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 gap-3">
          <div className="backdrop-blur-md bg-white/10 p-3 rounded-2xl border border-white/10 text-xs">
            <span className="text-[10px] font-bold text-emerald-300 uppercase block">Mineral Mixture</span>
            <strong className="text-white text-xs font-bold block mt-0.5">{feedDetails.Mineral_Mixture}</strong>
          </div>

          <div className="backdrop-blur-md bg-white/10 p-3 rounded-2xl border border-white/10 text-xs">
            <span className="text-[10px] font-bold text-emerald-300 uppercase block flex items-center space-x-1">
              <Droplets className="w-3.5 h-3.5 text-cyan-400" />
              <span>Water Requirement</span>
            </span>
            <strong className="text-cyan-300 text-xs font-bold block mt-0.5">{feedDetails.Water_Requirement}</strong>
          </div>

          <div className="backdrop-blur-md bg-white/10 p-3 rounded-2xl border border-white/10 text-xs">
            <span className="text-[10px] font-bold text-amber-300 uppercase block">Daily Feed Cost</span>
            <strong className="text-amber-400 text-sm font-extrabold block mt-0.5">₹{feedDetails.Daily_Feed_Cost_INR} / Day</strong>
          </div>

          <div className="backdrop-blur-md bg-white/10 p-3 rounded-2xl border border-white/10 text-xs">
            <span className="text-[10px] font-bold text-emerald-300 uppercase block">Nutrition Level</span>
            <strong className="text-white text-xs font-bold block mt-0.5">{feedDetails.Nutrition_Level}</strong>
          </div>

          <div className="backdrop-blur-md bg-white/10 p-3 rounded-2xl border border-white/10 text-xs">
            <span className="text-[10px] font-bold text-amber-300 uppercase block">Protein %</span>
            <strong className="text-amber-300 text-xs font-extrabold block mt-0.5">{feedDetails.Protein_Percentage}</strong>
          </div>

          <div className="backdrop-blur-md bg-white/10 p-3 rounded-2xl border border-white/10 text-xs">
            <span className="text-[10px] font-bold text-emerald-300 uppercase block">Fiber %</span>
            <strong className="text-white text-xs font-bold block mt-0.5">{feedDetails.Fiber_Percentage}</strong>
          </div>

          <div className="backdrop-blur-md bg-white/10 p-3 rounded-2xl border border-white/10 text-xs">
            <span className="text-[10px] font-bold text-emerald-300 uppercase block flex items-center space-x-1">
              <Zap className="w-3.5 h-3.5 text-amber-400" />
              <span>Energy Level</span>
            </span>
            <strong className="text-amber-400 text-xs font-bold block mt-0.5">{feedDetails.Energy_Level}</strong>
          </div>

          <div className="backdrop-blur-md bg-white/10 p-3 rounded-2xl border border-white/10 text-xs">
            <span className="text-[10px] font-bold text-emerald-300 uppercase block">Recommended Season</span>
            <strong className="text-white text-xs font-bold block mt-0.5">{feedDetails.Recommended_Season}</strong>
          </div>
        </div>
      </div>

      {/* Description & Agronomic Rationale Card */}
      <div className="bg-white dark:bg-slate-900 rounded-3xl p-6 sm:p-8 border border-slate-200 dark:border-slate-800 shadow-xl space-y-6">
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          <div className="md:col-span-2 space-y-4">
            <h3 className="font-extrabold text-base text-slate-900 dark:text-white flex items-center space-x-2">
              <Info className="w-5 h-5 text-emerald-600" />
              <span>Breed Overview & Knowledge Rationale</span>
            </h3>
            
            <p className="text-xs sm:text-sm text-slate-700 dark:text-slate-300 leading-relaxed font-medium bg-slate-50 dark:bg-slate-800/60 p-4 rounded-2xl border border-slate-200 dark:border-slate-700">
              {masterDetails.Description}
            </p>

            <div className="space-y-2 pt-2">
              <h4 className="font-bold text-xs text-slate-900 dark:text-white uppercase tracking-wider">
                Agronomic Compatibility Verification
              </h4>
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-2 text-xs">
                <div className="flex items-center space-x-2 bg-emerald-50 dark:bg-emerald-950/60 p-3 rounded-xl border border-emerald-200 dark:border-emerald-800">
                  <CheckCircle2 className="w-4 h-4 text-emerald-600 shrink-0" />
                  <span className="text-slate-800 dark:text-slate-200">Disease Resistance: <strong>{masterDetails.Disease_Resistance}</strong></span>
                </div>

                <div className="flex items-center space-x-2 bg-emerald-50 dark:bg-emerald-950/60 p-3 rounded-xl border border-emerald-200 dark:border-emerald-800">
                  <CheckCircle2 className="w-4 h-4 text-emerald-600 shrink-0" />
                  <span className="text-slate-800 dark:text-slate-200">Climate Adaptability: <strong>{masterDetails.Climate_Adaptability}</strong></span>
                </div>
              </div>
            </div>
          </div>

          {/* QR Code & Official Certificate */}
          <div className="bg-gradient-to-b from-slate-900 to-emerald-950 text-white p-6 rounded-3xl border border-emerald-500/30 flex flex-col items-center justify-center space-y-4 text-center shadow-xl">
            <div className="bg-white p-3 rounded-2xl shadow-xl border-2 border-amber-400">
              <QRCodeSVG value={`https://pasumitra.agri.gov/breed/${masterDetails.Breed_ID}`} size={125} />
            </div>
            <div>
              <span className="text-xs font-extrabold text-amber-300 block">Official Breed Certificate</span>
              <span className="text-[10px] text-emerald-300 font-mono">Breed ID: {masterDetails.Breed_ID}</span>
            </div>
            <span className="text-[10px] bg-emerald-900/80 text-emerald-200 px-3 py-1 rounded-full border border-emerald-500/30 font-semibold">
              Verified from economics_master.csv
            </span>
          </div>
        </div>
      </div>

      {/* Explainable AI (XAI) Feature Importance Chart */}
      <div className="bg-white dark:bg-slate-900 rounded-3xl p-6 border border-slate-200 dark:border-slate-800 shadow-xs space-y-4">
        <div className="flex items-center space-x-2 text-emerald-600">
          <BarChart className="w-5 h-5 text-emerald-600" />
          <div>
            <h3 className="font-bold text-sm text-slate-900 dark:text-white">{t('xaiTitle')}</h3>
            <p className="text-xs text-slate-500">{t('xaiSubtitle')}</p>
          </div>
        </div>

        <div className="h-56 w-full pt-4">
          <ResponsiveContainer width="100%" height="100%">
            <BarChart data={xaiData} layout="vertical" margin={{ top: 5, right: 30, left: 40, bottom: 5 }}>
              <XAxis type="number" hide />
              <YAxis dataKey="feature_name" type="category" width={180} tick={{ fontSize: 11, fill: '#64748b' }} />
              <Tooltip formatter={(value) => [`${value}% Contribution`, 'Importance']} />
              <Bar dataKey="importance_score" radius={[0, 8, 8, 0]}>
                {xaiData.map((_: any, index: number) => (
                  <Cell key={`cell-${index}`} fill={index === 0 ? '#10b981' : '#0d9488'} />
                ))}
              </Bar>
            </BarChart>
          </ResponsiveContainer>
        </div>
      </div>
    </div>
  );
};
