// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $StoredRecipesTable extends StoredRecipes
    with TableInfo<$StoredRecipesTable, StoredRecipe> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoredRecipesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imagePreviewPathMeta = const VerificationMeta(
    'imagePreviewPath',
  );
  @override
  late final GeneratedColumn<String> imagePreviewPath = GeneratedColumn<String>(
    'image_preview_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _preparationTimeMeta = const VerificationMeta(
    'preparationTime',
  );
  @override
  late final GeneratedColumn<double> preparationTime = GeneratedColumn<double>(
    'preparation_time',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cookingTimeMeta = const VerificationMeta(
    'cookingTime',
  );
  @override
  late final GeneratedColumn<double> cookingTime = GeneratedColumn<double>(
    'cooking_time',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalTimeMeta = const VerificationMeta(
    'totalTime',
  );
  @override
  late final GeneratedColumn<double> totalTime = GeneratedColumn<double>(
    'total_time',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _servingsMeta = const VerificationMeta(
    'servings',
  );
  @override
  late final GeneratedColumn<double> servings = GeneratedColumn<double>(
    'servings',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _servingNameMeta = const VerificationMeta(
    'servingName',
  );
  @override
  late final GeneratedColumn<String> servingName = GeneratedColumn<String>(
    'serving_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _vegetableMeta = const VerificationMeta(
    'vegetable',
  );
  @override
  late final GeneratedColumn<String> vegetable = GeneratedColumn<String>(
    'vegetable',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _effortMeta = const VerificationMeta('effort');
  @override
  late final GeneratedColumn<int> effort = GeneratedColumn<int>(
    'effort',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastModifiedMeta = const VerificationMeta(
    'lastModified',
  );
  @override
  late final GeneratedColumn<String> lastModified = GeneratedColumn<String>(
    'last_modified',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<int> rating = GeneratedColumn<int>(
    'rating',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hasStepTitlesMeta = const VerificationMeta(
    'hasStepTitles',
  );
  @override
  late final GeneratedColumn<bool> hasStepTitles = GeneratedColumn<bool>(
    'has_step_titles',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_step_titles" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    imagePath,
    imagePreviewPath,
    preparationTime,
    cookingTime,
    totalTime,
    servings,
    servingName,
    vegetable,
    notes,
    isFavorite,
    effort,
    lastModified,
    rating,
    source,
    hasStepTitles,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stored_recipes';
  @override
  VerificationContext validateIntegrity(
    Insertable<StoredRecipe> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    } else if (isInserting) {
      context.missing(_imagePathMeta);
    }
    if (data.containsKey('image_preview_path')) {
      context.handle(
        _imagePreviewPathMeta,
        imagePreviewPath.isAcceptableOrUnknown(
          data['image_preview_path']!,
          _imagePreviewPathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_imagePreviewPathMeta);
    }
    if (data.containsKey('preparation_time')) {
      context.handle(
        _preparationTimeMeta,
        preparationTime.isAcceptableOrUnknown(
          data['preparation_time']!,
          _preparationTimeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_preparationTimeMeta);
    }
    if (data.containsKey('cooking_time')) {
      context.handle(
        _cookingTimeMeta,
        cookingTime.isAcceptableOrUnknown(
          data['cooking_time']!,
          _cookingTimeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_cookingTimeMeta);
    }
    if (data.containsKey('total_time')) {
      context.handle(
        _totalTimeMeta,
        totalTime.isAcceptableOrUnknown(data['total_time']!, _totalTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_totalTimeMeta);
    }
    if (data.containsKey('servings')) {
      context.handle(
        _servingsMeta,
        servings.isAcceptableOrUnknown(data['servings']!, _servingsMeta),
      );
    }
    if (data.containsKey('serving_name')) {
      context.handle(
        _servingNameMeta,
        servingName.isAcceptableOrUnknown(
          data['serving_name']!,
          _servingNameMeta,
        ),
      );
    }
    if (data.containsKey('vegetable')) {
      context.handle(
        _vegetableMeta,
        vegetable.isAcceptableOrUnknown(data['vegetable']!, _vegetableMeta),
      );
    } else if (isInserting) {
      context.missing(_vegetableMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    } else if (isInserting) {
      context.missing(_notesMeta);
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    if (data.containsKey('effort')) {
      context.handle(
        _effortMeta,
        effort.isAcceptableOrUnknown(data['effort']!, _effortMeta),
      );
    }
    if (data.containsKey('last_modified')) {
      context.handle(
        _lastModifiedMeta,
        lastModified.isAcceptableOrUnknown(
          data['last_modified']!,
          _lastModifiedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastModifiedMeta);
    }
    if (data.containsKey('rating')) {
      context.handle(
        _ratingMeta,
        rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('has_step_titles')) {
      context.handle(
        _hasStepTitlesMeta,
        hasStepTitles.isAcceptableOrUnknown(
          data['has_step_titles']!,
          _hasStepTitlesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_hasStepTitlesMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StoredRecipe map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoredRecipe(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      )!,
      imagePreviewPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_preview_path'],
      )!,
      preparationTime: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}preparation_time'],
      )!,
      cookingTime: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cooking_time'],
      )!,
      totalTime: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_time'],
      )!,
      servings: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}servings'],
      ),
      servingName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}serving_name'],
      ),
      vegetable: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vegetable'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
      effort: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}effort'],
      ),
      lastModified: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_modified'],
      )!,
      rating: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rating'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      ),
      hasStepTitles: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_step_titles'],
      )!,
    );
  }

  @override
  $StoredRecipesTable createAlias(String alias) {
    return $StoredRecipesTable(attachedDatabase, alias);
  }
}

class StoredRecipe extends DataClass implements Insertable<StoredRecipe> {
  final int id;
  final String name;
  final String imagePath;
  final String imagePreviewPath;
  final double preparationTime;
  final double cookingTime;
  final double totalTime;
  final double? servings;
  final String? servingName;
  final String vegetable;
  final String notes;
  final bool isFavorite;
  final int? effort;
  final String lastModified;
  final int? rating;
  final String? source;
  final bool hasStepTitles;
  const StoredRecipe({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.imagePreviewPath,
    required this.preparationTime,
    required this.cookingTime,
    required this.totalTime,
    this.servings,
    this.servingName,
    required this.vegetable,
    required this.notes,
    required this.isFavorite,
    this.effort,
    required this.lastModified,
    this.rating,
    this.source,
    required this.hasStepTitles,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['image_path'] = Variable<String>(imagePath);
    map['image_preview_path'] = Variable<String>(imagePreviewPath);
    map['preparation_time'] = Variable<double>(preparationTime);
    map['cooking_time'] = Variable<double>(cookingTime);
    map['total_time'] = Variable<double>(totalTime);
    if (!nullToAbsent || servings != null) {
      map['servings'] = Variable<double>(servings);
    }
    if (!nullToAbsent || servingName != null) {
      map['serving_name'] = Variable<String>(servingName);
    }
    map['vegetable'] = Variable<String>(vegetable);
    map['notes'] = Variable<String>(notes);
    map['is_favorite'] = Variable<bool>(isFavorite);
    if (!nullToAbsent || effort != null) {
      map['effort'] = Variable<int>(effort);
    }
    map['last_modified'] = Variable<String>(lastModified);
    if (!nullToAbsent || rating != null) {
      map['rating'] = Variable<int>(rating);
    }
    if (!nullToAbsent || source != null) {
      map['source'] = Variable<String>(source);
    }
    map['has_step_titles'] = Variable<bool>(hasStepTitles);
    return map;
  }

  StoredRecipesCompanion toCompanion(bool nullToAbsent) {
    return StoredRecipesCompanion(
      id: Value(id),
      name: Value(name),
      imagePath: Value(imagePath),
      imagePreviewPath: Value(imagePreviewPath),
      preparationTime: Value(preparationTime),
      cookingTime: Value(cookingTime),
      totalTime: Value(totalTime),
      servings: servings == null && nullToAbsent
          ? const Value.absent()
          : Value(servings),
      servingName: servingName == null && nullToAbsent
          ? const Value.absent()
          : Value(servingName),
      vegetable: Value(vegetable),
      notes: Value(notes),
      isFavorite: Value(isFavorite),
      effort: effort == null && nullToAbsent
          ? const Value.absent()
          : Value(effort),
      lastModified: Value(lastModified),
      rating: rating == null && nullToAbsent
          ? const Value.absent()
          : Value(rating),
      source: source == null && nullToAbsent
          ? const Value.absent()
          : Value(source),
      hasStepTitles: Value(hasStepTitles),
    );
  }

  factory StoredRecipe.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoredRecipe(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      imagePath: serializer.fromJson<String>(json['imagePath']),
      imagePreviewPath: serializer.fromJson<String>(json['imagePreviewPath']),
      preparationTime: serializer.fromJson<double>(json['preparationTime']),
      cookingTime: serializer.fromJson<double>(json['cookingTime']),
      totalTime: serializer.fromJson<double>(json['totalTime']),
      servings: serializer.fromJson<double?>(json['servings']),
      servingName: serializer.fromJson<String?>(json['servingName']),
      vegetable: serializer.fromJson<String>(json['vegetable']),
      notes: serializer.fromJson<String>(json['notes']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      effort: serializer.fromJson<int?>(json['effort']),
      lastModified: serializer.fromJson<String>(json['lastModified']),
      rating: serializer.fromJson<int?>(json['rating']),
      source: serializer.fromJson<String?>(json['source']),
      hasStepTitles: serializer.fromJson<bool>(json['hasStepTitles']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'imagePath': serializer.toJson<String>(imagePath),
      'imagePreviewPath': serializer.toJson<String>(imagePreviewPath),
      'preparationTime': serializer.toJson<double>(preparationTime),
      'cookingTime': serializer.toJson<double>(cookingTime),
      'totalTime': serializer.toJson<double>(totalTime),
      'servings': serializer.toJson<double?>(servings),
      'servingName': serializer.toJson<String?>(servingName),
      'vegetable': serializer.toJson<String>(vegetable),
      'notes': serializer.toJson<String>(notes),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'effort': serializer.toJson<int?>(effort),
      'lastModified': serializer.toJson<String>(lastModified),
      'rating': serializer.toJson<int?>(rating),
      'source': serializer.toJson<String?>(source),
      'hasStepTitles': serializer.toJson<bool>(hasStepTitles),
    };
  }

  StoredRecipe copyWith({
    int? id,
    String? name,
    String? imagePath,
    String? imagePreviewPath,
    double? preparationTime,
    double? cookingTime,
    double? totalTime,
    Value<double?> servings = const Value.absent(),
    Value<String?> servingName = const Value.absent(),
    String? vegetable,
    String? notes,
    bool? isFavorite,
    Value<int?> effort = const Value.absent(),
    String? lastModified,
    Value<int?> rating = const Value.absent(),
    Value<String?> source = const Value.absent(),
    bool? hasStepTitles,
  }) => StoredRecipe(
    id: id ?? this.id,
    name: name ?? this.name,
    imagePath: imagePath ?? this.imagePath,
    imagePreviewPath: imagePreviewPath ?? this.imagePreviewPath,
    preparationTime: preparationTime ?? this.preparationTime,
    cookingTime: cookingTime ?? this.cookingTime,
    totalTime: totalTime ?? this.totalTime,
    servings: servings.present ? servings.value : this.servings,
    servingName: servingName.present ? servingName.value : this.servingName,
    vegetable: vegetable ?? this.vegetable,
    notes: notes ?? this.notes,
    isFavorite: isFavorite ?? this.isFavorite,
    effort: effort.present ? effort.value : this.effort,
    lastModified: lastModified ?? this.lastModified,
    rating: rating.present ? rating.value : this.rating,
    source: source.present ? source.value : this.source,
    hasStepTitles: hasStepTitles ?? this.hasStepTitles,
  );
  StoredRecipe copyWithCompanion(StoredRecipesCompanion data) {
    return StoredRecipe(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      imagePreviewPath: data.imagePreviewPath.present
          ? data.imagePreviewPath.value
          : this.imagePreviewPath,
      preparationTime: data.preparationTime.present
          ? data.preparationTime.value
          : this.preparationTime,
      cookingTime: data.cookingTime.present
          ? data.cookingTime.value
          : this.cookingTime,
      totalTime: data.totalTime.present ? data.totalTime.value : this.totalTime,
      servings: data.servings.present ? data.servings.value : this.servings,
      servingName: data.servingName.present
          ? data.servingName.value
          : this.servingName,
      vegetable: data.vegetable.present ? data.vegetable.value : this.vegetable,
      notes: data.notes.present ? data.notes.value : this.notes,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
      effort: data.effort.present ? data.effort.value : this.effort,
      lastModified: data.lastModified.present
          ? data.lastModified.value
          : this.lastModified,
      rating: data.rating.present ? data.rating.value : this.rating,
      source: data.source.present ? data.source.value : this.source,
      hasStepTitles: data.hasStepTitles.present
          ? data.hasStepTitles.value
          : this.hasStepTitles,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoredRecipe(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('imagePath: $imagePath, ')
          ..write('imagePreviewPath: $imagePreviewPath, ')
          ..write('preparationTime: $preparationTime, ')
          ..write('cookingTime: $cookingTime, ')
          ..write('totalTime: $totalTime, ')
          ..write('servings: $servings, ')
          ..write('servingName: $servingName, ')
          ..write('vegetable: $vegetable, ')
          ..write('notes: $notes, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('effort: $effort, ')
          ..write('lastModified: $lastModified, ')
          ..write('rating: $rating, ')
          ..write('source: $source, ')
          ..write('hasStepTitles: $hasStepTitles')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    imagePath,
    imagePreviewPath,
    preparationTime,
    cookingTime,
    totalTime,
    servings,
    servingName,
    vegetable,
    notes,
    isFavorite,
    effort,
    lastModified,
    rating,
    source,
    hasStepTitles,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoredRecipe &&
          other.id == this.id &&
          other.name == this.name &&
          other.imagePath == this.imagePath &&
          other.imagePreviewPath == this.imagePreviewPath &&
          other.preparationTime == this.preparationTime &&
          other.cookingTime == this.cookingTime &&
          other.totalTime == this.totalTime &&
          other.servings == this.servings &&
          other.servingName == this.servingName &&
          other.vegetable == this.vegetable &&
          other.notes == this.notes &&
          other.isFavorite == this.isFavorite &&
          other.effort == this.effort &&
          other.lastModified == this.lastModified &&
          other.rating == this.rating &&
          other.source == this.source &&
          other.hasStepTitles == this.hasStepTitles);
}

class StoredRecipesCompanion extends UpdateCompanion<StoredRecipe> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> imagePath;
  final Value<String> imagePreviewPath;
  final Value<double> preparationTime;
  final Value<double> cookingTime;
  final Value<double> totalTime;
  final Value<double?> servings;
  final Value<String?> servingName;
  final Value<String> vegetable;
  final Value<String> notes;
  final Value<bool> isFavorite;
  final Value<int?> effort;
  final Value<String> lastModified;
  final Value<int?> rating;
  final Value<String?> source;
  final Value<bool> hasStepTitles;
  const StoredRecipesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.imagePreviewPath = const Value.absent(),
    this.preparationTime = const Value.absent(),
    this.cookingTime = const Value.absent(),
    this.totalTime = const Value.absent(),
    this.servings = const Value.absent(),
    this.servingName = const Value.absent(),
    this.vegetable = const Value.absent(),
    this.notes = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.effort = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.rating = const Value.absent(),
    this.source = const Value.absent(),
    this.hasStepTitles = const Value.absent(),
  });
  StoredRecipesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String imagePath,
    required String imagePreviewPath,
    required double preparationTime,
    required double cookingTime,
    required double totalTime,
    this.servings = const Value.absent(),
    this.servingName = const Value.absent(),
    required String vegetable,
    required String notes,
    this.isFavorite = const Value.absent(),
    this.effort = const Value.absent(),
    required String lastModified,
    this.rating = const Value.absent(),
    this.source = const Value.absent(),
    required bool hasStepTitles,
  }) : name = Value(name),
       imagePath = Value(imagePath),
       imagePreviewPath = Value(imagePreviewPath),
       preparationTime = Value(preparationTime),
       cookingTime = Value(cookingTime),
       totalTime = Value(totalTime),
       vegetable = Value(vegetable),
       notes = Value(notes),
       lastModified = Value(lastModified),
       hasStepTitles = Value(hasStepTitles);
  static Insertable<StoredRecipe> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? imagePath,
    Expression<String>? imagePreviewPath,
    Expression<double>? preparationTime,
    Expression<double>? cookingTime,
    Expression<double>? totalTime,
    Expression<double>? servings,
    Expression<String>? servingName,
    Expression<String>? vegetable,
    Expression<String>? notes,
    Expression<bool>? isFavorite,
    Expression<int>? effort,
    Expression<String>? lastModified,
    Expression<int>? rating,
    Expression<String>? source,
    Expression<bool>? hasStepTitles,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (imagePath != null) 'image_path': imagePath,
      if (imagePreviewPath != null) 'image_preview_path': imagePreviewPath,
      if (preparationTime != null) 'preparation_time': preparationTime,
      if (cookingTime != null) 'cooking_time': cookingTime,
      if (totalTime != null) 'total_time': totalTime,
      if (servings != null) 'servings': servings,
      if (servingName != null) 'serving_name': servingName,
      if (vegetable != null) 'vegetable': vegetable,
      if (notes != null) 'notes': notes,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (effort != null) 'effort': effort,
      if (lastModified != null) 'last_modified': lastModified,
      if (rating != null) 'rating': rating,
      if (source != null) 'source': source,
      if (hasStepTitles != null) 'has_step_titles': hasStepTitles,
    });
  }

  StoredRecipesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? imagePath,
    Value<String>? imagePreviewPath,
    Value<double>? preparationTime,
    Value<double>? cookingTime,
    Value<double>? totalTime,
    Value<double?>? servings,
    Value<String?>? servingName,
    Value<String>? vegetable,
    Value<String>? notes,
    Value<bool>? isFavorite,
    Value<int?>? effort,
    Value<String>? lastModified,
    Value<int?>? rating,
    Value<String?>? source,
    Value<bool>? hasStepTitles,
  }) {
    return StoredRecipesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      imagePreviewPath: imagePreviewPath ?? this.imagePreviewPath,
      preparationTime: preparationTime ?? this.preparationTime,
      cookingTime: cookingTime ?? this.cookingTime,
      totalTime: totalTime ?? this.totalTime,
      servings: servings ?? this.servings,
      servingName: servingName ?? this.servingName,
      vegetable: vegetable ?? this.vegetable,
      notes: notes ?? this.notes,
      isFavorite: isFavorite ?? this.isFavorite,
      effort: effort ?? this.effort,
      lastModified: lastModified ?? this.lastModified,
      rating: rating ?? this.rating,
      source: source ?? this.source,
      hasStepTitles: hasStepTitles ?? this.hasStepTitles,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (imagePreviewPath.present) {
      map['image_preview_path'] = Variable<String>(imagePreviewPath.value);
    }
    if (preparationTime.present) {
      map['preparation_time'] = Variable<double>(preparationTime.value);
    }
    if (cookingTime.present) {
      map['cooking_time'] = Variable<double>(cookingTime.value);
    }
    if (totalTime.present) {
      map['total_time'] = Variable<double>(totalTime.value);
    }
    if (servings.present) {
      map['servings'] = Variable<double>(servings.value);
    }
    if (servingName.present) {
      map['serving_name'] = Variable<String>(servingName.value);
    }
    if (vegetable.present) {
      map['vegetable'] = Variable<String>(vegetable.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (effort.present) {
      map['effort'] = Variable<int>(effort.value);
    }
    if (lastModified.present) {
      map['last_modified'] = Variable<String>(lastModified.value);
    }
    if (rating.present) {
      map['rating'] = Variable<int>(rating.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (hasStepTitles.present) {
      map['has_step_titles'] = Variable<bool>(hasStepTitles.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoredRecipesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('imagePath: $imagePath, ')
          ..write('imagePreviewPath: $imagePreviewPath, ')
          ..write('preparationTime: $preparationTime, ')
          ..write('cookingTime: $cookingTime, ')
          ..write('totalTime: $totalTime, ')
          ..write('servings: $servings, ')
          ..write('servingName: $servingName, ')
          ..write('vegetable: $vegetable, ')
          ..write('notes: $notes, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('effort: $effort, ')
          ..write('lastModified: $lastModified, ')
          ..write('rating: $rating, ')
          ..write('source: $source, ')
          ..write('hasStepTitles: $hasStepTitles')
          ..write(')'))
        .toString();
  }
}

class $StoredCategoriesTable extends StoredCategories
    with TableInfo<$StoredCategoriesTable, StoredCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoredCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortKindMeta = const VerificationMeta(
    'sortKind',
  );
  @override
  late final GeneratedColumn<String> sortKind = GeneratedColumn<String>(
    'sort_kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ascendingMeta = const VerificationMeta(
    'ascending',
  );
  @override
  late final GeneratedColumn<bool> ascending = GeneratedColumn<bool>(
    'ascending',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("ascending" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _isSystemMeta = const VerificationMeta(
    'isSystem',
  );
  @override
  late final GeneratedColumn<bool> isSystem = GeneratedColumn<bool>(
    'is_system',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_system" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    position,
    sortKind,
    ascending,
    isSystem,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stored_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<StoredCategory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('sort_kind')) {
      context.handle(
        _sortKindMeta,
        sortKind.isAcceptableOrUnknown(data['sort_kind']!, _sortKindMeta),
      );
    } else if (isInserting) {
      context.missing(_sortKindMeta);
    }
    if (data.containsKey('ascending')) {
      context.handle(
        _ascendingMeta,
        ascending.isAcceptableOrUnknown(data['ascending']!, _ascendingMeta),
      );
    }
    if (data.containsKey('is_system')) {
      context.handle(
        _isSystemMeta,
        isSystem.isAcceptableOrUnknown(data['is_system']!, _isSystemMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StoredCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoredCategory(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      sortKind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sort_kind'],
      )!,
      ascending: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}ascending'],
      )!,
      isSystem: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_system'],
      )!,
    );
  }

  @override
  $StoredCategoriesTable createAlias(String alias) {
    return $StoredCategoriesTable(attachedDatabase, alias);
  }
}

class StoredCategory extends DataClass implements Insertable<StoredCategory> {
  final int id;
  final String name;
  final int position;
  final String sortKind;
  final bool ascending;
  final bool isSystem;
  const StoredCategory({
    required this.id,
    required this.name,
    required this.position,
    required this.sortKind,
    required this.ascending,
    required this.isSystem,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['position'] = Variable<int>(position);
    map['sort_kind'] = Variable<String>(sortKind);
    map['ascending'] = Variable<bool>(ascending);
    map['is_system'] = Variable<bool>(isSystem);
    return map;
  }

  StoredCategoriesCompanion toCompanion(bool nullToAbsent) {
    return StoredCategoriesCompanion(
      id: Value(id),
      name: Value(name),
      position: Value(position),
      sortKind: Value(sortKind),
      ascending: Value(ascending),
      isSystem: Value(isSystem),
    );
  }

  factory StoredCategory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoredCategory(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      position: serializer.fromJson<int>(json['position']),
      sortKind: serializer.fromJson<String>(json['sortKind']),
      ascending: serializer.fromJson<bool>(json['ascending']),
      isSystem: serializer.fromJson<bool>(json['isSystem']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'position': serializer.toJson<int>(position),
      'sortKind': serializer.toJson<String>(sortKind),
      'ascending': serializer.toJson<bool>(ascending),
      'isSystem': serializer.toJson<bool>(isSystem),
    };
  }

  StoredCategory copyWith({
    int? id,
    String? name,
    int? position,
    String? sortKind,
    bool? ascending,
    bool? isSystem,
  }) => StoredCategory(
    id: id ?? this.id,
    name: name ?? this.name,
    position: position ?? this.position,
    sortKind: sortKind ?? this.sortKind,
    ascending: ascending ?? this.ascending,
    isSystem: isSystem ?? this.isSystem,
  );
  StoredCategory copyWithCompanion(StoredCategoriesCompanion data) {
    return StoredCategory(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      position: data.position.present ? data.position.value : this.position,
      sortKind: data.sortKind.present ? data.sortKind.value : this.sortKind,
      ascending: data.ascending.present ? data.ascending.value : this.ascending,
      isSystem: data.isSystem.present ? data.isSystem.value : this.isSystem,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoredCategory(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('position: $position, ')
          ..write('sortKind: $sortKind, ')
          ..write('ascending: $ascending, ')
          ..write('isSystem: $isSystem')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, position, sortKind, ascending, isSystem);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoredCategory &&
          other.id == this.id &&
          other.name == this.name &&
          other.position == this.position &&
          other.sortKind == this.sortKind &&
          other.ascending == this.ascending &&
          other.isSystem == this.isSystem);
}

class StoredCategoriesCompanion extends UpdateCompanion<StoredCategory> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> position;
  final Value<String> sortKind;
  final Value<bool> ascending;
  final Value<bool> isSystem;
  const StoredCategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.position = const Value.absent(),
    this.sortKind = const Value.absent(),
    this.ascending = const Value.absent(),
    this.isSystem = const Value.absent(),
  });
  StoredCategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int position,
    required String sortKind,
    this.ascending = const Value.absent(),
    this.isSystem = const Value.absent(),
  }) : name = Value(name),
       position = Value(position),
       sortKind = Value(sortKind);
  static Insertable<StoredCategory> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? position,
    Expression<String>? sortKind,
    Expression<bool>? ascending,
    Expression<bool>? isSystem,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (position != null) 'position': position,
      if (sortKind != null) 'sort_kind': sortKind,
      if (ascending != null) 'ascending': ascending,
      if (isSystem != null) 'is_system': isSystem,
    });
  }

  StoredCategoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? position,
    Value<String>? sortKind,
    Value<bool>? ascending,
    Value<bool>? isSystem,
  }) {
    return StoredCategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      position: position ?? this.position,
      sortKind: sortKind ?? this.sortKind,
      ascending: ascending ?? this.ascending,
      isSystem: isSystem ?? this.isSystem,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (sortKind.present) {
      map['sort_kind'] = Variable<String>(sortKind.value);
    }
    if (ascending.present) {
      map['ascending'] = Variable<bool>(ascending.value);
    }
    if (isSystem.present) {
      map['is_system'] = Variable<bool>(isSystem.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoredCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('position: $position, ')
          ..write('sortKind: $sortKind, ')
          ..write('ascending: $ascending, ')
          ..write('isSystem: $isSystem')
          ..write(')'))
        .toString();
  }
}

