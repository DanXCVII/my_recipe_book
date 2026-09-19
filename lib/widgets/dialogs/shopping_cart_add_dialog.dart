import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/shopping_cart/shopping_cart_bloc.dart';
import '../../generated/l10n.dart';
import '../../local_storage/local_repository.dart';
import '../../models/ingredient.dart';
import '../../util/helper.dart';
import '../culinary_editorial_theme.dart';

const double _expandedLayoutBreakpoint = 600;

Future<void> showShoppingCartAddIngredient(BuildContext context) {
  final cartBloc = context.read<ShoppingCartBloc>();
  final repository = context.read<LocalRepository>();
  final ingredientNames = repository.getIngredientNames();
  final recipeNames = repository.getRecipeNames();
  final useDialog =
      MediaQuery.sizeOf(context).width >= _expandedLayoutBreakpoint;

  Widget form({required bool isSheet}) => BlocProvider.value(
    value: cartBloc,
    child: _ShoppingCartIngredientSurface(
      ingredientNames: ingredientNames,
      recipeNames: recipeNames,
      isSheet: isSheet,
    ),
  );

  if (useDialog) {
    return showDialog<void>(
      context: context,
      builder: (_) => Dialog(
        key: const Key('shopping-cart-add-dialog'),
        insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560, maxHeight: 720),
          child: form(isSheet: false),
        ),
      ),
    );
  }

  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      final keyboardInset = MediaQuery.viewInsetsOf(sheetContext).bottom;
      return Padding(
        padding: EdgeInsets.only(bottom: keyboardInset),
        child: FractionallySizedBox(
          key: const Key('shopping-cart-add-sheet'),
          heightFactor: .92,
          child: form(isSheet: true),
        ),
      );
    },
  );
}

class _ShoppingCartIngredientSurface extends StatefulWidget {
  const _ShoppingCartIngredientSurface({
    required this.ingredientNames,
    required this.recipeNames,
    required this.isSheet,
  });

  final List<String> ingredientNames;
  final List<String> recipeNames;
  final bool isSheet;

  @override
  State<_ShoppingCartIngredientSurface> createState() =>
      _ShoppingCartIngredientSurfaceState();
}

