import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:my_recipe_book/blocs/recipe_manager/recipe_manager.dart';
import 'package:my_recipe_book/widgets/dialogs/textfield_dialog.dart';

import '../../blocs/new_recipe/nutritions/nutritions.dart';
import '../../blocs/nutrition_manager/nutrition_manager.dart';
import '../../blocs/shopping_cart/shopping_cart.dart';
import '../../generated/i18n.dart';
import '../../models/nutrition.dart';
import '../../models/recipe.dart';
import '../../routes.dart';
import '../recipe_screen.dart';

/// arguments which are provided to the route, when pushing to it
class AddRecipeNutritionsArguments {
  final Recipe modifiedRecipe;
  final String editingRecipeName;

  AddRecipeNutritionsArguments(
    this.modifiedRecipe, {
    this.editingRecipeName,
  });
}

class AddRecipeNutritions extends StatefulWidget {
  final Recipe modifiedRecipe;
  final String editingRecipeName;

  AddRecipeNutritions({
    this.modifiedRecipe,
    this.editingRecipeName,
  });

  @override
  _AddRecipeNutritionsState createState() => _AddRecipeNutritionsState();
}

class _AddRecipeNutritionsState extends State<AddRecipeNutritions> {
  bool isInitialized = false;
  static final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  Map<String, TextEditingController> nutritionsController = {};
  List<Key> dismissibleKeys = [];
  List<Key> listTileKeys = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    for (String k in nutritionsController.keys) {
      nutritionsController[k].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NutritionManagerBloc, NutritionManagerState>(
      listener: (context, state) {
        if (state is LoadedNutritionManager) {
          if (!isInitialized) {
            _initializeData(state.nutritions);
          } else {
            if (state.nutritions.length > listTileKeys.length) {
              nutritionsController
                  .addAll({state.nutritions.last: TextEditingController()});
              listTileKeys.add(Key(state.nutritions.last));
              dismissibleKeys.add(Key('D-${state.nutritions.last}'));
            } else if (state.nutritions.length < listTileKeys.length) {
              nutritionsController.remove(state.nutritions.last);
              listTileKeys.removeLast();
              dismissibleKeys.removeLast();
            }
          }
        }
      },
      child: BlocBuilder<NutritionManagerBloc, NutritionManagerState>(
        builder: (context, state) {
          if (state is LoadingNutritionManager) {
            return _getNutritionManagerLoadingScreen();
          } else if (state is LoadedNutritionManager) {
            return Scaffold(
              appBar: AppBar(
                title: Text(S.of(context).add_nutritions),
                actions: <Widget>[
                  BlocListener<NutritionsBloc, NutritionsState>(
                    listener: (context, state) {
                      if (state is NEditingFinishedGoBack) {
                        // TODO: internationalize
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text('saving your input...')));
                      } else if (state is NSavedGoBack) {
                        Scaffold.of(context).hideCurrentSnackBar();
                        Navigator.popUntil(context,
                            ModalRoute.withName(RouteNames.recipeScreen));
                        Navigator.popAndPushNamed(
                          context,
                          RouteNames.recipeScreen,
                          arguments: RecipeScreenArguments(
                            BlocProvider.of<ShoppingCartBloc>(context),
                            widget.modifiedRecipe,
                            getRecipePrimaryColor(
                                widget.modifiedRecipe.vegetable),
                            'heroImageTag',
                          ),
                        );
                      } else if (state is NSaved) {
                        // TODO: differentiate between editing and new Recipe
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                        // Navigator.pushNamed(
                        //   context,
                        //   RouteNames.recipeScreen,
                        //   arguments: RecipeScreenArguments(
                        //     BlocProvider.of<ShoppingCartBloc>(context),
                        //     state.recipe,
                        //     getRecipePrimaryColor(
                        //         widget.modifiedRecipe.vegetable),
                        //     'heroImageTag',
                        //   ),
                        // );
                      }
                    },
                    child: BlocBuilder<NutritionsBloc, NutritionsState>(
                      builder: (context, state) {
                        if (state is NSavingTmpData) {
                          return Icon(
                            Icons.check,
                            color: Colors.grey,
                          );
                        } else if (state is NCanSave || state is NSaved) {
                          return IconButton(
                            icon: Icon(Icons.check),
                            color: Colors.white,
                            onPressed: () {
                              _finishedEditingNutritions(false);
                            },
                          );
                        } else if (state is NEditingFinished) {
                          return CircularProgressIndicator();
                        } else {
                          return Icon(Icons.check);
                        }
                      },
                    ),
                  )
                ],
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: Color(0xFF790604),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onPressed: () {
                  listTileKeys.add(Key('${listTileKeys.length}'));
                  dismissibleKeys.add(Key('D-${dismissibleKeys.length}'));
                  showDialog(
                    context: context,
                    builder: (_) => TextFieldDialog(
                      validation: (String name) {
                        if (state.nutritions.contains(name)) {
                          return 'nutrition already exists';
                        } else {
                          return null;
                        }
                      },
                      save: (String name) {
                        BlocProvider.of<NutritionManagerBloc>(context)
                            .add(AddNutrition(name));
                      },
                      hintText: 'nutrition name',
                    ),
                  );
                },
              ),
              body: state.nutritions.isEmpty
                  ? Center(
                      child: Text(S.of(context).you_have_no_nutritions),
                    )
                  : Form(
                      key: _formKey,
                      child: ReorderableListView(
                        onReorder: (oldIndex, newIndex) {
                          BlocProvider.of<NutritionManagerBloc>(context)
                              .add(MoveNutrition(oldIndex, newIndex));
                        },
                        children: List<Widget>.generate(
                          state.nutritions.length,
                          (i) => _getNutritionListTile(state.nutritions[i],
                              context, listTileKeys[i], state.nutritions),
                        ),
                      ),
                    ),
            );
          } else {
            return Text(state.toString());
          }
        },
      ),
    );
  }

  void _initializeData(List<String> nutritions) {
    for (String nutritionName in nutritions) {
      nutritionsController.addAll({nutritionName: TextEditingController()});
      dismissibleKeys.add(Key('D-$nutritionName'));
      listTileKeys.add(Key(nutritionName));
      for (Nutrition nutrition in widget.modifiedRecipe.nutritions) {
        if (nutrition.name == nutritionName) {
          nutritionsController[nutritionName].text = nutrition.amountUnit;
        }
      }
    }
  }

  Widget _getNutritionManagerLoadingScreen() {
    return Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).add_nutritions),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ));
  }

  Future<void> _finishedEditingNutritions(bool goBack) async {
    List<Nutrition> recipeNutritions = nutritionsController.keys
        .map((nutritionName) => nutritionsController[nutritionName].text == ''
            ? null
            : Nutrition(
                name: nutritionName,
                amountUnit: nutritionsController[nutritionName].text))
        .toList()
          ..removeWhere((item) => item == null);

    BlocProvider.of<NutritionsBloc>(context).add(
      FinishedEditing(
        widget.editingRecipeName,
        widget.editingRecipeName != null
            ? widget.modifiedRecipe.categories
            : goBack,
        recipeNutritions,
        BlocProvider.of<RecipeManagerBloc>(context),
      ),
    );
  }

  Widget _getNutritionListTile(String nutritionName, BuildContext context,
      Key key, List<String> nutritions) {
    return ListTile(
      key: key,
      title: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => TextFieldDialog(
              validation: (String name) {
                if (nutritions.contains(name)) {
                  return 'nutrition already exists';
                } else {
                  return null;
                }
              },
              save: (String name) {
                BlocProvider.of<NutritionManagerBloc>(context)
                    .add(UpdateNutrition(nutritionName, name));
              },
              hintText: 'nutrition name',
              prefilledText: nutritionName,
            ),
          );
        },
        child: Text(nutritionName),
      ),
      leading: Icon(Icons.reorder),
      trailing: Container(
        width: MediaQuery.of(context).size.width / 3 > 50
            ? 50
            : MediaQuery.of(context).size.width / 3,
        child: TextFormField(
          controller: nutritionsController[nutritionName],
        ),
      ),
    );
  }
}
