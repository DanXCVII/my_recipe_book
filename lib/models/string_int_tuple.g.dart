// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'string_int_tuple.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StringIntTupleAdapter extends TypeAdapter<StringIntTuple> {
  @override
  StringIntTuple read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StringIntTuple(
      text: fields[0] as String,
      number: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, StringIntTuple obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.text)
      ..writeByte(1)
      ..write(obj.number);
  }

  @override
  int get typeId => 9;
}
