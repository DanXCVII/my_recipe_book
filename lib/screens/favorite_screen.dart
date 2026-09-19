import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../ad_related/ad.dart';
import '../blocs/favorite_recipes/favorite_recipes_bloc.dart';
import '../blocs/recipe_calendar/recipe_calendar_bloc.dart';
import '../blocs/recipe_manager/recipe_manager_bloc.dart';
import '../blocs/shopping_cart/shopping_cart_bloc.dart';
import '../constants/global_settings.dart';
import '../constants/routes.dart';
import '../generated/l10n.dart';
import '../models/recipe.dart';
import '../widgets/culinary_editorial_theme.dart';
import '../widgets/recipe_overview/recipe_collection_controls.dart';
import '../widgets/recipe_overview/editorial_recipe_card.dart';
import 'recipe_screen.dart';
import 'cook_mode_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  static const _layoutPreferenceKey = 'favoriteRecipeCardLayout';

  final TextEditingController _searchController = TextEditingController();
  RecipeOverviewCardLayout _layout = RecipeOverviewCardLayout.list;

  @override
  void initState() {
    super.initState();
    _restoreLayout();
  }

  Future<void> _restoreLayout() async {
    final preferences = await SharedPreferences.getInstance();
    if (!mounted) return;
    final stored = preferences.getString(_layoutPreferenceKey);
    setState(() {
      _layout = stored == RecipeOverviewCardLayout.grid.name
          ? RecipeOverviewCardLayout.grid
          : RecipeOverviewCardLayout.list;
    });
  }

  Future<void> _setLayout(RecipeOverviewCardLayout layout) async {
    if (_layout == layout) return;
    setState(() => _layout = layout);
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_layoutPreferenceKey, layout.name);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return ColoredBox(
      color: palette.background,
      child: SafeArea(
        bottom: false,
        child: BlocBuilder<FavoriteRecipesBloc, FavoriteRecipesState>(
          builder: (context, state) {
            if (state is LoadedFavorites &&
                state.query.isEmpty &&
                _searchController.text.isNotEmpty) {
              _searchController.clear();
            }
            return CustomScrollView(
              key: const Key('bookmarks-scroll-view'),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              slivers: [
                SliverToBoxAdapter(
                  child: _BookmarksHeader(
                    recipeCount: state is LoadedFavorites
                        ? state.allRecipes.length
                        : null,
                  ),
                ),
                if (state is LoadedFavorites && state.allRecipes.isNotEmpty)
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: RecipeCollectionControlsHeaderDelegate(
                      height: 115,
                      background: palette.background,
                      child: _BookmarksControlCluster(
                        state: state,
                        layout: _layout,
                        onLayoutChanged: _setLayout,
                        searchController: _searchController,
                      ),
                    ),
                  ),
                ..._contentSlivers(state),
                const SliverToBoxAdapter(child: SizedBox(height: 116)),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Widget> _contentSlivers(FavoriteRecipesState state) {
    if (state is LoadingFavorites) return const [_BookmarksLoading()];
    if (state is FailedFavorites) {
      return [
        _BookmarksMessage(
          icon: Icons.cloud_off_rounded,
          title: S.of(context).recipe_overview_failed,
          description: S.of(context).recipe_overview_failed_description,
          actionLabel: S.of(context).retry,
          onAction: () =>
              context.read<FavoriteRecipesBloc>().add(const LoadFavorites()),
        ),
      ];
    }
    if (state is! LoadedFavorites) return const [];
    if (state.allRecipes.isEmpty) {
      return [
        _BookmarksMessage(
          icon: Icons.bookmark_add_outlined,
          title: S.of(context).no_added_favorites_yet,
          description: S.of(context).bookmarks_empty_description,
        ),
      ];
    }
    if (state.visibleRecipes.isEmpty) {
      return [
        _BookmarksMessage(
          icon: Icons.filter_alt_off_rounded,
          title: S.of(context).no_filtered_recipes,
          description: S.of(context).no_recipes_fit_your_filter,
          actionLabel: S.of(context).clear_filters,
          onAction: _clearFilters,
        ),
      ];
    }
    return [
      if (_layout == RecipeOverviewCardLayout.grid)
        _buildGrid(state)
      else
        _buildList(state),
    ];
  }

  Widget _buildGrid(LoadedFavorites state) {
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
        final compact = width < 600;
        final horizontalPadding =
            (compact ? 12.0 : 24.0) + math.max(0, (width - 1200) / 2);
        return SliverPadding(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            8,
            horizontalPadding,
            8,
          ),
          sliver: SliverMasonryGrid.count(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: compact ? 8 : 14,
            crossAxisSpacing: compact ? 8 : 12,
            childCount: state.visibleRecipes.length,
            itemBuilder: (context, index) => _cardFor(
              state.visibleRecipes[index],
              RecipeOverviewCardLayout.grid,
            ),
          ),
        );
      },
    );
  }

  Widget _buildList(LoadedFavorites state) {
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
            8,
            horizontalPadding,
            8,
          ),
          sliver: SliverList.separated(
            itemCount: state.visibleRecipes.length,
            itemBuilder: (context, index) => _cardFor(
              state.visibleRecipes[index],
              RecipeOverviewCardLayout.list,
            ),
            separatorBuilder: (context, index) => const SizedBox(height: 12),
          ),
        );
      },
    );
  }

  Widget _cardFor(Recipe recipe, RecipeOverviewCardLayout layout) {
    final heroImageTag = 'favorites-${recipe.name}';
    return EditorialRecipeCard(
      key: ValueKey('favorite-${layout.name}-${recipe.name}'),
      recipe: recipe,
      heroImageTag: heroImageTag,
      layout: layout,
      onOpen: () => _openRecipe(recipe, heroImageTag),
      onCookAction: recipe.steps.isEmpty ? null : () => _openCookMode(recipe),
      onBookmarkToggle: () =>
          context.read<RecipeManagerBloc>().add(RMRemoveFavorite(recipe)),
    );
  }

  void _clearFilters() {
    _searchController.clear();
    setState(() {});
    context.read<FavoriteRecipesBloc>().add(ClearFavoriteFilters());
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

  void _openCookMode(Recipe recipe) {
    Navigator.pushNamed(
      context,
      RouteNames.cookMode,
      arguments: CookModeArguments(
        recipe: recipe,
        effectiveIngredients: recipe.ingredients,
      ),
    );
  }
}

