import 'package:flutter/material.dart';

class IngredientSearchScreen extends StatefulWidget {
  const IngredientSearchScreen({Key key}) : super(key: key);

  @override
  _IngredientSearchScreenState createState() => _IngredientSearchScreenState();
}

class _IngredientSearchScreenState extends State<IngredientSearchScreen>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("ingredient search"),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color.fromRGBO(150, 150, 150, 0.3),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
                  child: AnimatedSize(
                    vsync: this,
                    duration: Duration(milliseconds: 150),
                    curve: Curves.fastOutSlowIn,
                    child: !isExpanded
                        ? Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: TextField(
                                  decoration: InputDecoration(
                                    labelText: "  ingredient one",
                                    labelStyle:
                                        TextStyle(fontWeight: FontWeight.w500),
                                    border: OutlineInputBorder(),
                                    focusedBorder: const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(50)),
                                      borderSide: const BorderSide(
                                        color: Colors.amber,
                                        width: 2,
                                      ),
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(50)),
                                      borderSide: const BorderSide(
                                          color:
                                              Color.fromRGBO(210, 210, 210, 1),
                                          width: 2),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: TextField(
                                  decoration: InputDecoration(
                                    labelText: "  ingredient one",
                                    labelStyle:
                                        TextStyle(fontWeight: FontWeight.w500),
                                    border: OutlineInputBorder(),
                                    focusedBorder: const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(50)),
                                      borderSide: const BorderSide(
                                          color: Colors.amber, width: 2),
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(50)),
                                      borderSide: const BorderSide(
                                        color: Color.fromRGBO(210, 210, 210, 1),
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(
                                      Icons.expand_more,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        isExpanded = true;
                                      });
                                    },
                                  ),
                                  Container(
                                    width: 45,
                                    height: 45,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(45),
                                        color: Colors.yellow[800]),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.search,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {},
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )
                        : Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Container(
                                  height: 200,
                                  child: ListView(children: <Widget>[
                                    TextField(
                                      decoration: InputDecoration(
                                        labelText: "  ingredient one",
                                        labelStyle: TextStyle(
                                            fontWeight: FontWeight.w500),
                                        border: OutlineInputBorder(),
                                        focusedBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50)),
                                          borderSide: const BorderSide(
                                            color: Colors.amber,
                                            width: 2,
                                          ),
                                        ),
                                        enabledBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50)),
                                          borderSide: const BorderSide(
                                              color: Color.fromRGBO(
                                                  210, 210, 210, 1),
                                              width: 2),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    TextField(
                                      decoration: InputDecoration(
                                        labelText: "  ingredient two",
                                        labelStyle: TextStyle(
                                            fontWeight: FontWeight.w500),
                                        border: OutlineInputBorder(),
                                        focusedBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50)),
                                          borderSide: const BorderSide(
                                              color: Colors.amber, width: 2),
                                        ),
                                        enabledBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50)),
                                          borderSide: const BorderSide(
                                            color: Color.fromRGBO(
                                                210, 210, 210, 1),
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(
                                      Icons.expand_less,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        isExpanded = false;
                                      });
                                    },
                                  ),
                                  Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(40),
                                        color: Colors.deepOrange[900]),
                                    child: Row(
                                      children: <Widget>[
                                        IconButton(
                                          icon: Icon(Icons.remove),
                                          onPressed: () {},
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.add),
                                          onPressed: () {},
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 45,
                                    height: 45,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(45),
                                        color: Colors.yellow[800]),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.search,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {},
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
