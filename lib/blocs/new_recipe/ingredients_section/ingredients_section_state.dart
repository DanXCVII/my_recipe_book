part of 'ingredients_section_bloc.dart';

abstract class IngredientsSectionState {
  const IngredientsSectionState();
}

class LoadedIngredientsSection extends IngredientsSectionState {
  final List<String> sectionTitles;
  final List<List<Ingredient>> ingredients;

  LoadedIngredientsSection(
    this.sectionTitles,
    this.ingredients,
  );
}
