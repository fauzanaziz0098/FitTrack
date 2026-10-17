import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/local/app_database.dart';
import '../../auth/providers/auth_provider.dart';
import '../../food_logging/screens/food_search_screen.dart';

class MealSectionCard extends ConsumerWidget {
  final String mealType; // 'breakfast', 'lunch', 'dinner', 'snack'
  final String title;
  final IconData icon;
  final List<LocalMealLog> mealLogs;

  const MealSectionCard({
    super.key,
    required this.mealType,
    required this.title,
    required this.icon,
    required this.mealLogs,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredLogs = mealLogs.where((log) => log.mealType == mealType).toList();
    final totalCalories = filteredLogs.fold<double>(0, (sum, item) => sum + item.totalCalories);
    final totalProtein = filteredLogs.fold<double>(0, (sum, item) => sum + item.totalProteinG);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Column(
        children: [
          // Header Row
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (filteredLogs.isNotEmpty)
                        Text(
                          '${filteredLogs.length} makanan • ${totalProtein.round()}g protein',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${totalCalories.round()} kkal',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: totalCalories > 0 ? AppColors.textPrimary : AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Logged Food Items List
          if (filteredLogs.isNotEmpty) ...[
            Divider(color: AppColors.surfaceBorder, height: 1),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: filteredLogs.length,
              separatorBuilder: (_, _) => Divider(color: AppColors.surfaceBorder, height: 1),
              itemBuilder: (context, index) {
                final item = filteredLogs[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.foodName,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Porsi: ${item.servingQuantity}x • P: ${item.totalProteinG.round()}g  C: ${item.totalCarbsG.round()}g  F: ${item.totalFatG.round()}g',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${item.totalCalories.round()} kkal',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, size: 18, color: AppColors.textMuted),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              backgroundColor: AppColors.surfaceLight,
                              title: Text('Hapus Makanan?', style: GoogleFonts.outfit()),
                              content: Text('Hapus ${item.foodName} dari catatan waktu makan ini?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: const Text('Batal'),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                                  onPressed: () => Navigator.pop(ctx, true),
                                  child: const Text('Hapus', style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            await ref.read(ironBiteRepositoryProvider).deleteMealLog(item.id);
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],

          // Add Food Button
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FoodSearchScreen(mealType: mealType),
                ),
              );
            },
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(18)),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight.withValues(alpha: 0.5),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(18)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, size: 16, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Text(
                    'Tambah Makanan',
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
