import 'dart:io';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:my_recipe_book/blocs/recipe_calendar/recipe_calendar_bloc.dart';
import 'package:my_recipe_book/util/my_wrapper.dart';
import 'package:my_recipe_book/widgets/duration_picker.dart';

import '../../../blocs/category_manager/category_manager_bloc.dart';
import '../../../blocs/new_recipe/clear_recipe/clear_recipe_bloc.dart';
import '../../../blocs/new_recipe/general_info/general_info_bloc.dart';
import '../../../blocs/recipe_tag_manager/recipe_tag_manager_bloc.dart';
import '../../../blocs/shopping_cart/shopping_cart_bloc.dart';
import '../../../constants/routes.dart';
import '../../../generated/i18n.dart';
import '../../../local_storage/local_paths.dart';
import '../../../models/recipe.dart';
import '../../../recipe_overview/add_recipe_screen/validation_clean_up.dart';
import '../../../util/helper.dart';
import '../../../widgets/dialogs/are_you_sure_dialog.dart';
import '../../../widgets/dialogs/info_dialog.dart';
import '../../../widgets/image_selector.dart' as IS;
import '../ingredients_screen.dart';
import 'categories_section.dart';
import 'recipe_tag_section.dart';

/// arguments which are provided to the route, when pushing to it
class GeneralInfoArguments {
  final Recipe modifiedRecipe;
  final String editingRecipeName;
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
  final Recipe modifiedRecipe;
  final String editingRecipeName;

  GeneralInfoScreen({
    this.modifiedRecipe,
    this.editingRecipeName,
  });

  _GeneralInfoScreenState createState() =>
      _GeneralInfoScreenState(modifiedRecipe);
}

