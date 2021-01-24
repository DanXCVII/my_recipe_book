import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:my_recipe_book/ad_related/ad.dart';
import 'package:my_recipe_book/blocs/recipe_calendar/recipe_calendar_bloc.dart';
import 'package:my_recipe_book/blocs/recipe_manager/recipe_manager_bloc.dart';
import 'package:my_recipe_book/blocs/shopping_cart/shopping_cart_bloc.dart';
import 'package:my_recipe_book/constants/global_settings.dart';
import 'package:my_recipe_book/constants/routes.dart';
import 'package:my_recipe_book/generated/i18n.dart';
import 'package:my_recipe_book/models/recipe.dart';
import 'package:my_recipe_book/models/tuple.dart';
import 'package:my_recipe_book/screens/recipe_screen.dart';
import 'package:my_recipe_book/widgets/dialogs/calendar_add_dialog.dart';
import 'package:my_recipe_book/widgets/dialogs/calendar_recipe_add_dialog.dart';
import 'package:my_recipe_book/widgets/recipe_image_hero.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:wakelock/wakelock.dart';

double deviceWidthMedium = 700;

class RecipeCalendarScreenArguments {
  final ShoppingCartBloc shoppingCartBloc;
  final RecipeCalendarBloc recipeCalendarBloc;

  RecipeCalendarScreenArguments(
    this.recipeCalendarBloc,
    this.shoppingCartBloc,
  );
}

class RecipeCalendarScreen extends StatefulWidget {
  final double width;
  final double height;

  RecipeCalendarScreen({
    this.width,
    this.height,
    Key key,
  }) : super(key: key);

  @override
  _RecipeCalendarScreenState createState() => _RecipeCalendarScreenState();
}

class _RecipeCalendarScreenState extends State<RecipeCalendarScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GradientAppBar(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
              colors: [Color(0xffAF1E1E), Color(0xff641414)],
            ),
            title: Text(I18n.of(context).recipe_planer),
            actions: [
              BlocBuilder<RecipeCalendarBloc, RecipeCalendarState>(
                  builder: (context, state) {
                if (state is LoadingRecipeCalendar) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                          width: 25,
                          height: 25,
                          child: CircularProgressIndicator()),
                    ),
                  );
                } else if (state is LoadedRecipeCalendarOverview) {
                  return IconButton(
                    icon: Icon(Icons.view_day_outlined),
                    onPressed: () {
                      BlocProvider.of<RecipeCalendarBloc>(context)
                          .add(ChangeRecipeCalendarViewEvent(true));
                    },
                  );
                } else {
                  return IconButton(
                    icon: Icon(Icons.calendar_today_outlined),
                    onPressed: () {
                      BlocProvider.of<RecipeCalendarBloc>(context)
                          .add(ChangeRecipeCalendarViewEvent(false));
                      BlocProvider.of<RecipeCalendarBloc>(context)
                          .add(ChangeSelectedDateEvent(DateTime.now()));
                    },
                  );
                }
              })
            ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (contxt) => CalendarAddDialog(
                (date, recipeName) {
                  BlocProvider.of<RecipeCalendarBloc>(context)
                      .add(AddRecipeToCalendarEvent(date, recipeName));
                },
              ),
            );
          },
          child: Icon(MdiIcons.calendarPlus),
        ),
        body: RecipeCalendarContent(
          height: widget.height,
          width: widget.width,
        ));
  }
}

class RecipeCalendarContent extends StatefulWidget {
  final double height;
  final double width;

  RecipeCalendarContent({
    @required this.height,
    @required this.width,
    Key key,
  }) : super(key: key);

  @override
  _RecipeCalendarContentState createState() => _RecipeCalendarContentState();
}

