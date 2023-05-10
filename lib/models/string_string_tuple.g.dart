// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'string_string_tuple.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StringStringTupleAdapter extends TypeAdapter<StringStringTuple> {
  @override
  StringStringTuple read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StringStringTuple(
      name: fields[0] as String,
      value: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, StringStringTuple obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.value);
  }

  @override
  int get typeId => 10;
}
