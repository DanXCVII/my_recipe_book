import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_recipe_book/blocs/shopping_cart/shopping_cart_bloc.dart';
import 'package:my_recipe_book/constants/routes.dart';
import 'package:my_recipe_book/models/enums.dart';
import 'package:my_recipe_book/screens/recipe_overview.dart';
import 'package:my_recipe_book/widgets/recipe_card.dart';

// ShoppingCartBloc must be in context
class AnimatedVegetable extends StatelessWidget {
  final Vegetable vegetable;
  final bool small;

  const AnimatedVegetable(
    this.vegetable, {
    this.small = false,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          RouteNames.vegetableRecipes,
          arguments: RecipeGridViewArguments(
              shoppingCartBloc: BlocProvider.of<ShoppingCartBloc>(context),
              vegetable: vegetable),
        );
      },
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0.1, end: 1),
        duration: Duration(milliseconds: 700),
        curve: Curves.easeOutQuad,
        builder: (_, double size, myChild) => Container(
          height: small ? size * 50 : size * 65,
          width: small ? size * 50 : size * 65,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(15),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black45,
                  blurRadius: 2.0,
                  spreadRadius: 1.0,
                  offset: Offset(
                    0,
                    1.0,
                  ),
                ),
              ],
              color: _getVegetableCircleColor(vegetable)),
          child: Center(
            child: Image.asset(
              "images/${getRecipeTypeImage(vegetable)}.png",
              height: small ? size * 30 : size * 40,
              width: small ? size * 30 : size * 40,
              fit: BoxFit.scaleDown,
            ),
          ),
        ),
      ),
    );
  }

  Color _getVegetableCircleColor(Vegetable vegetable) {
    switch (vegetable) {
      case Vegetable.NON_VEGETARIAN:
        return Color(0xffBF8138);
      case Vegetable.VEGETARIAN:
        return Color(0xff8DCF4A);
      case Vegetable.VEGAN:
        return Color(0xff1BC318);
      default:
        return null;
    }
  }
}
