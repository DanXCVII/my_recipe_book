import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../ad_related/ad.dart';
import '../blocs/recipe_calendar/recipe_calendar_bloc.dart';
import '../blocs/recipe_manager/recipe_manager_bloc.dart';
import '../blocs/recipe_overview/recipe_overview_bloc.dart';
import '../blocs/shopping_cart/shopping_cart_bloc.dart';
import '../constants/global_constants.dart' as constants;
import '../constants/global_settings.dart';
import '../constants/routes.dart';
import '../generated/l10n.dart';
import '../models/enums.dart';
import '../models/recipe.dart';
import '../models/string_int_tuple.dart';
import '../widgets/recipe_overview/recipe_collection_controls.dart';
import '../widgets/recipe_overview/editorial_recipe_card.dart';
import '../widgets/recipe_overview/recipe_overview_theme.dart';
import 'recipe_screen.dart';
import 'cook_mode_screen.dart';

class RecipeGridViewArguments {
  final String? category;
  final Vegetable? vegetable;
  final StringIntTuple? recipeTag;
  final ShoppingCartBloc shoppingCartBloc;
  final RecipeCalendarBloc recipeCalendarBloc;

  RecipeGridViewArguments({
    this.category,
    this.vegetable,
    this.recipeTag,
    required this.shoppingCartBloc,
    required this.recipeCalendarBloc,
  });
}

class RecipeGridView extends StatefulWidget {
  const RecipeGridView({super.key});

  @override
  State<RecipeGridView> createState() => _RecipeGridViewState();
}

