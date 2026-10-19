class WeightLog {
  final String id;
  final String userId;
  final double weightKg;
  final DateTime loggedDate;
  final String? notes;
  final DateTime createdAt;

  const WeightLog({
    required this.id,
    required this.userId,
    required this.weightKg,
    required this.loggedDate,
    this.notes,
    required this.createdAt,
  });

  factory WeightLog.fromJson(Map<String, dynamic> json) {
    return WeightLog(
      id: json['id'] as String,
      userId: json['user_id'] as String? ?? '',
      weightKg: (json['weight_kg'] as num?)?.toDouble() ?? 0.0,
      loggedDate: DateTime.tryParse(json['logged_date']?.toString() ?? '') ?? DateTime.now(),
      notes: json['notes'] as String?,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'weight_kg': weightKg,
      'logged_date': loggedDate.toIso8601String().split('T').first,
      'notes': notes,
    };
  }
}
