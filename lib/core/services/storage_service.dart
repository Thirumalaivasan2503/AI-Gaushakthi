import 'package:flutter_riverpod/flutter_riverpod.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

/// Cloud Storage, Local Files & Key-Value Storage Manager
class StorageService {
  final Map<String, String> _keyValueStore = {};
  final List<String> _pendingUploadQueue = [];

  Future<void> setString(String key, String value) async {
    _keyValueStore[key] = value;
  }

  Future<String?> getString(String key) async {
    return _keyValueStore[key];
  }

  Future<void> remove(String key) async {
    _keyValueStore.remove(key);
  }

  Future<String> uploadFile({
    required String filePath,
    required String fileType,
  }) async {
    // Simulated cloud file upload with compression
    await Future.delayed(const Duration(milliseconds: 600));
    return 'https://storage.googleapis.com/pasumitra-ai-bucket/uploads/${DateTime.now().millisecondsSinceEpoch}.$fileType';
  }

  Future<void> queueOfflineUpload(String filePath) async {
    _pendingUploadQueue.add(filePath);
  }

  List<String> get pendingQueue => List.unmodifiable(_pendingUploadQueue);
}
