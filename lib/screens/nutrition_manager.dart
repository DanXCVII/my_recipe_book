import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../blocs/nutrition_manager/nutrition_manager_bloc.dart';
import '../generated/l10n.dart';
import '../models/recipe.dart';
import '../widgets/dialogs/info_dialog.dart';
import '../widgets/dialogs/textfield_dialog.dart';
import '../widgets/icon_info_message.dart';

class NutritionManager extends StatefulWidget {
  final Recipe? newRecipe;

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
      nutritionsController[k]!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NutritionManagerBloc, NutritionManagerState>(
      listener: (context, state) {
        if (state is LoadedNutritionManager) {
          if (isInitialized == false) {
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
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.black,
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xffAF1E1E), Color(0xff641414)]),
                  ),
                ),
                title: Text(S.of(context).manage_nutritions),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.help_outline),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => InfoDialog(
                          title: S.of(context).info,
                          body: S.of(context).nutrition_manager_description,
                        ),
                      );
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
                    showDialog(
                      context: context,
                      builder: (_) => TextFieldDialog(
                        validation: (String? name) {
                          if (state.nutritions.contains(name)) {
                            return S.of(context).nutrition_already_exists;
                          } else if (name == "") {
                            return S.of(context).field_must_not_be_empty;
                          } else {
                            return null;
                          }
                        },
                        save: (String name) {
                          BlocProvider.of<NutritionManagerBloc>(context)
                              .add(AddNutrition(name));
                          nutritionsController
                              .addAll({name: TextEditingController()});
                          dismissibleKeys.add(Key('D-$name'));
                          listTileKeys.add(Key(name));
                        },
                        hintText: S.of(context).nutrition,
                      ),
                    );
                  }),
              body: state.nutritions.isEmpty
                  ? Center(
                      child: IconInfoMessage(
                      iconWidget: Icon(
                        MdiIcons.nutrition,
                        color: Colors.grey[200],
                        size: 70.0,
                      ),
                      description: S.of(context).you_have_no_nutritions,
                    ))
                  : Form(
                      key: _formKey,
                      child: ReorderableListView(
                        onReorder: (oldIndex, newIndex) {
                          BlocProvider.of<NutritionManagerBloc>(context)
                              .add(MoveNutrition(oldIndex, newIndex));
                        },
                        children: List.generate(
                          dismissibleKeys.length,
                          (index) => Dismissible(
                            key: dismissibleKeys[index],
                            background: _getPrimaryBackgroundDismissible(),
                            secondaryBackground:
                                _getSecondaryBackgroundDismissible(),
                            onDismissed: (_) {
                              _removeNutrition(index, state.nutritions);
                            },
                            child: _getNutritionListTile(
                              state.nutritions[index],
                              context,
                              listTileKeys[index],
                              state.nutritions,
                              index,
                            ),
                          ),
                        ).toList(),
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

  void _removeNutrition(int index, List<String> nutritions) {
    setState(() {
      dismissibleKeys = (List<Key>.from(dismissibleKeys))..removeAt(index);
      listTileKeys = (List<Key>.from(listTileKeys))..removeAt(index);
      nutritionsController.remove(nutritions[index]);
      BlocProvider.of<NutritionManagerBloc>(context)
          .add(DeleteNutrition(nutritions[index]));
    });
  }

  Widget _getNutritionManagerLoadingScreen() {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xffAF1E1E), Color(0xff641414)]),
            ),
          ),
          title: Text(S.of(context).manage_nutritions),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ));
  }

  _showDeleteDialog(
    BuildContext context,
    String nutritionName,
    List<String> nutritions,
    int index,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(S.of(context).delete_nutrition),
        content: Text(S.of(context).sure_you_want_to_delete_this_nutrition +
            " $nutritionName"),
        actions: <Widget>[
          TextButton(
            child: Text(S.of(context).no),
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              foregroundColor: Theme.of(context).textTheme.bodyMedium!.color,
            ),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          TextButton(
            child: Text(S.of(context).yes),
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              foregroundColor: Theme.of(context).textTheme.bodyMedium!.color,
              backgroundColor: Colors.red[600],
            ),
            onPressed: () {
              _removeNutrition(index, nutritions);
              BlocProvider.of<NutritionManagerBloc>(context)
                  .add(DeleteNutrition(nutritionName));

              nutritionsController.remove(nutritionName);
              Navigator.pop(context, true);
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
              MdiIcons.deleteSweep,
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
              MdiIcons.deleteSweep,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  Widget _getNutritionListTile(
    String nutritionName,
    BuildContext context,
    Key key,
    List<String> nutritions,
    int index,
  ) {
    return ListTile(
      key: key,
      title: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => TextFieldDialog(
              validation: (String? name) {
                if (nutritions.contains(name)) {
                  return S.of(context).nutrition_already_exists;
                } else if (name == "") {
                  return S.of(context).field_must_not_be_empty;
                } else {
                  return null;
                }
              },
              save: (String name) {
                BlocProvider.of<NutritionManagerBloc>(context).add(
                  UpdateNutrition(nutritionName, name),
                );
              },
              hintText: S.of(context).nutrition,
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
            _showDeleteDialog(context, nutritionName, nutritions, index);
          },
        ),
      ),
    );
  }
}
