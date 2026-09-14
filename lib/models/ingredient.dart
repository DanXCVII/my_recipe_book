import 'package:equatable/equatable.dart';

class Ingredient extends Equatable {
  final String name;
  final double? amount;
  final String? unit;

  const Ingredient({required this.name, this.amount, this.unit});

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
  List<Object?> get props => [name, amount, unit];

  /// If method toString() is added, modify ingredientAdd screen to make key unique because the
  /// reorderable list needs unique keys and is dependent on ingrdient.toString() right now
}

class CheckableIngredient extends Equatable {
  final String name;
  final double? amount;
  final String? unit;
  final bool checked;

  const CheckableIngredient(this.name, this.amount, this.unit, this.checked);

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
  }) => CheckableIngredient(
    name ?? this.name,
    amount ?? this.amount,
    unit ?? this.unit,
    checked ?? this.checked,
  );

  @override
  List<Object?> get props => [name, amount, unit, checked];
}
