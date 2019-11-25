import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';

import '../../../blocs/add_recipe/add_recipe.dart';
import '../../../blocs/add_recipe/add_recipe_bloc.dart';
import '../../../blocs/add_recipe/add_recipe_state.dart';
import '../../../generated/i18n.dart';
import '../../../helper.dart';
import '../../../models/enums.dart';
import '../../../models/recipe.dart';
import '../../../my_wrapper.dart';
import '../../../recipe.dart';
import '../categories_section.dart';
import '../image_selector.dart' as IS;
import '../ingredients_info/ingredients_screen.dart';
import '../validation_clean_up.dart';
import '../validator/dialogs.dart';

class GeneralInfoScreen extends StatefulWidget {
  final Recipe editRecipe;

  GeneralInfoScreen({
    this.editRecipe,
  });

  _GeneralInfoScreenState createState() => _GeneralInfoScreenState();
}

class _GeneralInfoScreenState extends State<GeneralInfoScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController preperationTimeController =
      TextEditingController();
  final TextEditingController cookingTimeController = TextEditingController();
  final TextEditingController totalTimeController = TextEditingController();

  final MyImageWrapper selectedRecipeImage = MyImageWrapper();
  final MyVegetableWrapper selectedRecipeVegetable = MyVegetableWrapper();

  final List<String> newRecipeCategories = [];

  static GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
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
    return BlocListener<AddRecipeBloc, AddRecipeState>(
      listener: (context, state) {
        if (state is LoadedAddRecipe) {
          initializeData(state.recipe);
        }
      },
      child: BlocBuilder<AddRecipeBloc, AddRecipeState>(
        builder: (context, state) {
          if (state is LoadingAddRecipe) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is LoadedAddRecipe) {
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                title: Text("add general info"),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.arrow_forward),
                    color: Colors.white,
                    onPressed: () {
                      _finishedEditingGeneralInfo(state.recipe);
                    },
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Column(children: <Widget>[
                  // top section with the add image button
                  SizedBox(height: 30),
                  IS.ImageSelector(
                    imageWrapper: selectedRecipeImage,
                    circleSize: 120,
                    color: Color(0xFF790604),
                    recipeName:
                        widget.editRecipe == null ? 'tmp' : state.recipe.name,
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
                              if (validateNumber(value) == false &&
                                  value != "") {
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
                  CategorySection(newRecipeCategories, state.categories),
                ]),
              ),
            );
          } else {
            return Text(state.toString());
          }
        },
      ),
    );
  }

  _finishedEditingGeneralInfo(Recipe editedRecipe) {
    RecipeValidator()
        .validateGeneralInfo(
      _formKey,
      widget.editRecipe != null ? true : false,
      nameController.text,
    )
        .then((v) {
      switch (v) {
        case Validator.REQUIRED_FIELDS:
          showRequiredFieldsDialog(context);
          break;
        case Validator.NAME_TAKEN:
          showRecipeNameTakenDialog(context);
          break;

        default:
          saveValidData(editedRecipe, context);
          break;
      }
    });
  }

  void initializeData(Recipe newRecipe) {
    if (newRecipe.name != null) nameController.text = newRecipe.name;
    if (widget.editRecipe != null &&
        newRecipe.imagePath != "images/randomFood.jpg")
      selectedRecipeImage.selectedImage = newRecipe.imagePath;
    if (newRecipe.preperationTime != null && newRecipe.preperationTime != 0.0)
      preperationTimeController.text = newRecipe.preperationTime.toString();
    if (newRecipe.cookingTime != null && newRecipe.cookingTime != 0.0)
      cookingTimeController.text = newRecipe.cookingTime.toString();
    if (newRecipe.totalTime != null && newRecipe.totalTime != 0.0)
      totalTimeController.text = newRecipe.totalTime.toString();

    if (newRecipe.categories != null)
      newRecipe.categories.forEach((category) {
        newRecipeCategories.add(category);
      });
    switch (newRecipe.vegetable) {
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

    PathProvider.pP.getTmpRecipeDir().then((path) {
      Directory(path..substring(0, path.length - 1))
          .deleteSync(recursive: true);
    });
  }

  void saveValidData(Recipe editedRecipe, BuildContext gInfoScreenContext) {
    String imageDatatype;
    String recipeImage = selectedRecipeImage.selectedImage;
    if (recipeImage != null) {
      imageDatatype = getImageDatatype(recipeImage);
    }

    Recipe newRecipe = editedRecipe.copyWith(
      name: nameController.text,
      categories: newRecipeCategories,
      imagePath: selectedRecipeImage.selectedImage == null
          ? 'images/randomFood.jpg'
          : selectedRecipeImage.selectedImage,
      preperationTime: preperationTimeController.text.isEmpty
          ? 0
          : double.parse(
              preperationTimeController.text.replaceAll(RegExp(r','), 'e')),
      cookingTime: cookingTimeController.text.isEmpty
          ? 0
          : double.parse(
              cookingTimeController.text.replaceAll(RegExp(r','), 'e')),
      totalTime: totalTimeController.text.isEmpty
          ? 0
          : double.parse(
              totalTimeController.text.replaceAll(RegExp(r','), 'e')),
      servings: null,
      vegetable: null,
    );
    if (widget.editRecipe == null) {
      BlocProvider.of<AddRecipeBloc>(context)
          .add(SaveTemporaryRecipeData(newRecipe));
    }

    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => BlocProvider<AddRecipeBloc>(
          builder: (context) =>
              BlocProvider.of<AddRecipeBloc>(gInfoScreenContext),
          child: IngredientsAddScreen(
            editRecipe: widget.editRecipe,
            recipe: newRecipe,
          ),
        ),
      ),
    );
  }

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
        PathProvider.pP.getRecipeDir(recipeName).then((path) {
          Directory(path).create(recursive: true);
        });
      } catch (e) {
        return "looooool";
      }
    }
    return null;
  }
}
