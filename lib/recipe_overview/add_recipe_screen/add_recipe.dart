import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

import '../../recipe.dart';
import '../../database.dart';
import './steps_section.dart';
import './ingredients_section.dart';
import './categories_section.dart';
import './vegetarian_section.dart';
import '../../my_wrapper.dart';
import './complexity_section.dart';
import '../recipe_screen.dart' show RecipeScreen;

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
  final List<List<File>> stepImages = new List<List<File>>();
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
  bool buttonEnabled = true;

  @override
  void initState() {
    super.initState();
    selectedRecipeVegetable.setVegetableStatus(Vegetable.NON_VEGETARIAN);
    stepImages.add(new List<File>());
    // initialize list of controllers for the dynamic textFields with one element
    ingredientNameController.add(new List<TextEditingController>());
    ingredientNameController[0].add(new TextEditingController());
    ingredientAmountController.add(new List<TextEditingController>());
    ingredientAmountController[0].add(new TextEditingController());
    ingredientUnitController.add(new List<TextEditingController>());
    ingredientUnitController[0].add(new TextEditingController());
    ingredientGlossaryController.add(new TextEditingController());
    stepsDescController.add(new TextEditingController());

    if (widget.editRecipe != null) {
      // TODO: only add data if not null;
      nameController.text = widget.editRecipe.name;
      if (widget.editRecipe.image != null)
        selectedRecipeImage.setSelectedImage(widget.editRecipe.image);
      preperationTimeController.text =
          widget.editRecipe.preperationTime.toString();
      if (widget.editRecipe.cookingTime != null)
        cookingTimeController.text = widget.editRecipe.cookingTime.toString();
      if (widget.editRecipe.totalTime != null)
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
          stepImages.add(new List<File>());
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
              color: buttonEnabled == false ? Colors.grey : Colors.white,
              onPressed: () {
                if (buttonEnabled) {
                  if (_formKey.currentState.validate()) {
                    if (isIngredientListValid(ingredientNameController,
                        ingredientAmountController, ingredientUnitController)) {
                      /////////// Only do when all data is VALID! ///////////
                      if (widget.editRecipe == null) {
                        saveRecipe().then((_) {
                          Navigator.pop(context);
                        });
                      } else {
                        deleteOldSaveNewRecipe(widget.editRecipe)
                            .then((newRecipe) {
                          newRecipe.isFavorite = widget.editRecipe.isFavorite;
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      RecipeScreen(recipe: newRecipe)));
                        });
                      }
                      setState(() {
                        buttonEnabled = false;
                      });
                    } else {
                      // TODO: show alert with info that ingredients list need to be filled in properly
                      print(
                          "show alert with info that ingredients list needs to be filled in properly");
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                title: Text("No valid data for ingredients"),
                                contentPadding:
                                    EdgeInsets.fromLTRB(15, 24, 15, 0),
                                content: Text(
                                    "Please fill in the data for the ingredients properly :)"),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text('Ok'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ));
                    }
                  }
                } else {
                  return;
                }
              },
            )
          ],
        ),
        body: Form(
          key: _formKey,
          child: ListView(children: <Widget>[
            // top section with the add image button
            ImageSelector(selectedRecipeImage),
            // name textField
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter a name";
                  }
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
                      },
                      autovalidate: true,
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
                      },
                      autovalidate: true,
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
                },
                autovalidate: true,
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
            CategorySection(addCategoryImage, newRecipeCategories),
          ]),
        ));
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

  Future<Recipe> deleteOldSaveNewRecipe(Recipe editRecipe) async {
    if (selectedRecipeImage.getSelectedImage().path ==
        await ImagePath.getRecipePath(editRecipe.id)) {
      String tmpRecipeImage = await ImagePath.getTmpRecipePath();
      await saveImage(editRecipe.image, tmpRecipeImage);
      selectedRecipeImage.setSelectedImage(File(tmpRecipeImage));
    }

    for (int i = 0; i < stepImages.length; i++) {
      print(stepImages.length);
      for (int j = 0; j < stepImages[i].length; j++) {
        print(stepImages[i].length);
        if (stepImages[i][j]
            .path
            .contains(ImagePath.getRecipeStepDir(editRecipe.id))) {
          String name = stepImages[i][j].path.split("/").last;
          String tmpStepImagePath = await ImagePath.getTmpStepPathImage(name);
          await saveImage(stepImages[i][j], tmpStepImagePath);
          stepImages[i][j] = File(tmpStepImagePath);
        }
      }
    }

    await DBProvider.db.deleteRecipe(editRecipe);
    print(selectedRecipeImage.getSelectedImage().path);
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
        ? recipeId = await DBProvider.db.getNewIDforTable("Recipe")
        : recipeId = widget.editRecipe.id;

    String recipeImagePath = await ImagePath.getRecipePath(recipeId);
    String s = selectedRecipeImage.getSelectedImage().path;
    print("PPPPPPPPPPPPPPPPPPPP");
    print(s);
    print("PPPPPPPPPPPPPPPPPPPP");
    await saveImage(selectedRecipeImage.getSelectedImage(), recipeImagePath);
    selectedRecipeImage.setSelectedImage(File(recipeImagePath));
    print(removeEmptyStrings(stepsDescController).length);
    for (int i = 0; i < removeEmptyStrings(stepsDescController).length; i++) {
      for (int j = 0; j < stepImages[i].length; j++) {
        await saveImage(stepImages[i][j],
            await ImagePath.getRecipeStepPath(recipeId, i, j));
        stepImages[i][j] =
            File(await ImagePath.getRecipeStepPath(recipeId, i, j));
      }
    }
    Recipe newRecipe = new Recipe(
        id: recipeId,
        name: nameController.text,
        image: selectedRecipeImage.getSelectedImage(),
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
    int i = await DBProvider.db.newRecipe(newRecipe);
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
    var result = await DBProvider.db.getRecipeById(recipeId);

    return newRecipe;
    print("end saveRecipe()");
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

Future<void> saveImage(File image, String name) async {
  print("saveFile()");
  print("****************************");
  print(image.path);
  print(name);

  if (image != null) {
    await image.copy("$name");
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

// Top section of the screen where you can select an image for the dish
class ImageSelector extends StatefulWidget {
  final MyImageWrapper selectedRecipeImage;

  ImageSelector(this.selectedRecipeImage);

  @override
  State<StatefulWidget> createState() {
    return _ImageSelectorState();
  }
}

class _ImageSelectorState extends State<ImageSelector> {
  Future _askUser() async {
    switch (await showDialog(
        context: context,
        builder: (_) => SimpleDialog(
              title: Text("Change Picture"),
              children: <Widget>[
                SimpleDialogOption(
                  child: Text("Select an image from your gallery"),
                  onPressed: () {
                    Navigator.pop(context, Answers.GALLERY);
                  },
                ),
                SimpleDialogOption(
                  child: Text("Take a new photo with camera"),
                  onPressed: () {
                    Navigator.pop(context, Answers.PHOTO);
                  },
                ),
              ],
            ))) {
      case Answers.GALLERY:
        {
          File pictureFile = await ImagePicker.pickImage(
            source: ImageSource.gallery,
            // maxHeight: 50.0,
            // maxWidth: 50.0,
          );
          if (pictureFile != null) {
            widget.selectedRecipeImage.setSelectedImage(pictureFile);
            print("You selected gallery image : " + pictureFile.path);
            setState(() {});
          }
          break;
        }
      case Answers.PHOTO:
        {
          File pictureFile = await ImagePicker.pickImage(
            source: ImageSource.camera,
            //maxHeight: 50.0,
            //maxWidth: 50.0,
          );
          if (pictureFile != null) {
            widget.selectedRecipeImage.setSelectedImage(pictureFile);
            print("You selected gallery image : " + pictureFile.path);
            setState(() {});
          }
          break;
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Center(
          child: widget.selectedRecipeImage.getSelectedImage() == null
              ? Container(
                  child: Center(
                      child: IconButton(
                    onPressed: () {
                      _askUser();
                    },
                    color: Colors.white,
                    icon: Icon(Icons.add_a_photo),
                    iconSize: 32,
                  )),
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF790604),
                  ),
                )
              : Stack(children: <Widget>[
                  ClipOval(
                      child: Container(
                    child: Image.file(
                      widget.selectedRecipeImage.getSelectedImage(),
                      fit: BoxFit.cover,
                    ),
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                  )),
                  Opacity(
                    opacity: 0.3,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black87,
                      ),
                      width: 110,
                      height: 110,
                    ),
                  ),
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: IconButton(
                      icon: Icon(Icons.add_a_photo),
                      iconSize: 32,
                      color: Colors.white,
                      onPressed: () {
                        setState(() {
                          _askUser();
                        });
                      },
                    ),
                  ),
                ])),
    );
  }
}
