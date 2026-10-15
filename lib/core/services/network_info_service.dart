import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Network Connectivity Status Provider for Offline Mode Support
class NetworkInfoNotifier extends StateNotifier<bool> {
  NetworkInfoNotifier() : super(true); // Default to online

  void setOnlineStatus(bool isOnline) {
    state = isOnline;
  }

  void toggleStatus() {
    state = !state;
  }
}

final isOnlineProvider = StateNotifierProvider<NetworkInfoNotifier, bool>((ref) {
  return NetworkInfoNotifier();
});
