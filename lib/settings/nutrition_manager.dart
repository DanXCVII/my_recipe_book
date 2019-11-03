import 'dart:io';

import 'package:flutter/material.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_recipe_book/dialogs/add_nut_cat_dialog.dart';
import 'package:my_recipe_book/hive.dart';
import 'package:my_recipe_book/models/nutrition.dart';
import 'package:my_recipe_book/models/recipe.dart';
import 'package:my_recipe_book/io/io_operations.dart' as IO;
import 'package:my_recipe_book/models/recipe_keeper.dart';
import 'package:my_recipe_book/recipe_overview/recipe_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:my_recipe_book/generated/i18n.dart';
import 'package:hive/hive.dart';

import '../helper.dart';
import '../recipe.dart';

class NutritionManager extends StatefulWidget {
  final String editRecipeName;
  final Recipe newRecipe;

  NutritionManager({this.editRecipeName, this.newRecipe});

  @override
  _NutritionManagerState createState() => _NutritionManagerState();
}

class _NutritionManagerState extends State<NutritionManager> {
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
        if (widget.editRecipeName != null) {
          for (Nutrition en in widget.newRecipe.nutritions) {
            if (en.name.compareTo(currentNutrition) == 0) {
              nutritionsController[currentNutrition].text = en.amountUnit;
            }
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(widget.newRecipe == null
            ? S.of(context).manage_nutritions
            : S.of(context).add_nutritions),
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
            showDialog(context: context, builder: (_) => AddDialog(true));
          }),
      body: WatchBoxBuilder(
          box: Hive.box<List<String>>('order'),
          builder: (context, boxNutritions) {
            List<String> nutritions = boxNutritions.get('nutritions');

            if (nutritions.length > nutritionsController.keys.length) {
              String newNutrition = nutritions.last;
              nutritionsController
                  .addAll({newNutrition: TextEditingController()});
              dismissibleKeys.add(Key(newNutrition));
            }
            if (nutritions.isEmpty) {
              return Center(
                child: Text(S.of(context).you_have_no_nutritions),
              );
            } else {
              int i = -1;
              return Form(
                key: _formKey,
                child: ReorderableListView(
                  onReorder: (oldIndex, newIndex) {
                    moveNutrition(oldIndex, newIndex);
                  },
                  children: nutritions.map((currentNutrition) {
                    i++;
                    if (widget.newRecipe == null) {
                      return _getNutritionListTile(
                          currentNutrition, context, listTileKeys[i]);
                    } else {
                      return Dismissible(
                        key: dismissibleKeys[i],
                        background: _getPrimaryBackgroundDismissible(),
                        secondaryBackground:
                            _getSecondaryBackgroundDismissible(),
                        // confirmDismiss: (_) {
                        //   nutritionsController.remove(nutritionName);
                        //   rKeeper.removeNutrition(nutritionName);
                        // },
                        onDismissed: (_) {
                          nutritionsController.remove(currentNutrition);
                          deleteNutrition(currentNutrition);
                        },
                        child: _getNutritionListTile(
                            currentNutrition, context, listTileKeys[i]),
                      );
                    }
                  }).toList(),
                ),
              );
            }
          }),
    );
  }

  _showDeleteDialog(BuildContext context, String nutritionName) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(S.of(context).delete_nutrition),
        content: Text(S.of(context).sure_you_want_to_delete_this_nutrition +
            " $nutritionName"),
        actions: <Widget>[
          FlatButton(
            child: Text(S.of(context).no),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            textColor: Theme.of(context).textTheme.body1.color,
            onPressed: () {
              Navigator.pop(context, false);
              return false;
            },
          ),
          FlatButton(
            child: Text(S.of(context).yes),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            textColor: Theme.of(context).textTheme.body1.color,
            color: Colors.red[600],
            onPressed: () {
              deleteNutrition(nutritionName);
              nutritionsController.remove(nutritionName);
              Navigator.pop(context, true);
              return true;
            },
          ),
        ],
      ),
    ).then((boo) => boo);
  }

  Future<void> editingFinished() async {
    // if not editing recipe and just managing nutritions
    if (widget.newRecipe == null) {
      Navigator.pop(context);
    } // if editing recipe
    else {
      _addNutritionsToRecipe();
      await _correctImagesPaths();
      await _saveData();

      if (widget.editRecipeName != null) {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => RecipeScreen(
              recipe: widget.newRecipe,
              primaryColor: getRecipePrimaryColor(widget.newRecipe.vegetable),
              heroImageTag: 'heroImageTag',
            ),
          ),
        );
      } else {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    }
  }

  Future<void> _saveData() async {
    String oldRecipeImageName = widget.editRecipeName == null
        ? 'tmp'
        : getUnderscoreName(widget.editRecipeName);

    Recipe fullImagePathRecipe;

    // If editing recipe
    if (widget.editRecipeName != null) {
      bool hasFiles =
          Directory(await PathProvider.pP.getRecipeDir(widget.editRecipeName))
              .existsSync();

      // if an image exists and the recipename changed
      if (hasFiles && widget.editRecipeName != widget.newRecipe.name) {
        await IO.copyRecipeDataToNewPath(
            widget.editRecipeName, widget.newRecipe.name);
        _saveToHive();
        await Directory(await PathProvider.pP.getRecipeDir(oldRecipeImageName))
            .delete(recursive: true);
        return;
      } // if no image exist
      else {
        _saveToHive();
      }
    } // if adding new recipe
    else {
      // if we added images
      if (_hasRecipeImage(widget.newRecipe)) {
        await IO.copyRecipeDataToNewPath(
          oldRecipeImageName,
          widget.newRecipe.name,
          // fileExtension: widget.newRecipe.imagePath != null
          //     ? getImageDatatype(widget.newRecipe.imagePath)
          //     : null,
        );
        _saveToHive();

        await Directory(await PathProvider.pP.getRecipeDir(oldRecipeImageName))
            .delete(recursive: true);
      } // if we didn't add images
      else {
        _saveToHive();
      }
    }

    imageCache.clear();
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

  void _addNutritionsToRecipe() {
    List<Nutrition> recipeNutritions = [];
    for (String n in nutritionsController.keys) {
      String amountUnit = nutritionsController[n].text;
      if (amountUnit != null && amountUnit != '') {
        recipeNutritions
            .add(Nutrition(name: n, amountUnit: nutritionsController[n].text));
      }
    }
    widget.newRecipe.nutritions = recipeNutritions;
  }

  Future<void> _saveToHive() async {
    // IF EDITING RECIPE
    if (widget.editRecipeName != null) {
      modifyRecipe(widget.editRecipeName, widget.newRecipe);
    } // IF ADDING NEW RECIPE
    else {
      saveRecipe(widget.newRecipe);
    }
  }

  Future<void> _correctImagesPaths() async {
    String appDirPath = (await getApplicationDocumentsDirectory()).path;
    if (widget.newRecipe.imagePath != 'images/randomFood.jpg') {
      String dataType = getImageDatatype(widget.newRecipe.imagePath);
      widget.newRecipe.imagePath = await PathProvider.pP
          .getRecipePathFull(widget.newRecipe.name, dataType);
      widget.newRecipe.imagePreviewPath = await PathProvider.pP
          .getRecipePreviewPathFull(widget.newRecipe.name, dataType);
    } else {
      widget.newRecipe.imagePreviewPath = 'images/randomFood.jpg';
    }

    // for (int i = 0; i < widget.newRecipe.steps.length; i++) {
    //   for (int j = 0; j < widget.newRecipe.stepImages[i].length; j++) {
    //     widget.newRecipe.stepImages[i][j] =
    //         appDirPath + widget.newRecipe.stepImages[i][j];
    //   }
    // }
  }

  Widget _getPrimaryBackgroundDismissible() {
    return Container(
      color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Icon(
              GroovinMaterialIcons.delete_sweep,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  Widget _getSecondaryBackgroundDismissible() {
    return Container(
      color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(
              GroovinMaterialIcons.delete_sweep,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  Widget _getNutritionListTile(
      String nutritionName, BuildContext context, Key key) {
    return ListTile(
      key: key,
      title: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => AddDialog(
              true,
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
        child: widget.newRecipe != null
            ? TextFormField(
                controller: nutritionsController[nutritionName],
              )
            : IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _showDeleteDialog(context, nutritionName);
                },
              ),
      ),
    );
  }
}
