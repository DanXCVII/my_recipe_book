
import 'package:flutter/material.dart';

import '../helper.dart';
import '../recipe.dart';
import '../recipe_card.dart';

TextStyle smallHeading = TextStyle(
    fontSize: 16, color: Color(0xffC75F00), fontWeight: FontWeight.w600);
TextStyle timeStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.w900);
TextStyle ingredientsStyle =
    TextStyle(fontSize: 14, fontWeight: FontWeight.w600);
TextStyle stepNumberStyle =
    TextStyle(fontSize: 32, fontWeight: FontWeight.w700);
TextStyle complexityNumberStyle =
    TextStyle(fontSize: 32, fontWeight: FontWeight.w900);

class RecipeCardBig extends StatelessWidget {
  final Recipe recipe;

  const RecipeCardBig({this.recipe, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                blurRadius: 5,
                spreadRadius: 2,
                color: Colors.grey[400],
              )
            ]),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 12,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Image.asset(
                      recipe.imagePath,
                      fit: BoxFit.cover,
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          color: Colors.white.withOpacity(0.6),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width / 1.8 -
                                          20,
                                  child: Text(
                                    recipe.name,
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Image.asset(
                                  "images/${getRecipeTypeImage(recipe.vegetable)}.png",
                                  height: 35,
                                  width: 35,
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                            ],
                          ),
                        ))
                  ],
                ),
              ),
              Expanded(
                flex: 8,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('prep. time', style: smallHeading),
                              SizedBox(height: 5),
                              Text('1h 50min', style: timeStyle),
                            ],
                          ),
                          VerticalDivider(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('cook. time', style: smallHeading),
                              SizedBox(height: 5),
                              Text('1h 20min', style: timeStyle),
                            ],
                          ),
                          VerticalDivider(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('total time', style: smallHeading),
                              SizedBox(height: 5),
                              Text('3h 40min', style: timeStyle),
                            ],
                          ),
                        ],
                      ),
                      Spacer(),
                      Text(
                        '10 ingredients:',
                        style: smallHeading,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      buildIngredients(recipe.ingredients),
                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('steps', style: smallHeading),
                              Text(
                                recipe.steps.length.toString(),
                                style: stepNumberStyle,
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('categories', style: smallHeading),
                              Text('Teiggerichte, EssenWarm')
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text('complexity', style: smallHeading),
                              Text(
                                recipe.complexity.toString(),
                                style: complexityNumberStyle,
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildIngredients(List<List<Ingredient>> ingredients) {
    List<Ingredient> flatIngredients = flattenIngredients(ingredients);

    Column leftIngredientColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[],
    );
    Column rightIngredientColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[],
    );
    Column leftIngredAmountColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[],
    );
    Column rightIngredAmountColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[],
    );

    for (int i = 0; i < flatIngredients.length; i += 2) {
      leftIngredientColumn.children
          .add(Text(flatIngredients[i].name, style: ingredientsStyle));
      leftIngredAmountColumn.children.add(Text(
        flatIngredients[i].amount.toString() + ' ' + flatIngredients[i].unit,
        style: ingredientsStyle,
      ));
    }
    for (int i = 1; i < flatIngredients.length; i += 2) {
      rightIngredientColumn.children
          .add(Text(flatIngredients[i].name, style: ingredientsStyle));
      rightIngredAmountColumn.children.add(Text(
        flatIngredients[i].amount.toString() + ' ' + flatIngredients[i].unit,
        style: ingredientsStyle,
      ));
    }
    if (flatIngredients.length > 1)
      return Row(
        children: <Widget>[
          leftIngredientColumn,
          Spacer(),
          leftIngredAmountColumn,
          SizedBox(width: 5),
          rightIngredientColumn,
          Spacer(),
          rightIngredAmountColumn,
        ],
      );
    else {
      return Row(children: <Widget>[
        leftIngredientColumn,
        Spacer(),
        leftIngredAmountColumn
      ]);
    }
  }
}
