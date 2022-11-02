import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:my_recipe_book/blocs/app/app_bloc.dart';
import 'package:my_recipe_book/generated/i18n.dart';

class VerticalSideBar extends StatelessWidget {
  final int selectedIndex;
  final bool shoppingCartOpen;
  final bool calendarIsOpen;

  const VerticalSideBar(
    this.selectedIndex,
    this.shoppingCartOpen,
    this.calendarIsOpen,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SideBarItem(
              MdiIcons.notebook,
              selectedIndex == 0 ? Colors.orange : Colors.grey[600],
              I18n.of(context)!.recipes,
              () {
                _changeView(0, context);
              },
            ),
            Divider(),
            SideBarItem(
              Icons.favorite,
              selectedIndex == 1 ? Colors.pink : Colors.grey[600],
              I18n.of(context)!.favorites,
              () {
                _changeView(1, context);
              },
            ),
            Divider(),
            SideBarItem(
              MdiIcons.diceMultiple,
              selectedIndex == 3 ? Colors.green : Colors.grey[600],
              I18n.of(context)!.explore,
              () {
                _changeView(3, context);
              },
            ),
            Divider(),
            SideBarItem(
              Icons.settings,
              selectedIndex == 4 ? Colors.yellow : Colors.grey[600],
              I18n.of(context)!.settings,
              () {
                _changeView(4, context);
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Divider(color: Colors.grey),
            ),
            SideBarItem(
              Icons.shopping_basket,
              shoppingCartOpen ? Colors.brown : Colors.grey[600],
              I18n.of(context)!.shoppingcart,
              () {
                _changeShoppingCartView(context, !shoppingCartOpen);
              },
            ),
            Divider(),
            SideBarItem(
              Icons.calendar_today,
              calendarIsOpen ? Colors.blue : Colors.grey[600],
              I18n.of(context)!.recipe_planer,
              () {
                BlocProvider.of<AppBloc>(context)
                    .add(ChangeRecipeCalendarView(true));
              },
            ),
          ],
        ),
      ),
    );
  }

  /// index 0: recipes
  /// index 1: favorites
  /// index 2: shoppingCart
  /// index 3: random recipes
  /// index 4: settings
  void _changeView(int index, BuildContext context) {
    BlocProvider.of<AppBloc>(context)..add(ChangeView(index, context));
  }

  void _changeShoppingCartView(BuildContext context, bool shoppingCartOpen) {
    BlocProvider.of<AppBloc>(context)
      ..add(ChangeShoppingCartView(shoppingCartOpen));
  }
}

class SideBarItem extends StatelessWidget {
  final Color? selectedColor;
  final IconData icon;
  final String title;
  final Function onPressed;

  const SideBarItem(
    this.icon,
    this.selectedColor,
    this.title,
    this.onPressed, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: selectedColor!.withOpacity(0.3),
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              onPressed();
            },
            splashColor: selectedColor!.withOpacity(0.3),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                width: 150,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      icon,
                      size: 24,
                      color: selectedColor,
                    ),
                    SizedBox(width: 10),
                    Text(
                      title,
                      style: TextStyle(
                          color: selectedColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 14),
                    ),
                    SizedBox(width: 7),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
