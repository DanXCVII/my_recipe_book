// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../recipe.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecipeAdapter extends TypeAdapter<Recipe> {
  @override
  Recipe read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Recipe(
      name: fields[0] as String,
      imagePath: fields[1] as String,
      imagePreviewPath: fields[2] as String,
      preperationTime: fields[3] as double,
      cookingTime: fields[4] as double,
      totalTime: fields[5] as double,
      servings: fields[6] as double,
      ingredientsGlossary: (fields[8] as List)?.cast<String>(),
      ingredients: (fields[9] as List)
          ?.map((dynamic e) => (e as List)?.cast<Ingredient>())
          ?.toList(),
      vegetable: fields[10] as Vegetable,
      steps: (fields[11] as List)?.cast<String>(),
      stepImages: (fields[12] as List)
          ?.map((dynamic e) => (e as List)?.cast<String>())
          ?.toList(),
      notes: fields[13] as String,
      nutritions: (fields[14] as List)?.cast<Nutrition>(),
      categories: (fields[7] as List)?.cast<String>(),
      effort: fields[16] as int,
      isFavorite: fields[15] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Recipe obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.imagePath)
      ..writeByte(2)
      ..write(obj.imagePreviewPath)
      ..writeByte(3)
      ..write(obj.preperationTime)
      ..writeByte(4)
      ..write(obj.cookingTime)
      ..writeByte(5)
      ..write(obj.totalTime)
      ..writeByte(6)
      ..write(obj.servings)
      ..writeByte(7)
      ..write(obj.categories)
      ..writeByte(8)
      ..write(obj.ingredientsGlossary)
      ..writeByte(9)
      ..write(obj.ingredients)
      ..writeByte(10)
      ..write(obj.vegetable)
      ..writeByte(11)
      ..write(obj.steps)
      ..writeByte(12)
      ..write(obj.stepImages)
      ..writeByte(13)
      ..write(obj.notes)
      ..writeByte(14)
      ..write(obj.nutritions)
      ..writeByte(15)
      ..write(obj.isFavorite)
      ..writeByte(16)
      ..write(obj.effort);
  }
}