class _RecipeCalendarContentState extends State<RecipeCalendarContent>
    with TickerProviderStateMixin {
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();

    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = widget.height == null
        ? MediaQuery.of(context).size.height
        : widget.height;
    double width =
        widget.width == null ? MediaQuery.of(context).size.width : widget.width;
    return BlocBuilder<RecipeCalendarBloc, RecipeCalendarState>(
      builder: (context, state) {
        if (state is LoadingRecipeCalendar) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is LoadedRecipeCalendarOverview) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              // Switch out 2 lines below to play with TableCalendar's settings
              //-----------------------
              width > deviceWidthMedium
                  ? Container(
                      width: width,
                      height:
                          Ads.shouldShowAds() ? height - 80 - 60 : height - 80,
                      child: Row(children: [
                        Expanded(
                          flex: 3,
                          child: _buildTableCalendar(state.events),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          flex: 5,
                          child: _buildEventList(),
                        )
                      ]),
                    )
                  : Center(
                      child: Container(
                        width: width > 450
                            ? 450
                            : MediaQuery.of(context).size.width,
                        child: _buildTableCalendar(state.events),
                      ),
                    ),
              // _buildTableCalendarWithBuilders(),
              width > deviceWidthMedium ? null : const SizedBox(height: 8.0),
              width > deviceWidthMedium
                  ? null
                  : Expanded(
                      child: Center(
                        child: Container(
                          width: width > 450
                              ? 450
                              : MediaQuery.of(context).size.width,
                          child: _buildEventList(),
                        ),
                      ),
                    ),
            ]..removeWhere((element) => element == null),
          );
        } else if (state is LoadedRecipeCalendarVertical) {
          List<Widget> verticalDaysWithRecipes = [];
          verticalDaysWithRecipes.add(
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_left_rounded),
                  onPressed: () {
                    BlocProvider.of<RecipeCalendarBloc>(context)
                        .add(ChangeSelectedTimeVerticalEvent(false));
                  },
                ),
                Spacer(),
                Text(
                  state.from.day.toString() +
                      " - " +
                      state.from.add(Duration(days: 7)).day.toString() +
                      " " +
                      _getMonthString(
                          state.from.add(Duration(days: 7)).month, context) +
                      " " +
                      state.from.add(Duration(days: 7)).year.toString(),
                  style: TextStyle(fontSize: 16),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.arrow_right_rounded),
                  onPressed: () {
                    BlocProvider.of<RecipeCalendarBloc>(context)
                        .add(ChangeSelectedTimeVerticalEvent(true));
                  },
                ),
              ],
            ),
          );
          for (int i = 0; i < state.days; i++) {
            verticalDaysWithRecipes.addAll(_getDayWithRecipes(
                state.from.add(Duration(days: i)),
                state.recipes[state.from.add(Duration(days: i))]));
          }
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width > 600
                      ? 600
                      : double.infinity,
                  child: Column(
                    children: verticalDaysWithRecipes
                      ..add(
                        Container(
                          height: 60,
                        ), // Added Container, so that the FAB doesn't cover a recipe
                      ),
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }

  // Simple TableCalendar configuration (using Styles)
  Widget _buildTableCalendar(Map<DateTime, List<String>> events) {
    return TableCalendar(
      locale: I18n.of(context).locale_full,
      calendarController: _calendarController,
      events: events,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
        selectedColor: Colors.orange[900],
        todayColor: Colors.orange[700],
        markersColor: Colors.amber[500],
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle:
            TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.deepOrange[400],
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      onDaySelected: _onDaySelected,
    );
  }

  Widget _buildEventList() {
    return BlocBuilder<RecipeCalendarBloc, RecipeCalendarState>(
        builder: (context, state) {
      if (state is LoadingRecipeCalendar) {
        return Center(child: CircularProgressIndicator());
      } else if (state is LoadedRecipeCalendarOverview) {
        return ListView(
          children: List.generate(state.currentRecipes.length * 2, (index) {
            if (index % 2 == 0) {
              Tuple2<DateTime, Recipe> dateRecipeTuple =
                  state.currentRecipes[index ~/ 2];
              return _getRecipeListTile(dateRecipeTuple, index);
            } else {
              return Divider();
            }
          })
            ..add(
              Container(
                  height:
                      60), // Just so that the floatingActionButton doen't cover a recipe
            ),
        );
      }
      return Container();
    });
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    BlocProvider.of<RecipeCalendarBloc>(context)
        .add(ChangeSelectedDateEvent(day));
  }

  List<Widget> _getDayWithRecipes(
      DateTime date, List<Tuple2<DateTime, Recipe>> recipes) {
    List<Widget> dayWithRecipes = [];

    dayWithRecipes.add(
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 42, top: 15),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 2.0, // default 20.0
                          spreadRadius: 1.0, // default 5.0
                          offset: Offset(0.0, 1.5),
                        ),
                      ],
                      color: (date ==
                              DateTime(DateTime.now().year,
                                  DateTime.now().month, DateTime.now().day))
                          ? Colors.red[900]
                          : Colors.orange[900],
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    padding: const EdgeInsets.only(left: 32, right: 12),
                    height: 30,
                    width: 150,
                    child: Center(
                      child: Text(
                        _getWeekdayString(date.weekday, context),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black38,
                        blurRadius: 2.0, // default 20.0
                        spreadRadius: 1.0, // default 5.0
                        offset: Offset(0.0, 1.5),
                      ),
                    ],
                    color: (date ==
                            DateTime(DateTime.now().year, DateTime.now().month,
                                DateTime.now().day))
                        ? Colors.deepOrange[900]
                        : Colors.orange[700],
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          date.day.toString(),
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(_getMonthAbbrevString(date.month, context),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            )),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (contxt) => CalendarRecipeAddDialog(
                    save: (recipeName) {
                      BlocProvider.of<RecipeCalendarBloc>(context).add(
                        AddRecipeToCalendarEvent(date, recipeName),
                      );
                    },
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
    if (recipes.isNotEmpty) {
      dayWithRecipes.add(Divider());
    }
    int i = 0;
    for (Tuple2<DateTime, Recipe> dateRecipeTuple in recipes) {
      dayWithRecipes.add(_getRecipeListTile(dateRecipeTuple, i));
      dayWithRecipes.add(Divider());
      i += 1;
    }

    return dayWithRecipes;
  }

  ListTile _getRecipeListTile(
      Tuple2<DateTime, Recipe> dateRecipeTuple, int uniqueNumber) {
    return ListTile(
      onTap: () {
        if (GlobalSettings().standbyDisabled()) {
          Wakelock.enable();
        }
        Navigator.pushNamed(
          context,
          RouteNames.recipeScreen,
          arguments: RecipeScreenArguments(
            BlocProvider.of<ShoppingCartBloc>(context),
            BlocProvider.of<RecipeCalendarBloc>(context),
            dateRecipeTuple.item2,
            dateRecipeTuple.item1.toIso8601String() +
                dateRecipeTuple.item2.name +
                uniqueNumber.toString(),
            BlocProvider.of<RecipeManagerBloc>(context),
          ),
        ).then((_) {
          Wakelock.disable();
          if (Ads.shouldShowAds()) Ads.hideBottomBannerAd();
        });
      },
      subtitle: dateRecipeTuple.item1.hour == 0 &&
              dateRecipeTuple.item1.minute == 0
          ? null
          : Text(
              "${dateRecipeTuple.item1.hour < 10 ? "0" : ""}${dateRecipeTuple.item1.hour.toString()}:${dateRecipeTuple.item1.minute < 10 ? "0" : ""}${dateRecipeTuple.item1.minute.toString()}"),
      title: Text(dateRecipeTuple.item2.name),
      leading: RecipeImageHero(
        dateRecipeTuple.item2,
        dateRecipeTuple.item1.toIso8601String() +
            dateRecipeTuple.item2.name +
            uniqueNumber.toString(),
        showAds: true,
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          BlocProvider.of<RecipeCalendarBloc>(context).add(
            RemoveRecipeFromDateEvent(
              dateRecipeTuple.item1,
              dateRecipeTuple.item2.name,
            ),
          );
        },
      ),
    );
  }

  String _getMonthAbbrevString(int month, BuildContext context) {
    switch (month) {
      case 1:
        return I18n.of(context).jan;
      case 2:
        return I18n.of(context).feb;
      case 3:
        return I18n.of(context).mar;
      case 4:
        return I18n.of(context).apr;
      case 5:
        return I18n.of(context).may;
      case 6:
        return I18n.of(context).jun;
      case 7:
        return I18n.of(context).jul;
      case 8:
        return I18n.of(context).aug;
      case 9:
        return I18n.of(context).sep;
      case 10:
        return I18n.of(context).oct;
      case 11:
        return I18n.of(context).nov;
      case 12:
        return I18n.of(context).dec;
      default:
        return "";
    }
  }

  String _getMonthString(int month, BuildContext context) {
    switch (month) {
      case 1:
        return I18n.of(context).january;
      case 2:
        return I18n.of(context).february;
      case 3:
        return I18n.of(context).march;
      case 4:
        return I18n.of(context).april;
      case 5:
        return I18n.of(context).may_full;
      case 6:
        return I18n.of(context).june;
      case 7:
        return I18n.of(context).july;
      case 8:
        return I18n.of(context).august;
      case 9:
        return I18n.of(context).september;
      case 10:
        return I18n.of(context).october;
      case 11:
        return I18n.of(context).november;
      case 12:
        return I18n.of(context).december;
      default:
        return "";
    }
  }

  String _getWeekdayString(int weekday, BuildContext context) {
    switch (weekday) {
      case 1:
        return I18n.of(context).monday;
      case 2:
        return I18n.of(context).tuesday;
      case 3:
        return I18n.of(context).wednesday;
      case 4:
        return I18n.of(context).thursday;
      case 5:
        return I18n.of(context).friday;
      case 6:
        return I18n.of(context).saturday;
      case 7:
        return I18n.of(context).sunday;
      default:
        return "";
    }
  }
}
