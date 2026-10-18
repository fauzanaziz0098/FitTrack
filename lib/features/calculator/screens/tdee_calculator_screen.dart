import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/nutrition_calculator.dart';
import '../../auth/providers/auth_provider.dart';
import '../../main_navigation_screen.dart';

class TdeeCalculatorScreen extends ConsumerStatefulWidget {
  final bool isEditing;
  const TdeeCalculatorScreen({super.key, this.isEditing = false});

  @override
  ConsumerState<TdeeCalculatorScreen> createState() => _TdeeCalculatorScreenState();
}

class _TdeeCalculatorScreenState extends ConsumerState<TdeeCalculatorScreen> {
  Gender _gender = Gender.male;
  DateTime _birthDate = DateTime.now().subtract(const Duration(days: 365 * 25)); // Default ~25 yo
  double _heightCm = 175.0;
  double _weightKg = 72.0;
  double _activityLevel = 1.55; // Moderate
  FitnessGoal _goal = FitnessGoal.bulk; // Default bulking for lifters
  bool _isLoading = false;

  late final TextEditingController _heightController;
  late final TextEditingController _weightController;

  final Map<double, String> _activityLabels = {
    1.2: 'Sedentary (Jarang / Tidak Berolahraga)',
    1.375: 'Ringan (Latihan 1-3 hari/minggu)',
    1.55: 'Moderat (Latihan 3-5 hari/minggu)',
    1.725: 'Tinggi (Latihan keras 6-7 hari/minggu)',
    1.9: 'Ekstrem (Latihan berat 2x sehari / Atlet)',
  };

