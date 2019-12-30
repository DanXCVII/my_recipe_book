import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/new_recipe/ingredients/ingredients.dart';
import '../../../blocs/new_recipe/ingredients/ingredients_bloc.dart';
import '../../../blocs/new_recipe/ingredients/ingredients_event.dart';
import '../../../database.dart';
import '../../../models/enums.dart';
import '../../../models/ingredient.dart';
import '../../../models/recipe.dart';
import '../../../my_wrapper.dart';
import '../ingredients_section.dart';
import '../validation_clean_up.dart';
import '../validator/dialogs.dart';
import '../vegetarian_section.dart';

/// arguments which are provided to the route, when pushing to it
class IngredientsArguments {
  final Recipe modifiedRecipe;
  final String editingRecipeName;

  IngredientsArguments(
    this.modifiedRecipe, {
    this.editingRecipeName,
  });
}

class IngredientsAddScreen extends StatefulWidget {
  final Recipe modifiedRecipe;
  final String editingRecipeName;

  IngredientsAddScreen({
    this.modifiedRecipe,
    this.editingRecipeName,
    Key key,
  }) : super(key: key);

  _IngredientsAddScreenState createState() => _IngredientsAddScreenState();
}

class _IngredientsAddScreenState extends State<IngredientsAddScreen> {
  final List<List<TextEditingController>> ingredientNameController = [[]];
  final List<List<TextEditingController>> ingredientAmountController = [[]];
  final List<List<TextEditingController>> ingredientUnitController = [[]];
  final List<TextEditingController> ingredientGlossaryController = [];
  final TextEditingController servingsController = TextEditingController();

  final MyVegetableWrapper selectedRecipeVegetable = MyVegetableWrapper();

  static GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    selectedRecipeVegetable.setVegetableStatus(Vegetable.NON_VEGETARIAN);

    // initialize list of controllers for the dynamic textFields with one element
    ingredientNameController[0].add(TextEditingController());
    ingredientAmountController[0].add(TextEditingController());
    ingredientUnitController[0].add(TextEditingController());
    ingredientGlossaryController.add(TextEditingController());

