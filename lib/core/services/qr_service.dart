import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final qrServiceProvider = Provider<QRService>((ref) {
  return QRService();
});

/// QR Code Generation & Livestock Profile Sharing Service
class QRService {
  String generateAnimalQRCodeData({
    required String animalId,
    required String earTag,
    required String breed,
    required String ownerName,
  }) {
    final payload = {
      'app': 'PasuMitraAI',
      'animal_id': animalId,
      'ear_tag': earTag,
      'breed': breed,
      'owner': ownerName,
      'timestamp': DateTime.now().toIso8601String(),
    };
    return jsonEncode(payload);
  }

  Map<String, dynamic>? parseScannedQRCode(String qrRawData) {
    try {
      return jsonDecode(qrRawData) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }
}
