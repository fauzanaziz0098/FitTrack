import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class LocalProfiles extends Table {
  TextColumn get id => text()();
  TextColumn get gender => text()(); // 'male' or 'female'
  DateTimeColumn get birthDate => dateTime()();
  RealColumn get heightCm => real()();
  RealColumn get currentWeightKg => real()();
  RealColumn get activityLevel => real()();
  TextColumn get goal => text()(); // 'cut', 'maintain', 'bulk'
  IntColumn get calorieTarget => integer()();
  RealColumn get proteinTargetG => real()();
  RealColumn get carbsTargetG => real()();
  RealColumn get fatTargetG => real()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalFoods extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().nullable()(); // null = global preset
  TextColumn get name => text()();
  TextColumn get barcode => text().nullable()();
  RealColumn get servingSizeG => real().withDefault(const Constant(100.0))();
  RealColumn get caloriesPerServing => real()();
  RealColumn get proteinG => real().withDefault(const Constant(0.0))();
  RealColumn get carbsG => real().withDefault(const Constant(0.0))();
  RealColumn get fatG => real().withDefault(const Constant(0.0))();
  BoolColumn get isVerified => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalMealLogs extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get foodId => text()();
  TextColumn get foodName => text()();
  TextColumn get mealType => text()(); // 'breakfast', 'lunch', 'dinner', 'snack'
  RealColumn get servingQuantity => real().withDefault(const Constant(1.0))();
  RealColumn get totalCalories => real()();
  RealColumn get totalProteinG => real()();
  RealColumn get totalCarbsG => real()();
  RealColumn get totalFatG => real()();
  DateTimeColumn get loggedDate => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalWeightLogs extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  RealColumn get weightKg => real()();
  DateTimeColumn get loggedDate => dateTime()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [LocalProfiles, LocalFoods, LocalMealLogs, LocalWeightLogs])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'ironbite_db');
  }
}
