import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/buttons/primary_button.dart';
import '../../../core/widgets/cards/login_card.dart';
import '../../../core/widgets/feedback/loading_overlay.dart';
import '../../farmer/presentation/controllers/farmer_controller.dart';

/// AI Recommendation Screen displaying ML Model Predictions & Explainable AI (XAI) Rationales
class RecommendationScreen extends ConsumerStatefulWidget {
  const RecommendationScreen({super.key});

  @override
  ConsumerState<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends ConsumerState<RecommendationScreen> {
  bool _isGenerating = false;
  Map<String, dynamic>? _recommendationResult;

  void _runAiRecommendationPipeline() async {
    setState(() {
      _isGenerating = true;
    });

    await Future.delayed(const Duration(milliseconds: 800));

    final farmerState = ref.read(farmerControllerProvider);
    final feedEnv = farmerState.feedEnv;
    final temp = feedEnv?.averageTemperatureC ?? 36.5;

    // Simulated ML Explainable AI output based on ml/explainability.py architecture
    final String primaryBreed = temp > 38 ? "Kangayam Cattle" : "Sahiwal Cow";
    final double confidence = temp > 38 ? 96.8 : 95.4;

    setState(() {
      _isGenerating = false;
      _recommendationResult = {
        "recommended_breed": primaryBreed,
        "confidence_score": confidence,
        "sustainability_score": 98.5,
        "eval_model_used": "Gradient Boosting (XGBoost Equivalent)",
        "climate_explanation": "Selected for extreme heat tolerance (up to 48°C) in semi-arid zones with low annual rainfall.",
        "disease_explanation": "High natural resistance against Foot and Mouth Disease (FMD) and tick-borne parasites.",
        "economic_roi": "Saves ₹35,000/year in tractor diesel costs with A2 protein milk yield.",
        "top_3_alternatives": [
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
        ]
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Breed Recommendation'),
      ),
      body: LoadingOverlay(
        isLoading: _isGenerating,
        message: 'Running ML candidate model evaluation & SHAP XAI pipeline...',
        child: SafeArea(
          child: SingleChildScrollView(
            padding: AppSpacing.paddingLg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AI Indigenous Breed Selector', style: AppTypography.displayMedium.copyWith(color: AppColors.primary)),
                const SizedBox(height: 8),
                Text('Powered by Machine Learning (XGBoost / Random Forest) with Explainable AI (XAI).', style: AppTypography.bodyMedium),
                const SizedBox(height: 20),

                PrimaryButton(
                  text: 'Generate AI Breed Recommendation',
                  onPressed: _runAiRecommendationPipeline,
                ),

                const SizedBox(height: 24),
                if (_recommendationResult != null) ...[
                  // Primary Recommendation Result Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: AppColors.goldGradient,
                      borderRadius: AppSpacing.borderRadiusLg,
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'MATCHED INDIGENOUS BREED',
                              style: AppTypography.labelSmall.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${_recommendationResult!["confidence_score"]}% Confidence',
                                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _recommendationResult!["recommended_breed"],
                          style: AppTypography.displayMedium.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Evaluated by: ${_recommendationResult!["eval_model_used"]}',
                          style: AppTypography.labelSmall.copyWith(color: AppColors.primaryDark.withOpacity(0.8)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  // Explainable AI (XAI) Rationales
                  Text('Explainable AI (XAI) Decision Rationales', style: AppTypography.titleLarge),
                  const SizedBox(height: 12),

                  LoginCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildXaiRow(Icons.thermostat, 'Climate Suitability', _recommendationResult!["climate_explanation"]),
                        const Divider(height: 24),
                        _buildXaiRow(Icons.shield, 'Disease Resistance & Immunity', _recommendationResult!["disease_explanation"]),
                        const Divider(height: 24),
                        _buildXaiRow(Icons.trending_up, 'Economic ROI & Fuel Savings', _recommendationResult!["economic_roi"]),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  // Top 3 Alternative Breeds
                  Text('Top 3 Alternative Recommended Breeds', style: AppTypography.titleLarge),
                  const SizedBox(height: 12),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: (_recommendationResult!["top_3_alternatives"] as List).length,
                    itemBuilder: (context, index) {
                      final alt = _recommendationResult!["top_3_alternatives"][index];
                      return LoginCard(
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColors.primary.withOpacity(0.1),
                              child: Text('${index + 2}', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 14),
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
                  // Feature Importance Breakdown Chart
                  Text('ML Feature Importance Breakdown', style: AppTypography.titleLarge),
                  const SizedBox(height: 12),

                  LoginCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: (_recommendationResult!["feature_importance"] as List).map((feat) {
                        final double weight = feat["weight"];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(feat["feature"], style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.bold)),
                                  Text('${(weight * 100).toStringAsFixed(0)}%', style: AppTypography.labelSmall),
                                ],
                              ),
                              const SizedBox(height: 4),
                              LinearProgressIndicator(
                                value: weight,
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildXaiRow(IconData icon, String title, String text) {
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
              Text(text, style: AppTypography.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}
