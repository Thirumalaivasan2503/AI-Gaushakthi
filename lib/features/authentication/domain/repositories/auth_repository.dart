import '../models/user_model.dart';
import '../user_role.dart';

/// Contract for Authentication Operations
abstract class AuthRepository {
  Future<UserModel> loginWithEmail({
    required String email,
    required String password,
  });

  Future<UserModel> loginWithMobile({
    required String mobile,
    required String password,
  });

  Future<void> sendOtp({required String mobile});

  Future<UserModel> verifyOtp({
    required String mobile,
    required String otp,
  });

  Future<UserModel> register({
    required String fullName,
    required String mobile,
    required String email,
    required String password,
    required UserRole role,
    String? state,
    String? district,
    String? village,
  });

  Future<void> forgotPassword({required String identity});

  Future<void> resetPassword({
    required String identity,
    required String otp,
    required String newPassword,
  });

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  });

  Future<Map<String, String>> refreshToken({required String refreshToken});

  Future<void> logout();

  Future<UserModel?> getCachedSession();

  Future<void> saveSessionToCache(UserModel user, String token, String refreshToken);
}
