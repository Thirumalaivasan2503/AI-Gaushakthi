import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_typography.dart';

/// Simple Country Code Selector Widget (+91 India default)
class CountryCodePickerWidget extends StatelessWidget {
  final String selectedCode;
  final ValueChanged<String> onChanged;

  const CountryCodePickerWidget({
    super.key,
    this.selectedCode = '+91',
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const codes = ['+91', '+1', '+44', '+61', '+81', '+971'];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1.5),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedCode,
          icon: const Icon(Icons.arrow_drop_down, color: AppColors.primary),
          style: AppTypography.titleMedium.copyWith(color: AppColors.primary),
          onChanged: (val) {
            if (val != null) onChanged(val);
          },
          items: codes.map((c) {
            return DropdownMenuItem<String>(
              value: c,
              child: Text(
                '$c 🇮🇳',
                style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
