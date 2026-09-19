import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../ad_related/ad.dart';
import '../../blocs/recipe_calendar/recipe_calendar_bloc.dart';
import '../../blocs/recipe_manager/recipe_manager_bloc.dart';
import '../../blocs/shopping_cart/shopping_cart_bloc.dart';
import '../../constants/global_constants.dart' as constants;
import '../../constants/global_settings.dart';
import '../../constants/routes.dart';
import '../../generated/l10n.dart';
import '../../models/enums.dart';
import '../../models/recipe.dart';
import '../../models/tuple.dart';
import '../../screens/recipe_screen.dart';
import '../../util/helper.dart';
import '../culinary_editorial_theme.dart';
import '../dialogs/calendar_add_dialog.dart';
import 'calendar_export_preview.dart';

enum _CalendarRecipeAction { remove }

class EditorialWeeklyPlanner extends StatefulWidget {
  const EditorialWeeklyPlanner({this.embedded = false, super.key});

  final bool embedded;

  @override
  State<EditorialWeeklyPlanner> createState() => _EditorialWeeklyPlannerState();
}

class _EditorialWeeklyPlannerState extends State<EditorialWeeklyPlanner> {
  final Map<DateTime, GlobalKey> _dayKeys = <DateTime, GlobalKey>{};
  DateTime? _selectedDay;
  DateTime? _lastWeekStart;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return BlocConsumer<RecipeCalendarBloc, RecipeCalendarState>(
      listener: _showCalendarFeedback,
      builder: (context, state) {
        if (state is LoadingRecipeCalendar) {
          return Center(
            child: CircularProgressIndicator(color: palette.primary),
          );
        }
        if (state is FailedRecipeCalendar) {
          return _CalendarFailure(palette: palette);
        }
        if (state is! LoadedRecipeCalendarWeek) {
          return const SizedBox.shrink();
        }
        final textScale = MediaQuery.textScalerOf(context).scale(1);
        _syncSelectedDay(state.weekStart);
        final drafts = buildCalendarExportDrafts(state.recipes);
        final ingredientCount = drafts.fold(
          0,
          (sum, draft) => sum + draft.ingredients.length,
        );
        return Stack(
          children: [
            CustomScrollView(
              key: const Key('calendar-week-scroll'),
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _WeekHeaderDelegate(
                    height:
                        (widget.embedded ? 196 : 194) +
                        ((textScale - 1).clamp(0, 0.5) * 105),
                    child: _WeekHeader(
                      state: state,
                      selectedDay: _selectedDay!,
                      palette: palette,
                      embedded: widget.embedded,
                      onSelectDay: (day) => _selectDay(day),
                      onPlanRecipe: _showPlanRecipe,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    widget.embedded ? 12 : 20,
                    18,
                    widget.embedded ? 12 : 20,
                    widget.embedded ? 120 : 132,
                  ),
                  sliver: SliverList.separated(
                    itemCount: state.recipes.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 26),
                    itemBuilder: (context, index) {
                      final entry = state.recipes.entries.elementAt(index);
                      final key = _dayKeys.putIfAbsent(
                        entry.key,
                        GlobalKey.new,
                      );
                      return _DaySection(
                        key: key,
                        date: entry.key,
                        recipes: entry.value,
                        selected: _sameDate(entry.key, _selectedDay!),
                        palette: palette,
                        onAdd: () => _showRecipeForDay(entry.key),
                        onOpen: _openRecipe,
                        onRemove: (dateRecipe) =>
                            context.read<RecipeCalendarBloc>().add(
                              RemoveRecipeFromDateEvent(
                                dateRecipe.item1,
                                dateRecipe.item2.name,
                              ),
                            ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: _ExportDock(
                recipeCount: state.recipeCount,
                ingredientCount: ingredientCount,
                enabled: ingredientCount > 0,
                palette: palette,
                embedded: widget.embedded,
                onPressed: () => _showExportPreview(state),
              ),
            ),
          ],
        );
      },
    );
  }

  void _syncSelectedDay(DateTime weekStart) {
    if (_lastWeekStart == weekStart) return;
    _lastWeekStart = weekStart;
    final today = DateTime.now();
    final normalizedToday = DateTime(today.year, today.month, today.day);
    final weekEnd = weekStart.add(const Duration(days: 7));
    _selectedDay =
        !normalizedToday.isBefore(weekStart) &&
            normalizedToday.isBefore(weekEnd)
        ? normalizedToday
        : weekStart;
    _dayKeys.clear();
  }

  void _selectDay(DateTime day) {
    setState(() => _selectedDay = day);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final target = _dayKeys[day]?.currentContext;
      if (target != null) {
        Scrollable.ensureVisible(
          target,
          duration: GlobalSettings().animationsEnabled()
              ? const Duration(milliseconds: 320)
              : Duration.zero,
          curve: Curves.easeOutCubic,
          alignment: 0.08,
        );
      }
    });
  }

  Future<void> _showPlanRecipe() async {
    final selection = await showCalendarSchedule(context);
    if (selection == null || !mounted) return;
    context.read<RecipeCalendarBloc>().add(
      AddRecipeToCalendarEvent(selection.scheduledAt, selection.recipeName),
    );
  }

  Future<void> _showRecipeForDay(DateTime date) async {
    final selection = await showCalendarSchedule(
      context,
      fixedDate: date,
      allowTime: false,
    );
    if (selection == null || !mounted) return;
    context.read<RecipeCalendarBloc>().add(
      AddRecipeToCalendarEvent(selection.scheduledAt, selection.recipeName),
    );
  }

  void _openRecipe(Tuple2<DateTime, Recipe> value, int index) {
    if (GlobalSettings().standbyDisabled()) WakelockPlus.enable();
    final heroTag = '${value.item1.toIso8601String()}${value.item2.name}$index';
    Navigator.pushNamed(
      context,
      RouteNames.recipeScreen,
      arguments: RecipeScreenArguments(
        context.read<ShoppingCartBloc>(),
        context.read<RecipeCalendarBloc>(),
        value.item2,
        heroTag,
        context.read<RecipeManagerBloc>(),
      ),
    ).then((_) {
      WakelockPlus.disable();
      if (Ads.shouldShowBannerAds()) Ads.hideBottomBannerAd();
    });
  }

  Future<void> _showExportPreview(LoadedRecipeCalendarWeek state) async {
    final shoppingCartBloc = context.read<ShoppingCartBloc>();
    final result = await showModalBottomSheet<int>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => BlocProvider.value(
        value: shoppingCartBloc,
        child: FractionallySizedBox(
          heightFactor: 0.94,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                child: CalendarExportPreviewSheet(
                  drafts: buildCalendarExportDrafts(state.recipes),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    if (result != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).calendar_export_success(result))),
      );
    }
  }

