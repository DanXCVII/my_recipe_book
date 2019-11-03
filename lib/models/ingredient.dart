import 'package:hive/hive.dart';

part './typeAdapter/ingredient.g.dart';

@HiveType()
class Ingredient  {
  @HiveField(0)
  String name;
  @HiveField(1)
  double amount;
  @HiveField(2)
  String unit;

  Ingredient({
    this.name,
    this.amount,
    this.unit,
  });

  factory Ingredient.fromMap(Map<String, dynamic> json) => new Ingredient(
        name: json['name'],
        amount: json['amount'],
        unit: json['unit'],
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'amount': amount,
        'unit': unit,
      };
}

@HiveType()
class CheckableIngredient extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  double amount;
  @HiveField(2)
  String unit;
  @HiveField(3)
  bool checked;

  CheckableIngredient(this.name, this.amount, this.unit, this.checked);

  @override
  String toString() {
    return '$name $amount $unit $checked';
  }

  Ingredient getIngredient() {
    return Ingredient(name: name, amount: amount, unit: unit);
  }
}
