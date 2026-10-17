import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/local/app_database.dart';
import '../../../data/remote/supabase_service.dart';
import '../../../data/repositories/ironbite_repository.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService.instance;
});

final ironBiteRepositoryProvider = Provider<IronBiteRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final supabase = ref.watch(supabaseServiceProvider);
  return IronBiteRepository(db: db, supabase: supabase);
});

// Profile Stream Provider
final currentProfileProvider = StreamProvider<LocalProfile?>((ref) {
  final repo = ref.watch(ironBiteRepositoryProvider);
  return repo.watchCurrentProfile();
});

// Selected Date Notifier for Dashboard
class SelectedDateNotifier extends Notifier<DateTime> {
  @override
  DateTime build() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  void setDate(DateTime date) => state = date;
  void nextDay() => state = state.add(const Duration(days: 1));
  void prevDay() => state = state.subtract(const Duration(days: 1));
}

final selectedDateProvider = NotifierProvider<SelectedDateNotifier, DateTime>(
  SelectedDateNotifier.new,
);

// Daily Summary Stream Provider for Selected Date
final dailySummaryProvider = StreamProvider<DailySummary>((ref) {
  final repo = ref.watch(ironBiteRepositoryProvider);
  final date = ref.watch(selectedDateProvider);
  return repo.watchDailySummary(date);
});

// Meal Logs Stream Provider for Selected Date
final mealLogsProvider = StreamProvider<List<LocalMealLog>>((ref) {
  final repo = ref.watch(ironBiteRepositoryProvider);
  final date = ref.watch(selectedDateProvider);
  return repo.watchMealLogsForDate(date);
});

// Weight Logs Stream Provider
final weightLogsProvider = StreamProvider<List<LocalWeightLog>>((ref) {
  final repo = ref.watch(ironBiteRepositoryProvider);
  return repo.watchWeightLogs();
});

// Food Search Query Notifier
class FoodSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String q) => state = q;
  void clear() => state = '';
}

final foodSearchQueryProvider = NotifierProvider<FoodSearchQueryNotifier, String>(
  FoodSearchQueryNotifier.new,
);

// Foods Stream Provider with search query
final foodsListProvider = StreamProvider<List<LocalFood>>((ref) {
  final repo = ref.watch(ironBiteRepositoryProvider);
  final query = ref.watch(foodSearchQueryProvider);
  return repo.watchFoods(query: query);
});

// Auth state provider
final authStateProvider = StreamProvider<AuthState?>((ref) {
  final supabase = ref.watch(supabaseServiceProvider);
  if (!supabase.isInitialized) return Stream.value(null);
  return Supabase.instance.client.auth.onAuthStateChange;
});

// Current user provider (reactive to login/logout)
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.value?.session?.user ?? SupabaseService.instance.currentUser;
});
