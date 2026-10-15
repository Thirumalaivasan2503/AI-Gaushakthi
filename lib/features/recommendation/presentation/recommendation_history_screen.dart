import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/cards/login_card.dart';

/// Historical AI Recommendation History Screen
class RecommendationHistoryScreen extends ConsumerWidget {
  const RecommendationHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = [
      {
        "id": "rec_001",
        "recommended_breed": "Kangayam Cattle",
        "confidence_score": 96.8,
        "timestamp": "2024-08-01 10:30:00",
        "productivity_goal": "Draft & Tillage",
        "status": "Verified",
      },
      {
        "id": "rec_002",
        "recommended_breed": "Sahiwal Cow",
        "confidence_score": 95.4,
        "timestamp": "2024-07-28 14:15:00",
        "productivity_goal": "Milk Production",
        "status": "Verified",
      },
      {
        "id": "rec_003",
        "recommended_breed": "Tellicherry / Malabari Goat",
        "confidence_score": 97.1,
        "timestamp": "2024-07-15 09:00:00",
        "productivity_goal": "Meat Production",
        "status": "Verified",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommendation History'),
      ),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.paddingLg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Past AI Breed Predictions', style: AppTypography.displayMedium.copyWith(color: AppColors.primary)),
              const SizedBox(height: 6),
              Text('View all previous breed recommendations generated for your farm profile.', style: AppTypography.bodyMedium),
              const SizedBox(height: 20),

              Expanded(
                child: ListView.separated(
                  itemCount: history.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = history[index];
                    return LoginCard(
                      child: InkWell(
                        onTap: () => context.push('/prediction-details'),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              backgroundColor: AppColors.goldGlow,
                              child: Icon(Icons.psychology, color: AppColors.primaryDark),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item["recommended_breed"] as String,
                                    style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Goal: ${item["productivity_goal"]} • ${item["timestamp"]}',
                                    style: AppTypography.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${item["confidence_score"]}%',
                                style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
