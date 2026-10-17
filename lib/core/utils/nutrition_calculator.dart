enum Gender { male, female }
enum FitnessGoal { cut, maintain, bulk }

class NutritionPlan {
  final double bmr;
  final double tdee;
  final int targetCalories;
  final double targetProteinG;
  final double targetCarbsG;
  final double targetFatG;

  NutritionPlan({
    required this.bmr,
    required this.tdee,
    required this.targetCalories,
    required this.targetProteinG,
    required this.targetCarbsG,
    required this.targetFatG,
  });
}

class NutritionCalculator {
  /// Calculate age from birthDate
  static int calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age < 0 ? 0 : age;
  }

  /// Perhitungan BMR dengan rumus Mifflin-St Jeor
  /// Pria: BMR = (10 x BB_kg) + (6.25 x TB_cm) - (5 x Umur) + 5
  /// Wanita: BMR = (10 x BB_kg) + (6.25 x TB_cm) - (5 x Umur) - 161
  static double calculateBmr({
    required Gender gender,
    required double weightKg,
    required double heightCm,
    required int age,
  }) {
    if (gender == Gender.male) {
      return (10 * weightKg) + (6.25 * heightCm) - (5 * age) + 5;
    } else {
      return (10 * weightKg) + (6.25 * heightCm) - (5 * age) - 161;
    }
  }

  /// Perhitungan TDEE = BMR * activityLevel
  static double calculateTdee(double bmr, double activityLevel) {
    return bmr * activityLevel;
  }

  /// Menghitung target kalori dan makronutrisi lengkap sesuai PRD
  static NutritionPlan calculateFullPlan({
    required Gender gender,
    required double weightKg,
    required double heightCm,
    required DateTime birthDate,
    required double activityLevel,
    required FitnessGoal goal,
    double proteinMultiplier = 2.0, // 1.6 - 2.2 g per kg berat badan
    double fatPercentage = 0.22, // 20 - 25% total kalori
  }) {
    final age = calculateAge(birthDate);
    final bmr = calculateBmr(
      gender: gender,
      weightKg: weightKg,
      heightCm: heightCm,
      age: age,
    );

    final tdee = calculateTdee(bmr, activityLevel);

    // Goal adjustment
    // Cutting: Defisit 300 - 500 kkal (default 400)
    // Maintenance: 0 kkal
    // Lean Bulking: Surplus 300 - 500 kkal (default 350)
    int calorieAdjustment = 0;
    switch (goal) {
      case FitnessGoal.cut:
        calorieAdjustment = -400;
        break;
      case FitnessGoal.maintain:
        calorieAdjustment = 0;
        break;
      case FitnessGoal.bulk:
        calorieAdjustment = 350;
        break;
    }

    final targetCalories = (tdee + calorieAdjustment).round().clamp(1000, 7000);

    // Macro Split
    // 1. Protein: proteinMultiplier (1.6 - 2.2) * weightKg
    final targetProteinG = (weightKg * proteinMultiplier);
    final proteinCalories = targetProteinG * 4;

    // 2. Lemak: 20-25% total kalori
    final fatCalories = targetCalories * fatPercentage;
    final targetFatG = fatCalories / 9;

    // 3. Karbohidrat: sisa kalori / 4
    final remainingCaloriesForCarbs = targetCalories - (proteinCalories + fatCalories);
    final targetCarbsG = (remainingCaloriesForCarbs / 4).clamp(0.0, 1000.0);

    return NutritionPlan(
      bmr: bmr,
      tdee: tdee,
      targetCalories: targetCalories,
      targetProteinG: double.parse(targetProteinG.toStringAsFixed(1)),
      targetCarbsG: double.parse(targetCarbsG.toStringAsFixed(1)),
      targetFatG: double.parse(targetFatG.toStringAsFixed(1)),
    );
  }
}
