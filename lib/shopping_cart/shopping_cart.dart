import 'package:flutter/material.dart';

import '../database.dart';
import '../recipe.dart';

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
                      left: ((MediaQuery.of(context).size.width / 2) - 200),
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
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 15),
              child: Row(
                children: <Widget>[
                  Text('check',
                      style: TextStyle(fontFamily: 'Ribeye', fontSize: 16)),
                  Text('     ware',
                      style: TextStyle(fontFamily: 'Ribeye', fontSize: 16)),
                  Spacer(),
                  Text('amount   ',
                      style: TextStyle(fontFamily: 'Ribeye', fontSize: 16))
                ],
              ),
            ),
            FutureBuilder<ShoppingCart>(
              future: DBProvider.db.getShoppingCartIngredients(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.ingredientsAmount.isNotEmpty)
                    return Container(
                        height: MediaQuery.of(context).size.height - 335,
                        child: ListView(
                            children: buildShoppingList(snapshot.data)));
                  else
                    return Center(child: Text("Nothing added yet"));
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
    );
  }

  // TODO: Continue
  List<Widget> buildShoppingList(ShoppingCart sC) {
    List<Widget> output = [];
    for (int i = 0; i < sC.ingredientNames.length; i++) {
      output.add(
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Container(
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(width: 1.5),
                    left: BorderSide(width: 1.5),
                    right: BorderSide(width: 1.5),
                    bottom: BorderSide(
                        width: i == sC.ingredientNames.length - 1 ? 1.5 : 0))),
            child: IngredientRow(
              ingredientName: sC.ingredientNames[i],
              ingredientAmount: sC.ingredientsAmount[i],
              ingredientUnit: sC.ingredientsUnit[i],
            ),
          ),
        ),
      );
    }
    return output;
  }
}

class IngredientRow extends StatefulWidget {
  final String ingredientName;
  final double ingredientAmount;
  final String ingredientUnit;

  IngredientRow({
    Key key,
    this.ingredientName,
    this.ingredientAmount,
    this.ingredientUnit,
  }) : super(key: key);

  _IngredientRowState createState() => _IngredientRowState();
}

class _IngredientRowState extends State<IngredientRow> {
  bool saved;
  @override
  void initState() {
    super.initState();
    saved = false;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          height: 50,
          width: 50,
          decoration:
              BoxDecoration(border: Border(right: BorderSide(width: 1.5))),
          child: Center(
            child: IconButton(
              iconSize: 30,
              icon: Icon(Icons.check_circle_outline),
              color: saved == true ? Colors.green : Colors.grey,
              onPressed: () {
                if (!saved)
                  setState(() {
                    saved = true;
                  });
              },
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            //'SpaghettiSauce von der Kuh mit ganz viel ',
            '${widget.ingredientName}',
            style: TextStyle(fontSize: 18),
          ),
        ),
        Spacer(),
        Container(
            height: 50,
            width: 99,
            decoration:
                BoxDecoration(border: Border(left: BorderSide(width: 1.5))),
            child: Center(
              child: Text(
                '${widget.ingredientAmount} ${widget.ingredientUnit}',
                style: TextStyle(fontSize: 18),
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
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..color = Colors.black
      ..strokeWidth = 2;

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
