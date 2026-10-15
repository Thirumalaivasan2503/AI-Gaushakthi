import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_typography.dart';

/// Expense & Budget Tracker Card Widget
class ExpenseCardWidget extends StatelessWidget {
  final String title;
  final double currentExpense;
  final double maxBudget;
  final IconData icon;
  final Color accentColor;

  const ExpenseCardWidget({
    super.key,
    required this.title,
    required this.currentExpense,
    required this.maxBudget,
    required this.icon,
    this.accentColor = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (maxBudget > 0 ? (currentExpense / maxBudget) : 0.0).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: accentColor, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '₹${currentExpense.toStringAsFixed(0)}',
                style: AppTypography.titleLarge.copyWith(color: accentColor, fontWeight: FontWeight.bold),
              ),
              Text(
                'Budget: ₹${maxBudget.toStringAsFixed(0)}',
                style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.border,
            valueColor: AlwaysStoppedAnimation<Color>(
              progress > 0.9 ? AppColors.error : accentColor,
            ),
            minHeight: 6,
          ),
        ],
      ),
    );
  }
}
