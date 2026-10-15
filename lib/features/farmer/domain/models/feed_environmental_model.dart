import 'package:equatable/equatable.dart';

/// Feed & Environmental Data Collection Model (Prepares ML recommendation engine feature inputs)
class FeedEnvironmentalModel extends Equatable {
  final String id;
  final String farmerId;

  // Feed Management
  final String feedType; // Napier Grass, Sorghum, Wheat Straw, Cottonseed Cake, Mineral Blocks
  final double dailyQuantityKg;
  final double dailyCostInr;
  final double monthlyCostInr;
  final String waterAvailability; // Abundant Borewell, Rainfed Pond, Canal Irrigation, Limited
  final bool usesMineralSupplements;
  final String seasonalFeedChanges;

  // Agro-Environmental Parameters
  final double averageTemperatureC;
  final double annualRainfallMm;
  final double humidityPercentage;
  final String climateZone; // Semi-Arid, Arid, Humid Subtropical, Tropical Savanna
  final String waterSource; // River, Well, Canal, Rainwater
  final String soilType; // Red Loamy, Black Cotton, Sandy Loam, Clay
  final double grazingAreaAcres;
  final String currentSeason; // Summer, Monsoon, Winter, Post-Monsoon

  const FeedEnvironmentalModel({
    required this.id,
    required this.farmerId,
    this.feedType = 'Co-4 Napier Grass & Cottonseed Cake',
    this.dailyQuantityKg = 25.0,
    this.dailyCostInr = 180.0,
    this.monthlyCostInr = 5400.0,
    this.waterAvailability = 'Abundant Borewell & Canal',
    this.usesMineralSupplements = true,
    this.seasonalFeedChanges = 'Transition to Dry Fodder & Silage in Peak Summer',
    this.averageTemperatureC = 32.5,
    this.annualRainfallMm = 750.0,
    this.humidityPercentage = 68.0,
    this.climateZone = 'Semi-Arid Tropical',
    this.waterSource = 'Borewell & River Canal',
    this.soilType = 'Red Loamy Soil',
    this.grazingAreaAcres = 3.0,
    this.currentSeason = 'Monsoon / Kharif',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'farmer_id': farmerId,
        'feed_type': feedType,
        'daily_quantity_kg': dailyQuantityKg,
        'daily_cost_inr': dailyCostInr,
        'monthly_cost_inr': monthlyCostInr,
        'water_availability': waterAvailability,
        'uses_mineral_supplements': usesMineralSupplements,
        'seasonal_feed_changes': seasonalFeedChanges,
        'average_temperature_c': averageTemperatureC,
        'annual_rainfall_mm': annualRainfallMm,
        'humidity_percentage': humidityPercentage,
        'climate_zone': climateZone,
        'water_source': waterSource,
        'soil_type': soilType,
        'grazing_area_acres': grazingAreaAcres,
        'current_season': currentSeason,
      };

  factory FeedEnvironmentalModel.fromJson(Map<String, dynamic> json) => FeedEnvironmentalModel(
        id: json['id'] ?? '',
        farmerId: json['farmer_id'] ?? '',
        feedType: json['feed_type'] ?? 'Co-4 Napier Grass & Cottonseed Cake',
        dailyQuantityKg: (json['daily_quantity_kg'] as num?)?.toDouble() ?? 25.0,
        dailyCostInr: (json['daily_cost_inr'] as num?)?.toDouble() ?? 180.0,
        monthlyCostInr: (json['monthly_cost_inr'] as num?)?.toDouble() ?? 5400.0,
        waterAvailability: json['water_availability'] ?? 'Abundant Borewell & Canal',
        usesMineralSupplements: json['uses_mineral_supplements'] ?? true,
        seasonalFeedChanges: json['seasonal_feed_changes'] ?? 'Transition to Dry Fodder & Silage',
        averageTemperatureC: (json['average_temperature_c'] as num?)?.toDouble() ?? 32.5,
        annualRainfallMm: (json['annual_rainfall_mm'] as num?)?.toDouble() ?? 750.0,
        humidityPercentage: (json['humidity_percentage'] as num?)?.toDouble() ?? 68.0,
        climateZone: json['climate_zone'] ?? 'Semi-Arid Tropical',
        waterSource: json['water_source'] ?? 'Borewell & River Canal',
        soilType: json['soil_type'] ?? 'Red Loamy Soil',
        grazingAreaAcres: (json['grazing_area_acres'] as num?)?.toDouble() ?? 3.0,
        currentSeason: json['current_season'] ?? 'Monsoon / Kharif',
      );

  @override
  List<Object?> get props => [
        id,
        farmerId,
        feedType,
        dailyQuantityKg,
        dailyCostInr,
        monthlyCostInr,
        waterAvailability,
        usesMineralSupplements,
        seasonalFeedChanges,
        averageTemperatureC,
        annualRainfallMm,
        humidityPercentage,
        climateZone,
        waterSource,
        soilType,
        grazingAreaAcres,
        currentSeason,
      ];
}
