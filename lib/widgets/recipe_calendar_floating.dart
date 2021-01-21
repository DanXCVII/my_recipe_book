import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:my_recipe_book/blocs/recipe_calendar/recipe_calendar_bloc.dart';
import 'package:my_recipe_book/screens/recipe_calendar_screen.dart';

import '../blocs/app/app_bloc.dart';
import 'dialogs/calendar_add_dialog.dart';

class RecipeCalendarFloating extends StatefulWidget {
  final Offset initialPosition;

  RecipeCalendarFloating({
    @required this.initialPosition,
    Key key,
  }) : super(key: key);

  @override
  _RecipeCalendarFloatingState createState() => _RecipeCalendarFloatingState();
}

class _RecipeCalendarFloatingState extends State<RecipeCalendarFloating>
    with TickerProviderStateMixin {
  double width = 100.0, height = 100.0;
  Offset position;
  bool visible = false;

  @override
  void initState() {
    super.initState();
    position = widget.initialPosition;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: BlocListener<AppBloc, AppState>(
        listener: (context, state) {
          if (state is LoadedState) {
            if (state.recipeCalendarOpen != visible) {
              setState(() {
                visible = state.recipeCalendarOpen;
              });
            }
          }
        },
        child: Material(
          color: Colors.transparent,
          child: AnimatedSize(
            vsync: this,
            duration: Duration(milliseconds: 150),
            curve: Curves.fastOutSlowIn,
            child: visible
                ? _getRecipeCalendarContent(
                    400,
                    MediaQuery.of(context).size.height > 800
                        ? 720
                        : MediaQuery.of(context).size.height - 80,
                  )
                : Container(
                    height: 400,
                  ),
          ),
        ),
      ),
    );
  }

  Widget _getRecipeCalendarContent(double width, double height) => Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 32),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(1, 1),
                      blurRadius: 2,
                      spreadRadius: 1,
                      color: Theme.of(context).backgroundColor == Colors.white
                          ? Colors.grey[400]
                          : Colors.black,
                    ),
                  ],
                  color: Theme.of(context).backgroundColor == Colors.white
                      ? Colors.grey[200]
                      : Colors.grey[800]),
              height: height,
              width: width,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Stack(
                  children: <Widget>[
                    RecipeCalendarContent(
                      height: height,
                      width: width,
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        width: 50.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black38,
                              blurRadius: 2.0, // default 20.0
                              spreadRadius: 1.0, // default 5.0
                              offset: Offset(0.0, 1.5),
                            ),
                          ],
                          color: Colors.amber,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        child: BlocBuilder<RecipeCalendarBloc,
                            RecipeCalendarState>(
                          builder: (context, state) {
                            if (state is LoadingRecipeCalendar) {
                              return CircularProgressIndicator();
                            } else if (state is LoadedRecipeCalendarOverview) {
                              return IconButton(
                                icon: Icon(Icons.view_day, color: Colors.black),
                                onPressed: () {
                                  BlocProvider.of<RecipeCalendarBloc>(context)
                                      .add(ChangeRecipeCalendarViewEvent(true));
                                },
                              );
                            } else {
                              return IconButton(
                                icon: Icon(Icons.view_day, color: Colors.black),
                                onPressed: () {
                                  BlocProvider.of<RecipeCalendarBloc>(context)
                                      .add(
                                          ChangeRecipeCalendarViewEvent(false));
                                },
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (contxt) => CalendarAddDialog(
                              (date, recipeName) {
                                BlocProvider.of<RecipeCalendarBloc>(context)
                                    .add(AddRecipeToCalendarEvent(
                                        date, recipeName));
                              },
                            ),
                          );
                        },
                        child: Icon(MdiIcons.calendarPlus),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 383, top: 25),
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor == Colors.white
                      ? Colors.grey[900]
                      : Colors.grey[200],
                  shape: BoxShape.circle),
              width: 25,
              height: 25,
            ),
          ),
          Container(
            width: 430,
            height: 60,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: IconButton(
                  icon: Icon(
                    Icons.cancel,
                    color: Theme.of(context).backgroundColor == Colors.white
                        ? Colors.grey[400]
                        : Colors.grey[900],
                    size: 36,
                  ),
                  onPressed: () {
                    BlocProvider.of<AppBloc>(context)
                      ..add(ChangeRecipeCalendarView(false));
                  },
                ),
              ),
            ),
          ),
        ],
      );
}
