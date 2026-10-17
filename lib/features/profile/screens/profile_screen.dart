import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/nutrition_calculator.dart';
import '../../../core/widgets/theme_selector_modal.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/screens/auth_screen.dart';
import '../../calculator/screens/tdee_calculator_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(currentProfileProvider);
    final supabase = ref.watch(supabaseServiceProvider);
    final currentUser = supabase.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Profil & Pengaturan', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // User & Target Header Card
            profileAsync.when(
              data: (profile) {
                if (profile == null) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.surfaceBorder),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.account_circle, size: 56, color: AppColors.textMuted),
                        const SizedBox(height: 12),
                        Text(
                          'Profil Lifter Belum Diatur',
                          style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Hitung target kalori dan makronutrisi harian Anda.',
                          style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.calculate, color: Colors.black),
                          label: const Text('Buka Kalkulator TDEE'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const TdeeCalculatorScreen()),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }

                final age = NutritionCalculator.calculateAge(profile.birthDate);
                final goalLabel = profile.goal == 'cut'
                    ? 'Cutting (-400 kkal)'
                    : profile.goal == 'bulk'
                        ? 'Lean Bulking (+350 kkal)'
                        : 'Maintenance';

                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.surfaceBorder),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.fitness_center, color: AppColors.primary, size: 28),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentUser?.email ?? 'Iron Lifter (Mode Offline)',
                                  style: GoogleFonts.outfit(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.surfaceLight,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        goalLabel,
                                        style: GoogleFonts.inter(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Divider(color: AppColors.surfaceBorder, height: 1),
                      const SizedBox(height: 16),

                      // Metrics Grid
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildProfileStat('Berat', '${profile.currentWeightKg.toStringAsFixed(1)} kg'),
                          _buildProfileStat('Tinggi', '${profile.heightCm.round()} cm'),
                          _buildProfileStat('Usia', '$age thn'),
                          _buildProfileStat('Kelamin', profile.gender == 'male' ? 'Pria' : 'Wanita'),
                        ],
                      ),

                      const SizedBox(height: 16),
                      const Divider(color: AppColors.surfaceBorder, height: 1),
                      const SizedBox(height: 16),

                      // Target Macros
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildMacroStat('Target Kalori', '${profile.calorieTarget} kkal', AppColors.primary),
                          _buildMacroStat('Protein', '${profile.proteinTargetG.round()}g', AppColors.protein),
                          _buildMacroStat('Karbo', '${profile.carbsTargetG.round()}g', AppColors.carbs),
                          _buildMacroStat('Lemak', '${profile.fatTargetG.round()}g', AppColors.fat),
                        ],
                      ),
                      const SizedBox(height: 18),

                      OutlinedButton.icon(
                        icon: const Icon(Icons.edit, size: 16),
                        label: const Text('Ubah Target Nutrisi / Hitung Ulang'),
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
                );
              },
              loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
              error: (err, _) => Text('Error: $err'),
            ),
            const SizedBox(height: 20),

            // Tampilan & Tema
            Text(
              'Tampilan & Tema',
              style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.surfaceBorder),
              ),
              child: const ThemeSelectorSection(showHeader: true),
            ),
            const SizedBox(height: 20),

            // Akun & Autentikasi Supabase
            Text(
              'Akun & Autentikasi',
              style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.surfaceBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: currentUser != null
                              ? AppColors.success.withValues(alpha: 0.15)
                              : AppColors.surfaceLight,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          currentUser != null ? Icons.verified_user : Icons.person_outline,
                          color: currentUser != null ? AppColors.success : AppColors.textMuted,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentUser != null ? (currentUser.email ?? 'Akun Terhubung') : 'Mode Tamu / Offline',
                              style: GoogleFonts.outfit(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              currentUser != null
                                  ? 'Sesi Supabase Auth Aktif'
                                  : 'Masuk akun untuk menghubungkan profil ke cloud Supabase',
                              style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  if (currentUser != null) ...[
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error),
                        minimumSize: const Size.fromHeight(46),
                      ),
                      icon: const Icon(Icons.logout, size: 18, color: AppColors.error),
                      label: const Text('Keluar dari Akun (Logout)'),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            backgroundColor: AppColors.surface,
                            title: Text('Konfirmasi Logout', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                            content: const Text('Anda yakin ingin keluar dari sesi akun Supabase?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: const Text('Batal'),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                                onPressed: () => Navigator.pop(ctx, true),
                                child: const Text('Keluar', style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          await supabase.signOut();
                          if (context.mounted) {
                            setState(() {});
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: AppColors.surfaceLight,
                                content: Text('Anda telah keluar dari akun.'),
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ] else ...[
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(46),
                      ),
                      icon: const Icon(Icons.login, size: 18),
                      label: const Text('Masuk / Daftar Akun'),
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AuthScreen()),
                        );
                        if (mounted) setState(() {});
                      },
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),

            // About IronBite & Version
            Center(
              child: Column(
                children: [
                  Text(
                    'IronBite v1.0.0 (MVP)',
                    style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Offline-First Nutrition & Lifter Body Composition Tracker',
                    style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileStat(String label, String value) {
    return Column(
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted)),
        const SizedBox(height: 2),
        Text(value, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildMacroStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary)),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }
}
