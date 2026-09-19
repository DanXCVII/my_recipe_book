import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../generated/l10n.dart';
import '../../local_storage/local_repository.dart';
import '../culinary_editorial_theme.dart';

@immutable
class CalendarScheduleSelection {
  const CalendarScheduleSelection({
    required this.recipeName,
    required this.scheduledAt,
  });

  final String recipeName;
  final DateTime scheduledAt;
}

Future<CalendarScheduleSelection?> showCalendarSchedule(
  BuildContext context, {
  String? fixedRecipeName,
  DateTime? fixedDate,
  DateTime? initialDate,
  bool allowTime = true,
}) {
  assert(
    fixedDate == null || initialDate == null,
    'Use fixedDate or initialDate, not both.',
  );

  final recipeNames = fixedRecipeName == null
      ? List<String>.of(context.read<LocalRepository>().getRecipeNames())
      : <String>[];
  recipeNames.sort(
    (left, right) => left.toLowerCase().compareTo(right.toLowerCase()),
  );
  final now = DateTime.now();
  final selectedDate =
      fixedDate ?? initialDate ?? DateTime(now.year, now.month, now.day);
  final content = _CalendarScheduleForm(
    recipeNames: recipeNames,
    fixedRecipeName: fixedRecipeName,
    fixedDate: fixedDate,
    initialDate: selectedDate,
    allowTime: allowTime,
  );

  if (MediaQuery.sizeOf(context).width < 600) {
    return showModalBottomSheet<CalendarScheduleSelection>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => _CalendarScheduleSheet(child: content),
    );
  }

  return showDialog<CalendarScheduleSelection>(
    context: context,
    builder: (dialogContext) => _CalendarScheduleDialog(child: content),
  );
}

