import 'package:flutter_test/flutter_test.dart';
import 'package:ironbite/core/utils/nutrition_calculator.dart';

void main() {
  group('NutritionCalculator Tests (Mifflin-St Jeor & PRD Formulas)', () {
    test('Calculates age correctly from birth date', () {
      final birthDate = DateTime(2000, 1, 1);
      final age = NutritionCalculator.calculateAge(birthDate);
      expect(age, greaterThanOrEqualTo(24));
    });

    test('Calculates Male BMR correctly', () {
      // Pria 75kg, 175cm, 25 thn
      // BMR = (10*75) + (6.25*175) - (5*25) + 5 = 750 + 1093.75 - 125 + 5 = 1723.75
      final bmr = NutritionCalculator.calculateBmr(
        gender: Gender.male,
        weightKg: 75.0,
        heightCm: 175.0,
        age: 25,
      );
      expect(bmr, 1723.75);
    });

    test('Calculates Female BMR correctly', () {
      // Wanita 60kg, 160cm, 25 thn
      // BMR = (10*60) + (6.25*160) - (5*25) - 161 = 600 + 1000 - 125 - 161 = 1314.0
      final bmr = NutritionCalculator.calculateBmr(
        gender: Gender.female,
        weightKg: 60.0,
        heightCm: 160.0,
        age: 25,
      );
      expect(bmr, 1314.0);
    });

    test('Full plan calculation for Lean Bulking lifter allocates surplus and macros', () {
      final plan = NutritionCalculator.calculateFullPlan(
        gender: Gender.male,
        weightKg: 70.0,
        heightCm: 175.0,
        birthDate: DateTime.now().subtract(const Duration(days: 365 * 25)),
        activityLevel: 1.55,
        goal: FitnessGoal.bulk,
        proteinMultiplier: 2.0,
      );

      // Protein target should be 70 * 2.0 = 140g
      expect(plan.targetProteinG, 140.0);
      expect(plan.targetCalories, greaterThan(plan.tdee.round()));
      expect(plan.targetCarbsG, greaterThan(0));
      expect(plan.targetFatG, greaterThan(0));
    });
  });
}
