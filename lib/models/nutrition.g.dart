// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nutrition.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NutritionAdapter extends TypeAdapter<Nutrition> {
  @override
  Nutrition read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Nutrition(
      name: fields[0] as String,
      amountUnit: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Nutrition obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.amountUnit);
  }

  @override
  int get typeId => 4;
}