class _CalendarScheduleSheet extends StatelessWidget {
  const _CalendarScheduleSheet({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final theme = culinaryEditorialTheme(Theme.of(context), palette);
    return Theme(
      data: theme,
      child: SafeArea(
        top: false,
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: Material(
            key: const Key('calendar-schedule-sheet'),
            color: palette.surface,
            shadowColor: palette.shadow,
            elevation: 8,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            clipBehavior: Clip.antiAlias,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class _CalendarScheduleDialog extends StatelessWidget {
  const _CalendarScheduleDialog({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final theme = culinaryEditorialTheme(Theme.of(context), palette);
    return Theme(
      data: theme,
      child: Dialog(
        key: const Key('calendar-schedule-dialog'),
        backgroundColor: palette.surface,
        surfaceTintColor: Colors.transparent,
        shadowColor: palette.shadow,
        elevation: 8,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _CalendarScheduleForm extends StatefulWidget {
  const _CalendarScheduleForm({
    required this.recipeNames,
    required this.fixedRecipeName,
    required this.fixedDate,
    required this.initialDate,
    required this.allowTime,
  });

  final List<String> recipeNames;
  final String? fixedRecipeName;
  final DateTime? fixedDate;
  final DateTime initialDate;
  final bool allowTime;

  @override
  State<_CalendarScheduleForm> createState() => _CalendarScheduleFormState();
}

class _CalendarScheduleFormState extends State<_CalendarScheduleForm> {
  late final TextEditingController _recipeController;
  late final FocusNode _recipeFocusNode;
  late DateTime _selectedDate;
  TimeOfDay? _selectedTime;

  bool get _recipeIsFixed => widget.fixedRecipeName != null;
  bool get _dateIsFixed => widget.fixedDate != null;

  String? get _canonicalRecipeName {
    if (_recipeIsFixed) return widget.fixedRecipeName;
    final input = _recipeController.text.trim().toLowerCase();
    if (input.isEmpty) return null;
    for (final recipeName in widget.recipeNames) {
      if (recipeName.toLowerCase() == input) return recipeName;
    }
    return null;
  }

  bool get _canSubmit => _canonicalRecipeName != null;

  @override
  void initState() {
    super.initState();
    _recipeController = TextEditingController();
    _recipeFocusNode = FocusNode();
    _selectedDate = DateTime(
      widget.initialDate.year,
      widget.initialDate.month,
      widget.initialDate.day,
    );
    if (widget.allowTime &&
        (widget.initialDate.hour != 0 || widget.initialDate.minute != 0)) {
      _selectedTime = TimeOfDay.fromDateTime(widget.initialDate);
    }
    _recipeController.addListener(_onRecipeChanged);
  }

  @override
  void dispose() {
    _recipeController
      ..removeListener(_onRecipeChanged)
      ..dispose();
    _recipeFocusNode.dispose();
    super.dispose();
  }

  void _onRecipeChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final locale = MaterialLocalizations.of(context);
    final isPerDayQuickAdd = _dateIsFixed && !_recipeIsFixed;
    final title = isPerDayQuickAdd
        ? S
              .of(context)
              .calendar_add_for_day(locale.formatMediumDate(_selectedDate))
        : S.of(context).calendar_plan_recipe;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (MediaQuery.sizeOf(context).width < 600) ...[
          Center(
            child: Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: palette.outline.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
          const SizedBox(height: 18),
        ],
        Text(title, style: CulinaryEditorialType.headline(palette, size: 24)),
        const SizedBox(height: 18),
        if (_recipeIsFixed)
          _FixedRecipeSummary(recipeName: widget.fixedRecipeName!)
        else
          _RecipeAutocomplete(
            recipeNames: widget.recipeNames,
            controller: _recipeController,
            focusNode: _recipeFocusNode,
            onSubmitted: _canSubmit ? _submit : null,
          ),
        const SizedBox(height: 16),
        if (_dateIsFixed)
          _FixedDateSummary(date: _selectedDate)
        else ...[
          Text(
            S.of(context).calendar_schedule_when,
            style: CulinaryEditorialType.body(
              palette,
              size: 12,
              weight: FontWeight.w700,
              color: palette.onSurfaceVariant,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          _ScheduleField(
            key: const Key('calendar-schedule-date'),
            icon: Icons.calendar_today_outlined,
            label: S.of(context).calendar_schedule_date,
            value: locale.formatFullDate(_selectedDate),
            onTap: _selectDate,
          ),
          if (widget.allowTime) ...[
            const SizedBox(height: 8),
            _ScheduleField(
              key: const Key('calendar-schedule-time'),
              icon: Icons.schedule_outlined,
              label: S.of(context).calendar_schedule_time_optional,
              value: _selectedTime == null
                  ? S.of(context).calendar_schedule_no_time
                  : locale.formatTimeOfDay(_selectedTime!),
              onTap: _selectTime,
              trailing: _selectedTime == null
                  ? null
                  : IconButton(
                      key: const Key('calendar-schedule-clear-time'),
                      tooltip: S.of(context).calendar_schedule_clear_time,
                      onPressed: () => setState(() => _selectedTime = null),
                      icon: const Icon(Icons.close, size: 20),
                    ),
            ),
          ],
        ],
        const SizedBox(height: 22),
        Row(
          children: [
            TextButton(
              key: const Key('calendar-schedule-cancel'),
              style: TextButton.styleFrom(
                minimumSize: const Size(88, 52),
                foregroundColor: palette.onSurfaceVariant,
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Text(S.of(context).cancel),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: FilledButton.icon(
                key: const Key('calendar-schedule-submit'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(0, 52),
                  backgroundColor: palette.primary,
                  foregroundColor: palette.onPrimary,
                  disabledBackgroundColor: palette.surfaceContainerHigh,
                  disabledForegroundColor: palette.onSurfaceVariant,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _canSubmit ? _submit : null,
                icon: const Icon(Icons.event_available_outlined, size: 20),
                label: Text(S.of(context).add),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _selectDate() async {
    FocusScope.of(context).unfocus();
    final palette = CulinaryEditorialPalette.of(context);
    final baseTheme = Theme.of(context);
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (pickerContext, child) => Theme(
        data: culinaryEditorialTheme(baseTheme, palette),
        child: child!,
      ),
    );
    if (date != null && mounted) {
      setState(() => _selectedDate = date);
    }
  }

  Future<void> _selectTime() async {
    FocusScope.of(context).unfocus();
    final palette = CulinaryEditorialPalette.of(context);
    final baseTheme = Theme.of(context);
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (pickerContext, child) => Theme(
        data: culinaryEditorialTheme(baseTheme, palette),
        child: child!,
      ),
    );
    if (time != null && mounted) {
      setState(() => _selectedTime = time);
    }
  }

  void _submit() {
    final recipeName = _canonicalRecipeName;
    if (recipeName == null) return;
    final time = _selectedTime;
    final scheduledAt = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      time?.hour ?? 0,
      time?.minute ?? 0,
    );
    Navigator.of(context).pop(
      CalendarScheduleSelection(
        recipeName: recipeName,
        scheduledAt: scheduledAt,
      ),
    );
  }
}

class _RecipeAutocomplete extends StatelessWidget {
  const _RecipeAutocomplete({
    required this.recipeNames,
    required this.controller,
    required this.focusNode,
    required this.onSubmitted,
  });

  final List<String> recipeNames;
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final input = controller.text.trim();
    final hasCanonicalMatch = recipeNames.any(
      (name) => name.toLowerCase() == input.toLowerCase(),
    );
    final errorText = input.isNotEmpty && !hasCanonicalMatch
        ? S.of(context).no_recipe_with_this_name
        : null;

    if (recipeNames.isEmpty) {
      return Container(
        key: const Key('calendar-schedule-empty-recipes'),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: palette.surfaceContainer,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.menu_book_outlined, color: palette.onSurfaceVariant),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                S.of(context).calendar_schedule_no_saved_recipes,
                style: CulinaryEditorialType.body(
                  palette,
                  size: 13,
                  color: palette.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) => RawAutocomplete<String>(
        textEditingController: controller,
        focusNode: focusNode,
        displayStringForOption: (option) => option,
        optionsBuilder: (value) {
          final query = value.text.trim().toLowerCase();
          if (query.isEmpty) return const Iterable<String>.empty();
          return recipeNames.where(
            (name) => name.toLowerCase().contains(query),
          );
        },
        onSelected: (option) {
          controller
            ..text = option
            ..selection = TextSelection.collapsed(offset: option.length);
        },
        fieldViewBuilder: (context, textController, fieldFocusNode, _) {
          return TextField(
            key: const Key('calendar-schedule-recipe'),
            controller: textController,
            focusNode: fieldFocusNode,
            autofocus: true,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => onSubmitted?.call(),
            decoration: InputDecoration(
              labelText: S.of(context).recipe_name,
              hintText: S.of(context).calendar_schedule_recipe_hint,
              errorText: errorText,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: input.isEmpty
                  ? null
                  : IconButton(
                      tooltip: S.of(context).clear_search,
                      onPressed: controller.clear,
                      icon: const Icon(Icons.close),
                    ),
            ),
          );
        },
        optionsViewBuilder: (context, onSelected, options) {
          final visibleOptions = options.toList(growable: false);
          if (visibleOptions.isEmpty) return const SizedBox.shrink();
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              color: palette.surfaceContainerHigh,
              elevation: 3,
              shadowColor: palette.shadow,
              borderRadius: BorderRadius.circular(12),
              clipBehavior: Clip.antiAlias,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: constraints.maxWidth,
                  maxHeight: 240,
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  shrinkWrap: true,
                  itemCount: visibleOptions.length,
                  itemBuilder: (context, index) {
                    final option = visibleOptions[index];
                    return InkWell(
                      onTap: () => onSelected(option),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minHeight: 48),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Text(
                            option,
                            style: CulinaryEditorialType.body(
                              palette,
                              size: 14,
                              weight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FixedRecipeSummary extends StatelessWidget {
  const _FixedRecipeSummary({required this.recipeName});

  final String recipeName;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Container(
      key: const Key('calendar-schedule-fixed-recipe'),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: palette.surfaceContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: palette.primarySoft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.menu_book_outlined, color: palette.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              recipeName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: CulinaryEditorialType.headline(palette, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}

class _FixedDateSummary extends StatelessWidget {
  const _FixedDateSummary({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Container(
      key: const Key('calendar-schedule-fixed-date'),
      constraints: const BoxConstraints(minHeight: 56),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: palette.surfaceContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_today_outlined, color: palette.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              MaterialLocalizations.of(context).formatFullDate(date),
              style: CulinaryEditorialType.body(
                palette,
                size: 14,
                weight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScheduleField extends StatelessWidget {
  const _ScheduleField({
    required super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
    this.trailing,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Material(
      color: palette.surfaceContainer,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 8, 8),
            child: Row(
              children: [
                Icon(icon, color: palette.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: CulinaryEditorialType.body(
                          palette,
                          size: 11,
                          weight: FontWeight.w700,
                          color: palette.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        value,
                        style: CulinaryEditorialType.body(
                          palette,
                          size: 14,
                          weight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                trailing ??
                    Icon(Icons.chevron_right, color: palette.onSurfaceVariant),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