class _BookmarksHeader extends StatelessWidget {
  const _BookmarksHeader({required this.recipeCount});

  final int? recipeCount;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final summary = recipeCount == null
        ? null
        : S.of(context).bookmark_recipe_count(recipeCount!);

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1240),
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).bookmarked_recipes,
                  style: CulinaryEditorialType.headline(
                    palette,
                    size: 30,
                    weight: FontWeight.w600,
                    height: 1.08,
                  ),
                ),
                if (summary != null) ...[
                  const SizedBox(height: 7),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: palette.secondary,
                          shape: BoxShape.circle,
                        ),
                        child: const SizedBox.square(dimension: 7),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          summary,
                          style: CulinaryEditorialType.body(
                            palette,
                            size: 13,
                            color: palette.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BookmarksControlCluster extends StatelessWidget {
  const _BookmarksControlCluster({
    required this.state,
    required this.layout,
    required this.onLayoutChanged,
    required this.searchController,
  });

  final LoadedFavorites state;
  final RecipeOverviewCardLayout layout;
  final ValueChanged<RecipeOverviewCardLayout> onLayoutChanged;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1240),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 2, 20, 6),
          child: RecipeCollectionControls(
            keyPrefix: 'bookmarks',
            recipes: state.allRecipes,
            layout: layout,
            searchController: searchController,
            recipeSort: state.recipeSort,
            filters: state.filters,
            onLayoutChanged: onLayoutChanged,
            onQueryChanged: (query) => context.read<FavoriteRecipesBloc>().add(
              FilterFavoritesQuery(query),
            ),
            onSortChanged: (sort) => context.read<FavoriteRecipesBloc>().add(
              ChangeFavoritesSort(sort),
            ),
            onAscendingChanged: (ascending) => context
                .read<FavoriteRecipesBloc>()
                .add(ChangeFavoritesAscending(ascending)),
            onFiltersChanged: (filters) => context
                .read<FavoriteRecipesBloc>()
                .add(UpdateFavoriteFilters(filters)),
          ),
        ),
      ),
    );
  }
}

class _BookmarksLoading extends StatelessWidget {
  const _BookmarksLoading();

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
      sliver: SliverList.separated(
        itemCount: 4,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) => DecoratedBox(
          decoration: BoxDecoration(
            color: palette.surface,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: palette.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const SizedBox.square(dimension: 96),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SkeletonLine(widthFactor: .78, palette: palette),
                      const SizedBox(height: 12),
                      _SkeletonLine(widthFactor: .58, palette: palette),
                      const SizedBox(height: 10),
                      _SkeletonLine(widthFactor: .9, palette: palette),
                    ],
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

class _SkeletonLine extends StatelessWidget {
  const _SkeletonLine({required this.widthFactor, required this.palette});

  final double widthFactor;
  final CulinaryEditorialPalette palette;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      alignment: Alignment.centerLeft,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: palette.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(999),
        ),
        child: const SizedBox(height: 12),
      ),
    );
  }
}

class _BookmarksMessage extends StatelessWidget {
  const _BookmarksMessage({
    required this.icon,
    required this.title,
    required this.description,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String description;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 32, 28, 116),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 48, color: palette.primary),
                const SizedBox(height: 18),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: CulinaryEditorialType.headline(
                    palette,
                    size: 23,
                    weight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: CulinaryEditorialType.body(
                    palette,
                    size: 14,
                    color: palette.onSurfaceVariant,
                  ),
                ),
                if (actionLabel != null && onAction != null) ...[
                  const SizedBox(height: 18),
                  SizedBox(
                    height: 48,
                    child: FilledButton(
                      onPressed: onAction,
                      child: Text(actionLabel!),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
