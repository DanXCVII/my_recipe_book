import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:my_recipe_book/dialogs/dialog_types.dart';
import 'package:my_recipe_book/generated/i18n.dart';
import 'package:my_recipe_book/models/enums.dart';
import 'package:my_recipe_book/models/recipe.dart';
import 'package:my_recipe_book/models/recipe_keeper.dart';
import 'package:my_recipe_book/recipe_overview/add_recipe_screen/ingredients_info/ingredients_screen.dart';
import 'package:my_recipe_book/recipe_overview/add_recipe_screen/validator/dialogs.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../../helper.dart';
import '../../../my_wrapper.dart';
import '../categories_section.dart';
import '../dummy_data.dart';
import '../image_selector.dart' as IS;

import 'package:flutter/material.dart';

import '../../../recipe.dart';
import '../validation_clean_up.dart';

class GeneralInfoScreen extends StatefulWidget {
  final Recipe newRecipe;
  final String editRecipeName;

  GeneralInfoScreen({
    this.newRecipe,
    this.editRecipeName,
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
    if (widget.newRecipe.name != null)
      nameController.text = widget.newRecipe.name;
    if (widget.editRecipeName != null &&
        widget.newRecipe.imagePath != "images/randomFood.jpg")
      selectedRecipeImage.selectedImage = widget.newRecipe.imagePath;
    if (widget.newRecipe.preperationTime != null &&
        widget.newRecipe.preperationTime != 0.0)
      preperationTimeController.text =
          widget.newRecipe.preperationTime.toString();
    if (widget.newRecipe.cookingTime != null &&
        widget.newRecipe.cookingTime != 0.0)
      cookingTimeController.text = widget.newRecipe.cookingTime.toString();
    if (widget.newRecipe.totalTime != null && widget.newRecipe.totalTime != 0.0)
      totalTimeController.text = widget.newRecipe.totalTime.toString();

    if (widget.newRecipe.categories != null)
      widget.newRecipe.categories.forEach((category) {
        newRecipeCategories.add(category);
      });
    switch (widget.newRecipe.vegetable) {
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
              _finishedEditingGeneralInfo();
            },
          ),
          // ScopedModelDescendant<RecipeKeeper>(
          //   builder: (context, child, rKeeper) => IconButton(
          //     icon: Icon(Icons.art_track),
          //     onPressed: () {
          //       FocusScope.of(context).requestFocus(FocusNode());
          //       showDialog(
          //         context: context,
          //         barrierDismissible: false,
          //         builder: (_) => WillPopScope(
          //           // It disables the back button
          //           onWillPop: () async => false,
          //           child: RoundDialog(
          //               Center(child: CircularProgressIndicator()), 80),
          //         ),
          //       );
          //       DummyData().saveDummyData(rKeeper).then((_) {
          //         Navigator.pop(context);
          //       });
          //     },
          //   ),
          // ),
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
                widget.editRecipeName == null ? 'tmp' : widget.newRecipe.name,
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
                            if (validateNumber(value) == false && value != "") {
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
                            if (validateNumber(value) == false && value != "") {
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
          CategorySection(newRecipeCategories),
        ]),
      ),
    );
  }

  _finishedEditingGeneralInfo() {
    RecipeValidator()
        .validateGeneralInfo(
      _formKey,
      widget.newRecipe != null,
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
          saveValidData(widget.newRecipe);
          break;
      }
    });
  }

  void saveValidData(Recipe newRecipe) {
    String imageDatatype;
    String recipeImage = selectedRecipeImage.selectedImage;
    if (recipeImage != null) {
      imageDatatype = getImageDatatype(recipeImage);
    }

    newRecipe.name = nameController.text;
    newRecipe.categories = newRecipeCategories;
    newRecipe.imagePath = selectedRecipeImage.selectedImage == null
        ? 'images/randomFood.jpg'
        : selectedRecipeImage.selectedImage;
    newRecipe.preperationTime = preperationTimeController.text.isEmpty
        ? 0
        : double.parse(
            preperationTimeController.text.replaceAll(RegExp(r','), 'e'));
    newRecipe.cookingTime = cookingTimeController.text.isEmpty
        ? 0
        : double.parse(
            cookingTimeController.text.replaceAll(RegExp(r','), 'e'));
    newRecipe.totalTime = totalTimeController.text.isEmpty
        ? 0
        : double.parse(totalTimeController.text.replaceAll(RegExp(r','), 'e'));

    Navigator.push(
      context,
      CupertinoPageRoute(
          builder: (context) => IngredientsAddScreen(
                editRecipeName: widget.editRecipeName,
                newRecipe: newRecipe,
              )),
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
