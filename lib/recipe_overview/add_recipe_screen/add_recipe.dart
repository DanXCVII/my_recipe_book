import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:my_recipe_book/io/io_operations.dart';
import 'package:my_recipe_book/models/recipe_keeper.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:math';

import '../../recipe.dart';
import '../../database.dart';
import './steps_section.dart';
import './ingredients_section.dart';
import '../../dialogs.dart';

import './categories_section.dart';
import './vegetarian_section.dart';
import './validation_clean_up.dart';
import '../../my_wrapper.dart';
import './complexity_section.dart';
import '../recipe_screen.dart' show RecipeScreen;
import './image_selector.dart' as IS;

const double categories = 14;
const double topPadding = 8;

class AddRecipeForm extends StatefulWidget {
  final Recipe editRecipe;

  AddRecipeForm({
    this.editRecipe,
  });

  @override
  State<StatefulWidget> createState() {
    return _AddRecipeFormState();
  }
}

class _AddRecipeFormState extends State<AddRecipeForm> {
  //////////// for Ingredients ////////////
  final List<List<TextEditingController>> ingredientNameController = [[]];
  final List<List<TextEditingController>> ingredientAmountController = [[]];
  final List<List<TextEditingController>> ingredientUnitController = [[]];
  final List<TextEditingController> ingredientGlossaryController = [];

  //////////// for Steps ////////////
  final List<List<String>> stepImages = [[]];
  final List<TextEditingController> stepsDescController = [];

  //////////// for Category ////////////
  final List<String> newRecipeCategories = [];

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

  static GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // TODO: Delete old not saved data when opening addRecipe
  @override
  void initState() {
    super.initState();

    selectedRecipeVegetable.setVegetableStatus(Vegetable.NON_VEGETARIAN);
    stepImages.add([]);
    // initialize list of controllers for the dynamic textFields with one element
    ingredientNameController.add([]);
    ingredientNameController[0].add(new TextEditingController());
    ingredientAmountController.add([]);
    ingredientAmountController[0].add(new TextEditingController());
    ingredientUnitController.add([]);
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

        ingredientNameController.add([]);
        ingredientAmountController.add([]);
        ingredientUnitController.add([]);
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
          stepImages.add([]);
        }
        stepsDescController[i].text = widget.editRecipe.steps[i];

