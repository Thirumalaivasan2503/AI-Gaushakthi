import '../../../../core/services/api_service.dart';
import '../../../../core/services/sqlite_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../domain/models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/user_role.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiService apiService;
  final SQLiteService sqliteService;
  final StorageService storageService;

  AuthRepositoryImpl({
    required this.apiService,
    required this.sqliteService,
    required this.storageService,
  });

  @override
  Future<UserModel> loginWithEmail({
    required String email,
    required String password,
  }) async {
    final response = await apiService.post('/auth/login', body: {
      'email': email,
      'password': password,
    });

    final mockUser = _generateMockUser(
      email: email,
      mobile: '+91 98765 43210',
      fullName: 'Ramesh Kumar',
      role: UserRole.ruralFarmer,
    );

    final token = response['data']?['access_token'] ?? 'mock_jwt_access_token_12345';
    final refreshToken = response['data']?['refresh_token'] ?? 'mock_jwt_refresh_token_12345';

    apiService.setAuthToken(token);
    await saveSessionToCache(mockUser, token, refreshToken);

    return mockUser;
  }

  @override
  Future<UserModel> loginWithMobile({
    required String mobile,
    required String password,
  }) async {
    final response = await apiService.post('/auth/login/mobile', body: {
      'mobile': mobile,
      'password': password,
    });

    final mockUser = _generateMockUser(
      email: 'farmer@pasumitra.org',
      mobile: mobile,
      fullName: 'Sundareshan M',
      role: UserRole.ruralFarmer,
    );

    final token = response['data']?['access_token'] ?? 'mock_jwt_access_token_12345';
    final refreshToken = response['data']?['refresh_token'] ?? 'mock_jwt_refresh_token_12345';

    apiService.setAuthToken(token);
    await saveSessionToCache(mockUser, token, refreshToken);

    return mockUser;
  }

  @override
  Future<void> sendOtp({required String mobile}) async {
    await apiService.post('/auth/login/mobile', body: {'mobile': mobile});
  }

  @override
  Future<UserModel> verifyOtp({
    required String mobile,
    required String otp,
  }) async {
    final response = await apiService.post('/auth/verify-otp', body: {
      'mobile': mobile,
      'otp': otp,
    });

    UserRole userRole = UserRole.ruralFarmer;
    if (mobile.contains('99999') || mobile.contains('98000')) {
      userRole = UserRole.veterinaryExpert;
    } else if (mobile.contains('88888') || mobile.contains('97000')) {
      userRole = UserRole.administrator;
    }

    final mockUser = _generateMockUser(
      email: 'user@pasumitra.org',
      mobile: mobile,
      fullName: userRole == UserRole.veterinaryExpert
          ? 'Dr. Ananya Sharma (Vet Specialist)'
          : (userRole == UserRole.administrator ? 'Admin Rajesh (AgriTech)' : 'Farmer Suresh'),
      role: userRole,
    );

    final token = response['data']?['access_token'] ?? 'mock_jwt_access_token_12345';
    final refreshToken = response['data']?['refresh_token'] ?? 'mock_jwt_refresh_token_12345';

    apiService.setAuthToken(token);
    await saveSessionToCache(mockUser, token, refreshToken);

    return mockUser;
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
    final response = await apiService.post('/auth/register', body: {
      'full_name': fullName,
      'mobile': mobile,
      'email': email,
      'password': password,
      'role': role.name,
      'state': state,
      'district': district,
      'village': village,
    });

    final mockUser = UserModel(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      fullName: fullName,
      mobile: mobile,
      email: email,
      role: role,
      farmerProfile: FarmerProfile(
        state: state ?? 'Tamil Nadu',
        district: district ?? 'Coimbatore',
        village: village ?? 'Pillur',
        livestockFocus: 'Kangayam Cattle & Salem Black Goats',
      ),
    );

    final token = response['data']?['access_token'] ?? 'mock_jwt_access_token_new_reg';
    final refreshToken = response['data']?['refresh_token'] ?? 'mock_jwt_refresh_token_new_reg';

    apiService.setAuthToken(token);
    await saveSessionToCache(mockUser, token, refreshToken);

    return mockUser;
  }

  @override
  Future<void> forgotPassword({required String identity}) async {
    await apiService.post('/auth/forgot-password', body: {'identity': identity});
  }

  @override
  Future<void> resetPassword({
    required String identity,
    required String otp,
    required String newPassword,
  }) async {
    await apiService.post('/auth/reset-password', body: {
      'identity': identity,
      'otp': otp,
      'new_password': newPassword,
    });
  }

  @override
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    await apiService.post('/auth/change-password', body: {
      'old_password': oldPassword,
      'new_password': newPassword,
    });
  }

  @override
  Future<Map<String, String>> refreshToken({required String refreshToken}) async {
    final response = await apiService.post('/auth/refresh', body: {
      'refresh_token': refreshToken,
    });
    final newToken = response['data']?['access_token'] ?? 'refreshed_access_token_999';
    final newRefresh = response['data']?['refresh_token'] ?? refreshToken;

    apiService.setAuthToken(newToken);
    await storageService.setString('access_token', newToken);
    await storageService.setString('refresh_token', newRefresh);

    return {'access_token': newToken, 'refresh_token': newRefresh};
  }

  @override
  Future<void> logout() async {
    await apiService.post('/auth/logout');
    apiService.setAuthToken(null);
    await sqliteService.clearCachedUserProfile();
    await sqliteService.clearOfflineSession();
    await storageService.remove('access_token');
    await storageService.remove('refresh_token');
    await storageService.remove('user_profile');
  }

  @override
  Future<UserModel?> getCachedSession() async {
    final cached = await sqliteService.getCachedUserProfile();
    if (cached != null && cached.isNotEmpty) {
      return UserModel.fromJson(cached);
    }
    return null;
  }

  @override
  Future<void> saveSessionToCache(UserModel user, String token, String refreshToken) async {
    await sqliteService.cacheUserProfile(user.toJson());
    await sqliteService.saveOfflineSession(user.id, token);
    await storageService.setString('access_token', token);
    await storageService.setString('refresh_token', refreshToken);
  }

  UserModel _generateMockUser({
    required String email,
    required String mobile,
    required String fullName,
    required UserRole role,
  }) {
    return UserModel(
      id: 'usr_1001',
      fullName: fullName,
      mobile: mobile,
      email: email,
      role: role,
      language: 'en',
      farmerProfile: const FarmerProfile(
        state: 'Tamil Nadu',
        district: 'Coimbatore',
        village: 'Kottur',
        livestockFocus: 'Kangayam Cattle & Bargur Cows',
      ),
      veterinaryProfile: role == UserRole.veterinaryExpert
          ? const VeterinaryProfile(
              registrationNumber: 'VET-TN-2024-998',
              specialization: 'Indigenous Breed Breeding & Artificial Insemination',
              clinicAddress: 'District Veterinary Hospital, Pollachi Road',
            )
          : null,
      adminProfile: role == UserRole.administrator
          ? const AdminProfile(
              department: 'State Animal Husbandry & Genetics Board',
              adminLevel: 'System Administrator',
            )
          : null,
    );
  }
}
