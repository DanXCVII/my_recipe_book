import 'package:hive_ce/hive_ce.dart';

import '../models/enums.dart';
import '../models/ingredient.dart';
import '../models/nutrition.dart';
import '../models/recipe.dart';
import '../models/recipe_sort.dart';
import '../models/string_int_tuple.dart';
import '../models/string_string_tuple.dart';

abstract class _ReadOnlyLegacyAdapter<T> extends TypeAdapter<T> {
  @override
  void write(BinaryWriter writer, T obj) =>
      throw UnsupportedError('Legacy Hive adapters are read-only');
}

class VegetableAdapter extends _ReadOnlyLegacyAdapter<Vegetable> {
  @override
  final int typeId = 1;

  @override
  Vegetable read(BinaryReader reader) => switch (reader.readByte()) {
    0 => Vegetable.NON_VEGETARIAN,
    1 => Vegetable.VEGETARIAN,
    2 => Vegetable.VEGAN,
    _ => Vegetable.NON_VEGETARIAN,
  };
}

class RecipeSortAdapter extends _ReadOnlyLegacyAdapter<RecipeSort> {
  @override
  final int typeId = 2;

  @override
  RecipeSort read(BinaryReader reader) => switch (reader.readByte()) {
    0 => RecipeSort.BY_NAME,
    1 => RecipeSort.BY_INGREDIENT_COUNT,
    2 => RecipeSort.BY_EFFORT,
    3 => RecipeSort.BY_LAST_MODIFIED,
    _ => RecipeSort.BY_LAST_MODIFIED,
  };
}

class IngredientAdapter extends _ReadOnlyLegacyAdapter<Ingredient> {
  @override
  final int typeId = 3;

  @override
  Ingredient read(BinaryReader reader) {
    final fields = _readFields(reader);
    return Ingredient(
      name: fields[0] as String,
      amount: (fields[1] as num?)?.toDouble(),
      unit: fields[2] as String?,
    );
  }
}

class CheckableIngredientAdapter
    extends _ReadOnlyLegacyAdapter<CheckableIngredient> {
  @override
  final int typeId = 4;

  @override
  CheckableIngredient read(BinaryReader reader) {
    final fields = _readFields(reader);
    return CheckableIngredient(
      fields[0] as String,
      (fields[1] as num?)?.toDouble(),
      fields[2] as String?,
      fields[3] as bool,
    );
  }
}

class NutritionAdapter extends _ReadOnlyLegacyAdapter<Nutrition> {
  @override
  final int typeId = 5;

  @override
  Nutrition read(BinaryReader reader) {
    final fields = _readFields(reader);
    return Nutrition(
      name: fields[0] as String,
      amountUnit: fields[1] as String,
    );
  }
}

class RSortAdapter extends _ReadOnlyLegacyAdapter<RSort> {
  @override
  final int typeId = 6;

  @override
  RSort read(BinaryReader reader) {
    final fields = _readFields(reader);
    return RSort(fields[0] as RecipeSort, fields[1] as bool?);
  }
}

class RecipeAdapter extends _ReadOnlyLegacyAdapter<Recipe> {
  @override
  final int typeId = 7;

  @override
  Recipe read(BinaryReader reader) {
    final fields = _readFields(reader);
    return Recipe(
      name: fields[0] as String? ?? '',
      imagePath: fields[1] as String,
      imagePreviewPath: fields[2] as String,
      preperationTime: (fields[3] as num).toDouble(),
      cookingTime: (fields[4] as num).toDouble(),
      totalTime: (fields[5] as num).toDouble(),
      servings: (fields[6] as num?)?.toDouble(),
      categories: (fields[7] as List).cast<String>(),
      ingredientsGlossary: (fields[8] as List).cast<String>(),
      ingredients: (fields[9] as List)
          .map((group) => (group as List).cast<Ingredient>())
          .toList(),
      vegetable: fields[10] as Vegetable? ?? Vegetable.VEGAN,
      steps: (fields[11] as List).cast<String>(),
      stepImages: (fields[12] as List)
          .map((group) => (group as List).cast<String>())
          .toList(),
      notes: fields[13] as String,
      nutritions: (fields[14] as List).cast<Nutrition>(),
      isFavorite: fields[15] as bool,
      effort: fields[16] as int?,
      lastModified: fields[17] as String? ?? firstModified,
      rating: fields[18] as int?,
      tags: (fields[19] as List).cast<StringIntTuple>(),
      source: fields[20] as String?,
      servingName: fields[21] as String?,
      stepTitles: (fields[22] as List? ?? []).cast<String>(),
    );
  }
}

class StringIntTupleAdapter extends _ReadOnlyLegacyAdapter<StringIntTuple> {
  @override
  final int typeId = 9;

  @override
  StringIntTuple read(BinaryReader reader) {
    final fields = _readFields(reader);
    return StringIntTuple(
      text: fields[0] as String,
      number: (fields[1] as num).toInt(),
    );
  }
}

class StringStringTupleAdapter
    extends _ReadOnlyLegacyAdapter<StringStringTuple> {
  @override
  final int typeId = 10;

  @override
  StringStringTuple read(BinaryReader reader) {
    final fields = _readFields(reader);
    return StringStringTuple(
      name: fields[0] as String,
      value: fields[1] as String,
    );
  }
}

Map<int, dynamic> _readFields(BinaryReader reader) {
  final count = reader.readByte();
  return <int, dynamic>{
    for (var index = 0; index < count; index++)
      reader.readByte(): reader.read(),
  };
}
