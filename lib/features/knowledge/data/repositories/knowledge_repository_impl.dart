import '../../../../core/services/api_service.dart';
import '../../domain/models/breed_info_model.dart';
import '../../domain/models/knowledge_article_model.dart';
import '../../domain/models/breed_info_model.dart';
import '../../domain/repositories/knowledge_repository.dart';

class KnowledgeRepositoryImpl implements KnowledgeRepository {
  final ApiService apiService;

  final List<BreedInfoModel> _breeds = [];
  final List<KnowledgeArticleModel> _articles = [];

  KnowledgeRepositoryImpl({required this.apiService}) {
    _initSeedData();
  }

  void _initSeedData() {
    _breeds.addAll([
      const BreedInfoModel(
        id: 'kangayam',
        name: 'Kangayam Cattle',
        species: 'Cattle (Bos indicus)',
        origin: 'Kongu Region, Tamil Nadu (Coimbatore, Erode, Tiruppur)',
        nativeRegion: 'Semi-Arid Tamil Nadu Plains',
        history: 'Indigenous draught breed developed by native breeders for hardiness in dry terrain.',
        climateSuitability: 'Extreme Heat Resilience up to 48°C',
        milkProductionLiters: '600 - 800 L / Lactation (High A2 Protein)',
        diseaseResistanceScore: 98.5,
        bodyWeightKg: '450-550 kg (Bull), 320-400 kg (Cow)',
        lifespanYears: '18-22 Years',
        feedRequirement: 'Low (Thrives on roughage, crop stover, wild grazing)',
        maintenanceCost: 'Low (₹120/day)',
        breedingCharacteristics: 'High calving ease, strong maternal instinct',
        economicValue: 'Draft capacity saves ₹35,000/yr in diesel fuel',
        advantages: ['Extreme Heat Tolerance', 'Zero Diesel Tillage Capability', 'High FMD Immunity'],
        disadvantages: ['Moderate milk yield compared to commercial milch breeds'],
        interestingFacts: ['Famous for Jallikattu and traditional temple bull breeding.'],
        governmentRecognition: 'NBAGR Registered (Breed Code: INDIA_CATTLE_1800_KANGAYAM_03009)',
        conservationStatus: 'Protected Native Breed',
        suitableStates: ['Tamil Nadu', 'Karnataka', 'Andhra Pradesh'],
        recommendedTempRange: '20°C - 48°C',
        rainfallRangeMm: '400 - 900 mm',
        waterRequirement: 'Low to Moderate',
      ),
      const BreedInfoModel(
        id: 'gir',
        name: 'Gir Cow',
        species: 'Cattle (Bos indicus)',
        origin: 'Gir Forest & Kathiawar, Gujarat',
        nativeRegion: 'Gujarat & Central India',
        history: 'Renowned ancient milch breed known for distinct convex forehead and long pendulous ears.',
        climateSuitability: 'Warm Tropical & Dry Semi-Arid Plains',
        milkProductionLiters: '1800 - 2400 L / Lactation (Fat: 4.5% - 5.2% A2)',
        diseaseResistanceScore: 96.0,
        bodyWeightKg: '550-650 kg (Bull), 380-450 kg (Cow)',
        lifespanYears: '16-20 Years',
        feedRequirement: 'Moderate (Green fodder & grain concentrate)',
        maintenanceCost: 'Moderate (₹180/day)',
        breedingCharacteristics: 'Long lactation length (300+ days)',
        economicValue: 'A2 Milk sells at premium prices (₹90-120/L)',
        advantages: ['Top Milch Yield', 'Gentle Temperament', 'Tick & Parasite Resistant'],
        disadvantages: ['Requires mineral supplementation during peak milk yield'],
        interestingFacts: ['Exported to Brazil to establish world-class Gyrolando dairy cattle.'],
        governmentRecognition: 'NBAGR Registered (Breed Code: INDIA_CATTLE_0400_GIR_03008)',
        conservationStatus: 'Commercial Native Milch Breed',
        suitableStates: ['Gujarat', 'Maharashtra', 'Rajasthan', 'Madhya Pradesh', 'Tamil Nadu'],
        recommendedTempRange: '18°C - 42°C',
        rainfallRangeMm: '500 - 1200 mm',
        waterRequirement: 'Moderate',
      ),
      const BreedInfoModel(
        id: 'sahiwal',
        name: 'Sahiwal Cow',
        species: 'Cattle (Bos indicus)',
        origin: 'Sahiwal / Montgomery Region (Punjab border)',
        nativeRegion: 'North & Central India Plains',
        history: 'Heaviest milch cattle breed of India, distinguished by reddish-brown coat and loose skin.',
        climateSuitability: 'Subtropical Dry Plains & Heat Wave Adaptable',
        milkProductionLiters: '2000 - 2800 L / Lactation (A2 Protein)',
        diseaseResistanceScore: 95.2,
        bodyWeightKg: '500-600 kg (Bull), 360-420 kg (Cow)',
        lifespanYears: '15-18 Years',
        feedRequirement: 'Moderate',
        maintenanceCost: 'Moderate (₹190/day)',
        breedingCharacteristics: 'High milk persistence across multiple calvings',
        economicValue: 'High ROI for commercial A2 dairy ventures',
        advantages: ['Highest Milk Yield among native breeds', 'Mastitis Immunity', 'Tick Resistant'],
        disadvantages: ['Sluggish draft performance'],
        interestingFacts: ['Widely cross-bred globally due to high thermotolerance.'],
        governmentRecognition: 'NBAGR Registered (Breed Code: INDIA_CATTLE_1700_SAHIWAL_03026)',
        conservationStatus: 'Popular Milch Breed',
        suitableStates: ['Punjab', 'Haryana', 'Uttar Pradesh', 'Rajasthan', 'Tamil Nadu'],
        recommendedTempRange: '15°C - 44°C',
        rainfallRangeMm: '450 - 1000 mm',
        waterRequirement: 'Moderate',
      ),
      const BreedInfoModel(
        id: 'ongole',
        name: 'Ongole Cattle',
        species: 'Cattle (Bos indicus)',
        origin: 'Prakasam / Guntur District, Andhra Pradesh',
        nativeRegion: 'Coastal Andhra Pradesh',
        history: 'Famous dual-purpose draft & milch breed exported to create American Brahman cattle.',
        climateSuitability: 'Humid Coastal & Hot Subtropical',
        milkProductionLiters: '1000 - 1400 L / Lactation',
        diseaseResistanceScore: 97.0,
        bodyWeightKg: '600-700 kg (Bull), 400-500 kg (Cow)',
        lifespanYears: '18-20 Years',
        feedRequirement: 'Moderate to Low',
        maintenanceCost: 'Moderate (₹160/day)',
        breedingCharacteristics: 'Massive muscular frame with powerful muscular hump',
        economicValue: 'High export value for pedigree breeding stock',
        advantages: ['Muscular Heavy Draft', 'Coastal Humidity Tolerance', 'Eye Cancer Immunity'],
        disadvantages: ['Requires large open grazing enclosures'],
        interestingFacts: ['Formed the foundation backbone of the global Brahman cattle breed.'],
        governmentRecognition: 'NBAGR Registered (Breed Code: INDIA_CATTLE_0100_ONGOLE_03020)',
        conservationStatus: 'Protected Dual-Purpose Breed',
        suitableStates: ['Andhra Pradesh', 'Telangana', 'Tamil Nadu'],
        recommendedTempRange: '22°C - 46°C',
        rainfallRangeMm: '600 - 1300 mm',
        waterRequirement: 'Moderate',
      ),
      const BreedInfoModel(
        id: 'malabari',
        name: 'Tellicherry / Malabari Goat',
        species: 'Goat (Capra hircus)',
        origin: 'Malabar Region, North Kerala',
        nativeRegion: 'Coastal Kerala & Western Ghats',
        history: 'Prolific native dual goat breed reared by traditional coastal and hilly homesteads.',
        climateSuitability: 'Humid Tropical, Coastal & Heavy Rainfall',
        milkProductionLiters: '1.5 - 2.5 L / Day (Fat: 4.0%)',
        diseaseResistanceScore: 94.5,
        bodyWeightKg: '40-50 kg (Buck), 30-38 kg (Doe)',
        lifespanYears: '10-12 Years',
        feedRequirement: 'Low (Staple tree fodder & jackfruit leaves)',
        maintenanceCost: 'Very Low (₹35/day)',
        breedingCharacteristics: 'High kidding rate: 50% twins, 25% triplets',
        economicValue: 'High meat & milk return in 8-10 months',
        advantages: ['High Prolificacy (Twins/Triplets)', 'PPR & Worm Immunity', 'Fast Growth Rate'],
        disadvantages: ['Requires stall-feeding in heavy rain'],
        interestingFacts: ['Coat colors vary widely from white, black, to brown patches.'],
        governmentRecognition: 'NBAGR Registered (Breed Code: INDIA_GOAT_0900_MALABARI_06012)',
        conservationStatus: 'Stable Native Goat Breed',
        suitableStates: ['Kerala', 'Tamil Nadu', 'Karnataka'],
        recommendedTempRange: '20°C - 38°C',
        rainfallRangeMm: '1200 - 3000 mm',
        waterRequirement: 'Low',
      ),
    ]);

    _articles.addAll([
      const KnowledgeArticleModel(
        id: 'art_101',
        title: 'Rashtriya Gokul Mission (RGM) Native Breed Subsidy',
        category: 'Govt Schemes',
        readTime: '4 min read',
        summary: '50% capital subsidy up to ₹50 Lakhs for setting up Kangayam & Gir breed multiplication farms.',
        fullContent: 'Under RGM, individual farmers, FPOs, and SHGs are eligible for 50% capital subsidy for establishing native cattle breeding units.',
        author: 'Ministry of Animal Husbandry',
      ),
      const KnowledgeArticleModel(
        id: 'art_102',
        title: 'Summer Heat Stress Mitigation in Zebu Cows',
        category: 'Seasonal Advice',
        readTime: '6 min read',
        summary: 'Feeding electrolyte-enriched fodder and providing shade reduces THI heat stress by 15%.',
        fullContent: 'Indigenous Zebu cattle maintain normal body temp via dewlap heat dissipation. Supplement with green fodder during midday.',
        author: 'Dr. Ananya Sharma',
      ),
    ]);
  }

  @override
  Future<List<BreedInfoModel>> getAllBreeds() async {
    return List.unmodifiable(_breeds);
  }

  @override
  Future<BreedInfoModel?> getBreedById(String id) async {
    try {
      return _breeds.firstWhere((b) => b.id == id || b.name.toLowerCase().contains(id.toLowerCase()));
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<KnowledgeArticleModel>> getArticles() async {
    return List.unmodifiable(_articles);
  }

  @override
  Future<void> toggleBookmarkArticle(String articleId) async {
    final idx = _articles.indexWhere((a) => a.id == articleId);
    if (idx != -1) {
      final current = _articles[idx];
      _articles[idx] = current.copyWith(isBookmarked: !current.isBookmarked);
    }
  }
}
