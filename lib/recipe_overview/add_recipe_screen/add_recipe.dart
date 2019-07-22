import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as ImageIO;

import '../../recipe.dart';
import '../../database.dart';
import './steps_section.dart';
import './ingredients_section.dart';
import './savingDialog.dart';

import './categories_section.dart';
import './vegetarian_section.dart';
import '../../my_wrapper.dart';
import './complexity_section.dart';
import '../recipe_screen.dart' show RecipeScreen;
import './image_selector.dart' as IS;

const double categories = 14;
const double topPadding = 8;

// TODO ~: Put the AddRecipe Scaffold in a stateless widget

class AddRecipeForm extends StatefulWidget {
  final Recipe editRecipe;

  AddRecipeForm({this.editRecipe});

  @override
  State<StatefulWidget> createState() {
    return _AddRecipeFormState();
  }
}

class _AddRecipeFormState extends State<AddRecipeForm> {
  //////////// for Ingredients ////////////
  final List<List<TextEditingController>> ingredientNameController =
      new List<List<TextEditingController>>();
  final List<List<TextEditingController>> ingredientAmountController =
      new List<List<TextEditingController>>();
  final List<List<TextEditingController>> ingredientUnitController =
      new List<List<TextEditingController>>();
  final List<TextEditingController> ingredientGlossaryController =
      new List<TextEditingController>();

  //////////// for Steps ////////////
  final List<List<String>> stepImages = new List<List<String>>();
  final List<TextEditingController> stepsDescController =
      new List<TextEditingController>();

  //////////// for Category ////////////
  final List<String> newRecipeCategories = new List<String>();
  final MyImageWrapper addCategoryImage = new MyImageWrapper();

  //////////// for Complexity ////////////
  final MyDoubleWrapper complexity = new MyDoubleWrapper(number: 5.0);

  //////////// this Widget ////////////
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController preperationTimeController =
      new TextEditingController();
  final TextEditingController cookingTimeController =
      new TextEditingController();
  final TextEditingController totalTimeController = new TextEditingController();
  final TextEditingController servingsController = new TextEditingController();
  final TextEditingController notesController = new TextEditingController();
  final MyImageWrapper selectedRecipeImage = new MyImageWrapper();
  final MyVegetableWrapper selectedRecipeVegetable = new MyVegetableWrapper();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    selectedRecipeVegetable.setVegetableStatus(Vegetable.NON_VEGETARIAN);
    stepImages.add(new List<String>());
    // initialize list of controllers for the dynamic textFields with one element
    ingredientNameController.add(new List<TextEditingController>());
    ingredientNameController[0].add(new TextEditingController());
    ingredientAmountController.add(new List<TextEditingController>());
    ingredientAmountController[0].add(new TextEditingController());
    ingredientUnitController.add(new List<TextEditingController>());
    ingredientUnitController[0].add(new TextEditingController());
    ingredientGlossaryController.add(new TextEditingController());
    stepsDescController.add(new TextEditingController());