  void _showCalendarFeedback(BuildContext context, RecipeCalendarState state) {
    if (state is! LoadedRecipeCalendarWeek) return;
    final removed = state.removedRecipe;
    if (removed != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).calendar_removed(removed.item2)),
          action: SnackBarAction(
            label: S.of(context).undo,
            onPressed: () => context.read<RecipeCalendarBloc>().add(
              AddRecipeToCalendarEvent(removed.item1, removed.item2),
            ),
          ),
        ),
      );
    }
  }
}

List<CalendarExportRecipeDraft> buildCalendarExportDrafts(
  Map<DateTime, List<Tuple2<DateTime, Recipe>>> days,
) {
  final grouped = <String, List<Recipe>>{};
  for (final value in days.values.expand((day) => day)) {
    grouped.putIfAbsent(value.item2.name, () => <Recipe>[]).add(value.item2);
  }
  return grouped.values
      .map(
        (recipes) => CalendarExportRecipeDraft(
          recipe: recipes.first,
          occurrenceCount: recipes.length,
        ),
      )
      .toList(growable: false);
}

class _WeekHeader extends StatelessWidget {
  const _WeekHeader({
    required this.state,
    required this.selectedDay,
    required this.palette,
    required this.embedded,
    required this.onSelectDay,
    required this.onPlanRecipe,
  });

