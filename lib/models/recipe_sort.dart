import 'package:equatable/equatable.dart';

import 'enums.dart';

class RSort extends Equatable {
  final RecipeSort sort;
  final bool? ascending;

  RSort(this.sort, this.ascending);

  @override
  List<Object?> get props => [sort, ascending];
}
