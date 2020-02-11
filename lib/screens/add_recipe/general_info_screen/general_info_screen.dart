import 'dart:io';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:my_recipe_book/blocs/new_recipe/general_info/general_info_bloc.dart';
import 'package:my_recipe_book/blocs/shopping_cart/shopping_cart.dart';

import '../../../blocs/new_recipe/clear_recipe/clear_recipe_bloc.dart';
import '../../../generated/i18n.dart';
import '../../../helper.dart';
import '../../../local_storage/local_paths.dart';
import '../../../models/recipe.dart';
import '../../../recipe_overview/add_recipe_screen/validation_clean_up.dart';
import '../../../routes.dart';
import '../../../widgets/image_selector.dart' as IS;
import '../ingredients_screen.dart';
import 'categories_section.dart';

/// arguments which are provided to the route, when pushing to it
class GeneralInfoArguments {
  final Recipe modifiedRecipe;
  final String editingRecipeName;
  final ShoppingCartBloc shoppingCartBloc;

  GeneralInfoArguments(
    this.modifiedRecipe,
    this.shoppingCartBloc, {
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

class _GeneralInfoScreenState extends State<GeneralInfoScreen> {
  Recipe modifiedRecipe;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController preperationTimeController =
      TextEditingController();
  final TextEditingController cookingTimeController = TextEditingController();
  final TextEditingController totalTimeController = TextEditingController();

  static GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _GeneralInfoScreenState(this.modifiedRecipe);
  Flushbar flush;

  @override
  void initState() {
    super.initState();

    _initializeData(modifiedRecipe);
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    preperationTimeController.dispose();
    cookingTimeController.dispose();
    totalTimeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _saveGeneralInfoData(context, true);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("add general info"),
          actions: <Widget>[
            BlocListener<ClearRecipeBloc, ClearRecipeState>(
              listener: (context, state) {
                if (state is ClearedRecipe) {
                  setState(() {
                    modifiedRecipe = state.recipe;
                    _initializeData(state.recipe);
                  });
                }
              },
              child: IconButton(
                  icon: Icon(Icons.format_clear),
                  onPressed: () {
                    BlocProvider.of<ClearRecipeBloc>(context).add(Clear(
                        widget.editingRecipeName == null ? false : true,
                        DateTime.now()));
                  }),
            ),
            BlocListener<GeneralInfoBloc, GeneralInfoState>(
              listener: (context, state) {
                if (state is GEditingFinishedGoBack) {
                  // TODO: internationalize
                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text('saving your input...')));
                } else if (state is GSaved) {
                  BlocProvider.of<GeneralInfoBloc>(context).add(SetCanSave());

                  Navigator.pushNamed(
                    context,
                    RouteNames.addRecipeIngredients,
                    arguments: IngredientsArguments(
                      state.recipe,
                      BlocProvider.of<ShoppingCartBloc>(context),
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
                      decoration: InputDecoration(
                        filled: true,
                        labelText: S.of(context).name + "*",
                        icon: Icon(GroovinMaterialIcons.notebook),
                      ),
                    ),
                  ),
                  // time textFields
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: TextFormField(
                            validator: (value) {
                              if (validateNumber(value) == false &&
                                  value != "") {
                                return S.of(context).no_valid_number;
                              }
                              return null;
                            },
                            autovalidate: false,
                            controller: preperationTimeController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              filled: true,
                              labelText: S.of(context).prep_time,
                              icon: Icon(Icons.access_time),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: TextFormField(
                            validator: (value) {
                              if (validateNumber(value) == false &&
                                  value != "") {
                                return S.of(context).no_valid_number;
                              }
                              return null;
                            },
                            autovalidate: false,
                            controller: cookingTimeController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              filled: true,
                              labelText: S.of(context).cook_time,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 52, top: 12, right: 12, bottom: 12),
                    child: TextFormField(
                      validator: (value) {
                        if (validateNumber(value) == false && value != "") {
                          return S.of(context).no_valid_number;
                        }
                        return null;
                      },
                      autovalidate: false,
                      controller: totalTimeController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        helperText: S.of(context).in_minutes,
                        filled: true,
                        labelText: S.of(context).total_time,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            CategorySection(
              selectedCategories: modifiedRecipe.categories,
              onSelect: (String chipName) {
                BlocProvider.of<GeneralInfoBloc>(context)
                    .add(AddCategoryToRecipe(
                  chipName,
                  widget.editingRecipeName == null ? false : true,
                ));
              },
              onDeselect: (String chipName) {
                BlocProvider.of<GeneralInfoBloc>(context)
                    .add(RemoveCategoryFromRecipe(
                  chipName,
                  widget.editingRecipeName == null ? false : true,
                ));
              },
            ),
          ]),
        ),
      ),
    );
  }

  /// prefills the textfields with the data of the given recipe
  void _initializeData(Recipe recipe) {
    if (recipe.name != null) nameController.text = recipe.name;
    if (recipe.preperationTime != null && recipe.preperationTime != 0.0)
      preperationTimeController.text = recipe.preperationTime.toString();
    if (recipe.cookingTime != null && recipe.cookingTime != 0.0)
      cookingTimeController.text = recipe.cookingTime.toString();
    if (recipe.totalTime != null && recipe.totalTime != 0.0)
      totalTimeController.text = recipe.totalTime.toString();
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
            S.of(context).check_ingredient_section_fields,
            S.of(context).check_filled_in_information_description,
          );

          break;
        case Validator.NAME_TAKEN:
          _showFlushInfo(S.of(context).recipename_taken,
              S.of(context).recipename_taken_description);
          break;

        default:
          _saveGeneralInfoData(context, false);
          break;
      }
    });
  }

  void _showFlushInfo(String title, String body) {
    if (flush != null && flush.isShowing()) {
    } else {
      flush = Flushbar<bool>(
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
            flush.dismiss(true); // result = true
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
      preperationTimeController.text.isEmpty
          ? 0
          : double.parse(
              preperationTimeController.text.replaceAll(RegExp(r','), 'e')),
      cookingTimeController.text.isEmpty
          ? 0
          : double.parse(
              cookingTimeController.text.replaceAll(RegExp(r','), 'e')),
      totalTimeController.text.isEmpty
          ? 0
          : double.parse(
              totalTimeController.text.replaceAll(RegExp(r','), 'e')),
    ));
  }

  /// checks the recipeName for invalid characters like . or / or length
  /// because the name will be used as a directory for the recipe images
  String _validateRecipeName(String recipeName) {
    if (recipeName.isEmpty) {
      return "Please enter a name";
    }
    if (recipeName.contains('/') ||
        recipeName.contains('.') ||
        recipeName.length >= 70) {
      return "invalid name";
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
