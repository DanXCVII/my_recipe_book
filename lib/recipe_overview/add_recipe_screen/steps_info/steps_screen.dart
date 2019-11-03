import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_recipe_book/generated/i18n.dart';
import 'package:my_recipe_book/models/recipe.dart';
import 'package:my_recipe_book/models/recipe_keeper.dart';
import 'package:my_recipe_book/io/io_operations.dart' as IO;
import 'package:my_recipe_book/recipe.dart';
import 'package:my_recipe_book/settings/nutrition_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:hive/hive.dart';

import '../../../helper.dart';
import '../../../my_wrapper.dart';
import '../complexity_section.dart';
import '../steps_section.dart';

class StepsScreen extends StatefulWidget {
  final Recipe newRecipe;
  final String editRecipeName;

  StepsScreen({
    this.newRecipe,
    this.editRecipeName,
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

        if (widget.editRecipeName != null)
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
              child: widget.editRecipeName != null
                  ? Steps(
                      stepsDescController,
                      stepImages,
                      editRecipeName: widget.editRecipeName,
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
    String oldRecipeImageName = widget.editRecipeName == null
        ? 'tmp'
        : getUnderscoreName(widget.editRecipeName);

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

    Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => NutritionManager(
            newRecipe: widget.newRecipe,
            editRecipeName: widget.editRecipeName,
          ),
        ));
  }
}
