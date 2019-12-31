import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:my_recipe_book/blocs/shopping_cart/shopping_cart.dart';
import 'package:path_provider/path_provider.dart';

import '../blocs/add_recipe/add_recipe.dart';
import '../blocs/nutrition_manager/nutrition_manager.dart';
import '../dialogs/add_nut_cat_dialog.dart';
import '../generated/i18n.dart';
import '../helper.dart';
import '../models/nutrition.dart';
import '../models/recipe.dart';
import '../recipe.dart';
import '../recipe_overview/recipe_screen.dart';
import '../routes.dart';

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
                IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () {
                    editingFinished();
                  },
                ),
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
                      builder: (_) => AddDialog(
                            true,
                            state.nutritions,
                            nutritionManagerBloc:
                                BlocProvider.of<NutritionManagerBloc>(context),
                          ));
                }),
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

  Future<void> editingFinished() async {
    final Recipe recipeNutrition =
        _addNutritionsToRecipe(widget.modifiedRecipe);
    final Recipe recipeFinal = await _correctImagesPaths(recipeNutrition);
    if (widget.modifiedRecipe == null) {
      BlocProvider.of<AddRecipeBloc>(context).add(SaveNewRecipe(recipeFinal));
    } else {
      BlocProvider.of<AddRecipeBloc>(context)
          .add(ModifyRecipe(recipeFinal, widget.modifiedRecipe));
    }

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

  Recipe _addNutritionsToRecipe(Recipe recipe) {
    List<Nutrition> recipeNutritions = [];
    for (String n in nutritionsController.keys) {
      String amountUnit = nutritionsController[n].text;
      if (amountUnit != null && amountUnit != '') {
        recipeNutritions
            .add(Nutrition(name: n, amountUnit: nutritionsController[n].text));
      }
    }

    return recipe.copyWith(nutritions: recipeNutritions);
  }

  Future<Recipe> _correctImagesPaths(Recipe recipe) async {
    String appDirPath = (await getApplicationDocumentsDirectory()).path;

    String imagePath;
    String imagePreviewPath;

    if (recipe.imagePath != 'images/randomFood.jpg') {
      String dataType = getImageDatatype(recipe.imagePath);
      imagePath =
          await PathProvider.pP.getRecipePathFull(recipe.name, dataType);
      imagePreviewPath =
          await PathProvider.pP.getRecipePreviewPathFull(recipe.name, dataType);
    } else {
      imagePreviewPath = 'images/randomFood.jpg';
    }

    List<List<String>> stepImages = recipe.stepImages;

    for (int i = 0; i < recipe.steps.length; i++) {
      for (int j = 0; j < recipe.stepImages[i].length; j++) {
        stepImages[i][j] = appDirPath + recipe.stepImages[i][j];
      }
    }

    return recipe.copyWith(
      imagePath: imagePath,
      imagePreviewPath: imagePreviewPath,
      stepImages: stepImages,
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
            builder: (_) => AddDialog(
              true,
              nutritions,
              nutritionManagerBloc:
                  BlocProvider.of<NutritionManagerBloc>(context),
              modifiedItem: nutritionName,
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
