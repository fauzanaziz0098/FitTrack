class FoodItem {
  final String id;
  final String? userId;
  final String name;
  final String? barcode;
  final double servingSizeG;
  final double caloriesPerServing;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final bool isVerified;
  final DateTime createdAt;

  const FoodItem({
    required this.id,
    this.userId,
    required this.name,
    this.barcode,
    required this.servingSizeG,
    required this.caloriesPerServing,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    this.isVerified = false,
    required this.createdAt,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'] as String,
      userId: json['user_id'] as String?,
      name: json['name'] as String? ?? 'Makanan',
      barcode: json['barcode'] as String?,
      servingSizeG: (json['serving_size_g'] as num?)?.toDouble() ?? 100.0,
      caloriesPerServing: (json['calories_per_serving'] as num?)?.toDouble() ?? 0.0,
      proteinG: (json['protein_g'] as num?)?.toDouble() ?? 0.0,
      carbsG: (json['carbs_g'] as num?)?.toDouble() ?? 0.0,
      fatG: (json['fat_g'] as num?)?.toDouble() ?? 0.0,
      isVerified: json['is_verified'] as bool? ?? false,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'barcode': barcode,
      'serving_size_g': servingSizeG,
      'calories_per_serving': caloriesPerServing,
      'protein_g': proteinG,
      'carbs_g': carbsG,
      'fat_g': fatG,
      'is_verified': isVerified,
    };
  }
}
