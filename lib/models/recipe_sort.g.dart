// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_sort.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RSortAdapter extends TypeAdapter<RSort> {
  @override
  RSort read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RSort(
      fields[0] as RecipeSort,
      fields[1] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, RSort obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.sort)
      ..writeByte(1)
      ..write(obj.ascending);
  }
}