class _ShoppingCartIngredientSurfaceState
    extends State<_ShoppingCartIngredientSurface> {
  final _formKey = GlobalKey<FormState>();
  final _ingredientController = TextEditingController();
  final _amountController = TextEditingController();
  final _unitController = TextEditingController();
  final _recipeController = TextEditingController();
  final _ingredientFocus = FocusNode();
  final _amountFocus = FocusNode();
  final _unitFocus = FocusNode();
  final _recipeFocus = FocusNode();

  String? _selectedRecipe;
  String? _feedbackIngredient;
  bool _submitting = false;
  bool _keepOpenAfterSubmit = false;

  @override
  void dispose() {
    _ingredientController.dispose();
    _amountController.dispose();
    _unitController.dispose();
    _recipeController.dispose();
    _ingredientFocus.dispose();
    _amountFocus.dispose();
    _unitFocus.dispose();
    _recipeFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final borderRadius = widget.isSheet
        ? const BorderRadius.vertical(top: Radius.circular(28))
        : BorderRadius.circular(24);

    return PopScope(
      canPop: !_submitting,
      child: Material(
        color: palette.surface,
        borderRadius: borderRadius,
        clipBehavior: Clip.antiAlias,
        child: BlocListener<ShoppingCartBloc, ShoppingCartState>(
          listener: _onCartState,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.isSheet) _DragHandle(palette: palette),
              _Header(
                palette: palette,
                enabled: !_submitting,
                onClose: () => Navigator.of(context).pop(),
              ),
              Divider(height: 1, color: palette.outline.withValues(alpha: .2)),
              Expanded(
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _SectionLabel(
                          label: S.of(context).shopping_ingredient_name,
                          palette: palette,
                        ),
                        const SizedBox(height: 8),
                        _ingredientAutocomplete(context),
                        const SizedBox(height: 22),
                        _SectionLabel(
                          label: S.of(context).shopping_quantity_measure,
                          palette: palette,
                        ),
                        const SizedBox(height: 8),
                        _quantityFields(context),
                        const SizedBox(height: 22),
                        _SectionLabel(
                          label: S.of(context).shopping_link_recipe_optional,
                          palette: palette,
                        ),
                        const SizedBox(height: 8),
                        _recipeAutocomplete(context),
                        if (_selectedRecipe != null) ...[
                          const SizedBox(height: 8),
                          _SelectedRecipe(
                            name: _selectedRecipe!,
                            palette: palette,
                            enabled: !_submitting,
                            onUnlink: _unlinkRecipe,
                          ),
                        ],
                        const SizedBox(height: 24),
                        _actions(context, palette),
                        if (_feedbackIngredient != null) ...[
                          const SizedBox(height: 10),
                          Semantics(
                            liveRegion: true,
                            child: _SuccessMessage(
                              message: S
                                  .of(context)
                                  .shopping_ingredient_added(
                                    _feedbackIngredient!,
                                  ),
                              palette: palette,
                            ),
                          ),
                        ],
                      ],
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

  Widget _ingredientAutocomplete(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => RawAutocomplete<String>(
        textEditingController: _ingredientController,
        focusNode: _ingredientFocus,
        optionsBuilder: (value) =>
            _rankSuggestions(widget.ingredientNames, value.text),
        onSelected: (value) {
          _ingredientController.text = value;
          setState(() => _feedbackIngredient = null);
        },
        fieldViewBuilder: (context, controller, focusNode, _) => TextFormField(
          key: const Key('shopping-cart-add-name'),
          controller: controller,
          focusNode: focusNode,
          autofocus: true,
          textCapitalization: S.of(context).two_char_locale == 'EN'
              ? TextCapitalization.none
              : TextCapitalization.sentences,
          textInputAction: TextInputAction.next,
          enabled: !_submitting,
          style: CulinaryEditorialType.body(
            CulinaryEditorialPalette.of(context),
            size: 15,
          ),
          cursorColor: CulinaryEditorialPalette.of(context).primary,
          validator: (value) => value == null || value.trim().isEmpty
              ? S.of(context).shopping_ingredient_required
              : null,
          onChanged: (_) => setState(() => _feedbackIngredient = null),
          onFieldSubmitted: (_) => _amountFocus.requestFocus(),
          decoration: _fieldDecoration(
            context,
            hint: S.of(context).shopping_ingredient_hint,
            prefixIcon: Icons.shopping_basket_outlined,
            controller: controller,
            focusNode: focusNode,
          ),
        ),
        optionsViewBuilder: (context, onSelected, options) => _SuggestionMenu(
          width: constraints.maxWidth,
          options: options,
          icon: Icons.restaurant_menu,
          palette: CulinaryEditorialPalette.of(context),
          onSelected: onSelected,
        ),
      ),
    );
  }

  Widget _quantityFields(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final stack = constraints.maxWidth < 360;
        final amount = TextFormField(
          key: const Key('shopping-cart-add-amount'),
          controller: _amountController,
          focusNode: _amountFocus,
          enabled: !_submitting,
          style: CulinaryEditorialType.body(
            CulinaryEditorialPalette.of(context),
            size: 15,
          ),
          cursorColor: CulinaryEditorialPalette.of(context).primary,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (value == null || value.trim().isEmpty) return null;
            return getDoubleFromString(value) == null
                ? S.of(context).no_valid_number
                : null;
          },
          onFieldSubmitted: (_) => _unitFocus.requestFocus(),
          decoration: _fieldDecoration(
            context,
            label: S.of(context).amount,
            prefixIcon: Icons.numbers,
            controller: _amountController,
            focusNode: _amountFocus,
          ),
        );
        final unit = TextFormField(
          key: const Key('shopping-cart-add-unit'),
          controller: _unitController,
          focusNode: _unitFocus,
          enabled: !_submitting,
          style: CulinaryEditorialType.body(
            CulinaryEditorialPalette.of(context),
            size: 15,
          ),
          cursorColor: CulinaryEditorialPalette.of(context).primary,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) => _recipeFocus.requestFocus(),
          decoration: _fieldDecoration(
            context,
            label: S.of(context).unit,
            prefixIcon: Icons.scale_outlined,
            controller: _unitController,
            focusNode: _unitFocus,
          ),
        );
        if (stack) {
          return Column(children: [amount, const SizedBox(height: 10), unit]);
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: amount),
            const SizedBox(width: 10),
            Expanded(child: unit),
          ],
        );
      },
    );
  }

  Widget _recipeAutocomplete(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => RawAutocomplete<String>(
        textEditingController: _recipeController,
        focusNode: _recipeFocus,
        optionsBuilder: (value) =>
            _rankSuggestions(widget.recipeNames, value.text),
        onSelected: (value) {
          setState(() {
            _selectedRecipe = value;
            _feedbackIngredient = null;
          });
          _recipeController.text = value;
        },
        fieldViewBuilder: (context, controller, focusNode, _) => TextFormField(
          key: const Key('shopping-cart-add-recipe'),
          controller: controller,
          focusNode: focusNode,
          enabled: !_submitting,
          style: CulinaryEditorialType.body(
            CulinaryEditorialPalette.of(context),
            size: 15,
          ),
          cursorColor: CulinaryEditorialPalette.of(context).primary,
          textInputAction: TextInputAction.done,
          validator: (value) {
            final query = value?.trim() ?? '';
            if (query.isEmpty) return null;
            if (_selectedRecipe == query) return null;
            return S.of(context).shopping_select_saved_recipe;
          },
          onChanged: (value) {
            if (_selectedRecipe == value) return;
            setState(() {
              _selectedRecipe = null;
              _feedbackIngredient = null;
            });
          },
          onFieldSubmitted: (_) => _submit(keepOpen: false),
          decoration: _fieldDecoration(
            context,
            hint: S.of(context).shopping_recipe_search_hint,
            prefixIcon: Icons.menu_book_outlined,
            controller: controller,
            focusNode: focusNode,
          ),
        ),
        optionsViewBuilder: (context, onSelected, options) => _SuggestionMenu(
          width: constraints.maxWidth,
          options: options,
          icon: Icons.menu_book_outlined,
          palette: CulinaryEditorialPalette.of(context),
          onSelected: onSelected,
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration(
    BuildContext context, {
    String? label,
    String? hint,
    required IconData prefixIcon,
    required TextEditingController controller,
    required FocusNode focusNode,
  }) {
    final palette = CulinaryEditorialPalette.of(context);
    final fieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    );
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: palette.surfaceContainer,
      constraints: const BoxConstraints(minHeight: 56),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      labelStyle: CulinaryEditorialType.body(
        palette,
        size: 13,
        color: palette.onSurfaceVariant,
      ),
      hintStyle: CulinaryEditorialType.body(
        palette,
        size: 14,
        color: palette.onSurfaceVariant.withValues(alpha: .78),
      ),
      border: fieldBorder,
      enabledBorder: fieldBorder,
      disabledBorder: fieldBorder,
      focusedBorder: fieldBorder.copyWith(
        borderSide: BorderSide(color: palette.primary, width: 1.5),
      ),
      errorBorder: fieldBorder.copyWith(
        borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
      ),
      focusedErrorBorder: fieldBorder.copyWith(
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.error,
          width: 1.5,
        ),
      ),
      prefixIcon: Icon(prefixIcon, color: palette.primary),
      suffixIcon: controller.text.isEmpty
          ? null
          : IconButton(
              tooltip: S.of(context).shopping_clear_field,
              onPressed: _submitting
                  ? null
                  : () {
                      controller.clear();
                      if (controller == _recipeController) {
                        _selectedRecipe = null;
                      }
                      setState(() => _feedbackIngredient = null);
                      focusNode.requestFocus();
                    },
              icon: const Icon(Icons.close, size: 18),
            ),
    );
  }

  Widget _actions(BuildContext context, CulinaryEditorialPalette palette) {
    final spinner = SizedBox.square(
      dimension: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: palette.onPrimary,
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton.icon(
          key: const Key('shopping-cart-add-submit'),
          onPressed: _submitting ? null : () => _submit(keepOpen: false),
          icon: _submitting && !_keepOpenAfterSubmit
              ? spinner
              : const Icon(Icons.add),
          label: Text(S.of(context).shopping_add_to_list),
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            backgroundColor: palette.primary,
            foregroundColor: palette.onPrimary,
            disabledBackgroundColor: palette.surfaceContainerHigh,
            disabledForegroundColor: palette.onSurfaceVariant,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 10),
        FilledButton.tonalIcon(
          key: const Key('shopping-cart-add-another'),
          onPressed: _submitting ? null : () => _submit(keepOpen: true),
          icon: _submitting && _keepOpenAfterSubmit
              ? SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: palette.onSurfaceVariant,
                  ),
                )
              : const Icon(Icons.playlist_add),
          label: Text(S.of(context).shopping_add_another),
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            backgroundColor: palette.surfaceContainer,
            foregroundColor: palette.onSurface,
            disabledBackgroundColor: palette.surfaceContainerHigh,
            disabledForegroundColor: palette.onSurfaceVariant,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  void _submit({required bool keepOpen}) {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!_formKey.currentState!.validate()) return;
    final amountText = _amountController.text.trim();
    final ingredientName = _ingredientController.text.trim();
    setState(() {
      _submitting = true;
      _keepOpenAfterSubmit = keepOpen;
      _feedbackIngredient = null;
    });
    context.read<ShoppingCartBloc>().add(
      CleanAddIngredients([
        Ingredient(
          name: ingredientName,
          amount: amountText.isEmpty ? null : getDoubleFromString(amountText),
          unit: _unitController.text.trim(),
        ),
      ], _selectedRecipe ?? shoppingSummaryName),
    );
  }

  void _onCartState(BuildContext context, ShoppingCartState state) {
    if (!_submitting || state is! LoadedShoppingCart) return;
    if (state.actionError != null) {
      setState(() => _submitting = false);
      return;
    }
    if (!_keepOpenAfterSubmit) {
      Navigator.of(context).pop();
      return;
    }

    final addedIngredient = _ingredientController.text.trim();
    _ingredientController.clear();
    _amountController.clear();
    _unitController.clear();
    setState(() {
      _submitting = false;
      _feedbackIngredient = addedIngredient;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _ingredientFocus.requestFocus();
    });
  }

  void _unlinkRecipe() {
    _recipeController.clear();
    setState(() {
      _selectedRecipe = null;
      _feedbackIngredient = null;
    });
    _recipeFocus.requestFocus();
  }
}

