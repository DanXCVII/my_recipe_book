import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/new_recipe/ingredients/ingredients_bloc.dart';
import '../../blocs/new_recipe/ingredients/ingredients_event.dart';
import '../../blocs/new_recipe/ingredients/ingredients_state.dart';
import '../../generated/i18n.dart';
import '../../helper.dart';
import '../../hive.dart';
import '../../models/enums.dart';
import '../../models/ingredient.dart';
import '../../models/recipe.dart';
import '../../my_wrapper.dart';
import '../../recipe_overview/add_recipe_screen/validation_clean_up.dart';
import '../../routes.dart';
import '../../widgets/dialogs/info_dialog.dart';
import '../../widgets/ingredients_section.dart';
import '../../widgets/vegetarian_section.dart';
import 'steps_screen/steps_screen.dart';

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
        _saveIngredientsData(true);
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
                  BlocProvider.of<IngredientsBloc>(context).add(SetCanSave());

                  Navigator.pushNamed(
                    context,
                    RouteNames.addRecipeSteps,
                    arguments: StepsArguments(
                      state.recipe,
                      editingRecipeName: widget.editingRecipeName,
                    ),
                  );
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
                child: Ingredients(
                  servingsController,
                  ingredientNameController,
                  ingredientAmountController,
                  ingredientUnitController,
                  ingredientGlossaryController,
                  HiveProvider().getIngredientNames(),
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
    if (recipe.vegetable != null) {
      selectedRecipeVegetable.setVegetableStatus(recipe.vegetable);
    } else {
      selectedRecipeVegetable.setVegetableStatus(Vegetable.NON_VEGETARIAN);
    }

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
        showDialog(
          context: context,
          builder: (_) => InfoDialog(
              title: S.of(context).check_filled_in_information,
              body: S.of(context).check_filled_in_information_description),
        );
        break;
      case Validator.INGREDIENTS_NOT_VALID:
        showDialog(
          context: context,
          builder: (_) => InfoDialog(
              title: S.of(context).check_ingredients_input,
              body: S.of(context).check_ingredients_input_description),
        );
        break;
      case Validator.GLOSSARY_NOT_VALID:
        showDialog(
          context: context,
          builder: (_) => InfoDialog(
              title: S.of(context).check_ingredient_section_fields,
              body: S.of(context).check_ingredient_section_fields_description),
        );
        break;

      default:
        _saveIngredientsData(false);
        break;
    }
  }

  /// notifies the Bloc to save all filled in data on this screen, with
  /// the info to go back
  void _saveIngredientsData(bool goBack) {
    if (goBack)
      BlocProvider.of<IngredientsBloc>(context).add(
        FinishedEditing(
          widget.editingRecipeName == null ? false : true,
          goBack,
          double.parse(
              servingsController.text == "" ? "1" : servingsController.text),
          _getIngredientsList(
            ingredientNameController,
            ingredientAmountController,
            ingredientUnitController,
          ),
          ingredientGlossaryController.map((item) => item.text).toList(),
          selectedRecipeVegetable.vegetableStatus,
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
          double.parse(servingsController.text),
          cleanIngredientsData,
          glossary,
          selectedRecipeVegetable.vegetableStatus,
        ),
      );
    }
  }

  /// creating list of list of ingredients with the data of the
  /// textEditingControllers. All lists must be the same size.
  /// The amount will be converted to a double, because the recipe
  /// saves the amount as a double
  List<List<Ingredient>> _getIngredientsList(
      List<List<TextEditingController>> ingredientNamesContr,
      List<List<TextEditingController>> amountContr,
      List<List<TextEditingController>> unitContr) {
    List<List<Ingredient>> ingredients = [];

    for (int i = 0; i < ingredientNamesContr.length; i++) {
      ingredients.add([]);
      for (int j = 0; j < ingredientNamesContr[i].length; j++) {
        String ingredientName = ingredientNamesContr[i][j].text;
        double amount = validateNumber(amountContr[i][j].text)
            ? double.parse(
                amountContr[i][j].text.replaceAll(new RegExp(r','), 'e'))
            : null;
        String unit = unitContr[i][j].text;
        ingredients[i]
            .add(Ingredient(name: ingredientName, amount: amount, unit: unit));
      }
    }

    return ingredients;
  }
}
