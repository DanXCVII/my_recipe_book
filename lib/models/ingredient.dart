import 'package:equatable/equatable.dart';

class Ingredient extends Equatable {
  final String? id;
  final String name;
  final double? amount;
  final String? unit;

  const Ingredient({this.id, required this.name, this.amount, this.unit});

  factory Ingredient.fromMap(Map<String, dynamic> json) => new Ingredient(
    id: json['id'] as String?,
    name: json['name'],
    amount: double.tryParse(json['amount'].toString()),
    unit: json['unit'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'amount': amount,
    'unit': unit,
  };

  Ingredient copyWith({
    String? id,
    String? name,
    double? amount,
    String? unit,
    bool clearAmount = false,
  }) {
    return Ingredient(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: clearAmount ? null : amount ?? this.amount,
      unit: unit ?? this.unit,
    );
  }

  @override
  // Identity is deliberately excluded: shopping-list comparisons are based on
  // the ingredient value, while recipe editing uses [id] for durable links.
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
