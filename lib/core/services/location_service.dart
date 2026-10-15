import 'package:flutter_riverpod/flutter_riverpod.dart';

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

/// GPS Location & Reverse Geocoding Service
class LocationService {
  String _currentState = 'Tamil Nadu';
  String _currentDistrict = 'Coimbatore';
  String _currentVillage = 'Kottur / Pollachi';
  double _latitude = 10.9984;
  double _longitude = 76.9616;

  Future<Map<String, dynamic>> getCurrentGPSLocation() async {
    return {
      'latitude': _latitude,
      'longitude': _longitude,
      'state': _currentState,
      'district': _currentDistrict,
      'village': _currentVillage,
      'climate_zone': 'Semi-Arid Tropical',
    };
  }

  void updateManualLocation({required String state, required String district, required String village}) {
    _currentState = state;
    _currentDistrict = district;
    _currentVillage = village;
  }
}