    _initializeData(widget.modifiedRecipe);
  }

  @override
  void dispose() {
    super.dispose();
    ingredientNameController.forEach((list) {
      list.forEach((controller) {
        controller.dispose();
      });
    });
    ingredientAmountController.forEach((list) {
      list.forEach((controller) {
        controller.dispose();
      });
    });
    ingredientUnitController.forEach((list) {
      list.forEach((controller) {
        controller.dispose();
      });
    });
    ingredientGlossaryController.forEach((controller) {
      controller.dispose();
    });
    servingsController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _saveIngredientsData(context, true);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("add ingredients info"),
          actions: <Widget>[
            BlocListener<IngredientsBloc, IngredientsState>(
              listener: (context, state) {
                if (state is IEditingFinishedGoBack) {
                  // TODO: internationalize
                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text('saving your input...')));
                } else if (state is ISaved) {
                  // TODO: Navigator.pushNamed to next screen
                } else if (state is ISavedGoBack) {
                  Scaffold.of(context).hideCurrentSnackBar();
                  Navigator.pop(context);
                }
              },
              child: BlocBuilder<IngredientsBloc, IngredientsState>(
                builder: (context, state) {
                  if (state is ISavingTmpData) {
                    return Icon(
                      Icons.arrow_forward,
                      color: Colors.grey,
                    );
                  } else if (state is ICanSave) {
                    return IconButton(
                      icon: Icon(Icons.arrow_forward),
                      color: Colors.white,
                      onPressed: () {
                        _finishedEditingIngredients();
                      },
                    );
                  } else if (state is IEditingFinished) {
                    return CircularProgressIndicator();
                  } else {
                    return Icon(Icons.arrow_forward);
                  }
                },
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Form(
                key: _formKey,
                child: FutureBuilder<List<String>>(
                  future: DBProvider.db.getAllIngredientNames(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Ingredients(
                        servingsController,
                        ingredientNameController,
                        ingredientAmountController,
                        ingredientUnitController,
                        ingredientGlossaryController,
                        snapshot.data,
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 56, top: 12, bottom: 12),
                child: Text(
                  "Kategorie:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Vegetarian(
                vegetableStatus: selectedRecipeVegetable,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// prefills the textfields with the data of the given recipe and the
  /// radio button with the selected vegetable
  void _initializeData(Recipe recipe) {
    if (recipe.servings != null)
      servingsController.text = recipe.servings.toString();

    if (recipe.ingredientsGlossary != null)
      for (int i = 0; i < recipe.ingredientsGlossary.length; i++) {
        if (i > 0) {
          ingredientGlossaryController.add(TextEditingController());
          ingredientNameController.add([]);
          ingredientAmountController.add([]);
          ingredientUnitController.add([]);
        }
        ingredientGlossaryController[i].text = recipe.ingredientsGlossary[i];

        if (recipe.ingredients != null)
          for (int j = 0; j < recipe.ingredients[i].length; j++) {
            if (i != 0 || j > 0) {
              ingredientNameController[i].add(TextEditingController());
              ingredientAmountController[i].add(TextEditingController());
              ingredientUnitController[i].add(TextEditingController());
            }
            ingredientNameController[i][j].text = recipe.ingredients[i][j].name;
            ingredientAmountController[i][j].text =
                recipe.ingredients[i][j].amount != null
                    ? recipe.ingredients[i][j].amount.toString()
                    : "";
            ingredientUnitController[i][j].text = recipe.ingredients[i][j].unit;
          }
        switch (recipe.vegetable) {
          case Vegetable.NON_VEGETARIAN:
            selectedRecipeVegetable
                .setVegetableStatus(Vegetable.NON_VEGETARIAN);
            break;
          case Vegetable.VEGETARIAN:
            selectedRecipeVegetable.setVegetableStatus(Vegetable.VEGETARIAN);
            break;
          case Vegetable.VEGAN:
            selectedRecipeVegetable.setVegetableStatus(Vegetable.VEGAN);
            break;
        }
      }
  }

  /// validates the info with the RecipeValidator() class and shows a
  /// suitable dialog if the info is somehow not valid. If it is, it
  /// calls _saveIngredientsData(..)
  void _finishedEditingIngredients() {
    Validator v = RecipeValidator().validateIngredientsData(
        _formKey,
        ingredientNameController,
        ingredientAmountController,
        ingredientUnitController,
        ingredientGlossaryController);

    switch (v) {
      case Validator.REQUIRED_FIELDS:
        showRequiredFieldsDialog(context);
        break;

      case Validator.INGREDIENTS_NOT_VALID:
        showIngredientsIncompleteDialog(context);
        break;
      case Validator.GLOSSARY_NOT_VALID:
        showIngredientsGlossaryIncomplete(context);
        break;
      default:
        _saveIngredientsData(context, false);
        break;
    }
  }

  /// notifies the Bloc to save all filled in data on this screen, with
  /// the info to go back
  void _saveIngredientsData(
      BuildContext ingredientsScreenContext, bool goBack) {
    if (goBack)
      BlocProvider.of<IngredientsBloc>(context).add(
        FinishedEditing(
          widget.editingRecipeName == null ? false : true,
          goBack,
          getIngredientsList(
            ingredientNameController,
            ingredientAmountController,
            ingredientUnitController,
          ),
          ingredientGlossaryController.map((item) => item.text).toList(),
        ),
      );
    else {
      List<List<Ingredient>> cleanIngredientsData = getCleanIngredientData(
          ingredientNameController,
          ingredientAmountController,
          ingredientUnitController);

      List<String> glossary =
          getCleanGlossary(ingredientGlossaryController, cleanIngredientsData);

      BlocProvider.of<IngredientsBloc>(context).add(
        FinishedEditing(
          widget.editingRecipeName == null ? false : true,
          goBack,
          cleanIngredientsData,
          glossary,
        ),
      );
    }
  }
}
