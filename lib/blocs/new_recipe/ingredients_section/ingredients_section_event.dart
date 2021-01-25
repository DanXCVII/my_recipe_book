part of 'ingredients_section_bloc.dart';

abstract class IngredientsSectionEvent {
  const IngredientsSectionEvent();
}

class AddIngredient extends IngredientsSectionEvent {
  final Ingredient ingredient;
  final int index;

  const AddIngredient(
    this.ingredient,
    this.index,
  );
}

class EditIngredient extends IngredientsSectionEvent {
  final Ingredient newIngredient;
  final int sectionIndex;
  final int index;
  final int newSectionIndex;

  const EditIngredient(
    this.newIngredient,
    this.sectionIndex,
    this.index,
    this.newSectionIndex,
  );
}

class MoveIngredient extends IngredientsSectionEvent {
  final int sectionIndex;
  final int oldIndex;
  final int newIndex;

  MoveIngredient(
    this.sectionIndex,
    this.oldIndex,
    this.newIndex,
  );
}

class AddSectionTitle extends IngredientsSectionEvent {
  final String title;

  const AddSectionTitle(
    this.title,
  );
}

class RemoveSection extends IngredientsSectionEvent {
  final int index;

  RemoveSection(this.index);
}

class EditSectionTitle extends IngredientsSectionEvent {
  final String newTitle;
  final int sectionIndex;

  const EditSectionTitle(
    this.newTitle,
    this.sectionIndex,
  );
}

class RemoveIngredient extends IngredientsSectionEvent {
  final int sectionIndex;
  final int index;

  RemoveIngredient(
    this.sectionIndex,
    this.index,
  );
}

class InitializeIngredientsSection extends IngredientsSectionEvent {
  final List<String> sectionTitles;
  final List<List<Ingredient>> ingredients;

  const InitializeIngredientsSection(
    this.sectionTitles,
    this.ingredients,
  );
}
