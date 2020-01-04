import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../../blocs/new_recipe/nutritions/nutritions.dart';
import '../../blocs/nutrition_manager/nutrition_manager.dart';
import '../../blocs/shopping_cart/shopping_cart.dart';
import '../../dialogs/add_nut_cat_dialog.dart';
import '../../generated/i18n.dart';
import '../../models/nutrition.dart';
import '../../models/recipe.dart';
import '../../recipe_overview/recipe_screen.dart';
import '../../routes.dart';

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
  static final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  Map<String, TextEditingController> nutritionsController = {};
  List<Key> dismissibleKeys = [];
  List<Key> listTileKeys = [];
  Box<List<String>> boxNutritions;

  @override
  void initState() {
    super.initState();
    boxNutritions = Hive.box<List<String>>('order');
    List<String> nutritions = boxNutritions.get('nutritions');

    if (nutritions.isNotEmpty) {
      for (int i = 0; i < nutritions.length; i++) {
        String currentNutrition = nutritions[i];

        nutritionsController
            .addAll({currentNutrition: TextEditingController()});
        for (Nutrition en in widget.modifiedRecipe.nutritions) {
          if (en.name.compareTo(currentNutrition) == 0) {
            nutritionsController[currentNutrition].text = en.amountUnit;
          }
        }
        dismissibleKeys.add(Key('D-$currentNutrition'));
        listTileKeys.add(Key(currentNutrition));
      }
    }
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
    return BlocBuilder<NutritionManagerBloc, NutritionManagerState>(
      builder: (context, state) {
        if (state is LoadingNutritionManager) {
          return _getNutritionManagerLoadingScreen();
        } else if (state is LoadedNutritionManager) {
          int i = -1;

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
                    } else if (state is NSaved) {
                      // TODO: differentiate between editing and new Recipe
                      Navigator.popUntil(context,
                          ModalRoute.withName(RouteNames.loadingScreen));
                      Navigator.popAndPushNamed(
                        context,
                        RouteNames.recipeScreen,
                        arguments: RecipeScreenArguments(
                          BlocProvider.of<ShoppingCartBloc>(context),
                          state.recipe,
                          getRecipePrimaryColor(
                              widget.modifiedRecipe.vegetable),
                          'heroImageTag',
                        ),
                      );
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
                      children: state.nutritions.map((currentNutrition) {
                        i++;

                        return _getNutritionListTile(currentNutrition, context,
                            listTileKeys[i], state.nutritions);
                      }).toList(),
                    ),
                  ),
          );
        } else {
          return Text(state.toString());
        }
      },
    );
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
      ),
    );

    if (widget.editingRecipeName != null) {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);

      Navigator.popAndPushNamed(
        context,
        RouteNames.recipeScreen,
        arguments: RecipeScreenArguments(
          BlocProvider.of<ShoppingCartBloc>(context),
          widget.modifiedRecipe,
          getRecipePrimaryColor(widget.modifiedRecipe.vegetable),
          'heroImageTag',
        ),
      );
    } else {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
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
