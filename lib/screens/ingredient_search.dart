import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../blocs/ad_manager/ad_manager_bloc.dart';
import '../models/enums.dart';
import 'package:my_recipe_book/constants/global_settings.dart';
import 'package:my_recipe_book/models/enums.dart';
import 'package:my_recipe_book/models/tuple.dart';
import 'package:my_recipe_book/screens/recipe_screen.dart';
import 'package:wakelock/wakelock.dart';

import '../blocs/ingredient_search/ingredient_search_bloc.dart';
import '../blocs/recipe_manager/recipe_manager_bloc.dart';
import '../blocs/shopping_cart/shopping_cart_bloc.dart';
import '../constants/global_constants.dart' as Constants;
import '../constants/routes.dart';
import '../generated/i18n.dart';
import '../local_storage/hive.dart';
import '../models/recipe.dart';
import '../models/string_int_tuple.dart';
import '../widgets/icon_info_message.dart';
import '../widgets/recipe_image_hero.dart';
import './recipe_screen.dart';

const double showExpandedSearch = 770;

class IngredientSearchScreenArguments {
  final AdManagerBloc adManagerBloc;
  final ShoppingCartBloc shoppingCartBloc;
  final bool hasPremium;

  IngredientSearchScreenArguments(
    this.shoppingCartBloc,
    this.adManagerBloc,
    this.hasPremium,
  );
}

class IngredientSearchScreen extends StatefulWidget {
  const IngredientSearchScreen({Key key}) : super(key: key);

  @override
  _IngredientSearchScreenState createState() => _IngredientSearchScreenState();
}

