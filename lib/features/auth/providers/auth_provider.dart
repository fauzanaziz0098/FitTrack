import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/models/daily_summary.dart';
import '../../../data/models/food_item.dart';
import '../../../data/models/meal_log.dart';
import '../../../data/models/user_profile.dart';
import '../../../data/models/weight_log.dart';
import '../../../data/remote/supabase_service.dart';
import '../../../data/repositories/ironbite_repository.dart';

final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService.instance;
});

final ironBiteRepositoryProvider = Provider<IronBiteRepository>((ref) {
  final supabase = ref.watch(supabaseServiceProvider);
  return IronBiteRepository(supabase: supabase);
});

// Profile Provider
final currentProfileProvider = FutureProvider<UserProfile?>((ref) async {
  ref.watch(currentUserProvider);
  final repo = ref.watch(ironBiteRepositoryProvider);
  return await repo.getProfile();
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

// Daily Summary Provider for Selected Date
final dailySummaryProvider = FutureProvider<DailySummary>((ref) async {
  ref.watch(currentUserProvider);
  final repo = ref.watch(ironBiteRepositoryProvider);
  final date = ref.watch(selectedDateProvider);
  return await repo.getDailySummary(date);
});

// Meal Logs Provider for Selected Date
final mealLogsProvider = FutureProvider<List<MealLog>>((ref) async {
  ref.watch(currentUserProvider);
  final repo = ref.watch(ironBiteRepositoryProvider);
  final date = ref.watch(selectedDateProvider);
  return await repo.getMealLogsForDate(date);
});

// Weight Logs Provider
final weightLogsProvider = FutureProvider<List<WeightLog>>((ref) async {
  ref.watch(currentUserProvider);
  final repo = ref.watch(ironBiteRepositoryProvider);
  return await repo.getWeightLogs();
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

// Foods List Provider with search query
final foodsListProvider = FutureProvider<List<FoodItem>>((ref) async {
  ref.watch(currentUserProvider);
  final repo = ref.watch(ironBiteRepositoryProvider);
  final query = ref.watch(foodSearchQueryProvider);
  return await repo.getFoods(query: query);
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
