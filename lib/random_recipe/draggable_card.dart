import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_recipe_book/models/recipe_keeper.dart';
import 'package:my_recipe_book/random_recipe/anchored_widget.dart';
import 'package:my_recipe_book/random_recipe/recipe_card_big.dart';
import 'package:my_recipe_book/random_recipe/recipe_engine.dart';
import 'package:my_recipe_book/recipe_overview/recipe_screen.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:my_recipe_book/models/selected_index.dart';

import '../database.dart';
import '../recipe.dart';

class CardStack extends StatefulWidget {
  final RecipeEngine recipeEngine;

  CardStack({
    this.recipeEngine,
    Key key,
  }) : super(key: key);

  _CardStackState createState() => _CardStackState();
}

class _CardStackState extends State<CardStack> {
  Key _frontCard;
  RecipeDecision _currentRecipeD;
  double _nextCardScale = 0.9;

  @override
  void initState() {
    super.initState();
    widget.recipeEngine.addListener(_onRecipeEngineChange);

    _currentRecipeD = widget.recipeEngine.currentRecipeD;
    _currentRecipeD.addListener(_onRecipeChange);

    _frontCard = Key(_currentRecipeD.recipe.name);
  }

  @override
  void didUpdateWidget(CardStack oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.recipeEngine != oldWidget.recipeEngine) {
      oldWidget.recipeEngine.removeListener(_onRecipeEngineChange);
      widget.recipeEngine.addListener(_onRecipeEngineChange);

      if (_currentRecipeD != null) {
        _currentRecipeD.removeListener(_onRecipeChange);
      }
      _currentRecipeD = widget.recipeEngine.currentRecipeD;
      if (_currentRecipeD != null) {
        _currentRecipeD.addListener(_onRecipeChange);
      }
    }
  }

  @override
  void dispose() {
    if (_currentRecipeD != null) {
      _currentRecipeD.removeListener(_onRecipeChange);
    }

    widget.recipeEngine.removeListener(_onRecipeEngineChange);

    super.dispose();
  }

  void _onRecipeEngineChange() {
    setState(() {
      if (_currentRecipeD != null) {
        _currentRecipeD.removeListener(_onRecipeChange);
      }
      _currentRecipeD = widget.recipeEngine.currentRecipeD;
      if (_currentRecipeD != null) {
        _currentRecipeD.addListener(_onRecipeChange);
      }

      _frontCard = Key(_currentRecipeD.recipe.name);
    });
  }

  void _onRecipeChange() {
    setState(() {});
  }

  void _onSlideUpdate(double distance) {
    setState(() {
      _nextCardScale = 0.9 + (0.1 * (distance / 100.0)).clamp(0.0, 0.1);
    });
  }

  Widget _buildBackCard() {
    return Transform(
      transform: Matrix4.identity()..scale(_nextCardScale, _nextCardScale),
      alignment: Alignment.center,
      child: RecipeCardBig(
        recipe: widget.recipeEngine.nextRecipeD.recipe,
      ),
    );
  }

  Widget _buildFrontCard() {
    return RecipeCardBig(
      key: _frontCard,
      recipe: widget.recipeEngine.currentRecipeD.recipe,
    );
  }

  void _onSlideOutComplete() {
    RecipeDecision currentRecipeD = widget.recipeEngine.currentRecipeD;

    currentRecipeD.makeDecision();

    widget.recipeEngine.cycleRecipeD();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        DraggableCard(
          card: _buildBackCard(),
          isDraggable: false,
        ),
        DraggableCard(
          card: _buildFrontCard(),
          onSlideUpdate: _onSlideUpdate,
          recipe: widget.recipeEngine.currentRecipeD.recipe,
          onSlideOutComplete: _onSlideOutComplete,
        ),
      ],
    );
  }
}

class DraggableCard extends StatefulWidget {
  final Widget card;
  final bool isDraggable;
  final Function(double distance) onSlideUpdate;
  final Recipe recipe;
  final Function() onSlideOutComplete;

  DraggableCard({
    this.card,
    this.isDraggable = true,
    this.onSlideUpdate,
    this.recipe,
    this.onSlideOutComplete,
    Key key,
  }) : super(key: key);

  _DraggableCardState createState() => _DraggableCardState();
}

