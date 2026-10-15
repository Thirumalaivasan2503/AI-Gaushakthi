import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final sqliteServiceProvider = Provider<SQLiteService>((ref) {
  return SQLiteService();
});

/// SQLite Local Cache & Offline Data Store Service
class SQLiteService {
  final Map<String, String> _localStore = {};
  final List<Map<String, dynamic>> _offlineSyncQueue = [];

  Future<void> initDatabase() async {
    // Simulated SQLite initialization
  }

  Future<void> cacheUserData(String userId, Map<String, dynamic> userData) async {
    _localStore['user_$userId'] = jsonEncode(userData);
    _localStore['current_profile'] = jsonEncode(userData);
  }

  Future<void> cacheUserProfile(Map<String, dynamic> profileData) async {
    final userId = profileData['user_id'] ?? profileData['userId'] ?? 'current';
    await cacheUserData(userId, profileData);
  }

  Future<Map<String, dynamic>?> getCachedUserData(String userId) async {
    final data = _localStore['user_$userId'];
    if (data != null) {
      return jsonDecode(data) as Map<String, dynamic>;
    }
    return null;
  }

  Future<Map<String, dynamic>?> getCachedUserProfile() async {
    final data = _localStore['current_profile'];
    if (data != null) {
      return jsonDecode(data) as Map<String, dynamic>;
    }
    return null;
  }

  Future<void> clearCachedUserProfile() async {
    _localStore.remove('current_profile');
  }

  Future<void> saveOfflineSession(String userId, String token) async {
    _localStore['session_user_id'] = userId;
    _localStore['session_token'] = token;
  }

  Future<void> clearOfflineSession() async {
    _localStore.remove('session_user_id');
    _localStore.remove('session_token');
  }

  Future<void> cacheWeather(String district, Map<String, dynamic> weatherData) async {
    _localStore['weather_$district'] = jsonEncode(weatherData);
  }

  Future<Map<String, dynamic>?> getCachedWeather(String district) async {
    final data = _localStore['weather_$district'];
    if (data != null) {
      return jsonDecode(data) as Map<String, dynamic>;
    }
    return null;
  }

  Future<void> enqueueSyncAction(String action, Map<String, dynamic> payload) async {
    _offlineSyncQueue.add({
      'id': 'queue_${DateTime.now().millisecondsSinceEpoch}',
      'action': action,
      'payload': payload,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  Future<void> addPendingSync(String action, Map<String, dynamic> payload) async {
    await enqueueSyncAction(action, payload);
  }

  Future<List<Map<String, dynamic>>> getSyncQueue() async {
    return List.unmodifiable(_offlineSyncQueue);
  }

  Future<void> clearSyncQueue() async {
    _offlineSyncQueue.clear();
  }

  Future<void> savePreference(String key, String value) async {
    _localStore['pref_$key'] = value;
  }

  Future<String?> getPreference(String key) async {
    return _localStore['pref_$key'];
  }
}
