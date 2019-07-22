import 'package:flutter/material.dart';

import '../database.dart';

class ShoppingCart extends StatefulWidget {
  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListView(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Center(
                child: Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                'Your \nShopping List',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 35, fontFamily: 'Ribeye'),
              ),
            )),
          ],
        )
      ],
    ));
  }
}
