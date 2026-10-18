import 'dart:async';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../local/app_database.dart';
import '../local/default_foods.dart';
import '../remote/supabase_service.dart';

class DailySummary {
  final double totalCalories;
  final double totalProtein;
  final double totalCarbs;
  final double totalFat;
  final int logCount;

  const DailySummary({
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFat,
    required this.logCount,
  });

  static const empty = DailySummary(
    totalCalories: 0,
    totalProtein: 0,
    totalCarbs: 0,
    totalFat: 0,
    logCount: 0,
  );
}

class IronBiteRepository {
  final AppDatabase db;
  final SupabaseService supabase;
  final _uuid = const Uuid();

  IronBiteRepository({required this.db, required this.supabase});

  String get currentUserId => supabase.currentUser?.id ?? 'local_lifter_user';

  /// Initial seed & sync of master food list directly from Supabase
  Future<void> initDatabase() async {
    // 1. Sinkronisasi master foods langsung dari remote database Supabase jika terhubung
    if (supabase.isInitialized) {
      try {
        final remoteFoods = await supabase.fetchGlobalFoods();
        if (remoteFoods.isNotEmpty) {
          debugPrint('[IronBite] Syncing ${remoteFoods.length} foods from Supabase database...');
          await db.batch((batch) {
            for (final f in remoteFoods) {
              batch.insert(
                db.localFoods,
                LocalFoodsCompanion.insert(
                  id: f['id'] as String,
                  userId: Value(f['user_id'] as String?),
                  name: f['name'] as String,
                  barcode: Value(f['barcode'] as String?),
                  servingSizeG: Value((f['serving_size_g'] as num?)?.toDouble() ?? 100.0),
                  caloriesPerServing: (f['calories_per_serving'] as num).toDouble(),
                  proteinG: Value((f['protein_g'] as num?)?.toDouble() ?? 0.0),
                  carbsG: Value((f['carbs_g'] as num?)?.toDouble() ?? 0.0),
                  fatG: Value((f['fat_g'] as num?)?.toDouble() ?? 0.0),
                  isVerified: Value((f['is_verified'] as bool?) ?? false),
                  createdAt: DateTime.tryParse(f['created_at']?.toString() ?? '') ?? DateTime.now(),
                  isSynced: const Value(true),
                ),
                mode: InsertMode.insertOrReplace,
              );
            }
          });
          debugPrint('[IronBite] Master foods synced from Supabase successfully.');
          return;
        }
      } catch (e) {
        debugPrint('[IronBite] Fetch remote foods error: $e');
      }
    }

    // 2. Fallback offline jika belum ada data di local SQLite
    final existingFoodsCount = await (db.select(db.localFoods)..limit(1)).get();
    if (existingFoodsCount.isEmpty) {
      debugPrint('[IronBite] Seeding initial master foods into Drift SQLite...');
      await db.batch((batch) {
        batch.insertAll(db.localFoods, DefaultFoods.initialFoods);
      });
      debugPrint('[IronBite] Master foods seeded successfully.');
    }
  }

  // ==================== PROFILE METHODS ====================

  Stream<LocalProfile?> watchCurrentProfile() {
    return (db.select(db.localProfiles)
          ..where((tbl) => tbl.id.equals(currentUserId)))
        .watchSingleOrNull();
  }

  Future<LocalProfile?> getCurrentProfile() async {
    return await (db.select(db.localProfiles)
          ..where((tbl) => tbl.id.equals(currentUserId)))
        .getSingleOrNull();
  }

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
    final now = DateTime.now();
    final profileId = currentUserId;

    final companion = LocalProfilesCompanion.insert(
      id: profileId,
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
      createdAt: now,
      updatedAt: now,
      isSynced: const Value(false),
    );

    await db.into(db.localProfiles).insertOnConflictUpdate(companion);

    // Hapus data profile guest lama jika user sekarang sudah login
    if (profileId != 'local_lifter_user') {
      try {
        await (db.delete(db.localProfiles)..where((tbl) => tbl.id.equals('local_lifter_user'))).go();
      } catch (_) {}
    }

    // Also record initial weight in weight logs for today
    await logWeight(weightKg: currentWeightKg, date: now, notes: 'Target awal profil');

