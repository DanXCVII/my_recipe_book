import 'ingredient.dart';
import 'package:hive/hive.dart';

part './typeAdapter/shopping_cart_tuple.g.dart';


@HiveType()
class StringListTuple {
  @HiveField(0)
  String item1;

  @HiveField(1)
  List<CheckableIngredient> item2;

  /// Creates a new tuple value with the specified items.
  StringListTuple(this.item1, this.item2);

  @override
  String toString() => '[$item1, $item2]';
}
