import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_recipe_book/generated/i18n.dart';
import 'package:my_recipe_book/models/recipe.dart';
import 'package:my_recipe_book/models/recipe_keeper.dart';
import 'package:my_recipe_book/io/io_operations.dart' as IO;
import 'package:my_recipe_book/recipe.dart';
import 'package:my_recipe_book/settings/nutrition_manager.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:hive/hive.dart';

import '../../../helper.dart';
import '../../../my_wrapper.dart';
import '../complexity_section.dart';
import '../steps_section.dart';

class StepsScreen extends StatefulWidget {
  final Recipe newRecipe;
  final bool editingRecipe;
  final Recipe editRecipe;

  StepsScreen({
    this.newRecipe,
    this.editingRecipe,
    this.editRecipe,
    Key key,
  }) : super(key: key);

  _StepsScreenState createState() => _StepsScreenState();
}

class _StepsScreenState extends State<StepsScreen> {
  final List<List<String>> stepImages = [[]];
  final List<TextEditingController> stepsDescController = [];
  final TextEditingController notesController = TextEditingController();

  final MyDoubleWrapper complexity = MyDoubleWrapper(myDouble: 5.0);

  static GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    stepsDescController.add(TextEditingController());

    if (widget.newRecipe.notes != null)
      notesController.text = widget.newRecipe.notes;

    if (widget.newRecipe.effort != null)
      complexity.myDouble = widget.newRecipe.effort.toDouble();

    if (widget.newRecipe.steps != null)
      for (int i = 0; i < widget.newRecipe.steps.length; i++) {
        if (i > 0) {
          stepsDescController.add(TextEditingController());
          stepImages.add([]);
        }
        stepsDescController[i].text = widget.newRecipe.steps[i];

        if (widget.editingRecipe)
          for (int j = 0; j < widget.newRecipe.stepImages[i].length; j++) {
            stepImages[i].add(widget.newRecipe.stepImages[i][j]);
          }
      }
  }

  @override
  void dispose() {
    stepsDescController.forEach((controller) {
      controller.dispose();
    });
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("add steps"),
        actions: <Widget>[
          ScopedModelDescendant<RecipeKeeper>(
            builder: (context, child, rKeeper) => IconButton(
              icon: Icon(Icons.check),
              color: Colors.white,
              onPressed: () {
                _finishedEditingRecipe(rKeeper);
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Form(
              key: _formKey,
              child: widget.editingRecipe
                  ? Steps(
                      stepsDescController,
                      stepImages,
                      editRecipeName: widget.editRecipe.name,
                    )
                  : Steps(
                      stepsDescController,
                      stepImages,
                    ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  right: 12, top: 12, left: 18, bottom: 12),
              child: TextField(
                controller: notesController,
                decoration: InputDecoration(
                  labelText: S.of(context).notes,
                  filled: true,
                  icon: Icon(Icons.assignment),
                ),
                minLines: 3,
                maxLines: 10,
              ),
            ),
            ComplexitySection(complexity: complexity),
          ],
        ),
      ),
    );
  }

  void _finishedEditingRecipe(RecipeKeeper rKeeper) {
    String oldRecipeImageName = !widget.editingRecipe
        ? 'tmp'
        : getUnderscoreName(widget.editRecipe.name);

    // modifying the stepImages paths for the database
    for (int i = 0; i < stepImages.length; i++) {
      for (int j = 0; j < stepImages[i].length; j++) {
        stepImages[i][j] = stepImages[i][j].replaceFirst(
            '/$oldRecipeImageName/',
            '/${getUnderscoreName(widget.newRecipe.name)}/');
      }
    }

    widget.newRecipe.steps = removeEmptyStrings(stepsDescController);
    widget.newRecipe.stepImages = stepImages;
    widget.newRecipe.notes = notesController.text;
    widget.newRecipe.effort = complexity.myDouble.round();

    saveRecipe(rKeeper).then((recipe) {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => WillPopScope(
            onWillPop: () async {
              Navigator.of(context).popUntil((route) => route.isFirst);
              rKeeper.currentlyEditedRecipe =
                  Recipe(servings: null, name: null, vegetable: null);
              return false;
            },
            child: NutritionManager(
              widget.editingRecipe,
              editRecipeNutritions: widget.newRecipe.nutritions,
              nutritions: rKeeper.nutritions,
              recipeName: widget.newRecipe.name,
            ),
          ),
        ),
      );
    });
  }

  Future<Recipe> saveRecipe(RecipeKeeper rKeeper) async {
    String oldRecipeImageName = !widget.editingRecipe
        ? 'tmp'
        : getUnderscoreName(widget.editRecipe.name);

    Recipe fullImagePathRecipe;
    if (widget.editingRecipe) {
      fullImagePathRecipe = await rKeeper.modifyRecipe(
        widget.editRecipe.name,
        widget.newRecipe,
        false,
      );
    } else {
      if (_hasRecipeImage(widget.newRecipe)) {
        await IO.renameRecipeData(
          oldRecipeImageName,
          widget.newRecipe.name,
          fileExtension: widget.newRecipe.imagePath != null
              ? getImageDatatype(widget.newRecipe.imagePath)
              : null,
        );
        widget.newRecipe.imagePath = PathProvider.pP.getRecipePath(
            widget.newRecipe.name,
            getImageDatatype(widget.newRecipe.imagePath));
      }
      var boxRecipes = Hive.box<Recipe>('recipes');
      boxRecipes.add(widget.newRecipe);
      if (boxRecipes.containsKey('${widget.newRecipe.name}')) {
        boxRecipes.delete('${widget.newRecipe.name}');
      }
      fullImagePathRecipe = await rKeeper.addRecipe(widget.newRecipe, false);
    }
    imageCache.clear();

    return fullImagePathRecipe;
  }
}

bool _hasRecipeImage(Recipe recipe) {
  if (recipe.imagePath != "images/randomFood.jpg") {
    return true;
  }
  for (List<String> l in recipe.stepImages) {
    if (l.isNotEmpty) {
      return true;
    }
  }
  return false;
}
