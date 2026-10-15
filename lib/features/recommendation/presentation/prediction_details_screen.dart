import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/cards/login_card.dart';

/// Detailed Prediction Breakdown Screen (Explainable AI outputs & Feature Weights)
class PredictionDetailsScreen extends ConsumerWidget {
  const PredictionDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Map<String, dynamic> result = {
      "recommended_breed": "Kangayam Cattle",
      "confidence_score": 96.8,
      "disease_resistance_score": 98.5,
      "climate_score": 99.0,
      "profitability_score": 94.0,
      "sustainability_score": 98.5,
      "climate_explanation": "Extreme heat resilience up to 48°C. Ideal for semi-arid Tamil Nadu drylands.",
      "disease_explanation": "Natural FMD & Tick Fever immunity with zero genetic susceptibility.",
      "feed_maint": "Low feed requirement (stover & wild pasture). Maintenance cost: ₹120/day.",
      "profit_desc": "Fuel saving of ₹35,000/yr in diesel draft plus rich A2 protein milk revenue.",
      "alternatives": [
        {"breed_name": "Gir Cow", "confidence": 92.4, "note": "High A2 milk yield under warm climate"},
        {"breed_name": "Bargur Cattle", "confidence": 89.1, "note": "Low feed cost in stony hills"},
        {"breed_name": "Ongole Cattle", "confidence": 86.5, "note": "Heavy muscular draft power"},
      ],
      "feature_importance": [
        {"feature": "Agro-Climate Heat Index (THI)", "weight": 0.28},
        {"feature": "Monthly Feed Budget", "weight": 0.22},
        {"feature": "Productivity Goal Alignment", "weight": 0.19},
        {"feature": "Annual Rainfall Vector", "weight": 0.16},
        {"feature": "Disease History Count", "weight": 0.15},
      ],
      "timestamp": "2024-08-01 12:00:00",
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Prediction Details & XAI Rationale'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingLg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppColors.goldGradient,
                  borderRadius: AppSpacing.borderRadiusLg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('TOP MATCHED BREED', style: AppTypography.labelSmall.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.bold)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text('${result["confidence_score"]}% Match', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(result["recommended_breed"], style: AppTypography.displayMedium.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('Model: Gradient Boosting (XGBoost Equivalent) • Tested via 5-Fold CV', style: AppTypography.labelSmall.copyWith(color: AppColors.primaryDark)),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              // Explainable AI Rationales
              Text('Explainable AI (XAI) Agronomic Insights', style: AppTypography.titleLarge),
              const SizedBox(height: 12),

              LoginCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInsightRow(Icons.thermostat, 'Climate Adaptability', result["climate_explanation"]),
                    const Divider(height: 24),
                    _buildInsightRow(Icons.shield, 'Disease Immunity', result["disease_explanation"]),
                    const Divider(height: 24),
                    _buildInsightRow(Icons.grass, 'Feed & Maintenance', result["feed_maint"]),
                    const Divider(height: 24),
                    _buildInsightRow(Icons.trending_up, 'Profit Projection', result["profit_desc"]),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              // Top 3 Alternative Breeds
              Text('Top 3 Alternative Breeds', style: AppTypography.titleLarge),
              const SizedBox(height: 12),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: (result["alternatives"] as List).length,
                itemBuilder: (context, index) {
                  final alt = result["alternatives"][index];
                  return LoginCard(
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.primary.withOpacity(0.12),
                          child: Text('#${index + 2}', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(alt["breed_name"], style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.bold)),
                              Text(alt["note"], style: AppTypography.bodySmall),
                            ],
                          ),
                        ),
                        Text('${alt["confidence"]}%', style: AppTypography.titleSmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),
              // Feature Importance Breakdown
              Text('Feature Weight Contribution (SHAP Ranking)', style: AppTypography.titleLarge),
              const SizedBox(height: 12),

              LoginCard(
                child: Column(
                  children: (result["feature_importance"] as List).map((f) {
                    final double w = f["weight"];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(f["feature"], style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.bold)),
                              Text('${(w * 100).toStringAsFixed(0)}%', style: AppTypography.labelSmall),
                            ],
                          ),
                          const SizedBox(height: 4),
                          LinearProgressIndicator(
                            value: w,
                            backgroundColor: AppColors.border,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondary),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInsightRow(IconData icon, String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(desc, style: AppTypography.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}
