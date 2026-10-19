class MealLog {
  final String id;
  final String userId;
  final String foodId;
  final String foodName;
  final String mealType;
  final double servingQuantity;
  final double totalCalories;
  final double totalProteinG;
  final double totalCarbsG;
  final double totalFatG;
  final DateTime loggedDate;
  final DateTime createdAt;

  const MealLog({
    required this.id,
    required this.userId,
    required this.foodId,
    required this.foodName,
    required this.mealType,
    required this.servingQuantity,
    required this.totalCalories,
    required this.totalProteinG,
    required this.totalCarbsG,
    required this.totalFatG,
    required this.loggedDate,
    required this.createdAt,
  });

  factory MealLog.fromJson(Map<String, dynamic> json) {
    // Cari nama makanan dari hasil join table foods(name)
    String name = 'Makanan';
    if (json['foods'] is Map && json['foods']['name'] != null) {
      name = json['foods']['name'].toString();
    } else if (json['food_name'] != null && json['food_name'].toString().isNotEmpty) {
      name = json['food_name'].toString();
    }

    return MealLog(
      id: json['id'] as String,
      userId: json['user_id'] as String? ?? '',
      foodId: json['food_id'] as String? ?? '',
      foodName: name,
      mealType: json['meal_type'] as String? ?? 'breakfast',
      servingQuantity: (json['serving_quantity'] as num?)?.toDouble() ?? 1.0,
      totalCalories: (json['total_calories'] as num?)?.toDouble() ?? 0.0,
      totalProteinG: (json['total_protein_g'] as num?)?.toDouble() ?? 0.0,
      totalCarbsG: (json['total_carbs_g'] as num?)?.toDouble() ?? 0.0,
      totalFatG: (json['total_fat_g'] as num?)?.toDouble() ?? 0.0,
      loggedDate: DateTime.tryParse(json['logged_date']?.toString() ?? '') ?? DateTime.now(),
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'food_id': foodId,
      'meal_type': mealType,
      'serving_quantity': servingQuantity,
      'total_calories': totalCalories,
      'total_protein_g': totalProteinG,
      'total_carbs_g': totalCarbsG,
      'total_fat_g': totalFatG,
      'logged_date': loggedDate.toIso8601String().split('T').first,
    };
  }
}
