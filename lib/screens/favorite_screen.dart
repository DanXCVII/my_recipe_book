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
import '../constants/global_constants.dart' as constants;
import '../constants/global_settings.dart';
import '../constants/routes.dart';
import '../generated/l10n.dart';
import '../models/enums.dart';
import '../models/recipe.dart';
import '../models/recipe_sort.dart';
import '../widgets/culinary_editorial_theme.dart';
import '../widgets/recipe_overview/editorial_recipe_card.dart';
import '../widgets/recipe_overview/recipe_layout_switch.dart';
import 'recipe_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  static const _layoutPreferenceKey = 'favoriteRecipeCardLayout';

  final TextEditingController _searchController = TextEditingController();
  RecipeOverviewCardLayout _layout = RecipeOverviewCardLayout.list;
  bool _showSearch = false;

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
                    showSearch: _showSearch,
                    onSearchPressed: () {
                      setState(() => _showSearch = !_showSearch);
                    },
                  ),
                ),
                if (_showSearch)
                  SliverToBoxAdapter(
                    child: _BookmarkSearch(
                      controller: _searchController,
                      onChanged: (query) {
                        setState(() {});
                        context.read<FavoriteRecipesBloc>().add(
                          FilterFavoritesQuery(query),
                        );
                      },
                      onClear: () {
                        _searchController.clear();
                        setState(() {});
                        context.read<FavoriteRecipesBloc>().add(
                          const FilterFavoritesQuery(''),
                        );
                      },
                    ),
                  ),
                if (state is LoadedFavorites && state.allRecipes.isNotEmpty)
                  SliverToBoxAdapter(child: _CollectionStrip(state: state)),
                if (state is LoadedFavorites && state.allRecipes.isNotEmpty)
                  SliverToBoxAdapter(
                    child: _BookmarksControls(
                      state: state,
                      layout: _layout,
                      onLayoutChanged: _setLayout,
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
      onCookAction: () => _openRecipe(recipe, heroImageTag),
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
}

class _BookmarksHeader extends StatelessWidget {
  const _BookmarksHeader({
    required this.recipeCount,
    required this.showSearch,
    required this.onSearchPressed,
  });

  final int? recipeCount;
  final bool showSearch;
  final VoidCallback onSearchPressed;

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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
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
                const SizedBox(width: 12),
                _RoundAction(
                  key: const Key('bookmarks-search-toggle'),
                  icon: showSearch ? Icons.close_rounded : Icons.search_rounded,
                  tooltip: S.of(context).search_bookmarks,
                  onPressed: onSearchPressed,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoundAction extends StatelessWidget {
  const _RoundAction({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return SizedBox.square(
      dimension: 48,
      child: IconButton.filledTonal(
        tooltip: tooltip,
        onPressed: onPressed,
        style: IconButton.styleFrom(
          backgroundColor: palette.surfaceContainer,
          foregroundColor: palette.onSurfaceVariant,
        ),
        icon: Icon(icon, size: 21),
      ),
    );
  }
}

class _BookmarkSearch extends StatelessWidget {
  const _BookmarkSearch({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1240),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
          child: SizedBox(
            height: 48,
            child: TextField(
              key: const Key('bookmarks-search-field'),
              controller: controller,
              autofocus: true,
              onChanged: onChanged,
              textInputAction: TextInputAction.search,
              style: CulinaryEditorialType.body(palette, size: 13),
              cursorColor: palette.primary,
              decoration: InputDecoration(
                hintText: S.of(context).search_bookmarks,
                prefixIcon: Icon(
                  Icons.search_rounded,
                  size: 20,
                  color: palette.outline,
                ),
                suffixIcon: controller.text.isEmpty
                    ? null
                    : IconButton(
                        tooltip: S.of(context).clear_search,
                        onPressed: onClear,
                        icon: const Icon(Icons.close_rounded, size: 18),
                      ),
                filled: true,
                fillColor: palette.surfaceContainer,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: palette.primary, width: 1.5),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CollectionStrip extends StatelessWidget {
  const _CollectionStrip({required this.state});

  final LoadedFavorites state;

  @override
  Widget build(BuildContext context) {
    final categories = state.categoryCounts.entries.toList()
      ..sort((first, second) => first.key.compareTo(second.key));
    return SizedBox(
      height: 54,
      child: ListView.separated(
        key: const Key('bookmarks-collection-strip'),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length + 1,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = index == 0 ? null : categories[index - 1].key;
          final count = index == 0
              ? state.allRecipes.length
              : categories[index - 1].value;
          final label = category == null
              ? S.of(context).all_recipes_filter
              : category == constants.noCategory
              ? S.of(context).no_category
              : category;
          return _FilterPill(
            key: ValueKey('bookmarks-category-${category ?? 'all'}'),
            label: '$label ($count)',
            selected: state.selectedCategory == category,
            prominent: true,
            onPressed: () => context.read<FavoriteRecipesBloc>().add(
              FilterFavoritesCategory(category),
            ),
          );
        },
      ),
    );
  }
}

class _BookmarksControls extends StatelessWidget {
  const _BookmarksControls({
    required this.state,
    required this.layout,
    required this.onLayoutChanged,
  });

  final LoadedFavorites state;
  final RecipeOverviewCardLayout layout;
  final ValueChanged<RecipeOverviewCardLayout> onLayoutChanged;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1240),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 2, 20, 6),
          child: Column(
            children: [
              Row(
                children: [
                  RecipeLayoutSwitch(
                    keyPrefix: 'bookmarks',
                    layout: layout,
                    onChanged: onLayoutChanged,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _FavoritesSortMenu(recipeSort: state.recipeSort),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              SizedBox(
                height: 52,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _FilterPill(
                      label: S.of(context).all_recipes_filter,
                      selected: state.selectedVegetable == null,
                      onPressed: () => context.read<FavoriteRecipesBloc>().add(
                        const FilterFavoritesVegetable(null),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _FilterPill(
                      label: S.of(context).with_meat,
                      selected:
                          state.selectedVegetable == Vegetable.NON_VEGETARIAN,
                      onPressed: () => context.read<FavoriteRecipesBloc>().add(
                        const FilterFavoritesVegetable(
                          Vegetable.NON_VEGETARIAN,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _FilterPill(
                      label: S.of(context).vegetarian,
                      selected: state.selectedVegetable == Vegetable.VEGETARIAN,
                      onPressed: () => context.read<FavoriteRecipesBloc>().add(
                        const FilterFavoritesVegetable(Vegetable.VEGETARIAN),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _FilterPill(
                      label: S.of(context).vegan,
                      selected: state.selectedVegetable == Vegetable.VEGAN,
                      onPressed: () => context.read<FavoriteRecipesBloc>().add(
                        const FilterFavoritesVegetable(Vegetable.VEGAN),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({
    super.key,
    required this.label,
    required this.selected,
    required this.onPressed,
    this.prominent = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;
  final bool prominent;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected
            ? prominent
                  ? palette.primary
                  : palette.primarySoft
            : palette.surfaceContainer,
        borderRadius: BorderRadius.circular(999),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(999),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: prominent ? 15 : 13,
                vertical: 12,
              ),
              child: Center(
                child: Text(
                  label,
                  maxLines: 1,
                  style: CulinaryEditorialType.body(
                    palette,
                    size: prominent ? 12.5 : 11.5,
                    weight: selected ? FontWeight.w700 : FontWeight.w600,
                    color: selected && prominent
                        ? palette.onPrimary
                        : selected
                        ? palette.primary
                        : palette.onSurfaceVariant,
                    height: 1,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FavoritesSortMenu extends StatelessWidget {
  const _FavoritesSortMenu({required this.recipeSort});

  final RSort recipeSort;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return PopupMenuButton<Object>(
      tooltip: S.of(context).sort_by(_sortLabel(context, recipeSort.sort)),
      color: palette.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 6,
      onSelected: (value) {
        if (value is RecipeSort) {
          context.read<FavoriteRecipesBloc>().add(ChangeFavoritesSort(value));
        } else if (value is bool) {
          context.read<FavoriteRecipesBloc>().add(
            ChangeFavoritesAscending(value),
          );
        }
      },
      itemBuilder: (context) => [
        for (final sort in RecipeSort.values)
          PopupMenuItem<Object>(
            value: sort,
            child: _SortMenuRow(
              label: _sortLabel(context, sort),
              selected: recipeSort.sort == sort,
            ),
          ),
        const PopupMenuDivider(),
        PopupMenuItem<Object>(
          value: true,
          child: _SortMenuRow(
            label: S.of(context).ascending,
            selected: recipeSort.ascending == true,
          ),
        ),
        PopupMenuItem<Object>(
          value: false,
          child: _SortMenuRow(
            label: S.of(context).descending,
            selected: recipeSort.ascending == false,
          ),
        ),
      ],
      child: SizedBox(
        width: double.infinity,
        child: Material(
          color: palette.surface,
          borderRadius: BorderRadius.circular(999),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SizedBox(
              height: 48,
              child: Row(
                children: [
                  Icon(
                    recipeSort.ascending == true
                        ? Icons.arrow_upward_rounded
                        : Icons.arrow_downward_rounded,
                    size: 17,
                    color: palette.primary,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      _sortLabel(context, recipeSort.sort),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: CulinaryEditorialType.body(
                        palette,
                        size: 11.5,
                        weight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.expand_more_rounded,
                    size: 18,
                    color: palette.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static String _sortLabel(BuildContext context, RecipeSort sort) {
    return switch (sort) {
      RecipeSort.BY_NAME => S.of(context).by_name,
      RecipeSort.BY_EFFORT => S.of(context).by_effort,
      RecipeSort.BY_INGREDIENT_COUNT => S.of(context).by_ingredientsamount,
      RecipeSort.BY_LAST_MODIFIED => S.of(context).by_last_modified,
      RecipeSort.BY_TOTAL_TIME => S.of(context).total_time,
    };
  }
}

class _SortMenuRow extends StatelessWidget {
  const _SortMenuRow({required this.label, required this.selected});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Row(
      children: [
        Icon(
          selected ? Icons.check_rounded : null,
          size: 18,
          color: palette.primary,
        ),
        const SizedBox(width: 8),
        Text(label, style: CulinaryEditorialType.body(palette, size: 13)),
      ],
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
