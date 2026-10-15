import 'package:flutter/material.dart';
import '../../../features/farmer/domain/models/medical_vaccination_model.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_typography.dart';

/// Interactive Vaccination Timeline Widget
class VaccinationTimelineWidget extends StatelessWidget {
  final List<VaccinationRecordModel> records;
  final VoidCallback? onAddVaccinationTap;

  const VaccinationTimelineWidget({
    super.key,
    required this.records,
    this.onAddVaccinationTap,
  });

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            const Icon(Icons.vaccines_outlined, size: 36, color: AppColors.textMuted),
            const SizedBox(height: 8),
            Text('No vaccination records logged yet', style: AppTypography.bodySmall),
          ],
        ),
      );
    }

    return Column(
      children: records.map((record) {
        final isCompleted = record.isCompleted;
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeline line and indicator
              Column(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: isCompleted ? AppColors.success : AppColors.warning,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isCompleted ? Icons.check : Icons.access_time,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  Container(
                    width: 2,
                    height: 40,
                    color: AppColors.border,
                  ),
                ],
              ),
              const SizedBox(width: 14),

              // Info Box
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isCompleted ? AppColors.border : AppColors.warning,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            record.vaccineName,
                            style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: isCompleted
                                  ? AppColors.success.withOpacity(0.12)
                                  : AppColors.warning.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              isCompleted ? 'Completed' : 'Upcoming Due',
                              style: AppTypography.labelSmall.copyWith(
                                color: isCompleted ? AppColors.success : AppColors.warning,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text('Administered Date: ${record.vaccinationDate}', style: AppTypography.bodySmall),
                      Text(
                        'Next Booster Due: ${record.nextDueDate}',
                        style: AppTypography.bodySmall.copyWith(
                          color: isCompleted ? AppColors.primary : AppColors.error,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text('Administered by: ${record.vaccinatedBy}', style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
