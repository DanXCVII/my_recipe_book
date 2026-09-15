import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../blocs/recipe_calendar/recipe_calendar_bloc.dart';
import '../blocs/shopping_cart/shopping_cart_bloc.dart';
import '../generated/l10n.dart';
import '../widgets/calendar/editorial_weekly_planner.dart';
import '../widgets/culinary_editorial_theme.dart';

class RecipeCalendarScreenArguments {
  const RecipeCalendarScreenArguments(
    this.recipeCalendarBloc,
    this.shoppingCartBloc,
  );

  final RecipeCalendarBloc recipeCalendarBloc;
  final ShoppingCartBloc shoppingCartBloc;
}

class RecipeCalendarScreen extends StatelessWidget {
  const RecipeCalendarScreen({this.width, this.height, super.key});

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final dark = Theme.of(context).brightness == Brightness.dark;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: dark ? Brightness.light : Brightness.dark,
        statusBarBrightness: dark ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: palette.background,
        systemNavigationBarIconBrightness: dark
            ? Brightness.light
            : Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: palette.background,
        appBar: AppBar(
          backgroundColor: palette.background,
          foregroundColor: palette.onSurfaceVariant,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          toolbarHeight: 58,
          leading: const BackButton(),
          titleSpacing: 0,
          title: Text(
            S.of(context).recipe_planer,
            style: CulinaryEditorialType.body(
              palette,
              size: 13,
              weight: FontWeight.w600,
              color: palette.onSurfaceVariant,
              letterSpacing: 0.2,
            ),
          ),
        ),
        body: SafeArea(
          top: false,
          bottom: false,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: const RecipeCalendarContent(),
            ),
          ),
        ),
      ),
    );
  }
}

class RecipeCalendarContent extends StatelessWidget {
  const RecipeCalendarContent({
    this.height,
    this.width,
    this.embedded = false,
    super.key,
  });

  final double? height;
  final double? width;
  final bool embedded;

  @override
  Widget build(BuildContext context) =>
      EditorialWeeklyPlanner(embedded: embedded);
}
