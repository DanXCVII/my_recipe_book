import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_recipe_book/generated/l10n.dart';

import '../../../blocs/category_manager/category_manager_bloc.dart';
import '../../../blocs/new_recipe/clear_recipe/clear_recipe_bloc.dart';
import '../../../blocs/new_recipe/general_info/general_info_bloc.dart';
import '../../../blocs/recipe_calendar/recipe_calendar_bloc.dart';
import '../../../blocs/recipe_tag_manager/recipe_tag_manager_bloc.dart';
import '../../../blocs/shopping_cart/shopping_cart_bloc.dart';
import '../../../constants/routes.dart';
import '../../../local_storage/local_repository.dart';
import '../../../local_storage/local_paths.dart';
import '../../../models/recipe.dart';
import '../../../models/enums.dart';
import '../../../recipe_overview/add_recipe_screen/validation_clean_up.dart';
import '../../../util/helper.dart';
import '../../../util/my_wrapper.dart';
import '../../../widgets/duration_picker.dart';
import '../../../widgets/image_selector.dart' as IS;
import '../../../widgets/recipe_editor/editorial_editor_shell.dart';
import '../ingredients_screen.dart';
import 'categories_section.dart';
import 'recipe_tag_section.dart';

/// arguments which are provided to the route, when pushing to it
class GeneralInfoArguments {
  final Recipe? modifiedRecipe;
  final String? editingRecipeName;
  final ShoppingCartBloc shoppingCartBloc;
  final RecipeCalendarBloc recipeCalendarBloc;

  GeneralInfoArguments(
    this.modifiedRecipe,
    this.shoppingCartBloc,
    this.recipeCalendarBloc, {
    this.editingRecipeName,
  });
}

class GeneralInfoScreen extends StatefulWidget {
  final Recipe? modifiedRecipe;
  final String? editingRecipeName;

  GeneralInfoScreen({this.modifiedRecipe, this.editingRecipeName});

  _GeneralInfoScreenState createState() =>
      _GeneralInfoScreenState(modifiedRecipe);
}

