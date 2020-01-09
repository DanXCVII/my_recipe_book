import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_recipe_book/dialogs/info_dialog.dart';

import '../../../blocs/new_recipe/steps/steps.dart';
import '../../../blocs/new_recipe/steps/steps_bloc.dart';
import '../../../blocs/new_recipe/steps/steps_state.dart';
import '../../../generated/i18n.dart';
import '../../../helper.dart';
import '../../../models/recipe.dart';
import '../../../my_wrapper.dart';
import '../../../routes.dart';
import '../../../widgets/complexity_section.dart';
import '../nutritions.dart';
import 'steps_section.dart';

/// arguments which are provided to the route, when pushing to it
class StepsArguments {
  final Recipe modifiedRecipe;
  final String editingRecipeName;

  StepsArguments(
    this.modifiedRecipe, {
    this.editingRecipeName,
  });
}

class StepsScreen extends StatefulWidget {
  final Recipe modifiedRecipe;
  final String editingRecipeName;

  StepsScreen({
    this.modifiedRecipe,
    this.editingRecipeName,
    Key key,
  }) : super(key: key);

  _StepsScreenState createState() => _StepsScreenState();
}

class _StepsScreenState extends State<StepsScreen> {
  final List<TextEditingController> stepsDescController = [];
  final TextEditingController notesController = TextEditingController();

  final MyDoubleWrapper complexity = MyDoubleWrapper(myDouble: 5.0);

  static GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    stepsDescController.add(TextEditingController());

    _initializeData(widget.modifiedRecipe);
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
    return WillPopScope(
      onWillPop: () async {
        _finishedEditingSteps(true);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("add steps"),
          actions: <Widget>[
            BlocListener<StepsBloc, StepsState>(
              listener: (context, state) {
                if (state is SEditingFinishedGoBack) {
                  // TODO: internationalize
                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text('saving your input...')));
                } else if (state is SSaved) {
                  BlocProvider.of<StepsBloc>(context).add(SetCanSave());

                  Navigator.pushNamed(
                    context,
                    RouteNames.addRecipeNutritions,
                    arguments: AddRecipeNutritionsArguments(
                      state.recipe,
                      editingRecipeName: widget.editingRecipeName,
                    ),
                  );
                } else if (state is SSavedGoBack) {
                  Scaffold.of(context).hideCurrentSnackBar();
                  Navigator.pop(context);
                } else if (state is SCanSave && state.isValid == false) {
                  showDialog(
                      context: context,
                      builder: (_) => InfoDialog(
                          title: "too many images for the steps", body: "lol"));
                }
              },
              child: BlocBuilder<StepsBloc, StepsState>(
                builder: (context, state) {
                  if (state is SSavingTmpData) {
                    return Icon(
                      Icons.arrow_forward,
                      color: Colors.grey,
                    );
                  } else if (state is SCanSave) {
                    return IconButton(
                      icon: Icon(Icons.arrow_forward),
                      color: Colors.white,
                      onPressed: () {
                        _finishedEditingSteps(false);
                      },
                    );
                  } else if (state is SEditingFinished) {
                    return CircularProgressIndicator();
                  } else {
                    return Icon(Icons.arrow_forward);
                  }
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
                child: widget.editingRecipeName != null
                    ? Steps(
                        stepsDescController,
                        editRecipeName: widget.editingRecipeName,
                      )
                    : Steps(
                        stepsDescController,
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
      ),
    );
  }

  void _finishedEditingSteps(bool goBack) {
    if (goBack)
      BlocProvider.of<StepsBloc>(context).add(
        FinishedEditing(
          widget.editingRecipeName == null ? false : true,
          goBack,
          complexity.myDouble.round(),
          notesController.text,
          removeTrailingEmptyStrings(
              stepsDescController.map((item) => item.text).toList()),
        ),
      );
    else {
      BlocProvider.of<StepsBloc>(context).add(
        FinishedEditing(
          widget.editingRecipeName == null ? false : true,
          goBack,
          complexity.myDouble.round(),
          notesController.text,
          removeTrailingEmptyStrings(
              stepsDescController.map((item) => item.text).toList()),
        ),
      );
    }
  }

  /// prefills the textfields with the data of the given recipe
  void _initializeData(Recipe recipe) {
    if (widget.modifiedRecipe.notes != null)
      notesController.text = widget.modifiedRecipe.notes;

    if (widget.modifiedRecipe.effort != null)
      complexity.myDouble = widget.modifiedRecipe.effort.toDouble();

    if (widget.modifiedRecipe.steps != null)
      for (int i = 0; i < widget.modifiedRecipe.steps.length; i++) {
        if (i > 0) {
          stepsDescController.add(TextEditingController());
        }

        stepsDescController[i].text = widget.modifiedRecipe.steps[i];
      }
  }
}
