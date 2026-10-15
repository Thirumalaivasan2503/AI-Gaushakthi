import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_service.dart';
import 'sqlite_service.dart';

final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService(
    sqliteService: ref.watch(sqliteServiceProvider),
    apiService: ref.watch(apiServiceProvider),
  );
});

/// Background Synchronization Engine & Connectivity Processor
class SyncService {
  final SQLiteService sqliteService;
  final ApiService apiService;

  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;

  SyncService({
    required this.sqliteService,
    required this.apiService,
  });

  Future<void> triggerBackgroundSync() async {
    if (_isSyncing) return;
    _isSyncing = true;

    try {
      final queue = await sqliteService.getSyncQueue();
      if (queue.isNotEmpty) {
        await apiService.post('/api/v1/sync/push', data: {'client_queue': queue});
        await sqliteService.clearSyncQueue();
      }
    } catch (_) {
      // Exponential backoff or retry queueing
    } finally {
      _isSyncing = false;
    }
  }
}
