import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/recipe_calendar/recipe_calendar_bloc.dart';

import '../../blocs/new_recipe/ingredients/ingredients_bloc.dart';
import '../../blocs/new_recipe/ingredients_section/ingredients_section_bloc.dart';
import '../../blocs/shopping_cart/shopping_cart_bloc.dart';
import '../../constants/routes.dart';

import 'package:my_recipe_book/generated/l10n.dart';

import '../../local_storage/local_repository.dart';
import '../../models/enums.dart';
import '../../models/ingredient.dart';
import '../../models/recipe.dart';
import '../../util/helper.dart';
import '../../util/my_wrapper.dart';
import '../../widgets/ingredients_section.dart';
import '../../widgets/recipe_editor/editorial_editor_shell.dart';
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

  IngredientsAddScreen({this.modifiedRecipe, this.editingRecipeName, Key? key})
    : super(key: key);

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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _saveIngredientsData(true);
        }
      },
      child: BlocListener<IngredientsBloc, IngredientsState>(
        listener: (context, state) {
          if (state is ISaved) {
            context.read<IngredientsBloc>().add(SetCanSave());
            Navigator.pushNamed(
              context,
              RouteNames.addRecipeSteps,
              arguments: StepsArguments(
                state.recipe,
                context.read<ShoppingCartBloc>(),
                context.read<RecipeCalendarBloc>(),
                editingRecipeName: widget.editingRecipeName,
              ),
            );
          } else if (state is ISavedGoBack) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            Navigator.pop(context);
          }
        },
        child: BlocBuilder<IngredientsBloc, IngredientsState>(
          builder: (context, state) =>
              BlocBuilder<IngredientsSectionBloc, IngredientsSectionState>(
                builder: (context, sectionState) {
                  final summaryRecipe = sectionState is LoadedIngredientsSection
                      ? widget.modifiedRecipe!.copyWith(
                          ingredients: sectionState.ingredients,
                          ingredientsGlossary: sectionState.sectionTitles,
                        )
                      : widget.modifiedRecipe!;
                  return EditorialEditorShell(
                    stage: 2,
                    recipe: summaryRecipe,
                    title: S.of(context).editor_ingredients,
                    busy: state is ISavingTmpData || state is IEditingFinished,
                    primaryLabel: S.of(context).continue_to_instructions,
                    onBack: () => _saveIngredientsData(true),
                    onPrimary: _finishedEditingIngredients,
                    body: Form(
                      key: _formKey,
                      child: Ingredients(
                        servingsController,
                        servingsNameController,
                        context.read<LocalRepository>().getIngredientNames(),
                        showServings: false,
                      ),
                    ),
                  );
                },
              ),
        ),
      ),
    );
  }

  /// prefills the textfields with the data of the given recipe and the
  /// radio button with the selected vegetable
  void _initializeData(Recipe recipe) {
    selectedRecipeVegetable.setVegetableStatus(Vegetable.NON_VEGETARIAN);

    if (recipe.servingName != null) {
      servingsNameController.text = recipe.servingName!;
    }

    if (recipe.servings != null)
      servingsController.text = recipe.servings.toString();

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${S.of(context).check_filled_in_information}: '
            '${S.of(context).check_red_fields_desc}',
          ),
        ),
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
          widget.modifiedRecipe!.vegetable,
        ),
      );
    } else {
      final sectionState =
          BlocProvider.of<IngredientsSectionBloc>(context).state
              as LoadedIngredientsSection;
      final savedIngredients = sectionState.ingredients
          .map((section) => List<Ingredient>.from(section))
          .toList();
      final savedSectionTitles = List<String>.from(sectionState.sectionTitles);

      for (int i = savedIngredients.length - 1; i >= 0; i--) {
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
          widget.modifiedRecipe!.vegetable,
        ),
      );
    }
  }
}
