import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../../recipe.dart';
import '../../database.dart';
import './steps_section.dart';
import './ingredients_section.dart';
import '../../round_dialog.dart';

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

  //////////// for Complexity ////////////
  final MyDoubleWrapper complexity = new MyDoubleWrapper(myDouble: 5.0);

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

  int recipeId;

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
      nameController.text = widget.editRecipe.name;
      if (widget.editRecipe.imagePath != "images/randomFood.png")
        selectedRecipeImage.selectedImage = widget.editRecipe.imagePath;
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
        for (int j = 0; j < widget.editRecipe.ingredients[i].length; j++) {
          if (i != 0 || j > 0) {
            ingredientNameController[i].add(new TextEditingController());
            ingredientAmountController[i].add(new TextEditingController());
            ingredientUnitController[i].add(new TextEditingController());
          }
          ingredientNameController[i][j].text =
              widget.editRecipe.ingredients[i][j].name;
          ingredientAmountController[i][j].text =
              widget.editRecipe.ingredients[i][j].amount.toString();
          ingredientUnitController[i][j].text =
              widget.editRecipe.ingredients[i][j].unit;
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
              // TODO: Check if ingredients data is not only partially filled in
              if (_formKey.currentState.validate() &&
                  isIngredientListValid(ingredientNameController,
                      ingredientAmountController, ingredientUnitController)) {
                /////////// Only do if all data is VALID! ///////////
                FocusScope.of(context).requestFocus(new FocusNode());
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => WillPopScope(
                      // It disables the back button
                      onWillPop: () async => false,
                      child: RoundDialog(
                          FlareActor(
                            'animations/writing_pen.flr',
                            alignment: Alignment.center,
                            fit: BoxFit.fitWidth,
                            animation: "Go",
                          ),
                          150)),
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
                    imageCache.clear();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => RecipeScreen(
                                  recipe: newRecipe,
                                  primaryColor:
                                      getRecipePrimaryColor(newRecipe),
                                  heroImageTag: 'null',
                                )));
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
            IS.ImageSelector(
              imageWrapper: selectedRecipeImage,
              circleSize: 120,
              color: Color(0xFF790604),
              // type: IS.TypeRC.RECIPE,
              //editRecipeId:
              //    widget.editRecipe == null ? null : widget.editRecipe.id,
            ),
            SizedBox(height: 30),
            // name textField
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter a name";
                  }
                  return null;
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
                        }
                        return null;
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
                        }
                        return null;
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
                  }
                  return null;
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
                  }
                  return null;
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
            Steps(stepsDescController, stepImages, recipeId),
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
            CategorySection( newRecipeCategories, _formKey),
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
    /*
    // If user hasn't selected a new image (old image stays the same) ..
    if (selectedRecipeImage.selectedImage ==
        await PathProvider.pP.getRecipePath(editRecipe.id)) {
      // .. temporarily put image in tmp dir befor recipe gets deleted and saved again
      String tmpRecipeImage =
          await PathProvider.pP.getTmpImagePath(editRecipe.imagePath);
      // remove code when not needed anymore
      saveImage(File(editRecipe.imagePath), tmpRecipeImage, 300);
      saveImage(File(editRecipe.imagePath), tmpRecipeImage, 300);
      selectedRecipeImage.selectedImage = tmpRecipeImage;
    }*/

    /// temporarily save all step pics (that are not new) in another folder that they don't get lost,
    /// when the recipe gets deleted.
    /*
    for (int i = 0; i < stepImages.length; i++) {
      for (int j = 0; j < stepImages[i].length; j++) {
        if (stepImages[i][j]
            .contains(PathProvider.pP.getRecipeStepDir(editRecipe.id))) {
          String stepImageName = stepImages[i][j].split("/").last;
          String tmpStepImagePath =
              await PathProvider.pP.getTmpImagePath(stepImageName);
          saveImage(File(stepImages[i][j]), tmpStepImagePath, 2000);
          stepImages[i][j] = tmpStepImagePath;
        }
      }
    }
    */

    await DBProvider.db.deleteRecipeFromDatabase(editRecipe);
    Recipe newRecipe = await saveRecipe();

    // DELETION
    /*
    Directory appDir = await getApplicationDocumentsDirectory();
    String imageLocalPathRecipe = "${appDir.path}/tmp";
    var dir = new Directory(imageLocalPathRecipe);
    if (await dir.exists()) {
      dir.deleteSync(recursive: true);
    }
    */

    return newRecipe;
  }

  Future<Recipe> saveRecipe() async {
    // get the lists for the data of the ingredients
    List<List<Ingredient>> ingredients = getCleanIngredientData(
        ingredientNameController,
        ingredientAmountController,
        ingredientUnitController);

    // Saving the Recipe image and RecipePreviewImage (Recipe Image with lower quality)
    // TODO: Remove unnessesary code - Code for saving here
    /*
    if (selectedRecipeImage.selectedImage != 'images/randomFood.png' &&
        selectedRecipeImage.selectedImage != null) {
      String recipeImagePath = await PathProvider.pP.getRecipePath(recipeId);
      await saveImage(
          File(selectedRecipeImage.selectedImage), recipeImagePath, 2000);
      selectedRecipeImage.selectedImage = recipeImagePath;
      String recipeImagePreviewPath =
          await PathProvider.pP.getRecipePreviewPath(recipeId);
      await saveImage(
          File(selectedRecipeImage.selectedImage), recipeImagePreviewPath, 400);
    }*/
    /*
    for (int i = 0; i < removeEmptyStrings(stepsDescController).length; i++) {
      for (int j = 0; j < stepImages[i].length; j++) {
        String stepImageLocation =
            await PathProvider.pP.getRecipeStepPath(recipeId, i, j);
        String stepImagePreviewLocation =
            await PathProvider.pP.getRecipeStepPreviewPath(recipeId, i, j);
        await saveImage(File(stepImages[i][j]), stepImageLocation, 2000);
        await saveImage(File(stepImages[i][j]), stepImagePreviewLocation, 500);
        stepImages[i][j] =
            await PathProvider.pP.getRecipeStepPath(recipeId, i, j);
      }
    }*/
    if (recipeId == null)
      recipeId = await DBProvider.db.getNewIDforTable('recipe', 'id');
    Recipe newRecipe = new Recipe(
      id: recipeId,
      name: nameController.text,
      imagePath: selectedRecipeImage.selectedImage != null
          ? await PathProvider.pP.getRecipePath(recipeId)
          : "images/randomFood.png",
      imagePreviewPath: selectedRecipeImage.selectedImage != null
          ? await PathProvider.pP.getRecipePreviewPath(recipeId)
          : "images/randomFood.png",
      preperationTime: preperationTimeController.text.isEmpty
          ? 0
          : double.parse(
              preperationTimeController.text.replaceAll(new RegExp(r','), 'e')),
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
      ingredients: ingredients,
      complexity: complexity.myDouble.round(),
      categories: newRecipeCategories,
      isFavorite:
          widget.editRecipe == null ? false : widget.editRecipe.isFavorite,
    );
    await DBProvider.db.newRecipe(newRecipe);
    if (widget.editRecipe != null) {
      widget.editRecipe.setEqual(newRecipe);
      await DBProvider.db
          .updateFavorite(widget.editRecipe.isFavorite, recipeId);
    }

    // DELETE
    await DBProvider.db.getRecipeById(recipeId);

    return newRecipe;
  }

  bool isIngredientListValid(
      List<List<TextEditingController>> ingredients,
      List<List<TextEditingController>> amount,
      List<List<TextEditingController>> unit) {
    int validator = 0;
    for (int i = 0; i < ingredients.length; i++) {
      for (int j = 0; j < ingredients[i].length; j++) {
        validator = 0;
        if (ingredients[i][j].text == "") validator++;
        if (amount[i][j].text == "") validator++;
        if (unit[i][j].text == "") validator++;
        if (validator == 1 || validator == 2) return false;
      }
    }
    return true;
  }

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
      List<List<Ingredient>> cleanIngredientsData) {
    List<String> output = new List<String>();
    for (int i = 0; i < glossary.length; i++) {
      output.add(glossary[i].text);
    }

    for (int i = cleanIngredientsData.length; i < glossary.length; i++) {
      output.removeLast();
    }

    return output;
  }

  /// removes all leading and trailing whitespaces and empty ingredients from the lists
  /// of ingredients and
  List<List<Ingredient>> getCleanIngredientData(
      List<List<TextEditingController>> ingredients,
      List<List<TextEditingController>> amount,
      List<List<TextEditingController>> unit) {
    /// creating the three lists with the data of the ingredients
    /// by getting the data of the controllers.
    List<List<String>> ingredientsNames = [[]];
    for (int i = 0; i < ingredients.length; i++) {
      ingredientsNames.add([]);
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
    List<List<Ingredient>> cleanIngredientsData = [[]];

    for (int i = 0; i < ingredientsNames.length; i++) {
      cleanIngredientsData.add([]);
      for (int j = 0; j < ingredientsNames[i].length; j++)
        cleanIngredientsData[i].add(Ingredient(ingredientsNames[i][j],
            ingredientsAmount[i][j], ingredientsUnit[i][j]));
    }

    for (int i = 0; i < cleanIngredientsData.length; i++) {
      for (int j = 0; j < cleanIngredientsData[i].length; j++) {
        // remove leading and trailing white spaces
        cleanIngredientsData[i][j].name =
            cleanIngredientsData[i][j].name.trim();
        cleanIngredientsData[i][j].unit =
            cleanIngredientsData[i][j].unit.trim();
        // remove all ingredients from the list, when all three fields are empty
        if (cleanIngredientsData[i][j].name == "" &&
            cleanIngredientsData[i][j].amount == -1 &&
            cleanIngredientsData[i][j].unit == "") {
          cleanIngredientsData[i].removeAt(j);
        }
      }
    }
    // create the output list with the clean ingredient lists
    for (int i = 0; i < cleanIngredientsData.length; i++) {
      if (cleanIngredientsData[i].isEmpty) {
        cleanIngredientsData.remove(cleanIngredientsData[i]);
      }
    }

    return cleanIngredientsData;
  }
}

