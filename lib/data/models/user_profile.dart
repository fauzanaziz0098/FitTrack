class UserProfile {
  final String id;
  final String gender;
  final DateTime birthDate;
  final double heightCm;
  final double currentWeightKg;
  final double activityLevel;
  final String goal;
  final int calorieTarget;
  final double proteinTargetG;
  final double carbsTargetG;
  final double fatTargetG;
  final DateTime updatedAt;

  const UserProfile({
    required this.id,
    required this.gender,
    required this.birthDate,
    required this.heightCm,
    required this.currentWeightKg,
    required this.activityLevel,
    required this.goal,
    required this.calorieTarget,
    required this.proteinTargetG,
    required this.carbsTargetG,
    required this.fatTargetG,
    required this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      gender: json['gender'] as String? ?? 'male',
      birthDate: DateTime.tryParse(json['birth_date']?.toString() ?? '') ??
          DateTime.now().subtract(const Duration(days: 365 * 25)),
      heightCm: (json['height_cm'] as num?)?.toDouble() ?? 170.0,
      currentWeightKg: (json['current_weight_kg'] as num?)?.toDouble() ?? 70.0,
      activityLevel: (json['activity_level'] as num?)?.toDouble() ?? 1.55,
      goal: json['goal'] as String? ?? 'bulk',
      calorieTarget: (json['calorie_target'] as num?)?.toInt() ?? 2500,
      proteinTargetG: (json['protein_target_g'] as num?)?.toDouble() ?? 150.0,
      carbsTargetG: (json['carbs_target_g'] as num?)?.toDouble() ?? 250.0,
      fatTargetG: (json['fat_target_g'] as num?)?.toDouble() ?? 60.0,
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gender': gender,
      'birth_date': birthDate.toIso8601String().split('T').first,
      'height_cm': heightCm,
      'current_weight_kg': currentWeightKg,
      'activity_level': activityLevel,
      'goal': goal,
      'calorie_target': calorieTarget,
      'protein_target_g': proteinTargetG,
      'carbs_target_g': carbsTargetG,
      'fat_target_g': fatTargetG,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    };
  }
}
