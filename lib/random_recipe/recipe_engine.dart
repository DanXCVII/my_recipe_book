import 'package:flutter/material.dart';

import '../recipe.dart';

class RecipeEngine extends ChangeNotifier {
  final List<RecipeDecision> _recipeDecisions;
  int _currentRecipeIndex;
  int _nextRecipeIndex;

  RecipeEngine({
    List<RecipeDecision> recipeDecisions,
  }) : _recipeDecisions = recipeDecisions {
    _currentRecipeIndex = 0;
    _nextRecipeIndex = 1;
  }

  RecipeDecision get currentRecipeD => _recipeDecisions[_currentRecipeIndex];

  RecipeDecision get nextRecipeD => _recipeDecisions[_nextRecipeIndex];

  void cycleRecipeD() {
    if (currentRecipeD.decisionMade) {
      print('cycleRecipeD');
      currentRecipeD.reset();

      _currentRecipeIndex = _nextRecipeIndex;
      _nextRecipeIndex = _nextRecipeIndex < _recipeDecisions.length - 1
          ? _nextRecipeIndex + 1
          : 0;
      print(
          'Current match: ${_recipeDecisions[_currentRecipeIndex].recipe.name}, Next match: ${_recipeDecisions[_nextRecipeIndex].recipe.name}');

      notifyListeners();
    }
  }
}

class RecipeDecision extends ChangeNotifier {
  final Recipe recipe;
  bool decisionMade = false;

  RecipeDecision({
    this.recipe,
  });

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
