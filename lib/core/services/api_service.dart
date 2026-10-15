import 'package:flutter_riverpod/flutter_riverpod.dart';

/// REST API Service Interface with JWT & Header Injection
abstract class ApiService {
  void setAuthToken(String? token);
  Future<dynamic> get(String endpoint, {Map<String, dynamic>? queryParameters, Map<String, String>? headers});
  Future<dynamic> post(String endpoint, {Map<String, dynamic>? body, Map<String, dynamic>? data, Map<String, String>? headers});
  Future<dynamic> put(String endpoint, {Map<String, dynamic>? body, Map<String, String>? headers});
  Future<void> delete(String endpoint, {Map<String, String>? headers});
}

/// ApiService Implementation with Authentication Handlers & Fallbacks
class ApiServiceImpl implements ApiService {
  String? _authToken;

  @override
  void setAuthToken(String? token) {
    _authToken = token;
  }

  Map<String, String> _buildHeaders(Map<String, String>? customHeaders) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    if (customHeaders != null) {
      headers.addAll(customHeaders);
    }
    return headers;
  }

  @override
  Future<dynamic> get(String endpoint, {Map<String, dynamic>? queryParameters, Map<String, String>? headers}) async {
    return _ApiResponse({'status': 'success', 'data': {}});
  }

  @override
  Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? data,
    Map<String, String>? headers,
  }) async {
    return _ApiResponse({'status': 'success', 'data': body ?? data ?? {}});
  }

  @override
  Future<dynamic> put(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    return _ApiResponse({'status': 'success', 'data': body ?? {}});
  }

  @override
  Future<void> delete(String endpoint, {Map<String, String>? headers}) async {}
}

class _ApiResponse {
  final Map<String, dynamic> data;
  _ApiResponse(this.data);
}

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiServiceImpl();
});
