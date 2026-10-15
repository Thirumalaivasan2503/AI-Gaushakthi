import 'package:flutter_test/flutter_test.dart';
import 'package:indigenous_livestock_app/features/authentication/domain/utils/validators.dart';

void main() {
  group('Validators Unit Tests', () {
    test('validateEmail returns null for valid email address', () {
      expect(Validators.validateEmail('farmer@pasumitra.org'), isNull);
      expect(Validators.validateEmail('vet.specialist@domain.co.in'), isNull);
    });

    test('validateEmail returns error message for invalid email', () {
      expect(Validators.validateEmail('invalid-email'), equals('Please enter a valid email address'));
      expect(Validators.validateEmail(''), equals('Email address is required'));
    });

    test('validateMobile returns null for valid 10-digit mobile number', () {
      expect(Validators.validateMobile('9876543210'), isNull);
      expect(Validators.validateMobile('+91 98765 43210'), isNull);
    });

    test('validateMobile returns error for short or empty mobile number', () {
      expect(Validators.validateMobile('123'), equals('Please enter a valid 10-digit mobile number'));
      expect(Validators.validateMobile(''), equals('Mobile number is required'));
    });

    test('validatePassword enforces minimum 8 chars, 1 letter, and 1 digit', () {
      expect(Validators.validatePassword('Password123'), isNull);
      expect(Validators.validatePassword('short'), equals('Password must be at least 8 characters long'));
      expect(Validators.validatePassword('123456789'), equals('Password must contain at least one letter'));
      expect(Validators.validatePassword('abcdefghijk'), equals('Password must contain at least one digit'));
    });

    test('validateOtp validates 6-digit PIN length', () {
      expect(Validators.validateOtp('123456'), isNull);
      expect(Validators.validateOtp('123'), equals('Please enter the complete 6-digit OTP code'));
      expect(Validators.validateOtp('abc123'), equals('Please enter the complete 6-digit OTP code'));
    });

    test('validateConfirmPassword checks matching string', () {
      expect(Validators.validateConfirmPassword('Password123', 'Password123'), isNull);
      expect(Validators.validateConfirmPassword('Password123', 'Different123'), equals('Passwords do not match'));
    });
  });
}
