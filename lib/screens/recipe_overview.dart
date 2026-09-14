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
import '../models/recipe_sort.dart';
import '../models/string_int_tuple.dart';
import '../widgets/recipe_overview/editorial_recipe_card.dart';
import '../widgets/recipe_overview/recipe_overview_theme.dart';
import 'recipe_screen.dart';

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
  bool _showTagFilters = false;

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

    final controlsHeight = _showTagFilters ? 184.0 : 128.0;
    return CustomScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      slivers: [
        SliverToBoxAdapter(
          child: _OverviewHeader(title: title, recipes: state.allRecipes),
        ),
        if (state.allRecipes.isNotEmpty)
          SliverPersistentHeader(
            pinned: true,
            delegate: _PinnedControlsDelegate(
              height: controlsHeight,
              background: palette.background,
              child: _OverviewControls(
                state: state,
                layout: _layout,
                searchController: _searchController,
                showTagFilters: _showTagFilters,
                onLayoutChanged: (layout) => setState(() => _layout = layout),
                onTagFiltersChanged: (show) =>
                    setState(() => _showTagFilters = show),
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
        final horizontalPadding = 20.0 + math.max(0, (width - 1200) / 2);
        return SliverPadding(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            5,
            horizontalPadding,
            8,
          ),
          sliver: SliverMasonryGrid.count(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 14,
            crossAxisSpacing: 12,
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

  void _clearFilters() {
    _searchController.clear();
    setState(() => _showTagFilters = false);
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

class _OverviewControls extends StatelessWidget {
  const _OverviewControls({
    required this.state,
    required this.layout,
    required this.searchController,
    required this.showTagFilters,
    required this.onLayoutChanged,
    required this.onTagFiltersChanged,
  });

  final LoadedRecipeOverview state;
  final RecipeOverviewCardLayout layout;
  final TextEditingController searchController;
  final bool showTagFilters;
  final ValueChanged<RecipeOverviewCardLayout> onLayoutChanged;
  final ValueChanged<bool> onTagFiltersChanged;

  @override
  Widget build(BuildContext context) {
    final tags = <String>[];
    for (final recipe in state.allRecipes) {
      for (final tag in recipe.tags) {
        if (tag.text != state.recipeTag?.text && !tags.contains(tag.text)) {
          tags.add(tag.text);
        }
      }
    }

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1240),
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
            child: Column(
              children: [
                Row(
                  children: [
                    _ViewSwitch(layout: layout, onChanged: onLayoutChanged),
                    const SizedBox(width: 9),
                    Expanded(
                      child: _InlineSearch(controller: searchController),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                SizedBox(
                  height: 48,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _SortMenu(recipeSort: state.recipeSort),
                      if (state.vegetable == null) ...[
                        const _ControlDivider(),
                        _DietFilter(
                          label: S.of(context).all_recipes_filter,
                          count: state.allRecipes.length,
                          selected: state.selectedVegetable == null,
                          onTap: () => context.read<RecipeOverviewBloc>().add(
                            const FilterRecipesVegetable(null),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _DietFilter(
                          label: S.of(context).vegetarian,
                          count: _dietCount(Vegetable.VEGETARIAN),
                          selected:
                              state.selectedVegetable == Vegetable.VEGETARIAN,
                          vegetable: Vegetable.VEGETARIAN,
                          onTap: () => context.read<RecipeOverviewBloc>().add(
                            const FilterRecipesVegetable(Vegetable.VEGETARIAN),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _DietFilter(
                          label: S.of(context).vegan,
                          count: _dietCount(Vegetable.VEGAN),
                          selected: state.selectedVegetable == Vegetable.VEGAN,
                          vegetable: Vegetable.VEGAN,
                          onTap: () => context.read<RecipeOverviewBloc>().add(
                            const FilterRecipesVegetable(Vegetable.VEGAN),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _DietFilter(
                          label: S.of(context).with_meat,
                          count: _dietCount(Vegetable.NON_VEGETARIAN),
                          selected:
                              state.selectedVegetable ==
                              Vegetable.NON_VEGETARIAN,
                          vegetable: Vegetable.NON_VEGETARIAN,
                          onTap: () => context.read<RecipeOverviewBloc>().add(
                            const FilterRecipesVegetable(
                              Vegetable.NON_VEGETARIAN,
                            ),
                          ),
                        ),
                      ],
                      if (tags.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        _ControlChip(
                          icon: Icons.tune_rounded,
                          label: S.of(context).more_filters,
                          selected: showTagFilters,
                          onTap: () => onTagFiltersChanged(!showTagFilters),
                        ),
                      ],
                    ],
                  ),
                ),
                if (showTagFilters) ...[
                  const SizedBox(height: 4),
                  SizedBox(
                    height: 48,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: tags.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final tag = tags[index];
                        final selected = state.selectedRecipeTags.contains(tag);
                        return _ControlChip(
                          label: '#$tag',
                          selected: selected,
                          onTap: () {
                            final selection = List<String>.from(
                              state.selectedRecipeTags,
                            );
                            selected
                                ? selection.remove(tag)
                                : selection.add(tag);
                            context.read<RecipeOverviewBloc>().add(
                              FilterRecipesTag(selection),
                            );
                          },
                        );
                      },
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

  int _dietCount(Vegetable vegetable) =>
      state.allRecipes.where((recipe) => recipe.vegetable == vegetable).length;
}

class _ViewSwitch extends StatelessWidget {
  const _ViewSwitch({required this.layout, required this.onChanged});

  final RecipeOverviewCardLayout layout;
  final ValueChanged<RecipeOverviewCardLayout> onChanged;

  @override
  Widget build(BuildContext context) {
    final palette = RecipeOverviewPalette.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.surfaceContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ViewChoice(
            key: const Key('recipe-overview-grid-toggle'),
            icon: Icons.grid_view_rounded,
            label: S.of(context).grid_view,
            selected: layout == RecipeOverviewCardLayout.grid,
            onTap: () => onChanged(RecipeOverviewCardLayout.grid),
          ),
          _ViewChoice(
            key: const Key('recipe-overview-list-toggle'),
            icon: Icons.view_agenda_outlined,
            label: S.of(context).list_view,
            selected: layout == RecipeOverviewCardLayout.list,
            onTap: () => onChanged(RecipeOverviewCardLayout.list),
          ),
        ],
      ),
    );
  }
}

class _ViewChoice extends StatelessWidget {
  const _ViewChoice({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = RecipeOverviewPalette.of(context);
    return Semantics(
      button: true,
      selected: selected,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: AnimatedContainer(
          duration: MediaQuery.disableAnimationsOf(context)
              ? Duration.zero
              : const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 9),
          decoration: BoxDecoration(
            color: selected ? palette.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: palette.shadow,
                      offset: const Offset(0, 1),
                      blurRadius: 5,
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 17,
                color: selected ? palette.primary : palette.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: RecipeOverviewType.body(
                  palette,
                  size: 11,
                  weight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected
                      ? palette.onSurface
                      : palette.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InlineSearch extends StatelessWidget {
  const _InlineSearch({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final palette = RecipeOverviewPalette.of(context);
    return SizedBox(
      height: 48,
      child: TextField(
        key: const Key('recipe-overview-search'),
        controller: controller,
        onChanged: (query) =>
            context.read<RecipeOverviewBloc>().add(FilterRecipesQuery(query)),
        textInputAction: TextInputAction.search,
        style: RecipeOverviewType.body(palette, size: 12),
        cursorColor: palette.primary,
        decoration: InputDecoration(
          hintText: S.of(context).filter_recipes,
          hintStyle: RecipeOverviewType.body(
            palette,
            size: 12,
            color: palette.outline,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            size: 19,
            color: palette.outline,
          ),
          suffixIcon: controller.text.isEmpty
              ? null
              : IconButton(
                  tooltip: S.of(context).clear_search,
                  onPressed: () {
                    controller.clear();
                    context.read<RecipeOverviewBloc>().add(
                      const FilterRecipesQuery(''),
                    );
                  },
                  icon: const Icon(Icons.close_rounded, size: 18),
                ),
          filled: true,
          fillColor: palette.surfaceContainer,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999),
            borderSide: BorderSide(color: palette.primary, width: 1.5),
          ),
        ),
      ),
    );
  }
}

class _SortMenu extends StatelessWidget {
  const _SortMenu({required this.recipeSort});

  final RSort recipeSort;

  @override
  Widget build(BuildContext context) {
    final palette = RecipeOverviewPalette.of(context);
    return PopupMenuButton<Object>(
      tooltip: S.of(context).sort_by(_sortLabel(context, recipeSort.sort)),
      color: palette.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 6,
      onSelected: (value) {
        if (value is RecipeSort) {
          context.read<RecipeOverviewBloc>().add(ChangeRecipeSort(value));
        } else if (value is bool) {
          context.read<RecipeOverviewBloc>().add(ChangeAscending(value));
        }
      },
      itemBuilder: (context) => [
        for (final sort in RecipeSort.values)
          PopupMenuItem<Object>(
            value: sort,
            child: _MenuRow(
              label: _sortLabel(context, sort),
              selected: recipeSort.sort == sort,
            ),
          ),
        const PopupMenuDivider(),
        PopupMenuItem<Object>(
          value: true,
          child: _MenuRow(
            label: S.of(context).ascending,
            selected: recipeSort.ascending == true,
          ),
        ),
        PopupMenuItem<Object>(
          value: false,
          child: _MenuRow(
            label: S.of(context).descending,
            selected: recipeSort.ascending == false,
          ),
        ),
      ],
      child: _ControlChip(
        icon: recipeSort.ascending == true
            ? Icons.arrow_upward_rounded
            : Icons.arrow_downward_rounded,
        trailingIcon: Icons.expand_more_rounded,
        label: S.of(context).sort_by(_sortLabel(context, recipeSort.sort)),
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

class _MenuRow extends StatelessWidget {
  const _MenuRow({required this.label, required this.selected});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final palette = RecipeOverviewPalette.of(context);
    return Row(
      children: [
        SizedBox(
          width: 28,
          child: selected
              ? Icon(Icons.check_rounded, size: 18, color: palette.primary)
              : null,
        ),
        Text(label, style: RecipeOverviewType.body(palette, size: 13)),
      ],
    );
  }
}

class _DietFilter extends StatelessWidget {
  const _DietFilter({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
    this.vegetable,
  });

  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;
  final Vegetable? vegetable;

  @override
  Widget build(BuildContext context) {
    final palette = RecipeOverviewPalette.of(context);
    final isProduce =
        vegetable == Vegetable.VEGAN || vegetable == Vegetable.VEGETARIAN;
    return _ControlChip(
      label: '$label ($count)',
      icon: vegetable == null
          ? null
          : isProduce
          ? Icons.eco_rounded
          : Icons.restaurant_rounded,
      selected: selected,
      selectedColor: vegetable == null
          ? palette.primary
          : isProduce
          ? palette.secondary
          : palette.primary,
      onTap: onTap,
    );
  }
}

class _ControlChip extends StatelessWidget {
  const _ControlChip({
    required this.label,
    this.icon,
    this.trailingIcon,
    this.selected = false,
    this.selectedColor,
    this.onTap,
  });

  final String label;
  final IconData? icon;
  final IconData? trailingIcon;
  final bool selected;
  final Color? selectedColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = RecipeOverviewPalette.of(context);
    final activeColor = selectedColor ?? palette.primary;
    final foreground = selected ? palette.onPrimary : palette.onSurfaceVariant;
    return Semantics(
      button: onTap != null,
      selected: selected,
      child: Material(
        color: selected ? activeColor : palette.surfaceContainer,
        borderRadius: BorderRadius.circular(999),
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: onTap,
          child: SizedBox(
            height: 48,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 11),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 16, color: foreground),
                    const SizedBox(width: 4),
                  ],
                  Text(
                    label,
                    style: RecipeOverviewType.body(
                      palette,
                      size: 11,
                      weight: selected ? FontWeight.w700 : FontWeight.w600,
                      color: foreground,
                    ),
                  ),
                  if (trailingIcon != null) ...[
                    const SizedBox(width: 2),
                    Icon(trailingIcon, size: 16, color: foreground),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ControlDivider extends StatelessWidget {
  const _ControlDivider();

  @override
  Widget build(BuildContext context) {
    final palette = RecipeOverviewPalette.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 11),
      child: Container(width: 1, color: palette.outline.withAlpha(100)),
    );
  }
}

class _PinnedControlsDelegate extends SliverPersistentHeaderDelegate {
  const _PinnedControlsDelegate({
    required this.height,
    required this.background,
    required this.child,
  });

  final double height;
  final Color background;
  final Widget child;

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background.withAlpha(250),
        boxShadow: overlapsContent
            ? const [
                BoxShadow(
                  color: Color(0x10000000),
                  offset: Offset(0, 2),
                  blurRadius: 8,
                ),
              ]
            : null,
      ),
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant _PinnedControlsDelegate oldDelegate) =>
      height != oldDelegate.height ||
      background != oldDelegate.background ||
      child != oldDelegate.child;
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
