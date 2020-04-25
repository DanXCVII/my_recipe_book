import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:my_recipe_book/constants/global_settings.dart';
import 'package:my_recipe_book/widgets/icon_info_message.dart';
import 'package:wakelock/wakelock.dart';

import '../../ad_related/ad.dart';
import '../../blocs/new_recipe/nutritions/nutritions_bloc.dart';
import '../../blocs/new_recipe/nutritions/nutritions_event.dart';
import '../../blocs/new_recipe/nutritions/nutritions_state.dart';
import '../../blocs/nutrition_manager/nutrition_manager_bloc.dart';
import '../../blocs/recipe_manager/recipe_manager_bloc.dart';
import '../../blocs/shopping_cart/shopping_cart_bloc.dart';
import '../../constants/routes.dart';
import '../../generated/i18n.dart';
import '../../models/nutrition.dart';
import '../../models/recipe.dart';
import '../../widgets/dialogs/textfield_dialog.dart';
import '../../widgets/icon_info_message.dart';
import '../recipe_screen.dart';

/// arguments which are provided to the route, when pushing to it
class AddRecipeNutritionsArguments {
  final Recipe modifiedRecipe;
  final String editingRecipeName;
  final ShoppingCartBloc shoppingCartBloc;

  AddRecipeNutritionsArguments(
    this.modifiedRecipe,
    this.shoppingCartBloc, {
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

class _AddRecipeNutritionsState extends State<AddRecipeNutritions>
    with WidgetsBindingObserver {
  bool _isInitialized = false;
  static final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  Map<String, TextEditingController> nutritionsController = {};
  List<Key> dismissibleKeys = [];
  List<Key> listTileKeys = [];

  FocusNode _focusNode = FocusNode();
  FocusNode _exitFocusNode;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    for (String k in nutritionsController.keys) {
      nutritionsController[k].dispose();
    }

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
        _finishedEditingNutritions(true);
        return false;
      },
      child: BlocListener<NutritionManagerBloc, NutritionManagerState>(
        listener: (context, state) {
          if (state is LoadedNutritionManager) {
            if (!_isInitialized) {
              _initializeData(state.nutritions);
              setState(() {
                _isInitialized = true;
              });
            } else {
              if (state.nutritions.length > listTileKeys.length) {
                nutritionsController
                    .addAll({state.nutritions.last: TextEditingController()});
                listTileKeys.add(Key(state.nutritions.last));
                dismissibleKeys.add(Key('D-${state.nutritions.last}'));
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
                appBar: GradientAppBar(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xffAF1E1E), Color(0xff641414)],
                  ),
                  title: Text(I18n.of(context).add_nutritions),
                  actions: <Widget>[
                    BlocListener<NutritionsBloc, NutritionsState>(
                      listener: (context, state) {
                        if (state is NEditingFinishedGoBack) {
                          Scaffold.of(context).showSnackBar(SnackBar(
                              content:
                                  Text(I18n.of(context).saving_your_input)));
                        } else if (state is NSavedGoBack) {
                          Scaffold.of(context).hideCurrentSnackBar();
                          Navigator.pop(context);
                        } else if (state is NSaved) {
                          if (widget.editingRecipeName == null) {
                            Future.delayed(Duration(milliseconds: 300))
                                .then((_) {
                              Navigator.of(context)
                                  .pushNamedAndRemoveUntil(
                                    RouteNames.recipeScreen,
                                    (route) => route.isFirst,
                                    arguments: RecipeScreenArguments(
                                      BlocProvider.of<ShoppingCartBloc>(
                                          context),
                                      state.recipe,
                                      'heroImageTag',
                                      BlocProvider.of<RecipeManagerBloc>(
                                          context),
                                    ),
                                  )
                                  .then((_) => Ads.hideBottomBannerAd());
                            });
                          } else {
                            Future.delayed(Duration(milliseconds: 300))
                                .then((_) {
                              if (GlobalSettings().standbyDisabled()) {
                                Wakelock.enable();
                              }
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                RouteNames.recipeScreen,
                                ModalRoute.withName('recipeRoute'),
                                arguments: RecipeScreenArguments(
                                  BlocProvider.of<ShoppingCartBloc>(context),
                                  state.recipe,
                                  'heroImageTag',
                                  BlocProvider.of<RecipeManagerBloc>(context),
                                ),
                              ).then((_) {
                                Wakelock.disable();
                                Ads.hideBottomBannerAd();
                              });
                            });
                          }
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
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());

                                _finishedEditingNutritions(false);
                              },
                            );
                          } else if (state is NEditingFinished) {
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
                            return I18n.of(context).nutrition_already_exists;
                          } else if (name == "") {
                            return I18n.of(context).field_must_not_be_empty;
                          } else {
                            return null;
                          }
                        },
                        save: (String name) {
                          BlocProvider.of<NutritionManagerBloc>(context)
                              .add(AddNutrition(name));
                        },
                        hintText: I18n.of(context).nutrition,
                      ),
                    );
                  },
                ),
                body: state.nutritions.isEmpty
                    ? Center(
                        child: IconInfoMessage(
                        iconWidget: Icon(
                          MdiIcons.nutrition,
                          color: Colors.grey[200],
                          size: 70.0,
                        ),
                        description: I18n.of(context).you_have_no_nutritions,
                      ))
                    : Form(
                        key: _formKey,
                        child: ReorderableListView(
                          onReorder: (oldIndex, newIndex) {
                            BlocProvider.of<NutritionManagerBloc>(context)
                                .add(MoveNutrition(oldIndex, newIndex));
                          },
                          children: List<Widget>.generate(
                            state.nutritions.length,
                            (i) => Dismissible(
                              key: dismissibleKeys[i],
                              background: _getPrimaryBackgroundDismissible(),
                              secondaryBackground:
                                  _getSecondaryBackgroundDismissible(),
                              onDismissed: (_) {
                                setState(() {
                                  dismissibleKeys =
                                      List<Key>.from(dismissibleKeys)
                                        ..removeAt(i);
                                  listTileKeys = List<Key>.from(listTileKeys)
                                    ..removeAt(i);
                                  nutritionsController
                                      .remove(state.nutritions[i]);
                                  BlocProvider.of<NutritionManagerBloc>(context)
                                      .add(
                                          DeleteNutrition(state.nutritions[i]));
                                });
                              },
                              child: _getNutritionListTile(state.nutritions[i],
                                  context, listTileKeys[i], state.nutritions),
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
      ),
    );
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
        appBar: GradientAppBar(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: [Color(0xffAF1E1E), Color(0xff641414)],
          ),
          title: Text(I18n.of(context).add_nutritions),
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
        goBack,
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
                  return I18n.of(context).nutrition_already_exists;
                } else if (name == "") {
                  return I18n.of(context).field_must_not_be_empty;
                } else {
                  return null;
                }
              },
              save: (String name) {
                nutritionsController
                    .addAll({name: nutritionsController[nutritionName]});
                nutritionsController.remove(nutritionName);
                BlocProvider.of<NutritionManagerBloc>(context)
                    .add(UpdateNutrition(nutritionName, name));
              },
              hintText: I18n.of(context).nutrition,
              prefilledText: nutritionName,
            ),
          );
        },
        child: Text(nutritionName),
      ),
      leading: Icon(Icons.reorder),
      trailing: Container(
        width: 80,
        child: TextFormField(
          controller: nutritionsController[nutritionName],
          decoration: InputDecoration(
            filled: true,
            hintText: I18n.of(context).amnt,
          ),
        ),
      ),
    );
  }
}
