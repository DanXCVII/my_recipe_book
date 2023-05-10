import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'string_string_tuple.g.dart';

@HiveType(typeId: 10)
class StringStringTuple extends Equatable {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String value;

  StringStringTuple({
    required this.name,
    required this.value,
  });

  factory StringStringTuple.fromMap(Map<String, dynamic> json) =>
      new StringStringTuple(
        name: json['name'],
        value: json['value'],
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'value': value,
      };

  @override
  List<Object> get props => [
        name,
        value,
      ];

  @override
  String toString() {
    return "name: $name, value: $value";
  }
}
