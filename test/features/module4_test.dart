import 'package:flutter_test/flutter_test.dart';
import 'package:indigenous_livestock_app/core/services/voice_service.dart';
import 'package:indigenous_livestock_app/core/services/qr_service.dart';
import 'package:indigenous_livestock_app/core/services/pdf_service.dart';
import 'package:indigenous_livestock_app/core/services/vision_service.dart';

void main() {
  group('Module 4 Core Services Unit Tests', () {
    test('VoiceService shortcut command processing', () {
      final voice = VoiceService();
      expect(voice.processVoiceCommand('Recommend a breed'), equals('/recommendation'));
      expect(voice.processVoiceCommand('Show vaccination schedule'), equals('/farmer/medical-vaccination'));
      expect(voice.processVoiceCommand('Explain this disease'), equals('/vet/diseases'));
      expect(voice.processVoiceCommand('Show government schemes'), equals('/government-schemes'));
    });

    test('QRService JSON serialization and parsing', () {
      final qr = QRService();
      final encoded = qr.generateAnimalQRCodeData(
        animalId: 'a123',
        earTag: 'KANG-01',
        breed: 'Kangayam',
        ownerName: 'Ramesh',
      );

      final parsed = qr.parseScannedQRCode(encoded);
      expect(parsed?['animal_id'], equals('a123'));
      expect(parsed?['breed'], equals('Kangayam'));
    });

    test('PDFService report file generation path', () async {
      final pdf = PDFService();
      final path = await pdf.generateRecommendationPDFReport(
        farmerName: 'Ramesh Kumar',
        breedName: 'Kangayam Cattle',
        confidence: 96.8,
        climateDesc: 'Semi-Arid',
        diseaseDesc: 'High Immunity',
      );

      expect(path, contains('Ramesh_Kumar.pdf'));
    });

    test('VisionService image quality validation', () async {
      final vision = VisionService();
      final res = await vision.preprocessAndValidateImage('/path/to/lesion.jpg');
      expect(res['is_valid_quality'], isTrue);
      expect(res['flagged_for_vet'], isTrue);
    });
  });
}
