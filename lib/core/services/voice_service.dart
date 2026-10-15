import 'package:flutter_riverpod/flutter_riverpod.dart';

final voiceServiceProvider = Provider<VoiceService>((ref) {
  return VoiceService();
});

/// Hands-Free Voice Engine (Speech-to-Text & Text-to-Speech)
class VoiceService {
  bool _isListening = false;
  bool get isListening => _isListening;

  Future<void> startListening({required Function(String text) onResult}) async {
    _isListening = true;
    // Simulated Voice STT listening
    await Future.delayed(const Duration(milliseconds: 1200));
    _isListening = false;
    onResult('Recommend a breed for semi-arid Tamil Nadu');
  }

  Future<void> stopListening() async {
    _isListening = false;
  }

  Future<void> speakText(String text, {String language = 'en'}) async {
    // Simulated Text-to-Speech output
  }

  String processVoiceCommand(String rawVoiceInput) {
    final lower = rawVoiceInput.toLowerCase();
    if (lower.contains('recommend')) return '/recommendation';
    if (lower.contains('vaccin')) return '/farmer/medical-vaccination';
    if (lower.contains('disease')) return '/vet/diseases';
    if (lower.contains('scheme')) return '/government-schemes';
    return '/home';
  }
}