    // If a recipe will be edited and not a new one created
    if (widget.editRecipe != null) {
      // TODO: only add data if not null;
      nameController.text = widget.editRecipe.name;
      if (widget.editRecipe.imagePath != null)
        selectedRecipeImage.setSelectedImage(widget.editRecipe.imagePath);
      if (widget.editRecipe.preperationTime != 0.0)
        preperationTimeController.text =
            widget.editRecipe.preperationTime.toString();
      if (widget.editRecipe.cookingTime != 0.0)
        cookingTimeController.text = widget.editRecipe.cookingTime.toString();
      if (widget.editRecipe.totalTime != 0.0)
        totalTimeController.text = widget.editRecipe.totalTime.toString();
      servingsController.text = widget.editRecipe.servings.toString();
      notesController.text = widget.editRecipe.notes;
      for (int i = 0; i < widget.editRecipe.ingredientsGlossary.length; i++) {
        if (i > 0) {
          ingredientGlossaryController.add(new TextEditingController());
        }
        ingredientGlossaryController[i].text =
            widget.editRecipe.ingredientsGlossary[i];

        ingredientNameController.add(new List<TextEditingController>());
        ingredientAmountController.add(new List<TextEditingController>());
        ingredientUnitController.add(new List<TextEditingController>());
        for (int j = 0; j < widget.editRecipe.ingredientsList[i].length; j++) {
          if (i != 0 || j > 0) {
            ingredientNameController[i].add(new TextEditingController());
            ingredientAmountController[i].add(new TextEditingController());
            ingredientUnitController[i].add(new TextEditingController());
          }
          ingredientNameController[i][j].text =
              widget.editRecipe.ingredientsList[i][j];
          ingredientAmountController[i][j].text =
              widget.editRecipe.amount[i][j].toString();
          ingredientUnitController[i][j].text = widget.editRecipe.unit[i][j];
        }
      }
      for (int i = 0; i < widget.editRecipe.steps.length; i++) {
        if (i > 0) {
          stepsDescController.add(new TextEditingController());
          stepImages.add(new List<String>());
        }
        stepsDescController[i].text = widget.editRecipe.steps[i];

        for (int j = 0; j < widget.editRecipe.stepImages[i].length; j++) {
          stepImages[i].add(widget.editRecipe.stepImages[i][j]);
        }
      }
      widget.editRecipe.categories.forEach((category) {
        newRecipeCategories.add(category);
      });
      switch (widget.editRecipe.vegetable) {
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
        title: Text("add recipe"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            color: Colors.white,
            onPressed: () {
              if (_formKey.currentState.validate()) {
                /////////// Only do if all data is VALID! ///////////
                FocusScope.of(context).requestFocus(new FocusNode());
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => WillPopScope(
                      // It disables the back button
                      onWillPop: () async => false,
                      child: SavingDialog()),
                );
                if (widget.editRecipe == null) {
                  saveRecipe().then((_) {
                    Navigator.pop(context);
                  });
                } else {
                  deleteOldSaveNewRecipe(widget.editRecipe).then((newRecipe) {
                    newRecipe.isFavorite = widget.editRecipe.isFavorite;
                    Navigator.pop(context); // loading screen
                    Navigator.pop(context); // edit recipe screen
                    Navigator.pop(context); // old recipe screen
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => RecipeScreen(
                                recipe: newRecipe,
                                primaryColor:
                                    getRecipePrimaryColor(newRecipe))));
                  });
                }
              } else {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text("Check filled in information"),
                    contentPadding: EdgeInsets.fromLTRB(15, 24, 15, 0),
                    content: Container(
                      height: 10,
                    ),
                  ),
                );
              }
            },
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(children: <Widget>[
            // top section with the add image button
            SizedBox(height: 30),
            IS.ImageSelector(selectedRecipeImage, 120, Color(0xFF790604)),
            SizedBox(height: 30),
            // name textField
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter a name";
                  } return null;
                },
                controller: nameController,
                decoration: InputDecoration(
                  filled: true,
                  labelText: "name",
                  icon: Icon(Icons.android),
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
                          return "no valid number";
                        } return null;
                      },
                      autovalidate: false,
                      controller: preperationTimeController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        filled: true,
                        labelText: "preperation time",
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
                          return "no valid number";
                        } return null;
                      },
                      autovalidate: false,
                      controller: cookingTimeController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        filled: true,
                        labelText:
                            "cooking time", // TODO: Maybe change name to something which isn"t so much related to cooking with heat
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
                    return "no valid number";
                  } return null;
                },
                autovalidate: false,
                controller: totalTimeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  helperText: "in minutes",
                  filled: true,
                  labelText: "total time",
                ),
              ),
            ),
            // servings textField
            Padding(
              padding: const EdgeInsets.only(
                  left: 12, top: 12, bottom: 12, right: 200),
              child: TextFormField(
                validator: (value) {
                  if (validateNumber(value) == false) {
                    return "no valid number";
                  }
                  if (value.isEmpty) {
                    return "data required";
                  }return null;
                },
                controller: servingsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  labelText: "servings",
                  icon: Icon(Icons.local_dining),
                ),
              ),
            ),

            // ingredients section with it"s heading and text fields and buttons
            Ingredients(
              ingredientNameController,
              ingredientAmountController,
              ingredientUnitController,
              ingredientGlossaryController,
            ),
            // category for vegetarian heading
            Padding(
              padding: const EdgeInsets.only(left: 56, top: 12),
              child: Text(
                "select a category:",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.grey[700]),
              ),
            ),
            // category for radio buttons for vegetarian selector
            Vegetarian(
              vegetableStatus: selectedRecipeVegetable,
            ),
            // heading with textFields for steps section
            Steps(stepsDescController, stepImages),
            // notes textField and heading
            Padding(
              padding: const EdgeInsets.only(
                  right: 12, top: 12, left: 18, bottom: 12),
              child: TextField(
                controller: notesController,
                decoration: InputDecoration(
                  labelText: "notes",
                  filled: true,
                  icon: Icon(Icons.assignment),
                ),
                maxLines: 3,
              ),
            ),
            ComplexitySection(complexity: complexity),
            CategorySection(addCategoryImage, newRecipeCategories, _formKey),
          ]),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    preperationTimeController.dispose();
    cookingTimeController.dispose();
    totalTimeController.dispose();
    servingsController.dispose();
    notesController.dispose();
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
  }

  /// TODO: Only shows the new recipedata after restart. Needs to be fixed!
  Future<Recipe> deleteOldSaveNewRecipe(Recipe editRecipe) async {
    // If user hasn't selected a new image (old image stays the same) ..
    if (selectedRecipeImage.getSelectedImage() ==
        await PathProvider.pP.getRecipePath(editRecipe.id)) {
      // .. temporarily put image in tmp dir befor recipe gets deleted and saved again
      String tmpRecipeImage =
          await PathProvider.pP.getTmpImagePath(editRecipe.imagePath);
      await compute(
          saveImage, [File(editRecipe.imagePath), tmpRecipeImage, 2000]);
      selectedRecipeImage.setSelectedImage(tmpRecipeImage);
    }

    /// temporarily save all step pics (that are not new) in another folder that they don't get lost,
    /// when the recipe gets deleted.
    for (int i = 0; i < stepImages.length; i++) {
      print(stepImages.length);
      for (int j = 0; j < stepImages[i].length; j++) {
        print(stepImages[i].length);
        if (stepImages[i][j]
            .contains(PathProvider.pP.getRecipeStepDir(editRecipe.id))) {
          String stepImageName = stepImages[i][j].split("/").last;
          String tmpStepImagePath =
              await PathProvider.pP.getTmpImagePath(stepImageName);
          await compute(
              saveImage, [File(stepImages[i][j]), tmpStepImagePath, 2000]);
          stepImages[i][j] = tmpStepImagePath;
        }
      }
    }

    await DBProvider.db.deleteRecipe(editRecipe);
    print(selectedRecipeImage.getSelectedImage());
    Recipe newRecipe = await saveRecipe();

    // DELETION
    Directory appDir = await getApplicationDocumentsDirectory();
    String imageLocalPathRecipe = "${appDir.path}/tmp";
    var dir = new Directory(imageLocalPathRecipe);
    if (await dir.exists()) {
      dir.deleteSync(recursive: true);
    }

    return newRecipe;
  }

  Future<Recipe> saveRecipe() async {
    print("start saveRecipe()");

    // get the lists for the data of the ingredients
    Map<String, List<List<dynamic>>> ingredients = getCleanIngredientData(
        ingredientNameController,
        ingredientAmountController,
        ingredientUnitController);

    int recipeId;
    widget.editRecipe == null
        ? recipeId = await DBProvider.db.getNewIDforTable("Recipe", "id")
        : recipeId = widget.editRecipe.id;

    String recipeImagePath = await PathProvider.pP.getRecipePath(recipeId);
    await compute(saveImage,
        [File(selectedRecipeImage.getSelectedImage()), recipeImagePath, 2000]);
    selectedRecipeImage.setSelectedImage(recipeImagePath);
    print(removeEmptyStrings(stepsDescController).length);
    for (int i = 0; i < removeEmptyStrings(stepsDescController).length; i++) {
      for (int j = 0; j < stepImages[i].length; j++) {
        String stepImageLocation =
            await PathProvider.pP.getRecipeStepPath(recipeId, i, j);
        String stepImagePreviewLocation =
            await PathProvider.pP.getRecipeStepPreviewPath(recipeId, i, j);
        await compute(
            saveImage, [File(stepImages[i][j]), stepImageLocation, 2000]);
        await compute(
            saveImage, [File(stepImages[i][j]), stepImagePreviewLocation, 500]);
        stepImages[i][j] =
            await PathProvider.pP.getRecipeStepPath(recipeId, i, j);
      }
    }
    Recipe newRecipe = new Recipe(
        id: recipeId,
        name: nameController.text,
        imagePath: selectedRecipeImage.getSelectedImage(),
        preperationTime: preperationTimeController.text.isEmpty
            ? 0
            : double.parse(preperationTimeController.text
                .replaceAll(new RegExp(r','), 'e')),
        cookingTime: cookingTimeController.text.isEmpty
            ? 0
            : double.parse(
                cookingTimeController.text.replaceAll(new RegExp(r','), 'e')),
        totalTime: totalTimeController.text.isEmpty
            ? 0
            : double.parse(
                totalTimeController.text.replaceAll(new RegExp(r','), 'e')),
        servings: double.parse(
            servingsController.text.replaceAll(new RegExp(r','), 'e')),
        steps: removeEmptyStrings(stepsDescController),
        stepImages: stepImages,
        notes: notesController.text,
        vegetable: selectedRecipeVegetable.getVegetableStatus(),
        ingredientsGlossary:
            getCleanGlossary(ingredientGlossaryController, ingredients),
        ingredientsList: ingredients["ingredients"],
        amount: ingredients["amount"],
        unit: ingredients["unit"],
        complexity: complexity.getDouble().round(),
        categories: newRecipeCategories,
        isFavorite:
            widget.editRecipe == null ? null : widget.editRecipe.isFavorite);
    await DBProvider.db.newRecipe(newRecipe);
    if (widget.editRecipe != null) {
      await DBProvider.db
          .updateFavorite(widget.editRecipe.isFavorite, recipeId);
    }

    print("---------------");
    print(ingredients["ingredients"]);
    print(getCleanGlossary(ingredientGlossaryController, ingredients));
    print(ingredients["ingredients"]);
    print(ingredients["amount"]);
    print(ingredients["unit"]);
    print("---------------");

    // DELETE
    await DBProvider.db.getRecipeById(recipeId);

    return newRecipe;
  }

  // TODO: Remove if not needed anymore
  //bool isIngredientListValid(
  //    List<List<TextEditingController>> ingredients,
  //    List<List<TextEditingController>> amount,
  //    List<List<TextEditingController>> unit) {
  //  int validator = 0;
  //  for (int i = 0; i < ingredients.length; i++) {
  //    for (int j = 0; j < ingredients[i].length; j++) {
  //      validator = 0;
  //      if (ingredients[i][j].text == "") validator++;
  //      if (amount[i][j].text == "") validator++;
  //      if (unit[i][j].text == "") validator++;
  //      if (validator == 1 || validator == 2) return false;
  //    }
  //  }
  //  return true;
  //}

  List<String> removeEmptyStrings(List<TextEditingController> list) {
    List<String> output = new List<String>();

    for (int i = 0; i < list.length; i++) {
      if (list[i].text != "") {
        output.add(list[i].text);
      }
    }
    return output;
  }

  /// sets the length of the glossary for the ingredients section equal to
  /// the length list<list<ingredients>> (removes unnessesary sections)
  List<String> getCleanGlossary(List<TextEditingController> glossary,
      Map<String, List<List<dynamic>>> cleanIngredientsData) {
    List<String> output = new List<String>();
    for (int i = 0; i < glossary.length; i++) {
      output.add(glossary[i].text);
    }

    for (int i = cleanIngredientsData["ingredients"].length;
        i < glossary.length;
        i++) {
      output.removeLast();
    }

    return output;
  }

  /// removes all leading and trailing whitespaces and empty ingredients from the lists
  /// of ingredients and
  Map<String, List<List<dynamic>>> getCleanIngredientData(
      List<List<TextEditingController>> ingredients,
      List<List<TextEditingController>> amount,
      List<List<TextEditingController>> unit) {
    /// creating the three lists with the data of the ingredients
    /// by getting the data of the controllers.
    List<List<String>> ingredientsNames = new List<List<String>>();
    for (int i = 0; i < ingredients.length; i++) {
      ingredientsNames.add(new List<String>());
      for (int j = 0; j < ingredients[i].length; j++) {
        ingredientsNames[i].add(ingredients[i][j].text);
      }
    }

    List<List<double>> ingredientsAmount = new List<List<double>>();
    for (int i = 0; i < amount.length; i++) {
      ingredientsAmount.add(new List<double>());
      for (int j = 0; j < amount[i].length; j++) {
        String addValue = "-1";
        if (amount[i][j].text != "") addValue = amount[i][j].text;
        ingredientsAmount[i]
            .add(double.parse(addValue.replaceAll(new RegExp(r','), 'e')));
      }
    }

    List<List<String>> ingredientsUnit = new List<List<String>>();
    for (int i = 0; i < unit.length; i++) {
      ingredientsUnit.add(new List<String>());
      for (int j = 0; j < unit[i].length; j++) {
        ingredientsUnit[i].add(unit[i][j].text);
      }
    }

    /// Map which will be the clean map with the list of the ingredients
    /// data.
    Map<String, List<List<dynamic>>> output =
        new Map<String, List<List<dynamic>>>();

    output.addAll({"ingredients": new List<List<String>>()});
    output["ingredients"].addAll(ingredientsNames);
    output.addAll({"amount": new List<List<double>>()});
    output["amount"].addAll(ingredientsAmount);
    output.addAll({"unit": new List<List<String>>()});
    output["unit"].addAll(ingredientsUnit);

    for (int i = 0; i < output["ingredients"].length; i++) {
      for (int j = 0; j < output["ingredients"][i].length; j++) {
        // remove leading and trailing white spaces
        output["ingredients"][i][j] = output["ingredients"][i][j].trim();
        output["unit"][i][j] = output["unit"][i][j].trim();
        // remove all ingredients from the list, when all three fields are empty
        if (output["ingredients"][i][j] == "" &&
            output["amount"][i][j] == -1 &&
            output["unit"][i][j] == "") {
          output["ingredients"][i].removeAt(j);
          output["amount"][i].removeAt(j);
          output["unit"][i].removeAt(j);
        }
      }
    }
    // create the output list with the clean ingredient lists
    for (int i = 0; i < output["ingredients"].length; i++) {
      if (output["ingredients"][i].isEmpty) {
        output["ingredients"].remove(output["ingredients"][i]);
        output["amount"].remove(output["amount"][i]);
        output["unit"].remove(output["unit"][i]);
      }
    }

    return output;
  }
}

