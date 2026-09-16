import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/recipe_screen_ingredients/recipe_screen_ingredients_bloc.dart';
import '../../constants/global_settings.dart';
import '../../generated/l10n.dart';
import '../../models/ingredient.dart';
import '../../models/recipe.dart';
import '../../util/helper.dart';
import '../dialogs/number_dialog.dart';
import '../culinary_editorial_theme.dart';

class EditorialIngredientsPanel extends StatelessWidget {
  const EditorialIngredientsPanel({super.key, required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final ingredientCount = recipe.ingredients.fold<int>(
      0,
      (count, section) => count + section.length,
    );
    if (ingredientCount == 0) {
      return _EmptyPanel(
        icon: Icons.shopping_basket_outlined,
        message: S.of(context).recipe_ingredients_empty,
      );
    }

    return BlocBuilder<
      RecipeScreenIngredientsBloc,
      RecipeScreenIngredientsState
    >(
      builder: (context, state) {
        if (state is! LoadedRecipeIngredients) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(),
            ),
          );
        }
        final flat = state.ingredients.expand((section) => section).toList();
        final checkedCount = flat
            .where((ingredient) => ingredient.checked)
            .length;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final heading = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).pantry_checklist,
                      style: CulinaryEditorialType.headline(
                        palette,
                        size: 20,
                        weight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      S.of(context).pantry_checklist_help,
                      style: CulinaryEditorialType.body(
                        palette,
                        size: 12,
                        color: palette.onSurfaceVariant,
                      ),
                    ),
                  ],
                );
                final servingStepper = state.servings == null
                    ? const SizedBox.shrink()
                    : _ServingStepper(
                        recipe: recipe,
                        servings: state.servings!,
                      );
                if (constraints.maxWidth < 390 && state.servings != null) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      heading,
                      const SizedBox(height: 12),
                      servingStepper,
                    ],
                  );
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: heading),
                    if (state.servings != null) ...[
                      const SizedBox(width: 12),
                      servingStepper,
                    ],
                  ],
                );
              },
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.tonalIcon(
                key: const Key('recipe-add-all-ingredients'),
                onPressed: () => _toggleAll(context, state),
                icon: Icon(
                  checkedCount == flat.length
                      ? Icons.remove_shopping_cart_outlined
                      : Icons.shopping_cart_checkout_outlined,
                ),
                label: Text(
                  checkedCount == flat.length
                      ? S.of(context).remove_all_from_shopping_list
                      : checkedCount == 0
                      ? S.of(context).add_all_to_shopping_list(flat.length)
                      : S
                            .of(context)
                            .add_remaining_to_shopping_list(
                              flat.length - checkedCount,
                            ),
                ),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  backgroundColor: palette.primarySoft,
                  foregroundColor: palette.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: CulinaryEditorialType.body(
                    palette,
                    size: 13,
                    weight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ...List.generate(state.ingredients.length, (sectionIndex) {
              final ingredients = state.ingredients[sectionIndex];
              if (ingredients.isEmpty) return const SizedBox.shrink();
              final hasSections = recipe.ingredientsGlossary.isNotEmpty;
              final sectionTitle =
                  sectionIndex < recipe.ingredientsGlossary.length
                  ? recipe.ingredientsGlossary[sectionIndex].trim()
                  : '';
              final sectionChecked =
                  sectionIndex < (state.sectionCheck?.length ?? 0)
                  ? state.sectionCheck![sectionIndex]
                  : ingredients.every((ingredient) => ingredient.checked);
              return Padding(
                padding: EdgeInsets.only(top: sectionIndex == 0 ? 0 : 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (hasSections && sectionTitle.isNotEmpty)
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              sectionTitle,
                              style: CulinaryEditorialType.headline(
                                palette,
                                size: 17,
                                weight: FontWeight.w600,
                              ),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () => _toggleSection(
                              context,
                              state,
                              ingredients,
                              sectionChecked,
                            ),
                            icon: Icon(
                              sectionChecked
                                  ? Icons.remove_shopping_cart_outlined
                                  : Icons.add_shopping_cart_outlined,
                              size: 18,
                            ),
                            label: Text(
                              sectionChecked
                                  ? S.of(context).remove_section_from_cart
                                  : S.of(context).add_section_to_cart,
                            ),
                          ),
                        ],
                      ),
                    if (hasSections && sectionTitle.isNotEmpty)
                      const SizedBox(height: 7),
                    ...ingredients.map(
                      (ingredient) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _IngredientRow(
                          ingredient: ingredient,
                          onPressed: () =>
                              _toggleIngredient(context, state, ingredient),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        );
      },
    );
  }

  void _toggleIngredient(
    BuildContext context,
    LoadedRecipeIngredients state,
    CheckableIngredient ingredient,
  ) {
    final bloc = context.read<RecipeScreenIngredientsBloc>();
    if (ingredient.checked) {
      bloc.add(RemoveFromCart(recipe.name, [ingredient.getIngredient()]));
    } else {
      bloc.add(
        AddToCart(recipe.name, [
          ingredient.getIngredient(),
        ], servings: state.servings),
      );
    }
  }

  void _toggleSection(
    BuildContext context,
    LoadedRecipeIngredients state,
    List<CheckableIngredient> ingredients,
    bool sectionChecked,
  ) {
    final bloc = context.read<RecipeScreenIngredientsBloc>();
    if (sectionChecked) {
      bloc.add(
        RemoveFromCart(
          recipe.name,
          ingredients.map((ingredient) => ingredient.getIngredient()).toList(),
        ),
      );
    } else {
      bloc.add(
        AddToCart(
          recipe.name,
          ingredients
              .where((ingredient) => !ingredient.checked)
              .map((ingredient) => ingredient.getIngredient())
              .toList(),
          servings: state.servings,
        ),
      );
    }
  }

  void _toggleAll(BuildContext context, LoadedRecipeIngredients state) {
    final ingredients = state.ingredients.expand((section) => section).toList();
    final allChecked = ingredients.every((ingredient) => ingredient.checked);
    final bloc = context.read<RecipeScreenIngredientsBloc>();
    if (allChecked) {
      bloc.add(
        RemoveFromCart(
          recipe.name,
          ingredients.map((ingredient) => ingredient.getIngredient()).toList(),
        ),
      );
    } else {
      bloc.add(
        AddToCart(
          recipe.name,
          ingredients
              .where((ingredient) => !ingredient.checked)
              .map((ingredient) => ingredient.getIngredient())
              .toList(),
          servings: state.servings,
        ),
      );
    }
  }
}

