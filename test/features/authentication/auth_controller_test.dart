import 'package:flutter_test/flutter_test.dart';
import 'package:indigenous_livestock_app/features/authentication/domain/models/auth_state.dart';
import 'package:indigenous_livestock_app/features/authentication/domain/models/user_model.dart';
import 'package:indigenous_livestock_app/features/authentication/domain/user_role.dart';
import 'package:indigenous_livestock_app/features/authentication/domain/repositories/auth_repository.dart';
import 'package:indigenous_livestock_app/features/authentication/presentation/controllers/auth_controller.dart';

class MockAuthRepository implements AuthRepository {
  bool shouldFail = false;

  @override
  Future<UserModel> loginWithEmail({required String email, required String password}) async {
    if (shouldFail) throw Exception('Login failed');
    return const UserModel(
      id: 'usr_test_1',
      fullName: 'Test Farmer',
      mobile: '+919876543210',
      email: 'test@pasumitra.org',
      role: UserRole.ruralFarmer,
    );
  }

  @override
  Future<UserModel> loginWithMobile({required String mobile, required String password}) async {
    if (shouldFail) throw Exception('Login failed');
    return const UserModel(
      id: 'usr_test_2',
      fullName: 'Test Mobile User',
      mobile: mobile,
      email: 'mobile@pasumitra.org',
      role: UserRole.ruralFarmer,
    );
  }

  @override
  Future<void> sendOtp({required String mobile}) async {}

  @override
  Future<UserModel> verifyOtp({required String mobile, required String otp}) async {
    if (otp != '123456') throw Exception('Invalid OTP');
    return const UserModel(
      id: 'usr_test_otp',
      fullName: 'OTP Verified User',
      mobile: mobile,
      email: 'otp@pasumitra.org',
      role: UserRole.ruralFarmer,
    );
  }

  @override
  Future<UserModel> register({
    required String fullName,
    required String mobile,
    required String email,
    required String password,
    required UserRole role,
    String? state,
    String? district,
    String? village,
  }) async {
    return UserModel(
      id: 'usr_registered',
      fullName: fullName,
      mobile: mobile,
      email: email,
      role: role,
    );
  }

  @override
  Future<void> forgotPassword({required String identity}) async {}

  @override
  Future<void> resetPassword({required String identity, required String otp, required String newPassword}) async {}

  @override
  Future<void> changePassword({required String oldPassword, required String newPassword}) async {}

  @override
  Future<Map<String, String>> refreshToken({required String refreshToken}) async {
    return {'access_token': 'new_access', 'refresh_token': 'new_refresh'};
  }

  @override
  Future<void> logout() async {}

  @override
  Future<UserModel?> getCachedSession() async => null;

  @override
  Future<void> saveSessionToCache(UserModel user, String token, String refreshToken) async {}
}

void main() {
  group('AuthController Riverpod State Tests', () {
    late MockAuthRepository mockRepo;
    late AuthController controller;

    setUp(() {
      mockRepo = MockAuthRepository();
      controller = AuthController(mockRepo);
    });

    test('initial state sets to unauthenticated when cache is empty', () async {
      await controller.checkAutoLogin();
      expect(controller.debugState.status, equals(AuthStatus.unauthenticated));
    });

    test('loginWithMobile updates state to authenticated on success', () async {
      await controller.loginWithMobile('+919876543210', 'Password123');
      expect(controller.debugState.status, equals(AuthStatus.authenticated));
      expect(controller.debugState.user?.fullName, equals('Test Mobile User'));
    });

    test('verifyOtp updates state to authenticated when correct OTP provided', () async {
      await controller.verifyOtp('+919876543210', '123456');
      expect(controller.debugState.status, equals(AuthStatus.authenticated));
    });

    test('verifyOtp updates state to error when wrong OTP provided', () async {
      await controller.verifyOtp('+919876543210', '000000');
      expect(controller.debugState.status, equals(AuthStatus.error));
      expect(controller.debugState.errorMessage, contains('Invalid 6-digit OTP code'));
    });

    test('logout resets state to unauthenticated', () async {
      await controller.loginWithMobile('+919876543210', 'Password123');
      await controller.logout();
      expect(controller.debugState.status, equals(AuthStatus.unauthenticated));
      expect(controller.debugState.user, isNull);
    });
  });
}
