import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/shopping_cart/shopping_cart_bloc.dart';
import '../constants/global_constants.dart' as Constants;
import '../generated/i18n.dart';
import '../local_storage/hive.dart';
import '../models/ingredient.dart';
import '../models/recipe.dart';
import '../widgets/dialogs/info_dialog.dart';
import '../widgets/dialogs/shopping_cart_add_dialog.dart';
import '../widgets/icon_info_message.dart';
import '../widgets/search.dart';
import '../widgets/shopping_list.dart';

class FancyShoppingCartScreen extends StatelessWidget {
  final Image shoppingCartImage;

  const FancyShoppingCartScreen(
    this.shoppingCartImage, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double scaleFactor = MediaQuery.of(context).size.height / 800;
    return CustomScrollView(slivers: <Widget>[
      SliverAppBar(
        centerTitle: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => InfoDialog(
                  title: I18n.of(context).shopping_cart_help,
                  body: I18n.of(context).shopping_cart_help_desc,
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: RecipeSearch(
                    HiveProvider().getRecipeNames(),
                    BlocProvider.of<ShoppingCartBloc>(context),
                    HiveProvider().getRecipeTags(),
                    HiveProvider().getCategoryNames()..remove('no category'),
                  ));
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => BlocProvider.value(
                  value: BlocProvider.of<ShoppingCartBloc>(context),
                  child: ShoppingCartAddDialog(),
                ),
              );
            },
          ),
        ],
        expandedHeight: scaleFactor * 200.0,
        floating: false,
        pinned: true,
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: false,
          title: Text(I18n.of(context).shoppingcart),
          background: shoppingCartImage,
        ),
      ),
      SliverPadding(
        padding: EdgeInsets.all(12),
        sliver: BlocBuilder<ShoppingCartBloc, ShoppingCartState>(
            builder: (context, state) {
          if (state is LoadingShoppingCart) {
            return SliverList(
                delegate: SliverChildListDelegate(
                    [Center(child: CircularProgressIndicator())]));
          } else if (state is LoadedShoppingCart) {
            return SliverList(
              delegate: SliverChildListDelegate(getRecipeShoppingList(
                  state.shoppingCart, context, scaleFactor)),
            );
          } else {
            return Text(state.toString());
          }
        }),
      ),
    ]);
  }

  List<Widget> getRecipeShoppingList(
      Map<Recipe, List<CheckableIngredient>> ingredients,
      BuildContext context,
      scaleFactor) {
    List<Recipe> recipes = ingredients.keys.toList();
    if (ingredients.keys.isEmpty ||
        ingredients[ingredients.keys.first].isEmpty) {
      return [
        displayNothingAdded(context, scaleFactor),
      ];
    }
    Recipe summaryRecipe =
        recipes.firstWhere((recipe) => recipe.name == Constants.summary);
    if (summaryRecipe != recipes.first) {
      recipes.removeWhere((recipe) => recipe.name == "summary");
      recipes.insert(0, summaryRecipe);
    }
    return recipes.map((recipe) {
      Color ingredBackgroundColor =
          Theme.of(context).brightness == Brightness.dark
              ? Color(0xff40392F)
              : Colors.grey[100];
      if (recipe.name == 'summary') {
        return Center(
          child: Container(
            width: MediaQuery.of(context).size.width > 400 ? 400 : null,
            child: ShoppingCartListTile(
              recipe,
              ingredBackgroundColor,
              ingredients[recipe],
            ),
          ),
        );
      } else {
        return Center(
          child: Container(
            width: MediaQuery.of(context).size.width > 400 ? 400 : null,
            child: Dismissible(
              key: Key('$recipe'),
              onDismissed: (_) {
                List<Ingredient> removeIngreds = ingredients[recipe]
                    .map((ingred) => ingred.getIngredient())
                    .toList();
                BlocProvider.of<ShoppingCartBloc>(context)
                    .add(RemoveIngredients(removeIngreds, recipe));
              },
              background: PrimaryBackgroundDismissable(),
              secondaryBackground: SecondaryBackgroundDismissible(),
              child: ShoppingCartListTile(
                recipe,
                ingredBackgroundColor,
                ingredients[recipe],
              ),
            ),
          ),
        );
      }
    }).toList();
  }

  Widget displayNothingAdded(BuildContext context, double scaleFactor) {
    double deviceHeight = MediaQuery.of(context).size.height;
    return Container(
      height: deviceHeight / 2,
      child: Center(
        child: IconInfoMessage(
            iconWidget: Icon(
              Icons.shopping_basket,
              color: Colors.brown,
              size: 70.0,
            ),
            description: I18n.of(context).shopping_cart_is_empty),
      ),
    );
  }
}
