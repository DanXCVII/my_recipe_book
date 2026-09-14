import 'package:equatable/equatable.dart';

import 'ingredient.dart';
import 'recipe.dart';

class ShoppingCartData extends Equatable {
  const ShoppingCartData(this.sources);

  final List<ShoppingCartSourceData> sources;

  ShoppingCartSourceData? get summary {
    for (final source in sources) {
      if (source.isSummary) return source;
    }
    return null;
  }

  List<ShoppingCartSourceData> get recipeSources =>
      sources.where((source) => !source.isSummary).toList(growable: false);

  List<CheckableIngredient> get consolidatedItems => summary?.items ?? const [];

  Map<Recipe, List<CheckableIngredient>> toLegacyMap() {
    return {
      for (final source in sources)
        source.legacyRecipe: List<CheckableIngredient>.from(source.items),
    };
  }

  ShoppingCartData snapshot() => ShoppingCartData(
    sources.map((source) => source.snapshot()).toList(growable: false),
  );

  @override
  List<Object?> get props => [sources];
}

class ShoppingCartSourceData extends Equatable {
  const ShoppingCartSourceData({
    required this.key,
    required this.displayName,
    required this.items,
    required this.isSummary,
    required this.position,
    this.recipe,
    this.currentServings,
  });

  final String key;
  final String displayName;
  final List<CheckableIngredient> items;
  final bool isSummary;
  final int position;
  final Recipe? recipe;
  final double? currentServings;

  double? get effectiveServings => currentServings ?? recipe?.servings;

  Recipe get legacyRecipe {
    if (isSummary) return Recipe(name: 'summary');
    return recipe ?? Recipe(name: displayName, notes: 'noLink');
  }

  ShoppingCartSourceData snapshot() => ShoppingCartSourceData(
    key: key,
    displayName: displayName,
    items: List<CheckableIngredient>.from(items),
    isSummary: isSummary,
    position: position,
    recipe: recipe,
    currentServings: currentServings,
  );

  @override
  List<Object?> get props => [
    key,
    displayName,
    items,
    isSummary,
    position,
    recipe,
    currentServings,
  ];
}
