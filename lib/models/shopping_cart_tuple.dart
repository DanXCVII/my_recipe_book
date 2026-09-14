import 'package:equatable/equatable.dart';

import 'ingredient.dart';

class StringListTuple extends Equatable {
  final String item1;
  final List<CheckableIngredient> item2;

  /// Creates a new tuple value with the specified items.
  StringListTuple(this.item1, this.item2);

  @override
  String toString() => '[$item1, $item2]';

  @override
  List<Object> get props => [item1, item2];
}
