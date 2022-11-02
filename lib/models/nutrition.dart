import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'nutrition.g.dart';

@HiveType(typeId: 5)
class Nutrition extends Equatable {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String amountUnit;

  Nutrition({
    required this.name,
    required this.amountUnit,
  });

  @override
  String toString() {
    return '$name: $amountUnit';
  }

  factory Nutrition.fromMap(Map<String, dynamic> json) => new Nutrition(
        name: json['name'],
        amountUnit: json['amountUnit'],
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'amountUnit': amountUnit,
      };

  @override
  List<Object> get props => [
        name,
        amountUnit,
      ];
}
