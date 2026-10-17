// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $LocalProfilesTable extends LocalProfiles
    with TableInfo<$LocalProfilesTable, LocalProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
    'gender',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _birthDateMeta = const VerificationMeta(
    'birthDate',
  );
  @override
  late final GeneratedColumn<DateTime> birthDate = GeneratedColumn<DateTime>(
    'birth_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _heightCmMeta = const VerificationMeta(
    'heightCm',
  );
  @override
  late final GeneratedColumn<double> heightCm = GeneratedColumn<double>(
    'height_cm',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentWeightKgMeta = const VerificationMeta(
    'currentWeightKg',
  );
  @override
  late final GeneratedColumn<double> currentWeightKg = GeneratedColumn<double>(
    'current_weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activityLevelMeta = const VerificationMeta(
    'activityLevel',
  );
  @override
  late final GeneratedColumn<double> activityLevel = GeneratedColumn<double>(
    'activity_level',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _goalMeta = const VerificationMeta('goal');
  @override
  late final GeneratedColumn<String> goal = GeneratedColumn<String>(
    'goal',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _calorieTargetMeta = const VerificationMeta(
    'calorieTarget',
  );
  @override
  late final GeneratedColumn<int> calorieTarget = GeneratedColumn<int>(
    'calorie_target',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _proteinTargetGMeta = const VerificationMeta(
    'proteinTargetG',
  );
  @override
  late final GeneratedColumn<double> proteinTargetG = GeneratedColumn<double>(
    'protein_target_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _carbsTargetGMeta = const VerificationMeta(
    'carbsTargetG',
  );
  @override
  late final GeneratedColumn<double> carbsTargetG = GeneratedColumn<double>(
    'carbs_target_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fatTargetGMeta = const VerificationMeta(
    'fatTargetG',
  );
  @override
  late final GeneratedColumn<double> fatTargetG = GeneratedColumn<double>(
    'fat_target_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    gender,
    birthDate,
    heightCm,
    currentWeightKg,
    activityLevel,
    goal,
    calorieTarget,
    proteinTargetG,
    carbsTargetG,
    fatTargetG,
    createdAt,
    updatedAt,
    isSynced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('gender')) {
      context.handle(
        _genderMeta,
        gender.isAcceptableOrUnknown(data['gender']!, _genderMeta),
      );
    } else if (isInserting) {
      context.missing(_genderMeta);
    }
    if (data.containsKey('birth_date')) {
      context.handle(
        _birthDateMeta,
        birthDate.isAcceptableOrUnknown(data['birth_date']!, _birthDateMeta),
      );
    } else if (isInserting) {
      context.missing(_birthDateMeta);
    }
    if (data.containsKey('height_cm')) {
      context.handle(
        _heightCmMeta,
        heightCm.isAcceptableOrUnknown(data['height_cm']!, _heightCmMeta),
      );
    } else if (isInserting) {
      context.missing(_heightCmMeta);
    }
    if (data.containsKey('current_weight_kg')) {
      context.handle(
        _currentWeightKgMeta,
        currentWeightKg.isAcceptableOrUnknown(
          data['current_weight_kg']!,
          _currentWeightKgMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currentWeightKgMeta);
    }
    if (data.containsKey('activity_level')) {
      context.handle(
        _activityLevelMeta,
        activityLevel.isAcceptableOrUnknown(
          data['activity_level']!,
          _activityLevelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_activityLevelMeta);
    }
    if (data.containsKey('goal')) {
      context.handle(
        _goalMeta,
        goal.isAcceptableOrUnknown(data['goal']!, _goalMeta),
      );
    } else if (isInserting) {
      context.missing(_goalMeta);
    }
    if (data.containsKey('calorie_target')) {
      context.handle(
        _calorieTargetMeta,
        calorieTarget.isAcceptableOrUnknown(
          data['calorie_target']!,
          _calorieTargetMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_calorieTargetMeta);
    }
    if (data.containsKey('protein_target_g')) {
      context.handle(
        _proteinTargetGMeta,
        proteinTargetG.isAcceptableOrUnknown(
          data['protein_target_g']!,
          _proteinTargetGMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_proteinTargetGMeta);
    }
    if (data.containsKey('carbs_target_g')) {
      context.handle(
        _carbsTargetGMeta,
        carbsTargetG.isAcceptableOrUnknown(
          data['carbs_target_g']!,
          _carbsTargetGMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_carbsTargetGMeta);
    }
    if (data.containsKey('fat_target_g')) {
      context.handle(
        _fatTargetGMeta,
        fatTargetG.isAcceptableOrUnknown(
          data['fat_target_g']!,
          _fatTargetGMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fatTargetGMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gender'],
      )!,
      birthDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}birth_date'],
      )!,
      heightCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}height_cm'],
      )!,
      currentWeightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}current_weight_kg'],
      )!,
      activityLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}activity_level'],
      )!,
      goal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal'],
      )!,
      calorieTarget: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}calorie_target'],
      )!,
      proteinTargetG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}protein_target_g'],
      )!,
      carbsTargetG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carbs_target_g'],
      )!,
      fatTargetG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fat_target_g'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
    );
  }

  @override
  $LocalProfilesTable createAlias(String alias) {
    return $LocalProfilesTable(attachedDatabase, alias);
  }
}

