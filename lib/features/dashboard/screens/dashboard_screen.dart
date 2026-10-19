import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/widgets/empty_offline_state.dart';
import '../../../core/widgets/theme_selector_modal.dart';
import '../../auth/providers/auth_provider.dart';
import '../../calculator/screens/tdee_calculator_screen.dart';
import '../widgets/macro_progress_card.dart';
import '../widgets/meal_section_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(themeNotifierProvider);
    final profileAsync = ref.watch(currentProfileProvider);
    final selectedDate = ref.watch(selectedDateProvider);
    final summaryAsync = ref.watch(dailySummaryProvider);
    final mealLogsAsync = ref.watch(mealLogsProvider);

    final isToday = DateUtils.isSameDay(selectedDate, DateTime.now());
    String dateDisplay;
    try {
      dateDisplay = isToday
          ? 'Hari Ini, ${DateFormat('d MMM', 'id_ID').format(selectedDate)}'
          : DateFormat('EEEE, d MMM', 'id_ID').format(selectedDate);
    } catch (_) {
      dateDisplay = isToday
          ? 'Hari Ini, ${DateFormat('d MMM').format(selectedDate)}'
          : DateFormat('EEEE, d MMM').format(selectedDate);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.bolt, color: Colors.black, size: 20),
            ),
            const SizedBox(width: 10),
            Text(
              'IronBite',
              style: GoogleFonts.outfit(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        actions: [
          // Theme Quick Switcher
          IconButton(
            tooltip: 'Ganti Tema',
            icon: const Icon(Icons.palette_outlined),
            onPressed: () => showThemeSelectorModal(context),
          ),
          // Profile Target Quick Link
          IconButton(
            tooltip: 'Kalkulator TDEE',
            icon: const Icon(Icons.tune),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TdeeCalculatorScreen(isEditing: true),
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.surface,
        onRefresh: () async {
          ref.invalidate(currentProfileProvider);
          ref.invalidate(dailySummaryProvider);
          ref.invalidate(mealLogsProvider);
          try {
            await Future.wait([
              ref.read(dailySummaryProvider.future),
              ref.read(mealLogsProvider.future),
              ref.read(currentProfileProvider.future),
            ]);
          } catch (_) {}
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Date Switcher Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.surfaceBorder),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.chevron_left, color: AppColors.textSecondary),
                      onPressed: () {
                        ref.read(selectedDateProvider.notifier).prevDay();
                      },
                    ),
                    InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.dark(
                                  primary: AppColors.primary,
                                  onPrimary: Colors.black,
                                  surface: AppColors.surface,
                                  onSurface: AppColors.textPrimary,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          ref.read(selectedDateProvider.notifier).setDate(picked);
                        }
                      },
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, size: 16, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Text(
                            dateDisplay,
                            style: GoogleFonts.outfit(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.chevron_right, color: AppColors.textSecondary),
                      onPressed: () {
                        ref.read(selectedDateProvider.notifier).nextDay();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Profile Notice if not set up yet
              profileAsync.when(
                data: (profile) {
                  if (profile == null) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: AppColors.primary),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Target Kalori Belum Diatur',
                                  style: GoogleFonts.outfit(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Hitung TDEE dan sesuaikan target kalori sesuai tujuan.',
                                  style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const TdeeCalculatorScreen(),
                                ),
                              );
                            },
                            child: const Text('Hitung', style: TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
              ),

              // Daily Calorie & Macro Dashboard Card
              summaryAsync.when(
                data: (summary) {
                  final profile = profileAsync.value;
                  return MacroProgressCard(profile: profile, summary: summary);
                },
                loading: () => SizedBox(
                  height: 240,
                  child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
                ),
                error: (_, _) => Container(
                  padding: const EdgeInsets.all(16),
                  child: Text('Gagal memuat ringkasan harian.', style: TextStyle(color: AppColors.error)),
                ),
              ),

              const SizedBox(height: 24),

              // Meal Logs Section Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Jadwal Makan Harian',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '4 Waktu Makan',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 4 Meal Sections
              mealLogsAsync.when(
                data: (logs) {
                  return Column(
                    children: [
                      MealSectionCard(
                        mealType: 'breakfast',
                        title: 'Sarapan (Breakfast)',
                        icon: Icons.wb_sunny_outlined,
                        mealLogs: logs,
                      ),
                      MealSectionCard(
                        mealType: 'lunch',
                        title: 'Makan Siang (Lunch)',
                        icon: Icons.wb_twilight,
                        mealLogs: logs,
                      ),
                      MealSectionCard(
                        mealType: 'dinner',
                        title: 'Makan Malam (Dinner)',
                        icon: Icons.nightlight_round,
                        mealLogs: logs,
                      ),
                      MealSectionCard(
                        mealType: 'snack',
                        title: 'Camilan & Suplemen (Snacks)',
                        icon: Icons.coffee_outlined,
                        mealLogs: logs,
                      ),
                    ],
                  );
                },
                loading: () => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                ),
                error: (_, _) => EmptyOfflineState(
                  title: 'Data Tidak Tersedia (Offline)',
                  message: 'Tidak dapat memuat jadwal makan dari cloud. Periksa koneksi internet Anda.',
                  onRetry: () {
                    ref.invalidate(mealLogsProvider);
                    ref.invalidate(dailySummaryProvider);
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