    // Background sync to Supabase
    _syncProfileToRemote(companion);
  }

  // ==================== FOODS METHODS ====================

  Stream<List<LocalFood>> watchFoods({String? query}) {
    final select = db.select(db.localFoods);
    select.where((tbl) => tbl.userId.isNull() | tbl.userId.equals(currentUserId));
    if (query != null && query.trim().isNotEmpty) {
      select.where((tbl) => tbl.name.contains(query.trim()));
    }
    select.orderBy([(tbl) => OrderingTerm.asc(tbl.name)]);
    return select.watch();
  }

  Future<List<LocalFood>> getFoods({String? query}) async {
    final select = db.select(db.localFoods);
    select.where((tbl) => tbl.userId.isNull() | tbl.userId.equals(currentUserId));
    if (query != null && query.trim().isNotEmpty) {
      select.where((tbl) => tbl.name.contains(query.trim()));
    }
    select.orderBy([(tbl) => OrderingTerm.asc(tbl.name)]);
    return await select.get();
  }

  Future<LocalFood> addCustomFood({
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

    final companion = LocalFoodsCompanion.insert(
      id: id,
      name: name,
      userId: Value(currentUserId),
      barcode: Value(barcode),
      servingSizeG: Value(servingSizeG),
      caloriesPerServing: caloriesPerServing,
      proteinG: Value(proteinG),
      carbsG: Value(carbsG),
      fatG: Value(fatG),
      isVerified: const Value(false),
      createdAt: now,
      isSynced: const Value(false),
    );

    await db.into(db.localFoods).insert(companion);
    _syncFoodToRemote(companion);

    return (await (db.select(db.localFoods)..where((tbl) => tbl.id.equals(id))).getSingle());
  }

  // ==================== MEAL LOGS METHODS ====================

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  Stream<List<LocalMealLog>> watchMealLogsForDate(DateTime date) {
    final normalized = _normalizeDate(date);
    return (db.select(db.localMealLogs)
          ..where((tbl) => tbl.loggedDate.equals(normalized) & tbl.userId.equals(currentUserId))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.createdAt)]))
        .watch();
  }

  Stream<DailySummary> watchDailySummary(DateTime date) {
    return watchMealLogsForDate(date).map((logs) {
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
    });
  }

  Future<void> logMeal({
    required LocalFood food,
    required String mealType, // 'breakfast', 'lunch', 'dinner', 'snack'
    required double servingQuantity, // e.g. 1.0, 1.5, 2.0
    required DateTime date,
  }) async {
    final now = DateTime.now();
    final normalized = _normalizeDate(date);
    final id = _uuid.v4();

    final totalCalories = food.caloriesPerServing * servingQuantity;
    final totalProtein = food.proteinG * servingQuantity;
    final totalCarbs = food.carbsG * servingQuantity;
    final totalFat = food.fatG * servingQuantity;

    final companion = LocalMealLogsCompanion.insert(
      id: id,
      userId: currentUserId,
      foodId: food.id,
      foodName: food.name,
      mealType: mealType,
      servingQuantity: Value(servingQuantity),
      totalCalories: totalCalories,
      totalProteinG: totalProtein,
      totalCarbsG: totalCarbs,
      totalFatG: totalFat,
      loggedDate: normalized,
      createdAt: now,
      isSynced: const Value(false),
    );

    await db.into(db.localMealLogs).insert(companion);
    _syncMealLogToRemote(companion);
  }

  Future<void> deleteMealLog(String id) async {
    await (db.delete(db.localMealLogs)..where((tbl) => tbl.id.equals(id))).go();
    unawaited(supabase.deleteMealLog(id));
  }

  // ==================== WEIGHT LOGS METHODS ====================

  Stream<List<LocalWeightLog>> watchWeightLogs() {
    return (db.select(db.localWeightLogs)
          ..where((tbl) => tbl.userId.equals(currentUserId))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.loggedDate)]))
        .watch();
  }

  Future<void> logWeight({
    required double weightKg,
    required DateTime date,
    String? notes,
  }) async {
    final now = DateTime.now();
    final normalized = _normalizeDate(date);

    // Check if an entry for this date already exists to update it
    final existing = await (db.select(db.localWeightLogs)
          ..where((tbl) => tbl.loggedDate.equals(normalized) & tbl.userId.equals(currentUserId)))
        .getSingleOrNull();

    final id = existing?.id ?? _uuid.v4();

    final companion = LocalWeightLogsCompanion.insert(
      id: id,
      userId: currentUserId,
      weightKg: weightKg,
      loggedDate: normalized,
      notes: Value(notes),
      createdAt: existing?.createdAt ?? now,
      isSynced: const Value(false),
    );

    await db.into(db.localWeightLogs).insertOnConflictUpdate(companion);

    // Update current weight in active profile as well
    final currentProfile = await getCurrentProfile();
    if (currentProfile != null) {
      await (db.update(db.localProfiles)..where((tbl) => tbl.id.equals(currentProfile.id))).write(
        LocalProfilesCompanion(
          currentWeightKg: Value(weightKg),
          updatedAt: Value(now),
        ),
      );
    }

    _syncWeightLogToRemote(companion);
  }

  Future<void> deleteWeightLog(String id) async {
    await (db.delete(db.localWeightLogs)..where((tbl) => tbl.id.equals(id))).go();
    unawaited(supabase.deleteWeightLog(id));
  }

  /// Membersihkan semua data lokal user saat logout agar akun berikutnya tidak melihat data akun sebelumnya
  Future<void> clearLocalUserData() async {
    try {
      await db.delete(db.localProfiles).go();
      await db.delete(db.localWeightLogs).go();
      await db.delete(db.localMealLogs).go();
      await (db.delete(db.localFoods)..where((tbl) => tbl.userId.isNotNull())).go();
      debugPrint('[IronBite] Data lokal berhasil dibersihkan saat logout.');
    } catch (e) {
      debugPrint('[IronBite] Error saat clearLocalUserData: $e');
    }
  }

  /// Menarik data spesifik user dari cloud Supabase ke database lokal (RLS compliant)
  Future<void> syncUserDataFromRemote() async {
    if (!supabase.isInitialized || supabase.currentUser == null) return;
    final userId = currentUserId;

    try {
      debugPrint('[IronBite] Mengambil data user dari Supabase untuk user: $userId');

      // 1. Ambil profile remote
      final remoteProfile = await supabase.fetchUserProfile(userId);
      if (remoteProfile != null) {
        final birthDate = DateTime.tryParse(remoteProfile['birth_date']?.toString() ?? '') ??
            DateTime.now().subtract(const Duration(days: 365 * 25));
        final updatedAt = DateTime.tryParse(remoteProfile['updated_at']?.toString() ?? '') ?? DateTime.now();

        await db.into(db.localProfiles).insertOnConflictUpdate(
          LocalProfilesCompanion.insert(
            id: userId,
            gender: remoteProfile['gender']?.toString() ?? 'male',
            birthDate: birthDate,
            heightCm: (remoteProfile['height_cm'] as num?)?.toDouble() ?? 170.0,
            currentWeightKg: (remoteProfile['current_weight_kg'] as num?)?.toDouble() ?? 70.0,
            activityLevel: (remoteProfile['activity_level'] as num?)?.toDouble() ?? 1.55,
            goal: remoteProfile['goal']?.toString() ?? 'bulk',
            calorieTarget: (remoteProfile['calorie_target'] as num?)?.toInt() ?? 2500,
            proteinTargetG: (remoteProfile['protein_target_g'] as num?)?.toDouble() ?? 150.0,
            carbsTargetG: (remoteProfile['carbs_target_g'] as num?)?.toDouble() ?? 250.0,
            fatTargetG: (remoteProfile['fat_target_g'] as num?)?.toDouble() ?? 60.0,
            createdAt: updatedAt,
            updatedAt: updatedAt,
            isSynced: const Value(true),
          ),
        );
      }

      // 2. Ambil catatan berat badan remote
      final remoteWeightLogs = await supabase.fetchUserWeightLogs(userId);
      for (final wl in remoteWeightLogs) {
        final loggedDate = DateTime.tryParse(wl['logged_date']?.toString() ?? '') ?? DateTime.now();
        final createdAt = DateTime.tryParse(wl['created_at']?.toString() ?? '') ?? loggedDate;
        await db.into(db.localWeightLogs).insertOnConflictUpdate(
          LocalWeightLogsCompanion.insert(
            id: wl['id'] as String,
            userId: userId,
            weightKg: (wl['weight_kg'] as num).toDouble(),
            loggedDate: loggedDate,
            notes: Value(wl['notes']?.toString()),
            createdAt: createdAt,
            isSynced: const Value(true),
          ),
        );
      }

      // 3. Ambil catatan makanan remote
      final remoteMealLogs = await supabase.fetchUserMealLogs(userId);
      for (final ml in remoteMealLogs) {
        final loggedDate = DateTime.tryParse(ml['logged_date']?.toString() ?? '') ?? DateTime.now();
        final createdAt = DateTime.tryParse(ml['created_at']?.toString() ?? '') ?? loggedDate;
        await db.into(db.localMealLogs).insertOnConflictUpdate(
          LocalMealLogsCompanion.insert(
            id: ml['id'] as String,
            userId: userId,
            foodId: ml['food_id'] as String,
            foodName: ml['food_name']?.toString() ?? 'Makanan',
            mealType: ml['meal_type'] as String,
            servingQuantity: Value((ml['serving_quantity'] as num?)?.toDouble() ?? 1.0),
            totalCalories: (ml['total_calories'] as num).toDouble(),
            totalProteinG: (ml['total_protein_g'] as num).toDouble(),
            totalCarbsG: (ml['total_carbs_g'] as num).toDouble(),
            totalFatG: (ml['total_fat_g'] as num).toDouble(),
            loggedDate: loggedDate,
            createdAt: createdAt,
            isSynced: const Value(true),
          ),
        );
      }
      debugPrint('[IronBite] Sinkronisasi data user dari Supabase selesai.');
    } catch (e) {
      debugPrint('[IronBite] Error saat syncUserDataFromRemote: $e');
    }
  }

  // ==================== SYNC ENGINE ====================

  Future<void> _syncProfileToRemote(LocalProfilesCompanion comp) async {
    if (!supabase.isInitialized) return;
    try {
      await supabase.upsertProfile({
        'id': comp.id.value,
        'gender': comp.gender.value,
        'birth_date': comp.birthDate.value.toIso8601String().split('T').first,
        'height_cm': comp.heightCm.value,
        'current_weight_kg': comp.currentWeightKg.value,
        'activity_level': comp.activityLevel.value,
        'goal': comp.goal.value,
        'calorie_target': comp.calorieTarget.value,
        'protein_target_g': comp.proteinTargetG.value,
        'carbs_target_g': comp.carbsTargetG.value,
        'fat_target_g': comp.fatTargetG.value,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      });
      await (db.update(db.localProfiles)..where((tbl) => tbl.id.equals(comp.id.value))).write(
        const LocalProfilesCompanion(isSynced: Value(true)),
      );
    } catch (e) {
      debugPrint('[SyncEngine] Sync profile error: $e');
    }
  }

  Future<void> _syncFoodToRemote(LocalFoodsCompanion comp) async {
    if (!supabase.isInitialized) return;
    try {
      await supabase.upsertFood({
        'id': comp.id.value,
        'user_id': comp.userId.value,
        'name': comp.name.value,
        'barcode': comp.barcode.value,
        'serving_size_g': comp.servingSizeG.value,
        'calories_per_serving': comp.caloriesPerServing.value,
        'protein_g': comp.proteinG.value,
        'carbs_g': comp.carbsG.value,
        'fat_g': comp.fatG.value,
        'is_verified': comp.isVerified.value,
      });
      await (db.update(db.localFoods)..where((tbl) => tbl.id.equals(comp.id.value))).write(
        const LocalFoodsCompanion(isSynced: Value(true)),
      );
    } catch (e) {
      debugPrint('[SyncEngine] Sync food error: $e');
    }
  }

  Future<void> _syncMealLogToRemote(LocalMealLogsCompanion comp) async {
    if (!supabase.isInitialized) return;
    try {
      await supabase.upsertMealLog({
        'id': comp.id.value,
        'user_id': comp.userId.value,
        'food_id': comp.foodId.value,
        'meal_type': comp.mealType.value,
        'serving_quantity': comp.servingQuantity.value,
        'total_calories': comp.totalCalories.value,
        'total_protein_g': comp.totalProteinG.value,
        'total_carbs_g': comp.totalCarbsG.value,
        'total_fat_g': comp.totalFatG.value,
        'logged_date': comp.loggedDate.value.toIso8601String().split('T').first,
      });
      await (db.update(db.localMealLogs)..where((tbl) => tbl.id.equals(comp.id.value))).write(
        const LocalMealLogsCompanion(isSynced: Value(true)),
      );
    } catch (e) {
      debugPrint('[SyncEngine] Sync meal log error: $e');
    }
  }

  Future<void> _syncWeightLogToRemote(LocalWeightLogsCompanion comp) async {
    if (!supabase.isInitialized) return;
    try {
      await supabase.upsertWeightLog({
        'id': comp.id.value,
        'user_id': comp.userId.value,
        'weight_kg': comp.weightKg.value,
        'logged_date': comp.loggedDate.value.toIso8601String().split('T').first,
        'notes': comp.notes.value,
      });
      await (db.update(db.localWeightLogs)..where((tbl) => tbl.id.equals(comp.id.value))).write(
        const LocalWeightLogsCompanion(isSynced: Value(true)),
      );
    } catch (e) {
      debugPrint('[SyncEngine] Sync weight log error: $e');
    }
  }

  /// Sinkronisasi penuh semua data lokal yang belum tersinkron
  Future<String> triggerFullSync() async {
    if (!supabase.isInitialized) {
      return 'Koneksi ke Supabase belum terinisialisasi. Periksa koneksi internet.';
    }

    try {
      // 0. Tarik data user terbaru dari remote
      await syncUserDataFromRemote();

      // 1. Sync Profile
      final unsyncedProfile = await (db.select(db.localProfiles)
            ..where((tbl) => tbl.isSynced.equals(false)))
          .getSingleOrNull();

      if (unsyncedProfile != null) {
        await supabase.upsertProfile({
          'id': unsyncedProfile.id,
          'gender': unsyncedProfile.gender,
          'birth_date': unsyncedProfile.birthDate.toIso8601String().split('T').first,
          'height_cm': unsyncedProfile.heightCm,
          'current_weight_kg': unsyncedProfile.currentWeightKg,
          'activity_level': unsyncedProfile.activityLevel,
          'goal': unsyncedProfile.goal,
          'calorie_target': unsyncedProfile.calorieTarget,
          'protein_target_g': unsyncedProfile.proteinTargetG,
          'carbs_target_g': unsyncedProfile.carbsTargetG,
          'fat_target_g': unsyncedProfile.fatTargetG,
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        });
        await (db.update(db.localProfiles)..where((tbl) => tbl.id.equals(unsyncedProfile.id)))
            .write(const LocalProfilesCompanion(isSynced: Value(true)));
      }

      // 2. Sync Meal Logs
      final unsyncedMealLogs = await (db.select(db.localMealLogs)
            ..where((tbl) => tbl.isSynced.equals(false)))
          .get();

      for (final ml in unsyncedMealLogs) {
        await supabase.upsertMealLog({
          'id': ml.id,
          'user_id': ml.userId,
          'food_id': ml.foodId,
          'meal_type': ml.mealType,
          'serving_quantity': ml.servingQuantity,
          'total_calories': ml.totalCalories,
          'total_protein_g': ml.totalProteinG,
          'total_carbs_g': ml.totalCarbsG,
          'total_fat_g': ml.totalFatG,
          'logged_date': ml.loggedDate.toIso8601String().split('T').first,
        });
        await (db.update(db.localMealLogs)..where((tbl) => tbl.id.equals(ml.id)))
            .write(const LocalMealLogsCompanion(isSynced: Value(true)));
      }

      // 3. Sync Weight Logs
      final unsyncedWeightLogs = await (db.select(db.localWeightLogs)
            ..where((tbl) => tbl.isSynced.equals(false)))
          .get();

      for (final wl in unsyncedWeightLogs) {
        await supabase.upsertWeightLog({
          'id': wl.id,
          'user_id': wl.userId,
          'weight_kg': wl.weightKg,
          'logged_date': wl.loggedDate.toIso8601String().split('T').first,
          'notes': wl.notes,
        });
        await (db.update(db.localWeightLogs)..where((tbl) => tbl.id.equals(wl.id)))
            .write(const LocalWeightLogsCompanion(isSynced: Value(true)));
      }

      // 4. Sinkronisasi master foods dari database Supabase
      final remoteFoods = await supabase.fetchGlobalFoods();
      if (remoteFoods.isNotEmpty) {
        await db.batch((batch) {
          for (final f in remoteFoods) {
            batch.insert(
              db.localFoods,
              LocalFoodsCompanion.insert(
                id: f['id'] as String,
                userId: Value(f['user_id'] as String?),
                name: f['name'] as String,
                barcode: Value(f['barcode'] as String?),
                servingSizeG: Value((f['serving_size_g'] as num?)?.toDouble() ?? 100.0),
                caloriesPerServing: (f['calories_per_serving'] as num).toDouble(),
                proteinG: Value((f['protein_g'] as num?)?.toDouble() ?? 0.0),
                carbsG: Value((f['carbs_g'] as num?)?.toDouble() ?? 0.0),
                fatG: Value((f['fat_g'] as num?)?.toDouble() ?? 0.0),
                isVerified: Value((f['is_verified'] as bool?) ?? false),
                createdAt: DateTime.tryParse(f['created_at']?.toString() ?? '') ?? DateTime.now(),
                isSynced: const Value(true),
              ),
              mode: InsertMode.insertOrReplace,
            );
          }
        });
      }

      return 'Sinkronisasi berhasil! ${unsyncedMealLogs.length} meal logs & ${unsyncedWeightLogs.length} weight logs tersimpan ke cloud Supabase (${remoteFoods.length} master foods terhubung).';
    } catch (e) {
      return 'Gagal sinkronisasi: $e';
    }
  }
}
