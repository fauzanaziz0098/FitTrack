import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppSplashScreen extends StatelessWidget {
  const AppSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.6),
                  width: 2.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 24,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/logo.jpeg',
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const Icon(
                    Icons.fitness_center,
                    size: 48,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'IRONBITE',
              style: GoogleFonts.outfit(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                letterSpacing: 3,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'PRECISION NUTRITION & PHYSIQUE',
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 36),
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
