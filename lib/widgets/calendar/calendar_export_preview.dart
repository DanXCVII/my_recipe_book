import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/shopping_cart/shopping_cart_bloc.dart';
import '../../generated/l10n.dart';
import '../../models/ingredient.dart';
import '../../models/recipe.dart';
import '../../models/shopping_cart_recipe_addition.dart';
import '../../util/helper.dart';
import '../culinary_editorial_theme.dart';

class CalendarExportRecipeDraft {
  CalendarExportRecipeDraft({
    required this.recipe,
    required this.occurrenceCount,
  }) : ingredients = _consolidate(recipe.ingredients),
       totalServings = recipe.servings != null && recipe.servings! > 0
           ? recipe.servings! * occurrenceCount
           : null {
    selected.addAll(List<int>.generate(ingredients.length, (index) => index));
  }

  final Recipe recipe;
  final int occurrenceCount;
  final List<Ingredient> ingredients;
  final Set<int> selected = <int>{};
  double? totalServings;

  bool get hasServingBaseline =>
      recipe.servings != null && recipe.servings! > 0;

  double get scale => hasServingBaseline
      ? totalServings! / recipe.servings!
      : occurrenceCount.toDouble();

  List<Ingredient> get selectedScaledIngredients {
    final indexes = selected.toList()..sort();
    return indexes
        .map((index) {
          final ingredient = ingredients[index];
          return ingredient.copyWith(
            amount: ingredient.amount == null
                ? null
                : ingredient.amount! * scale,
            clearAmount: ingredient.amount == null,
          );
        })
        .toList(growable: false);
  }

  static List<Ingredient> _consolidate(List<List<Ingredient>> groups) {
    final result = <Ingredient>[];
    for (final ingredient in groups.expand((group) => group)) {
      final index = result.indexWhere(
        (value) =>
            value.name == ingredient.name && value.unit == ingredient.unit,
      );
      if (index < 0) {
        result.add(ingredient);
        continue;
      }
      final old = result[index];
      result[index] = old.copyWith(
        amount: old.amount != null && ingredient.amount != null
            ? old.amount! + ingredient.amount!
            : old.amount ?? ingredient.amount,
        clearAmount: old.amount == null && ingredient.amount == null,
      );
    }
    return result;
  }
}

class CalendarExportPreviewSheet extends StatefulWidget {
  const CalendarExportPreviewSheet({required this.drafts, super.key});

  final List<CalendarExportRecipeDraft> drafts;

  @override
  State<CalendarExportPreviewSheet> createState() =>
      _CalendarExportPreviewSheetState();
}

