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
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
            child: Row(
              children: <Widget>[
                Text('check', style: TextStyle(fontFamily: 'Ribeye')),
                Text('     ware', style: TextStyle(fontFamily: 'Ribeye')),
                Spacer(),
                Text('amount', style: TextStyle(fontFamily: 'Ribeye'))
              ],
            ))
      ],
    ));
  }
}
