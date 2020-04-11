import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_recipe_book/blocs/shopping_cart/shopping_cart_bloc.dart';
import 'package:my_recipe_book/constants/routes.dart';
import 'package:my_recipe_book/models/string_int_tuple.dart';
import 'package:my_recipe_book/screens/recipe_overview.dart';

// must be in context of shoppingCartBloc
class RecipeTagWrap extends StatelessWidget {
  final List<StringIntTuple> recipeTags;
  final String fontFamily;

  const RecipeTagWrap(
    this.recipeTags,
    this.fontFamily, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.center,
      runSpacing: 10,
      spacing: 10,
      children: List<Widget>.generate(
        recipeTags.length,
        (index) => InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              RouteNames.recipeTagOverview,
              arguments: RecipeGridViewArguments(
                recipeTag: recipeTags[index],
                shoppingCartBloc: BlocProvider.of<ShoppingCartBloc>(context),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                color: Color(recipeTags[index].number)),
            child: Padding(
              padding: EdgeInsets.fromLTRB(12, 9, 12, 9),
              child: Text(
                recipeTags[index].text,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontFamily: fontFamily,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