class _DraggableCardState extends State<DraggableCard>
    with TickerProviderStateMixin {
  GlobalKey recipeCardKey = GlobalKey(debugLabel: 'recipe_card_key');
  Offset cardOffset = const Offset(0.0, 0.0);
  Offset dragStart;
  Offset dragPosition;
  Offset slideBackStart;
  AnimationController slideBackAnimation;
  Tween<Offset> slideOutTween;
  AnimationController slideOutAnimation;

  @override
  void initState() {
    super.initState();
    slideBackAnimation = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    )
      ..addListener(() => setState(() {
            cardOffset = Offset.lerp(slideBackStart, const Offset(0.0, 0.0),
                Curves.elasticOut.transform(slideBackAnimation.value));

            if (null != widget.onSlideUpdate) {
              widget.onSlideUpdate(cardOffset.distance);
            }
          }))
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            dragStart = null;
            slideBackStart = null;
            dragPosition = null;
          });
        }
      });

    slideOutAnimation =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this)
          ..addListener(() {
            setState(() {
              cardOffset = slideOutTween.evaluate(slideOutAnimation);

              if (null != widget.onSlideUpdate) {
                widget.onSlideUpdate(cardOffset.distance);
              }
            });
          })
          ..addStatusListener((AnimationStatus status) {
            if (status == AnimationStatus.completed) {
              setState(() {
                dragStart = null;
                dragPosition = null;
                slideOutTween = null;

                if (widget.onSlideOutComplete != null) {
                  widget.onSlideOutComplete();
                }
              });
            }
          });
  }

  @override
  void didUpdateWidget(DraggableCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.card.key != oldWidget.card.key) {
      cardOffset = Offset(0.0, 0.0);
    }
  }

  @override
  void dispose() {
    slideBackAnimation.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    dragStart = details.globalPosition;

    if (slideBackAnimation.isAnimating) {
      slideBackAnimation.stop(canceled: true);
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      dragPosition = details.globalPosition;
      cardOffset = dragPosition - dragStart;

      if (null != widget.onSlideUpdate) {
        widget.onSlideUpdate(cardOffset.distance);
      }
    });
  }

  void _onPanEnd(DragEndDetails details) {
    final dragVector = cardOffset / cardOffset.distance;
    final isInLeftRegion = (cardOffset.dx / context.size.width) < -0.45;
    final isInRightRegion = (cardOffset.dx / context.size.width) > 0.45;
    final isInTopRegion = (cardOffset.dy / context.size.height) < -0.40;

    setState(() {
      if (isInLeftRegion || isInRightRegion) {
        slideOutTween = Tween(
            begin: cardOffset, end: dragVector * (2 * context.size.width));
        slideOutAnimation.forward(from: 0.0);
      } else if (isInTopRegion) {
        slideOutTween = Tween(
            begin: cardOffset, end: dragVector * (2 * context.size.height));
        slideOutAnimation.forward(from: 0.0);
      } else {
        slideBackStart = cardOffset;
        slideBackAnimation.forward(from: 0.0);
      }
    });
  }

  double _rotation(Rect dragBounds) {
    if (dragStart != null) {
      final rotationCornerMultiplier =
          dragStart.dy >= dragBounds.top + (dragBounds.height / 2) ? -1 : 1;
      return (pi / 8) *
          (cardOffset.dx / dragBounds.width) *
          rotationCornerMultiplier;
    } else {
      return 0.0;
    }
  }

  Offset _rotationOrigin(Rect dragBounds) {
    if (dragStart != null) {
      return dragStart - dragBounds.topLeft;
    } else {
      return Offset(0.0, 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainPageNavigator>(
      builder: (context, child, model) => AnchoredOverlay(
          showOverlay: model.showOverlay,
          child: Center(),
          overlayBuilder: (context, anchorBounds, anchor) {
            return CenterAbout(
              position: anchor,
              child: Transform(
                transform:
                    Matrix4.translationValues(cardOffset.dx, cardOffset.dy, 0.0)
                      ..rotateZ(_rotation(anchorBounds)),
                origin: _rotationOrigin(anchorBounds),
                child: Container(
                  key: recipeCardKey,
                  width: anchorBounds.width,
                  height: anchorBounds.height,
                  padding: EdgeInsets.all(16),
                  child: widget.isDraggable
                      ? GestureDetector(
                          onTap: () {

                            model.changeOverlayStatus(false);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => WillPopScope(
                                  onWillPop: () async {
                                    model.changeOverlayStatus(true);
                                    var completer = new Completer();
                                    completer.complete(false);
                                    await DBProvider.db.database;
                                    return true;
                                  },
                                  child: RecipeScreen(
                                    recipe: widget.recipe,
                                    primaryColor: getRecipePrimaryColor(
                                        widget.recipe.vegetable),
                                    heroImageTag: '${widget.recipe.name}',
                                    heroTitle: 'title-${widget.recipe.name}',
                                  ),
                                ),
                              ),
                            );
                          },
                          onPanStart: _onPanStart,
                          onPanUpdate: _onPanUpdate,
                          onPanEnd: _onPanEnd,
                          child: widget.card,
                        )
                      : widget.card,
                ),
              ),
            );
          }),
    );
  }
}
