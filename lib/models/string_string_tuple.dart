import 'package:equatable/equatable.dart';

class StringStringTuple extends Equatable {
  final String name;
  final String value;

  StringStringTuple({required this.name, required this.value});

  factory StringStringTuple.fromMap(Map<String, dynamic> json) =>
      new StringStringTuple(name: json['name'], value: json['value']);

  Map<String, dynamic> toMap() => {'name': name, 'value': value};

  @override
  List<Object> get props => [name, value];

  @override
  String toString() {
    return "name: $name, value: $value";
  }
}
