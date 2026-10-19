import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../local/default_foods.dart';
import '../models/daily_summary.dart';
import '../models/food_item.dart';
import '../models/meal_log.dart';
import '../models/user_profile.dart';
import '../models/weight_log.dart';
import '../remote/supabase_service.dart';

class IronBiteRepository {
  final SupabaseService supabase;
  final _uuid = const Uuid();

  IronBiteRepository({required this.supabase});

  String get currentUserId => supabase.currentUser?.id ?? '';

  Future<void> initDatabase() async {
    // Dipanggil saat startup untuk memastikan koneksi ke Supabase aktif
    debugPrint('[IronBite] Initializing pure Supabase repository. Current user: $currentUserId');
  }

  // ==================== PROFILE METHODS ====================

  Future<UserProfile?> getProfile() async {
    if (currentUserId.isEmpty) return null;
    final json = await supabase.fetchUserProfile(currentUserId);
    if (json == null) return null;
    return UserProfile.fromJson(json);
  }

  // Alias untuk kompatibilitas kode UI lama
  Future<UserProfile?> getCurrentProfile() async => getProfile();

  Future<void> saveProfile({
    required String gender,
    required DateTime birthDate,
    required double heightCm,
    required double currentWeightKg,
    required double activityLevel,
    required String goal,
    required int calorieTarget,
    required double proteinTargetG,
    required double carbsTargetG,
    required double fatTargetG,
  }) async {
    if (currentUserId.isEmpty) {
      throw Exception('Harap masuk terlebih dahulu untuk menyimpan profil.');
    }

    final profile = UserProfile(
      id: currentUserId,
      gender: gender,
      birthDate: birthDate,
      heightCm: heightCm,
      currentWeightKg: currentWeightKg,
      activityLevel: activityLevel,
      goal: goal,
      calorieTarget: calorieTarget,
      proteinTargetG: proteinTargetG,
      carbsTargetG: carbsTargetG,
      fatTargetG: fatTargetG,
      updatedAt: DateTime.now(),
    );

    await supabase.upsertProfile(profile.toJson());

    // Catat juga berat badan hari ini di catatan timbangan
    await logWeight(weightKg: currentWeightKg, date: DateTime.now(), notes: 'Target awal profil');
  }

  // ==================== FOODS METHODS ====================

  Future<List<FoodItem>> getFoods({String? query}) async {
    final remoteList = await supabase.fetchFoods(userId: currentUserId, query: query);
    List<FoodItem> items = remoteList.map((e) => FoodItem.fromJson(e)).toList();

    // Jika di database remote belum ada data makanan master, gabungkan dengan makanan standar fitnes lokal
    if (items.isEmpty) {
      final defaultList = DefaultFoods.initialFoods;
      if (query != null && query.trim().isNotEmpty) {
        final q = query.trim().toLowerCase();
        return defaultList.where((f) => f.name.toLowerCase().contains(q)).toList();
      }
      return defaultList;
    }

    return items;
  }

  Future<FoodItem> addCustomFood({
    required String name,
    required double servingSizeG,
    required double caloriesPerServing,
    required double proteinG,
    required double carbsG,
    required double fatG,
    String? barcode,
  }) async {
    final now = DateTime.now();
    final id = _uuid.v4();

    final food = FoodItem(
      id: id,
      userId: currentUserId.isNotEmpty ? currentUserId : null,
      name: name,
      barcode: barcode,
      servingSizeG: servingSizeG,
      caloriesPerServing: caloriesPerServing,
      proteinG: proteinG,
      carbsG: carbsG,
      fatG: fatG,
      isVerified: false,
      createdAt: now,
    );

    await supabase.upsertFood(food.toJson());
    return food;
  }

  // ==================== MEAL LOGS METHODS ====================

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  Future<List<MealLog>> getMealLogsForDate(DateTime date) async {
    if (currentUserId.isEmpty) return [];
    final normalized = _normalizeDate(date);
    final remoteList = await supabase.fetchUserMealLogs(currentUserId, date: normalized);
    return remoteList.map((e) => MealLog.fromJson(e)).toList();
  }

  Future<DailySummary> getDailySummary(DateTime date) async {
    final logs = await getMealLogsForDate(date);
    double cals = 0;
    double pro = 0;
    double carbs = 0;
    double fat = 0;

    for (final log in logs) {
      cals += log.totalCalories;
      pro += log.totalProteinG;
      carbs += log.totalCarbsG;
      fat += log.totalFatG;
    }

    return DailySummary(
      totalCalories: cals,
      totalProtein: pro,
      totalCarbs: carbs,
      totalFat: fat,
      logCount: logs.length,
    );
  }

  Future<void> logMeal({
    required FoodItem food,
    required String mealType,
    required double servingQuantity,
    required DateTime date,
  }) async {
    if (currentUserId.isEmpty) {
      throw Exception('Harap masuk terlebih dahulu untuk mencatat makanan.');
    }

    final now = DateTime.now();
    final normalized = _normalizeDate(date);
    final id = _uuid.v4();

    final totalCalories = food.caloriesPerServing * servingQuantity;
    final totalProtein = food.proteinG * servingQuantity;
    final totalCarbs = food.carbsG * servingQuantity;
    final totalFat = food.fatG * servingQuantity;

    final mealLog = MealLog(
      id: id,
      userId: currentUserId,
      foodId: food.id,
      foodName: food.name,
      mealType: mealType,
      servingQuantity: servingQuantity,
      totalCalories: totalCalories,
      totalProteinG: totalProtein,
      totalCarbsG: totalCarbs,
      totalFatG: totalFat,
      loggedDate: normalized,
      createdAt: now,
    );

    await supabase.upsertMealLog(mealLog.toJson());
  }

  Future<void> deleteMealLog(String id) async {
    await supabase.deleteMealLog(id);
  }

  // ==================== WEIGHT LOGS METHODS ====================

  Future<List<WeightLog>> getWeightLogs() async {
    if (currentUserId.isEmpty) return [];
    final remoteList = await supabase.fetchUserWeightLogs(currentUserId);
    return remoteList.map((e) => WeightLog.fromJson(e)).toList();
  }

  Future<void> logWeight({
    required double weightKg,
    required DateTime date,
    String? id,
    String? notes,
  }) async {
    if (currentUserId.isEmpty) {
      throw Exception('Harap masuk terlebih dahulu untuk mencatat berat badan.');
    }

    final now = DateTime.now();
    final normalized = _normalizeDate(date);
    final dateStr = normalized.toIso8601String().split('T').first;

    final data = <String, dynamic>{
      'user_id': currentUserId,
      'weight_kg': weightKg,
      'logged_date': dateStr,
      'notes': notes,
    };
    if (id != null && id.isNotEmpty) {
      data['id'] = id;
    }

    await supabase.upsertWeightLog(data);

    // Update berat badan saat ini di profil pengguna
    final profile = await getProfile();
    if (profile != null) {
      final updatedProfile = UserProfile(
        id: profile.id,
        gender: profile.gender,
        birthDate: profile.birthDate,
        heightCm: profile.heightCm,
        currentWeightKg: weightKg,
        activityLevel: profile.activityLevel,
        goal: profile.goal,
        calorieTarget: profile.calorieTarget,
        proteinTargetG: profile.proteinTargetG,
        carbsTargetG: profile.carbsTargetG,
        fatTargetG: profile.fatTargetG,
        updatedAt: now,
      );
      await supabase.upsertProfile(updatedProfile.toJson());
    }
  }

  Future<void> deleteWeightLog(String id) async {
    await supabase.deleteWeightLog(id);
  }
}
