import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:my_recipe_book/blocs/recipe_calendar/recipe_calendar_bloc.dart';

import '../../../blocs/new_recipe/steps/steps_bloc.dart';
import '../../../blocs/shopping_cart/shopping_cart_bloc.dart';
import '../../../constants/routes.dart';
import '../../../generated/i18n.dart';
import '../../../models/recipe.dart';
import '../../../util/helper.dart';
import '../../../util/my_wrapper.dart';
import '../../../widgets/complexity_section.dart';
import '../nutritions.dart';
import 'steps_section.dart';

/// arguments which are provided to the route, when pushing to it
class StepsArguments {
  final Recipe modifiedRecipe;
  final String editingRecipeName;
  final ShoppingCartBloc shoppingCartBloc;
  final RecipeCalendarBloc recipeCalendarBloc;

  StepsArguments(
    this.modifiedRecipe,
    this.shoppingCartBloc,
    this.recipeCalendarBloc, {
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

class _StepsScreenState extends State<StepsScreen> with WidgetsBindingObserver {
  final List<TextEditingController> stepsDescController = [];
  final List<String> stepTitles = [];
  final TextEditingController notesController = TextEditingController();

  final MyDoubleWrapper complexity = MyDoubleWrapper(myDouble: 5.0);
  Flushbar _flush;
  FocusNode _focusNode = FocusNode();
  FocusNode _exitFocusNode;

  static GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    stepsDescController.add(TextEditingController());

    _initializeData(widget.modifiedRecipe);
  }

  @override
  void dispose() {
    stepsDescController.forEach((controller) {
      controller.dispose();
    });
    notesController.dispose();
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _exitFocusNode = FocusScope.of(context).focusedChild;
      FocusScope.of(context).requestFocus(_focusNode);
    } else if (state == AppLifecycleState.resumed) {
      FocusScope.of(context).requestFocus(_exitFocusNode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _finishedEditingSteps(true);
        return false;
      },
      child: Scaffold(
        appBar: GradientAppBar(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: [Color(0xffAF1E1E), Color(0xff641414)],
          ),
          title: Text(I18n.of(context).add_steps),
          actions: <Widget>[
            BlocListener<StepsBloc, StepsState>(
              listener: (context, state) {
                if (state is SEditingFinishedGoBack) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(I18n.of(context).saving_your_input)));
                } else if (state is SSaved) {
                  BlocProvider.of<StepsBloc>(context).add(SetCanSave());

                  Navigator.pushNamed(
                    context,
                    RouteNames.addRecipeNutritions,
                    arguments: AddRecipeNutritionsArguments(
                      state.recipe,
                      BlocProvider.of<ShoppingCartBloc>(context),
                      BlocProvider.of<RecipeCalendarBloc>(context),
                      editingRecipeName: widget.editingRecipeName,
                    ),
                  );
                } else if (state is SSavedGoBack) {
                  Scaffold.of(context).hideCurrentSnackBar();
                  Navigator.pop(context);
                } else if (state is SCanSave && state.isValid == false) {
                  _showFlushInfo(
                    I18n.of(context).too_many_images_for_the_steps,
                    I18n.of(context).too_many_images_for_the_steps_description,
                  );
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
                        FocusScope.of(context).requestFocus(FocusNode());

                        _finishedEditingSteps(false);
                      },
                    );
                  } else if (state is SEditingFinished) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                            width: 25,
                            height: 25,
                            child: CircularProgressIndicator()),
                      ),
                    );
                  } else {
                    return Icon(Icons.arrow_forward);
                  }
                },
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width > 500 ? 500 : null,
              child: Column(
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: widget.editingRecipeName != null
                        ? Steps(
                            stepsDescController,
                            stepTitles,
                            editRecipeName: widget.editingRecipeName,
                          )
                        : Steps(
                            stepsDescController,
                            stepTitles,
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 12, top: 12, left: 18, bottom: 12),
                    child: TextField(
                      controller: notesController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        labelText: I18n.of(context).notes,
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
        ),
      ),
    );
  }

  void _showFlushInfo(String title, String body) {
    if (_flush != null && _flush.isShowing()) {
    } else {
      _flush = Flushbar<bool>(
        animationDuration: Duration(milliseconds: 300),
        leftBarIndicatorColor: Colors.blue[300],
        title: title,
        message: body,
        icon: Icon(
          Icons.info_outline,
          color: Colors.blue,
        ),
        mainButton: FlatButton(
          onPressed: () {
            _flush.dismiss(true); // result = true
          },
          child: Text(
            "OK",
            style: TextStyle(color: Colors.amber),
          ),
        ),
      ) // <bool> is the type of the result passed to dismiss() and collected by show().then((result){})
        ..show(context).then((result) {});
    }
  }

  void _finishedEditingSteps(bool goBack) {
    if (goBack) {
      BlocProvider.of<StepsBloc>(context).add(
        FinishedEditing(
          widget.editingRecipeName == null ? false : true,
          goBack,
          complexity.myDouble.round(),
          notesController.text,
          trimRemoveTrailingEmptyStrings(
              stepsDescController.map((item) => item.text).toList()),
          stepTitles,
        ),
      );
    } else {
      BlocProvider.of<StepsBloc>(context).add(
        FinishedEditing(
          widget.editingRecipeName == null ? false : true,
          goBack,
          complexity.myDouble.round(),
          notesController.text,
          trimRemoveTrailingEmptyStrings(
              stepsDescController.map((item) => item.text).toList()),
          stepTitles,
        ),
      );
    }
  }

  /// prefills the textfields with the data of the given recipe
  void _initializeData(Recipe recipe) {
    if (widget.modifiedRecipe.notes != null)
      notesController.text = widget.modifiedRecipe.notes;

    // case new recipe with no steps
    if (widget.modifiedRecipe.steps.isEmpty) {
      stepTitles.add("");
    } // case already steps added
    else {
      // case the recipe is an old recipe where the stepTitles are null
      if (widget.modifiedRecipe.stepTitles == null) {
        stepTitles.addAll(widget.modifiedRecipe.steps.map<String>((e) => ""));
      } // case the recipe already has stepTitles, which can be used
      else {
        stepTitles.addAll(widget.modifiedRecipe.stepTitles);
      }
    }

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