/// Only List of attributs because compute only lets you have one
/// argument for the executed method

Future<void> saveImage(File image, String name, int resolution) async {
  if (image != null) {
    final File newImage = await image.copy(name);
    print('UUUUUUUUUNNNNNNNNNNNNDDDDDDDDDD');
    /*
    ImageProperties properties =
        await FlutterNativeImage.getImageProperties(newImage.path);
    double quality = resolution / (properties.height + properties.width) * 100;
    if (quality > 100) quality = 100;
    print(properties.height);
    print(quality);
    File compressedFile = await FlutterNativeImage.compressImage(newImage.path,
        quality: quality.toInt(), percentage: 100);
        */

    await FlutterImageCompress.compressAndGetFile(
      image.path,
      name,
      minHeight: resolution,
      minWidth: resolution,
      quality: 95,
    );

    print('GGGGGGGOOOOOOOOOOOOOOOOOOOOOOOO');
    // compressedFile.copy(name);
    print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
    // print(quality);

    /*
    ImageIO.Image newImage = ImageIO.decodeImage(values[0].readAsBytesSync());
    ImageIO.Image resizedImage =
        ImageIO.copyResize(newImage, height: values[2]);
    new File('${values[1]}')..writeAsBytesSync(ImageIO.encodeJpg(resizedImage));
    */
  }
}

void showSavingDialog(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
          // It disables the back button
          onWillPop: () async => false,
          child: RoundDialog(CircularProgressIndicator(), 50)));
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
