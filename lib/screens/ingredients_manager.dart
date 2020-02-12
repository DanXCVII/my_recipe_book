import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';

import '../blocs/ingredinets_manager/ingredients_manager_bloc.dart';
import '../generated/i18n.dart';
import '../models/recipe.dart';
import '../widgets/dialogs/textfield_dialog.dart';

class IngredientsManager extends StatefulWidget {
  final String editRecipeName;
  final Recipe newRecipe;

  IngredientsManager({this.editRecipeName, this.newRecipe});

  @override
  _IngredientsManagerState createState() => _IngredientsManagerState();
}

class _IngredientsManagerState extends State<IngredientsManager> {
  static final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  Map<String, TextEditingController> ingredientsController = {};
  List<Key> dismissibleKeys = [];
  List<Key> listTileKeys = [];
  bool isInitialized = false;
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    for (String k in ingredientsController.keys) {
      ingredientsController[k].dispose();
    }
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<IngredientsManagerBloc, IngredientsManagerState>(
      listener: (context, state) {
        if (state is LoadedIngredientsManager) {
          if (isInitialized == false && state.ingredients.isNotEmpty) {
            setState(() {
              isInitialized = true;
              for (int i = 0; i < state.ingredients.length; i++) {
                String currentingredient = state.ingredients[i];

                ingredientsController
                    .addAll({currentingredient: TextEditingController()});

                dismissibleKeys.add(Key('D-$currentingredient'));
                listTileKeys.add(Key(currentingredient));
              }
            });
          }
        }
      },
      child: BlocBuilder<IngredientsManagerBloc, IngredientsManagerState>(
        builder: (context, state) {
          if (state is LoadingIngredientsManager) {
            return _getIngredientManagerLoadingScreen();
          } else if (state is LoadedIngredientsManager) {
            int i = -1;

            return Scaffold(
              appBar: AppBar(
                title: Text("Manage ingredients"),
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
                                if (state.ingredients.contains(name)) {
                                  return 'Ingredient already exists';
                                } else {
                                  return null;
                                }
                              },
                              save: (String name) {
                                BlocProvider.of<IngredientsManagerBloc>(context)
                                    .add(AddIngredient(name));
                              },
                              hintText: 'Ingredient name',
                            ));
                  }),
              body: state.ingredients.isEmpty
                  ? Center(
                      child: Text("you have no ingredients"),
                    )
                  : AnimationLimiter(
                      child: Form(
                        key: _formKey,
                        child: DraggableScrollbar.semicircle(
                          controller: _controller,
                          labelTextBuilder: (offset) {
                            final int currentItem = _controller.hasClients
                                ? (_controller.offset /
                                        _controller.position.maxScrollExtent *
                                        (state.ingredients.length - 1))
                                    .floor()
                                : 0;

                            return Text(
                                state.ingredients[currentItem].substring(0, 1));
                          },
                          child: ListView(
                            controller: _controller,
                            children: List<Widget>.generate(
                                state.ingredients.length * 2, (index) {
                              return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 150),
                                child: SlideAnimation(
                                  verticalOffset: 50.0,
                                  child: FadeInAnimation(
                                    child: index % 2 == 1
                                        ? Divider()
                                        : _getIngredientListTile(
                                            state.ingredients[index == 0
                                                ? 0
                                                : (index / 2).floor()],
                                            context,
                                            listTileKeys[index == 0
                                                ? 0
                                                : (index / 2).floor()],
                                            state.ingredients),
                                  ),
                                ),
                              );
                            }),
                          ),
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

  Widget _getIngredientManagerLoadingScreen() {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "manage ingredients",
          ),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ));
  }

  _showDeleteDialog(BuildContext context, String ingredientName) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("delete ingredient"),
        content: Text(S.of(context).sure_you_want_to_delete_this_nutrition +
            " $ingredientName"),
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
              BlocProvider.of<IngredientsManagerBloc>(context)
                  .add(DeleteIngredient(ingredientName));

              ingredientsController.remove(ingredientName);
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

  Widget _getIngredientListTile(String ingredientName, BuildContext context,
      Key key, List<String> ingredients) {
    return ListTile(
      key: key,
      title: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => TextFieldDialog(
              validation: (String name) {
                if (ingredients.contains(name)) {
                  return 'ingredient already exists';
                } else {
                  return null;
                }
              },
              save: (String name) {
                BlocProvider.of<IngredientsManagerBloc>(context).add(
                  UpdateIngredient(ingredientName, name),
                );
              },
              hintText: 'ingredient name',
              prefilledText: ingredientName,
            ),
          );
        },
        child: Text(ingredientName),
      ),
      trailing: Container(
        width: MediaQuery.of(context).size.width / 3 > 50
            ? 50
            : MediaQuery.of(context).size.width / 3,
        child: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            _showDeleteDialog(context, ingredientName);
          },
        ),
      ),
    );
  }
}