class _ServingStepper extends StatelessWidget {
  const _ServingStepper({required this.recipe, required this.servings});

  final Recipe recipe;
  final double servings;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Semantics(
      label: S.of(context).serving_adjuster,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: palette.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _StepperButton(
              tooltip: S.of(context).decrease_servings,
              icon: Icons.remove,
              onPressed: servings <= 1
                  ? null
                  : () => _update(context, servings - 1),
            ),
            InkWell(
              key: const Key('recipe-serving-value'),
              onTap: () => _editServings(context),
              borderRadius: BorderRadius.circular(999),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 74, minHeight: 40),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      '${_number(servings)} ${recipe.servingName ?? S.of(context).servings}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: CulinaryEditorialType.body(
                        palette,
                        size: 12,
                        weight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            _StepperButton(
              tooltip: S.of(context).increase_servings,
              icon: Icons.add,
              onPressed: () => _update(context, servings + 1),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _editServings(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (_) => NumberDialog(
        prefilledText: servings.toStringAsFixed(1),
        validation: (value) {
          final parsed = value == null ? null : getDoubleFromString(value);
          return parsed != null && parsed > 0
              ? null
              : S.of(context).shopping_invalid_servings;
        },
        save: (value) {
          final parsed = getDoubleFromString(value);
          if (parsed != null) _update(context, parsed);
        },
      ),
    );
  }

  void _update(BuildContext context, double value) {
    if (value <= 0) return;
    context.read<RecipeScreenIngredientsBloc>().add(
      UpdateServings(servings, value),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      constraints: const BoxConstraints.tightFor(width: 40, height: 40),
      style: IconButton.styleFrom(
        backgroundColor: palette.surface,
        foregroundColor: palette.onSurface,
        disabledForegroundColor: palette.onSurfaceVariant.withValues(alpha: .4),
      ),
    );
  }
}

class _IngredientRow extends StatelessWidget {
  const _IngredientRow({required this.ingredient, required this.onPressed});

  final CheckableIngredient ingredient;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final amount = _ingredientAmount(ingredient);
    return Semantics(
      button: true,
      checked: ingredient.checked,
      label: [
        amount,
        ingredient.name,
      ].where((part) => part.isNotEmpty).join(' '),
      child: Material(
        color: palette.surface,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 54),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: ingredient.checked
                          ? palette.secondary
                          : palette.surfaceContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: ingredient.checked
                        ? Icon(Icons.check, size: 16, color: palette.onPrimary)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 180),
                      opacity: ingredient.checked ? .48 : 1,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            if (amount.isNotEmpty)
                              TextSpan(
                                text: '$amount ',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            TextSpan(text: ingredient.name),
                          ],
                        ),
                        style:
                            CulinaryEditorialType.body(
                              palette,
                              size: 14,
                              color: palette.onSurface,
                            ).copyWith(
                              decoration: ingredient.checked
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                      ),
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
}

class _EmptyPanel extends StatelessWidget {
  const _EmptyPanel({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: palette.surfaceContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(icon, color: palette.onSurfaceVariant),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: CulinaryEditorialType.body(
              palette,
              color: palette.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

String _ingredientAmount(CheckableIngredient ingredient) {
  final amount = ingredient.amount == null
      ? ''
      : GlobalSettings().showDecimal()
      ? cutDouble(ingredient.amount!)
      : getFractionDouble(ingredient.amount!);
  return [amount, ingredient.unit]
      .where((part) => part != null && part.toString().trim().isNotEmpty)
      .join(' ');
}

String _number(double value) => value % 1 == 0
    ? value.toInt().toString()
    : value
          .toStringAsFixed(2)
          .replaceFirst(RegExp(r'0+$'), '')
          .replaceFirst(RegExp(r'\.$'), '');
