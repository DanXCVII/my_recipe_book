import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../blocs/ad_manager/ad_manager_bloc.dart';
import '../blocs/ingredient_search/ingredient_search_bloc.dart';
import '../blocs/recipe_calendar/recipe_calendar_bloc.dart';
import '../blocs/recipe_manager/recipe_manager_bloc.dart';
import '../blocs/shopping_cart/shopping_cart_bloc.dart';
import '../constants/global_constants.dart' as constants;
import '../constants/global_settings.dart';
import '../constants/routes.dart';
import '../generated/l10n.dart';
import '../local_storage/local_repository.dart';
import '../models/enums.dart';
import '../models/recipe.dart';
import '../models/string_int_tuple.dart';
import '../widgets/culinary_editorial_theme.dart';
import '../widgets/ingredient_search/editorial_ingredient_search_card.dart';
import 'recipe_screen.dart';

const double ingredientSearchTwoPaneBreakpoint = 720;
const int ingredientSearchMaximumIngredients = 20;

class IngredientSearchScreenArguments {
  const IngredientSearchScreenArguments(
    this.shoppingCartBloc,
    this.recipeCalendarBloc,
    this.adManagerBloc,
    this.hasPremium,
  );

  final Bloc<AdManagerEvent, AdManagerState> adManagerBloc;
  final ShoppingCartBloc shoppingCartBloc;
  final RecipeCalendarBloc recipeCalendarBloc;
  final bool hasPremium;
}

class IngredientSearchScreen extends StatefulWidget {
  const IngredientSearchScreen({super.key});

  @override
  State<IngredientSearchScreen> createState() => _IngredientSearchScreenState();
}

class _IngredientSearchScreenState extends State<IngredientSearchScreen> {
  final List<String> _ingredients = [];
  final List<String> _selectedCategories = [];
  final List<StringIntTuple> _selectedRecipeTags = [];

  late final List<String> _ingredientSuggestions;
  late final List<String> _categories;
  late final List<StringIntTuple> _recipeTags;
  TextEditingController? _fieldController;
  FocusNode? _fieldFocusNode;
  Vegetable? _selectedVegetable;
  int? _maxTotalTimeMinutes;
  int? _maxEffort;
  IngredientSearchSort _sort = IngredientSearchSort.bestMatch;

  @override
  void initState() {
    super.initState();
    final repository = context.read<LocalRepository>();
    _ingredientSuggestions = repository.getIngredientNames();
    _categories = repository.getCategoryNames();
    _recipeTags = repository.getRecipeTags();
  }

  IngredientSearchCriteria get _criteria => IngredientSearchCriteria(
    ingredients: List.unmodifiable(_ingredients),
    categories: List.unmodifiable(_selectedCategories),
    recipeTags: List.unmodifiable(_selectedRecipeTags),
    vegetable: _selectedVegetable,
    maxTotalTimeMinutes: _maxTotalTimeMinutes,
    maxEffort: _maxEffort,
    sort: _sort,
  );

  void _dispatchSearch() {
    context.read<IngredientSearchBloc>().add(UpdateIngredientSearch(_criteria));
  }

  void _updateSearch(VoidCallback update) {
    setState(update);
    _dispatchSearch();
  }

