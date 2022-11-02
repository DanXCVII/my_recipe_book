import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:my_recipe_book/generated/i18n.dart';
import 'package:my_recipe_book/models/nutrition.dart';

class AnimatedNutritionsFab extends StatefulWidget {
  final List<Nutrition> recipeNutritions;
  final ScrollController? hideButtonController;

  AnimatedNutritionsFab(
    this.recipeNutritions,
    this.hideButtonController, {
    Key? key,
  }) : super(key: key);

  @override
  _AnimatedNutritionsFabState createState() => _AnimatedNutritionsFabState();
}

class _AnimatedNutritionsFabState extends State<AnimatedNutritionsFab>
    with TickerProviderStateMixin {
  bool isVisible = true;
  bool hide = false;
  bool isMinimized = true;
  bool canceld = false;

  @override
  void initState() {
    widget.hideButtonController!.addListener(() {
      if (widget.hideButtonController!.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (isVisible == true) {
          canceld = false;
          hideButton();
          setState(() {
            isVisible = false;
          });
        }
      } else {
        if (widget.hideButtonController!.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (isVisible == false) {
            canceld = true;
            setState(() {
              hide = false;
              isVisible = true;
            });
          }
        }
      }
    });

    super.initState();
  }

  void hideButton() async {
    Future.delayed(Duration(milliseconds: 300)).then((value) {
      if (isVisible == false && canceld == false) {
        setState(() {
          hide = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0,
      duration: Duration(milliseconds: 200),
      child: hide
          ? Container()
          : Container(
              decoration: BoxDecoration(
                color: Colors.amber[800],
                gradient: new LinearGradient(
                  colors: [
                    Colors.amber[600]!,
                    Colors.amber[800]!,
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 1.0),
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: AnimatedSize(
                vsync: this,
                duration: Duration(milliseconds: 150),
                curve: Curves.fastOutSlowIn,
                child: isMinimized
                    ? Container(
                        height: 60,
                        width: 60,
                        child: IconButton(
                          icon: Icon(MdiIcons.nutrition),
                          color: Colors.white,
                          onPressed: (() {
                            setState(() {
                              isMinimized = false;
                            });
                          }),
                        ),
                      )
                    : Container(
                        height: MediaQuery.of(context).size.height > 330
                            ? 310
                            : MediaQuery.of(context).size.height - 100,
                        width: MediaQuery.of(context).size.width > 330
                            ? 310
                            : MediaQuery.of(context).size.width - 20,
                        child: Center(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Spacer(),
                                    Text(I18n.of(context)!.nutritions,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    Spacer(),
                                    IconButton(
                                      icon: Icon(Icons.cancel),
                                      color: Colors.grey[800],
                                      onPressed: () {
                                        setState(() {
                                          isMinimized = true;
                                        });
                                      },
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                height: MediaQuery.of(context).size.height > 330
                                    ? 244
                                    : MediaQuery.of(context).size.height - 172,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 22.0),
                                  child: ListView(
                                    children: List.generate(
                                      widget.recipeNutritions.length,
                                      (index) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 3.0),
                                        child: Row(children: [
                                          Text(
                                              widget
                                                  .recipeNutritions[index].name,
                                              style: TextStyle(
                                                fontSize: 16,
                                              )),
                                          Spacer(),
                                          Text(
                                              widget.recipeNutritions[index]
                                                  .amountUnit,
                                              style: TextStyle(
                                                fontSize: 16,
                                              )),
                                        ]),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
            ),
    );
  }
}
