import 'package:equatable/equatable.dart';

/// Productivity Goal Options for Indigenous Livestock Systems
enum ProductivityGoal {
  milkProduction('Milk Production', 'Maximize daily milk yield & fat content'),
  breeding('Breeding & Genetics', 'Produce high-pedigree indigenous calves'),
  meatProduction('Meat Production', 'Optimize weight gain & mutton/beef quality'),
  organicFarming('Organic Farming', 'Integrated zero-budget natural farming'),
  lowMaintenance('Low Maintenance', 'Minimal feed cost & high hardiness'),
  diseaseResistant('Disease Resistant Breed', 'Immunity against endemic diseases'),
  economicProfit('Economic Profitability', 'Maximize net annual farm ROI'),
  sustainableFarming('Sustainable Farming', 'Eco-friendly, climate-resilient farming');

  final String title;
  final String description;
  const ProductivityGoal(this.title, this.description);
}

/// Comprehensive Farmer Profile Entity
class FarmerProfileModel extends Equatable {
  final String id;
  final String userId;
  final String fullName;
  final String gender;
  final String dob;
  final String mobile;
  final String email;
  final String aadhaarNumber;
  final String profilePhotoPath;

  // Location Details
  final String state;
  final String district;
  final String taluk;
  final String village;
  final String pinCode;
  final String gpsLocation;

  // Farm Details
  final String farmName;
  final double farmSizeAcres;
  final int farmingExperienceYears;
  final String farmingType; // Rural, Semi-Urban, Urban
  final int numberOfWorkers;
  final String primaryLivestockType; // Cattle, Goat, Sheep, Mixed

  // Financial Info
  final double monthlyFarmingBudget;
  final double feedBudget;
  final double medicalBudget;
  final List<ProductivityGoal> productivityGoals;

