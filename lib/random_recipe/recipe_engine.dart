import 'package:flutter/material.dart';
import 'package:my_recipe_book/database.dart';

import '../recipe.dart';

class RecipeEngine extends ChangeNotifier {
  final List<RecipeDecision> _recipeDecisions;
  final String _categoryName;
  int _secondLastRecipeIndex;
  int _lastRecipeIndex;
  int _currentRecipeIndex;
  int _nextRecipeIndex;

  RecipeEngine({List<RecipeDecision> recipeDecisions, String categoryName})
      : _recipeDecisions = recipeDecisions,
        _categoryName = categoryName {
    _secondLastRecipeIndex =
        recipeDecisions.length == 1 ? 0 : recipeDecisions.length - 2;
    _lastRecipeIndex = recipeDecisions.length - 1;
    _currentRecipeIndex = 0;
    _nextRecipeIndex = 1;
  }

  RecipeDecision get currentRecipeD =>
      _recipeDecisions.isEmpty ? null : _recipeDecisions[_currentRecipeIndex];

  RecipeDecision get nextRecipeD =>
      _recipeDecisions.isEmpty ? null : _recipeDecisions[_nextRecipeIndex];

  void cycleRecipeD() {
    currentRecipeD.reset();

    _secondLastRecipeIndex = _lastRecipeIndex;
    _lastRecipeIndex = _currentRecipeIndex;
    _currentRecipeIndex = _nextRecipeIndex;
    _nextRecipeIndex = _nextRecipeIndex < _recipeDecisions.length - 1
        ? _nextRecipeIndex + 1
        : 0;
    print(_currentRecipeIndex);
    print(
        'Current match $_currentRecipeIndex: ${_recipeDecisions[_currentRecipeIndex].recipe.name}, Next match $_nextRecipeIndex: ${_recipeDecisions[_nextRecipeIndex].recipe.name}');
    notifyListeners();
    DBProvider.db
        .getNewRandomRecipe(
      _recipeDecisions[_secondLastRecipeIndex].recipe.name,
      categoryName: _categoryName == 'all categories' ? null : _categoryName,
    )
        .then((recipe) {
      print(
          'saving new for index $_lastRecipeIndex with name ${_recipeDecisions[_lastRecipeIndex]}');
      _recipeDecisions[_lastRecipeIndex] = RecipeDecision(recipe: recipe);
    });
  }
}

class RecipeDecision extends ChangeNotifier {
  final Recipe recipe;
  bool decisionMade = false;

  RecipeDecision({
    this.recipe,
  });

  @override
  String toString() {
    return recipe.name;
  }

  void makeDecision() {
    if (!decisionMade) {
      decisionMade = true;
    }
  }

  void reset() {
    if (decisionMade) {
      decisionMade = false;
      notifyListeners();
    }
  }
}