class _GeneralInfoScreenState extends State<GeneralInfoScreen>
    with WidgetsBindingObserver {
  Recipe modifiedRecipe;

  final MyDoubleWrapper preperationTime = MyDoubleWrapper();
  final MyDoubleWrapper cookingTime = MyDoubleWrapper();
  final MyDoubleWrapper totalTime = MyDoubleWrapper();
  final TextEditingController nameController = TextEditingController();

  final TextEditingController sourceController = TextEditingController();

  static GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _GeneralInfoScreenState(this.modifiedRecipe);
  Flushbar _flush;

  FocusNode _focusNode = FocusNode();
  FocusNode _exitFocusNode;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _initializeData(modifiedRecipe);
  }

  @override
  void dispose() {
    nameController.dispose();

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
        _saveGeneralInfoData(context, true);
        return false;
      },
      child: Scaffold(
        appBar: GradientAppBar(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: [Color(0xffAF1E1E), Color(0xff641414)],
          ),
          title: Text(I18n.of(context).add_general_info),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => InfoDialog(
                          title: I18n.of(context).info,
                          body: I18n.of(context)
                              .general_info_changes_will_be_saved,
                        ));
              },
            ),
            BlocListener<ClearRecipeBloc, ClearRecipeState>(
              listener: (context, state) {
                if (state is ClearedRecipe) {
                  setState(() {
                    modifiedRecipe = state.recipe
                        .copyWith(categories: modifiedRecipe.categories);
                    _emptyTextFields();
                  });
                }
              },
              child: IconButton(
                  icon: Icon(Icons.format_clear),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (bcontext) => BlocProvider.value(
                        value: BlocProvider.of<ClearRecipeBloc>(context),
                        child: AreYouSureDialog(
                          I18n.of(context).clean_recipe_info,
                          I18n.of(context).clean_recipe_info_desc,
                          () {
                            BlocProvider.of<ClearRecipeBloc>(context).add(
                              Clear(
                                widget.editingRecipeName == null ? false : true,
                              ),
                            );
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    );
                  }),
            ),
            BlocListener<GeneralInfoBloc, GeneralInfoState>(
              listener: (context, state) {
                if (state is GEditingFinishedGoBack) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(I18n.of(context).saving_your_input)));
                } else if (state is GSaved) {
                  BlocProvider.of<GeneralInfoBloc>(context).add(SetCanSave());

                  Navigator.pushNamed(
                    context,
                    RouteNames.addRecipeIngredients,
                    arguments: IngredientsArguments(
                      state.recipe,
                      BlocProvider.of<ShoppingCartBloc>(context),
                      BlocProvider.of<RecipeCalendarBloc>(context),
                      editingRecipeName: widget.editingRecipeName,
                    ),
                  );
                } else if (state is GSavedGoBack) {
                  Scaffold.of(context).hideCurrentSnackBar();
                  Navigator.pop(context);
                }
              },
              child: BlocBuilder<GeneralInfoBloc, GeneralInfoState>(
                builder: (context, state) {
                  if (state is GSavingTmpData) {
                    return Icon(
                      Icons.arrow_forward,
                      color: Colors.grey,
                    );
                  } else if (state is GCanSave) {
                    return IconButton(
                      icon: Icon(Icons.arrow_forward),
                      color: Colors.white,
                      onPressed: () {
                        FocusScope.of(context).requestFocus(FocusNode());

                        _finishedEditingGeneralInfo();
                      },
                    );
                  } else if (state is GEditingFinished) {
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
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width > 500 ? 500 : null,
              child: Column(children: <Widget>[
                // top section with the add image button
                SizedBox(height: 30),
                IS.ImageSelector(
                  onNewImage: (File imageFile) =>
                      BlocProvider.of<GeneralInfoBloc>(context).add(
                    UpdateRecipeImage(
                      imageFile,
                      widget.editingRecipeName == null ? false : true,
                    ),
                  ),
                  prefilledImage: modifiedRecipe.imagePath,
                  circleSize: 120,
                  color: Color(0xFF790604),
                  onCancel: () {
                    BlocProvider.of<ClearRecipeBloc>(context).add(
                        RemoveRecipeImage(
                            widget.editingRecipeName == null ? false : true));
                    BlocProvider.of<GeneralInfoBloc>(context).add(
                        GRemoveRecipeImage(
                            widget.editingRecipeName == null ? false : true));
                  },
                ),
                SizedBox(height: 30),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextFormField(
                          validator: _validateRecipeName,
                          controller: nameController,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            filled: true,
                            labelText: I18n.of(context).name + "*",
                            icon: Icon(MdiIcons.notebook),
                          ),
                        ),
                      ),
                      // time textFields
                      Padding(
                        padding: const EdgeInsets.fromLTRB(52, 12, 12, 12),
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          children: <Widget>[
                            _getTimeSelector(
                                preperationTime, I18n.of(context).prep_time),
                            _getTimeSelector(
                                cookingTime, I18n.of(context).cook_time),
                            _getTimeSelector(
                                totalTime, I18n.of(context).total_time)
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(
                            left: 52, top: 0, right: 12, bottom: 12),
                        child: TextFormField(
                          controller: sourceController,
                          decoration: InputDecoration(
                            filled: true,
                            labelText: I18n.of(context).source,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                CategorySection(),
                RecipeTagSection(),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getTimeSelector(MyDoubleWrapper time, String addText) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: time.myDouble != null && time.myDouble != 0
          ? InkWell(
              onTap: () async {
                _onTapDuration(time);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(addText + ":",
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                  Container(
                    width: 100,
                    child: Text(
                        "${time.myDouble ~/ 60} h ${cutDouble(time.myDouble % 60)} min",
                        style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            )
          : OutlineButton.icon(
              icon: Icon(Icons.add_circle),
              label: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(addText),
              ),
              onPressed: () async {
                _onTapDuration(time);
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
    );
  }

  void _onTapDuration(MyDoubleWrapper time) async {
    Duration resultingDuration = await showDurationPicker(
      context: context,
      initialTime: new Duration(minutes: 30),
    );
    if (resultingDuration != null) {
      setState(() {
        time.myDouble = resultingDuration.inMinutes.toDouble();
      });
    }
  }

  /// prefills the textfields with the data of the given recipe
  void _initializeData(Recipe recipe) {
    if (recipe.name != null) nameController.text = recipe.name;
    if (recipe.preperationTime != null && recipe.preperationTime != 0.0)
      preperationTime.myDouble = recipe.preperationTime;
    if (recipe.cookingTime != null && recipe.cookingTime != 0.0)
      cookingTime.myDouble = recipe.cookingTime;
    if (recipe.totalTime != null && recipe.totalTime != 0.0)
      totalTime.myDouble = recipe.totalTime;
    if (recipe.source != null) {
      sourceController.text = recipe.source;
    }
  }

  void _emptyTextFields() {
    nameController.clear();
    preperationTime.myDouble = null;
    cookingTime.myDouble = null;
    sourceController.clear();
  }

  /// validates the info with the RecipeValidator() class and shows a
  /// suitable dialog if the info is somehow not valid. If it is, it
  /// calls _saveGeneralInfoData(..)
  void _finishedEditingGeneralInfo() {
    RecipeValidator()
        .validateGeneralInfo(
      _formKey,
      widget.editingRecipeName != null ? true : false,
      nameController.text,
    )
        .then((v) {
      switch (v) {
        case Validator.REQUIRED_FIELDS:
          _showFlushInfo(
            I18n.of(context).check_filled_in_information,
            I18n.of(context).check_filled_in_information_description,
          );

          break;
        case Validator.NAME_TAKEN:
          _showFlushInfo(I18n.of(context).recipename_taken,
              I18n.of(context).recipename_taken_description);
          break;

        default:
          _saveGeneralInfoData(context, false);
          break;
      }
    });
  }

  void _showFlushInfo(String title, String body) {
    if (_flush != null && _flush.isShowing()) {
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
        mainButton: FlatButton(
          onPressed: () {
            _flush.dismiss(true); // result = true
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

  /// notifies the Bloc to save all filled in data on this screen, with
  /// the info to go back
  void _saveGeneralInfoData(BuildContext gInfoScreenContext, bool goBack) {
    BlocProvider.of<GeneralInfoBloc>(context).add(FinishedEditing(
      widget.editingRecipeName != null ? true : false,
      goBack,
      nameController.text,
      preperationTime.myDouble == null ? 0 : preperationTime.myDouble,
      cookingTime.myDouble == null ? 0 : cookingTime.myDouble,
      totalTime.myDouble == null ? 0 : totalTime.myDouble,
      sourceController.text,
      BlocProvider.of<CategoryManagerBloc>(context).selectedCategories,
      BlocProvider.of<RecipeTagManagerBloc>(context).selectedTags,
    ));
  }

  /// checks the recipeName for invalid characters like . or / or length
  /// because the name will be used as a directory for the recipe images
  String _validateRecipeName(String recipeName) {
    if (recipeName.isEmpty) {
      return I18n.of(context).please_enter_a_name;
    }
    if (recipeName.contains('/') ||
        recipeName.contains('.') ||
        recipeName.length >= 70) {
      return I18n.of(context).invalid_name;
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
