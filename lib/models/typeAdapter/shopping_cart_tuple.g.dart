// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../shopping_cart_tuple.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StringListTupleAdapter extends TypeAdapter<StringListTuple> {
  @override
  StringListTuple read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StringListTuple(
      fields[0] as String,
      (fields[1] as List)?.cast<CheckableIngredient>(),
    );
  }

  @override
  void write(BinaryWriter writer, StringListTuple obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.item1)
      ..writeByte(1)
      ..write(obj.item2);
  }
}
