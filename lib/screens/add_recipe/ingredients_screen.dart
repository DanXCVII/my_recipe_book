import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:my_recipe_book/blocs/recipe_calendar/recipe_calendar_bloc.dart';

import '../../blocs/new_recipe/ingredients/ingredients_bloc.dart';
import '../../blocs/new_recipe/ingredients_section/ingredients_section_bloc.dart';
import '../../blocs/shopping_cart/shopping_cart_bloc.dart';
import '../../constants/routes.dart';
import '../../generated/i18n.dart';
import '../../local_storage/hive.dart';
import '../../models/enums.dart';
import '../../models/ingredient.dart';
import '../../models/recipe.dart';
import '../../util/helper.dart';
import '../../util/my_wrapper.dart';
import '../../widgets/ingredients_section.dart';
import '../../widgets/vegetarian_section.dart';
import 'steps_screen/steps_screen.dart';

/// arguments which are provided to the route, when pushing to it
class IngredientsArguments {
  final Recipe modifiedRecipe;
  final String? editingRecipeName;
  final ShoppingCartBloc shoppingCartBloc;
  final RecipeCalendarBloc recipeCalendarBloc;

  IngredientsArguments(
    this.modifiedRecipe,
    this.shoppingCartBloc,
    this.recipeCalendarBloc, {
    this.editingRecipeName,
  });
}

class IngredientsAddScreen extends StatefulWidget {
  final Recipe? modifiedRecipe;
  final String? editingRecipeName;

  IngredientsAddScreen({
    this.modifiedRecipe,
    this.editingRecipeName,
    Key? key,
  }) : super(key: key);

  _IngredientsAddScreenState createState() => _IngredientsAddScreenState();
}