  final LoadedRecipeCalendarWeek state;
  final DateTime selectedDay;
  final CulinaryEditorialPalette palette;
  final bool embedded;
  final ValueChanged<DateTime> onSelectDay;
  final VoidCallback onPlanRecipe;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final weekEnd = state.weekStart.add(const Duration(days: 6));
    final sameMonth = state.weekStart.month == weekEnd.month;
    final range = sameMonth
        ? '${DateFormat.MMMd(locale).format(state.weekStart)} – ${DateFormat.d(locale).format(weekEnd)}'
        : '${DateFormat.MMMd(locale).format(state.weekStart)} – ${DateFormat.MMMd(locale).format(weekEnd)}';
    final thisWeek =
        state.weekStart == RecipeCalendarBloc.startOfWeek(DateTime.now());
    return ColoredBox(
      color: palette.background,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          embedded ? 12 : 20,
          8,
          embedded ? 12 : 20,
          10,
        ),
        child: Column(
          children: [
            Row(
              children: [
                IconButton.filledTonal(
                  key: const Key('calendar-previous-week'),
                  tooltip: S.of(context).calendar_previous_week,
                  style: IconButton.styleFrom(
                    backgroundColor: palette.surfaceContainerHigh,
                    foregroundColor: palette.onSurfaceVariant,
                  ),
                  onPressed: () => context.read<RecipeCalendarBloc>().add(
                    const ChangeCalendarWeek(-1),
                  ),
                  icon: const Icon(Icons.chevron_left),
                ),
                Expanded(
                  child: Text(
                    range,
                    textAlign: TextAlign.center,
                    style: CulinaryEditorialType.headline(palette, size: 20),
                  ),
                ),
                IconButton.filledTonal(
                  key: const Key('calendar-next-week'),
                  tooltip: S.of(context).calendar_next_week,
                  style: IconButton.styleFrom(
                    backgroundColor: palette.surfaceContainerHigh,
                    foregroundColor: palette.onSurfaceVariant,
                  ),
                  onPressed: () => context.read<RecipeCalendarBloc>().add(
                    const ChangeCalendarWeek(1),
                  ),
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: FilledButton.icon(
                    key: const Key('calendar-plan-recipe'),
                    style: FilledButton.styleFrom(
                      backgroundColor: palette.primary,
                      foregroundColor: palette.onPrimary,
                      minimumSize: const Size(0, 48),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    onPressed: onPlanRecipe,
                    icon: const Icon(Icons.add_circle_outline, size: 19),
                    label: Text(
                      S.of(context).calendar_plan_recipe,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: TextButton(
                    key: const Key('calendar-current-week'),
                    onPressed: thisWeek
                        ? null
                        : () => context.read<RecipeCalendarBloc>().add(
                            GoToCurrentCalendarWeek(),
                          ),
                    child: Text(
                      S.of(context).calendar_this_week,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: palette.surfaceContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    children: List<Widget>.generate(7, (index) {
                      final day = state.weekStart.add(Duration(days: index));
                      return Expanded(
                        child: _DayPicker(
                          day: day,
                          count: state.recipes[day]?.length ?? 0,
                          selected: _sameDate(day, selectedDay),
                          palette: palette,
                          locale: locale,
                          onTap: () => onSelectDay(day),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DayPicker extends StatelessWidget {
  const _DayPicker({
    required this.day,
    required this.count,
    required this.selected,
    required this.palette,
    required this.locale,
    required this.onTap,
  });

  final DateTime day;
  final int count;
  final bool selected;
  final CulinaryEditorialPalette palette;
  final String locale;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = selected ? palette.onPrimary : palette.onSurface;
    return Semantics(
      button: true,
      selected: selected,
      label:
          '${DateFormat.yMMMMEEEEd(locale).format(day)}, ${S.of(context).calendar_meal_count(count)}',
      child: InkWell(
        key: Key('calendar-day-${day.toIso8601String()}'),
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: AnimatedContainer(
          duration: GlobalSettings().animationsEnabled()
              ? const Duration(milliseconds: 180)
              : Duration.zero,
          decoration: BoxDecoration(
            color: selected ? palette.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                DateFormat.E(locale).format(day).toUpperCase(),
                maxLines: 1,
                style: CulinaryEditorialType.body(
                  palette,
                  size: 9,
                  weight: FontWeight.w700,
                  color: foreground,
                  letterSpacing: 0.4,
                ),
              ),
              Text(
                '${day.day}',
                style: CulinaryEditorialType.headline(
                  palette,
                  size: 17,
                ).copyWith(color: foreground),
              ),
              SizedBox(
                height: 8,
                child: count == 0
                    ? null
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          count.clamp(1, 3),
                          (_) => Container(
                            width: 4,
                            height: 4,
                            margin: const EdgeInsets.symmetric(horizontal: 1),
                            decoration: BoxDecoration(
                              color: selected
                                  ? palette.onPrimary
                                  : palette.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DaySection extends StatelessWidget {
  const _DaySection({
    required this.date,
    required this.recipes,
    required this.selected,
    required this.palette,
    required this.onAdd,
    required this.onOpen,
    required this.onRemove,
    super.key,
  });

  final DateTime date;
  final List<Tuple2<DateTime, Recipe>> recipes;
  final bool selected;
  final CulinaryEditorialPalette palette;
  final VoidCallback onAdd;
  final void Function(Tuple2<DateTime, Recipe>, int) onOpen;
  final ValueChanged<Tuple2<DateTime, Recipe>> onRemove;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    return AnimatedContainer(
      duration: GlobalSettings().animationsEnabled()
          ? const Duration(milliseconds: 180)
          : Duration.zero,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: selected ? palette.primarySoft.withValues(alpha: 0.22) : null,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      DateFormat('EEEE, MMM d', locale).format(date),
                      style: CulinaryEditorialType.headline(palette, size: 19),
                    ),
                    Text(
                      '· ${S.of(context).calendar_meal_count(recipes.length)}',
                      style: CulinaryEditorialType.body(
                        palette,
                        size: 11,
                        weight: FontWeight.w700,
                        color: palette.outline,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: S
                    .of(context)
                    .calendar_add_for_day(DateFormat.EEEE(locale).format(date)),
                style: IconButton.styleFrom(
                  foregroundColor: palette.onSurfaceVariant,
                ),
                onPressed: onAdd,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (recipes.isEmpty)
            InkWell(
              key: Key('calendar-empty-${date.toIso8601String()}'),
              borderRadius: BorderRadius.circular(14),
              onTap: onAdd,
              child: Container(
                constraints: const BoxConstraints(minHeight: 64),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: palette.surfaceContainer,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Icon(Icons.add_circle_outline, color: palette.primary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        S.of(context).calendar_empty_day,
                        style: CulinaryEditorialType.body(
                          palette,
                          size: 13,
                          weight: FontWeight.w600,
                          color: palette.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ...List<Widget>.generate(recipes.length, (index) {
              return Padding(
                padding: EdgeInsets.only(top: index == 0 ? 0 : 10),
                child: _CalendarRecipeCard(
                  value: recipes[index],
                  index: index,
                  palette: palette,
                  onOpen: () => onOpen(recipes[index], index),
                  onRemove: () => onRemove(recipes[index]),
                ),
              );
            }),
        ],
      ),
    );
  }
}

class _CalendarRecipeCard extends StatelessWidget {
  const _CalendarRecipeCard({
    required this.value,
    required this.index,
    required this.palette,
    required this.onOpen,
    required this.onRemove,
  });

  final Tuple2<DateTime, Recipe> value;
  final int index;
  final CulinaryEditorialPalette palette;
  final VoidCallback onOpen;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final recipe = value.item2;
    final hasTime = value.item1.hour != 0 || value.item1.minute != 0;
    final heroTag = '${value.item1.toIso8601String()}${recipe.name}$index';
    return Material(
      color: palette.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        key: Key('calendar-recipe-$heroTag'),
        borderRadius: BorderRadius.circular(16),
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: GlobalSettings().animationsEnabled()
                    ? heroTag
                    : '${recipe.name}7',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _RecipeThumbnail(recipe: recipe),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            recipe.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: CulinaryEditorialType.headline(
                              palette,
                              size: 18,
                            ),
                          ),
                        ),
                        PopupMenuButton<_CalendarRecipeAction>(
                          tooltip: S
                              .of(context)
                              .calendar_more_actions(recipe.name),
                          iconColor: palette.onSurfaceVariant,
                          onSelected: (_) => onRemove(),
                          itemBuilder: (_) => [
                            PopupMenuItem(
                              value: _CalendarRecipeAction.remove,
                              child: Row(
                                children: [
                                  const Icon(Icons.delete_outline),
                                  const SizedBox(width: 10),
                                  Text(S.of(context).calendar_remove_from_plan),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        if (hasTime)
                          _MetadataChip(
                            icon: Icons.schedule,
                            label: DateFormat.Hm().format(value.item1),
                            color: palette.primary,
                            palette: palette,
                          ),
                        if (recipe.effort != null)
                          _MetadataChip(
                            icon: Icons.local_fire_department_outlined,
                            label:
                                '${S.of(context).effort} ${recipe.effort}/10',
                            color: palette.tertiary,
                            palette: palette,
                          ),
                        _MetadataChip(
                          icon: recipe.vegetable == Vegetable.NON_VEGETARIAN
                              ? Icons.restaurant_outlined
                              : Icons.eco_outlined,
                          label: _dietLabel(context, recipe.vegetable),
                          color: recipe.vegetable == Vegetable.NON_VEGETARIAN
                              ? palette.onSurfaceVariant
                              : palette.secondary,
                          palette: palette,
                        ),
                        if (recipe.totalTime > 0)
                          _MetadataChip(
                            icon: Icons.timer_outlined,
                            label: getTimeHoursMinutes(recipe.totalTime),
                            color: palette.onSurfaceVariant,
                            palette: palette,
                          ),
                        if (recipe.servings != null)
                          _MetadataChip(
                            icon: Icons.people_outline,
                            label: S
                                .of(context)
                                .shopping_serving_value(
                                  _formatNumber(recipe.servings!),
                                ),
                            color: palette.onSurfaceVariant,
                            palette: palette,
                          ),
                      ],
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

class _RecipeThumbnail extends StatelessWidget {
  const _RecipeThumbnail({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final image = recipe.imagePreviewPath == constants.noRecipeImage
        ? Image.asset(recipe.imagePreviewPath, fit: BoxFit.cover)
        : Image.file(
            File(recipe.imagePreviewPath),
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                Image.asset(constants.noRecipeImage, fit: BoxFit.cover),
          );
    return SizedBox(width: 84, height: 84, child: image);
  }
}

class _MetadataChip extends StatelessWidget {
  const _MetadataChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.palette,
  });

  final IconData icon;
  final String label;
  final Color color;
  final CulinaryEditorialPalette palette;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.surfaceContainer,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: CulinaryEditorialType.body(
                palette,
                size: 10,
                weight: FontWeight.w700,
                color: palette.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExportDock extends StatelessWidget {
  const _ExportDock({
    required this.recipeCount,
    required this.ingredientCount,
    required this.enabled,
    required this.palette,
    required this.embedded,
    required this.onPressed,
  });

  final int recipeCount;
  final int ingredientCount;
  final bool enabled;
  final CulinaryEditorialPalette palette;
  final bool embedded;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        embedded ? 12 : 20,
        8,
        embedded ? 12 : 20,
        12,
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 680),
        padding: const EdgeInsets.fromLTRB(16, 10, 10, 10),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: palette.shadow,
              blurRadius: 26,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final summary = Text(
              enabled
                  ? S
                        .of(context)
                        .calendar_export_summary(recipeCount, ingredientCount)
                  : S.of(context).calendar_no_exportable,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: CulinaryEditorialType.body(
                palette,
                size: 12,
                weight: FontWeight.w700,
              ),
            );
            final button = FilledButton.icon(
              key: const Key('calendar-review-export'),
              style: FilledButton.styleFrom(
                backgroundColor: palette.primary,
                foregroundColor: palette.onPrimary,
                minimumSize: const Size(0, 48),
              ),
              onPressed: enabled ? onPressed : null,
              icon: const Icon(Icons.shopping_cart_outlined, size: 18),
              label: Text(S.of(context).calendar_review_export),
            );
            if (MediaQuery.textScalerOf(context).scale(1) > 1.1) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [summary, const SizedBox(height: 8), button],
              );
            }
            return Row(
              children: [
                Expanded(child: summary),
                const SizedBox(width: 8),
                button,
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CalendarFailure extends StatelessWidget {
  const _CalendarFailure({required this.palette});

  final CulinaryEditorialPalette palette;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.event_busy_outlined, size: 42, color: palette.primary),
            const SizedBox(height: 16),
            Text(
              S.of(context).calendar_load_failed,
              textAlign: TextAlign.center,
              style: CulinaryEditorialType.headline(palette, size: 22),
            ),
            const SizedBox(height: 8),
            Text(
              S.of(context).calendar_load_failed_description,
              textAlign: TextAlign.center,
              style: CulinaryEditorialType.body(
                palette,
                color: palette.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: () => context.read<RecipeCalendarBloc>().add(
                LoadRecipeCalendarEvent(),
              ),
              child: Text(S.of(context).retry),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeekHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _WeekHeaderDelegate({required this.height, required this.child});

  final double height;
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
    return Material(
      color: Colors.transparent,
      elevation: overlapsContent ? 2 : 0,
      child: child,
    );
  }

  @override
  bool shouldRebuild(_WeekHeaderDelegate oldDelegate) =>
      oldDelegate.height != height || oldDelegate.child != child;
}

String _dietLabel(BuildContext context, Vegetable value) => switch (value) {
  Vegetable.NON_VEGETARIAN => S.of(context).diet_meat,
  Vegetable.VEGETARIAN => S.of(context).diet_vegetarian,
  Vegetable.VEGAN => S.of(context).diet_vegan,
};

String _formatNumber(double value) => value == value.roundToDouble()
    ? value.toStringAsFixed(0)
    : value.toStringAsFixed(2).replaceFirst(RegExp(r'0+$'), '');

bool _sameDate(DateTime first, DateTime second) =>
    first.year == second.year &&
    first.month == second.month &&
    first.day == second.day;