class _IngredientSearchScreenState extends State<IngredientSearchScreen>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  bool _isMinimized = false;
  bool _showTagCatFilter = false;
  List<TextEditingController> _controllers = [];
  List<GlobalKey<AutoCompleteTextFieldState<String>>> _autoCompletionKeys = [];

  bool _isInitialized = false;

  List<StringIntTuple> _recipeTags;
  List<String> _categories;

  List<StringIntTuple> _selectedRecipeTags = [];
  List<String> _selectedCategories = [];
  Vegetable _selectedVegetable;

  _IngredientSearchScreenState() {
    _recipeTags = HiveProvider().getRecipeTags();
    _categories = HiveProvider().getCategoryNames();
  }

  @override
  void initState() {
    _controllers.addAll([TextEditingController(), TextEditingController()]);
    _autoCompletionKeys.addAll([GlobalKey(), GlobalKey()]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.width);
    if (!_isInitialized &&
        MediaQuery.of(context).size.width > showExpandedSearch) {
      setState(() {
        _isInitialized = true;
        _showTagCatFilter = true;
        _isExpanded = true;
      });
    }
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: GradientAppBar(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: [Color(0xffAF1E1E), Color(0xff641414)],
          ),
          title: Text(I18n.of(context).professional_search),
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width > 420
                  ? 450
                  : MediaQuery.of(context).size.width,
              child: Column(
                  crossAxisAlignment:
                      MediaQuery.of(context).size.width > showExpandedSearch
                          ? CrossAxisAlignment.start
                          : CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width > 420
                          ? 420
                          : MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color.fromRGBO(70, 70, 70, 1),
                                  Color.fromRGBO(60, 60, 60, 1)
                                ],
                              ),
                              borderRadius: BorderRadius.circular(25),
                              color: Color.fromRGBO(70, 70, 70, 1),
                            ),
                            child: AnimatedSize(
                              vsync: this,
                              duration: Duration(milliseconds: 150),
                              curve: Curves.fastOutSlowIn,
                              child: _isMinimized
                                  ? _getMinimized()
                                  : !_isExpanded
                                      ? _getNonExpanded()
                                      : LayoutBuilder(
                                          builder: (context, constraints) {
                                          double height;
                                          if (_showTagCatFilter) {
                                            height = MediaQuery.of(context)
                                                            .size
                                                            .height -
                                                        100 >
                                                    550
                                                ? 550
                                                : MediaQuery.of(context)
                                                        .size
                                                        .height -
                                                    100;
                                          } else {
                                            height = 275;
                                          }

                                          return Container(
                                            height: height,
                                            child: _getExpanded(
                                                constraints.maxHeight,
                                                constraints.maxWidth),
                                          );
                                        }),
                            ),
                          ),
                        ),
                      ),
                    ),
                    MediaQuery.of(context).size.width > showExpandedSearch
                        ? null
                        : Expanded(child: _getResultWidget())
                  ]..removeWhere((item) => item == null)),
            ),
            MediaQuery.of(context).size.width > showExpandedSearch
                ? Expanded(child: _getResultWidget())
                : null
          ]..removeWhere((item) => item == null),
        ));
  }

  Widget _getResultWidget() {
    return BlocBuilder<IngredientSearchBloc, IngredientSearchState>(
        builder: (context, state) {
      if (state is IngredientSearchInitial) {
        return Container();
      } else if (state is SearchingRecipes) {
        return Center(
          child: Container(
            height: MediaQuery.of(context).size.height - 350,
            child: Center(child: CircularProgressIndicator()),
          ),
        );
      } else if (state is IngredientSearchMatches) {
        if (state.tupleMatchesRecipe.isEmpty) {
          return ListView(children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height - 350,
              child: Center(
                child: state.totalIngredAmount == 0
                    ? IconInfoMessage(
                        iconWidget: Icon(
                          MdiIcons.pencil,
                          color: Colors.white,
                          size: 70.0,
                        ),
                        description: I18n.of(context).enter_some_information,
                      )
                    : IconInfoMessage(
                        iconWidget: Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 70.0,
                        ),
                        description: I18n.of(context).no_matching_recipes,
                      ),
              ),
            ),
          ]);
        } else {
          return _getRecipeFoundList(
              state.tupleMatchesRecipe, state.totalIngredAmount);
        }
      } else {
        return Text(state.toString());
      }
    });
  }

  Widget _getRecipeFoundList(
      List<Tuple2<int, Recipe>> recipeMatches, int totalIngredientAmount) {
    return ListView(
      children: List<Widget>.generate(
        recipeMatches.length * 2,
        (index) {
          int recipeIndex = index == 0 ? 0 : (index / 2).floor();
          Recipe currentRecipe = recipeMatches[recipeIndex].item2;
          return index % 2 == 1
              ? Divider()
              : ListTile(
                  onTap: () {
                    if (GlobalSettings().standbyDisabled()) {
                      Wakelock.enable();
                    }
                    Navigator.pushNamed(
                      context,
                      RouteNames.recipeScreen,
                      arguments: RecipeScreenArguments(
                        BlocProvider.of<ShoppingCartBloc>(context),
                        currentRecipe,
                        currentRecipe.name,
                        BlocProvider.of<RecipeManagerBloc>(context),
                      ),
                    ).then((_) => Wakelock.disable());
                  },
                  title: Text(recipeMatches[recipeIndex].item2.name),
                  subtitle: recipeMatches[recipeIndex].item1 == 0 &&
                          totalIngredientAmount == 0
                      ? null
                      : Text(
                          "${I18n.of(context).ingredient_matches}: ${recipeMatches[recipeIndex].item1} ${I18n.of(context).out_of} $totalIngredientAmount"),
                  leading: RecipeImageHero(
                    currentRecipe,
                    currentRecipe.name,
                    showAds: true,
                  ),
                );
        },
      ),
    );
  }

  Widget _getExpanded(double maxHeight, double maxWidth) {
    double height;
    if (_showTagCatFilter) {
      height = maxHeight - 100 > 500 ? 500 : maxHeight - 100;
    }
    return Container(
      height: height,
      width: maxWidth,
      child: ListView(
        children: <Widget>[
          _showTagCatFilter ? _getRecipeTagCategoryFilter() : Container(),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 15, 20, 5),
            child: Container(
              height: 180,
              child: ListView(
                  children: List<Widget>.generate(
                _controllers.length,
                (index) => Padding(
                  padding:
                      EdgeInsets.only(bottom: 10.0, top: index == 0 ? 5 : 0),
                  child: SimpleAutoCompleteTextField(
                    key: _autoCompletionKeys[index],
                    suggestions: HiveProvider().getIngredientNames(),
                    controller: _controllers[index],
                    // style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: I18n.of(context).ingredient,
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.grey[500]),
                      border: OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        borderSide: const BorderSide(
                          color: Colors.amber,
                          width: 2,
                        ),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        borderSide: const BorderSide(
                            color: Color.fromRGBO(210, 210, 210, 1), width: 2),
                      ),
                    ),
                  ),
                ),
              )),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      MediaQuery.of(context).size.width > showExpandedSearch
                          ? null
                          : IconButton(
                              icon: Icon(
                                Icons.expand_less,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isExpanded = false;
                                });
                              },
                            ),
                      MediaQuery.of(context).size.width > showExpandedSearch
                          ? null
                          : _getHideSearch(),
                      _showTagCatFilter &&
                              MediaQuery.of(context).size.width <=
                                  showExpandedSearch
                          ? _getHideTagCat()
                          : null,
                      !_showTagCatFilter &&
                              MediaQuery.of(context).size.width <=
                                  showExpandedSearch
                          ? _getExpandTagCat()
                          : null,
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 40,
                          width: 97,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: Colors.deepOrange[900]),
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                icon: Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  if (_controllers.length > 2)
                                    setState(() {
                                      _controllers.removeLast();
                                      _autoCompletionKeys.removeLast();
                                    });
                                },
                              ),
                              IconButton(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                icon: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (_controllers.length < 20) {
                                      _controllers.add(TextEditingController());
                                      _autoCompletionKeys.add(GlobalKey());
                                    }
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                      Spacer(),
                    ]..removeWhere((item) => item == null),
                  ),
                ),
                _getSearchIconButton(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _getNonExpanded() {
    return LayoutBuilder(
      builder: (context, constraints) => Container(
        height: _showTagCatFilter ? 500 : 220,
        child: ListView(
          children: List<Widget>.generate(
            2,
            (index) => Padding(
              padding: EdgeInsets.fromLTRB(20, index == 0 ? 20 : 0, 20, 10),
              child: SimpleAutoCompleteTextField(
                key: _autoCompletionKeys[index],
                suggestions: HiveProvider().getIngredientNames(),
                controller: _controllers[index],
                style: new TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: I18n.of(context).ingredient,
                  labelStyle: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.grey[500]),
                  border: OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    borderSide: const BorderSide(
                      color: Colors.amber,
                      width: 2,
                    ),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    borderSide: const BorderSide(
                        color: Color.fromRGBO(210, 210, 210, 1), width: 2),
                  ),
                ),
              ),
            ),
          )
            ..add(
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: Container(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.expand_more,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _isExpanded = true;
                              });
                            },
                          ),
                          _getHideSearch(),
                          _showTagCatFilter
                              ? _getHideTagCat()
                              : _getExpandTagCat(),
                        ],
                      ),
                      _getSearchIconButton()
                    ],
                  ),
                ),
              ),
            )
            ..insert(
              0,
              _showTagCatFilter ? _getRecipeTagCategoryFilter() : Container(),
            ),
        ),
      ),
    );
  }

  Widget _getMinimized() {
    return IconButton(
      icon: Icon(
        MdiIcons.eye,
        color: Colors.white,
      ),
      onPressed: () {
        setState(() {
          _isMinimized = false;
        });
      },
    );
  }

  Widget _getSearchIconButton() {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(45), color: Colors.yellow[800]),
      child: IconButton(
        icon: Icon(
          Icons.search,
          color: Colors.white,
        ),
        onPressed: () {
          FocusScope.of(context).requestFocus(FocusNode());
          BlocProvider.of<IngredientSearchBloc>(context).add(
            SearchRecipes(
              _controllers.map((controller) => controller.text).toList()
                ..removeWhere((text) => text == ""),
              _selectedCategories,
              _selectedRecipeTags,
              _selectedVegetable,
            ),
          );
        },
      ),
    );
  }

  Widget _getHideSearch() => IconButton(
        icon: Icon(
          MdiIcons.eyeOff,
          color: Colors.white,
        ),
        onPressed: () {
          setState(() {
            _isMinimized = true;
          });
        },
      );

  Widget _getExpandTagCat() => IconButton(
        icon: Icon(
          MdiIcons.tag,
          color: Colors.white,
        ),
        onPressed: () {
          setState(() {
            _showTagCatFilter = true;
            _isExpanded = true;
          });
        },
      );

  Widget _getHideTagCat() => IconButton(
        icon: Icon(
          MdiIcons.tagOff,
          color: Colors.white,
        ),
        onPressed: () {
          setState(() {
            _showTagCatFilter = false;
          });
        },
      );

  Widget _getRecipeTagCategoryFilter() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.all(Radius.circular(20))),
            width: MediaQuery.of(context).size.width - 40,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                height: 230,
                child: ListView(
                  children: <Widget>[
                    Wrap(
                      spacing: 5.0,
                      runSpacing: 1.0,
                      children: [
                        Vegetable.NON_VEGETARIAN,
                        Vegetable.VEGETARIAN,
                        Vegetable.VEGAN
                      ].map((vegetable) {
                        switch (vegetable) {
                          case Vegetable.VEGETARIAN:
                            return _getVegetableFilterChip(
                              Colors.green[700],
                              MdiIcons.cheese,
                              Colors.amber,
                              I18n.of(context).vegetarian,
                              vegetable,
                            );

                          case Vegetable.VEGAN:
                            return _getVegetableFilterChip(
                              Colors.orange,
                              MdiIcons.leaf,
                              Colors.green[700],
                              I18n.of(context).vegan,
                              vegetable,
                            );

                          case Vegetable.NON_VEGETARIAN:
                            return _getVegetableFilterChip(
                              Colors.lightBlue[300],
                              MdiIcons.cow,
                              Colors.brown[800],
                              I18n.of(context).with_meat,
                              vegetable,
                            );
                        }
                      }).toList(),
                    ),
                    Text(
                      I18n.of(context).categories,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    Wrap(
                        spacing: 5.0,
                        runSpacing: 1.0,
                        children: _categories.map((category) {
                          return FilterChip(
                            label: Text(category == Constants.noCategory
                                ? I18n.of(context).no_category
                                : category),
                            selected: _selectedCategories.contains(category),
                            onSelected: (isSelected) {
                              setState(() {
                                if (isSelected) {
                                  _selectedCategories.add(category);
                                } else {
                                  _selectedCategories.remove(category);
                                }
                              });
                            },
                          );
                        }).toList()),
                    Text(
                      I18n.of(context).tags,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    Wrap(
                        spacing: 5.0,
                        runSpacing: 3.0,
                        children: _recipeTags.map((recipeTag) {
                          return FilterChip(
                            label: Text(recipeTag.text),
                            backgroundColor: Color(recipeTag.number),
                            selected: _selectedRecipeTags.contains(recipeTag),
                            onSelected: (isSelected) {
                              setState(() {
                                if (isSelected) {
                                  _selectedRecipeTags.add(recipeTag);
                                } else {
                                  _selectedRecipeTags.remove(recipeTag);
                                }
                              });
                            },
                          );
                        }).toList())
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  Widget _getVegetableFilterChip(
    Color backgroundColor,
    IconData iconData,
    Color iconColor,
    String label,
    Vegetable vegetable,
  ) {
    return FilterChip(
      label: Text(label),
      selected: vegetable == _selectedVegetable,
      onSelected: (_) {
        setState(() {
          if (vegetable == _selectedVegetable) {
            _selectedVegetable = null;
          } else {
            _selectedVegetable = vegetable;
          }
        });
      },
      avatar: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
        ),
        child: Center(
          child: Icon(
            iconData,
            color: iconColor,
            size: 22,
          ),
        ),
      ),
    );
  }
}