class $StoredRecipeCategoriesTable extends StoredRecipeCategories
    with TableInfo<$StoredRecipeCategoriesTable, StoredRecipeCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoredRecipeCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _recipeIdMeta = const VerificationMeta(
    'recipeId',
  );
  @override
  late final GeneratedColumn<int> recipeId = GeneratedColumn<int>(
    'recipe_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES stored_recipes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES stored_categories (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, recipeId, categoryId, position];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stored_recipe_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<StoredRecipeCategory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('recipe_id')) {
      context.handle(
        _recipeIdMeta,
        recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StoredRecipeCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoredRecipeCategory(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      recipeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recipe_id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  $StoredRecipeCategoriesTable createAlias(String alias) {
    return $StoredRecipeCategoriesTable(attachedDatabase, alias);
  }
}

class StoredRecipeCategory extends DataClass
    implements Insertable<StoredRecipeCategory> {
  final int id;
  final int recipeId;
  final int categoryId;
  final int position;
  const StoredRecipeCategory({
    required this.id,
    required this.recipeId,
    required this.categoryId,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['recipe_id'] = Variable<int>(recipeId);
    map['category_id'] = Variable<int>(categoryId);
    map['position'] = Variable<int>(position);
    return map;
  }

  StoredRecipeCategoriesCompanion toCompanion(bool nullToAbsent) {
    return StoredRecipeCategoriesCompanion(
      id: Value(id),
      recipeId: Value(recipeId),
      categoryId: Value(categoryId),
      position: Value(position),
    );
  }

  factory StoredRecipeCategory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoredRecipeCategory(
      id: serializer.fromJson<int>(json['id']),
      recipeId: serializer.fromJson<int>(json['recipeId']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'recipeId': serializer.toJson<int>(recipeId),
      'categoryId': serializer.toJson<int>(categoryId),
      'position': serializer.toJson<int>(position),
    };
  }

  StoredRecipeCategory copyWith({
    int? id,
    int? recipeId,
    int? categoryId,
    int? position,
  }) => StoredRecipeCategory(
    id: id ?? this.id,
    recipeId: recipeId ?? this.recipeId,
    categoryId: categoryId ?? this.categoryId,
    position: position ?? this.position,
  );
  StoredRecipeCategory copyWithCompanion(StoredRecipeCategoriesCompanion data) {
    return StoredRecipeCategory(
      id: data.id.present ? data.id.value : this.id,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoredRecipeCategory(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('categoryId: $categoryId, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, recipeId, categoryId, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoredRecipeCategory &&
          other.id == this.id &&
          other.recipeId == this.recipeId &&
          other.categoryId == this.categoryId &&
          other.position == this.position);
}

class StoredRecipeCategoriesCompanion
    extends UpdateCompanion<StoredRecipeCategory> {
  final Value<int> id;
  final Value<int> recipeId;
  final Value<int> categoryId;
  final Value<int> position;
  const StoredRecipeCategoriesCompanion({
    this.id = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.position = const Value.absent(),
  });
  StoredRecipeCategoriesCompanion.insert({
    this.id = const Value.absent(),
    required int recipeId,
    required int categoryId,
    required int position,
  }) : recipeId = Value(recipeId),
       categoryId = Value(categoryId),
       position = Value(position);
  static Insertable<StoredRecipeCategory> custom({
    Expression<int>? id,
    Expression<int>? recipeId,
    Expression<int>? categoryId,
    Expression<int>? position,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recipeId != null) 'recipe_id': recipeId,
      if (categoryId != null) 'category_id': categoryId,
      if (position != null) 'position': position,
    });
  }

  StoredRecipeCategoriesCompanion copyWith({
    Value<int>? id,
    Value<int>? recipeId,
    Value<int>? categoryId,
    Value<int>? position,
  }) {
    return StoredRecipeCategoriesCompanion(
      id: id ?? this.id,
      recipeId: recipeId ?? this.recipeId,
      categoryId: categoryId ?? this.categoryId,
      position: position ?? this.position,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<int>(recipeId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoredRecipeCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('categoryId: $categoryId, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }
}

class $StoredTagsTable extends StoredTags
    with TableInfo<$StoredTagsTable, StoredTag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoredTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, color, position];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stored_tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<StoredTag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StoredTag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoredTag(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  $StoredTagsTable createAlias(String alias) {
    return $StoredTagsTable(attachedDatabase, alias);
  }
}

class StoredTag extends DataClass implements Insertable<StoredTag> {
  final int id;
  final String name;
  final int color;
  final int position;
  const StoredTag({
    required this.id,
    required this.name,
    required this.color,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['color'] = Variable<int>(color);
    map['position'] = Variable<int>(position);
    return map;
  }

  StoredTagsCompanion toCompanion(bool nullToAbsent) {
    return StoredTagsCompanion(
      id: Value(id),
      name: Value(name),
      color: Value(color),
      position: Value(position),
    );
  }

  factory StoredTag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoredTag(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<int>(json['color']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<int>(color),
      'position': serializer.toJson<int>(position),
    };
  }

  StoredTag copyWith({int? id, String? name, int? color, int? position}) =>
      StoredTag(
        id: id ?? this.id,
        name: name ?? this.name,
        color: color ?? this.color,
        position: position ?? this.position,
      );
  StoredTag copyWithCompanion(StoredTagsCompanion data) {
    return StoredTag(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      color: data.color.present ? data.color.value : this.color,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoredTag(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, color, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoredTag &&
          other.id == this.id &&
          other.name == this.name &&
          other.color == this.color &&
          other.position == this.position);
}

class StoredTagsCompanion extends UpdateCompanion<StoredTag> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> color;
  final Value<int> position;
  const StoredTagsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
    this.position = const Value.absent(),
  });
  StoredTagsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int color,
    required int position,
  }) : name = Value(name),
       color = Value(color),
       position = Value(position);
  static Insertable<StoredTag> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? color,
    Expression<int>? position,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (position != null) 'position': position,
    });
  }

  StoredTagsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? color,
    Value<int>? position,
  }) {
    return StoredTagsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      position: position ?? this.position,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoredTagsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }
}

