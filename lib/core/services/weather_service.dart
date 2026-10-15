import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_service.dart';
import 'sqlite_service.dart';

final weatherServiceProvider = Provider<WeatherService>((ref) {
  return WeatherService(
    apiService: ref.watch(apiServiceProvider),
    sqliteService: ref.watch(sqliteServiceProvider),
  );
});

/// Agronomic Weather Service with Local Cache
class WeatherService {
  final ApiService apiService;
  final SQLiteService sqliteService;

  WeatherService({
    required this.apiService,
    required this.sqliteService,
  });

  Future<Map<String, dynamic>> getCurrentWeather({String district = 'Coimbatore', String state = 'Tamil Nadu'}) async {
    try {
      final response = await apiService.get('/api/v1/weather/current', queryParameters: {'district': district, 'state': state});
      final data = response.data['data'] as Map<String, dynamic>;
      await sqliteService.cacheWeather(district, data);
      return data;
    } catch (_) {
      final cached = await sqliteService.getCachedWeather(district);
      if (cached != null) return cached;
      return {
        "state": state,
        "district": district,
        "temperature_c": 35.5,
        "humidity_percent": 62.0,
        "annual_rainfall_mm": 750.0,
        "wind_speed_kmh": 14.2,
        "heat_index_thi": 38.2,
        "climate_zone": "Semi-Arid Tropical",
        "forecast": "Clear sunny with evening light showers expected.",
      };
    }
  }
}
