import 'package:my_recipe_book/models/enums.dart';
import 'package:hive/hive.dart';

part './typeAdapter/recipe_sort.g.dart';

@HiveType()
class RSort {
  @HiveField(0)
  RecipeSort sort;
  @HiveField(1)
  bool ascending;

  RSort(this.sort, this.ascending);
}
