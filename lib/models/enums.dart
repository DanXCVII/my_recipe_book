import 'package:hive/hive.dart';

part 'enums.g.dart';

@HiveType()
enum Vegetable {
  @HiveField(0)
  NON_VEGETARIAN,
  @HiveField(1)
  VEGETARIAN,
  @HiveField(2)
  VEGAN
}

@HiveType()
enum RecipeSort {
  @HiveField(0)
  BY_NAME,
  @HiveField(1)
  BY_INGREDIENT_COUNT,
  @HiveField(2)
  BY_EFFORT,
  @HiveField(3)
  BY_LAST_MODIFIED,
}