class _GeneralInfoScreenState extends State<GeneralInfoScreen>
    with WidgetsBindingObserver {
  Recipe? modifiedRecipe;

  final MyDoubleWrapper preperationTime = MyDoubleWrapper();
  final MyDoubleWrapper cookingTime = MyDoubleWrapper();
  final MyDoubleWrapper totalTime = MyDoubleWrapper();
  final TextEditingController nameController = TextEditingController();

  final TextEditingController sourceController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController servingsController = TextEditingController();
  final TextEditingController servingsNameController = TextEditingController();
  Vegetable vegetable = Vegetable.NON_VEGETARIAN;
  double effort = 5;

  static GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _GeneralInfoScreenState(this.modifiedRecipe);
  Flushbar? _flush;

  FocusNode _focusNode = FocusNode();
  FocusNode? _exitFocusNode;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _initializeData(modifiedRecipe!);
  }

  @override
  void dispose() {
    nameController.dispose();
    sourceController.dispose();
    notesController.dispose();
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
          _saveGeneralInfoData(context, true);
        }
      },
      child: BlocListener<GeneralInfoBloc, GeneralInfoState>(
        listener: (context, state) {
          if (state is GSaved) {
            context.read<GeneralInfoBloc>().add(SetCanSave());
            Navigator.pushNamed(
              context,
              RouteNames.addRecipeIngredients,
              arguments: IngredientsArguments(
                state.recipe,
                context.read<ShoppingCartBloc>(),
                context.read<RecipeCalendarBloc>(),
                editingRecipeName: widget.editingRecipeName,
              ),
            );
          } else if (state is GSavedGoBack) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            Navigator.pop(context);
          }
        },
        child: BlocBuilder<GeneralInfoBloc, GeneralInfoState>(
          builder: (context, state) => EditorialEditorShell(
            stage: 1,
            recipe: modifiedRecipe!,
            title: S.of(context).editor_general,
            showSummary: false,
            busy: state is GEditingFinished || state is GSavingTmpData,
            primaryLabel: S.of(context).continue_to_ingredients,
            onBack: () => _saveGeneralInfoData(context, true),
            onPrimary: _finishedEditingGeneralInfo,
            body: Form(
              key: _formKey,
              child: Column(
                children: [
                  EditorialCard(
                    child: Column(
                      children: [
                        IS.ImageSelector(
                          onNewImage: (File imageFile) =>
                              context.read<GeneralInfoBloc>().add(
                                UpdateRecipeImage(
                                  imageFile,
                                  widget.editingRecipeName != null,
                                ),
                              ),
                          prefilledImage: modifiedRecipe!.imagePath,
                          circleSize: 132,
                          color: const Color(0xFFA83211),
                          onCancel: () {
                            context.read<ClearRecipeBloc>().add(
                              RemoveRecipeImage(
                                widget.editingRecipeName != null,
                              ),
                            );
                            context.read<GeneralInfoBloc>().add(
                              GRemoveRecipeImage(
                                widget.editingRecipeName != null,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          validator: _validateRecipeName,
                          controller: nameController,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: editorialInputDecoration(
                            context,
                            label: '${S.of(context).name} *',
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: notesController,
                          minLines: 3,
                          maxLines: 7,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: editorialInputDecoration(
                            context,
                            label: S.of(context).notes,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: sourceController,
                          decoration: editorialInputDecoration(
                            context,
                            label: S.of(context).source,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  EditorialCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).yield_portions,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: servingsController,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                decoration: editorialInputDecoration(
                                  context,
                                  label: S.of(context).amount,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                controller: servingsNameController,
                                decoration: editorialInputDecoration(
                                  context,
                                  label: S.of(context).servings,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            _getTimeSelector(
                              preperationTime,
                              S.of(context).prep_time,
                            ),
                            _getTimeSelector(
                              cookingTime,
                              S.of(context).cook_time,
                            ),
                            _getTimeSelector(
                              totalTime,
                              S.of(context).total_time,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  EditorialCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${S.of(context).effort}: ${effort.round()} / 10'),
                        Slider(
                          value: effort,
                          min: 1,
                          max: 10,
                          divisions: 9,
                          label: effort.round().toString(),
                          onChanged: (value) => setState(() => effort = value),
                        ),
                        const SizedBox(height: 8),
                        Text(S.of(context).dietary_preference),
                        const SizedBox(height: 8),
                        SegmentedButton<Vegetable>(
                          showSelectedIcon: true,
                          segments: [
                            ButtonSegment(
                              value: Vegetable.NON_VEGETARIAN,
                              label: Text(S.of(context).diet_meat),
                            ),
                            ButtonSegment(
                              value: Vegetable.VEGETARIAN,
                              label: Text(S.of(context).diet_vegetarian),
                            ),
                            ButtonSegment(
                              value: Vegetable.VEGAN,
                              label: Text(S.of(context).diet_vegan),
                            ),
                          ],
                          selected: {vegetable},
                          onSelectionChanged: (value) =>
                              setState(() => vegetable = value.first),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  EditorialCard(child: CategorySection()),
                  const SizedBox(height: 16),
                  EditorialCard(child: RecipeTagSection()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getTimeSelector(MyDoubleWrapper time, String addText) {
    final minutes = time.myDouble ?? 0;
    return OutlinedButton.icon(
      icon: const Icon(Icons.schedule_outlined),
      label: Text(
        minutes == 0
            ? addText
            : '$addText  ${minutes ~/ 60 > 0 ? '${minutes ~/ 60}h ' : ''}${cutDouble(minutes % 60)}m',
      ),
      onPressed: () => _onTapDuration(time),
      style: OutlinedButton.styleFrom(minimumSize: const Size(148, 52)),
    );
  }

  void _onTapDuration(MyDoubleWrapper time) async {
    Duration? resultingDuration = await showDurationPicker(
      context: context,
      initialTime: new Duration(
        minutes: time.myDouble != null ? time.myDouble!.toInt() : 30,
      ),
    );
    if (resultingDuration != null) {
      setState(() {
        time.myDouble = resultingDuration.inMinutes.toDouble();
      });
    }
  }

  /// prefills the textfields with the data of the given recipe
  void _initializeData(Recipe recipe) {
    nameController.text = recipe.name;
    notesController.text = recipe.notes;
    servingsController.text = recipe.servings == null
        ? ''
        : cutDouble(recipe.servings!);
    servingsNameController.text = recipe.servingName ?? S.current.servings;
    vegetable = recipe.vegetable;
    effort = (recipe.effort ?? 5).toDouble();
    if (recipe.preperationTime != 0.0)
      preperationTime.myDouble = recipe.preperationTime;
    if (recipe.cookingTime != 0.0) cookingTime.myDouble = recipe.cookingTime;
    if (recipe.totalTime != 0.0) totalTime.myDouble = recipe.totalTime;
    if (recipe.source != null) {
      sourceController.text = recipe.source!;
    }
  }

  /// validates the info with the RecipeValidator() class and shows a
  /// suitable dialog if the info is somehow not valid. If it is, it
  /// calls _saveGeneralInfoData(..)
  void _finishedEditingGeneralInfo() {
    RecipeValidator(context.read<LocalRepository>())
        .validateGeneralInfo(
          _formKey,
          widget.editingRecipeName != null ? true : false,
          nameController.text,
        )
        .then((v) {
          switch (v) {
            case Validator.REQUIRED_FIELDS:
              _showFlushInfo(
                S.of(context).check_filled_in_information,
                S.of(context).check_filled_in_information_description,
              );

              break;
            case Validator.NAME_TAKEN:
              _showFlushInfo(
                S.of(context).recipename_taken,
                S.of(context).recipename_taken_description,
              );
              break;

            default:
              _saveGeneralInfoData(context, false);
              break;
          }
        });
  }

  void _showFlushInfo(String title, String body) {
    if (_flush != null && _flush!.isShowing()) {
    } else {
      _flush =
          Flushbar<bool>(
              animationDuration: Duration(milliseconds: 300),
              leftBarIndicatorColor: Colors.blue[300],
              title: title,
              message: body,
              icon: Icon(Icons.info_outline, color: Colors.blue),
              mainButton: TextButton(
                onPressed: () {
                  _flush!.dismiss(true); // result = true
                },
                child: Text("OK", style: TextStyle(color: Colors.amber)),
              ),
            ) // <bool> is the type of the result passed to dismiss() and collected by show().then((result){})
            ..show(context).then((result) {});
    }
  }

  /// notifies the Bloc to save all filled in data on this screen, with
  /// the info to go back
  void _saveGeneralInfoData(BuildContext gInfoScreenContext, bool goBack) {
    BlocProvider.of<GeneralInfoBloc>(context).add(
      FinishedEditing(
        nameController.text,
        widget.editingRecipeName != null ? true : false,
        goBack,
        preperationTime.myDouble == null ? 0 : preperationTime.myDouble,
        cookingTime.myDouble == null ? 0 : cookingTime.myDouble,
        totalTime.myDouble == null ? 0 : totalTime.myDouble,
        sourceController.text,
        BlocProvider.of<CategoryManagerBloc>(context).selectedCategories,
        BlocProvider.of<RecipeTagManagerBloc>(context).selectedTags,
        notesController.text,
        servingsController.text.trim().isEmpty
            ? null
            : getDoubleFromString(servingsController.text),
        servingsNameController.text.trim(),
        vegetable,
        effort.round(),
      ),
    );
  }

  /// checks the recipeName for invalid characters like . or / or length
  /// because the name will be used as a directory for the recipe images
  String? _validateRecipeName(String? recipeName) {
    if (recipeName!.isEmpty) {
      return S.of(context).please_enter_a_name;
    }
    if (recipeName.contains('/') ||
        recipeName.contains('.') ||
        recipeName.length >= 70) {
      return S.of(context).invalid_name;
    } else {
      try {
        PathProvider.pP.getRecipeDirFull(recipeName).then((path) {
          Directory(path).create(recursive: true);
        });
      } catch (e) {
        return "looooool";
      }
    }
    return null;
  }
}
