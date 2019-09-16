import 'package:flutter/material.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:my_recipe_book/models/shopping_cart.dart';
import 'package:scoped_model/scoped_model.dart';

import '../recipe.dart';
import '../helper.dart';

class ShoppingCartScreen extends StatelessWidget {
  const ShoppingCartScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage('images/apple.png'), context);
    precacheImage(AssetImage('images/banana.png'), context);
    precacheImage(AssetImage('images/bread.png'), context);
    return Padding(
      padding: EdgeInsets.all(5),
      child: CustomPaint(
        painter: NotePainter(),
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Center(
                    child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    'Your\nShopping List',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 35,
                      fontFamily: 'Ribeye',
                      color: Colors.black,
                    ),
                  ),
                )),
                Padding(
                  padding: EdgeInsets.only(
                      left: ((MediaQuery.of(context).size.width / 2) + 90),
                      top: 15),
                  child: Image.asset(
                    'images/apple.png',
                    height: 40,
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(
                        left: ((MediaQuery.of(context).size.width / 2) + 130),
                        top: 40),
                    child: Image.asset(
                      'images/banana.png',
                      height: 45,
                    )),
                Padding(
                  padding: EdgeInsets.only(
                      left: ((MediaQuery.of(context).size.width / 2) - 190),
                      top: 30),
                  child: Image.asset(
                    'images/bread.png',
                    height: 70,
                  ),
                )
              ],
            ),
            Image.asset(
              'images/circles.png',
              height: 10,
            ),
            ScopedModelDescendant<ShoppingCartKeeper>(
                builder: (context, child, model) {
              if (model.fullShoppingCart['summary'].isNotEmpty) {
                return Padding(
                  padding:
                      const EdgeInsets.only(left: 25, right: 25, top: 15.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height - 335,
                        child: IngredientsList(
                          scKeeper: model,
                          shoppingCart: model.fullShoppingCart,
                          recipes: model.recipesOrder,
                        ),
                      )
                    ],
                  ),
                );
              } else {
                return Stack(
                  children: <Widget>[
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height - 400,
                        child: Center(
                            child: Text(
                          "Nothing added yet",
                          style: TextStyle(
                            fontSize: 26,
                            fontFamily: 'RibeyeMarrow',
                            color: Colors.black,
                          ),
                        ))),
                    Container(
                        height: (MediaQuery.of(context).size.height - 415) / 2,
                        child: Align(
                            alignment: Alignment(1, 1),
                            child: Image.asset(
                              'images/cookingPen.png',
                              height: 75,
                            )))
                  ],
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}

class IngredientsList extends StatelessWidget {
  final Map<String, List<CheckableIngredient>> shoppingCart;
  final ShoppingCartKeeper scKeeper;
  final List<String> recipes;

  IngredientsList({
    this.shoppingCart,
    this.scKeeper,
    this.recipes,
    Key key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: shoppingCart.keys.length,
      itemBuilder: (context, index) {
        String recipeName = shoppingCart.keys.toList()[index];

        if (recipeName.compareTo('summary') == 0) {
          return getRecipeTile(recipeName, false);
        } else {
          return Dismissible(
            key: Key('$recipeName'),
            onDismissed: (_) {
              scKeeper.removeRecipeFromCart(recipeName);
            },
            background: _getPrimaryBackgroundDismissable(),
            secondaryBackground: _getSecondaryBackgroundDismissable(),
            child: getRecipeTile(recipeName,
                shoppingCart.keys.toList().length - 1 == index ? true : false),
          );
        }
      },
    );
  }

