import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_recipe_book/models/enums.dart';
import 'package:my_recipe_book/models/ingredient.dart';
import 'package:my_recipe_book/models/recipe.dart';
import 'package:my_recipe_book/recipe_overview/add_recipe_screen/steps_info/steps_screen.dart';
import 'package:my_recipe_book/recipe_overview/add_recipe_screen/validator/dialogs.dart';

import '../../../database.dart';
import '../../../my_wrapper.dart';
import '../ingredients_section.dart';
import '../validation_clean_up.dart';
import '../vegetarian_section.dart';

class IngredientsAddScreen extends StatefulWidget {
  final Recipe newRecipe;
  final String editRecipeName;

  IngredientsAddScreen({
    this.newRecipe,
    this.editRecipeName,
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

    // If a recipe will be edited and not a new one created
    if (widget.newRecipe.servings != null)
      servingsController.text = widget.newRecipe.servings.toString();

    if (widget.newRecipe.ingredientsGlossary != null)
      for (int i = 0; i < widget.newRecipe.ingredientsGlossary.length; i++) {
        if (i > 0) {
          ingredientGlossaryController.add(TextEditingController());
          ingredientNameController.add([]);
          ingredientAmountController.add([]);
          ingredientUnitController.add([]);
        }
        ingredientGlossaryController[i].text =
            widget.newRecipe.ingredientsGlossary[i];

        if (widget.newRecipe.ingredients != null)
          for (int j = 0; j < widget.newRecipe.ingredients[i].length; j++) {
            if (i != 0 || j > 0) {
              ingredientNameController[i].add(TextEditingController());
              ingredientAmountController[i].add(TextEditingController());
              ingredientUnitController[i].add(TextEditingController());
            }
            ingredientNameController[i][j].text =
                widget.newRecipe.ingredients[i][j].name;
            ingredientAmountController[i][j].text =
                widget.newRecipe.ingredients[i][j].amount != null
                    ? widget.newRecipe.ingredients[i][j].amount.toString()
                    : "";
            ingredientUnitController[i][j].text =
                widget.newRecipe.ingredients[i][j].unit;
          }
        switch (widget.newRecipe.vegetable) {
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
    return Scaffold(
      appBar: AppBar(
        title: Text("add ingredients info"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_forward),
            color: Colors.white,
            onPressed: () {
              _finishedEditingIngredients();
            },
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
    );
  }

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
        saveValidIngredientsData(widget.newRecipe);
        break;
    }
  }

  void saveValidIngredientsData(Recipe editRecipe) {
    List<List<Ingredient>> ingredients = getCleanIngredientData(
        ingredientNameController,
        ingredientAmountController,
        ingredientUnitController);

    List<String> ingredientsGlossary =
        getCleanGlossary(ingredientGlossaryController, ingredients);

    editRecipe.ingredientsGlossary = ingredientsGlossary;
    editRecipe.ingredients = ingredients;
    editRecipe.vegetable = selectedRecipeVegetable.getVegetableStatus();
    editRecipe.servings = double.parse(servingsController.text);

    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => StepsScreen(
          editRecipeName: widget.editRecipeName,
          newRecipe: widget.newRecipe,
        ),
      ),
    );
  }
}