class _RecipeGridViewState extends State<RecipeGridView> {
  final TextEditingController _searchController = TextEditingController();
  RecipeOverviewCardLayout _layout = RecipeOverviewCardLayout.grid;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = RecipeOverviewPalette.of(context);
    return BlocBuilder<RecipeOverviewBloc, RecipeOverviewState>(
      builder: (context, state) {
        final title = _titleForState(context, state);
        return Scaffold(
          backgroundColor: palette.background,
          appBar: _buildAppBar(context, palette),
          body: state is LoadedRecipeOverview
              ? _buildLoaded(context, state, title, palette)
              : state is LoadingRecipeOverview || state is LoadingRecipes
              ? _LoadingOverview(title: title)
              : state is FailedRecipeOverview
              ? _FailureOverview(title: title)
              : const SizedBox.shrink(),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    RecipeOverviewPalette palette,
  ) {
    return AppBar(
      backgroundColor: palette.background,
      foregroundColor: palette.onSurfaceVariant,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      toolbarHeight: 58,
      leading: const BackButton(),
      titleSpacing: 0,
      title: Text(
        S.of(context).recipes,
        style: RecipeOverviewType.body(
          palette,
          size: 13,
          weight: FontWeight.w600,
          color: palette.onSurfaceVariant,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Widget _buildLoaded(
    BuildContext context,
    LoadedRecipeOverview state,
    String title,
    RecipeOverviewPalette palette,
  ) {
    if (state.query.isEmpty && _searchController.text.isNotEmpty) {
      _searchController.clear();
    }

    const controlsHeight = 115.0;
    return CustomScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      slivers: [
        SliverToBoxAdapter(
          child: _OverviewHeader(title: title, recipes: state.allRecipes),
        ),
        if (state.allRecipes.isNotEmpty)
          SliverPersistentHeader(
            pinned: true,
            delegate: RecipeCollectionControlsHeaderDelegate(
              height: controlsHeight,
              background: palette.background,
              child: _OverviewControlCluster(
                state: state,
                layout: _layout,
                searchController: _searchController,
                onLayoutChanged: (layout) => setState(() => _layout = layout),
              ),
            ),
          ),
        if (state.allRecipes.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: _EmptyOverview(
              title: S.of(context).no_recipes_in_collection,
              description: _baseEmptyDescription(context, state),
            ),
          )
        else if (state.visibleRecipes.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: _EmptyOverview(
              title: S.of(context).no_filtered_recipes,
              description: S.of(context).no_recipes_fit_your_filter,
              actionLabel: S.of(context).clear_filters,
              onAction: _clearFilters,
            ),
          )
        else if (_layout == RecipeOverviewCardLayout.grid)
          _buildGrid(state)
        else
          _buildList(state),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }

  String _baseEmptyDescription(
    BuildContext context,
    LoadedRecipeOverview state,
  ) {
    if (state.recipeTag != null) return S.of(context).no_recipes_with_this_tag;
    if (state.vegetable != null) return S.of(context).no_recipes_for_diet;
    return S.of(context).no_recipes_under_this_category;
  }

  Widget _buildGrid(LoadedRecipeOverview state) {
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.crossAxisExtent;
        if (width <= 40) {
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }
        final crossAxisCount = width < 600
            ? 2
            : width < 900
            ? 3
            : 4;
        final isCompact = width < 600;
        final horizontalPadding =
            (isCompact ? 10.0 : 20.0) + math.max(0, (width - 1200) / 2);
        return SliverPadding(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            5,
            horizontalPadding,
            8,
          ),
          sliver: SliverMasonryGrid.count(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: isCompact ? 6 : 14,
            crossAxisSpacing: isCompact ? 6 : 12,
            childCount: state.visibleRecipes.length,
            itemBuilder: (context, index) => _cardFor(
              context,
              state,
              state.visibleRecipes[index],
              RecipeOverviewCardLayout.grid,
            ),
          ),
        );
      },
    );
  }

  Widget _buildList(LoadedRecipeOverview state) {
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.crossAxisExtent;
        if (width <= 40) {
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }
        final horizontalPadding = 20.0 + math.max(0, (width - 860) / 2);
        return SliverPadding(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            5,
            horizontalPadding,
            8,
          ),
          sliver: SliverList.separated(
            itemCount: state.visibleRecipes.length,
            itemBuilder: (context, index) => _cardFor(
              context,
              state,
              state.visibleRecipes[index],
              RecipeOverviewCardLayout.list,
            ),
            separatorBuilder: (context, index) => const SizedBox(height: 12),
          ),
        );
      },
    );
  }

  Widget _cardFor(
    BuildContext context,
    LoadedRecipeOverview state,
    Recipe recipe,
    RecipeOverviewCardLayout layout,
  ) {
    final contextKey =
        state.category ??
        state.vegetable?.name ??
        state.recipeTag?.text ??
        'recipes';
    return EditorialRecipeCard(
      key: ValueKey('${layout.name}-${recipe.name}'),
      recipe: recipe,
      heroImageTag: '$contextKey-${recipe.name}',
      layout: layout,
      onOpen: () => _openRecipe(context, recipe, '$contextKey-${recipe.name}'),
      onCookAction: recipe.steps.isEmpty
          ? null
          : () => _openCookMode(context, recipe),
      onBookmarkToggle: () {
        final manager = context.read<RecipeManagerBloc>();
        manager.add(
          recipe.isFavorite ? RMRemoveFavorite(recipe) : RMAddFavorite(recipe),
        );
      },
    );
  }

  void _openRecipe(BuildContext context, Recipe recipe, String heroImageTag) {
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

  void _openCookMode(BuildContext context, Recipe recipe) {
    Navigator.pushNamed(
      context,
      RouteNames.cookMode,
      arguments: CookModeArguments(
        recipe: recipe,
        effectiveIngredients: recipe.ingredients,
      ),
    );
  }

  void _clearFilters() {
    _searchController.clear();
    context.read<RecipeOverviewBloc>().add(ClearRecipeFilters());
  }

  String _titleForState(BuildContext context, RecipeOverviewState state) {
    String? category;
    Vegetable? vegetable;
    StringIntTuple? recipeTag;
    if (state is LoadedRecipeOverview) {
      category = state.category;
      vegetable = state.vegetable;
      recipeTag = state.recipeTag;
    } else if (state is LoadingRecipes) {
      category = state.category;
      vegetable = state.vegetable;
      recipeTag = state.recipeTag;
    } else if (state is FailedRecipeOverview) {
      category = state.category;
      vegetable = state.vegetable;
      recipeTag = state.recipeTag;
    }

    if (category != null) {
      if (category == constants.noCategory) return S.of(context).no_category;
      if (category == constants.allCategories) {
        return S.of(context).all_categories;
      }
      return category;
    }
    if (vegetable == Vegetable.NON_VEGETARIAN) {
      return S.of(context).with_meat;
    }
    if (vegetable == Vegetable.VEGETARIAN) {
      return S.of(context).vegetarian;
    }
    if (vegetable == Vegetable.VEGAN) return S.of(context).vegan;
    return recipeTag?.text ?? S.of(context).recipes;
  }
}

class _OverviewHeader extends StatelessWidget {
  const _OverviewHeader({required this.title, required this.recipes});

  final String title;
  final List<Recipe> recipes;

  @override
  Widget build(BuildContext context) {
    final palette = RecipeOverviewPalette.of(context);
    final efforts = recipes
        .map((recipe) => recipe.effort)
        .whereType<int>()
        .toList();
    final averageEffort = efforts.isEmpty
        ? null
        : efforts.reduce((first, second) => first + second) / efforts.length;
    final effortLabel = averageEffort == null
        ? null
        : NumberFormat(
            '0.0',
            Localizations.localeOf(context).toLanguageTag(),
          ).format(averageEffort);

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1240),
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 3, 20, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: RecipeOverviewType.headline(palette)),
                const SizedBox(height: 7),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: palette.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.local_fire_department_rounded,
                          size: 15,
                          color: palette.primary,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          effortLabel == null
                              ? S.of(context).recipe_count(recipes.length)
                              : S
                                    .of(context)
                                    .recipe_summary_with_effort(
                                      recipes.length,
                                      effortLabel,
                                    ),
                          style: RecipeOverviewType.body(
                            palette,
                            size: 11,
                            weight: FontWeight.w600,
                            color: palette.onSurfaceVariant,
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OverviewControlCluster extends StatelessWidget {
  const _OverviewControlCluster({
    required this.state,
    required this.layout,
    required this.searchController,
    required this.onLayoutChanged,
  });

  final LoadedRecipeOverview state;
  final RecipeOverviewCardLayout layout;
  final TextEditingController searchController;
  final ValueChanged<RecipeOverviewCardLayout> onLayoutChanged;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1240),
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
            child: RecipeCollectionControls(
              keyPrefix: 'recipe-overview',
              recipes: state.allRecipes,
              layout: layout,
              searchController: searchController,
              recipeSort: state.recipeSort,
              filters: state.filters,
              excludedCategory: state.category,
              excludedTag: state.recipeTag?.text,
              includeVegetable: state.vegetable == null,
              onLayoutChanged: onLayoutChanged,
              onQueryChanged: (query) => context.read<RecipeOverviewBloc>().add(
                FilterRecipesQuery(query),
              ),
              onSortChanged: (sort) => context.read<RecipeOverviewBloc>().add(
                ChangeRecipeSort(sort),
              ),
              onAscendingChanged: (ascending) => context
                  .read<RecipeOverviewBloc>()
                  .add(ChangeAscending(ascending)),
              onFiltersChanged: (filters) => context
                  .read<RecipeOverviewBloc>()
                  .add(UpdateRecipeFilters(filters)),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyOverview extends StatelessWidget {
  const _EmptyOverview({
    required this.title,
    required this.description,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String description;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final palette = RecipeOverviewPalette.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 30, 28, 80),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.menu_book_rounded, size: 48, color: palette.primary),
            const SizedBox(height: 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: RecipeOverviewType.headline(
                palette,
                size: 22,
                weight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              description,
              textAlign: TextAlign.center,
              style: RecipeOverviewType.body(
                palette,
                size: 14,
                color: palette.onSurfaceVariant,
              ),
            ),
            if (onAction != null && actionLabel != null) ...[
              const SizedBox(height: 20),
              FilledButton.tonal(
                onPressed: onAction,
                style: FilledButton.styleFrom(
                  minimumSize: const Size(48, 48),
                  backgroundColor: palette.primarySoft,
                  foregroundColor: palette.primary,
                  textStyle: RecipeOverviewType.body(
                    palette,
                    size: 13,
                    weight: FontWeight.w700,
                  ),
                ),
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _FailureOverview extends StatelessWidget {
  const _FailureOverview({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final palette = RecipeOverviewPalette.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 3, 20, 12),
          child: Text(title, style: RecipeOverviewType.headline(palette)),
        ),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 30, 28, 80),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.sync_problem_rounded,
                    size: 48,
                    color: palette.primary,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    S.of(context).recipe_overview_failed,
                    textAlign: TextAlign.center,
                    style: RecipeOverviewType.headline(
                      palette,
                      size: 22,
                      weight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    S.of(context).recipe_overview_failed_description,
                    textAlign: TextAlign.center,
                    style: RecipeOverviewType.body(
                      palette,
                      size: 14,
                      color: palette.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: () => context.read<RecipeOverviewBloc>().add(
                      RetryRecipeOverview(),
                    ),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(48, 48),
                      backgroundColor: palette.primarySoft,
                      foregroundColor: palette.primary,
                      textStyle: RecipeOverviewType.body(
                        palette,
                        size: 13,
                        weight: FontWeight.w700,
                      ),
                    ),
                    icon: const Icon(Icons.refresh_rounded),
                    label: Text(S.of(context).retry),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LoadingOverview extends StatelessWidget {
  const _LoadingOverview({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final palette = RecipeOverviewPalette.of(context);
    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 3, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: RecipeOverviewType.headline(palette)),
                const SizedBox(height: 9),
                _SkeletonBlock(width: 150, height: 24, radius: 999),
                const SizedBox(height: 18),
                const _SkeletonBlock(height: 40, radius: 999),
                const SizedBox(height: 8),
                const _SkeletonBlock(height: 40, radius: 999),
              ],
            ),
          ),
        ),
        SliverLayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.crossAxisExtent;
            if (width <= 40) {
              return const SliverToBoxAdapter(child: SizedBox.shrink());
            }
            final crossAxisCount = width < 600
                ? 2
                : width < 900
                ? 3
                : 4;
            final horizontalPadding = 20.0 + math.max(0, (width - 1200) / 2);
            return SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.68,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => const _SkeletonCard(),
                  childCount: 8,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    final palette = RecipeOverviewPalette.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 4 / 3,
            child: _SkeletonBlock(height: double.infinity, radius: 0),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SkeletonBlock(width: 92, height: 18, radius: 999),
                SizedBox(height: 9),
                _SkeletonBlock(height: 16),
                SizedBox(height: 5),
                _SkeletonBlock(width: 110, height: 16),
                SizedBox(height: 12),
                _SkeletonBlock(width: 76, height: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonBlock extends StatelessWidget {
  const _SkeletonBlock({this.width, required this.height, this.radius = 6});

  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final palette = RecipeOverviewPalette.of(context);
    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: palette.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