  Widget getRecipeTile(String recipeName, bool isLast) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xffFEF3E1),
        border: Border(
          top: BorderSide(width: 2),
          left: BorderSide(width: 2),
          right: BorderSide(width: 2),
          bottom: BorderSide(width: isLast ? 2 : 0),
        ),
      ),
      child: ExpansionTile(
        title: Text(recipeName),
        children: shoppingCart[recipeName].map((ingredient) {
          return Dismissible(
            key: Key('$recipeName${ingredient.name}${ingredient.unit}'),
            onDismissed: (_) {
              scKeeper.removeIngredientFromCart(
                recipeName,
                Ingredient(
                    name: ingredient.name,
                    amount: ingredient.amount,
                    unit: ingredient.unit),
              );
            },
            background: _getPrimaryBackgroundDismissable(),
            secondaryBackground: _getSecondaryBackgroundDismissable(),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xffFEF3E1),
                border: Border(
                  top: BorderSide(width: 2),
                  bottom: BorderSide(
                      width:
                          ingredient == shoppingCart[recipeName].last ? 0 : 0),
                ),
              ),
              child: IngredientRow(
                showBorder: true,
                ingredient: ingredient,
                scKeeper: scKeeper,
                recipeName: recipeName,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _getPrimaryBackgroundDismissable() {
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

  Widget _getSecondaryBackgroundDismissable() {
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
}

class IngredientRow extends StatelessWidget {
  final CheckableIngredient ingredient;
  final ShoppingCartKeeper scKeeper;
  final String recipeName;
  final bool showBorder;

  IngredientRow({
    Key key,
    this.showBorder = false,
    @required this.recipeName,
    @required this.ingredient,
    @required this.scKeeper,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
              border: Border(right: BorderSide(width: showBorder ? 2 : 0))),
          child: Center(
            child: IconButton(
              iconSize: 30,
              icon: Icon(
                ingredient.checked
                    ? GroovinMaterialIcons.check_circle_outline
                    : GroovinMaterialIcons.circle_outline,
              ),
              color: ingredient.checked ? Colors.green : Colors.grey,
              onPressed: () {
                _checkIngredient();
              },
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            //'SpaghettiSauce von der Kuh mit ganz viel ',
            '${ingredient.name}',
            style: ingredient.checked
                ? TextStyle(
                    fontSize: 18,
                    decoration: TextDecoration.lineThrough,
                    color: Colors.black,
                  )
                : TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
          ),
        ),
        Spacer(),
        Container(
            height: 50,
            width: 99,
            decoration: BoxDecoration(
                border: Border(left: BorderSide(width: showBorder ? 2 : 0))),
            child: Center(
              child: Text(
                '${cutDouble(ingredient.amount)} ${ingredient.unit}',
                style: ingredient.checked
                    ? TextStyle(
                        fontSize: 18,
                        decoration: TextDecoration.lineThrough,
                        color: Colors.black)
                    : TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                overflow: TextOverflow.clip,
                maxLines: 1,
              ),
            ))
      ],
    );
  }

  void _checkIngredient() {
    if (ingredient.checked) {
      ingredient.checked = false;
    } else {
      ingredient.checked = true;
    }
    scKeeper.checkIngredient(recipeName, ingredient);
  }
}

class NotePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintStroke = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.black
      ..strokeWidth = 4;

    final paintFill = Paint()
      ..color = Color(0xffFEF3E1)
      ..strokeWidth = 2;

    var leftTop = Offset(4, 25);
    var leftTopEdge = Offset(20, 27);
    var topLeftEdge = Offset(27, 20);
    var topLeft = Offset(25, 4);

    var topRight = Offset(size.width - 25, 4);
    var topRightEdge = Offset(size.width - 27, 20);
    var rightTopEdge = Offset(size.width - 20, 27);
    var rightTop = Offset(size.width - 4, 25);

    var rightBottom = Offset(size.width - 4, size.height - 25);
    var rightBottomEdge = Offset(size.width - 20, size.height - 27);
    var bottomRightEdge = Offset(size.width - 27, size.height - 20);
    var bottomRight = Offset(size.width - 25, size.height - 4);

    var bottomLeft = Offset(25, size.height - 4);
    var bottomLeftEdge = Offset(27, size.height - 20);
    var leftBottomEdge = Offset(20, size.height - 27);
    var leftBottom = Offset(4, size.height - 25);

    var path = Path();
    path.moveTo(leftTop.dx, leftTop.dy);
    path.cubicTo(leftTopEdge.dx, leftTopEdge.dy, topLeftEdge.dx, topLeftEdge.dy,
        topLeft.dx, topLeft.dy);
    path.lineTo(topRight.dx, topRight.dy);
    path.cubicTo(topRightEdge.dx, topRightEdge.dy, rightTopEdge.dx,
        rightTopEdge.dy, rightTop.dx, rightTop.dy);
    path.lineTo(rightBottom.dx, rightBottom.dy);
    path.cubicTo(rightBottomEdge.dx, rightBottomEdge.dy, bottomRightEdge.dx,
        bottomRightEdge.dy, bottomRight.dx, bottomRight.dy);
    path.lineTo(bottomLeft.dx, bottomLeft.dy);
    path.cubicTo(bottomLeftEdge.dx, bottomLeftEdge.dy, leftBottomEdge.dx,
        leftBottomEdge.dy, leftBottom.dx, leftBottom.dy);
    path.lineTo(leftTop.dx, leftTop.dy);
    canvas.drawPath(path, paintFill);
    canvas.drawPath(path, paintStroke);
  }

  @override
  bool shouldRepaint(NotePainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(NotePainter oldDelegate) => false;
}
