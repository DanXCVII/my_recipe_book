import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../ad_related/ad.dart';
import '../blocs/recipe_calendar/recipe_calendar_bloc.dart';
import '../blocs/recipe_category_overview/recipe_category_overview_bloc.dart';
import '../blocs/recipe_manager/recipe_manager_bloc.dart';
import '../blocs/shopping_cart/shopping_cart_bloc.dart';
import '../constants/global_settings.dart';
import '../constants/routes.dart';
import '../models/recipe.dart';
import '../widgets/category_overview/dish_of_the_day.dart';
import '../widgets/category_overview/editorial_category_feed.dart';
import '../widgets/culinary_editorial_theme.dart';
import 'recipe_overview.dart';
import 'recipe_screen.dart';

class RecipeCategoryOverview extends StatefulWidget {
  const RecipeCategoryOverview({this.clock, super.key});

  final DateTime Function()? clock;

  @override
  State<RecipeCategoryOverview> createState() => _RecipeCategoryOverviewState();
}

class _RecipeCategoryOverviewState extends State<RecipeCategoryOverview> {
  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return ColoredBox(
      color: palette.background,
      child:
          BlocBuilder<RecipeCategoryOverviewBloc, RecipeCategoryOverviewState>(
            builder: (context, state) {
              final child = switch (state) {
                LoadingRecipeCategoryOverviewState() =>
                  const CategoryOverviewLoading(),
                FailedRecipeCategoryOverviewState() => CategoryOverviewFailure(
                  onRetry: () => context.read<RecipeCategoryOverviewBloc>().add(
                    RCOLoadRecipeCategoryOverview(),
                  ),
                ),
                LoadedRecipeCategoryOverview() => EditorialCategoryFeed(
                  sections: state.rCategoryOverview,
                  featuredRecipe: selectDishOfTheDay(
                    state.rCategoryOverview,
                    (widget.clock ?? DateTime.now)(),
                  ),
                  onOpenRecipe: _openRecipe,
                  onToggleFavorite: _toggleFavorite,
                  onOpenCategory: _openCategory,
                ),
                _ => const CategoryOverviewLoading(),
              };

              return RefreshIndicator(
                key: const Key('category-overview-refresh'),
                color: palette.onPrimary,
                backgroundColor: palette.primary,
                onRefresh: state is LoadingRecipeCategoryOverviewState
                    ? () async {}
                    : _refresh,
                child: child,
              );
            },
          ),
    );
  }

  Future<void> _refresh() async {
    final bloc = context.read<RecipeCategoryOverviewBloc>();
    final completion = bloc.stream.firstWhere(
      (state) =>
          state is LoadedRecipeCategoryOverview ||
          state is FailedRecipeCategoryOverviewState,
    );
    bloc.add(
      RCOLoadRecipeCategoryOverview(
        reopenBoxes: true,
        categoryOverviewContext: context,
      ),
    );
    await completion;
  }

  void _toggleFavorite(Recipe recipe) {
    context.read<RecipeManagerBloc>().add(
      recipe.isFavorite ? RMRemoveFavorite(recipe) : RMAddFavorite(recipe),
    );
  }

  void _openCategory(String category) {
    Navigator.pushNamed(
      context,
      RouteNames.recipeCategories,
      arguments: RecipeGridViewArguments(
        shoppingCartBloc: context.read<ShoppingCartBloc>(),
        recipeCalendarBloc: context.read<RecipeCalendarBloc>(),
        category: category,
      ),
    ).then((_) => Ads.hideBottomBannerAd());
  }

  void _openRecipe(Recipe recipe, String heroImageTag) {
    if (GlobalSettings().standbyDisabled()) WakelockPlus.enable();
    Navigator.pushNamed(
      context,
      RouteNames.recipeScreen,
      arguments: RecipeScreenArguments(
        context.read<ShoppingCartBloc>(),
        context.read<RecipeCalendarBloc>(),
        recipe,
        heroImageTag,
        context.read<RecipeManagerBloc>(),
      ),
    ).then((_) {
      WakelockPlus.disable();
      Ads.hideBottomBannerAd();
    });
  }
}
