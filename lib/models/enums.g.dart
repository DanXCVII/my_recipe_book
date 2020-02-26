// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enums.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VegetableAdapter extends TypeAdapter<Vegetable> {
  @override
  Vegetable read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Vegetable.NON_VEGETARIAN;
      case 1:
        return Vegetable.VEGETARIAN;
      case 2:
        return Vegetable.VEGAN;
      default:
        return null;
    }
  }

  @override
  void write(BinaryWriter writer, Vegetable obj) {
    switch (obj) {
      case Vegetable.NON_VEGETARIAN:
        writer.writeByte(0);
        break;
      case Vegetable.VEGETARIAN:
        writer.writeByte(1);
        break;
      case Vegetable.VEGAN:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get typeId => 1;
}

class RecipeSortAdapter extends TypeAdapter<RecipeSort> {
  @override
  RecipeSort read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return RecipeSort.BY_NAME;
      case 1:
        return RecipeSort.BY_INGREDIENT_COUNT;
      case 2:
        return RecipeSort.BY_EFFORT;
      case 3:
        return RecipeSort.BY_LAST_MODIFIED;
      default:
        return null;
    }
  }

  @override
  void write(BinaryWriter writer, RecipeSort obj) {
    switch (obj) {
      case RecipeSort.BY_NAME:
        writer.writeByte(0);
        break;
      case RecipeSort.BY_INGREDIENT_COUNT:
        writer.writeByte(1);
        break;
      case RecipeSort.BY_EFFORT:
        writer.writeByte(2);
        break;
      case RecipeSort.BY_LAST_MODIFIED:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get typeId => 2;
}
