import 'package:equatable/equatable.dart';
import 'user_model.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  offline,
  sessionExpired,
  error,
}

/// Immutable Authentication State for Riverpod Controller
class AuthState extends Equatable {
  final AuthStatus status;
  final UserModel? user;
  final String? token;
  final String? refreshToken;
  final String? errorMessage;
  final bool isOffline;
  final bool rememberMe;
  final String? pendingOtpPhone;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.token,
    this.refreshToken,
    this.errorMessage,
    this.isOffline = false,
    this.rememberMe = true,
    this.pendingOtpPhone,
  });

  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    String? token,
    String? refreshToken,
    String? errorMessage,
    bool? isOffline,
    bool? rememberMe,
    String? pendingOtpPhone,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
      errorMessage: errorMessage ?? this.errorMessage,
      isOffline: isOffline ?? this.isOffline,
      rememberMe: rememberMe ?? this.rememberMe,
      pendingOtpPhone: pendingOtpPhone ?? this.pendingOtpPhone,
    );
  }

  @override
  List<Object?> get props => [
        status,
        user,
        token,
        refreshToken,
        errorMessage,
        isOffline,
        rememberMe,
        pendingOtpPhone,
      ];
}
