import 'package:flutter/material.dart';

class AddRecipe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('add recipe'),
        ),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 32, right: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'preperation time:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Container(
                          width: 60,
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'time',
                              border: InputBorder.none,
                            ),
                          ))
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'cooking time:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Container(
                          width: 60,
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'time',
                              border: InputBorder.none,
                            ),
                          ))
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'total time:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Container(
                          width: 60,
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'time',
                              border: InputBorder.none,
                            ),
                          ))
                    ],
                  ),
                ],
              ),
            ),
            IngredientSection(),
          ],
        ));
  }
}

class IngredientSection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _IngredientSectionState();
  }
}

class _IngredientSectionState extends State<IngredientSection> {
  int _count = 1;

  List<Widget> getIngredientFields() {
    List<Widget> output = [];

    for (int i = 0; i < _count; i++) {
      output.add(Row(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 0, 0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'name',
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'amount',
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'unit',
                ),
              ),
            ),
          ),
          SizedBox(
            width: 32,
          )
        ],
      ));
    }
    return output;
  }

  @override
  Widget build(BuildContext context) {
    Column _ingredients = Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            left: 32,
            right: 32,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'ingredients:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              IconButton(
                icon: Icon(Icons.add_circle),
                onPressed: () {
                  setState(() {
                    _count += 1;
                  });
                },
              )
            ],
          ),
        ),
      ],
    );
    _ingredients.children.addAll(getIngredientFields());

    return _ingredients;
  }
}

class StepsSection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return null;
  }
}

class StepsSectionState extends State<StepsSection> {
  int _count = 1;

  List<Widget> getIngredientFields() {
    List<Widget> output = [];

    for (int i = 0; i < _count; i++) {
      output.add(
        Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'unit',
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return output;
  }

  @override
  Widget build(BuildContext context) {
    return null;
  }
}
