import 'package:flutter/material.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:my_recipe_book/dialogs/add_nut_cat_dialog.dart';
import 'package:my_recipe_book/models/recipe.dart';
import 'package:my_recipe_book/models/recipe_keeper.dart';
import 'package:my_recipe_book/recipe_overview/recipe_screen.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:my_recipe_book/generated/i18n.dart';

class NutritionManager extends StatefulWidget {
  final List<String> nutritions;
  final bool editRecipe;
  final List<Nutrition> editRecipeNutritions;
  final String recipeName;

  NutritionManager(
    this.editRecipe, {
    this.nutritions,
    this.editRecipeNutritions,
    this.recipeName,
  });

  @override
  _NutritionManagerState createState() => _NutritionManagerState();
}

class _NutritionManagerState extends State<NutritionManager> {
  static final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  Map<String, TextEditingController> nutritionsController = {};
  List<Key> dismissibleKeys = [];
  List<Key> listTileKeys = [];

  @override
  void initState() {
    super.initState();
    if (widget.nutritions != null) {
      for (String n in widget.nutritions) {
        nutritionsController.addAll({n: TextEditingController()});
        if (widget.editRecipe) {
          for (Nutrition en in widget.editRecipeNutritions) {
            if (en.name.compareTo(n) == 0) {
              nutritionsController[n].text = en.amountUnit;
            }
          }
        }
        dismissibleKeys.add(Key('D-$n'));
        listTileKeys.add(Key(n));
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
        title: Text(widget.recipeName == null
            ? S.of(context).manage_nutritions
            : S.of(context).add_nutritions),
        actions: <Widget>[
          ScopedModelDescendant<RecipeKeeper>(
            builder: (context, child, rKeeper) => IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                editingFinished(rKeeper);
              },
            ),
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
      body: ScopedModelDescendant<RecipeKeeper>(
          builder: (context, child, rKeeper) {
        if (rKeeper.nutritions.length != nutritionsController.keys.length) {
          nutritionsController
              .addAll({rKeeper.nutritions.last: TextEditingController()});
          dismissibleKeys.add(Key(rKeeper.nutritions.last));
        }
        if (rKeeper.nutritions.isEmpty) {
          return Center(
            child: Text(S.of(context).you_have_no_nutritions),
          );
        } else {
          int i = -1;
          return Form(
            key: _formKey,
            child: ReorderableListView(
              onReorder: (oldIndex, newIndex) {
                rKeeper.moveNutrition(oldIndex, newIndex);
              },
              children: rKeeper.nutritions.map((nutritionName) {
                i++;
                if (widget.recipeName == null) {
                  return _getNutritionListTile(
                      nutritionName, context, rKeeper, listTileKeys[i]);
                } else {
                  return Dismissible(
                    key: dismissibleKeys[i],
                    background: _getPrimaryBackgroundDismissible(),
                    secondaryBackground: _getSecondaryBackgroundDismissible(),
                    // confirmDismiss: (_) {
                    //   nutritionsController.remove(nutritionName);
                    //   rKeeper.removeNutrition(nutritionName);
                    // },
                    onDismissed: (_) {
                      nutritionsController.remove(nutritionName);
                      rKeeper.removeNutrition(nutritionName);
                    },
                    child: _getNutritionListTile(
                        nutritionName, context, rKeeper, listTileKeys[i]),
                  );
                }
              }).toList(),
            ),
          );
        }
      }),
    );
  }

  _showDeleteDialog(
      BuildContext context, String nutritionName, bool removeFromList) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Text(S.of(context).sure_you_want_to_delete_this_nutrition +
            " $nutritionName"),
        actions: <Widget>[
          FlatButton(
            child: Text(S.of(context).no),
            onPressed: () {
              Navigator.pop(context, false);
              return false;
            },
          ),
          ScopedModelDescendant<RecipeKeeper>(
            builder: (context, child, rKeeper) => FlatButton(
              child: Text(S.of(context).yes),
              onPressed: () {
                if (removeFromList) {
                  nutritionsController.remove(nutritionName);
                  rKeeper.removeNutrition(nutritionName);
                }
                Navigator.pop(context, true);
                return true;
              },
            ),
          )
        ],
      ),
    ).then((boo) => boo);
  }

  void editingFinished(RecipeKeeper rKeeper) {
    if (widget.recipeName == null) {
      rKeeper.updateNutritionOrder(rKeeper.nutritions).then((_) {
        Navigator.pop(context);
      });
    } else {
      List<Nutrition> recipeNutritions = [];
      for (String n in nutritionsController.keys) {
        String amountUnit = nutritionsController[n].text;
        if (amountUnit != null && amountUnit != '') {
          recipeNutritions.add(
              Nutrition(name: n, amountUnit: nutritionsController[n].text));
        }
      }
      rKeeper
          .addRecipeNutritions(widget.recipeName, recipeNutritions)
          .then((newRecipe) {
        if (widget.editRecipe) {
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => RecipeScreen(
                recipe: newRecipe,
                primaryColor: getRecipePrimaryColor(newRecipe.vegetable),
                heroImageTag: 'heroImageTag',
              ),
            ),
          );
        } else {
          rKeeper.currentlyEditedRecipe =
              Recipe(servings: null, name: null, vegetable: null);
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      });
    }
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

  Widget _getNutritionListTile(String nutritionName, BuildContext context,
      RecipeKeeper rKeeper, Key key) {
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
        child: widget.recipeName != null
            ? TextFormField(
                controller: nutritionsController[nutritionName],
              )
            : IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _showDeleteDialog(context, nutritionName, true);
                },
              ),
      ),
    );
  }
}
