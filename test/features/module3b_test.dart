import 'package:flutter_test/flutter_test.dart';
import 'package:indigenous_livestock_app/core/services/sqlite_service.dart';
import 'package:indigenous_livestock_app/core/services/firebase_service.dart';
import 'package:indigenous_livestock_app/core/services/location_service.dart';

void main() {
  group('Module 3B Core Services Unit Tests', () {
    test('SQLiteService local cache & queue', () async {
      final sqlite = SQLiteService();
      await sqlite.initDatabase();

      await sqlite.cacheUserData('u1', {'name': 'Ramesh'});
      final data = await sqlite.getCachedUserData('u1');
      expect(data?['name'], equals('Ramesh'));

      await sqlite.enqueueSyncAction('CREATE_ANIMAL', {'name': 'Valli'});
      final queue = await sqlite.getSyncQueue();
      expect(queue.length, equals(1));

      await sqlite.clearSyncQueue();
      expect((await sqlite.getSyncQueue()).length, equals(0));
    });

    test('FirebaseService FCM tokens', () async {
      final fb = FirebaseService();
      final token = await fb.getFCMToken();
      expect(token, isNotNull);
      expect(fb.notificationsEnabled, isTrue);

      fb.toggleNotifications(false);
      expect(fb.notificationsEnabled, isFalse);
    });

    test('LocationService GPS geocoding', () async {
      final loc = LocationService();
      final gps = await loc.getCurrentGPSLocation();
      expect(gps['state'], equals('Tamil Nadu'));
      expect(gps['district'], equals('Coimbatore'));

      loc.updateManualLocation(state: 'Gujarat', district: 'Gir Somnath', village: 'Veraval');
      final updated = await loc.getCurrentGPSLocation();
      expect(updated['state'], equals('Gujarat'));
    });
  });
}
