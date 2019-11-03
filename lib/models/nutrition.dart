import 'package:hive/hive.dart';

part './typeAdapter/nutrition.g.dart';

@HiveType()
class Nutrition  {
  @HiveField(0)
  String name;
  @HiveField(1)
  String amountUnit;

  Nutrition({
    this.name,
    this.amountUnit,
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
}