class LocalProfile extends DataClass implements Insertable<LocalProfile> {
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
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced;
  const LocalProfile({
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
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['gender'] = Variable<String>(gender);
    map['birth_date'] = Variable<DateTime>(birthDate);
    map['height_cm'] = Variable<double>(heightCm);
    map['current_weight_kg'] = Variable<double>(currentWeightKg);
    map['activity_level'] = Variable<double>(activityLevel);
    map['goal'] = Variable<String>(goal);
    map['calorie_target'] = Variable<int>(calorieTarget);
    map['protein_target_g'] = Variable<double>(proteinTargetG);
    map['carbs_target_g'] = Variable<double>(carbsTargetG);
    map['fat_target_g'] = Variable<double>(fatTargetG);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  LocalProfilesCompanion toCompanion(bool nullToAbsent) {
    return LocalProfilesCompanion(
      id: Value(id),
      gender: Value(gender),
      birthDate: Value(birthDate),
      heightCm: Value(heightCm),
      currentWeightKg: Value(currentWeightKg),
      activityLevel: Value(activityLevel),
      goal: Value(goal),
      calorieTarget: Value(calorieTarget),
      proteinTargetG: Value(proteinTargetG),
      carbsTargetG: Value(carbsTargetG),
      fatTargetG: Value(fatTargetG),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isSynced: Value(isSynced),
    );
  }

  factory LocalProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalProfile(
      id: serializer.fromJson<String>(json['id']),
      gender: serializer.fromJson<String>(json['gender']),
      birthDate: serializer.fromJson<DateTime>(json['birthDate']),
      heightCm: serializer.fromJson<double>(json['heightCm']),
      currentWeightKg: serializer.fromJson<double>(json['currentWeightKg']),
      activityLevel: serializer.fromJson<double>(json['activityLevel']),
      goal: serializer.fromJson<String>(json['goal']),
      calorieTarget: serializer.fromJson<int>(json['calorieTarget']),
      proteinTargetG: serializer.fromJson<double>(json['proteinTargetG']),
      carbsTargetG: serializer.fromJson<double>(json['carbsTargetG']),
      fatTargetG: serializer.fromJson<double>(json['fatTargetG']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'gender': serializer.toJson<String>(gender),
      'birthDate': serializer.toJson<DateTime>(birthDate),
      'heightCm': serializer.toJson<double>(heightCm),
      'currentWeightKg': serializer.toJson<double>(currentWeightKg),
      'activityLevel': serializer.toJson<double>(activityLevel),
      'goal': serializer.toJson<String>(goal),
      'calorieTarget': serializer.toJson<int>(calorieTarget),
      'proteinTargetG': serializer.toJson<double>(proteinTargetG),
      'carbsTargetG': serializer.toJson<double>(carbsTargetG),
      'fatTargetG': serializer.toJson<double>(fatTargetG),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  LocalProfile copyWith({
    String? id,
    String? gender,
    DateTime? birthDate,
    double? heightCm,
    double? currentWeightKg,
    double? activityLevel,
    String? goal,
    int? calorieTarget,
    double? proteinTargetG,
    double? carbsTargetG,
    double? fatTargetG,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
  }) => LocalProfile(
    id: id ?? this.id,
    gender: gender ?? this.gender,
    birthDate: birthDate ?? this.birthDate,
    heightCm: heightCm ?? this.heightCm,
    currentWeightKg: currentWeightKg ?? this.currentWeightKg,
    activityLevel: activityLevel ?? this.activityLevel,
    goal: goal ?? this.goal,
    calorieTarget: calorieTarget ?? this.calorieTarget,
    proteinTargetG: proteinTargetG ?? this.proteinTargetG,
    carbsTargetG: carbsTargetG ?? this.carbsTargetG,
    fatTargetG: fatTargetG ?? this.fatTargetG,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isSynced: isSynced ?? this.isSynced,
  );
  LocalProfile copyWithCompanion(LocalProfilesCompanion data) {
    return LocalProfile(
      id: data.id.present ? data.id.value : this.id,
      gender: data.gender.present ? data.gender.value : this.gender,
      birthDate: data.birthDate.present ? data.birthDate.value : this.birthDate,
      heightCm: data.heightCm.present ? data.heightCm.value : this.heightCm,
      currentWeightKg: data.currentWeightKg.present
          ? data.currentWeightKg.value
          : this.currentWeightKg,
      activityLevel: data.activityLevel.present
          ? data.activityLevel.value
          : this.activityLevel,
      goal: data.goal.present ? data.goal.value : this.goal,
      calorieTarget: data.calorieTarget.present
          ? data.calorieTarget.value
          : this.calorieTarget,
      proteinTargetG: data.proteinTargetG.present
          ? data.proteinTargetG.value
          : this.proteinTargetG,
      carbsTargetG: data.carbsTargetG.present
          ? data.carbsTargetG.value
          : this.carbsTargetG,
      fatTargetG: data.fatTargetG.present
          ? data.fatTargetG.value
          : this.fatTargetG,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalProfile(')
          ..write('id: $id, ')
          ..write('gender: $gender, ')
          ..write('birthDate: $birthDate, ')
          ..write('heightCm: $heightCm, ')
          ..write('currentWeightKg: $currentWeightKg, ')
          ..write('activityLevel: $activityLevel, ')
          ..write('goal: $goal, ')
          ..write('calorieTarget: $calorieTarget, ')
          ..write('proteinTargetG: $proteinTargetG, ')
          ..write('carbsTargetG: $carbsTargetG, ')
          ..write('fatTargetG: $fatTargetG, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    gender,
    birthDate,
    heightCm,
    currentWeightKg,
    activityLevel,
    goal,
    calorieTarget,
    proteinTargetG,
    carbsTargetG,
    fatTargetG,
    createdAt,
    updatedAt,
    isSynced,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalProfile &&
          other.id == this.id &&
          other.gender == this.gender &&
          other.birthDate == this.birthDate &&
          other.heightCm == this.heightCm &&
          other.currentWeightKg == this.currentWeightKg &&
          other.activityLevel == this.activityLevel &&
          other.goal == this.goal &&
          other.calorieTarget == this.calorieTarget &&
          other.proteinTargetG == this.proteinTargetG &&
          other.carbsTargetG == this.carbsTargetG &&
          other.fatTargetG == this.fatTargetG &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isSynced == this.isSynced);
}

class LocalProfilesCompanion extends UpdateCompanion<LocalProfile> {
  final Value<String> id;
  final Value<String> gender;
  final Value<DateTime> birthDate;
  final Value<double> heightCm;
  final Value<double> currentWeightKg;
  final Value<double> activityLevel;
  final Value<String> goal;
  final Value<int> calorieTarget;
  final Value<double> proteinTargetG;
  final Value<double> carbsTargetG;
  final Value<double> fatTargetG;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isSynced;
  final Value<int> rowid;
  const LocalProfilesCompanion({
    this.id = const Value.absent(),
    this.gender = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.currentWeightKg = const Value.absent(),
    this.activityLevel = const Value.absent(),
    this.goal = const Value.absent(),
    this.calorieTarget = const Value.absent(),
    this.proteinTargetG = const Value.absent(),
    this.carbsTargetG = const Value.absent(),
    this.fatTargetG = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalProfilesCompanion.insert({
    required String id,
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
    required DateTime createdAt,
    required DateTime updatedAt,
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       gender = Value(gender),
       birthDate = Value(birthDate),
       heightCm = Value(heightCm),
       currentWeightKg = Value(currentWeightKg),
       activityLevel = Value(activityLevel),
       goal = Value(goal),
       calorieTarget = Value(calorieTarget),
       proteinTargetG = Value(proteinTargetG),
       carbsTargetG = Value(carbsTargetG),
       fatTargetG = Value(fatTargetG),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<LocalProfile> custom({
    Expression<String>? id,
    Expression<String>? gender,
    Expression<DateTime>? birthDate,
    Expression<double>? heightCm,
    Expression<double>? currentWeightKg,
    Expression<double>? activityLevel,
    Expression<String>? goal,
    Expression<int>? calorieTarget,
    Expression<double>? proteinTargetG,
    Expression<double>? carbsTargetG,
    Expression<double>? fatTargetG,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isSynced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (gender != null) 'gender': gender,
      if (birthDate != null) 'birth_date': birthDate,
      if (heightCm != null) 'height_cm': heightCm,
      if (currentWeightKg != null) 'current_weight_kg': currentWeightKg,
      if (activityLevel != null) 'activity_level': activityLevel,
      if (goal != null) 'goal': goal,
      if (calorieTarget != null) 'calorie_target': calorieTarget,
      if (proteinTargetG != null) 'protein_target_g': proteinTargetG,
      if (carbsTargetG != null) 'carbs_target_g': carbsTargetG,
      if (fatTargetG != null) 'fat_target_g': fatTargetG,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalProfilesCompanion copyWith({
    Value<String>? id,
    Value<String>? gender,
    Value<DateTime>? birthDate,
    Value<double>? heightCm,
    Value<double>? currentWeightKg,
    Value<double>? activityLevel,
    Value<String>? goal,
    Value<int>? calorieTarget,
    Value<double>? proteinTargetG,
    Value<double>? carbsTargetG,
    Value<double>? fatTargetG,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? isSynced,
    Value<int>? rowid,
  }) {
    return LocalProfilesCompanion(
      id: id ?? this.id,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      heightCm: heightCm ?? this.heightCm,
      currentWeightKg: currentWeightKg ?? this.currentWeightKg,
      activityLevel: activityLevel ?? this.activityLevel,
      goal: goal ?? this.goal,
      calorieTarget: calorieTarget ?? this.calorieTarget,
      proteinTargetG: proteinTargetG ?? this.proteinTargetG,
      carbsTargetG: carbsTargetG ?? this.carbsTargetG,
      fatTargetG: fatTargetG ?? this.fatTargetG,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (birthDate.present) {
      map['birth_date'] = Variable<DateTime>(birthDate.value);
    }
    if (heightCm.present) {
      map['height_cm'] = Variable<double>(heightCm.value);
    }
    if (currentWeightKg.present) {
      map['current_weight_kg'] = Variable<double>(currentWeightKg.value);
    }
    if (activityLevel.present) {
      map['activity_level'] = Variable<double>(activityLevel.value);
    }
    if (goal.present) {
      map['goal'] = Variable<String>(goal.value);
    }
    if (calorieTarget.present) {
      map['calorie_target'] = Variable<int>(calorieTarget.value);
    }
    if (proteinTargetG.present) {
      map['protein_target_g'] = Variable<double>(proteinTargetG.value);
    }
    if (carbsTargetG.present) {
      map['carbs_target_g'] = Variable<double>(carbsTargetG.value);
    }
    if (fatTargetG.present) {
      map['fat_target_g'] = Variable<double>(fatTargetG.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalProfilesCompanion(')
          ..write('id: $id, ')
          ..write('gender: $gender, ')
          ..write('birthDate: $birthDate, ')
          ..write('heightCm: $heightCm, ')
          ..write('currentWeightKg: $currentWeightKg, ')
          ..write('activityLevel: $activityLevel, ')
          ..write('goal: $goal, ')
          ..write('calorieTarget: $calorieTarget, ')
          ..write('proteinTargetG: $proteinTargetG, ')
          ..write('carbsTargetG: $carbsTargetG, ')
          ..write('fatTargetG: $fatTargetG, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalFoodsTable extends LocalFoods
    with TableInfo<$LocalFoodsTable, LocalFood> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalFoodsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _barcodeMeta = const VerificationMeta(
    'barcode',
  );
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
    'barcode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _servingSizeGMeta = const VerificationMeta(
    'servingSizeG',
  );
  @override
  late final GeneratedColumn<double> servingSizeG = GeneratedColumn<double>(
    'serving_size_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(100.0),
  );
  static const VerificationMeta _caloriesPerServingMeta =
      const VerificationMeta('caloriesPerServing');
  @override
  late final GeneratedColumn<double> caloriesPerServing =
      GeneratedColumn<double>(
        'calories_per_serving',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _proteinGMeta = const VerificationMeta(
    'proteinG',
  );
  @override
  late final GeneratedColumn<double> proteinG = GeneratedColumn<double>(
    'protein_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _carbsGMeta = const VerificationMeta('carbsG');
  @override
  late final GeneratedColumn<double> carbsG = GeneratedColumn<double>(
    'carbs_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _fatGMeta = const VerificationMeta('fatG');
  @override
  late final GeneratedColumn<double> fatG = GeneratedColumn<double>(
    'fat_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _isVerifiedMeta = const VerificationMeta(
    'isVerified',
  );
  @override
  late final GeneratedColumn<bool> isVerified = GeneratedColumn<bool>(
    'is_verified',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_verified" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    name,
    barcode,
    servingSizeG,
    caloriesPerServing,
    proteinG,
    carbsG,
    fatG,
    isVerified,
    createdAt,
    isSynced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_foods';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalFood> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('barcode')) {
      context.handle(
        _barcodeMeta,
        barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta),
      );
    }
    if (data.containsKey('serving_size_g')) {
      context.handle(
        _servingSizeGMeta,
        servingSizeG.isAcceptableOrUnknown(
          data['serving_size_g']!,
          _servingSizeGMeta,
        ),
      );
    }
    if (data.containsKey('calories_per_serving')) {
      context.handle(
        _caloriesPerServingMeta,
        caloriesPerServing.isAcceptableOrUnknown(
          data['calories_per_serving']!,
          _caloriesPerServingMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_caloriesPerServingMeta);
    }
    if (data.containsKey('protein_g')) {
      context.handle(
        _proteinGMeta,
        proteinG.isAcceptableOrUnknown(data['protein_g']!, _proteinGMeta),
      );
    }
    if (data.containsKey('carbs_g')) {
      context.handle(
        _carbsGMeta,
        carbsG.isAcceptableOrUnknown(data['carbs_g']!, _carbsGMeta),
      );
    }
    if (data.containsKey('fat_g')) {
      context.handle(
        _fatGMeta,
        fatG.isAcceptableOrUnknown(data['fat_g']!, _fatGMeta),
      );
    }
    if (data.containsKey('is_verified')) {
      context.handle(
        _isVerifiedMeta,
        isVerified.isAcceptableOrUnknown(data['is_verified']!, _isVerifiedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalFood map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalFood(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      barcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}barcode'],
      ),
      servingSizeG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}serving_size_g'],
      )!,
      caloriesPerServing: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}calories_per_serving'],
      )!,
      proteinG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}protein_g'],
      )!,
      carbsG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carbs_g'],
      )!,
      fatG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fat_g'],
      )!,
      isVerified: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_verified'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
    );
  }

  @override
  $LocalFoodsTable createAlias(String alias) {
    return $LocalFoodsTable(attachedDatabase, alias);
  }
}

class LocalFood extends DataClass implements Insertable<LocalFood> {
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
  final bool isSynced;
  const LocalFood({
    required this.id,
    this.userId,
    required this.name,
    this.barcode,
    required this.servingSizeG,
    required this.caloriesPerServing,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.isVerified,
    required this.createdAt,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    map['serving_size_g'] = Variable<double>(servingSizeG);
    map['calories_per_serving'] = Variable<double>(caloriesPerServing);
    map['protein_g'] = Variable<double>(proteinG);
    map['carbs_g'] = Variable<double>(carbsG);
    map['fat_g'] = Variable<double>(fatG);
    map['is_verified'] = Variable<bool>(isVerified);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  LocalFoodsCompanion toCompanion(bool nullToAbsent) {
    return LocalFoodsCompanion(
      id: Value(id),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      name: Value(name),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      servingSizeG: Value(servingSizeG),
      caloriesPerServing: Value(caloriesPerServing),
      proteinG: Value(proteinG),
      carbsG: Value(carbsG),
      fatG: Value(fatG),
      isVerified: Value(isVerified),
      createdAt: Value(createdAt),
      isSynced: Value(isSynced),
    );
  }

  factory LocalFood.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalFood(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String?>(json['userId']),
      name: serializer.fromJson<String>(json['name']),
      barcode: serializer.fromJson<String?>(json['barcode']),
      servingSizeG: serializer.fromJson<double>(json['servingSizeG']),
      caloriesPerServing: serializer.fromJson<double>(
        json['caloriesPerServing'],
      ),
      proteinG: serializer.fromJson<double>(json['proteinG']),
      carbsG: serializer.fromJson<double>(json['carbsG']),
      fatG: serializer.fromJson<double>(json['fatG']),
      isVerified: serializer.fromJson<bool>(json['isVerified']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String?>(userId),
      'name': serializer.toJson<String>(name),
      'barcode': serializer.toJson<String?>(barcode),
      'servingSizeG': serializer.toJson<double>(servingSizeG),
      'caloriesPerServing': serializer.toJson<double>(caloriesPerServing),
      'proteinG': serializer.toJson<double>(proteinG),
      'carbsG': serializer.toJson<double>(carbsG),
      'fatG': serializer.toJson<double>(fatG),
      'isVerified': serializer.toJson<bool>(isVerified),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  LocalFood copyWith({
    String? id,
    Value<String?> userId = const Value.absent(),
    String? name,
    Value<String?> barcode = const Value.absent(),
    double? servingSizeG,
    double? caloriesPerServing,
    double? proteinG,
    double? carbsG,
    double? fatG,
    bool? isVerified,
    DateTime? createdAt,
    bool? isSynced,
  }) => LocalFood(
    id: id ?? this.id,
    userId: userId.present ? userId.value : this.userId,
    name: name ?? this.name,
    barcode: barcode.present ? barcode.value : this.barcode,
    servingSizeG: servingSizeG ?? this.servingSizeG,
    caloriesPerServing: caloriesPerServing ?? this.caloriesPerServing,
    proteinG: proteinG ?? this.proteinG,
    carbsG: carbsG ?? this.carbsG,
    fatG: fatG ?? this.fatG,
    isVerified: isVerified ?? this.isVerified,
    createdAt: createdAt ?? this.createdAt,
    isSynced: isSynced ?? this.isSynced,
  );
  LocalFood copyWithCompanion(LocalFoodsCompanion data) {
    return LocalFood(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      name: data.name.present ? data.name.value : this.name,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      servingSizeG: data.servingSizeG.present
          ? data.servingSizeG.value
          : this.servingSizeG,
      caloriesPerServing: data.caloriesPerServing.present
          ? data.caloriesPerServing.value
          : this.caloriesPerServing,
      proteinG: data.proteinG.present ? data.proteinG.value : this.proteinG,
      carbsG: data.carbsG.present ? data.carbsG.value : this.carbsG,
      fatG: data.fatG.present ? data.fatG.value : this.fatG,
      isVerified: data.isVerified.present
          ? data.isVerified.value
          : this.isVerified,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalFood(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('barcode: $barcode, ')
          ..write('servingSizeG: $servingSizeG, ')
          ..write('caloriesPerServing: $caloriesPerServing, ')
          ..write('proteinG: $proteinG, ')
          ..write('carbsG: $carbsG, ')
          ..write('fatG: $fatG, ')
          ..write('isVerified: $isVerified, ')
          ..write('createdAt: $createdAt, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    name,
    barcode,
    servingSizeG,
    caloriesPerServing,
    proteinG,
    carbsG,
    fatG,
    isVerified,
    createdAt,
    isSynced,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalFood &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.name == this.name &&
          other.barcode == this.barcode &&
          other.servingSizeG == this.servingSizeG &&
          other.caloriesPerServing == this.caloriesPerServing &&
          other.proteinG == this.proteinG &&
          other.carbsG == this.carbsG &&
          other.fatG == this.fatG &&
          other.isVerified == this.isVerified &&
          other.createdAt == this.createdAt &&
          other.isSynced == this.isSynced);
}

class LocalFoodsCompanion extends UpdateCompanion<LocalFood> {
  final Value<String> id;
  final Value<String?> userId;
  final Value<String> name;
  final Value<String?> barcode;
  final Value<double> servingSizeG;
  final Value<double> caloriesPerServing;
  final Value<double> proteinG;
  final Value<double> carbsG;
  final Value<double> fatG;
  final Value<bool> isVerified;
  final Value<DateTime> createdAt;
  final Value<bool> isSynced;
  final Value<int> rowid;
  const LocalFoodsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.name = const Value.absent(),
    this.barcode = const Value.absent(),
    this.servingSizeG = const Value.absent(),
    this.caloriesPerServing = const Value.absent(),
    this.proteinG = const Value.absent(),
    this.carbsG = const Value.absent(),
    this.fatG = const Value.absent(),
    this.isVerified = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalFoodsCompanion.insert({
    required String id,
    this.userId = const Value.absent(),
    required String name,
    this.barcode = const Value.absent(),
    this.servingSizeG = const Value.absent(),
    required double caloriesPerServing,
    this.proteinG = const Value.absent(),
    this.carbsG = const Value.absent(),
    this.fatG = const Value.absent(),
    this.isVerified = const Value.absent(),
    required DateTime createdAt,
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       caloriesPerServing = Value(caloriesPerServing),
       createdAt = Value(createdAt);
  static Insertable<LocalFood> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? name,
    Expression<String>? barcode,
    Expression<double>? servingSizeG,
    Expression<double>? caloriesPerServing,
    Expression<double>? proteinG,
    Expression<double>? carbsG,
    Expression<double>? fatG,
    Expression<bool>? isVerified,
    Expression<DateTime>? createdAt,
    Expression<bool>? isSynced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (name != null) 'name': name,
      if (barcode != null) 'barcode': barcode,
      if (servingSizeG != null) 'serving_size_g': servingSizeG,
      if (caloriesPerServing != null)
        'calories_per_serving': caloriesPerServing,
      if (proteinG != null) 'protein_g': proteinG,
      if (carbsG != null) 'carbs_g': carbsG,
      if (fatG != null) 'fat_g': fatG,
      if (isVerified != null) 'is_verified': isVerified,
      if (createdAt != null) 'created_at': createdAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalFoodsCompanion copyWith({
    Value<String>? id,
    Value<String?>? userId,
    Value<String>? name,
    Value<String?>? barcode,
    Value<double>? servingSizeG,
    Value<double>? caloriesPerServing,
    Value<double>? proteinG,
    Value<double>? carbsG,
    Value<double>? fatG,
    Value<bool>? isVerified,
    Value<DateTime>? createdAt,
    Value<bool>? isSynced,
    Value<int>? rowid,
  }) {
    return LocalFoodsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      barcode: barcode ?? this.barcode,
      servingSizeG: servingSizeG ?? this.servingSizeG,
      caloriesPerServing: caloriesPerServing ?? this.caloriesPerServing,
      proteinG: proteinG ?? this.proteinG,
      carbsG: carbsG ?? this.carbsG,
      fatG: fatG ?? this.fatG,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      isSynced: isSynced ?? this.isSynced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (servingSizeG.present) {
      map['serving_size_g'] = Variable<double>(servingSizeG.value);
    }
    if (caloriesPerServing.present) {
      map['calories_per_serving'] = Variable<double>(caloriesPerServing.value);
    }
    if (proteinG.present) {
      map['protein_g'] = Variable<double>(proteinG.value);
    }
    if (carbsG.present) {
      map['carbs_g'] = Variable<double>(carbsG.value);
    }
    if (fatG.present) {
      map['fat_g'] = Variable<double>(fatG.value);
    }
    if (isVerified.present) {
      map['is_verified'] = Variable<bool>(isVerified.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalFoodsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('barcode: $barcode, ')
          ..write('servingSizeG: $servingSizeG, ')
          ..write('caloriesPerServing: $caloriesPerServing, ')
          ..write('proteinG: $proteinG, ')
          ..write('carbsG: $carbsG, ')
          ..write('fatG: $fatG, ')
          ..write('isVerified: $isVerified, ')
          ..write('createdAt: $createdAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalMealLogsTable extends LocalMealLogs
    with TableInfo<$LocalMealLogsTable, LocalMealLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalMealLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _foodIdMeta = const VerificationMeta('foodId');
  @override
  late final GeneratedColumn<String> foodId = GeneratedColumn<String>(
    'food_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _foodNameMeta = const VerificationMeta(
    'foodName',
  );
  @override
  late final GeneratedColumn<String> foodName = GeneratedColumn<String>(
    'food_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mealTypeMeta = const VerificationMeta(
    'mealType',
  );
  @override
  late final GeneratedColumn<String> mealType = GeneratedColumn<String>(
    'meal_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _servingQuantityMeta = const VerificationMeta(
    'servingQuantity',
  );
  @override
  late final GeneratedColumn<double> servingQuantity = GeneratedColumn<double>(
    'serving_quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1.0),
  );
  static const VerificationMeta _totalCaloriesMeta = const VerificationMeta(
    'totalCalories',
  );
  @override
  late final GeneratedColumn<double> totalCalories = GeneratedColumn<double>(
    'total_calories',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalProteinGMeta = const VerificationMeta(
    'totalProteinG',
  );
  @override
  late final GeneratedColumn<double> totalProteinG = GeneratedColumn<double>(
    'total_protein_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalCarbsGMeta = const VerificationMeta(
    'totalCarbsG',
  );
  @override
  late final GeneratedColumn<double> totalCarbsG = GeneratedColumn<double>(
    'total_carbs_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalFatGMeta = const VerificationMeta(
    'totalFatG',
  );
  @override
  late final GeneratedColumn<double> totalFatG = GeneratedColumn<double>(
    'total_fat_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _loggedDateMeta = const VerificationMeta(
    'loggedDate',
  );
  @override
  late final GeneratedColumn<DateTime> loggedDate = GeneratedColumn<DateTime>(
    'logged_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    foodId,
    foodName,
    mealType,
    servingQuantity,
    totalCalories,
    totalProteinG,
    totalCarbsG,
    totalFatG,
    loggedDate,
    createdAt,
    isSynced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_meal_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalMealLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('food_id')) {
      context.handle(
        _foodIdMeta,
        foodId.isAcceptableOrUnknown(data['food_id']!, _foodIdMeta),
      );
    } else if (isInserting) {
      context.missing(_foodIdMeta);
    }
    if (data.containsKey('food_name')) {
      context.handle(
        _foodNameMeta,
        foodName.isAcceptableOrUnknown(data['food_name']!, _foodNameMeta),
      );
    } else if (isInserting) {
      context.missing(_foodNameMeta);
    }
    if (data.containsKey('meal_type')) {
      context.handle(
        _mealTypeMeta,
        mealType.isAcceptableOrUnknown(data['meal_type']!, _mealTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_mealTypeMeta);
    }
    if (data.containsKey('serving_quantity')) {
      context.handle(
        _servingQuantityMeta,
        servingQuantity.isAcceptableOrUnknown(
          data['serving_quantity']!,
          _servingQuantityMeta,
        ),
      );
    }
    if (data.containsKey('total_calories')) {
      context.handle(
        _totalCaloriesMeta,
        totalCalories.isAcceptableOrUnknown(
          data['total_calories']!,
          _totalCaloriesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalCaloriesMeta);
    }
    if (data.containsKey('total_protein_g')) {
      context.handle(
        _totalProteinGMeta,
        totalProteinG.isAcceptableOrUnknown(
          data['total_protein_g']!,
          _totalProteinGMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalProteinGMeta);
    }
    if (data.containsKey('total_carbs_g')) {
      context.handle(
        _totalCarbsGMeta,
        totalCarbsG.isAcceptableOrUnknown(
          data['total_carbs_g']!,
          _totalCarbsGMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalCarbsGMeta);
    }
    if (data.containsKey('total_fat_g')) {
      context.handle(
        _totalFatGMeta,
        totalFatG.isAcceptableOrUnknown(data['total_fat_g']!, _totalFatGMeta),
      );
    } else if (isInserting) {
      context.missing(_totalFatGMeta);
    }
    if (data.containsKey('logged_date')) {
      context.handle(
        _loggedDateMeta,
        loggedDate.isAcceptableOrUnknown(data['logged_date']!, _loggedDateMeta),
      );
    } else if (isInserting) {
      context.missing(_loggedDateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalMealLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalMealLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      foodId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}food_id'],
      )!,
      foodName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}food_name'],
      )!,
      mealType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meal_type'],
      )!,
      servingQuantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}serving_quantity'],
      )!,
      totalCalories: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_calories'],
      )!,
      totalProteinG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_protein_g'],
      )!,
      totalCarbsG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_carbs_g'],
      )!,
      totalFatG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_fat_g'],
      )!,
      loggedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}logged_date'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
    );
  }

  @override
  $LocalMealLogsTable createAlias(String alias) {
    return $LocalMealLogsTable(attachedDatabase, alias);
  }
}

class LocalMealLog extends DataClass implements Insertable<LocalMealLog> {
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
  final bool isSynced;
  const LocalMealLog({
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
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['food_id'] = Variable<String>(foodId);
    map['food_name'] = Variable<String>(foodName);
    map['meal_type'] = Variable<String>(mealType);
    map['serving_quantity'] = Variable<double>(servingQuantity);
    map['total_calories'] = Variable<double>(totalCalories);
    map['total_protein_g'] = Variable<double>(totalProteinG);
    map['total_carbs_g'] = Variable<double>(totalCarbsG);
    map['total_fat_g'] = Variable<double>(totalFatG);
    map['logged_date'] = Variable<DateTime>(loggedDate);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  LocalMealLogsCompanion toCompanion(bool nullToAbsent) {
    return LocalMealLogsCompanion(
      id: Value(id),
      userId: Value(userId),
      foodId: Value(foodId),
      foodName: Value(foodName),
      mealType: Value(mealType),
      servingQuantity: Value(servingQuantity),
      totalCalories: Value(totalCalories),
      totalProteinG: Value(totalProteinG),
      totalCarbsG: Value(totalCarbsG),
      totalFatG: Value(totalFatG),
      loggedDate: Value(loggedDate),
      createdAt: Value(createdAt),
      isSynced: Value(isSynced),
    );
  }

  factory LocalMealLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalMealLog(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      foodId: serializer.fromJson<String>(json['foodId']),
      foodName: serializer.fromJson<String>(json['foodName']),
      mealType: serializer.fromJson<String>(json['mealType']),
      servingQuantity: serializer.fromJson<double>(json['servingQuantity']),
      totalCalories: serializer.fromJson<double>(json['totalCalories']),
      totalProteinG: serializer.fromJson<double>(json['totalProteinG']),
      totalCarbsG: serializer.fromJson<double>(json['totalCarbsG']),
      totalFatG: serializer.fromJson<double>(json['totalFatG']),
      loggedDate: serializer.fromJson<DateTime>(json['loggedDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'foodId': serializer.toJson<String>(foodId),
      'foodName': serializer.toJson<String>(foodName),
      'mealType': serializer.toJson<String>(mealType),
      'servingQuantity': serializer.toJson<double>(servingQuantity),
      'totalCalories': serializer.toJson<double>(totalCalories),
      'totalProteinG': serializer.toJson<double>(totalProteinG),
      'totalCarbsG': serializer.toJson<double>(totalCarbsG),
      'totalFatG': serializer.toJson<double>(totalFatG),
      'loggedDate': serializer.toJson<DateTime>(loggedDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  LocalMealLog copyWith({
    String? id,
    String? userId,
    String? foodId,
    String? foodName,
    String? mealType,
    double? servingQuantity,
    double? totalCalories,
    double? totalProteinG,
    double? totalCarbsG,
    double? totalFatG,
    DateTime? loggedDate,
    DateTime? createdAt,
    bool? isSynced,
  }) => LocalMealLog(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    foodId: foodId ?? this.foodId,
    foodName: foodName ?? this.foodName,
    mealType: mealType ?? this.mealType,
    servingQuantity: servingQuantity ?? this.servingQuantity,
    totalCalories: totalCalories ?? this.totalCalories,
    totalProteinG: totalProteinG ?? this.totalProteinG,
    totalCarbsG: totalCarbsG ?? this.totalCarbsG,
    totalFatG: totalFatG ?? this.totalFatG,
    loggedDate: loggedDate ?? this.loggedDate,
    createdAt: createdAt ?? this.createdAt,
    isSynced: isSynced ?? this.isSynced,
  );
  LocalMealLog copyWithCompanion(LocalMealLogsCompanion data) {
    return LocalMealLog(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      foodId: data.foodId.present ? data.foodId.value : this.foodId,
      foodName: data.foodName.present ? data.foodName.value : this.foodName,
      mealType: data.mealType.present ? data.mealType.value : this.mealType,
      servingQuantity: data.servingQuantity.present
          ? data.servingQuantity.value
          : this.servingQuantity,
      totalCalories: data.totalCalories.present
          ? data.totalCalories.value
          : this.totalCalories,
      totalProteinG: data.totalProteinG.present
          ? data.totalProteinG.value
          : this.totalProteinG,
      totalCarbsG: data.totalCarbsG.present
          ? data.totalCarbsG.value
          : this.totalCarbsG,
      totalFatG: data.totalFatG.present ? data.totalFatG.value : this.totalFatG,
      loggedDate: data.loggedDate.present
          ? data.loggedDate.value
          : this.loggedDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalMealLog(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('foodId: $foodId, ')
          ..write('foodName: $foodName, ')
          ..write('mealType: $mealType, ')
          ..write('servingQuantity: $servingQuantity, ')
          ..write('totalCalories: $totalCalories, ')
          ..write('totalProteinG: $totalProteinG, ')
          ..write('totalCarbsG: $totalCarbsG, ')
          ..write('totalFatG: $totalFatG, ')
          ..write('loggedDate: $loggedDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    foodId,
    foodName,
    mealType,
    servingQuantity,
    totalCalories,
    totalProteinG,
    totalCarbsG,
    totalFatG,
    loggedDate,
    createdAt,
    isSynced,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalMealLog &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.foodId == this.foodId &&
          other.foodName == this.foodName &&
          other.mealType == this.mealType &&
          other.servingQuantity == this.servingQuantity &&
          other.totalCalories == this.totalCalories &&
          other.totalProteinG == this.totalProteinG &&
          other.totalCarbsG == this.totalCarbsG &&
          other.totalFatG == this.totalFatG &&
          other.loggedDate == this.loggedDate &&
          other.createdAt == this.createdAt &&
          other.isSynced == this.isSynced);
}

class LocalMealLogsCompanion extends UpdateCompanion<LocalMealLog> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> foodId;
  final Value<String> foodName;
  final Value<String> mealType;
  final Value<double> servingQuantity;
  final Value<double> totalCalories;
  final Value<double> totalProteinG;
  final Value<double> totalCarbsG;
  final Value<double> totalFatG;
  final Value<DateTime> loggedDate;
  final Value<DateTime> createdAt;
  final Value<bool> isSynced;
  final Value<int> rowid;
  const LocalMealLogsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.foodId = const Value.absent(),
    this.foodName = const Value.absent(),
    this.mealType = const Value.absent(),
    this.servingQuantity = const Value.absent(),
    this.totalCalories = const Value.absent(),
    this.totalProteinG = const Value.absent(),
    this.totalCarbsG = const Value.absent(),
    this.totalFatG = const Value.absent(),
    this.loggedDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalMealLogsCompanion.insert({
    required String id,
    required String userId,
    required String foodId,
    required String foodName,
    required String mealType,
    this.servingQuantity = const Value.absent(),
    required double totalCalories,
    required double totalProteinG,
    required double totalCarbsG,
    required double totalFatG,
    required DateTime loggedDate,
    required DateTime createdAt,
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       foodId = Value(foodId),
       foodName = Value(foodName),
       mealType = Value(mealType),
       totalCalories = Value(totalCalories),
       totalProteinG = Value(totalProteinG),
       totalCarbsG = Value(totalCarbsG),
       totalFatG = Value(totalFatG),
       loggedDate = Value(loggedDate),
       createdAt = Value(createdAt);
  static Insertable<LocalMealLog> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? foodId,
    Expression<String>? foodName,
    Expression<String>? mealType,
    Expression<double>? servingQuantity,
    Expression<double>? totalCalories,
    Expression<double>? totalProteinG,
    Expression<double>? totalCarbsG,
    Expression<double>? totalFatG,
    Expression<DateTime>? loggedDate,
    Expression<DateTime>? createdAt,
    Expression<bool>? isSynced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (foodId != null) 'food_id': foodId,
      if (foodName != null) 'food_name': foodName,
      if (mealType != null) 'meal_type': mealType,
      if (servingQuantity != null) 'serving_quantity': servingQuantity,
      if (totalCalories != null) 'total_calories': totalCalories,
      if (totalProteinG != null) 'total_protein_g': totalProteinG,
      if (totalCarbsG != null) 'total_carbs_g': totalCarbsG,
      if (totalFatG != null) 'total_fat_g': totalFatG,
      if (loggedDate != null) 'logged_date': loggedDate,
      if (createdAt != null) 'created_at': createdAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalMealLogsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? foodId,
    Value<String>? foodName,
    Value<String>? mealType,
    Value<double>? servingQuantity,
    Value<double>? totalCalories,
    Value<double>? totalProteinG,
    Value<double>? totalCarbsG,
    Value<double>? totalFatG,
    Value<DateTime>? loggedDate,
    Value<DateTime>? createdAt,
    Value<bool>? isSynced,
    Value<int>? rowid,
  }) {
    return LocalMealLogsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      foodId: foodId ?? this.foodId,
      foodName: foodName ?? this.foodName,
      mealType: mealType ?? this.mealType,
      servingQuantity: servingQuantity ?? this.servingQuantity,
      totalCalories: totalCalories ?? this.totalCalories,
      totalProteinG: totalProteinG ?? this.totalProteinG,
      totalCarbsG: totalCarbsG ?? this.totalCarbsG,
      totalFatG: totalFatG ?? this.totalFatG,
      loggedDate: loggedDate ?? this.loggedDate,
      createdAt: createdAt ?? this.createdAt,
      isSynced: isSynced ?? this.isSynced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (foodId.present) {
      map['food_id'] = Variable<String>(foodId.value);
    }
    if (foodName.present) {
      map['food_name'] = Variable<String>(foodName.value);
    }
    if (mealType.present) {
      map['meal_type'] = Variable<String>(mealType.value);
    }
    if (servingQuantity.present) {
      map['serving_quantity'] = Variable<double>(servingQuantity.value);
    }
    if (totalCalories.present) {
      map['total_calories'] = Variable<double>(totalCalories.value);
    }
    if (totalProteinG.present) {
      map['total_protein_g'] = Variable<double>(totalProteinG.value);
    }
    if (totalCarbsG.present) {
      map['total_carbs_g'] = Variable<double>(totalCarbsG.value);
    }
    if (totalFatG.present) {
      map['total_fat_g'] = Variable<double>(totalFatG.value);
    }
    if (loggedDate.present) {
      map['logged_date'] = Variable<DateTime>(loggedDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalMealLogsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('foodId: $foodId, ')
          ..write('foodName: $foodName, ')
          ..write('mealType: $mealType, ')
          ..write('servingQuantity: $servingQuantity, ')
          ..write('totalCalories: $totalCalories, ')
          ..write('totalProteinG: $totalProteinG, ')
          ..write('totalCarbsG: $totalCarbsG, ')
          ..write('totalFatG: $totalFatG, ')
          ..write('loggedDate: $loggedDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalWeightLogsTable extends LocalWeightLogs
    with TableInfo<$LocalWeightLogsTable, LocalWeightLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalWeightLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _loggedDateMeta = const VerificationMeta(
    'loggedDate',
  );
  @override
  late final GeneratedColumn<DateTime> loggedDate = GeneratedColumn<DateTime>(
    'logged_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    weightKg,
    loggedDate,
    notes,
    createdAt,
    isSynced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_weight_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalWeightLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    } else if (isInserting) {
      context.missing(_weightKgMeta);
    }
    if (data.containsKey('logged_date')) {
      context.handle(
        _loggedDateMeta,
        loggedDate.isAcceptableOrUnknown(data['logged_date']!, _loggedDateMeta),
      );
    } else if (isInserting) {
      context.missing(_loggedDateMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalWeightLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalWeightLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      )!,
      loggedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}logged_date'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
    );
  }

  @override
  $LocalWeightLogsTable createAlias(String alias) {
    return $LocalWeightLogsTable(attachedDatabase, alias);
  }
}

class LocalWeightLog extends DataClass implements Insertable<LocalWeightLog> {
  final String id;
  final String userId;
  final double weightKg;
  final DateTime loggedDate;
  final String? notes;
  final DateTime createdAt;
  final bool isSynced;
  const LocalWeightLog({
    required this.id,
    required this.userId,
    required this.weightKg,
    required this.loggedDate,
    this.notes,
    required this.createdAt,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['weight_kg'] = Variable<double>(weightKg);
    map['logged_date'] = Variable<DateTime>(loggedDate);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  LocalWeightLogsCompanion toCompanion(bool nullToAbsent) {
    return LocalWeightLogsCompanion(
      id: Value(id),
      userId: Value(userId),
      weightKg: Value(weightKg),
      loggedDate: Value(loggedDate),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      isSynced: Value(isSynced),
    );
  }

  factory LocalWeightLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalWeightLog(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      weightKg: serializer.fromJson<double>(json['weightKg']),
      loggedDate: serializer.fromJson<DateTime>(json['loggedDate']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'weightKg': serializer.toJson<double>(weightKg),
      'loggedDate': serializer.toJson<DateTime>(loggedDate),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  LocalWeightLog copyWith({
    String? id,
    String? userId,
    double? weightKg,
    DateTime? loggedDate,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    bool? isSynced,
  }) => LocalWeightLog(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    weightKg: weightKg ?? this.weightKg,
    loggedDate: loggedDate ?? this.loggedDate,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    isSynced: isSynced ?? this.isSynced,
  );
  LocalWeightLog copyWithCompanion(LocalWeightLogsCompanion data) {
    return LocalWeightLog(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      loggedDate: data.loggedDate.present
          ? data.loggedDate.value
          : this.loggedDate,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalWeightLog(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('weightKg: $weightKg, ')
          ..write('loggedDate: $loggedDate, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, weightKg, loggedDate, notes, createdAt, isSynced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalWeightLog &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.weightKg == this.weightKg &&
          other.loggedDate == this.loggedDate &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.isSynced == this.isSynced);
}

class LocalWeightLogsCompanion extends UpdateCompanion<LocalWeightLog> {
  final Value<String> id;
  final Value<String> userId;
  final Value<double> weightKg;
  final Value<DateTime> loggedDate;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<bool> isSynced;
  final Value<int> rowid;
  const LocalWeightLogsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.loggedDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalWeightLogsCompanion.insert({
    required String id,
    required String userId,
    required double weightKg,
    required DateTime loggedDate,
    this.notes = const Value.absent(),
    required DateTime createdAt,
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       weightKg = Value(weightKg),
       loggedDate = Value(loggedDate),
       createdAt = Value(createdAt);
  static Insertable<LocalWeightLog> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<double>? weightKg,
    Expression<DateTime>? loggedDate,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<bool>? isSynced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (weightKg != null) 'weight_kg': weightKg,
      if (loggedDate != null) 'logged_date': loggedDate,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalWeightLogsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<double>? weightKg,
    Value<DateTime>? loggedDate,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<bool>? isSynced,
    Value<int>? rowid,
  }) {
    return LocalWeightLogsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      weightKg: weightKg ?? this.weightKg,
      loggedDate: loggedDate ?? this.loggedDate,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      isSynced: isSynced ?? this.isSynced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (loggedDate.present) {
      map['logged_date'] = Variable<DateTime>(loggedDate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalWeightLogsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('weightKg: $weightKg, ')
          ..write('loggedDate: $loggedDate, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LocalProfilesTable localProfiles = $LocalProfilesTable(this);
  late final $LocalFoodsTable localFoods = $LocalFoodsTable(this);
  late final $LocalMealLogsTable localMealLogs = $LocalMealLogsTable(this);
  late final $LocalWeightLogsTable localWeightLogs = $LocalWeightLogsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    localProfiles,
    localFoods,
    localMealLogs,
    localWeightLogs,
  ];
}

typedef $$LocalProfilesTableCreateCompanionBuilder =
    LocalProfilesCompanion Function({
      required String id,
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
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<bool> isSynced,
      Value<int> rowid,
    });
typedef $$LocalProfilesTableUpdateCompanionBuilder =
    LocalProfilesCompanion Function({
      Value<String> id,
      Value<String> gender,
      Value<DateTime> birthDate,
      Value<double> heightCm,
      Value<double> currentWeightKg,
      Value<double> activityLevel,
      Value<String> goal,
      Value<int> calorieTarget,
      Value<double> proteinTargetG,
      Value<double> carbsTargetG,
      Value<double> fatTargetG,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
      Value<int> rowid,
    });

class $$LocalProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalProfilesTable> {
  $$LocalProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get currentWeightKg => $composableBuilder(
    column: $table.currentWeightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get activityLevel => $composableBuilder(
    column: $table.activityLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get goal => $composableBuilder(
    column: $table.goal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get calorieTarget => $composableBuilder(
    column: $table.calorieTarget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get proteinTargetG => $composableBuilder(
    column: $table.proteinTargetG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carbsTargetG => $composableBuilder(
    column: $table.carbsTargetG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fatTargetG => $composableBuilder(
    column: $table.fatTargetG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalProfilesTable> {
  $$LocalProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get currentWeightKg => $composableBuilder(
    column: $table.currentWeightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get activityLevel => $composableBuilder(
    column: $table.activityLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goal => $composableBuilder(
    column: $table.goal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get calorieTarget => $composableBuilder(
    column: $table.calorieTarget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get proteinTargetG => $composableBuilder(
    column: $table.proteinTargetG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carbsTargetG => $composableBuilder(
    column: $table.carbsTargetG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fatTargetG => $composableBuilder(
    column: $table.fatTargetG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalProfilesTable> {
  $$LocalProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<DateTime> get birthDate =>
      $composableBuilder(column: $table.birthDate, builder: (column) => column);

  GeneratedColumn<double> get heightCm =>
      $composableBuilder(column: $table.heightCm, builder: (column) => column);

  GeneratedColumn<double> get currentWeightKg => $composableBuilder(
    column: $table.currentWeightKg,
    builder: (column) => column,
  );

  GeneratedColumn<double> get activityLevel => $composableBuilder(
    column: $table.activityLevel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get goal =>
      $composableBuilder(column: $table.goal, builder: (column) => column);

  GeneratedColumn<int> get calorieTarget => $composableBuilder(
    column: $table.calorieTarget,
    builder: (column) => column,
  );

  GeneratedColumn<double> get proteinTargetG => $composableBuilder(
    column: $table.proteinTargetG,
    builder: (column) => column,
  );

  GeneratedColumn<double> get carbsTargetG => $composableBuilder(
    column: $table.carbsTargetG,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fatTargetG => $composableBuilder(
    column: $table.fatTargetG,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);
}

class $$LocalProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalProfilesTable,
          LocalProfile,
          $$LocalProfilesTableFilterComposer,
          $$LocalProfilesTableOrderingComposer,
          $$LocalProfilesTableAnnotationComposer,
          $$LocalProfilesTableCreateCompanionBuilder,
          $$LocalProfilesTableUpdateCompanionBuilder,
          (
            LocalProfile,
            BaseReferences<_$AppDatabase, $LocalProfilesTable, LocalProfile>,
          ),
          LocalProfile,
          PrefetchHooks Function()
        > {
  $$LocalProfilesTableTableManager(_$AppDatabase db, $LocalProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> gender = const Value.absent(),
                Value<DateTime> birthDate = const Value.absent(),
                Value<double> heightCm = const Value.absent(),
                Value<double> currentWeightKg = const Value.absent(),
                Value<double> activityLevel = const Value.absent(),
                Value<String> goal = const Value.absent(),
                Value<int> calorieTarget = const Value.absent(),
                Value<double> proteinTargetG = const Value.absent(),
                Value<double> carbsTargetG = const Value.absent(),
                Value<double> fatTargetG = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalProfilesCompanion(
                id: id,
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
                createdAt: createdAt,
                updatedAt: updatedAt,
                isSynced: isSynced,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
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
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalProfilesCompanion.insert(
                id: id,
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
                createdAt: createdAt,
                updatedAt: updatedAt,
                isSynced: isSynced,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocalProfilesTable, LocalProfile>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $LocalProfilesTable,
                    LocalProfile
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalProfilesTable,
      LocalProfile,
      $$LocalProfilesTableFilterComposer,
      $$LocalProfilesTableOrderingComposer,
      $$LocalProfilesTableAnnotationComposer,
      $$LocalProfilesTableCreateCompanionBuilder,
      $$LocalProfilesTableUpdateCompanionBuilder,
      (
        LocalProfile,
        BaseReferences<_$AppDatabase, $LocalProfilesTable, LocalProfile>,
      ),
      LocalProfile,
      PrefetchHooks Function()
    >;
typedef $$LocalFoodsTableCreateCompanionBuilder =
    LocalFoodsCompanion Function({
      required String id,
      Value<String?> userId,
      required String name,
      Value<String?> barcode,
      Value<double> servingSizeG,
      required double caloriesPerServing,
      Value<double> proteinG,
      Value<double> carbsG,
      Value<double> fatG,
      Value<bool> isVerified,
      required DateTime createdAt,
      Value<bool> isSynced,
      Value<int> rowid,
    });
typedef $$LocalFoodsTableUpdateCompanionBuilder =
    LocalFoodsCompanion Function({
      Value<String> id,
      Value<String?> userId,
      Value<String> name,
      Value<String?> barcode,
      Value<double> servingSizeG,
      Value<double> caloriesPerServing,
      Value<double> proteinG,
      Value<double> carbsG,
      Value<double> fatG,
      Value<bool> isVerified,
      Value<DateTime> createdAt,
      Value<bool> isSynced,
      Value<int> rowid,
    });

class $$LocalFoodsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalFoodsTable> {
  $$LocalFoodsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get servingSizeG => $composableBuilder(
    column: $table.servingSizeG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get caloriesPerServing => $composableBuilder(
    column: $table.caloriesPerServing,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get proteinG => $composableBuilder(
    column: $table.proteinG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carbsG => $composableBuilder(
    column: $table.carbsG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fatG => $composableBuilder(
    column: $table.fatG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isVerified => $composableBuilder(
    column: $table.isVerified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalFoodsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalFoodsTable> {
  $$LocalFoodsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get servingSizeG => $composableBuilder(
    column: $table.servingSizeG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get caloriesPerServing => $composableBuilder(
    column: $table.caloriesPerServing,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get proteinG => $composableBuilder(
    column: $table.proteinG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carbsG => $composableBuilder(
    column: $table.carbsG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fatG => $composableBuilder(
    column: $table.fatG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isVerified => $composableBuilder(
    column: $table.isVerified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalFoodsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalFoodsTable> {
  $$LocalFoodsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<double> get servingSizeG => $composableBuilder(
    column: $table.servingSizeG,
    builder: (column) => column,
  );

  GeneratedColumn<double> get caloriesPerServing => $composableBuilder(
    column: $table.caloriesPerServing,
    builder: (column) => column,
  );

  GeneratedColumn<double> get proteinG =>
      $composableBuilder(column: $table.proteinG, builder: (column) => column);

  GeneratedColumn<double> get carbsG =>
      $composableBuilder(column: $table.carbsG, builder: (column) => column);

  GeneratedColumn<double> get fatG =>
      $composableBuilder(column: $table.fatG, builder: (column) => column);

  GeneratedColumn<bool> get isVerified => $composableBuilder(
    column: $table.isVerified,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);
}

class $$LocalFoodsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalFoodsTable,
          LocalFood,
          $$LocalFoodsTableFilterComposer,
          $$LocalFoodsTableOrderingComposer,
          $$LocalFoodsTableAnnotationComposer,
          $$LocalFoodsTableCreateCompanionBuilder,
          $$LocalFoodsTableUpdateCompanionBuilder,
          (
            LocalFood,
            BaseReferences<_$AppDatabase, $LocalFoodsTable, LocalFood>,
          ),
          LocalFood,
          PrefetchHooks Function()
        > {
  $$LocalFoodsTableTableManager(_$AppDatabase db, $LocalFoodsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalFoodsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalFoodsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalFoodsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> barcode = const Value.absent(),
                Value<double> servingSizeG = const Value.absent(),
                Value<double> caloriesPerServing = const Value.absent(),
                Value<double> proteinG = const Value.absent(),
                Value<double> carbsG = const Value.absent(),
                Value<double> fatG = const Value.absent(),
                Value<bool> isVerified = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalFoodsCompanion(
                id: id,
                userId: userId,
                name: name,
                barcode: barcode,
                servingSizeG: servingSizeG,
                caloriesPerServing: caloriesPerServing,
                proteinG: proteinG,
                carbsG: carbsG,
                fatG: fatG,
                isVerified: isVerified,
                createdAt: createdAt,
                isSynced: isSynced,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> userId = const Value.absent(),
                required String name,
                Value<String?> barcode = const Value.absent(),
                Value<double> servingSizeG = const Value.absent(),
                required double caloriesPerServing,
                Value<double> proteinG = const Value.absent(),
                Value<double> carbsG = const Value.absent(),
                Value<double> fatG = const Value.absent(),
                Value<bool> isVerified = const Value.absent(),
                required DateTime createdAt,
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalFoodsCompanion.insert(
                id: id,
                userId: userId,
                name: name,
                barcode: barcode,
                servingSizeG: servingSizeG,
                caloriesPerServing: caloriesPerServing,
                proteinG: proteinG,
                carbsG: carbsG,
                fatG: fatG,
                isVerified: isVerified,
                createdAt: createdAt,
                isSynced: isSynced,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocalFoodsTable, LocalFood>(table),
                  BaseReferences<_$AppDatabase, $LocalFoodsTable, LocalFood>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalFoodsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalFoodsTable,
      LocalFood,
      $$LocalFoodsTableFilterComposer,
      $$LocalFoodsTableOrderingComposer,
      $$LocalFoodsTableAnnotationComposer,
      $$LocalFoodsTableCreateCompanionBuilder,
      $$LocalFoodsTableUpdateCompanionBuilder,
      (LocalFood, BaseReferences<_$AppDatabase, $LocalFoodsTable, LocalFood>),
      LocalFood,
      PrefetchHooks Function()
    >;
typedef $$LocalMealLogsTableCreateCompanionBuilder =
    LocalMealLogsCompanion Function({
      required String id,
      required String userId,
      required String foodId,
      required String foodName,
      required String mealType,
      Value<double> servingQuantity,
      required double totalCalories,
      required double totalProteinG,
      required double totalCarbsG,
      required double totalFatG,
      required DateTime loggedDate,
      required DateTime createdAt,
      Value<bool> isSynced,
      Value<int> rowid,
    });
typedef $$LocalMealLogsTableUpdateCompanionBuilder =
    LocalMealLogsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> foodId,
      Value<String> foodName,
      Value<String> mealType,
      Value<double> servingQuantity,
      Value<double> totalCalories,
      Value<double> totalProteinG,
      Value<double> totalCarbsG,
      Value<double> totalFatG,
      Value<DateTime> loggedDate,
      Value<DateTime> createdAt,
      Value<bool> isSynced,
      Value<int> rowid,
    });

class $$LocalMealLogsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalMealLogsTable> {
  $$LocalMealLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get foodId => $composableBuilder(
    column: $table.foodId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get foodName => $composableBuilder(
    column: $table.foodName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mealType => $composableBuilder(
    column: $table.mealType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get servingQuantity => $composableBuilder(
    column: $table.servingQuantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalCalories => $composableBuilder(
    column: $table.totalCalories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalProteinG => $composableBuilder(
    column: $table.totalProteinG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalCarbsG => $composableBuilder(
    column: $table.totalCarbsG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalFatG => $composableBuilder(
    column: $table.totalFatG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get loggedDate => $composableBuilder(
    column: $table.loggedDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalMealLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalMealLogsTable> {
  $$LocalMealLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get foodId => $composableBuilder(
    column: $table.foodId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get foodName => $composableBuilder(
    column: $table.foodName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mealType => $composableBuilder(
    column: $table.mealType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get servingQuantity => $composableBuilder(
    column: $table.servingQuantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalCalories => $composableBuilder(
    column: $table.totalCalories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalProteinG => $composableBuilder(
    column: $table.totalProteinG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalCarbsG => $composableBuilder(
    column: $table.totalCarbsG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalFatG => $composableBuilder(
    column: $table.totalFatG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get loggedDate => $composableBuilder(
    column: $table.loggedDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalMealLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalMealLogsTable> {
  $$LocalMealLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get foodId =>
      $composableBuilder(column: $table.foodId, builder: (column) => column);

  GeneratedColumn<String> get foodName =>
      $composableBuilder(column: $table.foodName, builder: (column) => column);

  GeneratedColumn<String> get mealType =>
      $composableBuilder(column: $table.mealType, builder: (column) => column);

  GeneratedColumn<double> get servingQuantity => $composableBuilder(
    column: $table.servingQuantity,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalCalories => $composableBuilder(
    column: $table.totalCalories,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalProteinG => $composableBuilder(
    column: $table.totalProteinG,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalCarbsG => $composableBuilder(
    column: $table.totalCarbsG,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalFatG =>
      $composableBuilder(column: $table.totalFatG, builder: (column) => column);

  GeneratedColumn<DateTime> get loggedDate => $composableBuilder(
    column: $table.loggedDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);
}

class $$LocalMealLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalMealLogsTable,
          LocalMealLog,
          $$LocalMealLogsTableFilterComposer,
          $$LocalMealLogsTableOrderingComposer,
          $$LocalMealLogsTableAnnotationComposer,
          $$LocalMealLogsTableCreateCompanionBuilder,
          $$LocalMealLogsTableUpdateCompanionBuilder,
          (
            LocalMealLog,
            BaseReferences<_$AppDatabase, $LocalMealLogsTable, LocalMealLog>,
          ),
          LocalMealLog,
          PrefetchHooks Function()
        > {
  $$LocalMealLogsTableTableManager(_$AppDatabase db, $LocalMealLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalMealLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalMealLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalMealLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> foodId = const Value.absent(),
                Value<String> foodName = const Value.absent(),
                Value<String> mealType = const Value.absent(),
                Value<double> servingQuantity = const Value.absent(),
                Value<double> totalCalories = const Value.absent(),
                Value<double> totalProteinG = const Value.absent(),
                Value<double> totalCarbsG = const Value.absent(),
                Value<double> totalFatG = const Value.absent(),
                Value<DateTime> loggedDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalMealLogsCompanion(
                id: id,
                userId: userId,
                foodId: foodId,
                foodName: foodName,
                mealType: mealType,
                servingQuantity: servingQuantity,
                totalCalories: totalCalories,
                totalProteinG: totalProteinG,
                totalCarbsG: totalCarbsG,
                totalFatG: totalFatG,
                loggedDate: loggedDate,
                createdAt: createdAt,
                isSynced: isSynced,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String foodId,
                required String foodName,
                required String mealType,
                Value<double> servingQuantity = const Value.absent(),
                required double totalCalories,
                required double totalProteinG,
                required double totalCarbsG,
                required double totalFatG,
                required DateTime loggedDate,
                required DateTime createdAt,
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalMealLogsCompanion.insert(
                id: id,
                userId: userId,
                foodId: foodId,
                foodName: foodName,
                mealType: mealType,
                servingQuantity: servingQuantity,
                totalCalories: totalCalories,
                totalProteinG: totalProteinG,
                totalCarbsG: totalCarbsG,
                totalFatG: totalFatG,
                loggedDate: loggedDate,
                createdAt: createdAt,
                isSynced: isSynced,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocalMealLogsTable, LocalMealLog>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $LocalMealLogsTable,
                    LocalMealLog
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalMealLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalMealLogsTable,
      LocalMealLog,
      $$LocalMealLogsTableFilterComposer,
      $$LocalMealLogsTableOrderingComposer,
      $$LocalMealLogsTableAnnotationComposer,
      $$LocalMealLogsTableCreateCompanionBuilder,
      $$LocalMealLogsTableUpdateCompanionBuilder,
      (
        LocalMealLog,
        BaseReferences<_$AppDatabase, $LocalMealLogsTable, LocalMealLog>,
      ),
      LocalMealLog,
      PrefetchHooks Function()
    >;
typedef $$LocalWeightLogsTableCreateCompanionBuilder =
    LocalWeightLogsCompanion Function({
      required String id,
      required String userId,
      required double weightKg,
      required DateTime loggedDate,
      Value<String?> notes,
      required DateTime createdAt,
      Value<bool> isSynced,
      Value<int> rowid,
    });
typedef $$LocalWeightLogsTableUpdateCompanionBuilder =
    LocalWeightLogsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<double> weightKg,
      Value<DateTime> loggedDate,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<bool> isSynced,
      Value<int> rowid,
    });

class $$LocalWeightLogsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalWeightLogsTable> {
  $$LocalWeightLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get loggedDate => $composableBuilder(
    column: $table.loggedDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalWeightLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalWeightLogsTable> {
  $$LocalWeightLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get loggedDate => $composableBuilder(
    column: $table.loggedDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalWeightLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalWeightLogsTable> {
  $$LocalWeightLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<DateTime> get loggedDate => $composableBuilder(
    column: $table.loggedDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);
}

class $$LocalWeightLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalWeightLogsTable,
          LocalWeightLog,
          $$LocalWeightLogsTableFilterComposer,
          $$LocalWeightLogsTableOrderingComposer,
          $$LocalWeightLogsTableAnnotationComposer,
          $$LocalWeightLogsTableCreateCompanionBuilder,
          $$LocalWeightLogsTableUpdateCompanionBuilder,
          (
            LocalWeightLog,
            BaseReferences<
              _$AppDatabase,
              $LocalWeightLogsTable,
              LocalWeightLog
            >,
          ),
          LocalWeightLog,
          PrefetchHooks Function()
        > {
  $$LocalWeightLogsTableTableManager(
    _$AppDatabase db,
    $LocalWeightLogsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalWeightLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalWeightLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalWeightLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<double> weightKg = const Value.absent(),
                Value<DateTime> loggedDate = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalWeightLogsCompanion(
                id: id,
                userId: userId,
                weightKg: weightKg,
                loggedDate: loggedDate,
                notes: notes,
                createdAt: createdAt,
                isSynced: isSynced,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required double weightKg,
                required DateTime loggedDate,
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalWeightLogsCompanion.insert(
                id: id,
                userId: userId,
                weightKg: weightKg,
                loggedDate: loggedDate,
                notes: notes,
                createdAt: createdAt,
                isSynced: isSynced,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocalWeightLogsTable, LocalWeightLog>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $LocalWeightLogsTable,
                    LocalWeightLog
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalWeightLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalWeightLogsTable,
      LocalWeightLog,
      $$LocalWeightLogsTableFilterComposer,
      $$LocalWeightLogsTableOrderingComposer,
      $$LocalWeightLogsTableAnnotationComposer,
      $$LocalWeightLogsTableCreateCompanionBuilder,
      $$LocalWeightLogsTableUpdateCompanionBuilder,
      (
        LocalWeightLog,
        BaseReferences<_$AppDatabase, $LocalWeightLogsTable, LocalWeightLog>,
      ),
      LocalWeightLog,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LocalProfilesTableTableManager get localProfiles =>
      $$LocalProfilesTableTableManager(_db, _db.localProfiles);
  $$LocalFoodsTableTableManager get localFoods =>
      $$LocalFoodsTableTableManager(_db, _db.localFoods);
  $$LocalMealLogsTableTableManager get localMealLogs =>
      $$LocalMealLogsTableTableManager(_db, _db.localMealLogs);
  $$LocalWeightLogsTableTableManager get localWeightLogs =>
      $$LocalWeightLogsTableTableManager(_db, _db.localWeightLogs);
}