  @override
  void initState() {
    super.initState();
    _heightController = TextEditingController(text: _heightCm.toStringAsFixed(1));
    _weightController = TextEditingController(text: _weightKg.toStringAsFixed(1));
    _loadExistingProfile();
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _loadExistingProfile() async {
    final repo = ref.read(ironBiteRepositoryProvider);
    final profile = await repo.getCurrentProfile();
    if (profile != null && mounted) {
      setState(() {
        _gender = profile.gender == 'female' ? Gender.female : Gender.male;
        _birthDate = profile.birthDate;
        _heightCm = profile.heightCm;
        _weightKg = profile.currentWeightKg;
        _heightController.text = _heightCm.toStringAsFixed(1);
        _weightController.text = _weightKg.toStringAsFixed(1);
        _activityLevel = profile.activityLevel;
        if (profile.goal == 'cut') _goal = FitnessGoal.cut;
        if (profile.goal == 'maintain') _goal = FitnessGoal.maintain;
        if (profile.goal == 'bulk') _goal = FitnessGoal.bulk;
      });
    }
  }

  NutritionPlan get _currentPlan {
    return NutritionCalculator.calculateFullPlan(
      gender: _gender,
      weightKg: _weightKg,
      heightCm: _heightCm,
      birthDate: _birthDate,
      activityLevel: _activityLevel,
      goal: _goal,
    );
  }

  Future<void> _saveProfile() async {
    setState(() => _isLoading = true);
    try {
      final plan = _currentPlan;
      final repo = ref.read(ironBiteRepositoryProvider);

      await repo.saveProfile(
        gender: _gender == Gender.male ? 'male' : 'female',
        birthDate: _birthDate,
        heightCm: _heightCm,
        currentWeightKg: _weightKg,
        activityLevel: _activityLevel,
        goal: _goal.name,
        calorieTarget: plan.targetCalories,
        proteinTargetG: plan.targetProteinG,
        carbsTargetG: plan.targetCarbsG,
        fatTargetG: plan.targetFatG,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.primary,
            content: Text(
              'Profil & target nutrisi berhasil disimpan!',
              style: GoogleFonts.outfit(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        );

        if (widget.isEditing) {
          Navigator.pop(context);
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: AppColors.error, content: Text('Gagal menyimpan: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final plan = _currentPlan;
    final age = NutritionCalculator.calculateAge(_birthDate);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Ubah Target Nutrisi' : 'Kalkulator TDEE & Profil'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Intro Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.surface, AppColors.surfaceLight.withValues(alpha: 0.6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.surfaceBorder),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.fitness_center, color: AppColors.primary, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Formula Mifflin-St Jeor',
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Kalkulasi presisi energi BMR, TDEE, & rasio makronutrisi lifter.',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Gender Selector
            Text('Jenis Kelamin', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildChoiceCard(
                    icon: Icons.male,
                    label: 'Pria',
                    isSelected: _gender == Gender.male,
                    onTap: () => setState(() => _gender = Gender.male),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildChoiceCard(
                    icon: Icons.female,
                    label: 'Wanita',
                    isSelected: _gender == Gender.female,
                    onTap: () => setState(() => _gender = Gender.female),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Age & BirthDate
            Text('Usia & Tanggal Lahir', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _birthDate,
                  firstDate: DateTime(1940),
                  lastDate: DateTime.now(),
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
                  setState(() => _birthDate = picked);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.surfaceBorder),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${DateFormat('dd MMMM yyyy').format(_birthDate)} ($age Tahun)',
                      style: GoogleFonts.inter(fontSize: 14, color: AppColors.textPrimary),
                    ),
                    Icon(Icons.calendar_month, color: AppColors.primary, size: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Height and Weight Input Fields (Input Angka)
            Row(
              children: [
                Expanded(
                  child: _buildNumberInputField(
                    title: 'Tinggi Badan',
                    unit: 'cm',
                    controller: _heightController,
                    onChanged: (val) => setState(() => _heightCm = val),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildNumberInputField(
                    title: 'Berat Badan',
                    unit: 'kg',
                    controller: _weightController,
                    onChanged: (val) => setState(() => _weightKg = val),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Activity Level
            Text('Aktivitas Harian', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.surfaceBorder),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<double>(
                  value: _activityLevel,
                  isExpanded: true,
                  dropdownColor: AppColors.surfaceLight,
                  icon: Icon(Icons.keyboard_arrow_down, color: AppColors.primary),
                  items: _activityLabels.entries.map((e) {
                    return DropdownMenuItem<double>(
                      value: e.key,
                      child: Text(
                        e.value,
                        style: GoogleFonts.inter(fontSize: 13, color: AppColors.textPrimary),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _activityLevel = val);
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Fitness Goal (Cut / Maintain / Bulk)
            Text('Target Komposisi Tubuh', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildGoalCard(
                    title: 'Cutting',
                    subtitle: '-400 kkal',
                    goal: FitnessGoal.cut,
                    color: AppColors.accentOrange,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildGoalCard(
                    title: 'Maintain',
                    subtitle: '0 kkal',
                    goal: FitnessGoal.maintain,
                    color: AppColors.accentBlue,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildGoalCard(
                    title: 'Lean Bulk',
                    subtitle: '+350 kkal',
                    goal: FitnessGoal.bulk,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Live Calculation Result Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.surfaceLight,
                    AppColors.surface,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('BMR', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
                          Text(
                            '${plan.bmr.round()} kkal',
                            style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Container(width: 1, height: 30, color: AppColors.surfaceBorder),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('TDEE (Maint.)', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
                          Text(
                            '${plan.tdee.round()} kkal',
                            style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Container(width: 1, height: 30, color: AppColors.surfaceBorder),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Target Dashboard', style: GoogleFonts.inter(fontSize: 12, color: AppColors.primary)),
                          Text(
                            '${plan.targetCalories} kkal',
                            style: GoogleFonts.outfit(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Penjelasan relasi TDEE dan Target Harian
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.surfaceBorder),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, size: 16, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _goal == FitnessGoal.bulk
                                ? 'Surplus +350 kkal dari TDEE diterapkan untuk Lean Bulk agar massa otot bertambah. Angka ini yang menjadi target di Dashboard.'
                                : _goal == FitnessGoal.cut
                                    ? 'Defisit -400 kkal dari TDEE diterapkan untuk Cutting. Angka ini yang menjadi target di Dashboard.'
                                    : 'Target kalori di Dashboard sama dengan TDEE pemeliharaan.',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(color: AppColors.surfaceBorder, height: 24),
                  Text(
                    'Target Makronutrisi Presisi',
                    style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildMacroPill(
                          label: 'Protein',
                          grams: plan.targetProteinG,
                          color: AppColors.protein,
                          note: '2.0 g/kg',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildMacroPill(
                          label: 'Karbohidrat',
                          grams: plan.targetCarbsG,
                          color: AppColors.carbs,
                          note: 'Energi utama',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildMacroPill(
                          label: 'Lemak',
                          grams: plan.targetFatG,
                          color: AppColors.fat,
                          note: '22% total',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Save Button
            ElevatedButton(
              onPressed: _isLoading ? null : _saveProfile,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                    )
                  : Text(
                      widget.isEditing ? 'Simpan Perubahan' : 'Kunci Target & Mulai Latihan',
                      style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildChoiceCard({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.15) : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.surfaceBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? AppColors.primary : AppColors.textSecondary, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberInputField({
    required String title,
    required String unit,
    required TextEditingController controller,
    required ValueChanged<double> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              suffixText: unit,
              suffixStyle: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.surfaceBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.surfaceBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
            onChanged: (text) {
              final val = double.tryParse(text.replaceAll(',', '.'));
              if (val != null && val > 0) {
                onChanged(val);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGoalCard({
    required String title,
    required String subtitle,
    required FitnessGoal goal,
    required Color color,
  }) {
    final isSelected = _goal == goal;
    return InkWell(
      onTap: () => setState(() => _goal = goal),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.15) : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : AppColors.surfaceBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? color : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: isSelected ? color : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroPill({
    required String label,
    required double grams,
    required Color color,
    required String note,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(label, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          Text(
            '${grams.round()}g',
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            note,
            style: GoogleFonts.inter(fontSize: 9, color: AppColors.textMuted),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
