import 'package:flutter/material.dart';

import '../../constants/global_constants.dart' as constants;
import '../../generated/l10n.dart';
import '../../models/enums.dart';
import '../../models/recipe.dart';
import '../../models/recipe_collection_filters.dart';
import '../../models/recipe_sort.dart';
import 'editorial_recipe_card.dart';
import 'recipe_layout_switch.dart';
import 'recipe_overview_theme.dart';

class RecipeCollectionControlsHeaderDelegate
    extends SliverPersistentHeaderDelegate {
  const RecipeCollectionControlsHeaderDelegate({
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
  bool shouldRebuild(
    covariant RecipeCollectionControlsHeaderDelegate oldDelegate,
  ) =>
      height != oldDelegate.height ||
      background != oldDelegate.background ||
      child != oldDelegate.child;
}

class RecipeCollectionControls extends StatelessWidget {
  const RecipeCollectionControls({
    required this.keyPrefix,
    required this.recipes,
    required this.layout,
    required this.searchController,
    required this.recipeSort,
    required this.filters,
    required this.onLayoutChanged,
    required this.onQueryChanged,
    required this.onSortChanged,
    required this.onAscendingChanged,
    required this.onFiltersChanged,
    this.excludedCategory,
    this.excludedTag,
    this.includeVegetable = true,
    super.key,
  });

  final String keyPrefix;
  final List<Recipe> recipes;
  final RecipeOverviewCardLayout layout;
  final TextEditingController searchController;
  final RSort recipeSort;
  final RecipeCollectionFilters filters;
  final String? excludedCategory;
  final String? excludedTag;
  final bool includeVegetable;
  final ValueChanged<RecipeOverviewCardLayout> onLayoutChanged;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<RecipeSort> onSortChanged;
  final ValueChanged<bool> onAscendingChanged;
  final ValueChanged<RecipeCollectionFilters> onFiltersChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            RecipeLayoutSwitch(
              keyPrefix: keyPrefix,
              layout: layout,
              onChanged: onLayoutChanged,
            ),
            const SizedBox(width: 9),
            Expanded(
              child: _CollectionSearch(
                keyPrefix: keyPrefix,
                controller: searchController,
                onChanged: onQueryChanged,
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),
        Row(
          children: [
            Expanded(
              child: _CollectionSortMenu(
                keyPrefix: keyPrefix,
                recipeSort: recipeSort,
                onSortChanged: onSortChanged,
                onAscendingChanged: onAscendingChanged,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _CollectionFilterButton(
                keyPrefix: keyPrefix,
                activeCount: filters.activeCount,
                onPressed: () => showRecipeCollectionFilterSheet(
                  context: context,
                  keyPrefix: keyPrefix,
                  recipes: recipes,
                  filters: filters,
                  excludedCategory: excludedCategory,
                  excludedTag: excludedTag,
                  includeVegetable: includeVegetable,
                  onChanged: onFiltersChanged,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CollectionSearch extends StatelessWidget {
  const _CollectionSearch({
    required this.keyPrefix,
    required this.controller,
    required this.onChanged,
  });

  final String keyPrefix;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final palette = RecipeOverviewPalette.of(context);
    return SizedBox(
      height: 48,
      child: TextField(
        key: Key('$keyPrefix-search'),
        controller: controller,
        onChanged: onChanged,
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
                  key: Key('$keyPrefix-clear-search'),
                  tooltip: S.of(context).clear_search,
                  onPressed: () {
                    controller.clear();
                    onChanged('');
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

class _CollectionSortMenu extends StatelessWidget {
  const _CollectionSortMenu({
    required this.keyPrefix,
    required this.recipeSort,
    required this.onSortChanged,
    required this.onAscendingChanged,
  });

  final String keyPrefix;
  final RSort recipeSort;
  final ValueChanged<RecipeSort> onSortChanged;
  final ValueChanged<bool> onAscendingChanged;

  @override
  Widget build(BuildContext context) {
    final palette = RecipeOverviewPalette.of(context);
    final label = S.of(context).sort_by(_sortLabel(context, recipeSort.sort));
    return PopupMenuButton<Object>(
      key: Key('$keyPrefix-sort'),
      tooltip: label,
      color: palette.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 6,
      onSelected: (value) {
        if (value is RecipeSort) {
          onSortChanged(value);
        } else if (value is bool) {
          onAscendingChanged(value);
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
      child: _CollectionControlButton(
        icon: recipeSort.ascending == true
            ? Icons.arrow_upward_rounded
            : Icons.arrow_downward_rounded,
        trailingIcon: Icons.expand_more_rounded,
        label: label,
      ),
    );
  }

  String _sortLabel(BuildContext context, RecipeSort sort) {
    return switch (sort) {
      RecipeSort.BY_NAME => S.of(context).by_name,
      RecipeSort.BY_EFFORT => S.of(context).by_effort,
      RecipeSort.BY_INGREDIENT_COUNT => S.of(context).by_ingredientsamount,
      RecipeSort.BY_LAST_MODIFIED => S.of(context).by_last_modified,
      RecipeSort.BY_TOTAL_TIME => S.of(context).total_time,
    };
  }
}

class _CollectionFilterButton extends StatelessWidget {
  const _CollectionFilterButton({
    required this.keyPrefix,
    required this.activeCount,
    required this.onPressed,
  });

  final String keyPrefix;
  final int activeCount;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return _CollectionControlButton(
      key: Key('$keyPrefix-filters'),
      icon: Icons.tune_rounded,
      label: activeCount == 0
          ? S.of(context).more_filters
          : S.of(context).recipe_filters_active(activeCount),
      selected: activeCount > 0,
      onTap: onPressed,
    );
  }
}

class _CollectionControlButton extends StatelessWidget {
  const _CollectionControlButton({
    required this.icon,
    required this.label,
    this.trailingIcon,
    this.selected = false,
    this.onTap,
    super.key,
  });

  final IconData icon;
  final String label;
  final IconData? trailingIcon;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = RecipeOverviewPalette.of(context);
    final foreground = selected ? palette.primary : palette.onSurfaceVariant;
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected ? palette.primarySoft : palette.surfaceContainer,
        borderRadius: BorderRadius.circular(999),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(999),
          child: SizedBox(
            height: 48,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 17, color: foreground),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: RecipeOverviewType.body(
                        palette,
                        size: 11,
                        weight: FontWeight.w700,
                        color: foreground,
                      ),
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
        Expanded(
          child: Text(label, style: RecipeOverviewType.body(palette, size: 13)),
        ),
      ],
    );
  }
}

Future<void> showRecipeCollectionFilterSheet({
  required BuildContext context,
  required String keyPrefix,
  required List<Recipe> recipes,
  required RecipeCollectionFilters filters,
  required ValueChanged<RecipeCollectionFilters> onChanged,
  String? excludedCategory,
  String? excludedTag,
  bool includeVegetable = true,
}) {
  final palette = RecipeOverviewPalette.of(context);
  final options = RecipeCollectionFilterOptions.fromRecipes(
    recipes,
    excludedCategory: excludedCategory,
    excludedTag: excludedTag,
    includeVegetable: includeVegetable,
  );
  var current = filters.normalizedFor(
    recipes,
    excludedCategory: excludedCategory,
    excludedTag: excludedTag,
    includeVegetable: includeVegetable,
  );

  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: palette.surface,
    showDragHandle: true,
    builder: (sheetContext) => StatefulBuilder(
      builder: (context, setSheetState) {
        void update(RecipeCollectionFilters filters) {
          current = filters.normalizedFor(
            recipes,
            excludedCategory: excludedCategory,
            excludedTag: excludedTag,
            includeVegetable: includeVegetable,
          );
          setSheetState(() {});
          onChanged(current);
        }

        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.82,
          minChildSize: 0.5,
          maxChildSize: 0.96,
          builder: (context, scrollController) => ListView(
            key: Key('$keyPrefix-filter-sheet'),
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      S.of(context).recipe_filters_title,
                      style: RecipeOverviewType.headline(
                        palette,
                        size: 24,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ),
                  TextButton(
                    key: Key('$keyPrefix-reset-filters'),
                    onPressed: () => update(const RecipeCollectionFilters()),
                    child: Text(S.of(context).recipe_filters_reset),
                  ),
                ],
              ),
              if (includeVegetable && options.vegetables.isNotEmpty) ...[
                const SizedBox(height: 18),
                _FilterSectionTitle(
                  title: S.of(context).recipe_filters_diet,
                  selectedCount: current.vegetable == null ? 0 : 1,
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _EditorialFilterChip(
                      key: Key('$keyPrefix-diet-any'),
                      label: S.of(context).recipe_filters_any_diet,
                      icon: Icons.restaurant_menu_rounded,
                      selected: current.vegetable == null,
                      onSelected: (_) =>
                          update(current.copyWith(vegetable: null)),
                    ),
                    for (final vegetable in options.vegetables)
                      _EditorialFilterChip(
                        key: Key('$keyPrefix-diet-${vegetable.name}'),
                        label: _dietLabel(context, vegetable),
                        icon: vegetable == Vegetable.NON_VEGETARIAN
                            ? Icons.restaurant_rounded
                            : Icons.eco_rounded,
                        selected: current.vegetable == vegetable,
                        onSelected: (selected) => update(
                          current.copyWith(
                            vegetable: selected ? vegetable : null,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
              const SizedBox(height: 24),
              _LimitFilter(
                icon: Icons.schedule_rounded,
                title: S.of(context).recipe_filters_max_time,
                enabled: current.maxTotalTimeMinutes != null,
                valueLabel: current.maxTotalTimeMinutes == null
                    ? S.of(context).recipe_filters_no_limit
                    : S
                          .of(context)
                          .recipe_filters_minutes(current.maxTotalTimeMinutes!),
                slider: current.maxTotalTimeMinutes == null
                    ? null
                    : Slider(
                        key: Key('$keyPrefix-time-slider'),
                        value: current.maxTotalTimeMinutes!.toDouble(),
                        min: 15,
                        max: 240,
                        divisions: 15,
                        label: S
                            .of(context)
                            .recipe_filters_minutes(
                              current.maxTotalTimeMinutes!,
                            ),
                        onChanged: (value) => update(
                          current.copyWith(
                            maxTotalTimeMinutes: (value / 15).round() * 15,
                          ),
                        ),
                      ),
                onEnabledChanged: (enabled) => update(
                  current.copyWith(maxTotalTimeMinutes: enabled ? 30 : null),
                ),
              ),
              const SizedBox(height: 12),
              _LimitFilter(
                icon: Icons.local_fire_department_rounded,
                title: S.of(context).recipe_filters_max_effort,
                enabled: current.maxEffort != null,
                valueLabel: current.maxEffort == null
                    ? S.of(context).recipe_filters_no_limit
                    : S
                          .of(context)
                          .recipe_filters_effort_value(current.maxEffort!),
                slider: current.maxEffort == null
                    ? null
                    : Slider(
                        key: Key('$keyPrefix-effort-slider'),
                        value: current.maxEffort!.toDouble(),
                        min: 1,
                        max: 10,
                        divisions: 9,
                        label: S
                            .of(context)
                            .recipe_filters_effort_value(current.maxEffort!),
                        onChanged: (value) =>
                            update(current.copyWith(maxEffort: value.round())),
                      ),
                onEnabledChanged: (enabled) =>
                    update(current.copyWith(maxEffort: enabled ? 5 : null)),
              ),
              if (options.categories.isNotEmpty) ...[
                const SizedBox(height: 28),
                _FilterSectionTitle(
                  title: S.of(context).categories,
                  selectedCount: current.categories.length,
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: options.categories.map((category) {
                    final selected = current.categories.contains(category);
                    return _EditorialFilterChip(
                      key: Key('$keyPrefix-category-$category'),
                      label: category == constants.noCategory
                          ? S.of(context).no_category
                          : category,
                      icon: Icons.folder_open_rounded,
                      selected: selected,
                      onSelected: (value) {
                        final selection = List<String>.from(current.categories);
                        value
                            ? selection.add(category)
                            : selection.remove(category);
                        update(current.copyWith(categories: selection));
                      },
                    );
                  }).toList(),
                ),
              ],
              if (options.tags.isNotEmpty) ...[
                const SizedBox(height: 28),
                _FilterSectionTitle(
                  title: S.of(context).tags,
                  selectedCount: current.tags.length,
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: options.tags.map((tag) {
                    final selected = current.tags.contains(tag.text);
                    return _EditorialFilterChip(
                      key: Key('$keyPrefix-tag-${tag.text}'),
                      label: '#${tag.text}',
                      icon: Icons.sell_outlined,
                      selected: selected,
                      onSelected: (value) {
                        final selection = List<String>.from(current.tags);
                        value
                            ? selection.add(tag.text)
                            : selection.remove(tag.text);
                        update(current.copyWith(tags: selection));
                      },
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 28),
              SizedBox(
                height: 52,
                child: FilledButton(
                  key: Key('$keyPrefix-filter-done'),
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

String _dietLabel(BuildContext context, Vegetable vegetable) {
  return switch (vegetable) {
    Vegetable.NON_VEGETARIAN => S.of(context).with_meat,
    Vegetable.VEGETARIAN => S.of(context).vegetarian,
    Vegetable.VEGAN => S.of(context).vegan,
  };
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
    final palette = RecipeOverviewPalette.of(context);
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
                style: RecipeOverviewType.body(
                  palette,
                  size: 14,
                  weight: FontWeight.w700,
                ),
              ),
              subtitle: Text(
                valueLabel,
                style: RecipeOverviewType.body(
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
    final palette = RecipeOverviewPalette.of(context);
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: RecipeOverviewType.headline(
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
              style: RecipeOverviewType.body(
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
    required this.label,
    required this.icon,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) {
    final palette = RecipeOverviewPalette.of(context);
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
      labelStyle: RecipeOverviewType.body(
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
