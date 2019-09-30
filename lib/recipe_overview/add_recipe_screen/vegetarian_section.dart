import "package:flutter/material.dart";
import 'package:my_recipe_book/generated/i18n.dart';
import 'package:my_recipe_book/models/recipe.dart';

import "../../my_wrapper.dart";

// Widget for the radio buttons (vegetarian, vegan, etc.)
class Vegetarian extends StatefulWidget {
  final MyVegetableWrapper vegetableStatus;
  Vegetarian({@required this.vegetableStatus});

  State<StatefulWidget> createState() {
    return _VegetarianState();
  }
}

class _VegetarianState extends State<Vegetarian> {
  int _radioValue = 0;

  @override
  initState() {
    switch (widget.vegetableStatus.getVegetableStatus()) {
      case Vegetable.NON_VEGETARIAN:
        _radioValue = 0;
        break;
      case Vegetable.VEGETARIAN:
        _radioValue = 1;
        break;
      case Vegetable.VEGAN:
        _radioValue = 2;
        break;
    }
    super.initState();
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          widget.vegetableStatus.setVegetableStatus(Vegetable.NON_VEGETARIAN);
          break;
        case 1:
          widget.vegetableStatus.setVegetableStatus(Vegetable.VEGETARIAN);
          break;
        case 2:
          widget.vegetableStatus.setVegetableStatus(Vegetable.VEGAN);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                child: Radio(
                  value: 0,
                  groupValue: _radioValue,
                  onChanged: _handleRadioValueChange,
                ),
              ),
              Text(
                S.of(context).non_vegetarian,
                style: TextStyle(fontSize: 16),
              ),
            ]),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                  child: Radio(
                    value: 1,
                    groupValue: _radioValue,
                    onChanged: _handleRadioValueChange,
                  ),
                ),
                Text(
                  S.of(context).vegetarian,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                  child: Radio(
                    value: 2,
                    groupValue: _radioValue,
                    onChanged: _handleRadioValueChange,
                  ),
                ),
                Text(
                  S.of(context).vegan,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            )
          ]),
    );
  }
}
