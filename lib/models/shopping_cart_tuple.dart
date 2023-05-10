import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

import 'ingredient.dart';

part 'shopping_cart_tuple.g.dart';

@HiveType(typeId: 8)
class StringListTuple extends Equatable {
  @HiveField(0)
  final String item1;
  @HiveField(1)
  final List<CheckableIngredient> item2;

  /// Creates a new tuple value with the specified items.
  StringListTuple(this.item1, this.item2);

  @override
  String toString() => '[$item1, $item2]';

  @override
  List<Object> get props => [
        item1,
        item2,
      ];
}
