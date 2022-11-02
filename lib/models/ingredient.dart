import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'ingredient.g.dart';

@HiveType(typeId: 3)
class Ingredient extends Equatable {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final double? amount;
  @HiveField(2)
  final String? unit;

  Ingredient({
    required this.name,
    this.amount,
    this.unit,
  });

  factory Ingredient.fromMap(Map<String, dynamic> json) => new Ingredient(
        name: json['name'],
        amount: double.tryParse(json['amount'].toString()),
        unit: json['unit'],
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'amount': amount,
        'unit': unit,
      };

  @override
  List<Object?> get props => [
        name,
        amount,
        unit,
      ];

  /// If method toString() is added, modify ingredientAdd screen to make key unique because the
  /// reorderable list needs unique keys and is dependent on ingrdient.toString() right now
}

@HiveType(typeId: 4)
class CheckableIngredient extends Equatable {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final double? amount;
  @HiveField(2)
  final String? unit;
  @HiveField(3)
  final bool checked;

  CheckableIngredient(this.name, this.amount, this.unit, this.checked);

  @override
  String toString() {
    return '$name $amount $unit $checked';
  }

  Ingredient getIngredient() {
    return Ingredient(name: name, amount: amount, unit: unit);
  }

  CheckableIngredient copyWith({
    String? name,
    double? amount,
    String? unit,
    bool? checked,
  }) =>
      CheckableIngredient(
        name ?? this.name,
        amount ?? this.amount,
        unit ?? this.unit,
        checked ?? this.checked,
      );

  @override
  List<Object?> get props => [
        name,
        amount,
        unit,
        checked,
      ];
}
