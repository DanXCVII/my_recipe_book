import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';

import '../blocs/nutrition_manager/nutrition_manager_bloc.dart';
import '../generated/i18n.dart';
import '../models/nutrition.dart';
import '../models/recipe.dart';
import '../widgets/dialogs/textfield_dialog.dart';

class NutritionManager extends StatefulWidget {
  final Recipe newRecipe;

  NutritionManager({this.newRecipe});

  @override
  _NutritionManagerState createState() => _NutritionManagerState();
}

class _NutritionManagerState extends State<NutritionManager> {
  static final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  Map<String, TextEditingController> nutritionsController = {};
  List<Key> dismissibleKeys = [];
  List<Key> listTileKeys = [];
  bool isInitialized = false;

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
          if (isInitialized == false && state.nutritions.isNotEmpty) {
            setState(() {
              isInitialized = true;
              for (int i = 0; i < state.nutritions.length; i++) {
                String currentNutrition = state.nutritions[i];

                nutritionsController
                    .addAll({currentNutrition: TextEditingController()});
                dismissibleKeys.add(Key('D-$currentNutrition'));
                listTileKeys.add(Key(currentNutrition));
              }
            });
          }
        }
      },
      child: BlocBuilder<NutritionManagerBloc, NutritionManagerState>(
        builder: (context, state) {
          if (state is LoadingNutritionManager) {
            return _getNutritionManagerLoadingScreen();
          } else if (state is LoadedNutritionManager) {
            int i = -1;

            return Scaffold(
              appBar: AppBar(
                title: Text(S.of(context).manage_nutritions),
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

                          return Dismissible(
                            key: dismissibleKeys[i],
                            background: _getPrimaryBackgroundDismissible(),
                            secondaryBackground:
                                _getSecondaryBackgroundDismissible(),
                            onDismissed: (_) {
                              nutritionsController.remove(currentNutrition);
                              BlocProvider.of<NutritionManagerBloc>(context)
                                  .add(DeleteNutrition(currentNutrition));
                            },
                            child: _getNutritionListTile(currentNutrition,
                                context, listTileKeys[i], state.nutritions),
                          );
                        }).toList(),
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

  Widget _getNutritionManagerLoadingScreen() {
    return Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).manage_nutritions),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ));
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
              BlocProvider.of<NutritionManagerBloc>(context)
                  .add(DeleteNutrition(nutritionName));

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
    Navigator.pop(context);
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
                BlocProvider.of<NutritionManagerBloc>(context).add(
                  UpdateNutrition(nutritionName, name),
                );
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
        child: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            _showDeleteDialog(context, nutritionName);
          },
        ),
      ),
    );
  }
}
