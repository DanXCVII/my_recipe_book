import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/new_recipe/steps/steps_bloc.dart';
import '../../../blocs/recipe_calendar/recipe_calendar_bloc.dart';
import '../../../blocs/shopping_cart/shopping_cart_bloc.dart';
import '../../../constants/routes.dart';

import 'package:my_recipe_book/generated/l10n.dart';

import '../../../models/recipe.dart';
import '../../../util/my_wrapper.dart';
import '../../../widgets/recipe_editor/editorial_editor_shell.dart';
import '../nutritions.dart';
import 'steps_section.dart';

/// arguments which are provided to the route, when pushing to it
class StepsArguments {
  final Recipe modifiedRecipe;
  final String? editingRecipeName;
  final ShoppingCartBloc shoppingCartBloc;
  final RecipeCalendarBloc recipeCalendarBloc;

  StepsArguments(
    this.modifiedRecipe,
    this.shoppingCartBloc,
    this.recipeCalendarBloc, {
    this.editingRecipeName,
  });
}

class StepsScreen extends StatefulWidget {
  final Recipe? modifiedRecipe;
  final String? editingRecipeName;

  StepsScreen({this.modifiedRecipe, this.editingRecipeName, Key? key})
    : super(key: key);

  _StepsScreenState createState() => _StepsScreenState();
}

class _StepsScreenState extends State<StepsScreen> with WidgetsBindingObserver {
  final List<TextEditingController> stepsDescController = [];
  final List<String> stepTitles = [];
  final TextEditingController notesController = TextEditingController();

  final MyDoubleWrapper complexity = MyDoubleWrapper(myDouble: 5.0);
  FocusNode _focusNode = FocusNode();
  FocusNode? _exitFocusNode;

  static GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    stepsDescController.add(TextEditingController());

    _initializeData(widget.modifiedRecipe);
  }

  @override
  void dispose() {
    stepsDescController.forEach((controller) {
      controller.dispose();
    });
    notesController.dispose();
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
          _finishedEditingSteps(true);
        }
      },
      child: BlocListener<StepsBloc, StepsState>(
        listener: (context, state) {
          if (state is SEditingFinishedGoBack) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(S.of(context).saving_your_input)),
            );
          } else if (state is SSaved) {
            BlocProvider.of<StepsBloc>(context).add(SetCanSave());
            Navigator.pushNamed(
              context,
              RouteNames.addRecipeNutritions,
              arguments: AddRecipeNutritionsArguments(
                state.recipe,
                BlocProvider.of<ShoppingCartBloc>(context),
                BlocProvider.of<RecipeCalendarBloc>(context),
                editingRecipeName: widget.editingRecipeName,
              ),
            );
          } else if (state is SSavedGoBack) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            Navigator.pop(context);
          } else if (state is SCanSave && !state.isValid) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${S.of(context).too_many_images_for_the_steps}: '
                  '${S.of(context).too_many_images_for_the_steps_description}',
                ),
              ),
            );
          }
        },
        child: BlocBuilder<StepsBloc, StepsState>(
          builder: (context, state) {
            final busy = state is! SCanSave;
            return EditorialEditorShell(
              stage: 3,
              recipe: widget.modifiedRecipe!,
              title: S.of(context).editor_instructions,
              primaryLabel: S.of(context).continue_to_nutrition,
              busy: busy,
              onBack: busy ? null : () => _finishedEditingSteps(true),
              onPrimary: busy ? null : () => _finishedEditingSteps(false),
              body: Form(
                key: _formKey,
                child: widget.editingRecipeName != null
                    ? Steps(
                        editRecipeName: widget.editingRecipeName,
                        ingredients: widget.modifiedRecipe!.ingredients,
                        ingredientGlossary:
                            widget.modifiedRecipe!.ingredientsGlossary,
                      )
                    : Steps(
                        ingredients: widget.modifiedRecipe!.ingredients,
                        ingredientGlossary:
                            widget.modifiedRecipe!.ingredientsGlossary,
                      ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _finishedEditingSteps(bool goBack) {
    if (goBack) {
      BlocProvider.of<StepsBloc>(context).add(
        FinishedEditing(
          widget.editingRecipeName == null ? false : true,
          goBack,
          complexity.myDouble!.round(),
          notesController.text,
        ),
      );
    } else {
      BlocProvider.of<StepsBloc>(context).add(
        FinishedEditing(
          widget.editingRecipeName == null ? false : true,
          goBack,
          complexity.myDouble!.round(),
          notesController.text,
        ),
      );
    }
  }

  /// prefills the textfields with the data of the given recipe
  void _initializeData(Recipe? recipe) {
    notesController.text = widget.modifiedRecipe!.notes;

    // case new recipe with no steps
    if (widget.modifiedRecipe!.steps.isEmpty) {
      stepTitles.add("");
    } // case already steps added
    else {
      // case the recipe is an old recipe where the stepTitles are null
      if (widget.modifiedRecipe!.stepTitles == null) {
        stepTitles.addAll(widget.modifiedRecipe!.steps.map<String>((e) => ""));
      } // case the recipe already has stepTitles, which can be used
      else {
        stepTitles.addAll(widget.modifiedRecipe!.stepTitles!);
      }
    }

    if (widget.modifiedRecipe!.effort != null)
      complexity.myDouble = widget.modifiedRecipe!.effort!.toDouble();

    for (int i = 0; i < widget.modifiedRecipe!.steps.length; i++) {
      if (i > 0) {
        stepsDescController.add(TextEditingController());
      }

      stepsDescController[i].text = widget.modifiedRecipe!.steps[i];
    }
  }
}
