import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/cards/glass_card.dart';
import '../../../core/widgets/cards/login_card.dart';
import '../../../core/widgets/feedback/loading_overlay.dart';
import '../../../core/widgets/input/search_bar_widget.dart';

import 'controllers/knowledge_controller.dart';

/// Digital Encyclopedia & Indigenous Knowledge Hub Screen
class KnowledgeHubScreen extends ConsumerWidget {
  const KnowledgeHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final knowledgeState = ref.watch(knowledgeControllerProvider);
    final articles = knowledgeState.articles;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Indigenous Knowledge Hub'),
      ),
      body: LoadingOverlay(
        isLoading: knowledgeState.isLoading,
        message: 'Loading encyclopedia resources...',
        child: SafeArea(
          child: SingleChildScrollView(
            padding: AppSpacing.paddingMd,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SearchBarWidget(
                  hintText: 'Search Kangayam, Gir, Sahiwal, FMD, ethno-vet tips...',
                  onChanged: (val) {
                    ref.read(knowledgeControllerProvider.notifier).search(val);
                  },
                ),
                const SizedBox(height: 20),

                Text('Knowledge Portals', style: AppTypography.titleLarge),
                const SizedBox(height: 12),

                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.1,
                  children: [
                    _buildCategoryCard(
                      context,
                      title: 'Breed Encyclopedia',
                      subtitle: 'Kangayam, Gir, Sahiwal, Ongole',
                      icon: Icons.pets,
                      color: AppColors.primary,
                      onTap: () => context.push('/knowledge/breeds'),
                    ),
                    _buildCategoryCard(
                      context,
                      title: 'Side-by-Side Comparison',
                      subtitle: 'Milk, Climate, ROI Matrix',
                      icon: Icons.compare_arrows,
                      color: AppColors.secondaryDark,
                      onTap: () => context.push('/knowledge/compare'),
                    ),
                    _buildCategoryCard(
                      context,
                      title: 'Govt Schemes & Subsidies',
                      subtitle: 'Rashtriya Gokul Mission',
                      icon: Icons.account_balance,
                      color: AppColors.warning,
                      onTap: () {},
                    ),
                    _buildCategoryCard(
                      context,
                      title: 'Ethno-Veterinary Care',
                      subtitle: 'Traditional Remedies',
                      icon: Icons.spa,
                      color: AppColors.success,
                      onTap: () {},
                    ),
                  ],
                ),

                const SizedBox(height: 24),
                // Educational Video Placeholder
                LoginCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.play_circle_fill, color: AppColors.error, size: 28),
                          const SizedBox(width: 8),
                          Text('Featured Masterclass Video', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 140,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(12),
                          image: const DecorationImage(
                            image: NetworkImage('https://storage.googleapis.com/pasumitra-ai-bucket/thumbnails/kangayam_masterclass.jpg'),
                            fit: BoxFit.cover,
                            opacity: 0.6,
                          ),
                        ),
                        child: const Center(
                          child: CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.play_arrow, color: AppColors.primary, size: 36),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Kangayam Bull Selection & Native Pasture Management', style: AppTypography.titleSmall),
                      Text('By Dr. Ananya Sharma • 12 min HD Video', style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted)),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                // Popular Articles
                Text('Popular Articles & Advisory Guides', style: AppTypography.titleLarge),
                const SizedBox(height: 12),

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    final art = articles[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: AppColors.goldGlow,
                          child: Icon(Icons.article_outlined, color: AppColors.primaryDark),
                        ),
                        title: Text(art.title, style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.bold)),
                        subtitle: Text('${art.category} • ${art.readTime}', style: AppTypography.labelSmall),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Opening article: ${art.title}')),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: GlassCard(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 34, color: color),
            const SizedBox(height: 10),
            Text(title, style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text(subtitle, style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
