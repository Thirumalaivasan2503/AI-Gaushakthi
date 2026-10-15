import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/cards/login_card.dart';
import '../../../core/widgets/input/search_bar_widget.dart';

/// Searchable Government Schemes Hub Screen
class GovernmentSchemesScreen extends StatefulWidget {
  const GovernmentSchemesScreen({super.key});

  @override
  State<GovernmentSchemesScreen> createState() => _GovernmentSchemesScreenState();
}

class _GovernmentSchemesScreenState extends State<GovernmentSchemesScreen> {
  final List<Map<String, String>> _schemes = [
    {
      "id": "sch_01",
      "title": "Rashtriya Gokul Mission (RGM) Native Breed Subsidy",
      "level": "Central Government",
      "subsidy": "50% Capital Subsidy up to ₹50 Lakhs",
      "eligibility": "Farmers & FPOs establishing Kangayam, Gir, or Sahiwal multiplication units",
      "apply_url": "https://dahd.nic.in/schemes",
    },
    {
      "id": "sch_02",
      "title": "National Livestock Mission (NLM) Goat Breeding",
      "level": "Central Government",
      "subsidy": "50% Subsidy up to ₹10 Lakhs for 100+10 goat breeding farms",
      "eligibility": "Individual farmers rearing Malabari / Tellicherry or Jamnapari goats",
      "apply_url": "https://nlm.udyamimitra.in",
    },
    {
      "id": "sch_03",
      "title": "Tamil Nadu Native Breed Protection Incentive",
      "level": "State Government",
      "subsidy": "Free AI Straws & ₹2,000 heifer birth incentive",
      "eligibility": "Farmers keeping registered Kangayam / Bargur cattle",
      "apply_url": "https://tn.gov.in/animalhusbandry",
    },
  ];

  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = _schemes.where((s) {
      if (_query.isEmpty) return true;
      return s["title"]!.toLowerCase().contains(_query.toLowerCase()) ||
          s["eligibility"]!.toLowerCase().contains(_query.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Government Schemes Hub'),
      ),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.paddingMd,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchBarWidget(
                hintText: 'Search Rashtriya Gokul Mission, NLM, subsidies...',
                onChanged: (val) => setState(() => _query = val),
              ),
              const SizedBox(height: 16),

              Expanded(
                child: ListView.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final sch = filtered[index];
                    return LoginCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(sch["level"]!, style: AppTypography.labelSmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                              ),
                              const Icon(Icons.bookmark_border, color: AppColors.secondary),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(sch["title"]!, style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Text('Subsidy: ${sch["subsidy"]}', style: AppTypography.bodySmall.copyWith(color: AppColors.success, fontWeight: FontWeight.bold)),
                          Text('Eligibility: ${sch["eligibility"]}', style: AppTypography.bodySmall),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.warning.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.info_outline, size: 16, color: AppColors.warning),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Disclaimer: Verify official application criteria at government portal before applying.',
                                    style: AppTypography.labelSmall.copyWith(fontSize: 10),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