class _DragHandle extends StatelessWidget {
  const _DragHandle({required this.palette});

  final CulinaryEditorialPalette palette;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 12, bottom: 4),
    child: Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: palette.outline.withValues(alpha: .35),
          borderRadius: BorderRadius.circular(99),
        ),
      ),
    ),
  );
}

class _Header extends StatelessWidget {
  const _Header({
    required this.palette,
    required this.enabled,
    required this.onClose,
  });

  final CulinaryEditorialPalette palette;
  final bool enabled;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 8, 12, 12),
    child: Row(
      children: [
        Expanded(
          child: Text(
            S.of(context).shopping_add_ingredient_title,
            style: CulinaryEditorialType.headline(
              palette,
              size: 24,
              weight: FontWeight.w600,
            ),
          ),
        ),
        IconButton.filledTonal(
          tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
          onPressed: enabled ? onClose : null,
          style: IconButton.styleFrom(
            minimumSize: const Size.square(48),
            backgroundColor: palette.surfaceContainer,
            foregroundColor: palette.onSurfaceVariant,
          ),
          icon: const Icon(Icons.close),
        ),
      ],
    ),
  );
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label, required this.palette});

  final String label;
  final CulinaryEditorialPalette palette;

  @override
  Widget build(BuildContext context) => Text(
    label.toUpperCase(),
    style: CulinaryEditorialType.body(
      palette,
      size: 12,
      weight: FontWeight.w700,
      color: palette.onSurfaceVariant,
      letterSpacing: .7,
    ),
  );
}