class _CalendarExportPreviewSheetState
    extends State<CalendarExportPreviewSheet> {
  bool _submitting = false;
  bool _failed = false;

  int get _selectedCount =>
      widget.drafts.fold(0, (sum, draft) => sum + draft.selected.length);

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final baseTheme = Theme.of(context);
    final editorialTheme = culinaryEditorialTheme(baseTheme, palette).copyWith(
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.selected) ? palette.primary : null,
        ),
      ),
    );
    return Theme(
      data: editorialTheme,
      child: BlocListener<ShoppingCartBloc, ShoppingCartState>(
        listener: (context, state) {
          if (!_submitting || state is! LoadedShoppingCart) return;
          if (state.actionError == ShoppingCartActionError.add) {
            setState(() {
              _submitting = false;
              _failed = true;
            });
          } else {
            Navigator.of(context).pop(_selectedCount);
          }
        },
        child: Material(
          color: palette.surface,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.viewInsetsOf(context).bottom,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: palette.outline.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                S.of(context).calendar_review_title,
                                style: CulinaryEditorialType.headline(
                                  palette,
                                  size: 26,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                S.of(context).calendar_review_description,
                                style: CulinaryEditorialType.body(
                                  palette,
                                  size: 13,
                                  color: palette.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: MaterialLocalizations.of(context)
                              .closeButtonTooltip,
                          style: IconButton.styleFrom(
                            foregroundColor: palette.onSurfaceVariant,
                          ),
                          onPressed: _submitting
                              ? null
                              : () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                      itemCount: widget.drafts.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) => _RecipeExportSection(
                        draft: widget.drafts[index],
                        palette: palette,
                        onChanged: () => setState(() => _failed = false),
                        onEditServings: () =>
                            _editServings(widget.drafts[index], palette),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                    decoration: BoxDecoration(
                      color: palette.surface,
                      boxShadow: [
                        BoxShadow(
                          color: palette.shadow,
                          blurRadius: 20,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (_failed) ...[
                          Text(
                            S.of(context).shopping_action_failed,
                            style: CulinaryEditorialType.body(
                              palette,
                              size: 12,
                              weight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                S
                                    .of(context)
                                    .calendar_selected_count(_selectedCount),
                                style: CulinaryEditorialType.body(
                                  palette,
                                  size: 12,
                                  weight: FontWeight.w700,
                                  color: palette.onSurfaceVariant,
                                ),
                              ),
                            ),
                            FilledButton.icon(
                              key: const Key('calendar-export-confirm'),
                              onPressed: _selectedCount == 0 || _submitting
                                  ? null
                                  : _submit,
                              icon: _submitting
                                  ? const SizedBox.square(
                                      dimension: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.shopping_cart_checkout),
                              label: Text(S.of(context).calendar_add_selected),
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
        ),
      ),
    );
  }

  Future<void> _editServings(
    CalendarExportRecipeDraft draft,
    CulinaryEditorialPalette palette,
  ) async {
    if (!draft.hasServingBaseline) return;
    final controller = TextEditingController(
      text: _formatNumber(draft.totalServings!),
    );
    final formKey = GlobalKey<FormState>();
    final value = await showDialog<double>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: palette.surface,
        title: Text(
          draft.recipe.name,
          style: CulinaryEditorialType.headline(palette, size: 20),
        ),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: S.of(context).servings),
            validator: (text) {
              final parsed = getDoubleFromString(text ?? '');
              return parsed == null || parsed <= 0
                  ? S.of(context).shopping_invalid_servings
                  : null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(S.of(context).cancel),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(
                  dialogContext,
                  getDoubleFromString(controller.text),
                );
              }
            },
            child: Text(S.of(context).done),
          ),
        ],
      ),
    );
    controller.dispose();
    if (value != null && mounted) {
      setState(() {
        draft.totalServings = value;
        _failed = false;
      });
    }
  }

  void _submit() {
    final additions = widget.drafts
        .map(
          (draft) => ShoppingCartRecipeAddition(
            recipeName: draft.recipe.name,
            ingredients: draft.selectedScaledIngredients,
            servings: draft.totalServings,
          ),
        )
        .where((addition) => addition.ingredients.isNotEmpty)
        .toList(growable: false);
    setState(() {
      _submitting = true;
      _failed = false;
    });
    context.read<ShoppingCartBloc>().add(MergeShoppingCartRecipes(additions));
  }
}

class _RecipeExportSection extends StatelessWidget {
  const _RecipeExportSection({
    required this.draft,
    required this.palette,
    required this.onChanged,
    required this.onEditServings,
  });

  final CalendarExportRecipeDraft draft;
  final CulinaryEditorialPalette palette;
  final VoidCallback onChanged;
  final VoidCallback onEditServings;

