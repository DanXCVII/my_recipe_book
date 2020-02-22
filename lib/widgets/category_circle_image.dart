import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../constants/global_constants.dart' as Constants;

class CategoryCircle extends StatelessWidget {
  final String categoryName;
  final String imageName;
  final Function onPressed;

  CategoryCircle({
    this.categoryName,
    this.imageName,
    @required this.onPressed,
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.grey[800],
              blurRadius: 2.0,
              spreadRadius: 1.0,
              offset: Offset(
                0,
                1.0,
              ),
            ),
          ],
        ),
        child: ClipOval(
          child: Stack(
            children: <Widget>[
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageName != Constants.noRecipeImage
                        ? FileImage(File(imageName))
                        : AssetImage(Constants.noRecipeImage),
                    fit: BoxFit.cover,
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                  child: Container(
                    decoration:
                        BoxDecoration(color: Colors.white.withOpacity(0.0)),
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 30),
                  decoration:
                      BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.4)),
                  width: 100,
                  height: 40,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        categoryName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Questrial',
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