class $StoredRecipeTagsTable extends StoredRecipeTags
    with TableInfo<$StoredRecipeTagsTable, StoredRecipeTag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoredRecipeTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _recipeIdMeta = const VerificationMeta(
    'recipeId',
  );
  @override
  late final GeneratedColumn<int> recipeId = GeneratedColumn<int>(
    'recipe_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES stored_recipes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
  late final GeneratedColumn<int> tagId = GeneratedColumn<int>(
    'tag_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES stored_tags (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, recipeId, tagId, position];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stored_recipe_tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<StoredRecipeTag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('recipe_id')) {
      context.handle(
        _recipeIdMeta,
        recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    if (data.containsKey('tag_id')) {
      context.handle(
        _tagIdMeta,
        tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tagIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StoredRecipeTag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoredRecipeTag(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      recipeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recipe_id'],
      )!,
      tagId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tag_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  $StoredRecipeTagsTable createAlias(String alias) {
    return $StoredRecipeTagsTable(attachedDatabase, alias);
  }
}

class StoredRecipeTag extends DataClass implements Insertable<StoredRecipeTag> {
  final int id;
  final int recipeId;
  final int tagId;
  final int position;
  const StoredRecipeTag({
    required this.id,
    required this.recipeId,
    required this.tagId,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['recipe_id'] = Variable<int>(recipeId);
    map['tag_id'] = Variable<int>(tagId);
    map['position'] = Variable<int>(position);
    return map;
  }

  StoredRecipeTagsCompanion toCompanion(bool nullToAbsent) {
    return StoredRecipeTagsCompanion(
      id: Value(id),
      recipeId: Value(recipeId),
      tagId: Value(tagId),
      position: Value(position),
    );
  }

  factory StoredRecipeTag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoredRecipeTag(
      id: serializer.fromJson<int>(json['id']),
      recipeId: serializer.fromJson<int>(json['recipeId']),
      tagId: serializer.fromJson<int>(json['tagId']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'recipeId': serializer.toJson<int>(recipeId),
      'tagId': serializer.toJson<int>(tagId),
      'position': serializer.toJson<int>(position),
    };
  }

  StoredRecipeTag copyWith({
    int? id,
    int? recipeId,
    int? tagId,
    int? position,
  }) => StoredRecipeTag(
    id: id ?? this.id,
    recipeId: recipeId ?? this.recipeId,
    tagId: tagId ?? this.tagId,
    position: position ?? this.position,
  );
  StoredRecipeTag copyWithCompanion(StoredRecipeTagsCompanion data) {
    return StoredRecipeTag(
      id: data.id.present ? data.id.value : this.id,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoredRecipeTag(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('tagId: $tagId, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, recipeId, tagId, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoredRecipeTag &&
          other.id == this.id &&
          other.recipeId == this.recipeId &&
          other.tagId == this.tagId &&
          other.position == this.position);
}

class StoredRecipeTagsCompanion extends UpdateCompanion<StoredRecipeTag> {
  final Value<int> id;
  final Value<int> recipeId;
  final Value<int> tagId;
  final Value<int> position;
  const StoredRecipeTagsCompanion({
    this.id = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.tagId = const Value.absent(),
    this.position = const Value.absent(),
  });
  StoredRecipeTagsCompanion.insert({
    this.id = const Value.absent(),
    required int recipeId,
    required int tagId,
    required int position,
  }) : recipeId = Value(recipeId),
       tagId = Value(tagId),
       position = Value(position);
  static Insertable<StoredRecipeTag> custom({
    Expression<int>? id,
    Expression<int>? recipeId,
    Expression<int>? tagId,
    Expression<int>? position,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recipeId != null) 'recipe_id': recipeId,
      if (tagId != null) 'tag_id': tagId,
      if (position != null) 'position': position,
    });
  }

  StoredRecipeTagsCompanion copyWith({
    Value<int>? id,
    Value<int>? recipeId,
    Value<int>? tagId,
    Value<int>? position,
  }) {
    return StoredRecipeTagsCompanion(
      id: id ?? this.id,
      recipeId: recipeId ?? this.recipeId,
      tagId: tagId ?? this.tagId,
      position: position ?? this.position,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<int>(recipeId.value);
    }
    if (tagId.present) {
      map['tag_id'] = Variable<int>(tagId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoredRecipeTagsCompanion(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('tagId: $tagId, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }
}

class $StoredIngredientGroupsTable extends StoredIngredientGroups
    with TableInfo<$StoredIngredientGroupsTable, StoredIngredientGroup> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoredIngredientGroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _recipeIdMeta = const VerificationMeta(
    'recipeId',
  );
  @override
  late final GeneratedColumn<int> recipeId = GeneratedColumn<int>(
    'recipe_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES stored_recipes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hasIngredientGroupMeta =
      const VerificationMeta('hasIngredientGroup');
  @override
  late final GeneratedColumn<bool> hasIngredientGroup = GeneratedColumn<bool>(
    'has_ingredient_group',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_ingredient_group" IN (0, 1))',
    ),
  );
  static const VerificationMeta _hasGlossaryMeta = const VerificationMeta(
    'hasGlossary',
  );
  @override
  late final GeneratedColumn<bool> hasGlossary = GeneratedColumn<bool>(
    'has_glossary',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_glossary" IN (0, 1))',
    ),
  );
  static const VerificationMeta _glossaryMeta = const VerificationMeta(
    'glossary',
  );
  @override
  late final GeneratedColumn<String> glossary = GeneratedColumn<String>(
    'glossary',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    recipeId,
    position,
    hasIngredientGroup,
    hasGlossary,
    glossary,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stored_ingredient_groups';
  @override
  VerificationContext validateIntegrity(
    Insertable<StoredIngredientGroup> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('recipe_id')) {
      context.handle(
        _recipeIdMeta,
        recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('has_ingredient_group')) {
      context.handle(
        _hasIngredientGroupMeta,
        hasIngredientGroup.isAcceptableOrUnknown(
          data['has_ingredient_group']!,
          _hasIngredientGroupMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_hasIngredientGroupMeta);
    }
    if (data.containsKey('has_glossary')) {
      context.handle(
        _hasGlossaryMeta,
        hasGlossary.isAcceptableOrUnknown(
          data['has_glossary']!,
          _hasGlossaryMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_hasGlossaryMeta);
    }
    if (data.containsKey('glossary')) {
      context.handle(
        _glossaryMeta,
        glossary.isAcceptableOrUnknown(data['glossary']!, _glossaryMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StoredIngredientGroup map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoredIngredientGroup(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      recipeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recipe_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      hasIngredientGroup: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_ingredient_group'],
      )!,
      hasGlossary: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_glossary'],
      )!,
      glossary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}glossary'],
      ),
    );
  }

  @override
  $StoredIngredientGroupsTable createAlias(String alias) {
    return $StoredIngredientGroupsTable(attachedDatabase, alias);
  }
}

class StoredIngredientGroup extends DataClass
    implements Insertable<StoredIngredientGroup> {
  final int id;
  final int recipeId;
  final int position;
  final bool hasIngredientGroup;
  final bool hasGlossary;
  final String? glossary;
  const StoredIngredientGroup({
    required this.id,
    required this.recipeId,
    required this.position,
    required this.hasIngredientGroup,
    required this.hasGlossary,
    this.glossary,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['recipe_id'] = Variable<int>(recipeId);
    map['position'] = Variable<int>(position);
    map['has_ingredient_group'] = Variable<bool>(hasIngredientGroup);
    map['has_glossary'] = Variable<bool>(hasGlossary);
    if (!nullToAbsent || glossary != null) {
      map['glossary'] = Variable<String>(glossary);
    }
    return map;
  }

  StoredIngredientGroupsCompanion toCompanion(bool nullToAbsent) {
    return StoredIngredientGroupsCompanion(
      id: Value(id),
      recipeId: Value(recipeId),
      position: Value(position),
      hasIngredientGroup: Value(hasIngredientGroup),
      hasGlossary: Value(hasGlossary),
      glossary: glossary == null && nullToAbsent
          ? const Value.absent()
          : Value(glossary),
    );
  }

  factory StoredIngredientGroup.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoredIngredientGroup(
      id: serializer.fromJson<int>(json['id']),
      recipeId: serializer.fromJson<int>(json['recipeId']),
      position: serializer.fromJson<int>(json['position']),
      hasIngredientGroup: serializer.fromJson<bool>(json['hasIngredientGroup']),
      hasGlossary: serializer.fromJson<bool>(json['hasGlossary']),
      glossary: serializer.fromJson<String?>(json['glossary']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'recipeId': serializer.toJson<int>(recipeId),
      'position': serializer.toJson<int>(position),
      'hasIngredientGroup': serializer.toJson<bool>(hasIngredientGroup),
      'hasGlossary': serializer.toJson<bool>(hasGlossary),
      'glossary': serializer.toJson<String?>(glossary),
    };
  }

  StoredIngredientGroup copyWith({
    int? id,
    int? recipeId,
    int? position,
    bool? hasIngredientGroup,
    bool? hasGlossary,
    Value<String?> glossary = const Value.absent(),
  }) => StoredIngredientGroup(
    id: id ?? this.id,
    recipeId: recipeId ?? this.recipeId,
    position: position ?? this.position,
    hasIngredientGroup: hasIngredientGroup ?? this.hasIngredientGroup,
    hasGlossary: hasGlossary ?? this.hasGlossary,
    glossary: glossary.present ? glossary.value : this.glossary,
  );
  StoredIngredientGroup copyWithCompanion(
    StoredIngredientGroupsCompanion data,
  ) {
    return StoredIngredientGroup(
      id: data.id.present ? data.id.value : this.id,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      position: data.position.present ? data.position.value : this.position,
      hasIngredientGroup: data.hasIngredientGroup.present
          ? data.hasIngredientGroup.value
          : this.hasIngredientGroup,
      hasGlossary: data.hasGlossary.present
          ? data.hasGlossary.value
          : this.hasGlossary,
      glossary: data.glossary.present ? data.glossary.value : this.glossary,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoredIngredientGroup(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('position: $position, ')
          ..write('hasIngredientGroup: $hasIngredientGroup, ')
          ..write('hasGlossary: $hasGlossary, ')
          ..write('glossary: $glossary')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    recipeId,
    position,
    hasIngredientGroup,
    hasGlossary,
    glossary,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoredIngredientGroup &&
          other.id == this.id &&
          other.recipeId == this.recipeId &&
          other.position == this.position &&
          other.hasIngredientGroup == this.hasIngredientGroup &&
          other.hasGlossary == this.hasGlossary &&
          other.glossary == this.glossary);
}

class StoredIngredientGroupsCompanion
    extends UpdateCompanion<StoredIngredientGroup> {
  final Value<int> id;
  final Value<int> recipeId;
  final Value<int> position;
  final Value<bool> hasIngredientGroup;
  final Value<bool> hasGlossary;
  final Value<String?> glossary;
  const StoredIngredientGroupsCompanion({
    this.id = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.position = const Value.absent(),
    this.hasIngredientGroup = const Value.absent(),
    this.hasGlossary = const Value.absent(),
    this.glossary = const Value.absent(),
  });
  StoredIngredientGroupsCompanion.insert({
    this.id = const Value.absent(),
    required int recipeId,
    required int position,
    required bool hasIngredientGroup,
    required bool hasGlossary,
    this.glossary = const Value.absent(),
  }) : recipeId = Value(recipeId),
       position = Value(position),
       hasIngredientGroup = Value(hasIngredientGroup),
       hasGlossary = Value(hasGlossary);
  static Insertable<StoredIngredientGroup> custom({
    Expression<int>? id,
    Expression<int>? recipeId,
    Expression<int>? position,
    Expression<bool>? hasIngredientGroup,
    Expression<bool>? hasGlossary,
    Expression<String>? glossary,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recipeId != null) 'recipe_id': recipeId,
      if (position != null) 'position': position,
      if (hasIngredientGroup != null)
        'has_ingredient_group': hasIngredientGroup,
      if (hasGlossary != null) 'has_glossary': hasGlossary,
      if (glossary != null) 'glossary': glossary,
    });
  }

  StoredIngredientGroupsCompanion copyWith({
    Value<int>? id,
    Value<int>? recipeId,
    Value<int>? position,
    Value<bool>? hasIngredientGroup,
    Value<bool>? hasGlossary,
    Value<String?>? glossary,
  }) {
    return StoredIngredientGroupsCompanion(
      id: id ?? this.id,
      recipeId: recipeId ?? this.recipeId,
      position: position ?? this.position,
      hasIngredientGroup: hasIngredientGroup ?? this.hasIngredientGroup,
      hasGlossary: hasGlossary ?? this.hasGlossary,
      glossary: glossary ?? this.glossary,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<int>(recipeId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (hasIngredientGroup.present) {
      map['has_ingredient_group'] = Variable<bool>(hasIngredientGroup.value);
    }
    if (hasGlossary.present) {
      map['has_glossary'] = Variable<bool>(hasGlossary.value);
    }
    if (glossary.present) {
      map['glossary'] = Variable<String>(glossary.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoredIngredientGroupsCompanion(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('position: $position, ')
          ..write('hasIngredientGroup: $hasIngredientGroup, ')
          ..write('hasGlossary: $hasGlossary, ')
          ..write('glossary: $glossary')
          ..write(')'))
        .toString();
  }
}

class $StoredIngredientsTable extends StoredIngredients
    with TableInfo<$StoredIngredientsTable, StoredIngredient> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoredIngredientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<int> groupId = GeneratedColumn<int>(
    'group_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES stored_ingredient_groups (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _opaqueIdMeta = const VerificationMeta(
    'opaqueId',
  );
  @override
  late final GeneratedColumn<String> opaqueId = GeneratedColumn<String>(
    'opaque_id',
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
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    groupId,
    position,
    opaqueId,
    name,
    amount,
    unit,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stored_ingredients';
  @override
  VerificationContext validateIntegrity(
    Insertable<StoredIngredient> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('opaque_id')) {
      context.handle(
        _opaqueIdMeta,
        opaqueId.isAcceptableOrUnknown(data['opaque_id']!, _opaqueIdMeta),
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
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StoredIngredient map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoredIngredient(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}group_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      opaqueId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}opaque_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      ),
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      ),
    );
  }

  @override
  $StoredIngredientsTable createAlias(String alias) {
    return $StoredIngredientsTable(attachedDatabase, alias);
  }
}

class StoredIngredient extends DataClass
    implements Insertable<StoredIngredient> {
  final int id;
  final int groupId;
  final int position;
  final String? opaqueId;
  final String name;
  final double? amount;
  final String? unit;
  const StoredIngredient({
    required this.id,
    required this.groupId,
    required this.position,
    this.opaqueId,
    required this.name,
    this.amount,
    this.unit,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['group_id'] = Variable<int>(groupId);
    map['position'] = Variable<int>(position);
    if (!nullToAbsent || opaqueId != null) {
      map['opaque_id'] = Variable<String>(opaqueId);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || amount != null) {
      map['amount'] = Variable<double>(amount);
    }
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    return map;
  }

  StoredIngredientsCompanion toCompanion(bool nullToAbsent) {
    return StoredIngredientsCompanion(
      id: Value(id),
      groupId: Value(groupId),
      position: Value(position),
      opaqueId: opaqueId == null && nullToAbsent
          ? const Value.absent()
          : Value(opaqueId),
      name: Value(name),
      amount: amount == null && nullToAbsent
          ? const Value.absent()
          : Value(amount),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
    );
  }

  factory StoredIngredient.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoredIngredient(
      id: serializer.fromJson<int>(json['id']),
      groupId: serializer.fromJson<int>(json['groupId']),
      position: serializer.fromJson<int>(json['position']),
      opaqueId: serializer.fromJson<String?>(json['opaqueId']),
      name: serializer.fromJson<String>(json['name']),
      amount: serializer.fromJson<double?>(json['amount']),
      unit: serializer.fromJson<String?>(json['unit']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'groupId': serializer.toJson<int>(groupId),
      'position': serializer.toJson<int>(position),
      'opaqueId': serializer.toJson<String?>(opaqueId),
      'name': serializer.toJson<String>(name),
      'amount': serializer.toJson<double?>(amount),
      'unit': serializer.toJson<String?>(unit),
    };
  }

  StoredIngredient copyWith({
    int? id,
    int? groupId,
    int? position,
    Value<String?> opaqueId = const Value.absent(),
    String? name,
    Value<double?> amount = const Value.absent(),
    Value<String?> unit = const Value.absent(),
  }) => StoredIngredient(
    id: id ?? this.id,
    groupId: groupId ?? this.groupId,
    position: position ?? this.position,
    opaqueId: opaqueId.present ? opaqueId.value : this.opaqueId,
    name: name ?? this.name,
    amount: amount.present ? amount.value : this.amount,
    unit: unit.present ? unit.value : this.unit,
  );
  StoredIngredient copyWithCompanion(StoredIngredientsCompanion data) {
    return StoredIngredient(
      id: data.id.present ? data.id.value : this.id,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      position: data.position.present ? data.position.value : this.position,
      opaqueId: data.opaqueId.present ? data.opaqueId.value : this.opaqueId,
      name: data.name.present ? data.name.value : this.name,
      amount: data.amount.present ? data.amount.value : this.amount,
      unit: data.unit.present ? data.unit.value : this.unit,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoredIngredient(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('position: $position, ')
          ..write('opaqueId: $opaqueId, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('unit: $unit')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, groupId, position, opaqueId, name, amount, unit);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoredIngredient &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.position == this.position &&
          other.opaqueId == this.opaqueId &&
          other.name == this.name &&
          other.amount == this.amount &&
          other.unit == this.unit);
}

class StoredIngredientsCompanion extends UpdateCompanion<StoredIngredient> {
  final Value<int> id;
  final Value<int> groupId;
  final Value<int> position;
  final Value<String?> opaqueId;
  final Value<String> name;
  final Value<double?> amount;
  final Value<String?> unit;
  const StoredIngredientsCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.position = const Value.absent(),
    this.opaqueId = const Value.absent(),
    this.name = const Value.absent(),
    this.amount = const Value.absent(),
    this.unit = const Value.absent(),
  });
  StoredIngredientsCompanion.insert({
    this.id = const Value.absent(),
    required int groupId,
    required int position,
    this.opaqueId = const Value.absent(),
    required String name,
    this.amount = const Value.absent(),
    this.unit = const Value.absent(),
  }) : groupId = Value(groupId),
       position = Value(position),
       name = Value(name);
  static Insertable<StoredIngredient> custom({
    Expression<int>? id,
    Expression<int>? groupId,
    Expression<int>? position,
    Expression<String>? opaqueId,
    Expression<String>? name,
    Expression<double>? amount,
    Expression<String>? unit,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'group_id': groupId,
      if (position != null) 'position': position,
      if (opaqueId != null) 'opaque_id': opaqueId,
      if (name != null) 'name': name,
      if (amount != null) 'amount': amount,
      if (unit != null) 'unit': unit,
    });
  }

  StoredIngredientsCompanion copyWith({
    Value<int>? id,
    Value<int>? groupId,
    Value<int>? position,
    Value<String?>? opaqueId,
    Value<String>? name,
    Value<double?>? amount,
    Value<String?>? unit,
  }) {
    return StoredIngredientsCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      position: position ?? this.position,
      opaqueId: opaqueId ?? this.opaqueId,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      unit: unit ?? this.unit,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<int>(groupId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (opaqueId.present) {
      map['opaque_id'] = Variable<String>(opaqueId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoredIngredientsCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('position: $position, ')
          ..write('opaqueId: $opaqueId, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('unit: $unit')
          ..write(')'))
        .toString();
  }
}

class $StoredNutritionsTable extends StoredNutritions
    with TableInfo<$StoredNutritionsTable, StoredNutrition> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoredNutritionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _recipeIdMeta = const VerificationMeta(
    'recipeId',
  );
  @override
  late final GeneratedColumn<int> recipeId = GeneratedColumn<int>(
    'recipe_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES stored_recipes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
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
  static const VerificationMeta _amountUnitMeta = const VerificationMeta(
    'amountUnit',
  );
  @override
  late final GeneratedColumn<String> amountUnit = GeneratedColumn<String>(
    'amount_unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    recipeId,
    position,
    name,
    amountUnit,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stored_nutritions';
  @override
  VerificationContext validateIntegrity(
    Insertable<StoredNutrition> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('recipe_id')) {
      context.handle(
        _recipeIdMeta,
        recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('amount_unit')) {
      context.handle(
        _amountUnitMeta,
        amountUnit.isAcceptableOrUnknown(data['amount_unit']!, _amountUnitMeta),
      );
    } else if (isInserting) {
      context.missing(_amountUnitMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StoredNutrition map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoredNutrition(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      recipeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recipe_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      amountUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}amount_unit'],
      )!,
    );
  }

  @override
  $StoredNutritionsTable createAlias(String alias) {
    return $StoredNutritionsTable(attachedDatabase, alias);
  }
}

class StoredNutrition extends DataClass implements Insertable<StoredNutrition> {
  final int id;
  final int recipeId;
  final int position;
  final String name;
  final String amountUnit;
  const StoredNutrition({
    required this.id,
    required this.recipeId,
    required this.position,
    required this.name,
    required this.amountUnit,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['recipe_id'] = Variable<int>(recipeId);
    map['position'] = Variable<int>(position);
    map['name'] = Variable<String>(name);
    map['amount_unit'] = Variable<String>(amountUnit);
    return map;
  }

  StoredNutritionsCompanion toCompanion(bool nullToAbsent) {
    return StoredNutritionsCompanion(
      id: Value(id),
      recipeId: Value(recipeId),
      position: Value(position),
      name: Value(name),
      amountUnit: Value(amountUnit),
    );
  }

  factory StoredNutrition.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoredNutrition(
      id: serializer.fromJson<int>(json['id']),
      recipeId: serializer.fromJson<int>(json['recipeId']),
      position: serializer.fromJson<int>(json['position']),
      name: serializer.fromJson<String>(json['name']),
      amountUnit: serializer.fromJson<String>(json['amountUnit']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'recipeId': serializer.toJson<int>(recipeId),
      'position': serializer.toJson<int>(position),
      'name': serializer.toJson<String>(name),
      'amountUnit': serializer.toJson<String>(amountUnit),
    };
  }

  StoredNutrition copyWith({
    int? id,
    int? recipeId,
    int? position,
    String? name,
    String? amountUnit,
  }) => StoredNutrition(
    id: id ?? this.id,
    recipeId: recipeId ?? this.recipeId,
    position: position ?? this.position,
    name: name ?? this.name,
    amountUnit: amountUnit ?? this.amountUnit,
  );
  StoredNutrition copyWithCompanion(StoredNutritionsCompanion data) {
    return StoredNutrition(
      id: data.id.present ? data.id.value : this.id,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      position: data.position.present ? data.position.value : this.position,
      name: data.name.present ? data.name.value : this.name,
      amountUnit: data.amountUnit.present
          ? data.amountUnit.value
          : this.amountUnit,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoredNutrition(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('position: $position, ')
          ..write('name: $name, ')
          ..write('amountUnit: $amountUnit')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, recipeId, position, name, amountUnit);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoredNutrition &&
          other.id == this.id &&
          other.recipeId == this.recipeId &&
          other.position == this.position &&
          other.name == this.name &&
          other.amountUnit == this.amountUnit);
}

class StoredNutritionsCompanion extends UpdateCompanion<StoredNutrition> {
  final Value<int> id;
  final Value<int> recipeId;
  final Value<int> position;
  final Value<String> name;
  final Value<String> amountUnit;
  const StoredNutritionsCompanion({
    this.id = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.position = const Value.absent(),
    this.name = const Value.absent(),
    this.amountUnit = const Value.absent(),
  });
  StoredNutritionsCompanion.insert({
    this.id = const Value.absent(),
    required int recipeId,
    required int position,
    required String name,
    required String amountUnit,
  }) : recipeId = Value(recipeId),
       position = Value(position),
       name = Value(name),
       amountUnit = Value(amountUnit);
  static Insertable<StoredNutrition> custom({
    Expression<int>? id,
    Expression<int>? recipeId,
    Expression<int>? position,
    Expression<String>? name,
    Expression<String>? amountUnit,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recipeId != null) 'recipe_id': recipeId,
      if (position != null) 'position': position,
      if (name != null) 'name': name,
      if (amountUnit != null) 'amount_unit': amountUnit,
    });
  }

  StoredNutritionsCompanion copyWith({
    Value<int>? id,
    Value<int>? recipeId,
    Value<int>? position,
    Value<String>? name,
    Value<String>? amountUnit,
  }) {
    return StoredNutritionsCompanion(
      id: id ?? this.id,
      recipeId: recipeId ?? this.recipeId,
      position: position ?? this.position,
      name: name ?? this.name,
      amountUnit: amountUnit ?? this.amountUnit,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<int>(recipeId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (amountUnit.present) {
      map['amount_unit'] = Variable<String>(amountUnit.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoredNutritionsCompanion(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('position: $position, ')
          ..write('name: $name, ')
          ..write('amountUnit: $amountUnit')
          ..write(')'))
        .toString();
  }
}

class $StoredStepGroupsTable extends StoredStepGroups
    with TableInfo<$StoredStepGroupsTable, StoredStepGroup> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoredStepGroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _recipeIdMeta = const VerificationMeta(
    'recipeId',
  );
  @override
  late final GeneratedColumn<int> recipeId = GeneratedColumn<int>(
    'recipe_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES stored_recipes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hasInstructionMeta = const VerificationMeta(
    'hasInstruction',
  );
  @override
  late final GeneratedColumn<bool> hasInstruction = GeneratedColumn<bool>(
    'has_instruction',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_instruction" IN (0, 1))',
    ),
  );
  static const VerificationMeta _instructionMeta = const VerificationMeta(
    'instruction',
  );
  @override
  late final GeneratedColumn<String> instruction = GeneratedColumn<String>(
    'instruction',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hasTitleMeta = const VerificationMeta(
    'hasTitle',
  );
  @override
  late final GeneratedColumn<bool> hasTitle = GeneratedColumn<bool>(
    'has_title',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_title" IN (0, 1))',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hasImageGroupMeta = const VerificationMeta(
    'hasImageGroup',
  );
  @override
  late final GeneratedColumn<bool> hasImageGroup = GeneratedColumn<bool>(
    'has_image_group',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_image_group" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    recipeId,
    position,
    hasInstruction,
    instruction,
    hasTitle,
    title,
    hasImageGroup,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stored_step_groups';
  @override
  VerificationContext validateIntegrity(
    Insertable<StoredStepGroup> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('recipe_id')) {
      context.handle(
        _recipeIdMeta,
        recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('has_instruction')) {
      context.handle(
        _hasInstructionMeta,
        hasInstruction.isAcceptableOrUnknown(
          data['has_instruction']!,
          _hasInstructionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_hasInstructionMeta);
    }
    if (data.containsKey('instruction')) {
      context.handle(
        _instructionMeta,
        instruction.isAcceptableOrUnknown(
          data['instruction']!,
          _instructionMeta,
        ),
      );
    }
    if (data.containsKey('has_title')) {
      context.handle(
        _hasTitleMeta,
        hasTitle.isAcceptableOrUnknown(data['has_title']!, _hasTitleMeta),
      );
    } else if (isInserting) {
      context.missing(_hasTitleMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('has_image_group')) {
      context.handle(
        _hasImageGroupMeta,
        hasImageGroup.isAcceptableOrUnknown(
          data['has_image_group']!,
          _hasImageGroupMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_hasImageGroupMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StoredStepGroup map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoredStepGroup(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      recipeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recipe_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      hasInstruction: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_instruction'],
      )!,
      instruction: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}instruction'],
      ),
      hasTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_title'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      hasImageGroup: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_image_group'],
      )!,
    );
  }

  @override
  $StoredStepGroupsTable createAlias(String alias) {
    return $StoredStepGroupsTable(attachedDatabase, alias);
  }
}

class StoredStepGroup extends DataClass implements Insertable<StoredStepGroup> {
  final int id;
  final int recipeId;
  final int position;
  final bool hasInstruction;
  final String? instruction;
  final bool hasTitle;
  final String? title;
  final bool hasImageGroup;
  const StoredStepGroup({
    required this.id,
    required this.recipeId,
    required this.position,
    required this.hasInstruction,
    this.instruction,
    required this.hasTitle,
    this.title,
    required this.hasImageGroup,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['recipe_id'] = Variable<int>(recipeId);
    map['position'] = Variable<int>(position);
    map['has_instruction'] = Variable<bool>(hasInstruction);
    if (!nullToAbsent || instruction != null) {
      map['instruction'] = Variable<String>(instruction);
    }
    map['has_title'] = Variable<bool>(hasTitle);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    map['has_image_group'] = Variable<bool>(hasImageGroup);
    return map;
  }

  StoredStepGroupsCompanion toCompanion(bool nullToAbsent) {
    return StoredStepGroupsCompanion(
      id: Value(id),
      recipeId: Value(recipeId),
      position: Value(position),
      hasInstruction: Value(hasInstruction),
      instruction: instruction == null && nullToAbsent
          ? const Value.absent()
          : Value(instruction),
      hasTitle: Value(hasTitle),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      hasImageGroup: Value(hasImageGroup),
    );
  }

  factory StoredStepGroup.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoredStepGroup(
      id: serializer.fromJson<int>(json['id']),
      recipeId: serializer.fromJson<int>(json['recipeId']),
      position: serializer.fromJson<int>(json['position']),
      hasInstruction: serializer.fromJson<bool>(json['hasInstruction']),
      instruction: serializer.fromJson<String?>(json['instruction']),
      hasTitle: serializer.fromJson<bool>(json['hasTitle']),
      title: serializer.fromJson<String?>(json['title']),
      hasImageGroup: serializer.fromJson<bool>(json['hasImageGroup']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'recipeId': serializer.toJson<int>(recipeId),
      'position': serializer.toJson<int>(position),
      'hasInstruction': serializer.toJson<bool>(hasInstruction),
      'instruction': serializer.toJson<String?>(instruction),
      'hasTitle': serializer.toJson<bool>(hasTitle),
      'title': serializer.toJson<String?>(title),
      'hasImageGroup': serializer.toJson<bool>(hasImageGroup),
    };
  }

  StoredStepGroup copyWith({
    int? id,
    int? recipeId,
    int? position,
    bool? hasInstruction,
    Value<String?> instruction = const Value.absent(),
    bool? hasTitle,
    Value<String?> title = const Value.absent(),
    bool? hasImageGroup,
  }) => StoredStepGroup(
    id: id ?? this.id,
    recipeId: recipeId ?? this.recipeId,
    position: position ?? this.position,
    hasInstruction: hasInstruction ?? this.hasInstruction,
    instruction: instruction.present ? instruction.value : this.instruction,
    hasTitle: hasTitle ?? this.hasTitle,
    title: title.present ? title.value : this.title,
    hasImageGroup: hasImageGroup ?? this.hasImageGroup,
  );
  StoredStepGroup copyWithCompanion(StoredStepGroupsCompanion data) {
    return StoredStepGroup(
      id: data.id.present ? data.id.value : this.id,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      position: data.position.present ? data.position.value : this.position,
      hasInstruction: data.hasInstruction.present
          ? data.hasInstruction.value
          : this.hasInstruction,
      instruction: data.instruction.present
          ? data.instruction.value
          : this.instruction,
      hasTitle: data.hasTitle.present ? data.hasTitle.value : this.hasTitle,
      title: data.title.present ? data.title.value : this.title,
      hasImageGroup: data.hasImageGroup.present
          ? data.hasImageGroup.value
          : this.hasImageGroup,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoredStepGroup(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('position: $position, ')
          ..write('hasInstruction: $hasInstruction, ')
          ..write('instruction: $instruction, ')
          ..write('hasTitle: $hasTitle, ')
          ..write('title: $title, ')
          ..write('hasImageGroup: $hasImageGroup')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    recipeId,
    position,
    hasInstruction,
    instruction,
    hasTitle,
    title,
    hasImageGroup,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoredStepGroup &&
          other.id == this.id &&
          other.recipeId == this.recipeId &&
          other.position == this.position &&
          other.hasInstruction == this.hasInstruction &&
          other.instruction == this.instruction &&
          other.hasTitle == this.hasTitle &&
          other.title == this.title &&
          other.hasImageGroup == this.hasImageGroup);
}

class StoredStepGroupsCompanion extends UpdateCompanion<StoredStepGroup> {
  final Value<int> id;
  final Value<int> recipeId;
  final Value<int> position;
  final Value<bool> hasInstruction;
  final Value<String?> instruction;
  final Value<bool> hasTitle;
  final Value<String?> title;
  final Value<bool> hasImageGroup;
  const StoredStepGroupsCompanion({
    this.id = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.position = const Value.absent(),
    this.hasInstruction = const Value.absent(),
    this.instruction = const Value.absent(),
    this.hasTitle = const Value.absent(),
    this.title = const Value.absent(),
    this.hasImageGroup = const Value.absent(),
  });
  StoredStepGroupsCompanion.insert({
    this.id = const Value.absent(),
    required int recipeId,
    required int position,
    required bool hasInstruction,
    this.instruction = const Value.absent(),
    required bool hasTitle,
    this.title = const Value.absent(),
    required bool hasImageGroup,
  }) : recipeId = Value(recipeId),
       position = Value(position),
       hasInstruction = Value(hasInstruction),
       hasTitle = Value(hasTitle),
       hasImageGroup = Value(hasImageGroup);
  static Insertable<StoredStepGroup> custom({
    Expression<int>? id,
    Expression<int>? recipeId,
    Expression<int>? position,
    Expression<bool>? hasInstruction,
    Expression<String>? instruction,
    Expression<bool>? hasTitle,
    Expression<String>? title,
    Expression<bool>? hasImageGroup,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recipeId != null) 'recipe_id': recipeId,
      if (position != null) 'position': position,
      if (hasInstruction != null) 'has_instruction': hasInstruction,
      if (instruction != null) 'instruction': instruction,
      if (hasTitle != null) 'has_title': hasTitle,
      if (title != null) 'title': title,
      if (hasImageGroup != null) 'has_image_group': hasImageGroup,
    });
  }

  StoredStepGroupsCompanion copyWith({
    Value<int>? id,
    Value<int>? recipeId,
    Value<int>? position,
    Value<bool>? hasInstruction,
    Value<String?>? instruction,
    Value<bool>? hasTitle,
    Value<String?>? title,
    Value<bool>? hasImageGroup,
  }) {
    return StoredStepGroupsCompanion(
      id: id ?? this.id,
      recipeId: recipeId ?? this.recipeId,
      position: position ?? this.position,
      hasInstruction: hasInstruction ?? this.hasInstruction,
      instruction: instruction ?? this.instruction,
      hasTitle: hasTitle ?? this.hasTitle,
      title: title ?? this.title,
      hasImageGroup: hasImageGroup ?? this.hasImageGroup,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<int>(recipeId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (hasInstruction.present) {
      map['has_instruction'] = Variable<bool>(hasInstruction.value);
    }
    if (instruction.present) {
      map['instruction'] = Variable<String>(instruction.value);
    }
    if (hasTitle.present) {
      map['has_title'] = Variable<bool>(hasTitle.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (hasImageGroup.present) {
      map['has_image_group'] = Variable<bool>(hasImageGroup.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoredStepGroupsCompanion(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('position: $position, ')
          ..write('hasInstruction: $hasInstruction, ')
          ..write('instruction: $instruction, ')
          ..write('hasTitle: $hasTitle, ')
          ..write('title: $title, ')
          ..write('hasImageGroup: $hasImageGroup')
          ..write(')'))
        .toString();
  }
}

class $StoredStepImagesTable extends StoredStepImages
    with TableInfo<$StoredStepImagesTable, StoredStepImage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoredStepImagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<int> groupId = GeneratedColumn<int>(
    'group_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES stored_step_groups (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, groupId, position, path];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stored_step_images';
  @override
  VerificationContext validateIntegrity(
    Insertable<StoredStepImage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('path')) {
      context.handle(
        _pathMeta,
        path.isAcceptableOrUnknown(data['path']!, _pathMeta),
      );
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StoredStepImage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoredStepImage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}group_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      path: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}path'],
      )!,
    );
  }

  @override
  $StoredStepImagesTable createAlias(String alias) {
    return $StoredStepImagesTable(attachedDatabase, alias);
  }
}

class StoredStepImage extends DataClass implements Insertable<StoredStepImage> {
  final int id;
  final int groupId;
  final int position;
  final String path;
  const StoredStepImage({
    required this.id,
    required this.groupId,
    required this.position,
    required this.path,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['group_id'] = Variable<int>(groupId);
    map['position'] = Variable<int>(position);
    map['path'] = Variable<String>(path);
    return map;
  }

  StoredStepImagesCompanion toCompanion(bool nullToAbsent) {
    return StoredStepImagesCompanion(
      id: Value(id),
      groupId: Value(groupId),
      position: Value(position),
      path: Value(path),
    );
  }

  factory StoredStepImage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoredStepImage(
      id: serializer.fromJson<int>(json['id']),
      groupId: serializer.fromJson<int>(json['groupId']),
      position: serializer.fromJson<int>(json['position']),
      path: serializer.fromJson<String>(json['path']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'groupId': serializer.toJson<int>(groupId),
      'position': serializer.toJson<int>(position),
      'path': serializer.toJson<String>(path),
    };
  }

  StoredStepImage copyWith({
    int? id,
    int? groupId,
    int? position,
    String? path,
  }) => StoredStepImage(
    id: id ?? this.id,
    groupId: groupId ?? this.groupId,
    position: position ?? this.position,
    path: path ?? this.path,
  );
  StoredStepImage copyWithCompanion(StoredStepImagesCompanion data) {
    return StoredStepImage(
      id: data.id.present ? data.id.value : this.id,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      position: data.position.present ? data.position.value : this.position,
      path: data.path.present ? data.path.value : this.path,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoredStepImage(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('position: $position, ')
          ..write('path: $path')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, groupId, position, path);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoredStepImage &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.position == this.position &&
          other.path == this.path);
}

class StoredStepImagesCompanion extends UpdateCompanion<StoredStepImage> {
  final Value<int> id;
  final Value<int> groupId;
  final Value<int> position;
  final Value<String> path;
  const StoredStepImagesCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.position = const Value.absent(),
    this.path = const Value.absent(),
  });
  StoredStepImagesCompanion.insert({
    this.id = const Value.absent(),
    required int groupId,
    required int position,
    required String path,
  }) : groupId = Value(groupId),
       position = Value(position),
       path = Value(path);
  static Insertable<StoredStepImage> custom({
    Expression<int>? id,
    Expression<int>? groupId,
    Expression<int>? position,
    Expression<String>? path,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'group_id': groupId,
      if (position != null) 'position': position,
      if (path != null) 'path': path,
    });
  }

  StoredStepImagesCompanion copyWith({
    Value<int>? id,
    Value<int>? groupId,
    Value<int>? position,
    Value<String>? path,
  }) {
    return StoredStepImagesCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      position: position ?? this.position,
      path: path ?? this.path,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<int>(groupId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoredStepImagesCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('position: $position, ')
          ..write('path: $path')
          ..write(')'))
        .toString();
  }
}

class $StoredStepIngredientsTable extends StoredStepIngredients
    with TableInfo<$StoredStepIngredientsTable, StoredStepIngredient> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoredStepIngredientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _stepGroupIdMeta = const VerificationMeta(
    'stepGroupId',
  );
  @override
  late final GeneratedColumn<int> stepGroupId = GeneratedColumn<int>(
    'step_group_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES stored_step_groups (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _ingredientIdMeta = const VerificationMeta(
    'ingredientId',
  );
  @override
  late final GeneratedColumn<int> ingredientId = GeneratedColumn<int>(
    'ingredient_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES stored_ingredients (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    stepGroupId,
    ingredientId,
    position,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stored_step_ingredients';
  @override
  VerificationContext validateIntegrity(
    Insertable<StoredStepIngredient> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('step_group_id')) {
      context.handle(
        _stepGroupIdMeta,
        stepGroupId.isAcceptableOrUnknown(
          data['step_group_id']!,
          _stepGroupIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_stepGroupIdMeta);
    }
    if (data.containsKey('ingredient_id')) {
      context.handle(
        _ingredientIdMeta,
        ingredientId.isAcceptableOrUnknown(
          data['ingredient_id']!,
          _ingredientIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ingredientIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {stepGroupId, ingredientId},
  ];
  @override
  StoredStepIngredient map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoredStepIngredient(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      stepGroupId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}step_group_id'],
      )!,
      ingredientId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ingredient_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  $StoredStepIngredientsTable createAlias(String alias) {
    return $StoredStepIngredientsTable(attachedDatabase, alias);
  }
}

class StoredStepIngredient extends DataClass
    implements Insertable<StoredStepIngredient> {
  final int id;
  final int stepGroupId;
  final int ingredientId;
  final int position;
  const StoredStepIngredient({
    required this.id,
    required this.stepGroupId,
    required this.ingredientId,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['step_group_id'] = Variable<int>(stepGroupId);
    map['ingredient_id'] = Variable<int>(ingredientId);
    map['position'] = Variable<int>(position);
    return map;
  }

  StoredStepIngredientsCompanion toCompanion(bool nullToAbsent) {
    return StoredStepIngredientsCompanion(
      id: Value(id),
      stepGroupId: Value(stepGroupId),
      ingredientId: Value(ingredientId),
      position: Value(position),
    );
  }

  factory StoredStepIngredient.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoredStepIngredient(
      id: serializer.fromJson<int>(json['id']),
      stepGroupId: serializer.fromJson<int>(json['stepGroupId']),
      ingredientId: serializer.fromJson<int>(json['ingredientId']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'stepGroupId': serializer.toJson<int>(stepGroupId),
      'ingredientId': serializer.toJson<int>(ingredientId),
      'position': serializer.toJson<int>(position),
    };
  }

  StoredStepIngredient copyWith({
    int? id,
    int? stepGroupId,
    int? ingredientId,
    int? position,
  }) => StoredStepIngredient(
    id: id ?? this.id,
    stepGroupId: stepGroupId ?? this.stepGroupId,
    ingredientId: ingredientId ?? this.ingredientId,
    position: position ?? this.position,
  );
  StoredStepIngredient copyWithCompanion(StoredStepIngredientsCompanion data) {
    return StoredStepIngredient(
      id: data.id.present ? data.id.value : this.id,
      stepGroupId: data.stepGroupId.present
          ? data.stepGroupId.value
          : this.stepGroupId,
      ingredientId: data.ingredientId.present
          ? data.ingredientId.value
          : this.ingredientId,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoredStepIngredient(')
          ..write('id: $id, ')
          ..write('stepGroupId: $stepGroupId, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, stepGroupId, ingredientId, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoredStepIngredient &&
          other.id == this.id &&
          other.stepGroupId == this.stepGroupId &&
          other.ingredientId == this.ingredientId &&
          other.position == this.position);
}

class StoredStepIngredientsCompanion
    extends UpdateCompanion<StoredStepIngredient> {
  final Value<int> id;
  final Value<int> stepGroupId;
  final Value<int> ingredientId;
  final Value<int> position;
  const StoredStepIngredientsCompanion({
    this.id = const Value.absent(),
    this.stepGroupId = const Value.absent(),
    this.ingredientId = const Value.absent(),
    this.position = const Value.absent(),
  });
  StoredStepIngredientsCompanion.insert({
    this.id = const Value.absent(),
    required int stepGroupId,
    required int ingredientId,
    required int position,
  }) : stepGroupId = Value(stepGroupId),
       ingredientId = Value(ingredientId),
       position = Value(position);
  static Insertable<StoredStepIngredient> custom({
    Expression<int>? id,
    Expression<int>? stepGroupId,
    Expression<int>? ingredientId,
    Expression<int>? position,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (stepGroupId != null) 'step_group_id': stepGroupId,
      if (ingredientId != null) 'ingredient_id': ingredientId,
      if (position != null) 'position': position,
    });
  }

  StoredStepIngredientsCompanion copyWith({
    Value<int>? id,
    Value<int>? stepGroupId,
    Value<int>? ingredientId,
    Value<int>? position,
  }) {
    return StoredStepIngredientsCompanion(
      id: id ?? this.id,
      stepGroupId: stepGroupId ?? this.stepGroupId,
      ingredientId: ingredientId ?? this.ingredientId,
      position: position ?? this.position,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (stepGroupId.present) {
      map['step_group_id'] = Variable<int>(stepGroupId.value);
    }
    if (ingredientId.present) {
      map['ingredient_id'] = Variable<int>(ingredientId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoredStepIngredientsCompanion(')
          ..write('id: $id, ')
          ..write('stepGroupId: $stepGroupId, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }
}

class $IngredientCatalogEntriesTable extends IngredientCatalogEntries
    with TableInfo<$IngredientCatalogEntriesTable, IngredientCatalogEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IngredientCatalogEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, position];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ingredient_catalog_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<IngredientCatalogEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IngredientCatalogEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IngredientCatalogEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  $IngredientCatalogEntriesTable createAlias(String alias) {
    return $IngredientCatalogEntriesTable(attachedDatabase, alias);
  }
}

class IngredientCatalogEntry extends DataClass
    implements Insertable<IngredientCatalogEntry> {
  final int id;
  final String name;
  final int position;
  const IngredientCatalogEntry({
    required this.id,
    required this.name,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['position'] = Variable<int>(position);
    return map;
  }

  IngredientCatalogEntriesCompanion toCompanion(bool nullToAbsent) {
    return IngredientCatalogEntriesCompanion(
      id: Value(id),
      name: Value(name),
      position: Value(position),
    );
  }

  factory IngredientCatalogEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IngredientCatalogEntry(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'position': serializer.toJson<int>(position),
    };
  }

  IngredientCatalogEntry copyWith({int? id, String? name, int? position}) =>
      IngredientCatalogEntry(
        id: id ?? this.id,
        name: name ?? this.name,
        position: position ?? this.position,
      );
  IngredientCatalogEntry copyWithCompanion(
    IngredientCatalogEntriesCompanion data,
  ) {
    return IngredientCatalogEntry(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IngredientCatalogEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IngredientCatalogEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.position == this.position);
}

class IngredientCatalogEntriesCompanion
    extends UpdateCompanion<IngredientCatalogEntry> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> position;
  const IngredientCatalogEntriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.position = const Value.absent(),
  });
  IngredientCatalogEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int position,
  }) : name = Value(name),
       position = Value(position);
  static Insertable<IngredientCatalogEntry> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? position,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (position != null) 'position': position,
    });
  }

  IngredientCatalogEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? position,
  }) {
    return IngredientCatalogEntriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      position: position ?? this.position,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IngredientCatalogEntriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }
}

class $NutritionCatalogEntriesTable extends NutritionCatalogEntries
    with TableInfo<$NutritionCatalogEntriesTable, NutritionCatalogEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NutritionCatalogEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, position];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'nutrition_catalog_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<NutritionCatalogEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NutritionCatalogEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NutritionCatalogEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  $NutritionCatalogEntriesTable createAlias(String alias) {
    return $NutritionCatalogEntriesTable(attachedDatabase, alias);
  }
}

class NutritionCatalogEntry extends DataClass
    implements Insertable<NutritionCatalogEntry> {
  final int id;
  final String name;
  final int position;
  const NutritionCatalogEntry({
    required this.id,
    required this.name,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['position'] = Variable<int>(position);
    return map;
  }

  NutritionCatalogEntriesCompanion toCompanion(bool nullToAbsent) {
    return NutritionCatalogEntriesCompanion(
      id: Value(id),
      name: Value(name),
      position: Value(position),
    );
  }

  factory NutritionCatalogEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NutritionCatalogEntry(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'position': serializer.toJson<int>(position),
    };
  }

  NutritionCatalogEntry copyWith({int? id, String? name, int? position}) =>
      NutritionCatalogEntry(
        id: id ?? this.id,
        name: name ?? this.name,
        position: position ?? this.position,
      );
  NutritionCatalogEntry copyWithCompanion(
    NutritionCatalogEntriesCompanion data,
  ) {
    return NutritionCatalogEntry(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NutritionCatalogEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NutritionCatalogEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.position == this.position);
}

class NutritionCatalogEntriesCompanion
    extends UpdateCompanion<NutritionCatalogEntry> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> position;
  const NutritionCatalogEntriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.position = const Value.absent(),
  });
  NutritionCatalogEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int position,
  }) : name = Value(name),
       position = Value(position);
  static Insertable<NutritionCatalogEntry> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? position,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (position != null) 'position': position,
    });
  }

  NutritionCatalogEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? position,
  }) {
    return NutritionCatalogEntriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      position: position ?? this.position,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NutritionCatalogEntriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }
}

class $CalendarEntriesTable extends CalendarEntries
    with TableInfo<$CalendarEntriesTable, CalendarEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CalendarEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _scheduledAtMeta = const VerificationMeta(
    'scheduledAt',
  );
  @override
  late final GeneratedColumn<String> scheduledAt = GeneratedColumn<String>(
    'scheduled_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recipeNameMeta = const VerificationMeta(
    'recipeName',
  );
  @override
  late final GeneratedColumn<String> recipeName = GeneratedColumn<String>(
    'recipe_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, scheduledAt, recipeName, position];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'calendar_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<CalendarEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('scheduled_at')) {
      context.handle(
        _scheduledAtMeta,
        scheduledAt.isAcceptableOrUnknown(
          data['scheduled_at']!,
          _scheduledAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledAtMeta);
    }
    if (data.containsKey('recipe_name')) {
      context.handle(
        _recipeNameMeta,
        recipeName.isAcceptableOrUnknown(data['recipe_name']!, _recipeNameMeta),
      );
    } else if (isInserting) {
      context.missing(_recipeNameMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CalendarEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CalendarEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      scheduledAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scheduled_at'],
      )!,
      recipeName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recipe_name'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  $CalendarEntriesTable createAlias(String alias) {
    return $CalendarEntriesTable(attachedDatabase, alias);
  }
}

class CalendarEntry extends DataClass implements Insertable<CalendarEntry> {
  final int id;
  final String scheduledAt;
  final String recipeName;
  final int position;
  const CalendarEntry({
    required this.id,
    required this.scheduledAt,
    required this.recipeName,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['scheduled_at'] = Variable<String>(scheduledAt);
    map['recipe_name'] = Variable<String>(recipeName);
    map['position'] = Variable<int>(position);
    return map;
  }

  CalendarEntriesCompanion toCompanion(bool nullToAbsent) {
    return CalendarEntriesCompanion(
      id: Value(id),
      scheduledAt: Value(scheduledAt),
      recipeName: Value(recipeName),
      position: Value(position),
    );
  }

  factory CalendarEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CalendarEntry(
      id: serializer.fromJson<int>(json['id']),
      scheduledAt: serializer.fromJson<String>(json['scheduledAt']),
      recipeName: serializer.fromJson<String>(json['recipeName']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'scheduledAt': serializer.toJson<String>(scheduledAt),
      'recipeName': serializer.toJson<String>(recipeName),
      'position': serializer.toJson<int>(position),
    };
  }

  CalendarEntry copyWith({
    int? id,
    String? scheduledAt,
    String? recipeName,
    int? position,
  }) => CalendarEntry(
    id: id ?? this.id,
    scheduledAt: scheduledAt ?? this.scheduledAt,
    recipeName: recipeName ?? this.recipeName,
    position: position ?? this.position,
  );
  CalendarEntry copyWithCompanion(CalendarEntriesCompanion data) {
    return CalendarEntry(
      id: data.id.present ? data.id.value : this.id,
      scheduledAt: data.scheduledAt.present
          ? data.scheduledAt.value
          : this.scheduledAt,
      recipeName: data.recipeName.present
          ? data.recipeName.value
          : this.recipeName,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CalendarEntry(')
          ..write('id: $id, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('recipeName: $recipeName, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, scheduledAt, recipeName, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CalendarEntry &&
          other.id == this.id &&
          other.scheduledAt == this.scheduledAt &&
          other.recipeName == this.recipeName &&
          other.position == this.position);
}

class CalendarEntriesCompanion extends UpdateCompanion<CalendarEntry> {
  final Value<int> id;
  final Value<String> scheduledAt;
  final Value<String> recipeName;
  final Value<int> position;
  const CalendarEntriesCompanion({
    this.id = const Value.absent(),
    this.scheduledAt = const Value.absent(),
    this.recipeName = const Value.absent(),
    this.position = const Value.absent(),
  });
  CalendarEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String scheduledAt,
    required String recipeName,
    required int position,
  }) : scheduledAt = Value(scheduledAt),
       recipeName = Value(recipeName),
       position = Value(position);
  static Insertable<CalendarEntry> custom({
    Expression<int>? id,
    Expression<String>? scheduledAt,
    Expression<String>? recipeName,
    Expression<int>? position,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (scheduledAt != null) 'scheduled_at': scheduledAt,
      if (recipeName != null) 'recipe_name': recipeName,
      if (position != null) 'position': position,
    });
  }

  CalendarEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? scheduledAt,
    Value<String>? recipeName,
    Value<int>? position,
  }) {
    return CalendarEntriesCompanion(
      id: id ?? this.id,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      recipeName: recipeName ?? this.recipeName,
      position: position ?? this.position,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (scheduledAt.present) {
      map['scheduled_at'] = Variable<String>(scheduledAt.value);
    }
    if (recipeName.present) {
      map['recipe_name'] = Variable<String>(recipeName.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CalendarEntriesCompanion(')
          ..write('id: $id, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('recipeName: $recipeName, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }
}

class $ShoppingSourcesTable extends ShoppingSources
    with TableInfo<$ShoppingSourcesTable, ShoppingSource> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShoppingSourcesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _sourceKeyMeta = const VerificationMeta(
    'sourceKey',
  );
  @override
  late final GeneratedColumn<String> sourceKey = GeneratedColumn<String>(
    'source_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSummaryMeta = const VerificationMeta(
    'isSummary',
  );
  @override
  late final GeneratedColumn<bool> isSummary = GeneratedColumn<bool>(
    'is_summary',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_summary" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _currentServingsMeta = const VerificationMeta(
    'currentServings',
  );
  @override
  late final GeneratedColumn<double> currentServings = GeneratedColumn<double>(
    'current_servings',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sourceKey,
    displayName,
    isSummary,
    currentServings,
    position,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shopping_sources';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShoppingSource> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('source_key')) {
      context.handle(
        _sourceKeyMeta,
        sourceKey.isAcceptableOrUnknown(data['source_key']!, _sourceKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceKeyMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('is_summary')) {
      context.handle(
        _isSummaryMeta,
        isSummary.isAcceptableOrUnknown(data['is_summary']!, _isSummaryMeta),
      );
    }
    if (data.containsKey('current_servings')) {
      context.handle(
        _currentServingsMeta,
        currentServings.isAcceptableOrUnknown(
          data['current_servings']!,
          _currentServingsMeta,
        ),
      );
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShoppingSource map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShoppingSource(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sourceKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_key'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      isSummary: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_summary'],
      )!,
      currentServings: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}current_servings'],
      ),
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  $ShoppingSourcesTable createAlias(String alias) {
    return $ShoppingSourcesTable(attachedDatabase, alias);
  }
}

class ShoppingSource extends DataClass implements Insertable<ShoppingSource> {
  final int id;
  final String sourceKey;
  final String displayName;
  final bool isSummary;
  final double? currentServings;
  final int position;
  const ShoppingSource({
    required this.id,
    required this.sourceKey,
    required this.displayName,
    required this.isSummary,
    this.currentServings,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['source_key'] = Variable<String>(sourceKey);
    map['display_name'] = Variable<String>(displayName);
    map['is_summary'] = Variable<bool>(isSummary);
    if (!nullToAbsent || currentServings != null) {
      map['current_servings'] = Variable<double>(currentServings);
    }
    map['position'] = Variable<int>(position);
    return map;
  }

  ShoppingSourcesCompanion toCompanion(bool nullToAbsent) {
    return ShoppingSourcesCompanion(
      id: Value(id),
      sourceKey: Value(sourceKey),
      displayName: Value(displayName),
      isSummary: Value(isSummary),
      currentServings: currentServings == null && nullToAbsent
          ? const Value.absent()
          : Value(currentServings),
      position: Value(position),
    );
  }

  factory ShoppingSource.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShoppingSource(
      id: serializer.fromJson<int>(json['id']),
      sourceKey: serializer.fromJson<String>(json['sourceKey']),
      displayName: serializer.fromJson<String>(json['displayName']),
      isSummary: serializer.fromJson<bool>(json['isSummary']),
      currentServings: serializer.fromJson<double?>(json['currentServings']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sourceKey': serializer.toJson<String>(sourceKey),
      'displayName': serializer.toJson<String>(displayName),
      'isSummary': serializer.toJson<bool>(isSummary),
      'currentServings': serializer.toJson<double?>(currentServings),
      'position': serializer.toJson<int>(position),
    };
  }

  ShoppingSource copyWith({
    int? id,
    String? sourceKey,
    String? displayName,
    bool? isSummary,
    Value<double?> currentServings = const Value.absent(),
    int? position,
  }) => ShoppingSource(
    id: id ?? this.id,
    sourceKey: sourceKey ?? this.sourceKey,
    displayName: displayName ?? this.displayName,
    isSummary: isSummary ?? this.isSummary,
    currentServings: currentServings.present
        ? currentServings.value
        : this.currentServings,
    position: position ?? this.position,
  );
  ShoppingSource copyWithCompanion(ShoppingSourcesCompanion data) {
    return ShoppingSource(
      id: data.id.present ? data.id.value : this.id,
      sourceKey: data.sourceKey.present ? data.sourceKey.value : this.sourceKey,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      isSummary: data.isSummary.present ? data.isSummary.value : this.isSummary,
      currentServings: data.currentServings.present
          ? data.currentServings.value
          : this.currentServings,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingSource(')
          ..write('id: $id, ')
          ..write('sourceKey: $sourceKey, ')
          ..write('displayName: $displayName, ')
          ..write('isSummary: $isSummary, ')
          ..write('currentServings: $currentServings, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sourceKey,
    displayName,
    isSummary,
    currentServings,
    position,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShoppingSource &&
          other.id == this.id &&
          other.sourceKey == this.sourceKey &&
          other.displayName == this.displayName &&
          other.isSummary == this.isSummary &&
          other.currentServings == this.currentServings &&
          other.position == this.position);
}

class ShoppingSourcesCompanion extends UpdateCompanion<ShoppingSource> {
  final Value<int> id;
  final Value<String> sourceKey;
  final Value<String> displayName;
  final Value<bool> isSummary;
  final Value<double?> currentServings;
  final Value<int> position;
  const ShoppingSourcesCompanion({
    this.id = const Value.absent(),
    this.sourceKey = const Value.absent(),
    this.displayName = const Value.absent(),
    this.isSummary = const Value.absent(),
    this.currentServings = const Value.absent(),
    this.position = const Value.absent(),
  });
  ShoppingSourcesCompanion.insert({
    this.id = const Value.absent(),
    required String sourceKey,
    required String displayName,
    this.isSummary = const Value.absent(),
    this.currentServings = const Value.absent(),
    required int position,
  }) : sourceKey = Value(sourceKey),
       displayName = Value(displayName),
       position = Value(position);
  static Insertable<ShoppingSource> custom({
    Expression<int>? id,
    Expression<String>? sourceKey,
    Expression<String>? displayName,
    Expression<bool>? isSummary,
    Expression<double>? currentServings,
    Expression<int>? position,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceKey != null) 'source_key': sourceKey,
      if (displayName != null) 'display_name': displayName,
      if (isSummary != null) 'is_summary': isSummary,
      if (currentServings != null) 'current_servings': currentServings,
      if (position != null) 'position': position,
    });
  }

  ShoppingSourcesCompanion copyWith({
    Value<int>? id,
    Value<String>? sourceKey,
    Value<String>? displayName,
    Value<bool>? isSummary,
    Value<double?>? currentServings,
    Value<int>? position,
  }) {
    return ShoppingSourcesCompanion(
      id: id ?? this.id,
      sourceKey: sourceKey ?? this.sourceKey,
      displayName: displayName ?? this.displayName,
      isSummary: isSummary ?? this.isSummary,
      currentServings: currentServings ?? this.currentServings,
      position: position ?? this.position,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sourceKey.present) {
      map['source_key'] = Variable<String>(sourceKey.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (isSummary.present) {
      map['is_summary'] = Variable<bool>(isSummary.value);
    }
    if (currentServings.present) {
      map['current_servings'] = Variable<double>(currentServings.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingSourcesCompanion(')
          ..write('id: $id, ')
          ..write('sourceKey: $sourceKey, ')
          ..write('displayName: $displayName, ')
          ..write('isSummary: $isSummary, ')
          ..write('currentServings: $currentServings, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }
}

class $ShoppingItemsTable extends ShoppingItems
    with TableInfo<$ShoppingItemsTable, ShoppingItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShoppingItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _sourceIdMeta = const VerificationMeta(
    'sourceId',
  );
  @override
  late final GeneratedColumn<int> sourceId = GeneratedColumn<int>(
    'source_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES shopping_sources (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
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
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _checkedMeta = const VerificationMeta(
    'checked',
  );
  @override
  late final GeneratedColumn<bool> checked = GeneratedColumn<bool>(
    'checked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("checked" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sourceId,
    position,
    name,
    amount,
    unit,
    checked,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shopping_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShoppingItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('source_id')) {
      context.handle(
        _sourceIdMeta,
        sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    }
    if (data.containsKey('checked')) {
      context.handle(
        _checkedMeta,
        checked.isAcceptableOrUnknown(data['checked']!, _checkedMeta),
      );
    } else if (isInserting) {
      context.missing(_checkedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShoppingItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShoppingItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}source_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      ),
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      ),
      checked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}checked'],
      )!,
    );
  }

  @override
  $ShoppingItemsTable createAlias(String alias) {
    return $ShoppingItemsTable(attachedDatabase, alias);
  }
}

class ShoppingItem extends DataClass implements Insertable<ShoppingItem> {
  final int id;
  final int sourceId;
  final int position;
  final String name;
  final double? amount;
  final String? unit;
  final bool checked;
  const ShoppingItem({
    required this.id,
    required this.sourceId,
    required this.position,
    required this.name,
    this.amount,
    this.unit,
    required this.checked,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['source_id'] = Variable<int>(sourceId);
    map['position'] = Variable<int>(position);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || amount != null) {
      map['amount'] = Variable<double>(amount);
    }
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    map['checked'] = Variable<bool>(checked);
    return map;
  }

  ShoppingItemsCompanion toCompanion(bool nullToAbsent) {
    return ShoppingItemsCompanion(
      id: Value(id),
      sourceId: Value(sourceId),
      position: Value(position),
      name: Value(name),
      amount: amount == null && nullToAbsent
          ? const Value.absent()
          : Value(amount),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      checked: Value(checked),
    );
  }

  factory ShoppingItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShoppingItem(
      id: serializer.fromJson<int>(json['id']),
      sourceId: serializer.fromJson<int>(json['sourceId']),
      position: serializer.fromJson<int>(json['position']),
      name: serializer.fromJson<String>(json['name']),
      amount: serializer.fromJson<double?>(json['amount']),
      unit: serializer.fromJson<String?>(json['unit']),
      checked: serializer.fromJson<bool>(json['checked']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sourceId': serializer.toJson<int>(sourceId),
      'position': serializer.toJson<int>(position),
      'name': serializer.toJson<String>(name),
      'amount': serializer.toJson<double?>(amount),
      'unit': serializer.toJson<String?>(unit),
      'checked': serializer.toJson<bool>(checked),
    };
  }

  ShoppingItem copyWith({
    int? id,
    int? sourceId,
    int? position,
    String? name,
    Value<double?> amount = const Value.absent(),
    Value<String?> unit = const Value.absent(),
    bool? checked,
  }) => ShoppingItem(
    id: id ?? this.id,
    sourceId: sourceId ?? this.sourceId,
    position: position ?? this.position,
    name: name ?? this.name,
    amount: amount.present ? amount.value : this.amount,
    unit: unit.present ? unit.value : this.unit,
    checked: checked ?? this.checked,
  );
  ShoppingItem copyWithCompanion(ShoppingItemsCompanion data) {
    return ShoppingItem(
      id: data.id.present ? data.id.value : this.id,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      position: data.position.present ? data.position.value : this.position,
      name: data.name.present ? data.name.value : this.name,
      amount: data.amount.present ? data.amount.value : this.amount,
      unit: data.unit.present ? data.unit.value : this.unit,
      checked: data.checked.present ? data.checked.value : this.checked,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingItem(')
          ..write('id: $id, ')
          ..write('sourceId: $sourceId, ')
          ..write('position: $position, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('unit: $unit, ')
          ..write('checked: $checked')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, sourceId, position, name, amount, unit, checked);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShoppingItem &&
          other.id == this.id &&
          other.sourceId == this.sourceId &&
          other.position == this.position &&
          other.name == this.name &&
          other.amount == this.amount &&
          other.unit == this.unit &&
          other.checked == this.checked);
}

class ShoppingItemsCompanion extends UpdateCompanion<ShoppingItem> {
  final Value<int> id;
  final Value<int> sourceId;
  final Value<int> position;
  final Value<String> name;
  final Value<double?> amount;
  final Value<String?> unit;
  final Value<bool> checked;
  const ShoppingItemsCompanion({
    this.id = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.position = const Value.absent(),
    this.name = const Value.absent(),
    this.amount = const Value.absent(),
    this.unit = const Value.absent(),
    this.checked = const Value.absent(),
  });
  ShoppingItemsCompanion.insert({
    this.id = const Value.absent(),
    required int sourceId,
    required int position,
    required String name,
    this.amount = const Value.absent(),
    this.unit = const Value.absent(),
    required bool checked,
  }) : sourceId = Value(sourceId),
       position = Value(position),
       name = Value(name),
       checked = Value(checked);
  static Insertable<ShoppingItem> custom({
    Expression<int>? id,
    Expression<int>? sourceId,
    Expression<int>? position,
    Expression<String>? name,
    Expression<double>? amount,
    Expression<String>? unit,
    Expression<bool>? checked,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceId != null) 'source_id': sourceId,
      if (position != null) 'position': position,
      if (name != null) 'name': name,
      if (amount != null) 'amount': amount,
      if (unit != null) 'unit': unit,
      if (checked != null) 'checked': checked,
    });
  }

  ShoppingItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? sourceId,
    Value<int>? position,
    Value<String>? name,
    Value<double?>? amount,
    Value<String?>? unit,
    Value<bool>? checked,
  }) {
    return ShoppingItemsCompanion(
      id: id ?? this.id,
      sourceId: sourceId ?? this.sourceId,
      position: position ?? this.position,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      unit: unit ?? this.unit,
      checked: checked ?? this.checked,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<int>(sourceId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (checked.present) {
      map['checked'] = Variable<bool>(checked.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingItemsCompanion(')
          ..write('id: $id, ')
          ..write('sourceId: $sourceId, ')
          ..write('position: $position, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('unit: $unit, ')
          ..write('checked: $checked')
          ..write(')'))
        .toString();
  }
}

class $RecipeDraftsTable extends RecipeDrafts
    with TableInfo<$RecipeDraftsTable, RecipeDraft> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipeDraftsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _slotMeta = const VerificationMeta('slot');
  @override
  late final GeneratedColumn<String> slot = GeneratedColumn<String>(
    'slot',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codecVersionMeta = const VerificationMeta(
    'codecVersion',
  );
  @override
  late final GeneratedColumn<int> codecVersion = GeneratedColumn<int>(
    'codec_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [slot, codecVersion, payload];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipe_drafts';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecipeDraft> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('slot')) {
      context.handle(
        _slotMeta,
        slot.isAcceptableOrUnknown(data['slot']!, _slotMeta),
      );
    } else if (isInserting) {
      context.missing(_slotMeta);
    }
    if (data.containsKey('codec_version')) {
      context.handle(
        _codecVersionMeta,
        codecVersion.isAcceptableOrUnknown(
          data['codec_version']!,
          _codecVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_codecVersionMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {slot};
  @override
  RecipeDraft map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecipeDraft(
      slot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}slot'],
      )!,
      codecVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}codec_version'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
    );
  }

  @override
  $RecipeDraftsTable createAlias(String alias) {
    return $RecipeDraftsTable(attachedDatabase, alias);
  }
}

class RecipeDraft extends DataClass implements Insertable<RecipeDraft> {
  final String slot;
  final int codecVersion;
  final String payload;
  const RecipeDraft({
    required this.slot,
    required this.codecVersion,
    required this.payload,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['slot'] = Variable<String>(slot);
    map['codec_version'] = Variable<int>(codecVersion);
    map['payload'] = Variable<String>(payload);
    return map;
  }

  RecipeDraftsCompanion toCompanion(bool nullToAbsent) {
    return RecipeDraftsCompanion(
      slot: Value(slot),
      codecVersion: Value(codecVersion),
      payload: Value(payload),
    );
  }

  factory RecipeDraft.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecipeDraft(
      slot: serializer.fromJson<String>(json['slot']),
      codecVersion: serializer.fromJson<int>(json['codecVersion']),
      payload: serializer.fromJson<String>(json['payload']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'slot': serializer.toJson<String>(slot),
      'codecVersion': serializer.toJson<int>(codecVersion),
      'payload': serializer.toJson<String>(payload),
    };
  }

  RecipeDraft copyWith({String? slot, int? codecVersion, String? payload}) =>
      RecipeDraft(
        slot: slot ?? this.slot,
        codecVersion: codecVersion ?? this.codecVersion,
        payload: payload ?? this.payload,
      );
  RecipeDraft copyWithCompanion(RecipeDraftsCompanion data) {
    return RecipeDraft(
      slot: data.slot.present ? data.slot.value : this.slot,
      codecVersion: data.codecVersion.present
          ? data.codecVersion.value
          : this.codecVersion,
      payload: data.payload.present ? data.payload.value : this.payload,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecipeDraft(')
          ..write('slot: $slot, ')
          ..write('codecVersion: $codecVersion, ')
          ..write('payload: $payload')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(slot, codecVersion, payload);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecipeDraft &&
          other.slot == this.slot &&
          other.codecVersion == this.codecVersion &&
          other.payload == this.payload);
}

class RecipeDraftsCompanion extends UpdateCompanion<RecipeDraft> {
  final Value<String> slot;
  final Value<int> codecVersion;
  final Value<String> payload;
  final Value<int> rowid;
  const RecipeDraftsCompanion({
    this.slot = const Value.absent(),
    this.codecVersion = const Value.absent(),
    this.payload = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecipeDraftsCompanion.insert({
    required String slot,
    required int codecVersion,
    required String payload,
    this.rowid = const Value.absent(),
  }) : slot = Value(slot),
       codecVersion = Value(codecVersion),
       payload = Value(payload);
  static Insertable<RecipeDraft> custom({
    Expression<String>? slot,
    Expression<int>? codecVersion,
    Expression<String>? payload,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (slot != null) 'slot': slot,
      if (codecVersion != null) 'codec_version': codecVersion,
      if (payload != null) 'payload': payload,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecipeDraftsCompanion copyWith({
    Value<String>? slot,
    Value<int>? codecVersion,
    Value<String>? payload,
    Value<int>? rowid,
  }) {
    return RecipeDraftsCompanion(
      slot: slot ?? this.slot,
      codecVersion: codecVersion ?? this.codecVersion,
      payload: payload ?? this.payload,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (slot.present) {
      map['slot'] = Variable<String>(slot.value);
    }
    if (codecVersion.present) {
      map['codec_version'] = Variable<int>(codecVersion.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipeDraftsCompanion(')
          ..write('slot: $slot, ')
          ..write('codecVersion: $codecVersion, ')
          ..write('payload: $payload, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DeletionTombstonesTable extends DeletionTombstones
    with TableInfo<$DeletionTombstonesTable, DeletionTombstone> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeletionTombstonesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _recipeNameMeta = const VerificationMeta(
    'recipeName',
  );
  @override
  late final GeneratedColumn<String> recipeName = GeneratedColumn<String>(
    'recipe_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<String> deletedAt = GeneratedColumn<String>(
    'deleted_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [recipeName, deletedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'deletion_tombstones';
  @override
  VerificationContext validateIntegrity(
    Insertable<DeletionTombstone> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('recipe_name')) {
      context.handle(
        _recipeNameMeta,
        recipeName.isAcceptableOrUnknown(data['recipe_name']!, _recipeNameMeta),
      );
    } else if (isInserting) {
      context.missing(_recipeNameMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_deletedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {recipeName};
  @override
  DeletionTombstone map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeletionTombstone(
      recipeName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recipe_name'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}deleted_at'],
      )!,
    );
  }

  @override
  $DeletionTombstonesTable createAlias(String alias) {
    return $DeletionTombstonesTable(attachedDatabase, alias);
  }
}

class DeletionTombstone extends DataClass
    implements Insertable<DeletionTombstone> {
  final String recipeName;
  final String deletedAt;
  const DeletionTombstone({required this.recipeName, required this.deletedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['recipe_name'] = Variable<String>(recipeName);
    map['deleted_at'] = Variable<String>(deletedAt);
    return map;
  }

  DeletionTombstonesCompanion toCompanion(bool nullToAbsent) {
    return DeletionTombstonesCompanion(
      recipeName: Value(recipeName),
      deletedAt: Value(deletedAt),
    );
  }

  factory DeletionTombstone.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeletionTombstone(
      recipeName: serializer.fromJson<String>(json['recipeName']),
      deletedAt: serializer.fromJson<String>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'recipeName': serializer.toJson<String>(recipeName),
      'deletedAt': serializer.toJson<String>(deletedAt),
    };
  }

  DeletionTombstone copyWith({String? recipeName, String? deletedAt}) =>
      DeletionTombstone(
        recipeName: recipeName ?? this.recipeName,
        deletedAt: deletedAt ?? this.deletedAt,
      );
  DeletionTombstone copyWithCompanion(DeletionTombstonesCompanion data) {
    return DeletionTombstone(
      recipeName: data.recipeName.present
          ? data.recipeName.value
          : this.recipeName,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DeletionTombstone(')
          ..write('recipeName: $recipeName, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(recipeName, deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeletionTombstone &&
          other.recipeName == this.recipeName &&
          other.deletedAt == this.deletedAt);
}

class DeletionTombstonesCompanion extends UpdateCompanion<DeletionTombstone> {
  final Value<String> recipeName;
  final Value<String> deletedAt;
  final Value<int> rowid;
  const DeletionTombstonesCompanion({
    this.recipeName = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DeletionTombstonesCompanion.insert({
    required String recipeName,
    required String deletedAt,
    this.rowid = const Value.absent(),
  }) : recipeName = Value(recipeName),
       deletedAt = Value(deletedAt);
  static Insertable<DeletionTombstone> custom({
    Expression<String>? recipeName,
    Expression<String>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (recipeName != null) 'recipe_name': recipeName,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DeletionTombstonesCompanion copyWith({
    Value<String>? recipeName,
    Value<String>? deletedAt,
    Value<int>? rowid,
  }) {
    return DeletionTombstonesCompanion(
      recipeName: recipeName ?? this.recipeName,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (recipeName.present) {
      map['recipe_name'] = Variable<String>(recipeName.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<String>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeletionTombstonesCompanion(')
          ..write('recipeName: $recipeName, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StorageMetadataTable extends StorageMetadata
    with TableInfo<$StorageMetadataTable, StorageMetadataData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StorageMetadataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'storage_metadata';
  @override
  VerificationContext validateIntegrity(
    Insertable<StorageMetadataData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  StorageMetadataData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StorageMetadataData(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $StorageMetadataTable createAlias(String alias) {
    return $StorageMetadataTable(attachedDatabase, alias);
  }
}

class StorageMetadataData extends DataClass
    implements Insertable<StorageMetadataData> {
  final String key;
  final String value;
  const StorageMetadataData({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  StorageMetadataCompanion toCompanion(bool nullToAbsent) {
    return StorageMetadataCompanion(key: Value(key), value: Value(value));
  }

  factory StorageMetadataData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StorageMetadataData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  StorageMetadataData copyWith({String? key, String? value}) =>
      StorageMetadataData(key: key ?? this.key, value: value ?? this.value);
  StorageMetadataData copyWithCompanion(StorageMetadataCompanion data) {
    return StorageMetadataData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StorageMetadataData(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StorageMetadataData &&
          other.key == this.key &&
          other.value == this.value);
}

class StorageMetadataCompanion extends UpdateCompanion<StorageMetadataData> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const StorageMetadataCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StorageMetadataCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<StorageMetadataData> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StorageMetadataCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return StorageMetadataCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StorageMetadataCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LegacyMigrationIssuesTable extends LegacyMigrationIssues
    with TableInfo<$LegacyMigrationIssuesTable, LegacyMigrationIssue> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LegacyMigrationIssuesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _legacyKeyMeta = const VerificationMeta(
    'legacyKey',
  );
  @override
  late final GeneratedColumn<String> legacyKey = GeneratedColumn<String>(
    'legacy_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _errorCodeMeta = const VerificationMeta(
    'errorCode',
  );
  @override
  late final GeneratedColumn<String> errorCode = GeneratedColumn<String>(
    'error_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _resolvedMeta = const VerificationMeta(
    'resolved',
  );
  @override
  late final GeneratedColumn<bool> resolved = GeneratedColumn<bool>(
    'resolved',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("resolved" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [legacyKey, errorCode, resolved];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'legacy_migration_issues';
  @override
  VerificationContext validateIntegrity(
    Insertable<LegacyMigrationIssue> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('legacy_key')) {
      context.handle(
        _legacyKeyMeta,
        legacyKey.isAcceptableOrUnknown(data['legacy_key']!, _legacyKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_legacyKeyMeta);
    }
    if (data.containsKey('error_code')) {
      context.handle(
        _errorCodeMeta,
        errorCode.isAcceptableOrUnknown(data['error_code']!, _errorCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_errorCodeMeta);
    }
    if (data.containsKey('resolved')) {
      context.handle(
        _resolvedMeta,
        resolved.isAcceptableOrUnknown(data['resolved']!, _resolvedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {legacyKey};
  @override
  LegacyMigrationIssue map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LegacyMigrationIssue(
      legacyKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}legacy_key'],
      )!,
      errorCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_code'],
      )!,
      resolved: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}resolved'],
      )!,
    );
  }

  @override
  $LegacyMigrationIssuesTable createAlias(String alias) {
    return $LegacyMigrationIssuesTable(attachedDatabase, alias);
  }
}

class LegacyMigrationIssue extends DataClass
    implements Insertable<LegacyMigrationIssue> {
  final String legacyKey;
  final String errorCode;
  final bool resolved;
  const LegacyMigrationIssue({
    required this.legacyKey,
    required this.errorCode,
    required this.resolved,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['legacy_key'] = Variable<String>(legacyKey);
    map['error_code'] = Variable<String>(errorCode);
    map['resolved'] = Variable<bool>(resolved);
    return map;
  }

  LegacyMigrationIssuesCompanion toCompanion(bool nullToAbsent) {
    return LegacyMigrationIssuesCompanion(
      legacyKey: Value(legacyKey),
      errorCode: Value(errorCode),
      resolved: Value(resolved),
    );
  }

  factory LegacyMigrationIssue.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LegacyMigrationIssue(
      legacyKey: serializer.fromJson<String>(json['legacyKey']),
      errorCode: serializer.fromJson<String>(json['errorCode']),
      resolved: serializer.fromJson<bool>(json['resolved']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'legacyKey': serializer.toJson<String>(legacyKey),
      'errorCode': serializer.toJson<String>(errorCode),
      'resolved': serializer.toJson<bool>(resolved),
    };
  }

  LegacyMigrationIssue copyWith({
    String? legacyKey,
    String? errorCode,
    bool? resolved,
  }) => LegacyMigrationIssue(
    legacyKey: legacyKey ?? this.legacyKey,
    errorCode: errorCode ?? this.errorCode,
    resolved: resolved ?? this.resolved,
  );
  LegacyMigrationIssue copyWithCompanion(LegacyMigrationIssuesCompanion data) {
    return LegacyMigrationIssue(
      legacyKey: data.legacyKey.present ? data.legacyKey.value : this.legacyKey,
      errorCode: data.errorCode.present ? data.errorCode.value : this.errorCode,
      resolved: data.resolved.present ? data.resolved.value : this.resolved,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LegacyMigrationIssue(')
          ..write('legacyKey: $legacyKey, ')
          ..write('errorCode: $errorCode, ')
          ..write('resolved: $resolved')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(legacyKey, errorCode, resolved);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LegacyMigrationIssue &&
          other.legacyKey == this.legacyKey &&
          other.errorCode == this.errorCode &&
          other.resolved == this.resolved);
}

class LegacyMigrationIssuesCompanion
    extends UpdateCompanion<LegacyMigrationIssue> {
  final Value<String> legacyKey;
  final Value<String> errorCode;
  final Value<bool> resolved;
  final Value<int> rowid;
  const LegacyMigrationIssuesCompanion({
    this.legacyKey = const Value.absent(),
    this.errorCode = const Value.absent(),
    this.resolved = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LegacyMigrationIssuesCompanion.insert({
    required String legacyKey,
    required String errorCode,
    this.resolved = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : legacyKey = Value(legacyKey),
       errorCode = Value(errorCode);
  static Insertable<LegacyMigrationIssue> custom({
    Expression<String>? legacyKey,
    Expression<String>? errorCode,
    Expression<bool>? resolved,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (legacyKey != null) 'legacy_key': legacyKey,
      if (errorCode != null) 'error_code': errorCode,
      if (resolved != null) 'resolved': resolved,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LegacyMigrationIssuesCompanion copyWith({
    Value<String>? legacyKey,
    Value<String>? errorCode,
    Value<bool>? resolved,
    Value<int>? rowid,
  }) {
    return LegacyMigrationIssuesCompanion(
      legacyKey: legacyKey ?? this.legacyKey,
      errorCode: errorCode ?? this.errorCode,
      resolved: resolved ?? this.resolved,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (legacyKey.present) {
      map['legacy_key'] = Variable<String>(legacyKey.value);
    }
    if (errorCode.present) {
      map['error_code'] = Variable<String>(errorCode.value);
    }
    if (resolved.present) {
      map['resolved'] = Variable<bool>(resolved.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LegacyMigrationIssuesCompanion(')
          ..write('legacyKey: $legacyKey, ')
          ..write('errorCode: $errorCode, ')
          ..write('resolved: $resolved, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LegacyBackupFilesTable extends LegacyBackupFiles
    with TableInfo<$LegacyBackupFilesTable, LegacyBackupFile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LegacyBackupFilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _byteLengthMeta = const VerificationMeta(
    'byteLength',
  );
  @override
  late final GeneratedColumn<int> byteLength = GeneratedColumn<int>(
    'byte_length',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sha256DigestMeta = const VerificationMeta(
    'sha256Digest',
  );
  @override
  late final GeneratedColumn<String> sha256Digest = GeneratedColumn<String>(
    'sha256_digest',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [path, byteLength, sha256Digest];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'legacy_backup_files';
  @override
  VerificationContext validateIntegrity(
    Insertable<LegacyBackupFile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('path')) {
      context.handle(
        _pathMeta,
        path.isAcceptableOrUnknown(data['path']!, _pathMeta),
      );
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('byte_length')) {
      context.handle(
        _byteLengthMeta,
        byteLength.isAcceptableOrUnknown(data['byte_length']!, _byteLengthMeta),
      );
    } else if (isInserting) {
      context.missing(_byteLengthMeta);
    }
    if (data.containsKey('sha256_digest')) {
      context.handle(
        _sha256DigestMeta,
        sha256Digest.isAcceptableOrUnknown(
          data['sha256_digest']!,
          _sha256DigestMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sha256DigestMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {path};
  @override
  LegacyBackupFile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LegacyBackupFile(
      path: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}path'],
      )!,
      byteLength: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}byte_length'],
      )!,
      sha256Digest: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sha256_digest'],
      )!,
    );
  }

  @override
  $LegacyBackupFilesTable createAlias(String alias) {
    return $LegacyBackupFilesTable(attachedDatabase, alias);
  }
}

class LegacyBackupFile extends DataClass
    implements Insertable<LegacyBackupFile> {
  final String path;
  final int byteLength;
  final String sha256Digest;
  const LegacyBackupFile({
    required this.path,
    required this.byteLength,
    required this.sha256Digest,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['path'] = Variable<String>(path);
    map['byte_length'] = Variable<int>(byteLength);
    map['sha256_digest'] = Variable<String>(sha256Digest);
    return map;
  }

  LegacyBackupFilesCompanion toCompanion(bool nullToAbsent) {
    return LegacyBackupFilesCompanion(
      path: Value(path),
      byteLength: Value(byteLength),
      sha256Digest: Value(sha256Digest),
    );
  }

  factory LegacyBackupFile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LegacyBackupFile(
      path: serializer.fromJson<String>(json['path']),
      byteLength: serializer.fromJson<int>(json['byteLength']),
      sha256Digest: serializer.fromJson<String>(json['sha256Digest']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'path': serializer.toJson<String>(path),
      'byteLength': serializer.toJson<int>(byteLength),
      'sha256Digest': serializer.toJson<String>(sha256Digest),
    };
  }

  LegacyBackupFile copyWith({
    String? path,
    int? byteLength,
    String? sha256Digest,
  }) => LegacyBackupFile(
    path: path ?? this.path,
    byteLength: byteLength ?? this.byteLength,
    sha256Digest: sha256Digest ?? this.sha256Digest,
  );
  LegacyBackupFile copyWithCompanion(LegacyBackupFilesCompanion data) {
    return LegacyBackupFile(
      path: data.path.present ? data.path.value : this.path,
      byteLength: data.byteLength.present
          ? data.byteLength.value
          : this.byteLength,
      sha256Digest: data.sha256Digest.present
          ? data.sha256Digest.value
          : this.sha256Digest,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LegacyBackupFile(')
          ..write('path: $path, ')
          ..write('byteLength: $byteLength, ')
          ..write('sha256Digest: $sha256Digest')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(path, byteLength, sha256Digest);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LegacyBackupFile &&
          other.path == this.path &&
          other.byteLength == this.byteLength &&
          other.sha256Digest == this.sha256Digest);
}

class LegacyBackupFilesCompanion extends UpdateCompanion<LegacyBackupFile> {
  final Value<String> path;
  final Value<int> byteLength;
  final Value<String> sha256Digest;
  final Value<int> rowid;
  const LegacyBackupFilesCompanion({
    this.path = const Value.absent(),
    this.byteLength = const Value.absent(),
    this.sha256Digest = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LegacyBackupFilesCompanion.insert({
    required String path,
    required int byteLength,
    required String sha256Digest,
    this.rowid = const Value.absent(),
  }) : path = Value(path),
       byteLength = Value(byteLength),
       sha256Digest = Value(sha256Digest);
  static Insertable<LegacyBackupFile> custom({
    Expression<String>? path,
    Expression<int>? byteLength,
    Expression<String>? sha256Digest,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (path != null) 'path': path,
      if (byteLength != null) 'byte_length': byteLength,
      if (sha256Digest != null) 'sha256_digest': sha256Digest,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LegacyBackupFilesCompanion copyWith({
    Value<String>? path,
    Value<int>? byteLength,
    Value<String>? sha256Digest,
    Value<int>? rowid,
  }) {
    return LegacyBackupFilesCompanion(
      path: path ?? this.path,
      byteLength: byteLength ?? this.byteLength,
      sha256Digest: sha256Digest ?? this.sha256Digest,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (byteLength.present) {
      map['byte_length'] = Variable<int>(byteLength.value);
    }
    if (sha256Digest.present) {
      map['sha256_digest'] = Variable<String>(sha256Digest.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LegacyBackupFilesCompanion(')
          ..write('path: $path, ')
          ..write('byteLength: $byteLength, ')
          ..write('sha256Digest: $sha256Digest, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $StoredRecipesTable storedRecipes = $StoredRecipesTable(this);
  late final $StoredCategoriesTable storedCategories = $StoredCategoriesTable(
    this,
  );
  late final $StoredRecipeCategoriesTable storedRecipeCategories =
      $StoredRecipeCategoriesTable(this);
  late final $StoredTagsTable storedTags = $StoredTagsTable(this);
  late final $StoredRecipeTagsTable storedRecipeTags = $StoredRecipeTagsTable(
    this,
  );
  late final $StoredIngredientGroupsTable storedIngredientGroups =
      $StoredIngredientGroupsTable(this);
  late final $StoredIngredientsTable storedIngredients =
      $StoredIngredientsTable(this);
  late final $StoredNutritionsTable storedNutritions = $StoredNutritionsTable(
    this,
  );
  late final $StoredStepGroupsTable storedStepGroups = $StoredStepGroupsTable(
    this,
  );
  late final $StoredStepImagesTable storedStepImages = $StoredStepImagesTable(
    this,
  );
  late final $StoredStepIngredientsTable storedStepIngredients =
      $StoredStepIngredientsTable(this);
  late final $IngredientCatalogEntriesTable ingredientCatalogEntries =
      $IngredientCatalogEntriesTable(this);
  late final $NutritionCatalogEntriesTable nutritionCatalogEntries =
      $NutritionCatalogEntriesTable(this);
  late final $CalendarEntriesTable calendarEntries = $CalendarEntriesTable(
    this,
  );
  late final $ShoppingSourcesTable shoppingSources = $ShoppingSourcesTable(
    this,
  );
  late final $ShoppingItemsTable shoppingItems = $ShoppingItemsTable(this);
  late final $RecipeDraftsTable recipeDrafts = $RecipeDraftsTable(this);
  late final $DeletionTombstonesTable deletionTombstones =
      $DeletionTombstonesTable(this);
  late final $StorageMetadataTable storageMetadata = $StorageMetadataTable(
    this,
  );
  late final $LegacyMigrationIssuesTable legacyMigrationIssues =
      $LegacyMigrationIssuesTable(this);
  late final $LegacyBackupFilesTable legacyBackupFiles =
      $LegacyBackupFilesTable(this);
  late final Index storedRecipesFavorite = Index(
    'stored_recipes_favorite',
    'CREATE INDEX stored_recipes_favorite ON stored_recipes (is_favorite)',
  );
  late final Index storedRecipesRating = Index(
    'stored_recipes_rating',
    'CREATE INDEX stored_recipes_rating ON stored_recipes (rating)',
  );
  late final Index storedRecipesVegetable = Index(
    'stored_recipes_vegetable',
    'CREATE INDEX stored_recipes_vegetable ON stored_recipes (vegetable)',
  );
  late final Index storedRecipeCategoriesCategory = Index(
    'stored_recipe_categories_category',
    'CREATE INDEX stored_recipe_categories_category ON stored_recipe_categories (category_id)',
  );
  late final Index storedRecipeCategoriesRecipe = Index(
    'stored_recipe_categories_recipe',
    'CREATE INDEX stored_recipe_categories_recipe ON stored_recipe_categories (recipe_id)',
  );
  late final Index storedRecipeTagsTag = Index(
    'stored_recipe_tags_tag',
    'CREATE INDEX stored_recipe_tags_tag ON stored_recipe_tags (tag_id)',
  );
  late final Index storedRecipeTagsRecipe = Index(
    'stored_recipe_tags_recipe',
    'CREATE INDEX stored_recipe_tags_recipe ON stored_recipe_tags (recipe_id)',
  );
  late final Index calendarEntriesScheduledAt = Index(
    'calendar_entries_scheduled_at',
    'CREATE INDEX calendar_entries_scheduled_at ON calendar_entries (scheduled_at)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    storedRecipes,
    storedCategories,
    storedRecipeCategories,
    storedTags,
    storedRecipeTags,
    storedIngredientGroups,
    storedIngredients,
    storedNutritions,
    storedStepGroups,
    storedStepImages,
    storedStepIngredients,
    ingredientCatalogEntries,
    nutritionCatalogEntries,
    calendarEntries,
    shoppingSources,
    shoppingItems,
    recipeDrafts,
    deletionTombstones,
    storageMetadata,
    legacyMigrationIssues,
    legacyBackupFiles,
    storedRecipesFavorite,
    storedRecipesRating,
    storedRecipesVegetable,
    storedRecipeCategoriesCategory,
    storedRecipeCategoriesRecipe,
    storedRecipeTagsTag,
    storedRecipeTagsRecipe,
    calendarEntriesScheduledAt,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'stored_recipes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('stored_recipe_categories', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'stored_categories',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('stored_recipe_categories', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'stored_recipes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('stored_recipe_tags', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'stored_tags',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('stored_recipe_tags', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'stored_recipes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('stored_ingredient_groups', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'stored_ingredient_groups',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('stored_ingredients', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'stored_recipes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('stored_nutritions', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'stored_recipes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('stored_step_groups', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'stored_step_groups',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('stored_step_images', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'stored_step_groups',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('stored_step_ingredients', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'stored_ingredients',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('stored_step_ingredients', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'shopping_sources',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('shopping_items', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$StoredRecipesTableCreateCompanionBuilder =
    StoredRecipesCompanion Function({
      Value<int> id,
      required String name,
      required String imagePath,
      required String imagePreviewPath,
      required double preparationTime,
      required double cookingTime,
      required double totalTime,
      Value<double?> servings,
      Value<String?> servingName,
      required String vegetable,
      required String notes,
      Value<bool> isFavorite,
      Value<int?> effort,
      required String lastModified,
      Value<int?> rating,
      Value<String?> source,
      required bool hasStepTitles,
    });
typedef $$StoredRecipesTableUpdateCompanionBuilder =
    StoredRecipesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> imagePath,
      Value<String> imagePreviewPath,
      Value<double> preparationTime,
      Value<double> cookingTime,
      Value<double> totalTime,
      Value<double?> servings,
      Value<String?> servingName,
      Value<String> vegetable,
      Value<String> notes,
      Value<bool> isFavorite,
      Value<int?> effort,
      Value<String> lastModified,
      Value<int?> rating,
      Value<String?> source,
      Value<bool> hasStepTitles,
    });

final class $$StoredRecipesTableReferences
    extends BaseReferences<_$AppDatabase, $StoredRecipesTable, StoredRecipe> {
  $$StoredRecipesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $StoredRecipeCategoriesTable,
    List<StoredRecipeCategory>
  >
  _storedRecipeCategoriesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.storedRecipeCategories,
        aliasName: 'stored_recipes__id__stored_recipe_categories__recipe_id',
      );

  $$StoredRecipeCategoriesTableProcessedTableManager
  get storedRecipeCategoriesRefs {
    final manager = $$StoredRecipeCategoriesTableTableManager(
      $_db,
      $_db.storedRecipeCategories,
    ).filter((f) => f.recipeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _storedRecipeCategoriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$StoredRecipeTagsTable, List<StoredRecipeTag>>
  _storedRecipeTagsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.storedRecipeTags,
    aliasName: 'stored_recipes__id__stored_recipe_tags__recipe_id',
  );

  $$StoredRecipeTagsTableProcessedTableManager get storedRecipeTagsRefs {
    final manager = $$StoredRecipeTagsTableTableManager(
      $_db,
      $_db.storedRecipeTags,
    ).filter((f) => f.recipeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _storedRecipeTagsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $StoredIngredientGroupsTable,
    List<StoredIngredientGroup>
  >
  _storedIngredientGroupsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.storedIngredientGroups,
        aliasName: 'stored_recipes__id__stored_ingredient_groups__recipe_id',
      );

  $$StoredIngredientGroupsTableProcessedTableManager
  get storedIngredientGroupsRefs {
    final manager = $$StoredIngredientGroupsTableTableManager(
      $_db,
      $_db.storedIngredientGroups,
    ).filter((f) => f.recipeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _storedIngredientGroupsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$StoredNutritionsTable, List<StoredNutrition>>
  _storedNutritionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.storedNutritions,
    aliasName: 'stored_recipes__id__stored_nutritions__recipe_id',
  );

  $$StoredNutritionsTableProcessedTableManager get storedNutritionsRefs {
    final manager = $$StoredNutritionsTableTableManager(
      $_db,
      $_db.storedNutritions,
    ).filter((f) => f.recipeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _storedNutritionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$StoredStepGroupsTable, List<StoredStepGroup>>
  _storedStepGroupsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.storedStepGroups,
    aliasName: 'stored_recipes__id__stored_step_groups__recipe_id',
  );

  $$StoredStepGroupsTableProcessedTableManager get storedStepGroupsRefs {
    final manager = $$StoredStepGroupsTableTableManager(
      $_db,
      $_db.storedStepGroups,
    ).filter((f) => f.recipeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _storedStepGroupsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$StoredRecipesTableFilterComposer
    extends Composer<_$AppDatabase, $StoredRecipesTable> {
  $$StoredRecipesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePreviewPath => $composableBuilder(
    column: $table.imagePreviewPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get preparationTime => $composableBuilder(
    column: $table.preparationTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cookingTime => $composableBuilder(
    column: $table.cookingTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalTime => $composableBuilder(
    column: $table.totalTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get servings => $composableBuilder(
    column: $table.servings,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get servingName => $composableBuilder(
    column: $table.servingName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vegetable => $composableBuilder(
    column: $table.vegetable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get effort => $composableBuilder(
    column: $table.effort,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasStepTitles => $composableBuilder(
    column: $table.hasStepTitles,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> storedRecipeCategoriesRefs(
    Expression<bool> Function($$StoredRecipeCategoriesTableFilterComposer f) f,
  ) {
    final $$StoredRecipeCategoriesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.storedRecipeCategories,
          getReferencedColumn: (t) => t.recipeId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$StoredRecipeCategoriesTableFilterComposer(
                $db: $db,
                $table: $db.storedRecipeCategories,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> storedRecipeTagsRefs(
    Expression<bool> Function($$StoredRecipeTagsTableFilterComposer f) f,
  ) {
    final $$StoredRecipeTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.storedRecipeTags,
      getReferencedColumn: (t) => t.recipeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoredRecipeTagsTableFilterComposer(
            $db: $db,
            $table: $db.storedRecipeTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> storedIngredientGroupsRefs(
    Expression<bool> Function($$StoredIngredientGroupsTableFilterComposer f) f,
  ) {
    final $$StoredIngredientGroupsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.storedIngredientGroups,
          getReferencedColumn: (t) => t.recipeId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$StoredIngredientGroupsTableFilterComposer(
                $db: $db,
                $table: $db.storedIngredientGroups,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> storedNutritionsRefs(
    Expression<bool> Function($$StoredNutritionsTableFilterComposer f) f,
  ) {
    final $$StoredNutritionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.storedNutritions,
      getReferencedColumn: (t) => t.recipeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoredNutritionsTableFilterComposer(
            $db: $db,
            $table: $db.storedNutritions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> storedStepGroupsRefs(
    Expression<bool> Function($$StoredStepGroupsTableFilterComposer f) f,
  ) {
    final $$StoredStepGroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.storedStepGroups,
      getReferencedColumn: (t) => t.recipeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoredStepGroupsTableFilterComposer(
            $db: $db,
            $table: $db.storedStepGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StoredRecipesTableOrderingComposer
    extends Composer<_$AppDatabase, $StoredRecipesTable> {
  $$StoredRecipesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePreviewPath => $composableBuilder(
    column: $table.imagePreviewPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get preparationTime => $composableBuilder(
    column: $table.preparationTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cookingTime => $composableBuilder(
    column: $table.cookingTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalTime => $composableBuilder(
    column: $table.totalTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get servings => $composableBuilder(
    column: $table.servings,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get servingName => $composableBuilder(
    column: $table.servingName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vegetable => $composableBuilder(
    column: $table.vegetable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get effort => $composableBuilder(
    column: $table.effort,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasStepTitles => $composableBuilder(
    column: $table.hasStepTitles,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StoredRecipesTableAnnotationComposer
    extends Composer<_$AppDatabase, $StoredRecipesTable> {
  $$StoredRecipesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<String> get imagePreviewPath => $composableBuilder(
    column: $table.imagePreviewPath,
    builder: (column) => column,
  );

  GeneratedColumn<double> get preparationTime => $composableBuilder(
    column: $table.preparationTime,
    builder: (column) => column,
  );

  GeneratedColumn<double> get cookingTime => $composableBuilder(
    column: $table.cookingTime,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalTime =>
      $composableBuilder(column: $table.totalTime, builder: (column) => column);

  GeneratedColumn<double> get servings =>
      $composableBuilder(column: $table.servings, builder: (column) => column);

  GeneratedColumn<String> get servingName => $composableBuilder(
    column: $table.servingName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get vegetable =>
      $composableBuilder(column: $table.vegetable, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  GeneratedColumn<int> get effort =>
      $composableBuilder(column: $table.effort, builder: (column) => column);

  GeneratedColumn<String> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => column,
  );

  GeneratedColumn<int> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<bool> get hasStepTitles => $composableBuilder(
    column: $table.hasStepTitles,
    builder: (column) => column,
  );

  Expression<T> storedRecipeCategoriesRefs<T extends Object>(
    Expression<T> Function($$StoredRecipeCategoriesTableAnnotationComposer a) f,
  ) {
    final $$StoredRecipeCategoriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.storedRecipeCategories,
          getReferencedColumn: (t) => t.recipeId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$StoredRecipeCategoriesTableAnnotationComposer(
                $db: $db,
                $table: $db.storedRecipeCategories,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> storedRecipeTagsRefs<T extends Object>(
    Expression<T> Function($$StoredRecipeTagsTableAnnotationComposer a) f,
  ) {
    final $$StoredRecipeTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.storedRecipeTags,
      getReferencedColumn: (t) => t.recipeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoredRecipeTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.storedRecipeTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> storedIngredientGroupsRefs<T extends Object>(
    Expression<T> Function($$StoredIngredientGroupsTableAnnotationComposer a) f,
  ) {
    final $$StoredIngredientGroupsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.storedIngredientGroups,
          getReferencedColumn: (t) => t.recipeId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$StoredIngredientGroupsTableAnnotationComposer(
                $db: $db,
                $table: $db.storedIngredientGroups,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> storedNutritionsRefs<T extends Object>(
    Expression<T> Function($$StoredNutritionsTableAnnotationComposer a) f,
  ) {
    final $$StoredNutritionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.storedNutritions,
      getReferencedColumn: (t) => t.recipeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoredNutritionsTableAnnotationComposer(
            $db: $db,
            $table: $db.storedNutritions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> storedStepGroupsRefs<T extends Object>(
    Expression<T> Function($$StoredStepGroupsTableAnnotationComposer a) f,
  ) {
    final $$StoredStepGroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.storedStepGroups,
      getReferencedColumn: (t) => t.recipeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoredStepGroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.storedStepGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StoredRecipesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StoredRecipesTable,
          StoredRecipe,
          $$StoredRecipesTableFilterComposer,
          $$StoredRecipesTableOrderingComposer,
          $$StoredRecipesTableAnnotationComposer,
          $$StoredRecipesTableCreateCompanionBuilder,
          $$StoredRecipesTableUpdateCompanionBuilder,
          (StoredRecipe, $$StoredRecipesTableReferences),
          StoredRecipe,
          PrefetchHooks Function({
            bool storedRecipeCategoriesRefs,
            bool storedRecipeTagsRefs,
            bool storedIngredientGroupsRefs,
            bool storedNutritionsRefs,
            bool storedStepGroupsRefs,
          })
        > {
  $$StoredRecipesTableTableManager(_$AppDatabase db, $StoredRecipesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StoredRecipesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StoredRecipesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StoredRecipesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> imagePath = const Value.absent(),
                Value<String> imagePreviewPath = const Value.absent(),
                Value<double> preparationTime = const Value.absent(),
                Value<double> cookingTime = const Value.absent(),
                Value<double> totalTime = const Value.absent(),
                Value<double?> servings = const Value.absent(),
                Value<String?> servingName = const Value.absent(),
                Value<String> vegetable = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<int?> effort = const Value.absent(),
                Value<String> lastModified = const Value.absent(),
                Value<int?> rating = const Value.absent(),
                Value<String?> source = const Value.absent(),
                Value<bool> hasStepTitles = const Value.absent(),
              }) => StoredRecipesCompanion(
                id: id,
                name: name,
                imagePath: imagePath,
                imagePreviewPath: imagePreviewPath,
                preparationTime: preparationTime,
                cookingTime: cookingTime,
                totalTime: totalTime,
                servings: servings,
                servingName: servingName,
                vegetable: vegetable,
                notes: notes,
                isFavorite: isFavorite,
                effort: effort,
                lastModified: lastModified,
                rating: rating,
                source: source,
                hasStepTitles: hasStepTitles,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String imagePath,
                required String imagePreviewPath,
                required double preparationTime,
                required double cookingTime,
                required double totalTime,
                Value<double?> servings = const Value.absent(),
                Value<String?> servingName = const Value.absent(),
                required String vegetable,
                required String notes,
                Value<bool> isFavorite = const Value.absent(),
                Value<int?> effort = const Value.absent(),
                required String lastModified,
                Value<int?> rating = const Value.absent(),
                Value<String?> source = const Value.absent(),
                required bool hasStepTitles,
              }) => StoredRecipesCompanion.insert(
                id: id,
                name: name,
                imagePath: imagePath,
                imagePreviewPath: imagePreviewPath,
                preparationTime: preparationTime,
                cookingTime: cookingTime,
                totalTime: totalTime,
                servings: servings,
                servingName: servingName,
                vegetable: vegetable,
                notes: notes,
                isFavorite: isFavorite,
                effort: effort,
                lastModified: lastModified,
                rating: rating,
                source: source,
                hasStepTitles: hasStepTitles,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StoredRecipesTable, StoredRecipe>(table),
                  $$StoredRecipesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                storedRecipeCategoriesRefs = false,
                storedRecipeTagsRefs = false,
                storedIngredientGroupsRefs = false,
                storedNutritionsRefs = false,
                storedStepGroupsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (storedRecipeCategoriesRefs) db.storedRecipeCategories,
                    if (storedRecipeTagsRefs) db.storedRecipeTags,
                    if (storedIngredientGroupsRefs) db.storedIngredientGroups,
                    if (storedNutritionsRefs) db.storedNutritions,
                    if (storedStepGroupsRefs) db.storedStepGroups,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (storedRecipeCategoriesRefs)
                        await $_getPrefetchedData<
                          StoredRecipe,
                          $StoredRecipesTable,
                          StoredRecipeCategory
                        >(
                          currentTable: table,
                          referencedTable: $$StoredRecipesTableReferences
                              ._storedRecipeCategoriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StoredRecipesTableReferences(
                                db,
                                table,
                                p0,
                              ).storedRecipeCategoriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.recipeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (storedRecipeTagsRefs)
                        await $_getPrefetchedData<
                          StoredRecipe,
                          $StoredRecipesTable,
                          StoredRecipeTag
                        >(
                          currentTable: table,
                          referencedTable: $$StoredRecipesTableReferences
                              ._storedRecipeTagsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StoredRecipesTableReferences(
                                db,
                                table,
                                p0,
                              ).storedRecipeTagsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.recipeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (storedIngredientGroupsRefs)
                        await $_getPrefetchedData<
                          StoredRecipe,
                          $StoredRecipesTable,
                          StoredIngredientGroup
                        >(
                          currentTable: table,
                          referencedTable: $$StoredRecipesTableReferences
                              ._storedIngredientGroupsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StoredRecipesTableReferences(
                                db,
                                table,
                                p0,
                              ).storedIngredientGroupsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.recipeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (storedNutritionsRefs)
                        await $_getPrefetchedData<
                          StoredRecipe,
                          $StoredRecipesTable,
                          StoredNutrition
                        >(
                          currentTable: table,
                          referencedTable: $$StoredRecipesTableReferences
                              ._storedNutritionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StoredRecipesTableReferences(
                                db,
                                table,
                                p0,
                              ).storedNutritionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.recipeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (storedStepGroupsRefs)
                        await $_getPrefetchedData<
                          StoredRecipe,
                          $StoredRecipesTable,
                          StoredStepGroup
                        >(
                          currentTable: table,
                          referencedTable: $$StoredRecipesTableReferences
                              ._storedStepGroupsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StoredRecipesTableReferences(
                                db,
                                table,
                                p0,
                              ).storedStepGroupsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.recipeId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$StoredRecipesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StoredRecipesTable,
      StoredRecipe,
      $$StoredRecipesTableFilterComposer,
      $$StoredRecipesTableOrderingComposer,
      $$StoredRecipesTableAnnotationComposer,
      $$StoredRecipesTableCreateCompanionBuilder,
      $$StoredRecipesTableUpdateCompanionBuilder,
      (StoredRecipe, $$StoredRecipesTableReferences),
      StoredRecipe,
      PrefetchHooks Function({
        bool storedRecipeCategoriesRefs,
        bool storedRecipeTagsRefs,
        bool storedIngredientGroupsRefs,
        bool storedNutritionsRefs,
        bool storedStepGroupsRefs,
      })
    >;
typedef $$StoredCategoriesTableCreateCompanionBuilder =
    StoredCategoriesCompanion Function({
      Value<int> id,
      required String name,
      required int position,
      required String sortKind,
      Value<bool> ascending,
      Value<bool> isSystem,
    });
typedef $$StoredCategoriesTableUpdateCompanionBuilder =
    StoredCategoriesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> position,
      Value<String> sortKind,
      Value<bool> ascending,
      Value<bool> isSystem,
    });

final class $$StoredCategoriesTableReferences
    extends
        BaseReferences<_$AppDatabase, $StoredCategoriesTable, StoredCategory> {
  $$StoredCategoriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $StoredRecipeCategoriesTable,
    List<StoredRecipeCategory>
  >
  _storedRecipeCategoriesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.storedRecipeCategories,
        aliasName:
            'stored_categories__id__stored_recipe_categories__category_id',
      );

  $$StoredRecipeCategoriesTableProcessedTableManager
  get storedRecipeCategoriesRefs {
    final manager = $$StoredRecipeCategoriesTableTableManager(
      $_db,
      $_db.storedRecipeCategories,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _storedRecipeCategoriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$StoredCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $StoredCategoriesTable> {
  $$StoredCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sortKind => $composableBuilder(
    column: $table.sortKind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get ascending => $composableBuilder(
    column: $table.ascending,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSystem => $composableBuilder(
    column: $table.isSystem,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> storedRecipeCategoriesRefs(
    Expression<bool> Function($$StoredRecipeCategoriesTableFilterComposer f) f,
  ) {
    final $$StoredRecipeCategoriesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.storedRecipeCategories,
          getReferencedColumn: (t) => t.categoryId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$StoredRecipeCategoriesTableFilterComposer(
                $db: $db,
                $table: $db.storedRecipeCategories,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$StoredCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $StoredCategoriesTable> {
  $$StoredCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sortKind => $composableBuilder(
    column: $table.sortKind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get ascending => $composableBuilder(
    column: $table.ascending,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSystem => $composableBuilder(
    column: $table.isSystem,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StoredCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $StoredCategoriesTable> {
  $$StoredCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get sortKind =>
      $composableBuilder(column: $table.sortKind, builder: (column) => column);

  GeneratedColumn<bool> get ascending =>
      $composableBuilder(column: $table.ascending, builder: (column) => column);

  GeneratedColumn<bool> get isSystem =>
      $composableBuilder(column: $table.isSystem, builder: (column) => column);

  Expression<T> storedRecipeCategoriesRefs<T extends Object>(
    Expression<T> Function($$StoredRecipeCategoriesTableAnnotationComposer a) f,
  ) {
    final $$StoredRecipeCategoriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.storedRecipeCategories,
          getReferencedColumn: (t) => t.categoryId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$StoredRecipeCategoriesTableAnnotationComposer(
                $db: $db,
                $table: $db.storedRecipeCategories,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$StoredCategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StoredCategoriesTable,
          StoredCategory,
          $$StoredCategoriesTableFilterComposer,
          $$StoredCategoriesTableOrderingComposer,
          $$StoredCategoriesTableAnnotationComposer,
          $$StoredCategoriesTableCreateCompanionBuilder,
          $$StoredCategoriesTableUpdateCompanionBuilder,
          (StoredCategory, $$StoredCategoriesTableReferences),
          StoredCategory,
          PrefetchHooks Function({bool storedRecipeCategoriesRefs})
        > {
  $$StoredCategoriesTableTableManager(
    _$AppDatabase db,
    $StoredCategoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StoredCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StoredCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StoredCategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> sortKind = const Value.absent(),
                Value<bool> ascending = const Value.absent(),
                Value<bool> isSystem = const Value.absent(),
              }) => StoredCategoriesCompanion(
                id: id,
                name: name,
                position: position,
                sortKind: sortKind,
                ascending: ascending,
                isSystem: isSystem,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required int position,
                required String sortKind,
                Value<bool> ascending = const Value.absent(),
                Value<bool> isSystem = const Value.absent(),
              }) => StoredCategoriesCompanion.insert(
                id: id,
                name: name,
                position: position,
                sortKind: sortKind,
                ascending: ascending,
                isSystem: isSystem,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StoredCategoriesTable, StoredCategory>(table),
                  $$StoredCategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({storedRecipeCategoriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (storedRecipeCategoriesRefs) db.storedRecipeCategories,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (storedRecipeCategoriesRefs)
                    await $_getPrefetchedData<
                      StoredCategory,
                      $StoredCategoriesTable,
                      StoredRecipeCategory
                    >(
                      currentTable: table,
                      referencedTable: $$StoredCategoriesTableReferences
                          ._storedRecipeCategoriesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$StoredCategoriesTableReferences(
                            db,
                            table,
                            p0,
                          ).storedRecipeCategoriesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.categoryId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$StoredCategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StoredCategoriesTable,
      StoredCategory,
      $$StoredCategoriesTableFilterComposer,
      $$StoredCategoriesTableOrderingComposer,
      $$StoredCategoriesTableAnnotationComposer,
      $$StoredCategoriesTableCreateCompanionBuilder,
      $$StoredCategoriesTableUpdateCompanionBuilder,
      (StoredCategory, $$StoredCategoriesTableReferences),
      StoredCategory,
      PrefetchHooks Function({bool storedRecipeCategoriesRefs})
    >;
typedef $$StoredRecipeCategoriesTableCreateCompanionBuilder =
    StoredRecipeCategoriesCompanion Function({
      Value<int> id,
      required int recipeId,
      required int categoryId,
      required int position,
    });
typedef $$StoredRecipeCategoriesTableUpdateCompanionBuilder =
    StoredRecipeCategoriesCompanion Function({
      Value<int> id,
      Value<int> recipeId,
      Value<int> categoryId,
      Value<int> position,
    });

final class $$StoredRecipeCategoriesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $StoredRecipeCategoriesTable,
          StoredRecipeCategory
        > {
  $$StoredRecipeCategoriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $StoredRecipesTable _recipeIdTable(_$AppDatabase db) => db
      .storedRecipes
      .createAlias('stored_recipe_categories__recipe_id__stored_recipes__id');

  $$StoredRecipesTableProcessedTableManager get recipeId {
    final $_column = $_itemColumn<int>('recipe_id')!;

    final manager = $$StoredRecipesTableTableManager(
      $_db,
      $_db.storedRecipes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recipeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $StoredCategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.storedCategories.createAlias(
        'stored_recipe_categories__category_id__stored_categories__id',
      );

  $$StoredCategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager = $$StoredCategoriesTableTableManager(
      $_db,
      $_db.storedCategories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StoredRecipeCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $StoredRecipeCategoriesTable> {
  $$StoredRecipeCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  $$StoredRecipesTableFilterComposer get recipeId {
    final $$StoredRecipesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.storedRecipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoredRecipesTableFilterComposer(
            $db: $db,
            $table: $db.storedRecipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$StoredCategoriesTableFilterComposer get categoryId {
    final $$StoredCategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.storedCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoredCategoriesTableFilterComposer(
            $db: $db,
            $table: $db.storedCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StoredRecipeCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $StoredRecipeCategoriesTable> {
  $$StoredRecipeCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  $$StoredRecipesTableOrderingComposer get recipeId {
    final $$StoredRecipesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.storedRecipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoredRecipesTableOrderingComposer(
            $db: $db,
            $table: $db.storedRecipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$StoredCategoriesTableOrderingComposer get categoryId {
    final $$StoredCategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.storedCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoredCategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.storedCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StoredRecipeCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $StoredRecipeCategoriesTable> {
  $$StoredRecipeCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  $$StoredRecipesTableAnnotationComposer get recipeId {
    final $$StoredRecipesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.storedRecipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoredRecipesTableAnnotationComposer(
            $db: $db,
            $table: $db.storedRecipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$StoredCategoriesTableAnnotationComposer get categoryId {
    final $$StoredCategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.storedCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoredCategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.storedCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StoredRecipeCategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StoredRecipeCategoriesTable,
          StoredRecipeCategory,
          $$StoredRecipeCategoriesTableFilterComposer,
          $$StoredRecipeCategoriesTableOrderingComposer,
          $$StoredRecipeCategoriesTableAnnotationComposer,
          $$StoredRecipeCategoriesTableCreateCompanionBuilder,
          $$StoredRecipeCategoriesTableUpdateCompanionBuilder,
          (StoredRecipeCategory, $$StoredRecipeCategoriesTableReferences),
          StoredRecipeCategory,
          PrefetchHooks Function({bool recipeId, bool categoryId})
        > {
  $$StoredRecipeCategoriesTableTableManager(
    _$AppDatabase db,
    $StoredRecipeCategoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StoredRecipeCategoriesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$StoredRecipeCategoriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$StoredRecipeCategoriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> recipeId = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
                Value<int> position = const Value.absent(),
              }) => StoredRecipeCategoriesCompanion(
                id: id,
                recipeId: recipeId,
                categoryId: categoryId,
                position: position,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int recipeId,
                required int categoryId,
                required int position,
              }) => StoredRecipeCategoriesCompanion.insert(
                id: id,
                recipeId: recipeId,
                categoryId: categoryId,
                position: position,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $StoredRecipeCategoriesTable,
                    StoredRecipeCategory
                  >(table),
                  $$StoredRecipeCategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({recipeId = false, categoryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (recipeId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.recipeId,
                        referencedTable: $$StoredRecipeCategoriesTableReferences
                            ._recipeIdTable(db),
                        referencedColumn:
                            $$StoredRecipeCategoriesTableReferences
                                ._recipeIdTable(db)
                                .id,
                      ) as T;
                    }
                    if (categoryId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.categoryId,
                        referencedTable: $$StoredRecipeCategoriesTableReferences
                            ._categoryIdTable(db),
                        referencedColumn:
                            $$StoredRecipeCategoriesTableReferences
                                ._categoryIdTable(db)
                                .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$StoredRecipeCategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StoredRecipeCategoriesTable,
      StoredRecipeCategory,
      $$StoredRecipeCategoriesTableFilterComposer,
      $$StoredRecipeCategoriesTableOrderingComposer,
      $$StoredRecipeCategoriesTableAnnotationComposer,
      $$StoredRecipeCategoriesTableCreateCompanionBuilder,
      $$StoredRecipeCategoriesTableUpdateCompanionBuilder,
      (StoredRecipeCategory, $$StoredRecipeCategoriesTableReferences),
      StoredRecipeCategory,
      PrefetchHooks Function({bool recipeId, bool categoryId})
    >;
typedef $$StoredTagsTableCreateCompanionBuilder = StoredTagsCompanion Function({
  Value<int> id,
  required String name,
  required int color,
  required int position,
});
typedef $$StoredTagsTableUpdateCompanionBuilder = StoredTagsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<int> color,
  Value<int> position,
});

final class $$StoredTagsTableReferences
    extends BaseReferences<_$AppDatabase, $StoredTagsTable, StoredTag> {
  $$StoredTagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$StoredRecipeTagsTable, List<StoredRecipeTag>>
  _storedRecipeTagsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.storedRecipeTags,
    aliasName: 'stored_tags__id__stored_recipe_tags__tag_id',
  );

  $$StoredRecipeTagsTableProcessedTableManager get storedRecipeTagsRefs {
    final manager = $$StoredRecipeTagsTableTableManager(
      $_db,
      $_db.storedRecipeTags,
    ).filter((f) => f.tagId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _storedRecipeTagsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$StoredTagsTableFilterComposer
    extends Composer<_$AppDatabase, $StoredTagsTable> {
  $$StoredTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> storedRecipeTagsRefs(
    Expression<bool> Function($$StoredRecipeTagsTableFilterComposer f) f,
  ) {
    final $$StoredRecipeTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.storedRecipeTags,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoredRecipeTagsTableFilterComposer(
            $db: $db,
            $table: $db.storedRecipeTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StoredTagsTableOrderingComposer
    extends Composer<_$AppDatabase, $StoredTagsTable> {
  $$StoredTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StoredTagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StoredTagsTable> {
  $$StoredTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  Expression<T> storedRecipeTagsRefs<T extends Object>(
    Expression<T> Function($$StoredRecipeTagsTableAnnotationComposer a) f,
  ) {
    final $$StoredRecipeTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.storedRecipeTags,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoredRecipeTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.storedRecipeTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StoredTagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StoredTagsTable,
          StoredTag,
          $$StoredTagsTableFilterComposer,
          $$StoredTagsTableOrderingComposer,
          $$StoredTagsTableAnnotationComposer,
          $$StoredTagsTableCreateCompanionBuilder,
          $$StoredTagsTableUpdateCompanionBuilder,
          (StoredTag, $$StoredTagsTableReferences),
          StoredTag,
          PrefetchHooks Function({bool storedRecipeTagsRefs})
        > {
  $$StoredTagsTableTableManager(_$AppDatabase db, $StoredTagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StoredTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StoredTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StoredTagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<int> position = const Value.absent(),
              }) => StoredTagsCompanion(
                id: id,
                name: name,
                color: color,
                position: position,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required int color,
                required int position,
              }) => StoredTagsCompanion.insert(
                id: id,
                name: name,
                color: color,
                position: position,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StoredTagsTable, StoredTag>(table),
                  $$StoredTagsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({storedRecipeTagsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (storedRecipeTagsRefs) db.storedRecipeTags,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (storedRecipeTagsRefs)
                    await $_getPrefetchedData<
                      StoredTag,
                      $StoredTagsTable,
                      StoredRecipeTag
                    >(
                      currentTable: table,
                      referencedTable: $$StoredTagsTableReferences
                          ._storedRecipeTagsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$StoredTagsTableReferences(
                            db,
                            table,
                            p0,
                          ).storedRecipeTagsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.tagId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$StoredTagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StoredTagsTable,
      StoredTag,
      $$StoredTagsTableFilterComposer,
      $$StoredTagsTableOrderingComposer,
      $$StoredTagsTableAnnotationComposer,
      $$StoredTagsTableCreateCompanionBuilder,
      $$StoredTagsTableUpdateCompanionBuilder,
      (StoredTag, $$StoredTagsTableReferences),
      StoredTag,
      PrefetchHooks Function({bool storedRecipeTagsRefs})
    >;
typedef $$StoredRecipeTagsTableCreateCompanionBuilder =
    StoredRecipeTagsCompanion Function({
      Value<int> id,
      required int recipeId,
      required int tagId,
      required int position,
    });
typedef $$StoredRecipeTagsTableUpdateCompanionBuilder =
    StoredRecipeTagsCompanion Function({
      Value<int> id,
      Value<int> recipeId,
      Value<int> tagId,
      Value<int> position,
    });

final class $$StoredRecipeTagsTableReferences
    extends
        BaseReferences<_$AppDatabase, $StoredRecipeTagsTable, StoredRecipeTag> {
  $$StoredRecipeTagsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $StoredRecipesTable _recipeIdTable(_$AppDatabase db) => db
      .storedRecipes
      .createAlias('stored_recipe_tags__recipe_id__stored_recipes__id');

  $$StoredRecipesTableProcessedTableManager get recipeId {
    final $_column = $_itemColumn<int>('recipe_id')!;

    final manager = $$StoredRecipesTableTableManager(
      $_db,
      $_db.storedRecipes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recipeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $StoredTagsTable _tagIdTable(_$AppDatabase db) =>
      db.storedTags.createAlias('stored_recipe_tags__tag_id__stored_tags__id');

  $$StoredTagsTableProcessedTableManager get tagId {
    final $_column = $_itemColumn<int>('tag_id')!;

    final manager = $$StoredTagsTableTableManager(
      $_db,
      $_db.storedTags,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tagIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StoredRecipeTagsTableFilterComposer
    extends Composer<_$AppDatabase, $StoredRecipeTagsTable> {
  $$StoredRecipeTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  $$StoredRecipesTableFilterComposer get recipeId {
    final $$StoredRecipesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.storedRecipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoredRecipesTableFilterComposer(
            $db: $db,
            $table: $db.storedRecipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$StoredTagsTableFilterComposer get tagId {
    final $$StoredTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.storedTags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoredTagsTableFilterComposer(
            $db: $db,
            $table: $db.storedTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StoredRecipeTagsTableOrderingComposer
    extends Composer<_$AppDatabase, $StoredRecipeTagsTable> {
  $$StoredRecipeTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  $$StoredRecipesTableOrderingComposer get recipeId {
    final $$StoredRecipesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.storedRecipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoredRecipesTableOrderingComposer(
            $db: $db,
            $table: $db.storedRecipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$StoredTagsTableOrderingComposer get tagId {
    final $$StoredTagsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.storedTags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoredTagsTableOrderingComposer(
            $db: $db,
            $table: $db.storedTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StoredRecipeTagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StoredRecipeTagsTable> {
  $$StoredRecipeTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  $$StoredRecipesTableAnnotationComposer get recipeId {
    final $$StoredRecipesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.storedRecipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoredRecipesTableAnnotationComposer(
            $db: $db,
            $table: $db.storedRecipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$StoredTagsTableAnnotationComposer get tagId {
    final $$StoredTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.storedTags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoredTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.storedTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StoredRecipeTagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StoredRecipeTagsTable,
          StoredRecipeTag,
          $$StoredRecipeTagsTableFilterComposer,
          $$StoredRecipeTagsTableOrderingComposer,
          $$StoredRecipeTagsTableAnnotationComposer,
          $$StoredRecipeTagsTableCreateCompanionBuilder,
          $$StoredRecipeTagsTableUpdateCompanionBuilder,
          (StoredRecipeTag, $$StoredRecipeTagsTableReferences),
          StoredRecipeTag,
          PrefetchHooks Function({bool recipeId, bool tagId})
        > {
  $$StoredRecipeTagsTableTableManager(
    _$AppDatabase db,
    $StoredRecipeTagsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StoredRecipeTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StoredRecipeTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StoredRecipeTagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> recipeId = const Value.absent(),
                Value<int> tagId = const Value.absent(),
                Value<int> position = const Value.absent(),
              }) => StoredRecipeTagsCompanion(
                id: id,
                recipeId: recipeId,
                tagId: tagId,
                position: position,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int recipeId,
                required int tagId,
                required int position,
              }) => StoredRecipeTagsCompanion.insert(
                id: id,
                recipeId: recipeId,
                tagId: tagId,
                position: position,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StoredRecipeTagsTable, StoredRecipeTag>(table),
                  $$StoredRecipeTagsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({recipeId = false, tagId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (recipeId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.recipeId,
                        referencedTable: $$StoredRecipeTagsTableReferences
                            ._recipeIdTable(db),
                        referencedColumn: $$StoredRecipeTagsTableReferences
                            ._recipeIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (tagId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.tagId,
                        referencedTable: $$StoredRecipeTagsTableReferences
                            ._tagIdTable(db),
                        referencedColumn: $$StoredRecipeTagsTableReferences
                            ._tagIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$StoredRecipeTagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StoredRecipeTagsTable,
      StoredRecipeTag,
      $$StoredRecipeTagsTableFilterComposer,
      $$StoredRecipeTagsTableOrderingComposer,
      $$StoredRecipeTagsTableAnnotationComposer,
      $$StoredRecipeTagsTableCreateCompanionBuilder,
      $$StoredRecipeTagsTableUpdateCompanionBuilder,
      (StoredRecipeTag, $$StoredRecipeTagsTableReferences),
      StoredRecipeTag,
      PrefetchHooks Function({bool recipeId, bool tagId})
    >;
typedef $$StoredIngredientGroupsTableCreateCompanionBuilder =
    StoredIngredientGroupsCompanion Function({
      Value<int> id,
      required int recipeId,
      required int position,
      required bool hasIngredientGroup,
      required bool hasGlossary,
      Value<String?> glossary,
    });
typedef $$StoredIngredientGroupsTableUpdateCompanionBuilder =
    StoredIngredientGroupsCompanion Function({
      Value<int> id,
      Value<int> recipeId,
      Value<int> position,
      Value<bool> hasIngredientGroup,
      Value<bool> hasGlossary,
      Value<String?> glossary,
    });

final class $$StoredIngredientGroupsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $StoredIngredientGroupsTable,
          StoredIngredientGroup
        > {
  $$StoredIngredientGroupsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $StoredRecipesTable _recipeIdTable(_$AppDatabase db) => db
      .storedRecipes
      .createAlias('stored_ingredient_groups__recipe_id__stored_recipes__id');

  $$StoredRecipesTableProcessedTableManager get recipeId {
    final $_column = $_itemColumn<int>('recipe_id')!;

    final manager = $$StoredRecipesTableTableManager(
      $_db,
      $_db.storedRecipes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recipeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$StoredIngredientsTable, List<StoredIngredient>>
  _storedIngredientsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.storedIngredients,
        aliasName: 'stored_ingredient_groups__id__stored_ingredients__group_id',
      );

  $$StoredIngredientsTableProcessedTableManager get storedIngredientsRefs {
    final manager = $$StoredIngredientsTableTableManager(
      $_db,
      $_db.storedIngredients,
    ).filter((f) => f.groupId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _storedIngredientsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$StoredIngredientGroupsTableFilterComposer
    extends Composer<_$AppDatabase, $StoredIngredientGroupsTable> {
  $$StoredIngredientGroupsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasIngredientGroup => $composableBuilder(
    column: $table.hasIngredientGroup,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasGlossary => $composableBuilder(
    column: $table.hasGlossary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get glossary => $composableBuilder(
    column: $table.glossary,
    builder: (column) => ColumnFilters(column),
  );

  $$StoredRecipesTableFilterComposer get recipeId {
    final $$StoredRecipesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.storedRecipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoredRecipesTableFilterComposer(
            $db: $db,
            $table: $db.storedRecipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> storedIngredientsRefs(
    Expression<bool> Function($$StoredIngredientsTableFilterComposer f) f,
  ) {
    final $$StoredIngredientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.storedIngredients,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoredIngredientsTableFilterComposer(
            $db: $db,
            $table: $db.storedIngredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StoredIngredientGroupsTableOrderingComposer
    extends Composer<_$AppDatabase, $StoredIngredientGroupsTable> {
  $$StoredIngredientGroupsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasIngredientGroup => $composableBuilder(
    column: $table.hasIngredientGroup,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasGlossary => $composableBuilder(
    column: $table.hasGlossary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get glossary => $composableBuilder(
    column: $table.glossary,
    builder: (column) => ColumnOrderings(column),
  );

  $$StoredRecipesTableOrderingComposer get recipeId {
    final $$StoredRecipesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.storedRecipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoredRecipesTableOrderingComposer(
            $db: $db,
            $table: $db.storedRecipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StoredIngredientGroupsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StoredIngredientGroupsTable> {
  $$StoredIngredientGroupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<bool> get hasIngredientGroup => $composableBuilder(
    column: $table.hasIngredientGroup,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hasGlossary => $composableBuilder(
    column: $table.hasGlossary,
    builder: (column) => column,
  );

  GeneratedColumn<String> get glossary =>
      $composableBuilder(column: $table.glossary, builder: (column) => column);

  $$StoredRecipesTableAnnotationComposer get recipeId {
    final $$StoredRecipesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.storedRecipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoredRecipesTableAnnotationComposer(
            $db: $db,
            $table: $db.storedRecipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> storedIngredientsRefs<T extends Object>(
    Expression<T> Function($$StoredIngredientsTableAnnotationComposer a) f,
  ) {
    final $$StoredIngredientsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.storedIngredients,
          getReferencedColumn: (t) => t.groupId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$StoredIngredientsTableAnnotationComposer(
                $db: $db,
                $table: $db.storedIngredients,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$StoredIngredientGroupsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StoredIngredientGroupsTable,
          StoredIngredientGroup,
          $$StoredIngredientGroupsTableFilterComposer,
          $$StoredIngredientGroupsTableOrderingComposer,
          $$StoredIngredientGroupsTableAnnotationComposer,
          $$StoredIngredientGroupsTableCreateCompanionBuilder,
          $$StoredIngredientGroupsTableUpdateCompanionBuilder,
          (StoredIngredientGroup, $$StoredIngredientGroupsTableReferences),
          StoredIngredientGroup,
          PrefetchHooks Function({bool recipeId, bool storedIngredientsRefs})
        > {
  $$StoredIngredientGroupsTableTableManager(
    _$AppDatabase db,
    $StoredIngredientGroupsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StoredIngredientGroupsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$StoredIngredientGroupsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$StoredIngredientGroupsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> recipeId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<bool> hasIngredientGroup = const Value.absent(),
                Value<bool> hasGlossary = const Value.absent(),
                Value<String?> glossary = const Value.absent(),
              }) => StoredIngredientGroupsCompanion(
                id: id,
                recipeId: recipeId,
                position: position,
                hasIngredientGroup: hasIngredientGroup,
                hasGlossary: hasGlossary,
                glossary: glossary,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int recipeId,
                required int position,
                required bool hasIngredientGroup,
                required bool hasGlossary,
                Value<String?> glossary = const Value.absent(),
              }) => StoredIngredientGroupsCompanion.insert(
                id: id,
                recipeId: recipeId,
                position: position,
                hasIngredientGroup: hasIngredientGroup,
                hasGlossary: hasGlossary,
                glossary: glossary,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $StoredIngredientGroupsTable,
                    StoredIngredientGroup
                  >(table),
                  $$StoredIngredientGroupsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({recipeId = false, storedIngredientsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (storedIngredientsRefs) db.storedIngredients,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (recipeId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.recipeId,
                            referencedTable:
                                $$StoredIngredientGroupsTableReferences
                                    ._recipeIdTable(db),
                            referencedColumn:
                                $$StoredIngredientGroupsTableReferences
                                    ._recipeIdTable(db)
                                    .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (storedIngredientsRefs)
                        await $_getPrefetchedData<
                          StoredIngredientGroup,
                          $StoredIngredientGroupsTable,
                          StoredIngredient
                        >(
                          currentTable: table,
                          referencedTable:
                              $$StoredIngredientGroupsTableReferences
                                  ._storedIngredientsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StoredIngredientGroupsTableReferences(
                                db,
                                table,
                                p0,
                              ).storedIngredientsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.groupId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$StoredIngredientGroupsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StoredIngredientGroupsTable,
      StoredIngredientGroup,
      $$StoredIngredientGroupsTableFilterComposer,
      $$StoredIngredientGroupsTableOrderingComposer,
      $$StoredIngredientGroupsTableAnnotationComposer,
      $$StoredIngredientGroupsTableCreateCompanionBuilder,
      $$StoredIngredientGroupsTableUpdateCompanionBuilder,
      (StoredIngredientGroup, $$StoredIngredientGroupsTableReferences),
      StoredIngredientGroup,
      PrefetchHooks Function({bool recipeId, bool storedIngredientsRefs})
    >;
typedef $$StoredIngredientsTableCreateCompanionBuilder =
    StoredIngredientsCompanion Function({
      Value<int> id,
      required int groupId,
      required int position,
      Value<String?> opaqueId,
      required String name,
      Value<double?> amount,
      Value<String?> unit,
    });
typedef $$StoredIngredientsTableUpdateCompanionBuilder =
    StoredIngredientsCompanion Function({
      Value<int> id,
      Value<int> groupId,
      Value<int> position,
      Value<String?> opaqueId,
      Value<String> name,
      Value<double?> amount,
      Value<String?> unit,
    });

final class $$StoredIngredientsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $StoredIngredientsTable,
          StoredIngredient
        > {
  $$StoredIngredientsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $StoredIngredientGroupsTable _groupIdTable(_$AppDatabase db) =>
      db.storedIngredientGroups.createAlias(
        'stored_ingredients__group_id__stored_ingredient_groups__id',
      );

  $$StoredIngredientGroupsTableProcessedTableManager get groupId {
    final $_column = $_itemColumn<int>('group_id')!;

    final manager = $$StoredIngredientGroupsTableTableManager(
      $_db,
      $_db.storedIngredientGroups,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $StoredStepIngredientsTable,
    List<StoredStepIngredient>
  >
  _storedStepIngredientsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.storedStepIngredients,
        aliasName:
            'stored_ingredients__id__stored_step_ingredients__ingredient_id',
      );

  $$StoredStepIngredientsTableProcessedTableManager
  get storedStepIngredientsRefs {
    final manager = $$StoredStepIngredientsTableTableManager(
      $_db,
      $_db.storedStepIngredients,
    ).filter((f) => f.ingredientId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _storedStepIngredientsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$StoredIngredientsTableFilterComposer
    extends Composer<_$AppDatabase, $StoredIngredientsTable> {
  $$StoredIngredientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get opaqueId => $composableBuilder(
    column: $table.opaqueId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  $$StoredIngredientGroupsTableFilterComposer get groupId {
    final $$StoredIngredientGroupsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.groupId,
          referencedTable: $db.storedIngredientGroups,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$StoredIngredientGroupsTableFilterComposer(
                $db: $db,
                $table: $db.storedIngredientGroups,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  Expression<bool> storedStepIngredientsRefs(
    Expression<bool> Function($$StoredStepIngredientsTableFilterComposer f) f,
  ) {
    final $$StoredStepIngredientsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.storedStepIngredients,
          getReferencedColumn: (t) => t.ingredientId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$StoredStepIngredientsTableFilterComposer(
                $db: $db,
                $table: $db.storedStepIngredients,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$StoredIngredientsTableOrderingComposer
    extends Composer<_$AppDatabase, $StoredIngredientsTable> {
  $$StoredIngredientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get opaqueId => $composableBuilder(
    column: $table.opaqueId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  $$StoredIngredientGroupsTableOrderingComposer get groupId {
    final $$StoredIngredientGroupsTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.groupId,
          referencedTable: $db.storedIngredientGroups,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$StoredIngredientGroupsTableOrderingComposer(
                $db: $db,
                $table: $db.storedIngredientGroups,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$StoredIngredientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StoredIngredientsTable> {
  $$StoredIngredientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get opaqueId =>
      $composableBuilder(column: $table.opaqueId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  $$StoredIngredientGroupsTableAnnotationComposer get groupId {
    final $$StoredIngredientGroupsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.groupId,
          referencedTable: $db.storedIngredientGroups,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$StoredIngredientGroupsTableAnnotationComposer(
                $db: $db,
                $table: $db.storedIngredientGroups,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  Expression<T> storedStepIngredientsRefs<T extends Object>(
    Expression<T> Function($$StoredStepIngredientsTableAnnotationComposer a) f,
  ) {
    final $$StoredStepIngredientsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.storedStepIngredients,
          getReferencedColumn: (t) => t.ingredientId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$StoredStepIngredientsTableAnnotationComposer(
                $db: $db,
                $table: $db.storedStepIngredients,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$StoredIngredientsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StoredIngredientsTable,
          StoredIngredient,
          $$StoredIngredientsTableFilterComposer,
          $$StoredIngredientsTableOrderingComposer,
          $$StoredIngredientsTableAnnotationComposer,
          $$StoredIngredientsTableCreateCompanionBuilder,
          $$StoredIngredientsTableUpdateCompanionBuilder,
          (StoredIngredient, $$StoredIngredientsTableReferences),
          StoredIngredient,
          PrefetchHooks Function({bool groupId, bool storedStepIngredientsRefs})
        > {
  $$StoredIngredientsTableTableManager(
    _$AppDatabase db,
    $StoredIngredientsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StoredIngredientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StoredIngredientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StoredIngredientsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> groupId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String?> opaqueId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double?> amount = const Value.absent(),
                Value<String?> unit = const Value.absent(),
              }) => StoredIngredientsCompanion(
                id: id,
                groupId: groupId,
                position: position,
                opaqueId: opaqueId,
                name: name,
                amount: amount,
                unit: unit,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int groupId,
                required int position,
                Value<String?> opaqueId = const Value.absent(),
                required String name,
                Value<double?> amount = const Value.absent(),
                Value<String?> unit = const Value.absent(),
              }) => StoredIngredientsCompanion.insert(
                id: id,
                groupId: groupId,
                position: position,
                opaqueId: opaqueId,
                name: name,
                amount: amount,
                unit: unit,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StoredIngredientsTable, StoredIngredient>(table),
                  $$StoredIngredientsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({groupId = false, storedStepIngredientsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (storedStepIngredientsRefs) db.storedStepIngredients,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (groupId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.groupId,
                            referencedTable: $$StoredIngredientsTableReferences
                                ._groupIdTable(db),
                            referencedColumn: $$StoredIngredientsTableReferences
                                ._groupIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (storedStepIngredientsRefs)
                        await $_getPrefetchedData<
                          StoredIngredient,
                          $StoredIngredientsTable,
                          StoredStepIngredient
                        >(
                          currentTable: table,
                          referencedTable: $$StoredIngredientsTableReferences
                              ._storedStepIngredientsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StoredIngredientsTableReferences(
                                db,
                                table,
                                p0,
                              ).storedStepIngredientsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ingredientId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$StoredIngredientsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StoredIngredientsTable,
      StoredIngredient,
      $$StoredIngredientsTableFilterComposer,
      $$StoredIngredientsTableOrderingComposer,
      $$StoredIngredientsTableAnnotationComposer,
      $$StoredIngredientsTableCreateCompanionBuilder,
      $$StoredIngredientsTableUpdateCompanionBuilder,
      (StoredIngredient, $$StoredIngredientsTableReferences),
      StoredIngredient,
      PrefetchHooks Function({bool groupId, bool storedStepIngredientsRefs})
    >;
typedef $$StoredNutritionsTableCreateCompanionBuilder =
    StoredNutritionsCompanion Function({
      Value<int> id,
      required int recipeId,
      required int position,
      required String name,
      required String amountUnit,
    });
typedef $$StoredNutritionsTableUpdateCompanionBuilder =
    StoredNutritionsCompanion Function({
      Value<int> id,
      Value<int> recipeId,
      Value<int> position,
      Value<String> name,
      Value<String> amountUnit,
    });

final class $$StoredNutritionsTableReferences
    extends
        BaseReferences<_$AppDatabase, $StoredNutritionsTable, StoredNutrition> {
  $$StoredNutritionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $StoredRecipesTable _recipeIdTable(_$AppDatabase db) => db
      .storedRecipes
      .createAlias('stored_nutritions__recipe_id__stored_recipes__id');

  $$StoredRecipesTableProcessedTableManager get recipeId {
    final $_column = $_itemColumn<int>('recipe_id')!;

    final manager = $$StoredRecipesTableTableManager(
      $_db,
      $_db.storedRecipes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recipeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StoredNutritionsTableFilterComposer
    extends Composer<_$AppDatabase, $StoredNutritionsTable> {
  $$StoredNutritionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get amountUnit => $composableBuilder(
    column: $table.amountUnit,
    builder: (column) => ColumnFilters(column),
  );

  $$StoredRecipesTableFilterComposer get recipeId {
    final $$StoredRecipesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.storedRecipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoredRecipesTableFilterComposer(
            $db: $db,
            $table: $db.storedRecipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StoredNutritionsTableOrderingComposer
    extends Composer<_$AppDatabase, $StoredNutritionsTable> {
  $$StoredNutritionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get amountUnit => $composableBuilder(
    column: $table.amountUnit,
    builder: (column) => ColumnOrderings(column),
  );

  $$StoredRecipesTableOrderingComposer get recipeId {
    final $$StoredRecipesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.storedRecipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoredRecipesTableOrderingComposer(
            $db: $db,
            $table: $db.storedRecipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StoredNutritionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StoredNutritionsTable> {
  $$StoredNutritionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get amountUnit => $composableBuilder(
    column: $table.amountUnit,
    builder: (column) => column,
  );

  $$StoredRecipesTableAnnotationComposer get recipeId {
    final $$StoredRecipesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.storedRecipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoredRecipesTableAnnotationComposer(
            $db: $db,
            $table: $db.storedRecipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StoredNutritionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StoredNutritionsTable,
          StoredNutrition,
          $$StoredNutritionsTableFilterComposer,
          $$StoredNutritionsTableOrderingComposer,
          $$StoredNutritionsTableAnnotationComposer,
          $$StoredNutritionsTableCreateCompanionBuilder,
          $$StoredNutritionsTableUpdateCompanionBuilder,
          (StoredNutrition, $$StoredNutritionsTableReferences),
          StoredNutrition,
          PrefetchHooks Function({bool recipeId})
        > {
  $$StoredNutritionsTableTableManager(
    _$AppDatabase db,
    $StoredNutritionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StoredNutritionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StoredNutritionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StoredNutritionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> recipeId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> amountUnit = const Value.absent(),
              }) => StoredNutritionsCompanion(
                id: id,
                recipeId: recipeId,
                position: position,
                name: name,
                amountUnit: amountUnit,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int recipeId,
                required int position,
                required String name,
                required String amountUnit,
              }) => StoredNutritionsCompanion.insert(
                id: id,
                recipeId: recipeId,
                position: position,
                name: name,
                amountUnit: amountUnit,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StoredNutritionsTable, StoredNutrition>(table),
                  $$StoredNutritionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({recipeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (recipeId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.recipeId,
                        referencedTable: $$StoredNutritionsTableReferences
                            ._recipeIdTable(db),
                        referencedColumn: $$StoredNutritionsTableReferences
                            ._recipeIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$StoredNutritionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StoredNutritionsTable,
      StoredNutrition,
      $$StoredNutritionsTableFilterComposer,
      $$StoredNutritionsTableOrderingComposer,
      $$StoredNutritionsTableAnnotationComposer,
      $$StoredNutritionsTableCreateCompanionBuilder,
      $$StoredNutritionsTableUpdateCompanionBuilder,
      (StoredNutrition, $$StoredNutritionsTableReferences),
      StoredNutrition,
      PrefetchHooks Function({bool recipeId})
    >;
typedef $$StoredStepGroupsTableCreateCompanionBuilder =
    StoredStepGroupsCompanion Function({
      Value<int> id,
      required int recipeId,
      required int position,
      required bool hasInstruction,
      Value<String?> instruction,
      required bool hasTitle,
      Value<String?> title,
      required bool hasImageGroup,
    });
typedef $$StoredStepGroupsTableUpdateCompanionBuilder =
    StoredStepGroupsCompanion Function({
      Value<int> id,
      Value<int> recipeId,
      Value<int> position,
      Value<bool> hasInstruction,
      Value<String?> instruction,
      Value<bool> hasTitle,
      Value<String?> title,
      Value<bool> hasImageGroup,
    });

final class $$StoredStepGroupsTableReferences
    extends
        BaseReferences<_$AppDatabase, $StoredStepGroupsTable, StoredStepGroup> {
  $$StoredStepGroupsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $StoredRecipesTable _recipeIdTable(_$AppDatabase db) => db
      .storedRecipes
      .createAlias('stored_step_groups__recipe_id__stored_recipes__id');

  $$StoredRecipesTableProcessedTableManager get recipeId {
    final $_column = $_itemColumn<int>('recipe_id')!;

    final manager = $$StoredRecipesTableTableManager(
      $_db,
      $_db.storedRecipes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recipeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$StoredStepImagesTable, List<StoredStepImage>>
  _storedStepImagesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.storedStepImages,
    aliasName: 'stored_step_groups__id__stored_step_images__group_id',
  );

  $$StoredStepImagesTableProcessedTableManager get storedStepImagesRefs {
    final manager = $$StoredStepImagesTableTableManager(
      $_db,
      $_db.storedStepImages,
    ).filter((f) => f.groupId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _storedStepImagesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $StoredStepIngredientsTable,
    List<StoredStepIngredient>
  >
  _storedStepIngredientsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.storedStepIngredients,
        aliasName:
            'stored_step_groups__id__stored_step_ingredients__step_group_id',
      );

  $$StoredStepIngredientsTableProcessedTableManager
  get storedStepIngredientsRefs {
    final manager = $$StoredStepIngredientsTableTableManager(
      $_db,
      $_db.storedStepIngredients,
    ).filter((f) => f.stepGroupId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _storedStepIngredientsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$StoredStepGroupsTableFilterComposer
    extends Composer<_$AppDatabase, $StoredStepGroupsTable> {
  $$StoredStepGroupsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasInstruction => $composableBuilder(
    column: $table.hasInstruction,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get instruction => $composableBuilder(
    column: $table.instruction,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasTitle => $composableBuilder(
    column: $table.hasTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasImageGroup => $composableBuilder(
    column: $table.hasImageGroup,
    builder: (column) => ColumnFilters(column),
  );

  $$StoredRecipesTableFilterComposer get recipeId {
    final $$StoredRecipesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.storedRecipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoredRecipesTableFilterComposer(
            $db: $db,
            $table: $db.storedRecipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> storedStepImagesRefs(
    Expression<bool> Function($$StoredStepImagesTableFilterComposer f) f,
  ) {
    final $$StoredStepImagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.storedStepImages,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoredStepImagesTableFilterComposer(
            $db: $db,
            $table: $db.storedStepImages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> storedStepIngredientsRefs(
    Expression<bool> Function($$StoredStepIngredientsTableFilterComposer f) f,
  ) {
    final $$StoredStepIngredientsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.storedStepIngredients,
          getReferencedColumn: (t) => t.stepGroupId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$StoredStepIngredientsTableFilterComposer(
                $db: $db,
                $table: $db.storedStepIngredients,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$StoredStepGroupsTableOrderingComposer
    extends Composer<_$AppDatabase, $StoredStepGroupsTable> {
  $$StoredStepGroupsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasInstruction => $composableBuilder(
    column: $table.hasInstruction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get instruction => $composableBuilder(
    column: $table.instruction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasTitle => $composableBuilder(
    column: $table.hasTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasImageGroup => $composableBuilder(
    column: $table.hasImageGroup,
    builder: (column) => ColumnOrderings(column),
  );

  $$StoredRecipesTableOrderingComposer get recipeId {
    final $$StoredRecipesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.storedRecipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoredRecipesTableOrderingComposer(
            $db: $db,
            $table: $db.storedRecipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StoredStepGroupsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StoredStepGroupsTable> {
  $$StoredStepGroupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<bool> get hasInstruction => $composableBuilder(
    column: $table.hasInstruction,
    builder: (column) => column,
  );

  GeneratedColumn<String> get instruction => $composableBuilder(
    column: $table.instruction,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hasTitle =>
      $composableBuilder(column: $table.hasTitle, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<bool> get hasImageGroup => $composableBuilder(
    column: $table.hasImageGroup,
    builder: (column) => column,
  );

  $$StoredRecipesTableAnnotationComposer get recipeId {
    final $$StoredRecipesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.storedRecipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoredRecipesTableAnnotationComposer(
            $db: $db,
            $table: $db.storedRecipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> storedStepImagesRefs<T extends Object>(
    Expression<T> Function($$StoredStepImagesTableAnnotationComposer a) f,
  ) {
    final $$StoredStepImagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.storedStepImages,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoredStepImagesTableAnnotationComposer(
            $db: $db,
            $table: $db.storedStepImages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> storedStepIngredientsRefs<T extends Object>(
    Expression<T> Function($$StoredStepIngredientsTableAnnotationComposer a) f,
  ) {
    final $$StoredStepIngredientsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.storedStepIngredients,
          getReferencedColumn: (t) => t.stepGroupId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$StoredStepIngredientsTableAnnotationComposer(
                $db: $db,
                $table: $db.storedStepIngredients,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$StoredStepGroupsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StoredStepGroupsTable,
          StoredStepGroup,
          $$StoredStepGroupsTableFilterComposer,
          $$StoredStepGroupsTableOrderingComposer,
          $$StoredStepGroupsTableAnnotationComposer,
          $$StoredStepGroupsTableCreateCompanionBuilder,
          $$StoredStepGroupsTableUpdateCompanionBuilder,
          (StoredStepGroup, $$StoredStepGroupsTableReferences),
          StoredStepGroup,
          PrefetchHooks Function({
            bool recipeId,
            bool storedStepImagesRefs,
            bool storedStepIngredientsRefs,
          })
        > {
  $$StoredStepGroupsTableTableManager(
    _$AppDatabase db,
    $StoredStepGroupsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StoredStepGroupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StoredStepGroupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StoredStepGroupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> recipeId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<bool> hasInstruction = const Value.absent(),
                Value<String?> instruction = const Value.absent(),
                Value<bool> hasTitle = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<bool> hasImageGroup = const Value.absent(),
              }) => StoredStepGroupsCompanion(
                id: id,
                recipeId: recipeId,
                position: position,
                hasInstruction: hasInstruction,
                instruction: instruction,
                hasTitle: hasTitle,
                title: title,
                hasImageGroup: hasImageGroup,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int recipeId,
                required int position,
                required bool hasInstruction,
                Value<String?> instruction = const Value.absent(),
                required bool hasTitle,
                Value<String?> title = const Value.absent(),
                required bool hasImageGroup,
              }) => StoredStepGroupsCompanion.insert(
                id: id,
                recipeId: recipeId,
                position: position,
                hasInstruction: hasInstruction,
                instruction: instruction,
                hasTitle: hasTitle,
                title: title,
                hasImageGroup: hasImageGroup,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StoredStepGroupsTable, StoredStepGroup>(table),
                  $$StoredStepGroupsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                recipeId = false,
                storedStepImagesRefs = false,
                storedStepIngredientsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (storedStepImagesRefs) db.storedStepImages,
                    if (storedStepIngredientsRefs) db.storedStepIngredients,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (recipeId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.recipeId,
                            referencedTable: $$StoredStepGroupsTableReferences
                                ._recipeIdTable(db),
                            referencedColumn: $$StoredStepGroupsTableReferences
                                ._recipeIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (storedStepImagesRefs)
                        await $_getPrefetchedData<
                          StoredStepGroup,
                          $StoredStepGroupsTable,
                          StoredStepImage
                        >(
                          currentTable: table,
                          referencedTable: $$StoredStepGroupsTableReferences
                              ._storedStepImagesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StoredStepGroupsTableReferences(
                                db,
                                table,
                                p0,
                              ).storedStepImagesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.groupId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (storedStepIngredientsRefs)
                        await $_getPrefetchedData<
                          StoredStepGroup,
                          $StoredStepGroupsTable,
                          StoredStepIngredient
                        >(
                          currentTable: table,
                          referencedTable: $$StoredStepGroupsTableReferences
                              ._storedStepIngredientsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StoredStepGroupsTableReferences(
                                db,
                                table,
                                p0,
                              ).storedStepIngredientsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.stepGroupId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$StoredStepGroupsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StoredStepGroupsTable,
      StoredStepGroup,
      $$StoredStepGroupsTableFilterComposer,
      $$StoredStepGroupsTableOrderingComposer,
      $$StoredStepGroupsTableAnnotationComposer,
      $$StoredStepGroupsTableCreateCompanionBuilder,
      $$StoredStepGroupsTableUpdateCompanionBuilder,
      (StoredStepGroup, $$StoredStepGroupsTableReferences),
      StoredStepGroup,
      PrefetchHooks Function({
        bool recipeId,
        bool storedStepImagesRefs,
        bool storedStepIngredientsRefs,
      })
    >;
typedef $$StoredStepImagesTableCreateCompanionBuilder =
    StoredStepImagesCompanion Function({
      Value<int> id,
      required int groupId,
      required int position,
      required String path,
    });
typedef $$StoredStepImagesTableUpdateCompanionBuilder =
    StoredStepImagesCompanion Function({
      Value<int> id,
      Value<int> groupId,
      Value<int> position,
      Value<String> path,
    });

final class $$StoredStepImagesTableReferences
    extends
        BaseReferences<_$AppDatabase, $StoredStepImagesTable, StoredStepImage> {
  $$StoredStepImagesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $StoredStepGroupsTable _groupIdTable(_$AppDatabase db) => db
      .storedStepGroups
      .createAlias('stored_step_images__group_id__stored_step_groups__id');

  $$StoredStepGroupsTableProcessedTableManager get groupId {
    final $_column = $_itemColumn<int>('group_id')!;

    final manager = $$StoredStepGroupsTableTableManager(
      $_db,
      $_db.storedStepGroups,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StoredStepImagesTableFilterComposer
    extends Composer<_$AppDatabase, $StoredStepImagesTable> {
  $$StoredStepImagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnFilters(column),
  );

  $$StoredStepGroupsTableFilterComposer get groupId {
    final $$StoredStepGroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.storedStepGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoredStepGroupsTableFilterComposer(
            $db: $db,
            $table: $db.storedStepGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StoredStepImagesTableOrderingComposer
    extends Composer<_$AppDatabase, $StoredStepImagesTable> {
  $$StoredStepImagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnOrderings(column),
  );

  $$StoredStepGroupsTableOrderingComposer get groupId {
    final $$StoredStepGroupsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.storedStepGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoredStepGroupsTableOrderingComposer(
            $db: $db,
            $table: $db.storedStepGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StoredStepImagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $StoredStepImagesTable> {
  $$StoredStepImagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  $$StoredStepGroupsTableAnnotationComposer get groupId {
    final $$StoredStepGroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.storedStepGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoredStepGroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.storedStepGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StoredStepImagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StoredStepImagesTable,
          StoredStepImage,
          $$StoredStepImagesTableFilterComposer,
          $$StoredStepImagesTableOrderingComposer,
          $$StoredStepImagesTableAnnotationComposer,
          $$StoredStepImagesTableCreateCompanionBuilder,
          $$StoredStepImagesTableUpdateCompanionBuilder,
          (StoredStepImage, $$StoredStepImagesTableReferences),
          StoredStepImage,
          PrefetchHooks Function({bool groupId})
        > {
  $$StoredStepImagesTableTableManager(
    _$AppDatabase db,
    $StoredStepImagesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StoredStepImagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StoredStepImagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StoredStepImagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> groupId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> path = const Value.absent(),
              }) => StoredStepImagesCompanion(
                id: id,
                groupId: groupId,
                position: position,
                path: path,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int groupId,
                required int position,
                required String path,
              }) => StoredStepImagesCompanion.insert(
                id: id,
                groupId: groupId,
                position: position,
                path: path,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StoredStepImagesTable, StoredStepImage>(table),
                  $$StoredStepImagesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({groupId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (groupId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.groupId,
                        referencedTable: $$StoredStepImagesTableReferences
                            ._groupIdTable(db),
                        referencedColumn: $$StoredStepImagesTableReferences
                            ._groupIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$StoredStepImagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StoredStepImagesTable,
      StoredStepImage,
      $$StoredStepImagesTableFilterComposer,
      $$StoredStepImagesTableOrderingComposer,
      $$StoredStepImagesTableAnnotationComposer,
      $$StoredStepImagesTableCreateCompanionBuilder,
      $$StoredStepImagesTableUpdateCompanionBuilder,
      (StoredStepImage, $$StoredStepImagesTableReferences),
      StoredStepImage,
      PrefetchHooks Function({bool groupId})
    >;
typedef $$StoredStepIngredientsTableCreateCompanionBuilder =
    StoredStepIngredientsCompanion Function({
      Value<int> id,
      required int stepGroupId,
      required int ingredientId,
      required int position,
    });
typedef $$StoredStepIngredientsTableUpdateCompanionBuilder =
    StoredStepIngredientsCompanion Function({
      Value<int> id,
      Value<int> stepGroupId,
      Value<int> ingredientId,
      Value<int> position,
    });

final class $$StoredStepIngredientsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $StoredStepIngredientsTable,
          StoredStepIngredient
        > {
  $$StoredStepIngredientsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $StoredStepGroupsTable _stepGroupIdTable(_$AppDatabase db) =>
      db.storedStepGroups.createAlias(
        'stored_step_ingredients__step_group_id__stored_step_groups__id',
      );

  $$StoredStepGroupsTableProcessedTableManager get stepGroupId {
    final $_column = $_itemColumn<int>('step_group_id')!;

    final manager = $$StoredStepGroupsTableTableManager(
      $_db,
      $_db.storedStepGroups,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_stepGroupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $StoredIngredientsTable _ingredientIdTable(_$AppDatabase db) =>
      db.storedIngredients.createAlias(
        'stored_step_ingredients__ingredient_id__stored_ingredients__id',
      );

  $$StoredIngredientsTableProcessedTableManager get ingredientId {
    final $_column = $_itemColumn<int>('ingredient_id')!;

    final manager = $$StoredIngredientsTableTableManager(
      $_db,
      $_db.storedIngredients,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ingredientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StoredStepIngredientsTableFilterComposer
    extends Composer<_$AppDatabase, $StoredStepIngredientsTable> {
  $$StoredStepIngredientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  $$StoredStepGroupsTableFilterComposer get stepGroupId {
    final $$StoredStepGroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.stepGroupId,
      referencedTable: $db.storedStepGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoredStepGroupsTableFilterComposer(
            $db: $db,
            $table: $db.storedStepGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$StoredIngredientsTableFilterComposer get ingredientId {
    final $$StoredIngredientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingredientId,
      referencedTable: $db.storedIngredients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoredIngredientsTableFilterComposer(
            $db: $db,
            $table: $db.storedIngredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StoredStepIngredientsTableOrderingComposer
    extends Composer<_$AppDatabase, $StoredStepIngredientsTable> {
  $$StoredStepIngredientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  $$StoredStepGroupsTableOrderingComposer get stepGroupId {
    final $$StoredStepGroupsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.stepGroupId,
      referencedTable: $db.storedStepGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoredStepGroupsTableOrderingComposer(
            $db: $db,
            $table: $db.storedStepGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$StoredIngredientsTableOrderingComposer get ingredientId {
    final $$StoredIngredientsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingredientId,
      referencedTable: $db.storedIngredients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoredIngredientsTableOrderingComposer(
            $db: $db,
            $table: $db.storedIngredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StoredStepIngredientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StoredStepIngredientsTable> {
  $$StoredStepIngredientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  $$StoredStepGroupsTableAnnotationComposer get stepGroupId {
    final $$StoredStepGroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.stepGroupId,
      referencedTable: $db.storedStepGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoredStepGroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.storedStepGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$StoredIngredientsTableAnnotationComposer get ingredientId {
    final $$StoredIngredientsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.ingredientId,
          referencedTable: $db.storedIngredients,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$StoredIngredientsTableAnnotationComposer(
                $db: $db,
                $table: $db.storedIngredients,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$StoredStepIngredientsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StoredStepIngredientsTable,
          StoredStepIngredient,
          $$StoredStepIngredientsTableFilterComposer,
          $$StoredStepIngredientsTableOrderingComposer,
          $$StoredStepIngredientsTableAnnotationComposer,
          $$StoredStepIngredientsTableCreateCompanionBuilder,
          $$StoredStepIngredientsTableUpdateCompanionBuilder,
          (StoredStepIngredient, $$StoredStepIngredientsTableReferences),
          StoredStepIngredient,
          PrefetchHooks Function({bool stepGroupId, bool ingredientId})
        > {
  $$StoredStepIngredientsTableTableManager(
    _$AppDatabase db,
    $StoredStepIngredientsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StoredStepIngredientsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$StoredStepIngredientsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$StoredStepIngredientsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> stepGroupId = const Value.absent(),
                Value<int> ingredientId = const Value.absent(),
                Value<int> position = const Value.absent(),
              }) => StoredStepIngredientsCompanion(
                id: id,
                stepGroupId: stepGroupId,
                ingredientId: ingredientId,
                position: position,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int stepGroupId,
                required int ingredientId,
                required int position,
              }) => StoredStepIngredientsCompanion.insert(
                id: id,
                stepGroupId: stepGroupId,
                ingredientId: ingredientId,
                position: position,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $StoredStepIngredientsTable,
                    StoredStepIngredient
                  >(table),
                  $$StoredStepIngredientsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({stepGroupId = false, ingredientId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (stepGroupId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.stepGroupId,
                        referencedTable: $$StoredStepIngredientsTableReferences
                            ._stepGroupIdTable(db),
                        referencedColumn: $$StoredStepIngredientsTableReferences
                            ._stepGroupIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (ingredientId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.ingredientId,
                        referencedTable: $$StoredStepIngredientsTableReferences
                            ._ingredientIdTable(db),
                        referencedColumn: $$StoredStepIngredientsTableReferences
                            ._ingredientIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$StoredStepIngredientsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StoredStepIngredientsTable,
      StoredStepIngredient,
      $$StoredStepIngredientsTableFilterComposer,
      $$StoredStepIngredientsTableOrderingComposer,
      $$StoredStepIngredientsTableAnnotationComposer,
      $$StoredStepIngredientsTableCreateCompanionBuilder,
      $$StoredStepIngredientsTableUpdateCompanionBuilder,
      (StoredStepIngredient, $$StoredStepIngredientsTableReferences),
      StoredStepIngredient,
      PrefetchHooks Function({bool stepGroupId, bool ingredientId})
    >;
typedef $$IngredientCatalogEntriesTableCreateCompanionBuilder =
    IngredientCatalogEntriesCompanion Function({
      Value<int> id,
      required String name,
      required int position,
    });
typedef $$IngredientCatalogEntriesTableUpdateCompanionBuilder =
    IngredientCatalogEntriesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> position,
    });

class $$IngredientCatalogEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $IngredientCatalogEntriesTable> {
  $$IngredientCatalogEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );
}

class $$IngredientCatalogEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $IngredientCatalogEntriesTable> {
  $$IngredientCatalogEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$IngredientCatalogEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $IngredientCatalogEntriesTable> {
  $$IngredientCatalogEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);
}

class $$IngredientCatalogEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IngredientCatalogEntriesTable,
          IngredientCatalogEntry,
          $$IngredientCatalogEntriesTableFilterComposer,
          $$IngredientCatalogEntriesTableOrderingComposer,
          $$IngredientCatalogEntriesTableAnnotationComposer,
          $$IngredientCatalogEntriesTableCreateCompanionBuilder,
          $$IngredientCatalogEntriesTableUpdateCompanionBuilder,
          (
            IngredientCatalogEntry,
            BaseReferences<
              _$AppDatabase,
              $IngredientCatalogEntriesTable,
              IngredientCatalogEntry
            >,
          ),
          IngredientCatalogEntry,
          PrefetchHooks Function()
        > {
  $$IngredientCatalogEntriesTableTableManager(
    _$AppDatabase db,
    $IngredientCatalogEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IngredientCatalogEntriesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$IngredientCatalogEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$IngredientCatalogEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> position = const Value.absent(),
              }) => IngredientCatalogEntriesCompanion(
                id: id,
                name: name,
                position: position,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required int position,
              }) => IngredientCatalogEntriesCompanion.insert(
                id: id,
                name: name,
                position: position,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $IngredientCatalogEntriesTable,
                    IngredientCatalogEntry
                  >(table),
                  BaseReferences<
                    _$AppDatabase,
                    $IngredientCatalogEntriesTable,
                    IngredientCatalogEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$IngredientCatalogEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IngredientCatalogEntriesTable,
      IngredientCatalogEntry,
      $$IngredientCatalogEntriesTableFilterComposer,
      $$IngredientCatalogEntriesTableOrderingComposer,
      $$IngredientCatalogEntriesTableAnnotationComposer,
      $$IngredientCatalogEntriesTableCreateCompanionBuilder,
      $$IngredientCatalogEntriesTableUpdateCompanionBuilder,
      (
        IngredientCatalogEntry,
        BaseReferences<
          _$AppDatabase,
          $IngredientCatalogEntriesTable,
          IngredientCatalogEntry
        >,
      ),
      IngredientCatalogEntry,
      PrefetchHooks Function()
    >;
typedef $$NutritionCatalogEntriesTableCreateCompanionBuilder =
    NutritionCatalogEntriesCompanion Function({
      Value<int> id,
      required String name,
      required int position,
    });
typedef $$NutritionCatalogEntriesTableUpdateCompanionBuilder =
    NutritionCatalogEntriesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> position,
    });

class $$NutritionCatalogEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $NutritionCatalogEntriesTable> {
  $$NutritionCatalogEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NutritionCatalogEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $NutritionCatalogEntriesTable> {
  $$NutritionCatalogEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NutritionCatalogEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NutritionCatalogEntriesTable> {
  $$NutritionCatalogEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);
}

class $$NutritionCatalogEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NutritionCatalogEntriesTable,
          NutritionCatalogEntry,
          $$NutritionCatalogEntriesTableFilterComposer,
          $$NutritionCatalogEntriesTableOrderingComposer,
          $$NutritionCatalogEntriesTableAnnotationComposer,
          $$NutritionCatalogEntriesTableCreateCompanionBuilder,
          $$NutritionCatalogEntriesTableUpdateCompanionBuilder,
          (
            NutritionCatalogEntry,
            BaseReferences<
              _$AppDatabase,
              $NutritionCatalogEntriesTable,
              NutritionCatalogEntry
            >,
          ),
          NutritionCatalogEntry,
          PrefetchHooks Function()
        > {
  $$NutritionCatalogEntriesTableTableManager(
    _$AppDatabase db,
    $NutritionCatalogEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NutritionCatalogEntriesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$NutritionCatalogEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$NutritionCatalogEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> position = const Value.absent(),
              }) => NutritionCatalogEntriesCompanion(
                id: id,
                name: name,
                position: position,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required int position,
              }) => NutritionCatalogEntriesCompanion.insert(
                id: id,
                name: name,
                position: position,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $NutritionCatalogEntriesTable,
                    NutritionCatalogEntry
                  >(table),
                  BaseReferences<
                    _$AppDatabase,
                    $NutritionCatalogEntriesTable,
                    NutritionCatalogEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NutritionCatalogEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NutritionCatalogEntriesTable,
      NutritionCatalogEntry,
      $$NutritionCatalogEntriesTableFilterComposer,
      $$NutritionCatalogEntriesTableOrderingComposer,
      $$NutritionCatalogEntriesTableAnnotationComposer,
      $$NutritionCatalogEntriesTableCreateCompanionBuilder,
      $$NutritionCatalogEntriesTableUpdateCompanionBuilder,
      (
        NutritionCatalogEntry,
        BaseReferences<
          _$AppDatabase,
          $NutritionCatalogEntriesTable,
          NutritionCatalogEntry
        >,
      ),
      NutritionCatalogEntry,
      PrefetchHooks Function()
    >;
typedef $$CalendarEntriesTableCreateCompanionBuilder =
    CalendarEntriesCompanion Function({
      Value<int> id,
      required String scheduledAt,
      required String recipeName,
      required int position,
    });
typedef $$CalendarEntriesTableUpdateCompanionBuilder =
    CalendarEntriesCompanion Function({
      Value<int> id,
      Value<String> scheduledAt,
      Value<String> recipeName,
      Value<int> position,
    });

class $$CalendarEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $CalendarEntriesTable> {
  $$CalendarEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recipeName => $composableBuilder(
    column: $table.recipeName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CalendarEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CalendarEntriesTable> {
  $$CalendarEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recipeName => $composableBuilder(
    column: $table.recipeName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CalendarEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CalendarEntriesTable> {
  $$CalendarEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recipeName => $composableBuilder(
    column: $table.recipeName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);
}

class $$CalendarEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CalendarEntriesTable,
          CalendarEntry,
          $$CalendarEntriesTableFilterComposer,
          $$CalendarEntriesTableOrderingComposer,
          $$CalendarEntriesTableAnnotationComposer,
          $$CalendarEntriesTableCreateCompanionBuilder,
          $$CalendarEntriesTableUpdateCompanionBuilder,
          (
            CalendarEntry,
            BaseReferences<_$AppDatabase, $CalendarEntriesTable, CalendarEntry>,
          ),
          CalendarEntry,
          PrefetchHooks Function()
        > {
  $$CalendarEntriesTableTableManager(
    _$AppDatabase db,
    $CalendarEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CalendarEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CalendarEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CalendarEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> scheduledAt = const Value.absent(),
                Value<String> recipeName = const Value.absent(),
                Value<int> position = const Value.absent(),
              }) => CalendarEntriesCompanion(
                id: id,
                scheduledAt: scheduledAt,
                recipeName: recipeName,
                position: position,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String scheduledAt,
                required String recipeName,
                required int position,
              }) => CalendarEntriesCompanion.insert(
                id: id,
                scheduledAt: scheduledAt,
                recipeName: recipeName,
                position: position,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CalendarEntriesTable, CalendarEntry>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $CalendarEntriesTable,
                    CalendarEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CalendarEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CalendarEntriesTable,
      CalendarEntry,
      $$CalendarEntriesTableFilterComposer,
      $$CalendarEntriesTableOrderingComposer,
      $$CalendarEntriesTableAnnotationComposer,
      $$CalendarEntriesTableCreateCompanionBuilder,
      $$CalendarEntriesTableUpdateCompanionBuilder,
      (
        CalendarEntry,
        BaseReferences<_$AppDatabase, $CalendarEntriesTable, CalendarEntry>,
      ),
      CalendarEntry,
      PrefetchHooks Function()
    >;
typedef $$ShoppingSourcesTableCreateCompanionBuilder =
    ShoppingSourcesCompanion Function({
      Value<int> id,
      required String sourceKey,
      required String displayName,
      Value<bool> isSummary,
      Value<double?> currentServings,
      required int position,
    });
typedef $$ShoppingSourcesTableUpdateCompanionBuilder =
    ShoppingSourcesCompanion Function({
      Value<int> id,
      Value<String> sourceKey,
      Value<String> displayName,
      Value<bool> isSummary,
      Value<double?> currentServings,
      Value<int> position,
    });

final class $$ShoppingSourcesTableReferences
    extends
        BaseReferences<_$AppDatabase, $ShoppingSourcesTable, ShoppingSource> {
  $$ShoppingSourcesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$ShoppingItemsTable, List<ShoppingItem>>
  _shoppingItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.shoppingItems,
    aliasName: 'shopping_sources__id__shopping_items__source_id',
  );

  $$ShoppingItemsTableProcessedTableManager get shoppingItemsRefs {
    final manager = $$ShoppingItemsTableTableManager(
      $_db,
      $_db.shoppingItems,
    ).filter((f) => f.sourceId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_shoppingItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ShoppingSourcesTableFilterComposer
    extends Composer<_$AppDatabase, $ShoppingSourcesTable> {
  $$ShoppingSourcesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceKey => $composableBuilder(
    column: $table.sourceKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSummary => $composableBuilder(
    column: $table.isSummary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get currentServings => $composableBuilder(
    column: $table.currentServings,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> shoppingItemsRefs(
    Expression<bool> Function($$ShoppingItemsTableFilterComposer f) f,
  ) {
    final $$ShoppingItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.shoppingItems,
      getReferencedColumn: (t) => t.sourceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShoppingItemsTableFilterComposer(
            $db: $db,
            $table: $db.shoppingItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ShoppingSourcesTableOrderingComposer
    extends Composer<_$AppDatabase, $ShoppingSourcesTable> {
  $$ShoppingSourcesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceKey => $composableBuilder(
    column: $table.sourceKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSummary => $composableBuilder(
    column: $table.isSummary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get currentServings => $composableBuilder(
    column: $table.currentServings,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ShoppingSourcesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShoppingSourcesTable> {
  $$ShoppingSourcesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sourceKey =>
      $composableBuilder(column: $table.sourceKey, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSummary =>
      $composableBuilder(column: $table.isSummary, builder: (column) => column);

  GeneratedColumn<double> get currentServings => $composableBuilder(
    column: $table.currentServings,
    builder: (column) => column,
  );

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  Expression<T> shoppingItemsRefs<T extends Object>(
    Expression<T> Function($$ShoppingItemsTableAnnotationComposer a) f,
  ) {
    final $$ShoppingItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.shoppingItems,
      getReferencedColumn: (t) => t.sourceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShoppingItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.shoppingItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ShoppingSourcesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShoppingSourcesTable,
          ShoppingSource,
          $$ShoppingSourcesTableFilterComposer,
          $$ShoppingSourcesTableOrderingComposer,
          $$ShoppingSourcesTableAnnotationComposer,
          $$ShoppingSourcesTableCreateCompanionBuilder,
          $$ShoppingSourcesTableUpdateCompanionBuilder,
          (ShoppingSource, $$ShoppingSourcesTableReferences),
          ShoppingSource,
          PrefetchHooks Function({bool shoppingItemsRefs})
        > {
  $$ShoppingSourcesTableTableManager(
    _$AppDatabase db,
    $ShoppingSourcesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShoppingSourcesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShoppingSourcesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShoppingSourcesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> sourceKey = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<bool> isSummary = const Value.absent(),
                Value<double?> currentServings = const Value.absent(),
                Value<int> position = const Value.absent(),
              }) => ShoppingSourcesCompanion(
                id: id,
                sourceKey: sourceKey,
                displayName: displayName,
                isSummary: isSummary,
                currentServings: currentServings,
                position: position,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String sourceKey,
                required String displayName,
                Value<bool> isSummary = const Value.absent(),
                Value<double?> currentServings = const Value.absent(),
                required int position,
              }) => ShoppingSourcesCompanion.insert(
                id: id,
                sourceKey: sourceKey,
                displayName: displayName,
                isSummary: isSummary,
                currentServings: currentServings,
                position: position,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ShoppingSourcesTable, ShoppingSource>(table),
                  $$ShoppingSourcesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({shoppingItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (shoppingItemsRefs) db.shoppingItems,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (shoppingItemsRefs)
                    await $_getPrefetchedData<
                      ShoppingSource,
                      $ShoppingSourcesTable,
                      ShoppingItem
                    >(
                      currentTable: table,
                      referencedTable: $$ShoppingSourcesTableReferences
                          ._shoppingItemsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ShoppingSourcesTableReferences(
                            db,
                            table,
                            p0,
                          ).shoppingItemsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.sourceId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ShoppingSourcesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShoppingSourcesTable,
      ShoppingSource,
      $$ShoppingSourcesTableFilterComposer,
      $$ShoppingSourcesTableOrderingComposer,
      $$ShoppingSourcesTableAnnotationComposer,
      $$ShoppingSourcesTableCreateCompanionBuilder,
      $$ShoppingSourcesTableUpdateCompanionBuilder,
      (ShoppingSource, $$ShoppingSourcesTableReferences),
      ShoppingSource,
      PrefetchHooks Function({bool shoppingItemsRefs})
    >;
typedef $$ShoppingItemsTableCreateCompanionBuilder =
    ShoppingItemsCompanion Function({
      Value<int> id,
      required int sourceId,
      required int position,
      required String name,
      Value<double?> amount,
      Value<String?> unit,
      required bool checked,
    });
typedef $$ShoppingItemsTableUpdateCompanionBuilder =
    ShoppingItemsCompanion Function({
      Value<int> id,
      Value<int> sourceId,
      Value<int> position,
      Value<String> name,
      Value<double?> amount,
      Value<String?> unit,
      Value<bool> checked,
    });

final class $$ShoppingItemsTableReferences
    extends BaseReferences<_$AppDatabase, $ShoppingItemsTable, ShoppingItem> {
  $$ShoppingItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ShoppingSourcesTable _sourceIdTable(_$AppDatabase db) => db
      .shoppingSources
      .createAlias('shopping_items__source_id__shopping_sources__id');

  $$ShoppingSourcesTableProcessedTableManager get sourceId {
    final $_column = $_itemColumn<int>('source_id')!;

    final manager = $$ShoppingSourcesTableTableManager(
      $_db,
      $_db.shoppingSources,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sourceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ShoppingItemsTableFilterComposer
    extends Composer<_$AppDatabase, $ShoppingItemsTable> {
  $$ShoppingItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get checked => $composableBuilder(
    column: $table.checked,
    builder: (column) => ColumnFilters(column),
  );

  $$ShoppingSourcesTableFilterComposer get sourceId {
    final $$ShoppingSourcesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceId,
      referencedTable: $db.shoppingSources,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShoppingSourcesTableFilterComposer(
            $db: $db,
            $table: $db.shoppingSources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShoppingItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ShoppingItemsTable> {
  $$ShoppingItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get checked => $composableBuilder(
    column: $table.checked,
    builder: (column) => ColumnOrderings(column),
  );

  $$ShoppingSourcesTableOrderingComposer get sourceId {
    final $$ShoppingSourcesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceId,
      referencedTable: $db.shoppingSources,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShoppingSourcesTableOrderingComposer(
            $db: $db,
            $table: $db.shoppingSources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShoppingItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShoppingItemsTable> {
  $$ShoppingItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<bool> get checked =>
      $composableBuilder(column: $table.checked, builder: (column) => column);

  $$ShoppingSourcesTableAnnotationComposer get sourceId {
    final $$ShoppingSourcesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceId,
      referencedTable: $db.shoppingSources,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShoppingSourcesTableAnnotationComposer(
            $db: $db,
            $table: $db.shoppingSources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShoppingItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShoppingItemsTable,
          ShoppingItem,
          $$ShoppingItemsTableFilterComposer,
          $$ShoppingItemsTableOrderingComposer,
          $$ShoppingItemsTableAnnotationComposer,
          $$ShoppingItemsTableCreateCompanionBuilder,
          $$ShoppingItemsTableUpdateCompanionBuilder,
          (ShoppingItem, $$ShoppingItemsTableReferences),
          ShoppingItem,
          PrefetchHooks Function({bool sourceId})
        > {
  $$ShoppingItemsTableTableManager(_$AppDatabase db, $ShoppingItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShoppingItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShoppingItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShoppingItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> sourceId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double?> amount = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<bool> checked = const Value.absent(),
              }) => ShoppingItemsCompanion(
                id: id,
                sourceId: sourceId,
                position: position,
                name: name,
                amount: amount,
                unit: unit,
                checked: checked,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int sourceId,
                required int position,
                required String name,
                Value<double?> amount = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                required bool checked,
              }) => ShoppingItemsCompanion.insert(
                id: id,
                sourceId: sourceId,
                position: position,
                name: name,
                amount: amount,
                unit: unit,
                checked: checked,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ShoppingItemsTable, ShoppingItem>(table),
                  $$ShoppingItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sourceId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sourceId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.sourceId,
                        referencedTable: $$ShoppingItemsTableReferences
                            ._sourceIdTable(db),
                        referencedColumn: $$ShoppingItemsTableReferences
                            ._sourceIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ShoppingItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShoppingItemsTable,
      ShoppingItem,
      $$ShoppingItemsTableFilterComposer,
      $$ShoppingItemsTableOrderingComposer,
      $$ShoppingItemsTableAnnotationComposer,
      $$ShoppingItemsTableCreateCompanionBuilder,
      $$ShoppingItemsTableUpdateCompanionBuilder,
      (ShoppingItem, $$ShoppingItemsTableReferences),
      ShoppingItem,
      PrefetchHooks Function({bool sourceId})
    >;
typedef $$RecipeDraftsTableCreateCompanionBuilder =
    RecipeDraftsCompanion Function({
      required String slot,
      required int codecVersion,
      required String payload,
      Value<int> rowid,
    });
typedef $$RecipeDraftsTableUpdateCompanionBuilder =
    RecipeDraftsCompanion Function({
      Value<String> slot,
      Value<int> codecVersion,
      Value<String> payload,
      Value<int> rowid,
    });

class $$RecipeDraftsTableFilterComposer
    extends Composer<_$AppDatabase, $RecipeDraftsTable> {
  $$RecipeDraftsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get slot => $composableBuilder(
    column: $table.slot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get codecVersion => $composableBuilder(
    column: $table.codecVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RecipeDraftsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipeDraftsTable> {
  $$RecipeDraftsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get slot => $composableBuilder(
    column: $table.slot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get codecVersion => $composableBuilder(
    column: $table.codecVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecipeDraftsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipeDraftsTable> {
  $$RecipeDraftsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get slot =>
      $composableBuilder(column: $table.slot, builder: (column) => column);

  GeneratedColumn<int> get codecVersion => $composableBuilder(
    column: $table.codecVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);
}

class $$RecipeDraftsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecipeDraftsTable,
          RecipeDraft,
          $$RecipeDraftsTableFilterComposer,
          $$RecipeDraftsTableOrderingComposer,
          $$RecipeDraftsTableAnnotationComposer,
          $$RecipeDraftsTableCreateCompanionBuilder,
          $$RecipeDraftsTableUpdateCompanionBuilder,
          (
            RecipeDraft,
            BaseReferences<_$AppDatabase, $RecipeDraftsTable, RecipeDraft>,
          ),
          RecipeDraft,
          PrefetchHooks Function()
        > {
  $$RecipeDraftsTableTableManager(_$AppDatabase db, $RecipeDraftsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipeDraftsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipeDraftsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipeDraftsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> slot = const Value.absent(),
                Value<int> codecVersion = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecipeDraftsCompanion(
                slot: slot,
                codecVersion: codecVersion,
                payload: payload,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String slot,
                required int codecVersion,
                required String payload,
                Value<int> rowid = const Value.absent(),
              }) => RecipeDraftsCompanion.insert(
                slot: slot,
                codecVersion: codecVersion,
                payload: payload,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RecipeDraftsTable, RecipeDraft>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $RecipeDraftsTable,
                    RecipeDraft
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RecipeDraftsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecipeDraftsTable,
      RecipeDraft,
      $$RecipeDraftsTableFilterComposer,
      $$RecipeDraftsTableOrderingComposer,
      $$RecipeDraftsTableAnnotationComposer,
      $$RecipeDraftsTableCreateCompanionBuilder,
      $$RecipeDraftsTableUpdateCompanionBuilder,
      (
        RecipeDraft,
        BaseReferences<_$AppDatabase, $RecipeDraftsTable, RecipeDraft>,
      ),
      RecipeDraft,
      PrefetchHooks Function()
    >;
typedef $$DeletionTombstonesTableCreateCompanionBuilder =
    DeletionTombstonesCompanion Function({
      required String recipeName,
      required String deletedAt,
      Value<int> rowid,
    });
typedef $$DeletionTombstonesTableUpdateCompanionBuilder =
    DeletionTombstonesCompanion Function({
      Value<String> recipeName,
      Value<String> deletedAt,
      Value<int> rowid,
    });

class $$DeletionTombstonesTableFilterComposer
    extends Composer<_$AppDatabase, $DeletionTombstonesTable> {
  $$DeletionTombstonesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get recipeName => $composableBuilder(
    column: $table.recipeName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DeletionTombstonesTableOrderingComposer
    extends Composer<_$AppDatabase, $DeletionTombstonesTable> {
  $$DeletionTombstonesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get recipeName => $composableBuilder(
    column: $table.recipeName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DeletionTombstonesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DeletionTombstonesTable> {
  $$DeletionTombstonesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get recipeName => $composableBuilder(
    column: $table.recipeName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$DeletionTombstonesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DeletionTombstonesTable,
          DeletionTombstone,
          $$DeletionTombstonesTableFilterComposer,
          $$DeletionTombstonesTableOrderingComposer,
          $$DeletionTombstonesTableAnnotationComposer,
          $$DeletionTombstonesTableCreateCompanionBuilder,
          $$DeletionTombstonesTableUpdateCompanionBuilder,
          (
            DeletionTombstone,
            BaseReferences<
              _$AppDatabase,
              $DeletionTombstonesTable,
              DeletionTombstone
            >,
          ),
          DeletionTombstone,
          PrefetchHooks Function()
        > {
  $$DeletionTombstonesTableTableManager(
    _$AppDatabase db,
    $DeletionTombstonesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DeletionTombstonesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DeletionTombstonesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DeletionTombstonesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> recipeName = const Value.absent(),
                Value<String> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DeletionTombstonesCompanion(
                recipeName: recipeName,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String recipeName,
                required String deletedAt,
                Value<int> rowid = const Value.absent(),
              }) => DeletionTombstonesCompanion.insert(
                recipeName: recipeName,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DeletionTombstonesTable, DeletionTombstone>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $DeletionTombstonesTable,
                    DeletionTombstone
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DeletionTombstonesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DeletionTombstonesTable,
      DeletionTombstone,
      $$DeletionTombstonesTableFilterComposer,
      $$DeletionTombstonesTableOrderingComposer,
      $$DeletionTombstonesTableAnnotationComposer,
      $$DeletionTombstonesTableCreateCompanionBuilder,
      $$DeletionTombstonesTableUpdateCompanionBuilder,
      (
        DeletionTombstone,
        BaseReferences<
          _$AppDatabase,
          $DeletionTombstonesTable,
          DeletionTombstone
        >,
      ),
      DeletionTombstone,
      PrefetchHooks Function()
    >;
typedef $$StorageMetadataTableCreateCompanionBuilder =
    StorageMetadataCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$StorageMetadataTableUpdateCompanionBuilder =
    StorageMetadataCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$StorageMetadataTableFilterComposer
    extends Composer<_$AppDatabase, $StorageMetadataTable> {
  $$StorageMetadataTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StorageMetadataTableOrderingComposer
    extends Composer<_$AppDatabase, $StorageMetadataTable> {
  $$StorageMetadataTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StorageMetadataTableAnnotationComposer
    extends Composer<_$AppDatabase, $StorageMetadataTable> {
  $$StorageMetadataTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$StorageMetadataTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StorageMetadataTable,
          StorageMetadataData,
          $$StorageMetadataTableFilterComposer,
          $$StorageMetadataTableOrderingComposer,
          $$StorageMetadataTableAnnotationComposer,
          $$StorageMetadataTableCreateCompanionBuilder,
          $$StorageMetadataTableUpdateCompanionBuilder,
          (
            StorageMetadataData,
            BaseReferences<
              _$AppDatabase,
              $StorageMetadataTable,
              StorageMetadataData
            >,
          ),
          StorageMetadataData,
          PrefetchHooks Function()
        > {
  $$StorageMetadataTableTableManager(
    _$AppDatabase db,
    $StorageMetadataTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StorageMetadataTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StorageMetadataTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StorageMetadataTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => StorageMetadataCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => StorageMetadataCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StorageMetadataTable, StorageMetadataData>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $StorageMetadataTable,
                    StorageMetadataData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StorageMetadataTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StorageMetadataTable,
      StorageMetadataData,
      $$StorageMetadataTableFilterComposer,
      $$StorageMetadataTableOrderingComposer,
      $$StorageMetadataTableAnnotationComposer,
      $$StorageMetadataTableCreateCompanionBuilder,
      $$StorageMetadataTableUpdateCompanionBuilder,
      (
        StorageMetadataData,
        BaseReferences<
          _$AppDatabase,
          $StorageMetadataTable,
          StorageMetadataData
        >,
      ),
      StorageMetadataData,
      PrefetchHooks Function()
    >;
typedef $$LegacyMigrationIssuesTableCreateCompanionBuilder =
    LegacyMigrationIssuesCompanion Function({
      required String legacyKey,
      required String errorCode,
      Value<bool> resolved,
      Value<int> rowid,
    });
typedef $$LegacyMigrationIssuesTableUpdateCompanionBuilder =
    LegacyMigrationIssuesCompanion Function({
      Value<String> legacyKey,
      Value<String> errorCode,
      Value<bool> resolved,
      Value<int> rowid,
    });

class $$LegacyMigrationIssuesTableFilterComposer
    extends Composer<_$AppDatabase, $LegacyMigrationIssuesTable> {
  $$LegacyMigrationIssuesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get legacyKey => $composableBuilder(
    column: $table.legacyKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get errorCode => $composableBuilder(
    column: $table.errorCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get resolved => $composableBuilder(
    column: $table.resolved,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LegacyMigrationIssuesTableOrderingComposer
    extends Composer<_$AppDatabase, $LegacyMigrationIssuesTable> {
  $$LegacyMigrationIssuesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get legacyKey => $composableBuilder(
    column: $table.legacyKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get errorCode => $composableBuilder(
    column: $table.errorCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get resolved => $composableBuilder(
    column: $table.resolved,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LegacyMigrationIssuesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LegacyMigrationIssuesTable> {
  $$LegacyMigrationIssuesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get legacyKey =>
      $composableBuilder(column: $table.legacyKey, builder: (column) => column);

  GeneratedColumn<String> get errorCode =>
      $composableBuilder(column: $table.errorCode, builder: (column) => column);

  GeneratedColumn<bool> get resolved =>
      $composableBuilder(column: $table.resolved, builder: (column) => column);
}

class $$LegacyMigrationIssuesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LegacyMigrationIssuesTable,
          LegacyMigrationIssue,
          $$LegacyMigrationIssuesTableFilterComposer,
          $$LegacyMigrationIssuesTableOrderingComposer,
          $$LegacyMigrationIssuesTableAnnotationComposer,
          $$LegacyMigrationIssuesTableCreateCompanionBuilder,
          $$LegacyMigrationIssuesTableUpdateCompanionBuilder,
          (
            LegacyMigrationIssue,
            BaseReferences<
              _$AppDatabase,
              $LegacyMigrationIssuesTable,
              LegacyMigrationIssue
            >,
          ),
          LegacyMigrationIssue,
          PrefetchHooks Function()
        > {
  $$LegacyMigrationIssuesTableTableManager(
    _$AppDatabase db,
    $LegacyMigrationIssuesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LegacyMigrationIssuesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$LegacyMigrationIssuesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LegacyMigrationIssuesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> legacyKey = const Value.absent(),
                Value<String> errorCode = const Value.absent(),
                Value<bool> resolved = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LegacyMigrationIssuesCompanion(
                legacyKey: legacyKey,
                errorCode: errorCode,
                resolved: resolved,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String legacyKey,
                required String errorCode,
                Value<bool> resolved = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LegacyMigrationIssuesCompanion.insert(
                legacyKey: legacyKey,
                errorCode: errorCode,
                resolved: resolved,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $LegacyMigrationIssuesTable,
                    LegacyMigrationIssue
                  >(table),
                  BaseReferences<
                    _$AppDatabase,
                    $LegacyMigrationIssuesTable,
                    LegacyMigrationIssue
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LegacyMigrationIssuesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LegacyMigrationIssuesTable,
      LegacyMigrationIssue,
      $$LegacyMigrationIssuesTableFilterComposer,
      $$LegacyMigrationIssuesTableOrderingComposer,
      $$LegacyMigrationIssuesTableAnnotationComposer,
      $$LegacyMigrationIssuesTableCreateCompanionBuilder,
      $$LegacyMigrationIssuesTableUpdateCompanionBuilder,
      (
        LegacyMigrationIssue,
        BaseReferences<
          _$AppDatabase,
          $LegacyMigrationIssuesTable,
          LegacyMigrationIssue
        >,
      ),
      LegacyMigrationIssue,
      PrefetchHooks Function()
    >;
typedef $$LegacyBackupFilesTableCreateCompanionBuilder =
    LegacyBackupFilesCompanion Function({
      required String path,
      required int byteLength,
      required String sha256Digest,
      Value<int> rowid,
    });
typedef $$LegacyBackupFilesTableUpdateCompanionBuilder =
    LegacyBackupFilesCompanion Function({
      Value<String> path,
      Value<int> byteLength,
      Value<String> sha256Digest,
      Value<int> rowid,
    });

class $$LegacyBackupFilesTableFilterComposer
    extends Composer<_$AppDatabase, $LegacyBackupFilesTable> {
  $$LegacyBackupFilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get byteLength => $composableBuilder(
    column: $table.byteLength,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sha256Digest => $composableBuilder(
    column: $table.sha256Digest,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LegacyBackupFilesTableOrderingComposer
    extends Composer<_$AppDatabase, $LegacyBackupFilesTable> {
  $$LegacyBackupFilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get byteLength => $composableBuilder(
    column: $table.byteLength,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sha256Digest => $composableBuilder(
    column: $table.sha256Digest,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LegacyBackupFilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LegacyBackupFilesTable> {
  $$LegacyBackupFilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<int> get byteLength => $composableBuilder(
    column: $table.byteLength,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sha256Digest => $composableBuilder(
    column: $table.sha256Digest,
    builder: (column) => column,
  );
}

class $$LegacyBackupFilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LegacyBackupFilesTable,
          LegacyBackupFile,
          $$LegacyBackupFilesTableFilterComposer,
          $$LegacyBackupFilesTableOrderingComposer,
          $$LegacyBackupFilesTableAnnotationComposer,
          $$LegacyBackupFilesTableCreateCompanionBuilder,
          $$LegacyBackupFilesTableUpdateCompanionBuilder,
          (
            LegacyBackupFile,
            BaseReferences<
              _$AppDatabase,
              $LegacyBackupFilesTable,
              LegacyBackupFile
            >,
          ),
          LegacyBackupFile,
          PrefetchHooks Function()
        > {
  $$LegacyBackupFilesTableTableManager(
    _$AppDatabase db,
    $LegacyBackupFilesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LegacyBackupFilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LegacyBackupFilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LegacyBackupFilesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> path = const Value.absent(),
                Value<int> byteLength = const Value.absent(),
                Value<String> sha256Digest = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LegacyBackupFilesCompanion(
                path: path,
                byteLength: byteLength,
                sha256Digest: sha256Digest,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String path,
                required int byteLength,
                required String sha256Digest,
                Value<int> rowid = const Value.absent(),
              }) => LegacyBackupFilesCompanion.insert(
                path: path,
                byteLength: byteLength,
                sha256Digest: sha256Digest,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LegacyBackupFilesTable, LegacyBackupFile>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $LegacyBackupFilesTable,
                    LegacyBackupFile
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LegacyBackupFilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LegacyBackupFilesTable,
      LegacyBackupFile,
      $$LegacyBackupFilesTableFilterComposer,
      $$LegacyBackupFilesTableOrderingComposer,
      $$LegacyBackupFilesTableAnnotationComposer,
      $$LegacyBackupFilesTableCreateCompanionBuilder,
      $$LegacyBackupFilesTableUpdateCompanionBuilder,
      (
        LegacyBackupFile,
        BaseReferences<
          _$AppDatabase,
          $LegacyBackupFilesTable,
          LegacyBackupFile
        >,
      ),
      LegacyBackupFile,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$StoredRecipesTableTableManager get storedRecipes =>
      $$StoredRecipesTableTableManager(_db, _db.storedRecipes);
  $$StoredCategoriesTableTableManager get storedCategories =>
      $$StoredCategoriesTableTableManager(_db, _db.storedCategories);
  $$StoredRecipeCategoriesTableTableManager get storedRecipeCategories =>
      $$StoredRecipeCategoriesTableTableManager(
        _db,
        _db.storedRecipeCategories,
      );
  $$StoredTagsTableTableManager get storedTags =>
      $$StoredTagsTableTableManager(_db, _db.storedTags);
  $$StoredRecipeTagsTableTableManager get storedRecipeTags =>
      $$StoredRecipeTagsTableTableManager(_db, _db.storedRecipeTags);
  $$StoredIngredientGroupsTableTableManager get storedIngredientGroups =>
      $$StoredIngredientGroupsTableTableManager(
        _db,
        _db.storedIngredientGroups,
      );
  $$StoredIngredientsTableTableManager get storedIngredients =>
      $$StoredIngredientsTableTableManager(_db, _db.storedIngredients);
  $$StoredNutritionsTableTableManager get storedNutritions =>
      $$StoredNutritionsTableTableManager(_db, _db.storedNutritions);
  $$StoredStepGroupsTableTableManager get storedStepGroups =>
      $$StoredStepGroupsTableTableManager(_db, _db.storedStepGroups);
  $$StoredStepImagesTableTableManager get storedStepImages =>
      $$StoredStepImagesTableTableManager(_db, _db.storedStepImages);
  $$StoredStepIngredientsTableTableManager get storedStepIngredients =>
      $$StoredStepIngredientsTableTableManager(_db, _db.storedStepIngredients);
  $$IngredientCatalogEntriesTableTableManager get ingredientCatalogEntries =>
      $$IngredientCatalogEntriesTableTableManager(
        _db,
        _db.ingredientCatalogEntries,
      );
  $$NutritionCatalogEntriesTableTableManager get nutritionCatalogEntries =>
      $$NutritionCatalogEntriesTableTableManager(
        _db,
        _db.nutritionCatalogEntries,
      );
  $$CalendarEntriesTableTableManager get calendarEntries =>
      $$CalendarEntriesTableTableManager(_db, _db.calendarEntries);
  $$ShoppingSourcesTableTableManager get shoppingSources =>
      $$ShoppingSourcesTableTableManager(_db, _db.shoppingSources);
  $$ShoppingItemsTableTableManager get shoppingItems =>
      $$ShoppingItemsTableTableManager(_db, _db.shoppingItems);
  $$RecipeDraftsTableTableManager get recipeDrafts =>
      $$RecipeDraftsTableTableManager(_db, _db.recipeDrafts);
  $$DeletionTombstonesTableTableManager get deletionTombstones =>
      $$DeletionTombstonesTableTableManager(_db, _db.deletionTombstones);
  $$StorageMetadataTableTableManager get storageMetadata =>
      $$StorageMetadataTableTableManager(_db, _db.storageMetadata);
  $$LegacyMigrationIssuesTableTableManager get legacyMigrationIssues =>
      $$LegacyMigrationIssuesTableTableManager(_db, _db.legacyMigrationIssues);
  $$LegacyBackupFilesTableTableManager get legacyBackupFiles =>
      $$LegacyBackupFilesTableTableManager(_db, _db.legacyBackupFiles);
}