  const FarmerProfileModel({
    required this.id,
    required this.userId,
    required this.fullName,
    this.gender = 'Male',
    this.dob = '1985-05-15',
    required this.mobile,
    required this.email,
    this.aadhaarNumber = '',
    this.profilePhotoPath = '',
    required this.state,
    required this.district,
    this.taluk = 'Pollachi',
    required this.village,
    this.pinCode = '641001',
    this.gpsLocation = '11.0168° N, 76.9558° E',
    required this.farmName,
    this.farmSizeAcres = 4.5,
    this.farmingExperienceYears = 12,
    this.farmingType = 'Traditional Rural',
    this.numberOfWorkers = 3,
    this.primaryLivestockType = 'Kangayam Cattle & Native Goats',
    this.monthlyFarmingBudget = 25000.0,
    this.feedBudget = 15000.0,
    this.medicalBudget = 5000.0,
    this.productivityGoals = const [
      ProductivityGoal.milkProduction,
      ProductivityGoal.diseaseResistant,
      ProductivityGoal.sustainableFarming,
    ],
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'full_name': fullName,
        'gender': gender,
        'dob': dob,
        'mobile': mobile,
        'email': email,
        'aadhaar_number': aadhaarNumber,
        'profile_photo_path': profilePhotoPath,
        'state': state,
        'district': district,
        'taluk': taluk,
        'village': village,
        'pin_code': pinCode,
        'gps_location': gpsLocation,
        'farm_name': farmName,
        'farm_size_acres': farmSizeAcres,
        'farming_experience_years': farmingExperienceYears,
        'farming_type': farmingType,
        'number_of_workers': numberOfWorkers,
        'primary_livestock_type': primaryLivestockType,
        'monthly_farming_budget': monthlyFarmingBudget,
        'feed_budget': feedBudget,
        'medical_budget': medicalBudget,
        'productivity_goals': productivityGoals.map((g) => g.name).toList(),
      };

  factory FarmerProfileModel.fromJson(Map<String, dynamic> json) => FarmerProfileModel(
        id: json['id'] ?? '',
        userId: json['user_id'] ?? '',
        fullName: json['full_name'] ?? 'Ramesh Kumar',
        gender: json['gender'] ?? 'Male',
        dob: json['dob'] ?? '1985-05-15',
        mobile: json['mobile'] ?? '+91 98765 43210',
        email: json['email'] ?? 'ramesh@pasumitra.org',
        aadhaarNumber: json['aadhaar_number'] ?? '',
        profilePhotoPath: json['profile_photo_path'] ?? '',
        state: json['state'] ?? 'Tamil Nadu',
        district: json['district'] ?? 'Coimbatore',
        taluk: json['taluk'] ?? 'Pollachi',
        village: json['village'] ?? 'Kottur',
        pinCode: json['pin_code'] ?? '641001',
        gpsLocation: json['gps_location'] ?? '11.0168° N, 76.9558° E',
        farmName: json['farm_name'] ?? 'Sri Amman Indigenous Cattle Farm',
        farmSizeAcres: (json['farm_size_acres'] as num?)?.toDouble() ?? 4.5,
        farmingExperienceYears: json['farming_experience_years'] ?? 12,
        farmingType: json['farming_type'] ?? 'Traditional Rural',
        numberOfWorkers: json['number_of_workers'] ?? 3,
        primaryLivestockType: json['primary_livestock_type'] ?? 'Kangayam Cattle & Native Goats',
        monthlyFarmingBudget: (json['monthly_farming_budget'] as num?)?.toDouble() ?? 25000.0,
        feedBudget: (json['feed_budget'] as num?)?.toDouble() ?? 15000.0,
        medicalBudget: (json['medical_budget'] as num?)?.toDouble() ?? 5000.0,
        productivityGoals: (json['productivity_goals'] as List?)
                ?.map((e) => ProductivityGoal.values.firstWhere(
                      (g) => g.name == e,
                      orElse: () => ProductivityGoal.milkProduction,
                    ))
                .toList() ??
            const [ProductivityGoal.milkProduction, ProductivityGoal.diseaseResistant],
      );

  FarmerProfileModel copyWith({
    String? id,
    String? userId,
    String? fullName,
    String? gender,
    String? dob,
    String? mobile,
    String? email,
    String? aadhaarNumber,
    String? profilePhotoPath,
    String? state,
    String? district,
    String? taluk,
    String? village,
    String? pinCode,
    String? gpsLocation,
    String? farmName,
    double? farmSizeAcres,
    int? farmingExperienceYears,
    String? farmingType,
    int? numberOfWorkers,
    String? primaryLivestockType,
    double? monthlyFarmingBudget,
    double? feedBudget,
    double? medicalBudget,
    List<ProductivityGoal>? productivityGoals,
  }) {
    return FarmerProfileModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      aadhaarNumber: aadhaarNumber ?? this.aadhaarNumber,
      profilePhotoPath: profilePhotoPath ?? this.profilePhotoPath,
      state: state ?? this.state,
      district: district ?? this.district,
      taluk: taluk ?? this.taluk,
      village: village ?? this.village,
      pinCode: pinCode ?? this.pinCode,
      gpsLocation: gpsLocation ?? this.gpsLocation,
      farmName: farmName ?? this.farmName,
      farmSizeAcres: farmSizeAcres ?? this.farmSizeAcres,
      farmingExperienceYears: farmingExperienceYears ?? this.farmingExperienceYears,
      farmingType: farmingType ?? this.farmingType,
      numberOfWorkers: numberOfWorkers ?? this.numberOfWorkers,
      primaryLivestockType: primaryLivestockType ?? this.primaryLivestockType,
      monthlyFarmingBudget: monthlyFarmingBudget ?? this.monthlyFarmingBudget,
      feedBudget: feedBudget ?? this.feedBudget,
      medicalBudget: medicalBudget ?? this.medicalBudget,
      productivityGoals: productivityGoals ?? this.productivityGoals,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        fullName,
        gender,
        dob,
        mobile,
        email,
        aadhaarNumber,
        profilePhotoPath,
        state,
        district,
        taluk,
        village,
        pinCode,
        gpsLocation,
        farmName,
        farmSizeAcres,
        farmingExperienceYears,
        farmingType,
        numberOfWorkers,
        primaryLivestockType,
        monthlyFarmingBudget,
        feedBudget,
        medicalBudget,
        productivityGoals,
      ];
}