  void _addIngredient([String? value]) {
    final ingredient = (value ?? _fieldController?.text ?? '').trim();
    if (ingredient.isEmpty) return;
    if (_ingredients.any(
      (existing) => existing.toLowerCase() == ingredient.toLowerCase(),
    )) {
      _fieldController?.clear();
      _fieldFocusNode?.requestFocus();
      return;
    }
    if (_ingredients.length >= ingredientSearchMaximumIngredients) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            S
                .of(context)
                .ingredient_search_limit(ingredientSearchMaximumIngredients),
          ),
        ),
      );
      return;
    }
    _updateSearch(() => _ingredients.add(ingredient));
    _fieldController?.clear();
    _fieldFocusNode?.requestFocus();
  }

  void _removeIngredient(String ingredient) {
    _updateSearch(() => _ingredients.remove(ingredient));
  }

  void _clearIngredients() {
    if (_ingredients.isEmpty) return;
    _updateSearch(_ingredients.clear);
  }

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final baseTheme = Theme.of(context);
    final editorialTheme = culinaryEditorialTheme(baseTheme, palette);
    return Theme(
      data: editorialTheme,
      child: Scaffold(
        backgroundColor: palette.background,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: palette.background,
          foregroundColor: palette.onSurface,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          title: Text(
            S.of(context).ingredient_search_title,
            style: CulinaryEditorialType.body(
              palette,
              size: 16,
              weight: FontWeight.w700,
            ),
          ),
        ),
        body: SafeArea(
          top: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth >= ingredientSearchTwoPaneBreakpoint) {
                return _buildTwoPane(context, constraints.maxWidth);
              }
              return _buildPhone(context);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPhone(BuildContext context) {
    return BlocBuilder<IngredientSearchBloc, IngredientSearchState>(
      builder: (context, state) => CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            sliver: SliverToBoxAdapter(child: _SearchWorkspace(state: state)),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 10),
            sliver: SliverToBoxAdapter(child: _ResultsHeader(state: state)),
          ),
          ..._resultSlivers(state, horizontalPadding: 20),
          const SliverToBoxAdapter(child: SizedBox(height: 28)),
        ],
      ),
    );
  }

  Widget _buildTwoPane(BuildContext context, double width) {
    final palette = CulinaryEditorialPalette.of(context);
    final workspaceWidth = width >= 1000 ? 400.0 : 360.0;
    return BlocBuilder<IngredientSearchBloc, IngredientSearchState>(
      builder: (context, state) => Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: workspaceWidth,
            child: ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.fromLTRB(28, 20, 20, 28),
              children: [_SearchWorkspace(state: state)],
            ),
          ),
          VerticalDivider(
            width: 1,
            thickness: 1,
            color: palette.surfaceContainerHigh,
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(28, 24, 28, 12),
                  sliver: SliverToBoxAdapter(
                    child: _ResultsHeader(state: state),
                  ),
                ),
                ..._resultSlivers(state, horizontalPadding: 28),
                const SliverToBoxAdapter(child: SizedBox(height: 28)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _resultSlivers(
    IngredientSearchState state, {
    required double horizontalPadding,
  }) {
    if (state is IngredientSearchInitial) {
      return [
        SliverToBoxAdapter(
          child: SizedBox(
            height: 400,
            child: _SearchStateMessage(
              icon: Icons.kitchen_rounded,
              title: S.of(context).ingredient_search_empty_title,
              description: S.of(context).ingredient_search_empty_description,
            ),
          ),
        ),
      ];
    }
    if (state is SearchingRecipes) {
      return const [
        SliverToBoxAdapter(
          child: SizedBox(
            height: 220,
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
      ];
    }
    if (state is IngredientSearchFailure) {
      return [
        SliverToBoxAdapter(
          child: SizedBox(
            height: 360,
            child: _SearchStateMessage(
              icon: Icons.cloud_off_rounded,
              title: S.of(context).ingredient_search_failed,
              description: S.of(context).ingredient_search_failed_description,
              actionLabel: S.of(context).retry,
              onAction: () => context.read<IngredientSearchBloc>().add(
                RetryIngredientSearch(_criteria),
              ),
            ),
          ),
        ),
      ];
    }

    final matches = state as IngredientSearchMatches;
    if (matches.results.isEmpty) {
      return [
        SliverToBoxAdapter(
          child: SizedBox(
            height: 360,
            child: _SearchStateMessage(
              icon: Icons.search_off_rounded,
              title: S.of(context).ingredient_search_no_matches,
              description: S
                  .of(context)
                  .ingredient_search_no_matches_description,
              actionLabel: S.of(context).ingredient_search_adjust_filters,
              onAction: _showAdvancedFilters,
            ),
          ),
        ),
      ];
    }

    return [
      SliverPadding(
        padding: EdgeInsets.fromLTRB(
          horizontalPadding,
          0,
          horizontalPadding,
          0,
        ),
        sliver: SliverList.separated(
          itemCount: matches.results.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final result = matches.results[index];
            final heroImageTag =
                'ingredient-search-${result.recipe.name}-${result.recipe.lastModified}';
            return EditorialIngredientSearchCard(
              key: Key('ingredient-search-result-${result.recipe.name}'),
              recipe: result.recipe,
              matchedIngredientCount: result.matchedIngredientCount,
              selectedIngredientCount: matches.criteria.ingredients.length,
              heroImageTag: heroImageTag,
              onOpen: () => _openRecipe(result.recipe, heroImageTag),
              onBookmarkToggle: () => _toggleFavorite(result.recipe),
            );
          },
        ),
      ),
    ];
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
    ).then((_) => WakelockPlus.disable());
  }

  void _toggleFavorite(Recipe recipe) {
    final manager = context.read<RecipeManagerBloc>();
    manager.add(
      recipe.isFavorite ? RMRemoveFavorite(recipe) : RMAddFavorite(recipe),
    );
  }

  Future<void> _showAdvancedFilters() async {
    final palette = CulinaryEditorialPalette.of(context);
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: palette.surface,
      showDragHandle: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setSheetState) {
          void update(VoidCallback change) {
            _updateSearch(change);
            setSheetState(() {});
          }

          return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.82,
            minChildSize: 0.5,
            maxChildSize: 0.96,
            builder: (context, scrollController) => ListView(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        S.of(context).ingredient_search_filters_title,
                        style: CulinaryEditorialType.headline(
                          palette,
                          size: 24,
                          weight: FontWeight.w600,
                        ),
                      ),
                    ),
                    TextButton(
                      key: const Key('ingredient-search-reset-filters'),
                      onPressed: () => update(() {
                        _selectedCategories.clear();
                        _selectedRecipeTags.clear();
                        _maxTotalTimeMinutes = null;
                        _maxEffort = null;
                      }),
                      child: Text(S.of(context).ingredient_search_reset),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _LimitFilter(
                  icon: Icons.schedule_rounded,
                  title: S.of(context).ingredient_search_max_time,
                  enabled: _maxTotalTimeMinutes != null,
                  valueLabel: _maxTotalTimeMinutes == null
                      ? S.of(context).ingredient_search_no_limit
                      : S
                            .of(context)
                            .ingredient_search_minutes(_maxTotalTimeMinutes!),
                  slider: _maxTotalTimeMinutes == null
                      ? null
                      : Slider(
                          key: const Key('ingredient-search-time-slider'),
                          value: _maxTotalTimeMinutes!.toDouble(),
                          min: 15,
                          max: 240,
                          divisions: 15,
                          label: S
                              .of(context)
                              .ingredient_search_minutes(_maxTotalTimeMinutes!),
                          onChanged: (value) => update(
                            () => _maxTotalTimeMinutes =
                                (value / 15).round() * 15,
                          ),
                        ),
                  onEnabledChanged: (enabled) =>
                      update(() => _maxTotalTimeMinutes = enabled ? 30 : null),
                ),
                const SizedBox(height: 12),
                _LimitFilter(
                  icon: Icons.local_fire_department_rounded,
                  title: S.of(context).ingredient_search_effort_cap,
                  enabled: _maxEffort != null,
                  valueLabel: _maxEffort == null
                      ? S.of(context).ingredient_search_no_limit
                      : S
                            .of(context)
                            .ingredient_search_effort_value(_maxEffort!),
                  slider: _maxEffort == null
                      ? null
                      : Slider(
                          key: const Key('ingredient-search-effort-slider'),
                          value: _maxEffort!.toDouble(),
                          min: 1,
                          max: 10,
                          divisions: 9,
                          label: S
                              .of(context)
                              .ingredient_search_effort_value(_maxEffort!),
                          onChanged: (value) =>
                              update(() => _maxEffort = value.round()),
                        ),
                  onEnabledChanged: (enabled) =>
                      update(() => _maxEffort = enabled ? 5 : null),
                ),
                if (_categories.isNotEmpty) ...[
                  const SizedBox(height: 28),
                  _FilterSectionTitle(
                    title: S.of(context).categories,
                    selectedCount: _selectedCategories.length,
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _categories.map((category) {
                      final selected = _selectedCategories.contains(category);
                      return _EditorialFilterChip(
                        key: Key('ingredient-search-category-$category'),
                        label: category == constants.noCategory
                            ? S.of(context).no_category
                            : category,
                        icon: Icons.folder_open_rounded,
                        selected: selected,
                        onSelected: (value) => update(() {
                          if (value) {
                            _selectedCategories.add(category);
                          } else {
                            _selectedCategories.remove(category);
                          }
                        }),
                      );
                    }).toList(),
                  ),
                ],
                if (_recipeTags.isNotEmpty) ...[
                  const SizedBox(height: 28),
                  _FilterSectionTitle(
                    title: S.of(context).tags,
                    selectedCount: _selectedRecipeTags.length,
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _recipeTags.map((tag) {
                      final selected = _selectedRecipeTags.contains(tag);
                      return _EditorialFilterChip(
                        key: Key('ingredient-search-tag-${tag.text}'),
                        label: '#${tag.text}',
                        icon: Icons.sell_outlined,
                        selected: selected,
                        onSelected: (value) => update(() {
                          if (value) {
                            _selectedRecipeTags.add(tag);
                          } else {
                            _selectedRecipeTags.remove(tag);
                          }
                        }),
                      );
                    }).toList(),
                  ),
                ],
                const SizedBox(height: 28),
                SizedBox(
                  height: 48,
                  child: FilledButton(
                    onPressed: () => Navigator.pop(sheetContext),
                    child: Text(S.of(context).done),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _SearchWorkspace({required IngredientSearchState state}) {
    final palette = CulinaryEditorialPalette.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).ingredient_search_heading,
          style: CulinaryEditorialType.headline(
            palette,
            size: 30,
            weight: FontWeight.w600,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          S.of(context).ingredient_search_description,
          style: CulinaryEditorialType.body(
            palette,
            size: 15,
            color: palette.onSurfaceVariant,
            height: 1.45,
          ),
        ),
        const SizedBox(height: 18),
        Material(
          color: palette.surface,
          borderRadius: BorderRadius.circular(16),
          elevation: 2,
          shadowColor: palette.shadow,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Autocomplete<String>(
                  optionsBuilder: (value) {
                    final query = value.text.trim().toLowerCase();
                    if (query.isEmpty) return const Iterable<String>.empty();
                    return _ingredientSuggestions
                        .where((suggestion) {
                          final alreadySelected = _ingredients.any(
                            (ingredient) =>
                                ingredient.toLowerCase() ==
                                suggestion.toLowerCase(),
                          );
                          return !alreadySelected &&
                              suggestion.toLowerCase().contains(query);
                        })
                        .take(8);
                  },
                  onSelected: _addIngredient,
                  fieldViewBuilder:
                      (context, controller, focusNode, onFieldSubmitted) {
                        _fieldController = controller;
                        _fieldFocusNode = focusNode;
                        return TextField(
                          key: const Key('ingredient-search-input'),
                          controller: controller,
                          focusNode: focusNode,
                          textInputAction: TextInputAction.done,
                          onSubmitted: _addIngredient,
                          decoration: InputDecoration(
                            hintText: S
                                .of(context)
                                .ingredient_search_input_hint,
                            prefixIcon: const Icon(Icons.search_rounded),
                            filled: true,
                            fillColor: palette.surfaceContainer,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            suffixIconConstraints: const BoxConstraints(
                              minWidth: 52,
                              minHeight: 48,
                            ),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(4),
                              child: IconButton.filled(
                                key: const Key('ingredient-search-add'),
                                tooltip: S.of(context).ingredient_search_add,
                                onPressed: _addIngredient,
                                icon: const Icon(Icons.add_rounded),
                                style: IconButton.styleFrom(
                                  backgroundColor: palette.primary,
                                  foregroundColor: palette.onPrimary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(9),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        S
                            .of(context)
                            .ingredient_search_basket_count(
                              _ingredients.length,
                            ),
                        style: CulinaryEditorialType.body(
                          palette,
                          size: 11,
                          weight: FontWeight.w700,
                          color: palette.outline,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    if (_ingredients.isNotEmpty)
                      TextButton(
                        key: const Key('ingredient-search-clear'),
                        onPressed: _clearIngredients,
                        child: Text(S.of(context).ingredient_search_clear_all),
                      ),
                  ],
                ),
                if (_ingredients.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 6),
                    child: Text(
                      S.of(context).ingredient_search_basket_empty,
                      style: CulinaryEditorialType.body(
                        palette,
                        size: 13,
                        color: palette.onSurfaceVariant,
                      ),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 6),
                    child: Wrap(
                      spacing: 7,
                      runSpacing: 7,
                      children: _ingredients
                          .map(
                            (ingredient) => InputChip(
                              key: Key('ingredient-chip-$ingredient'),
                              label: Text(ingredient),
                              onDeleted: () => _removeIngredient(ingredient),
                              deleteButtonTooltipMessage: S
                                  .of(context)
                                  .ingredient_search_remove(ingredient),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                const SizedBox(height: 10),
                Divider(height: 1, color: palette.surfaceContainerHigh),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _FilterSummary(
                        icon: Icons.schedule_rounded,
                        label: S.of(context).ingredient_search_max_time,
                        value: _maxTotalTimeMinutes == null
                            ? S.of(context).ingredient_search_any_time
                            : S
                                  .of(context)
                                  .ingredient_search_minutes(
                                    _maxTotalTimeMinutes!,
                                  ),
                        onTap: _showAdvancedFilters,
                      ),
                    ),
                    SizedBox(
                      height: 42,
                      child: VerticalDivider(
                        width: 24,
                        color: palette.surfaceContainerHigh,
                      ),
                    ),
                    Expanded(
                      child: _FilterSummary(
                        icon: Icons.local_fire_department_rounded,
                        label: S.of(context).ingredient_search_effort_cap,
                        value: _maxEffort == null
                            ? S.of(context).ingredient_search_any_effort
                            : S
                                  .of(context)
                                  .ingredient_search_effort_value(_maxEffort!),
                        onTap: _showAdvancedFilters,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _DietChip(
                label: S.of(context).ingredient_search_all,
                selected: _selectedVegetable == null,
                onSelected: () =>
                    _updateSearch(() => _selectedVegetable = null),
              ),
              const SizedBox(width: 8),
              _DietChip(
                label: S.of(context).ingredient_search_vegetarian,
                selected: _selectedVegetable == Vegetable.VEGETARIAN,
                onSelected: () => _updateSearch(
                  () => _selectedVegetable = Vegetable.VEGETARIAN,
                ),
              ),
              const SizedBox(width: 8),
              _DietChip(
                label: S.of(context).ingredient_search_vegan,
                selected: _selectedVegetable == Vegetable.VEGAN,
                onSelected: () =>
                    _updateSearch(() => _selectedVegetable = Vegetable.VEGAN),
              ),
              const SizedBox(width: 8),
              _DietChip(
                label: S.of(context).ingredient_search_meat,
                selected: _selectedVegetable == Vegetable.NON_VEGETARIAN,
                onSelected: () => _updateSearch(
                  () => _selectedVegetable = Vegetable.NON_VEGETARIAN,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            key: const Key('ingredient-search-filters'),
            onPressed: _showAdvancedFilters,
            icon: const Icon(Icons.tune_rounded),
            label: Text(
              _criteria.advancedFilterCount == 0
                  ? S.of(context).ingredient_search_more_filters
                  : S
                        .of(context)
                        .ingredient_search_active_filters(
                          _criteria.advancedFilterCount,
                        ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _ResultsHeader({required IngredientSearchState state}) {
    final palette = CulinaryEditorialPalette.of(context);
    final count = state is IngredientSearchMatches ? state.results.length : 0;
    return Row(
      children: [
        Expanded(
          child: Text.rich(
            TextSpan(
              text: S.of(context).ingredient_search_results,
              children: [
                if (state is IngredientSearchMatches)
                  TextSpan(
                    text: ' ${S.of(context).ingredient_search_found(count)}',
                    style: CulinaryEditorialType.body(
                      palette,
                      size: 12,
                      weight: FontWeight.w600,
                      color: palette.outline,
                    ),
                  ),
              ],
            ),
            style: CulinaryEditorialType.headline(
              palette,
              size: 20,
              weight: FontWeight.w600,
            ),
          ),
        ),
        PopupMenuButton<IngredientSearchSort>(
          key: const Key('ingredient-search-sort'),
          tooltip: S.of(context).sort_by(_sortLabel(context, _sort)),
          initialValue: _sort,
          onSelected: (value) => _updateSearch(() => _sort = value),
          itemBuilder: (context) => IngredientSearchSort.values
              .map(
                (sort) => PopupMenuItem(
                  value: sort,
                  child: Text(_sortLabel(context, sort)),
                ),
              )
              .toList(),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _sortLabel(context, _sort),
                    style: CulinaryEditorialType.body(
                      palette,
                      size: 11,
                      weight: FontWeight.w700,
                      color: palette.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(Icons.expand_more_rounded, size: 18),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _sortLabel(BuildContext context, IngredientSearchSort sort) {
    switch (sort) {
      case IngredientSearchSort.bestMatch:
        return S.of(context).ingredient_search_sort_best;
      case IngredientSearchSort.shortestTime:
        return S.of(context).ingredient_search_sort_time;
      case IngredientSearchSort.lowestEffort:
        return S.of(context).ingredient_search_sort_effort;
      case IngredientSearchSort.name:
        return S.of(context).ingredient_search_sort_name;
    }
  }
}

class _DietChip extends StatelessWidget {
  const _DietChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      showCheckmark: false,
      selectedColor: palette.onSurface,
      backgroundColor: palette.surface,
      labelStyle: CulinaryEditorialType.body(
        palette,
        size: 12,
        weight: FontWeight.w700,
        color: selected ? palette.background : palette.onSurfaceVariant,
      ),
      side: BorderSide.none,
    );
  }
}

class _FilterSummary extends StatelessWidget {
  const _FilterSummary({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48),
        child: Row(
          children: [
            Icon(icon, size: 18, color: palette.outline),
            const SizedBox(width: 7),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: CulinaryEditorialType.body(
                      palette,
                      size: 10,
                      weight: FontWeight.w700,
                      color: palette.outline,
                      letterSpacing: 0.35,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: CulinaryEditorialType.body(
                      palette,
                      size: 12,
                      weight: FontWeight.w700,
                      color: palette.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LimitFilter extends StatelessWidget {
  const _LimitFilter({
    required this.icon,
    required this.title,
    required this.enabled,
    required this.valueLabel,
    required this.slider,
    required this.onEnabledChanged,
  });

  final IconData icon;
  final String title;
  final bool enabled;
  final String valueLabel;
  final Widget? slider;
  final ValueChanged<bool> onEnabledChanged;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Material(
      color: palette.surfaceContainer,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 6, 12, 8),
        child: Column(
          children: [
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              secondary: Icon(icon, color: palette.primary),
              title: Text(
                title,
                style: CulinaryEditorialType.body(
                  palette,
                  size: 14,
                  weight: FontWeight.w700,
                ),
              ),
              subtitle: Text(
                valueLabel,
                style: CulinaryEditorialType.body(
                  palette,
                  size: 12,
                  color: palette.onSurfaceVariant,
                ),
              ),
              value: enabled,
              onChanged: onEnabledChanged,
              thumbColor: WidgetStateProperty.resolveWith(
                (states) => states.contains(WidgetState.selected)
                    ? palette.onPrimary
                    : palette.onSurfaceVariant,
              ),
              trackColor: WidgetStateProperty.resolveWith(
                (states) => states.contains(WidgetState.selected)
                    ? palette.primary
                    : palette.surfaceContainerHigh,
              ),
              trackOutlineColor: WidgetStateProperty.resolveWith(
                (states) => states.contains(WidgetState.selected)
                    ? palette.primary
                    : palette.outline.withValues(alpha: .72),
              ),
            ),
            if (slider != null) slider!,
          ],
        ),
      ),
    );
  }
}

class _FilterSectionTitle extends StatelessWidget {
  const _FilterSectionTitle({required this.title, required this.selectedCount});

  final String title;
  final int selectedCount;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: CulinaryEditorialType.headline(
              palette,
              size: 18,
              weight: FontWeight.w600,
            ),
          ),
        ),
        if (selectedCount > 0)
          Container(
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: palette.primarySoft,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '$selectedCount',
              style: CulinaryEditorialType.body(
                palette,
                size: 12,
                weight: FontWeight.w700,
                color: palette.primary,
              ),
            ),
          ),
      ],
    );
  }
}

class _EditorialFilterChip extends StatelessWidget {
  const _EditorialFilterChip({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final foreground = selected ? palette.primary : palette.onSurface;

    return FilterChip(
      label: Text(label),
      avatar: Icon(
        selected ? Icons.check_rounded : icon,
        size: 18,
        color: foreground,
      ),
      selected: selected,
      onSelected: onSelected,
      showCheckmark: false,
      backgroundColor: palette.surfaceContainer,
      selectedColor: palette.primarySoft,
      labelStyle: CulinaryEditorialType.body(
        palette,
        size: 13,
        weight: FontWeight.w700,
        color: foreground,
      ),
      side: BorderSide(
        color: selected
            ? palette.primary.withValues(alpha: .72)
            : palette.outline.withValues(alpha: .42),
      ),
      shape: const StadiumBorder(),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      tooltip: label,
    );
  }
}

class _SearchStateMessage extends StatelessWidget {
  const _SearchStateMessage({
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
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 42, color: palette.secondary),
              const SizedBox(height: 14),
              Text(
                title,
                textAlign: TextAlign.center,
                style: CulinaryEditorialType.headline(
                  palette,
                  size: 21,
                  weight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                description,
                textAlign: TextAlign.center,
                style: CulinaryEditorialType.body(
                  palette,
                  size: 13,
                  color: palette.onSurfaceVariant,
                ),
              ),
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(height: 18),
                FilledButton(onPressed: onAction, child: Text(actionLabel!)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
