import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/sqlite_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/models/auth_state.dart';
import '../../domain/models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/user_role.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  final sqliteService = ref.watch(sqliteServiceProvider);
  final storageService = ref.watch(storageServiceProvider);

  return AuthRepositoryImpl(
    apiService: apiService,
    sqliteService: sqliteService,
    storageService: storageService,
  );
});

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthController(repository);
});

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthController(this._repository) : super(const AuthState()) {
    checkAutoLogin();
  }

  Future<void> checkAutoLogin() async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final cachedUser = await _repository.getCachedSession();
      if (cachedUser != null) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: cachedUser,
          isOffline: false,
        );
      } else {
        state = state.copyWith(status: AuthStatus.unauthenticated);
      }
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> loginWithMobile(String mobile, String password) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      final user = await _repository.loginWithMobile(
        mobile: mobile,
        password: password,
      );
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Invalid credentials. Please try again.',
      );
    }
  }

  Future<void> sendOtp(String mobile) async {
    state = state.copyWith(
      status: AuthStatus.loading,
      pendingOtpPhone: mobile,
      errorMessage: null,
    );
    try {
      await _repository.sendOtp(mobile: mobile);
      state = state.copyWith(status: AuthStatus.unauthenticated);
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Failed to send OTP to $mobile',
      );
    }
  }

  Future<void> verifyOtp(String mobile, String otp) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      final user = await _repository.verifyOtp(mobile: mobile, otp: otp);
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Invalid 6-digit OTP code. Please re-enter.',
      );
    }
  }

  Future<void> registerUser({
    required String fullName,
    required String mobile,
    required String email,
    required String password,
    required UserRole role,
    String? stateName,
    String? district,
    String? village,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      final user = await _repository.register(
        fullName: fullName,
        mobile: mobile,
        email: email,
        password: password,
        role: role,
        state: stateName,
        district: district,
        village: village,
      );
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Registration failed. User may already exist.',
      );
    }
  }

  Future<void> forgotPassword(String identity) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      await _repository.forgotPassword(identity: identity);
      state = state.copyWith(status: AuthStatus.unauthenticated);
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Could not send reset code.',
      );
    }
  }

  Future<void> resetPassword(String identity, String otp, String newPassword) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      await _repository.resetPassword(
        identity: identity,
        otp: otp,
        newPassword: newPassword,
      );
      state = state.copyWith(status: AuthStatus.unauthenticated);
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Failed to reset password.',
      );
    }
  }

  Future<void> logout() async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      await _repository.logout();
      state = const AuthState(status: AuthStatus.unauthenticated);
    } catch (e) {
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  void setRememberMe(bool value) {
    state = state.copyWith(rememberMe: value);
  }
}