class _IngredientsAddScreenState extends State<IngredientsAddScreen>
    with WidgetsBindingObserver {
  final TextEditingController servingsController = TextEditingController();
  final TextEditingController servingsNameController = TextEditingController();

  final MyVegetableWrapper selectedRecipeVegetable = MyVegetableWrapper();
  FocusNode _focusNode = FocusNode();
  FocusNode? _exitFocusNode;

  static GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Flushbar? _flush;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _initializeData(widget.modifiedRecipe!);
  }

  @override
  void dispose() {
    servingsController.dispose();
    servingsNameController.dispose();

    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _exitFocusNode = FocusScope.of(context).focusedChild;
      FocusScope.of(context).requestFocus(_focusNode);
    } else if (state == AppLifecycleState.resumed) {
      FocusScope.of(context).requestFocus(_exitFocusNode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _saveIngredientsData(true);
        return false;
      },
      child: Scaffold(
        appBar: NewGradientAppBar(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: [Color(0xffAF1E1E), Color(0xff641414)],
          ),
          title: Text(I18n.of(context)!.add_ingredients_info),
          actions: <Widget>[
            BlocListener<IngredientsBloc, IngredientsState>(
              listener: (context, state) {
                if (state is IEditingFinishedGoBack) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(I18n.of(context)!.saving_your_input)));
                } else if (state is ISaved) {
                  BlocProvider.of<IngredientsBloc>(context).add(SetCanSave());

                  Navigator.pushNamed(
                    context,
                    RouteNames.addRecipeSteps,
                    arguments: StepsArguments(
                      state.recipe,
                      BlocProvider.of<ShoppingCartBloc>(context),
                      BlocProvider.of<RecipeCalendarBloc>(context),
                      editingRecipeName: widget.editingRecipeName,
                    ),
                  );
                } else if (state is ISavedGoBack) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
                        FocusScope.of(context).requestFocus(FocusNode());

                        _finishedEditingIngredients();
                      },
                    );
                  } else if (state is IEditingFinished) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                            width: 25,
                            height: 25,
                            child: CircularProgressIndicator()),
                      ),
                    );
                  } else {
                    return Icon(Icons.arrow_forward);
                  }
                },
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width > 500 ? 500 : null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Ingredients(
                      servingsController,
                      servingsNameController,
                      HiveProvider().getIngredientNames(),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 56, top: 12, bottom: 12),
                    child: Text(
                      I18n.of(context)!.category + ":",
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

    if (recipe.servingName != null) {
      servingsNameController.text = recipe.servingName!;
    }

    if (recipe.servings != null)
      servingsController.text = recipe.servings.toString();

    if (recipe.vegetable != null)
      switch (recipe.vegetable) {
        case Vegetable.NON_VEGETARIAN:
          selectedRecipeVegetable.setVegetableStatus(Vegetable.NON_VEGETARIAN);
          break;
        case Vegetable.VEGETARIAN:
          selectedRecipeVegetable.setVegetableStatus(Vegetable.VEGETARIAN);
          break;
        case Vegetable.VEGAN:
          selectedRecipeVegetable.setVegetableStatus(Vegetable.VEGAN);
          break;
      }
  }

  /// validates the info with the RecipeValidator() class and shows a
  /// suitable dialog if the info is somehow not valid. If it is, it
  /// calls _saveIngredientsData(..)
  void _finishedEditingIngredients() {
    if (!_formKey.currentState!.validate()) {
      _showFlushInfo(
        I18n.of(context)!.check_filled_in_information,
        I18n.of(context)!.check_red_fields_desc,
      );
    } else {
      _saveIngredientsData(false);
    }
  }

  /// notifies the Bloc to save all filled in data on this screen, with
  /// the info to go back
  void _saveIngredientsData(bool goBack) {
    if (goBack) {
      BlocProvider.of<IngredientsBloc>(context).add(
        FinishedEditing(
          widget.editingRecipeName == null ? false : true,
          goBack,
          (servingsController.text == "" || servingsController.text == "0")
              ? null
              : getDoubleFromString(servingsController.text),
          servingsNameController.text,
          (BlocProvider.of<IngredientsSectionBloc>(context).state
                  as LoadedIngredientsSection)
              .ingredients,
          (BlocProvider.of<IngredientsSectionBloc>(context).state
                  as LoadedIngredientsSection)
              .sectionTitles,
          selectedRecipeVegetable.vegetableStatus,
        ),
      );
    } else {
      List<List<Ingredient>> savedIngredients =
          (BlocProvider.of<IngredientsSectionBloc>(context).state
                  as LoadedIngredientsSection)
              .ingredients;
      List<String> savedSectionTitles =
          (BlocProvider.of<IngredientsSectionBloc>(context).state
                  as LoadedIngredientsSection)
              .sectionTitles;

      for (int i = 0; i < savedIngredients.length; i++) {
        if (savedIngredients[i].isEmpty && savedSectionTitles.length > i) {
          savedSectionTitles.removeAt(i);
          savedIngredients.removeAt(i);
        }
      }
      BlocProvider.of<IngredientsBloc>(context).add(
        FinishedEditing(
          widget.editingRecipeName == null ? false : true,
          goBack,
          (servingsController.text == "" || servingsController.text == "0")
              ? null
              : getDoubleFromString(servingsController.text),
          servingsNameController.text,
          savedIngredients,
          savedSectionTitles,
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
        double? amount = amountContr[i][j].text == "0"
            ? null
            : getDoubleFromString(amountContr[i][j].text) != null
                ? getDoubleFromString(
                    amountContr[i][j].text.replaceAll(new RegExp(r','), '.'))
                : null;
        String unit = unitContr[i][j].text;
        ingredients[i]
            .add(Ingredient(name: ingredientName, amount: amount, unit: unit));
      }
    }

    return ingredients;
  }

  void _showFlushInfo(String title, String body) {
    if (_flush != null && _flush!.isShowing()) {
    } else {
      _flush = Flushbar<bool>(
        animationDuration: Duration(milliseconds: 300),
        leftBarIndicatorColor: Colors.blue[300],
        title: title,
        message: body,
        icon: Icon(
          Icons.info_outline,
          color: Colors.blue,
        ),
        mainButton: TextButton(
          onPressed: () {
            _flush!.dismiss(true); // result = true
          },
          child: Text(
            "OK",
            style: TextStyle(color: Colors.amber),
          ),
        ),
      ) // <bool> is the type of the result passed to dismiss() and collected by show().then((result){})
        ..show(context).then((result) {});
    }
  }
}
