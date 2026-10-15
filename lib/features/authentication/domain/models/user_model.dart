import 'package:equatable/equatable.dart';
import '../user_role.dart';

/// Specific profile extensions for each user role
class FarmerProfile extends Equatable {
  final String state;
  final String district;
  final String village;
  final String livestockFocus;

  const FarmerProfile({
    required this.state,
    required this.district,
    required this.village,
    required this.livestockFocus,
  });

  Map<String, dynamic> toJson() => {
        'state': state,
        'district': district,
        'village': village,
        'livestock_focus': livestockFocus,
      };

  factory FarmerProfile.fromJson(Map<String, dynamic> json) => FarmerProfile(
        state: json['state'] ?? '',
        district: json['district'] ?? '',
        village: json['village'] ?? '',
        livestockFocus: json['livestock_focus'] ?? 'Cattle & Goats',
      );

  @override
  List<Object?> get props => [state, district, village, livestockFocus];
}

class VeterinaryProfile extends Equatable {
  final String registrationNumber;
  final String specialization;
  final String clinicAddress;

  const VeterinaryProfile({
    required this.registrationNumber,
    required this.specialization,
    required this.clinicAddress,
  });

  Map<String, dynamic> toJson() => {
        'registration_number': registrationNumber,
        'specialization': specialization,
        'clinic_address': clinicAddress,
      };

  factory VeterinaryProfile.fromJson(Map<String, dynamic> json) => VeterinaryProfile(
        registrationNumber: json['registration_number'] ?? '',
        specialization: json['specialization'] ?? 'Breeding Specialist',
        clinicAddress: json['clinic_address'] ?? '',
      );

  @override
  List<Object?> get props => [registrationNumber, specialization, clinicAddress];
}

class AdminProfile extends Equatable {
  final String department;
  final String adminLevel;

  const AdminProfile({
    required this.department,
    required this.adminLevel,
  });

  Map<String, dynamic> toJson() => {
        'department': department,
        'admin_level': adminLevel,
      };

  factory AdminProfile.fromJson(Map<String, dynamic> json) => AdminProfile(
        department: json['department'] ?? 'AgriTech Management',
        adminLevel: json['admin_level'] ?? 'SuperAdmin',
      );

  @override
  List<Object?> get props => [department, adminLevel];
}

/// Primary User Domain Entity
class UserModel extends Equatable {
  final String id;
  final String fullName;
  final String mobile;
  final String email;
  final UserRole role;
  final String language;
  final bool isActive;
  final FarmerProfile? farmerProfile;
  final VeterinaryProfile? veterinaryProfile;
  final AdminProfile? adminProfile;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.mobile,
    required this.email,
    required this.role,
    this.language = 'en',
    this.isActive = true,
    this.farmerProfile,
    this.veterinaryProfile,
    this.adminProfile,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'full_name': fullName,
        'mobile': mobile,
        'email': email,
        'role': role.name,
        'language': language,
        'is_active': isActive,
        'farmer_profile': farmerProfile?.toJson(),
        'veterinary_profile': veterinaryProfile?.toJson(),
        'admin_profile': adminProfile?.toJson(),
      };

  factory UserModel.fromJson(Map<String, dynamic> json) {
    UserRole parsedRole;
    final roleStr = json['role'] as String?;
    if (roleStr == 'veterinaryExpert' || roleStr == 'veterinary_expert') {
      parsedRole = UserRole.veterinaryExpert;
    } else if (roleStr == 'administrator' || roleStr == 'admin') {
      parsedRole = UserRole.administrator;
    } else if (roleStr == 'urbanFarmer') {
      parsedRole = UserRole.urbanFarmer;
    } else {
      parsedRole = UserRole.ruralFarmer;
    }

    return UserModel(
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? json['fullName'] ?? '',
      mobile: json['mobile'] ?? '',
      email: json['email'] ?? '',
      role: parsedRole,
      language: json['language'] ?? 'en',
      isActive: json['is_active'] ?? true,
      farmerProfile: json['farmer_profile'] != null
          ? FarmerProfile.fromJson(json['farmer_profile'])
          : null,
      veterinaryProfile: json['veterinary_profile'] != null
          ? VeterinaryProfile.fromJson(json['veterinary_profile'])
          : null,
      adminProfile: json['admin_profile'] != null
          ? AdminProfile.fromJson(json['admin_profile'])
          : null,
    );
  }

  UserModel copyWith({
    String? id,
    String? fullName,
    String? mobile,
    String? email,
    UserRole? role,
    String? language,
    bool? isActive,
    FarmerProfile? farmerProfile,
    VeterinaryProfile? veterinaryProfile,
    AdminProfile? adminProfile,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      role: role ?? this.role,
      language: language ?? this.language,
      isActive: isActive ?? this.isActive,
      farmerProfile: farmerProfile ?? this.farmerProfile,
      veterinaryProfile: veterinaryProfile ?? this.veterinaryProfile,
      adminProfile: adminProfile ?? this.adminProfile,
    );
  }

  @override
  List<Object?> get props => [
        id,
        fullName,
        mobile,
        email,
        role,
        language,
        isActive,
        farmerProfile,
        veterinaryProfile,
        adminProfile,
      ];
}
