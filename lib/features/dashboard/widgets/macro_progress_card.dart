import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/daily_summary.dart';
import '../../../data/models/user_profile.dart';

class MacroProgressCard extends StatelessWidget {
  final UserProfile? profile;
  final DailySummary summary;

  const MacroProgressCard({
    super.key,
    required this.profile,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    final targetCalories = profile?.calorieTarget ?? 2500;
    final targetProtein = profile?.proteinTargetG ?? 150.0;
    final targetCarbs = profile?.carbsTargetG ?? 270.0;
    final targetFat = profile?.fatTargetG ?? 65.0;

    final consumedCalories = summary.totalCalories.round();
    final remainingCalories = targetCalories - consumedCalories;
    final calProgress = (consumedCalories / targetCalories).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.surfaceBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top Row: Circular Calorie Meter + Remaining & Target info
          Row(
            children: [
              // Custom Circular Progress Ring
              SizedBox(
                width: 120,
                height: 120,
                child: CustomPaint(
                  painter: _CalorieRingPainter(
                    progress: calProgress,
                    trackColor: AppColors.surfaceBorder,
                    progressColor: remainingCalories >= 0 ? AppColors.primary : AppColors.error,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${consumedCalories.round()}',
                          style: GoogleFonts.outfit(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            height: 1.1,
                          ),
                        ),
                        Text(
                          'kkal masuk',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 24),
              // Target vs Remaining Metrics
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sisa Kuota Kalori',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          remainingCalories >= 0 ? '$remainingCalories' : '+${-remainingCalories}',
                          style: GoogleFonts.outfit(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: remainingCalories >= 0 ? AppColors.primary : AppColors.error,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          remainingCalories >= 0 ? 'kkal tersisa' : 'kkal surplus',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: remainingCalories >= 0 ? AppColors.primary : AppColors.error,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.flag_outlined, size: 14, color: profile != null ? AppColors.textMuted : AppColors.primary),
                          const SizedBox(width: 6),
                          Text(
                            profile != null
                                ? 'Batas Target: $targetCalories kkal'
                                : 'Target: Belum Diatur (Ketuk)',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: profile != null ? AppColors.textSecondary : AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),
          Divider(color: AppColors.surfaceBorder, height: 1),
          const SizedBox(height: 18),

          // Macro Breakdown Progress Bars
          _buildMacroProgressBar(
            title: 'Protein',
            consumed: summary.totalProtein,
            target: targetProtein,
            color: AppColors.protein,
          ),
          const SizedBox(height: 14),
          _buildMacroProgressBar(
            title: 'Karbohidrat',
            consumed: summary.totalCarbs,
            target: targetCarbs,
            color: AppColors.carbs,
          ),
          const SizedBox(height: 14),
          _buildMacroProgressBar(
            title: 'Lemak',
            consumed: summary.totalFat,
            target: targetFat,
            color: AppColors.fat,
          ),
        ],
      ),
    );
  }

  Widget _buildMacroProgressBar({
    required String title,
    required double consumed,
    required double target,
    required Color color,
  }) {
    final progress = target > 0 ? (consumed / target).clamp(0.0, 1.0) : 0.0;
    final percent = (progress * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            RichText(
              text: TextSpan(
                style: GoogleFonts.inter(fontSize: 12),
                children: [
                  TextSpan(
                    text: '${consumed.toStringAsFixed(1)}g',
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextSpan(
                    text: ' / ${target.round()}g ($percent%)',
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Stack(
          children: [
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            FractionallySizedBox(
              widthFactor: progress,
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color.withValues(alpha: 0.8),
                      color,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.4),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CalorieRingPainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final Color progressColor;

  _CalorieRingPainter({
    required this.progress,
    required this.trackColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 10.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background circle
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CalorieRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.progressColor != progressColor;
  }
}
