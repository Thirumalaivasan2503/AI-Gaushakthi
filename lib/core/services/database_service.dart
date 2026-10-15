import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Abstract SQLite Database Service Interface (Architecture preparation for offline storage)
abstract class DatabaseService {
  Future<void> init();
  Future<List<Map<String, dynamic>>> query(String table, {String? where, List<dynamic>? whereArgs});
  Future<int> insert(String table, Map<String, dynamic> data);
  Future<int> update(String table, Map<String, dynamic> data, {required String where, required List<dynamic> whereArgs});
  Future<int> delete(String table, {required String where, required List<dynamic> whereArgs});
}

class DatabaseServiceImpl implements DatabaseService {
  @override
  Future<void> init() async {}

  @override
  Future<List<Map<String, dynamic>>> query(String table, {String? where, List<dynamic>? whereArgs}) async {
    return [];
  }

  @override
  Future<int> insert(String table, Map<String, dynamic> data) async => 1;

  @override
  Future<int> update(String table, Map<String, dynamic> data, {required String where, required List<dynamic> whereArgs}) async => 1;

  @override
  Future<int> delete(String table, {required String where, required List<dynamic> whereArgs}) async => 1;
}

final databaseServiceProvider = Provider<DatabaseService>((ref) {
  return DatabaseServiceImpl();
});