  @override
  Widget build(BuildContext context) {
    final selectedCount = draft.selected.length;
    final checkboxValue = selectedCount == 0
        ? false
        : selectedCount == draft.ingredients.length
        ? true
        : null;
    return Material(
      color: palette.surfaceContainer,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        initiallyExpanded: true,
        tilePadding: const EdgeInsets.fromLTRB(8, 8, 12, 8),
        childrenPadding: const EdgeInsets.fromLTRB(8, 0, 12, 12),
        leading: Checkbox(
          tristate: true,
          value: checkboxValue,
          semanticLabel: S
              .of(context)
              .calendar_select_recipe_ingredients(draft.recipe.name),
          onChanged: draft.ingredients.isEmpty
              ? null
              : (selected) {
                  draft.selected.clear();
                  if (selected ?? false) {
                    draft.selected.addAll(
                      List<int>.generate(
                        draft.ingredients.length,
                        (index) => index,
                      ),
                    );
                  }
                  onChanged();
                },
        ),
        title: Text(
          draft.recipe.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: CulinaryEditorialType.headline(palette, size: 18),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Wrap(
            spacing: 8,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                S.of(context).calendar_planned_count(draft.occurrenceCount),
                style: CulinaryEditorialType.body(
                  palette,
                  size: 11,
                  color: palette.onSurfaceVariant,
                ),
              ),
              if (draft.hasServingBaseline)
                _ServingControl(
                  value: draft.totalServings!,
                  palette: palette,
                  onDecrease: draft.totalServings! > 1
                      ? () {
                          draft.totalServings = draft.totalServings! - 1 < 1
                              ? 1
                              : draft.totalServings! - 1;
                          onChanged();
                        }
                      : null,
                  onIncrease: () {
                    draft.totalServings = draft.totalServings! + 1;
                    onChanged();
                  },
                  onEdit: onEditServings,
                )
              else
                Text(
                  S.of(context).calendar_servings_not_set,
                  style: CulinaryEditorialType.body(
                    palette,
                    size: 11,
                    weight: FontWeight.w600,
                    color: palette.outline,
                  ),
                ),
            ],
          ),
        ),
        children: draft.ingredients.isEmpty
            ? [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    S.of(context).you_have_no_ingredients,
                    style: CulinaryEditorialType.body(
                      palette,
                      color: palette.onSurfaceVariant,
                    ),
                  ),
                ),
              ]
            : List<Widget>.generate(draft.ingredients.length, (index) {
                final ingredient = draft.ingredients[index];
                final scaledAmount = ingredient.amount == null
                    ? null
                    : ingredient.amount! * draft.scale;
                return CheckboxListTile(
                  dense: false,
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  value: draft.selected.contains(index),
                  onChanged: (selected) {
                    if (selected ?? false) {
                      draft.selected.add(index);
                    } else {
                      draft.selected.remove(index);
                    }
                    onChanged();
                  },
                  title: Text(
                    _ingredientLabel(ingredient, scaledAmount),
                    style: CulinaryEditorialType.body(palette, size: 13),
                  ),
                );
              }),
      ),
    );
  }
}

class _ServingControl extends StatelessWidget {
  const _ServingControl({
    required this.value,
    required this.palette,
    required this.onDecrease,
    required this.onIncrease,
    required this.onEdit,
  });

  final double value;
  final CulinaryEditorialPalette palette;
  final VoidCallback? onDecrease;
  final VoidCallback onIncrease;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: S.of(context).decrease_servings,
            style: IconButton.styleFrom(foregroundColor: palette.primary),
            visualDensity: VisualDensity.compact,
            onPressed: onDecrease,
            icon: const Icon(Icons.remove, size: 18),
          ),
          TextButton(
            onPressed: onEdit,
            style: TextButton.styleFrom(
              minimumSize: const Size(48, 48),
              foregroundColor: palette.onSurface,
            ),
            child: Text(_formatNumber(value)),
          ),
          IconButton(
            tooltip: S.of(context).increase_servings,
            style: IconButton.styleFrom(foregroundColor: palette.primary),
            visualDensity: VisualDensity.compact,
            onPressed: onIncrease,
            icon: const Icon(Icons.add, size: 18),
          ),
        ],
      ),
    );
  }
}

String _ingredientLabel(Ingredient ingredient, double? amount) {
  final quantity = amount == null ? '' : getFractionDouble(amount);
  final unit = ingredient.unit?.trim() ?? '';
  return [
    quantity,
    unit,
    ingredient.name,
  ].where((part) => part.isNotEmpty).join(' ');
}

String _formatNumber(double value) => value == value.roundToDouble()
    ? value.toStringAsFixed(0)
    : value.toStringAsFixed(2).replaceFirst(RegExp(r'0+$'), '');
