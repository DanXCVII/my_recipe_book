import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

import 'enums.dart';

part 'recipe_sort.g.dart';

@HiveType()
class RSort extends Equatable {
  @HiveField(0)
  final RecipeSort sort;
  @HiveField(1)
  final bool ascending;

  RSort(this.sort, this.ascending);

  @override
  List<Object> get props => [
        sort,
        ascending,
      ];
}