class _SuggestionMenu extends StatelessWidget {
  const _SuggestionMenu({
    required this.width,
    required this.options,
    required this.icon,
    required this.palette,
    required this.onSelected,
  });

  final double width;
  final Iterable<String> options;
  final IconData icon;
  final CulinaryEditorialPalette palette;
  final AutocompleteOnSelected<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final values = options.toList(growable: false);
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        color: palette.surface,
        elevation: 8,
        shadowColor: palette.shadow,
        borderRadius: BorderRadius.circular(14),
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: width, maxHeight: 240),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 6),
            shrinkWrap: true,
            itemCount: values.length,
            itemBuilder: (context, index) => ListTile(
              key: ValueKey('shopping-suggestion-${values[index]}'),
              minTileHeight: 48,
              leading: Icon(icon, color: palette.primary, size: 20),
              title: Text(
                values[index],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: CulinaryEditorialType.body(palette, size: 14),
              ),
              onTap: () => onSelected(values[index]),
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectedRecipe extends StatelessWidget {
  const _SelectedRecipe({
    required this.name,
    required this.palette,
    required this.enabled,
    required this.onUnlink,
  });

  final String name;
  final CulinaryEditorialPalette palette;
  final bool enabled;
  final VoidCallback onUnlink;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(12, 8, 6, 8),
    decoration: BoxDecoration(
      color: palette.primarySoft.withValues(alpha: .55),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Icon(Icons.bookmark_added_outlined, color: palette.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).shopping_linked_recipe,
                style: CulinaryEditorialType.body(
                  palette,
                  size: 11,
                  weight: FontWeight.w700,
                  color: palette.primary,
                  letterSpacing: .5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: CulinaryEditorialType.body(
                  palette,
                  size: 14,
                  weight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: enabled ? onUnlink : null,
          child: Text(S.of(context).shopping_unlink_recipe),
        ),
      ],
    ),
  );
}

class _SuccessMessage extends StatelessWidget {
  const _SuccessMessage({required this.message, required this.palette});

  final String message;
  final CulinaryEditorialPalette palette;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: palette.secondarySoft,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Icon(Icons.check_circle_outline, color: palette.secondary),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            message,
            style: CulinaryEditorialType.body(
              palette,
              size: 13,
              weight: FontWeight.w700,
              color: palette.secondary,
            ),
          ),
        ),
      ],
    ),
  );
}

Iterable<String> _rankSuggestions(List<String> values, String rawQuery) {
  final query = rawQuery.trim().toLowerCase();
  if (query.isEmpty) return const Iterable<String>.empty();

  final seen = <String>{};
  final prefixes = <String>[];
  final contains = <String>[];
  for (final value in values) {
    final normalized = value.trim().toLowerCase();
    if (normalized.isEmpty || !seen.add(normalized)) continue;
    if (normalized.startsWith(query)) {
      prefixes.add(value);
    } else if (normalized.contains(query)) {
      contains.add(value);
    }
  }
  return [...prefixes, ...contains].take(8);
}