        for (int j = 0; j < widget.editRecipe.stepImages[i].length; j++) {
          // TODO: When editing recipe, the fullPath to the image is set here
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
          ScopedModelDescendant<RecipeKeeper>(builder: (context, child, model) {
            return IconButton(
              icon: Icon(Icons.check),
              color: Colors.white,
              onPressed: () {
                // TODO: Check if ingredients data is not only partially filled in
                if (!_formKey.currentState.validate()) {
                  showDialog(
                      context: context,
                      builder: (_) => RoundEdgeDialog(
                            title: Text(
                              'Check filled in information',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 21),
                            ),
                            bottomSection: Text(
                              'it seems, that you haven’t filled in the required fields. '
                              'Please check for any red marked text fields.',
                            ),
                          ));
                } else if (!isIngredientListValid(
                  ingredientNameController,
                  ingredientAmountController,
                  ingredientUnitController,
                )) {
                  showDialog(
                      context: context,
                      builder: (_) => RoundEdgeDialog(
                            title: Text(
                              'Check your ingredients input',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 21),
                            ),
                            bottomSection: Text(
                              'it seems to be that you have only partially filled out the '
                              'data for the ingredients. Please correct that :)',
                            ),
                          ));
                } else if (!isGlossaryValid(
                  ingredientNameController,
                  ingredientAmountController,
                  ingredientUnitController,
                  ingredientGlossaryController,
                )) {
                  showDialog(
                      context: context,
                      builder: (_) => RoundEdgeDialog(
                            title: Text(
                              'Check your ingredients section fields',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 21),
                            ),
                            bottomSection: Text(
                                'if you have multiple sections, you need to provide a title '
                                'for each section.'),
                          ));
                } else {
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
                    saveRecipe(model).then((_) {
                      Navigator.pop(context);
                    });
                  } else {
                    deleteOldSaveNewRecipe(widget.editRecipe, model)
                        .then((newRecipe) {
                      newRecipe.isFavorite = widget.editRecipe.isFavorite;
                      Navigator.pop(context); // loading screen
                      Navigator.pop(context); // edit recipe screen
                      Navigator.pop(context); // old recipe screen
                      Navigator.pop(context); // recipes
                      imageCache
                          .clear(); // TODO: Maybe optimize and only clear nessesary date.. maybe not..
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => RecipeScreen(
                                    recipe: newRecipe,
                                    primaryColor: getRecipePrimaryColor(
                                        newRecipe.vegetable),
                                    heroImageTag: 'null',
                                  )));
                    });
                  }
                }
              },
            );
          }),
          IconButton(
            icon: Icon(Icons.art_track),
            onPressed: () {
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
              saveDummyData().then((_) {
                Navigator.pop(context);
              });
            },
          )
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
            // type: IS.TypeRC.RECIPE,
            recipeName:
                widget.editRecipe == null ? 'tmp' : widget.editRecipe.name,
          ),
          SizedBox(height: 30),
          // name textField
          Form(
            key: _formKey,
            child: Column(children: <Widget>[
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
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              // category for radio buttons for vegetarian selector
              Vegetarian(
                vegetableStatus: selectedRecipeVegetable,
              ),
              // heading with textFields for steps section
              widget.editRecipe != null
                  ? Steps(
                      stepsDescController,
                      stepImages,
                      recipeName: widget.editRecipe.name,
                    )
                  : Steps(
                      stepsDescController,
                      stepImages,
                    ),

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
            ]),
          ),
          ComplexitySection(complexity: complexity),
          CategorySection(newRecipeCategories),
        ]),
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

  /// TODO: ~~Fix that cached image will still show and not the new one
  Future<Recipe> deleteOldSaveNewRecipe(
      Recipe editRecipe, RecipeKeeper rKeeper) async {
    rKeeper.deleteRecipeWithName(editRecipe.name);
    await DBProvider.db.deleteRecipeFromDatabase(editRecipe);
    Recipe newRecipe = await saveRecipe(rKeeper);

    return newRecipe;
  }

  Future<void> saveDummyData() async {
    await DBProvider.db.newCategory('Hauptseisen');
    await DBProvider.db.newCategory('Vorspeisen');
    await DBProvider.db.newCategory('Nachtisch');
    await DBProvider.db.newCategory('Gemüselastig');
    int id1 = await DBProvider.db.getNewIDforTable('recipe', 'id');

    String imagePath =
        PathProvider.pP.getRecipePath('Steack mit Bratsauce', '.jpg');
    String imagePreviewPath =
        PathProvider.pP.getRecipePreviewPath('Steack mit Bratsauce', '.jpg');

    await saveImage(File('/storage/emulated/0/Download/recipeData/meat.jpg'),
        imagePath, 2000);
    //await saveImage(File('/storage/emulated/0/Download/recipeDate/meat.jpg'),
    //    imagePreviewPath, 300);
    Recipe r1 = new Recipe(
      name: 'Steack mit Bratsauce',
      imagePath: imagePath,
      imagePreviewPath: imagePreviewPath,
      preperationTime: 15,
      cookingTime: 60,
      totalTime: 90,
      servings: 3,
      ingredientsGlossary: ['Steacksauce', 'Steack'],
      ingredients: [
        [
          Ingredient(name: 'Rosmarin', amount: 5, unit: 'Zweige'),
          Ingredient(name: 'Mehl', amount: 300, unit: 'g'),
          Ingredient(name: 'Curry', amount: 1, unit: 'EL'),
          Ingredient(name: 'Gewürze', amount: 3, unit: 'Priesen')
        ],
        [
          Ingredient(name: 'Rohrzucker', amount: 50, unit: 'g'),
          Ingredient(name: 'Steak', amount: 700, unit: 'g')
        ],
      ],
      effort: 4,
      vegetable: Vegetable.NON_VEGETARIAN,
      steps: [
        'Flank Steak mit Rohrzucker und Salz bestreuen, anschließend mit Teriyakisauce marinieren '
            'und sanft einmassieren. Im Kühlschrank für 2 bis 3 Stunden ziehen lassen und danach 30 '
            'Minuten bei Zimmertemperatur ruhen lassen.',
        'Flank Steak etwa 2 Minuten bei geschlossenem Deckel grillen, für ein Rautenmuster um 45 Grad '
            'drehen und bei geschlossenem Deckel etwa 2 Minuten weitergrillen. Die Rückseite des Steaks '
            'auf die gleiche Weise grillen.',
        'Das gegrillte Steak wieder in die Teriyakisauce zurücklegen und auf dem Grill eine indirekte '
            'Zone einrichten. Einen Bratenkorb mittig auf den Grill legen, Steak hineinlegen und Deckel '
            'schließen. Nach 10 bis 15 Minuten Steak herausnehmen und kurz ruhen lassen.'
      ],
      stepImages: [
        [
          await saveStepImage(
              File('/storage/emulated/0/Download/recipeData/meat1.jpg'),
              'Steack mit Bratsauce',
              1)
        ],
        [
          await saveStepImage(
              File('/storage/emulated/0/Download/recipeData/meat2.jpg'),
              'Steack mit Bratsauce',
              2),
          await saveStepImage(
              File('/storage/emulated/0/Download/recipeData/meat3.jpg'),
              'Steack mit Bratsauce',
              2)
        ],
        []
      ],
      notes: 'Steak gegen die Faser in feine Tranchen schneiden.',
      isFavorite: false,
      categories: ['Hauptspeisen'],
    );
    await DBProvider.db.newRecipe(r1);
  }

  /// ONLY FOR DUMMY RECIPES, VERY TEMPORARY AND NOT NICE CODED
  /// TODO: Remove later
  Future<String> saveStepImage(
      File newImage, String recipeName, int stepNumber) async {
    String output;
    String newStepImageName = getStepImageName(newImage.path);
    String newStepImagePreviewName = 'p-' + newStepImageName;

    String stepImagePath = await PathProvider.pP
            .getRecipeStepNumberDir(recipeName, stepNumber + 1) +
        newStepImageName;
    output = stepImagePath;

    saveImage(
      newImage,
      stepImagePath,
      2000,
    );
    saveImage(
      newImage,
      recipeName,
      250,
    );
    return output;
  }

  // TODO: Remove later / Only for dummyRecipes
  String getStepImageName(String selectedImagePath) {
    Random random = new Random();
    int dotIndex = selectedImagePath.indexOf('.');
    String ending = selectedImagePath.substring(dotIndex);
    return random.nextInt(10000).toString() + ending;
  }

  Future<Recipe> saveRecipe(RecipeKeeper rKeeper) async {
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

    String imageDatatype;
    String recipeImage = selectedRecipeImage.selectedImage;
    if (recipeImage != null) {
      imageDatatype = recipeImage.substring(recipeImage.lastIndexOf('.'));
    }

    String recipeName = nameController.text;

    Recipe newRecipe = new Recipe(
      name: recipeName,
      imagePath: recipeImage != null
          ? PathProvider.pP.getRecipePath(nameController.text, imageDatatype)
          : "images/randomFood.png",

      /// imagePreviewPath: recipeImage != null
      ///     ? await PathProvider.pP.getRecipePreviewPathFull(recipeId)
      ///     : "images/randomFood.png",
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
      effort: complexity.myDouble.round(),
      categories: newRecipeCategories,
      isFavorite:
          widget.editRecipe == null ? false : widget.editRecipe.isFavorite,
    );
    await DBProvider.db.newRecipe(newRecipe);
    if (widget.editRecipe != null) {
      widget.editRecipe.setEqual(newRecipe);
      await DBProvider.db
          .updateFavorite(widget.editRecipe.isFavorite, recipeName);
    }

    Recipe thisRecipe = await DBProvider.db.getRecipeByName(recipeName, true);
    rKeeper.addRecipe(thisRecipe);
    return thisRecipe;
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
