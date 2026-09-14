import 'package:equatable/equatable.dart';

class Nutrition extends Equatable {
  final String name;
  final String amountUnit;

  const Nutrition({required this.name, required this.amountUnit});

  @override
  String toString() {
    return '$name: $amountUnit';
  }

  factory Nutrition.fromMap(Map<String, dynamic> json) =>
      new Nutrition(name: json['name'], amountUnit: json['amountUnit']);

  Map<String, dynamic> toMap() => {'name': name, 'amountUnit': amountUnit};

  @override
  List<Object> get props => [name, amountUnit];
}
