import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/add_recipe/add_recipe.dart';
import '../../../blocs/nutrition_manager/nutrition_manager.dart';
import '../../../blocs/nutrition_manager/nutrition_manager_bloc.dart';
import '../../../generated/i18n.dart';
import '../../../helper.dart';
import '../../../models/recipe.dart';
import '../../../my_wrapper.dart';
import '../../../screens/add_nutrition.dart';
import '../complexity_section.dart';
import '../steps_section.dart';

class StepsScreen extends StatefulWidget {
  final Recipe recipe;
  final Recipe editRecipe;

  StepsScreen({
    this.recipe,
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

    if (widget.recipe.notes != null) notesController.text = widget.recipe.notes;

    if (widget.recipe.effort != null)
      complexity.myDouble = widget.recipe.effort.toDouble();

    if (widget.recipe.steps != null)
      for (int i = 0; i < widget.recipe.steps.length; i++) {
        if (i > 0) {
          stepsDescController.add(TextEditingController());
          stepImages.add([]);
        }
        stepsDescController[i].text = widget.recipe.steps[i];

        if (widget.editRecipe != null)
          for (int j = 0; j < widget.recipe.stepImages[i].length; j++) {
            stepImages[i].add(widget.recipe.stepImages[i][j]);
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
          IconButton(
            icon: Icon(Icons.check),
            color: Colors.white,
            onPressed: () {
              _finishedEditingRecipe(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Form(
              key: _formKey,
              child: widget.editRecipe != null
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

  void _finishedEditingRecipe(BuildContext stepsScreenContext) {
    String oldRecipeImageName = widget.editRecipe == null
        ? 'tmp'
        : getUnderscoreName(widget.editRecipe.name);

    // modifying the stepImages paths for the database
    for (int i = 0; i < stepImages.length; i++) {
      for (int j = 0; j < stepImages[i].length; j++) {
        stepImages[i][j] = stepImages[i][j].replaceFirst(
            '/$oldRecipeImageName/',
            '/${getUnderscoreName(widget.recipe.name)}/');
      }
    }

    Recipe newRecipe = widget.recipe.copyWith(
      steps: removeEmptyStrings(stepsDescController),
      stepImages: stepImages,
      notes: notesController.text,
      effort: complexity.myDouble.round(),
    );

    if (widget.editRecipe != null) {
      BlocProvider.of<AddRecipeBloc>(context)
          .add(SaveTemporaryRecipeData(newRecipe));
    }

    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => BlocProvider<AddRecipeBloc>(
          builder: (context) =>
              BlocProvider.of<AddRecipeBloc>(stepsScreenContext),
          child: BlocProvider<NutritionManagerBloc>(
            builder: (context) =>
                NutritionManagerBloc()..add(LoadNutritionManager()),
            child: AddRecipeNutritions(
              newRecipe: newRecipe,
              editRecipe: widget.editRecipe,
            ),
          ),
        ),
      ),
    );
  }
}