/// Only List of attributs because compute only lets you have one 
/// argument for the executed method
/// List of dynamic must have
/// [0] File image
/// [1] String name
/// [2] int quality
void saveImage(List<dynamic> values) async {
  print("****************************");
  print("saveFile()");
  print(values[0].path);
  print(values[1]);

  if (values[0] != null) {
    ImageIO.Image newImage = ImageIO.decodeImage(values[0].readAsBytesSync());
    ImageIO.Image resizedImage =
        ImageIO.copyResize(newImage, height: values[2]);
    new File('${values[1]}')..writeAsBytesSync(ImageIO.encodeJpg(newImage));
  }
  print("****************************");
}

bool validateNumber(String text) {
  if (text.isEmpty) {
    return true;
  }
  String pattern = r"^(?!0*[.,]?0+$)\d*[.,]?\d+$";

  RegExp regex = new RegExp(pattern);
  if (regex.hasMatch(text)) {
    return true;
  } else {
    return false;
  }
}

typedef SectionsCountCallback = void Function(int sections);
typedef SectionAddCallback = void Function();

// clips a shape with 8 edges
class CustomIngredientsClipper extends CustomClipper<Path> {
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(size.width / 3 * 2, 0);
    path.lineTo(size.width, size.height / 3);
    path.lineTo(size.width, size.height / 3 * 2);
    path.lineTo(size.width / 3 * 2, size.height);
    path.lineTo(size.width / 3, size.height);
    path.lineTo(0, size.height / 3 * 2);
    path.lineTo(0, size.height / 3);
    path.lineTo(size.width / 3, 0);
    path.close();
    return path;
  }

  bool shouldReclip(CustomIngredientsClipper oldClipper) => false;
}

// clips a diamond shape
class CustomStepsClipper extends CustomClipper<Path> {
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(0, size.height / 2);
    path.lineTo(size.width / 2, 0);
    path.close();
    return path;
  }

  bool shouldReclip(CustomStepsClipper oldClipper) => false;
}

enum Answers { GALLERY, PHOTO }
