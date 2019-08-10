import 'package:flutter/material.dart';

import '../database.dart';
import '../recipe.dart';
import '../helper.dart';

class ShoppingCartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                    style: TextStyle(fontSize: 35, fontFamily: 'Ribeye'),
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
            FutureBuilder<ShoppingCart>(
              future: DBProvider.db.getShoppingCartIngredients(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.ingredients.isNotEmpty)
                    return Padding(
                      padding:
                          const EdgeInsets.only(left: 25, right: 25, top: 15.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text('check',
                                  style: TextStyle(
                                      fontFamily: 'Ribeye', fontSize: 16)),
                              Text('     ware',
                                  style: TextStyle(
                                      fontFamily: 'Ribeye', fontSize: 16)),
                              Spacer(),
                              Text('amount   ',
                                  style: TextStyle(
                                      fontFamily: 'Ribeye', fontSize: 16))
                            ],
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height - 335,
                            child: IngredientsList(
                                ingredients: snapshot.data.ingredients,
                                checked: snapshot.data.checked),
                          )
                        ],
                      ),
                    );
                  else
                    return Stack(
                      children: <Widget>[
                        Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height - 400,
                            child: Center(
                                child: Text(
                              "Nothing added yet",
                              style: TextStyle(
                                  fontSize: 26, fontFamily: 'RibeyeMarrow'),
                            ))),
                        Container(
                            height:
                                (MediaQuery.of(context).size.height - 415
                                ) / 2,
                            child: Align(
                                alignment: Alignment(
                                  1,1
                                ),
                                child: Image.asset('images/cookingPen.png', height: 75,)))
                      ],
                    );
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
    );
  }
}

class IngredientsList extends StatefulWidget {
  final List<Ingredient> ingredients;
  final List<bool> checked;

  IngredientsList({this.ingredients, this.checked, Key key}) : super(key: key);

  _IngredientsListState createState() => _IngredientsListState();
}

class _IngredientsListState extends State<IngredientsList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.ingredients.length,
      itemBuilder: (context, index) {
        String ingredientName = widget.ingredients[index].name;
        double ingredientAmount = widget.ingredients[index].amount;
        String ingredientUnit = widget.ingredients[index].unit;
        return Dismissible(
          key: Key('$ingredientName$ingredientAmount$ingredientUnit'),
          onDismissed: (_) {
            DBProvider.db
                .deleteFromShoppingCart(widget.ingredients[index])
                .then((_) {
              setState(() {
                widget.ingredients.removeAt(index);
                widget.checked.removeAt(index);
              });
            });
          },
          background: Container(
            color: Colors.red,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.delete, color: Colors.white),
                Text(
                  ' Delete from List',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                )
              ],
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
                color: Color(0xffFEF3E1),
                border: Border(
                    top: BorderSide(width: 2),
                    left: BorderSide(width: 2),
                    right: BorderSide(width: 2),
                    bottom: BorderSide(
                        width:
                            index == widget.ingredients.length - 1 ? 2 : 0))),
            child: IngredientRow(
                ingredient: widget.ingredients[index],
                checked: widget.checked,
                checkedIndex: index),
          ),
        );
      },
    );
  }
}

class IngredientRow extends StatefulWidget {
  final Ingredient ingredient;
  final List<bool> checked;
  final int checkedIndex;

  /// checked and checkedIndex because the Row needs to tell
  /// the overlaying List that an item is checked.
  /// One way: Using Wrapper and passing the wrapper
  /// Other way like here: Passing the list and the index

  IngredientRow({
    Key key,
    this.ingredient,
    this.checked,
    this.checkedIndex,
  }) : super(key: key);

  _IngredientRowState createState() => _IngredientRowState();
}

class _IngredientRowState extends State<IngredientRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          height: 50,
          width: 50,
          decoration:
              BoxDecoration(border: Border(right: BorderSide(width: 2))),
          child: Center(
            child: IconButton(
              iconSize: 30,
              icon: Icon(Icons.check_circle_outline),
              color: widget.checked[widget.checkedIndex] == true
                  ? Colors.green
                  : Colors.grey,
              onPressed: () {
                if (!widget.checked[widget.checkedIndex])
                  DBProvider.db
                      .checkIngredient(widget.ingredient, true)
                      .then((_) {
                    setState(() {
                      widget.checked[widget.checkedIndex] = true;
                    });
                  });
                else {
                  DBProvider.db
                      .checkIngredient(widget.ingredient, false)
                      .then((_) {
                    setState(() {
                      widget.checked[widget.checkedIndex] = false;
                    });
                  });
                }
              },
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            //'SpaghettiSauce von der Kuh mit ganz viel ',
            '${widget.ingredient.name}',
            style: widget.checked[widget.checkedIndex]
                ? TextStyle(
                    fontSize: 18, decoration: TextDecoration.lineThrough)
                : TextStyle(fontSize: 18),
          ),
        ),
        Spacer(),
        Container(
            height: 50,
            width: 99,
            decoration:
                BoxDecoration(border: Border(left: BorderSide(width: 2))),
            child: Center(
              child: Text(
                '${cutDouble(widget.ingredient.amount)} ${widget.ingredient.unit}',
                style: widget.checked[widget.checkedIndex]
                    ? TextStyle(
                        fontSize: 18, decoration: TextDecoration.lineThrough)
                    : TextStyle(fontSize: 18),
                overflow: TextOverflow.clip,
                maxLines: 1,
              ),
            ))
      ],
    );
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