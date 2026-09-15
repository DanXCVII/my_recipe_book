import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reorderables/reorderables.dart';

import '../blocs/new_recipe/ingredients_section/ingredients_section_bloc.dart';
import '../generated/l10n.dart';
import '../models/ingredient.dart';
import '../util/helper.dart';
import 'culinary_editorial_theme.dart';
import 'dialogs/are_you_sure_dialog.dart';
import 'recipe_editor/editorial_editor_shell.dart';

class Ingredients extends StatefulWidget {
  const Ingredients(
    this.servingsController,
    this.servingsNameController,
    this.ingredientNames, {
    super.key,
    this.showServings = true,
  });

  final List<String> ingredientNames;
  final TextEditingController servingsController;
  final TextEditingController servingsNameController;
  final bool showServings;

  @override
  State<Ingredients> createState() => _IngredientsState();
}

class _IngredientsState extends State<Ingredients> {
  bool _initializedServingName = false;

  @override
  Widget build(BuildContext context) {
    if (!_initializedServingName &&
        widget.servingsNameController.text.isEmpty) {
      widget.servingsNameController.text = S.of(context).servings;
      _initializedServingName = true;
    }

    return BlocBuilder<IngredientsSectionBloc, IngredientsSectionState>(
      builder: (context, state) {
        if (state is! LoadedIngredientsSection) {
          return const Center(child: CircularProgressIndicator());
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.showServings) ...[
              EditorialCard(child: _servingsFields(context)),
              const SizedBox(height: 14),
            ],
            for (var index = 0; index < state.ingredients.length; index++) ...[
              _IngredientSectionCard(
                sectionIndex: index,
                title: index < state.sectionTitles.length
                    ? state.sectionTitles[index]
                    : '',
                ingredients: state.ingredients[index],
                ingredientNames: widget.ingredientNames,
                canDelete:
                    state.ingredients.length > 1 ||
                    state.sectionTitles.isNotEmpty,
              ),
              const SizedBox(height: 14),
            ],
            OutlinedButton.icon(
              onPressed: () => _showAddSectionSheet(context),
              icon: const Icon(Icons.add),
              label: Text(S.of(context).add_section('')),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            ),
          ],
        );
      },
    );
  }

  Widget _servingsFields(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: TextFormField(
          controller: widget.servingsController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: (value) =>
              value != null &&
                  value.isNotEmpty &&
                  getDoubleFromString(value) == null
              ? S.of(context).no_valid_number
              : null,
          decoration: editorialInputDecoration(
            context,
            label: S.of(context).amount,
          ),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: TextFormField(
          controller: widget.servingsNameController,
          validator: (value) => value == null || value.trim().isEmpty
              ? S.of(context).field_must_not_be_empty
              : null,
          decoration: editorialInputDecoration(
            context,
            label: S.of(context).servings,
          ),
        ),
      ),
    ],
  );

  Future<void> _showAddSectionSheet(BuildContext context) async {
    final bloc = context.read<IngredientsSectionBloc>();
    final title = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) => _SectionTitleSheet(
        initialTitle: '',
        title: S.of(context).add_section(''),
      ),
    );
    if (title != null && title.trim().isNotEmpty && mounted) {
      bloc.add(AddSectionTitle(title.trim()));
    }
  }
}

class _IngredientSectionCard extends StatelessWidget {
  const _IngredientSectionCard({
    required this.sectionIndex,
    required this.title,
    required this.ingredients,
    required this.ingredientNames,
    required this.canDelete,
  });

  final int sectionIndex;
  final String title;
  final List<Ingredient> ingredients;
  final List<String> ingredientNames;
  final bool canDelete;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final heading = title.trim().isEmpty
        ? S.of(context).editor_ingredients
        : title;
    return EditorialCard(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => _renameSection(context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            heading,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: CulinaryEditorialType.headline(
                              palette,
                              size: 20,
                              weight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          Icons.edit_outlined,
                          size: 18,
                          color: palette.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (canDelete)
                IconButton(
                  tooltip: S.of(context).delete_section,
                  constraints: const BoxConstraints.tightFor(
                    width: 48,
                    height: 48,
                  ),
                  onPressed: () => _removeSection(context),
                  icon: const Icon(Icons.delete_outline),
                ),
            ],
          ),
          Divider(color: palette.outline.withValues(alpha: .22)),
          if (ingredients.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                S.of(context).ingredient_section_empty,
                textAlign: TextAlign.center,
                style: CulinaryEditorialType.body(
                  palette,
                  color: palette.onSurfaceVariant,
                ),
              ),
            )
          else
            ReorderableColumn(
              needsLongPressDraggable: false,
              onReorder: (oldIndex, newIndex) => context
                  .read<IngredientsSectionBloc>()
                  .add(MoveIngredient(sectionIndex, oldIndex, newIndex)),
              children: [
                for (var index = 0; index < ingredients.length; index++)
                  _IngredientRow(
                    key: ValueKey(
                      ingredients[index].id ?? '$sectionIndex-$index',
                    ),
                    sectionIndex: sectionIndex,
                    ingredientIndex: index,
                    ingredient: ingredients[index],
                  ),
              ],
            ),
          const SizedBox(height: 8),
          FilledButton.tonalIcon(
            onPressed: () => _showAddIngredientSheet(context),
            icon: const Icon(Icons.add),
            label: Text(S.of(context).add_ingredient('')),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              backgroundColor: palette.primarySoft,
              foregroundColor: palette.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _renameSection(BuildContext context) async {
    final bloc = context.read<IngredientsSectionBloc>();
    final newTitle = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _SectionTitleSheet(
        initialTitle: title,
        title: S.of(context).add_title,
      ),
    );
    if (!context.mounted || newTitle == null) return;
    final normalized = newTitle.trim();
    final state = bloc.state as LoadedIngredientsSection;
    if (state.sectionTitles.isEmpty) {
      if (normalized.isNotEmpty) bloc.add(AddSectionTitle(normalized));
    } else {
      bloc.add(EditSectionTitle(normalized, sectionIndex));
    }
  }

  Future<void> _removeSection(BuildContext context) async {
    final bloc = context.read<IngredientsSectionBloc>();
    if (ingredients.isEmpty) {
      bloc.add(RemoveSection(sectionIndex));
      return;
    }
    await showDialog<void>(
      context: context,
      builder: (_) => AreYouSureDialog(
        S.of(context).delete_section,
        S.of(context).delete_section_desc,
        () {
          bloc.add(RemoveSection(sectionIndex));
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Future<void> _showAddIngredientSheet(BuildContext context) async {
    final bloc = context.read<IngredientsSectionBloc>();
    final ingredient = await showModalBottomSheet<Ingredient>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _IngredientSheet(ingredientNames: ingredientNames),
    );
    if (ingredient != null && context.mounted) {
      bloc.add(AddIngredient(ingredient, sectionIndex));
    }
  }
}

class _IngredientRow extends StatelessWidget {
  const _IngredientRow({
    super.key,
    required this.sectionIndex,
    required this.ingredientIndex,
    required this.ingredient,
  });

  final int sectionIndex;
  final int ingredientIndex;
  final Ingredient ingredient;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: LayoutBuilder(
        builder: (context, constraints) => constraints.maxWidth < 420
            ? Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _dragHandle(palette),
                      Expanded(child: _nameField(context)),
                      _deleteButton(context),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40, right: 48, top: 8),
                    child: Row(
                      children: [
                        Expanded(child: _amountField(context)),
                        const SizedBox(width: 8),
                        Expanded(child: _unitField(context)),
                      ],
                    ),
                  ),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _dragHandle(palette),
                  Expanded(flex: 2, child: _amountField(context)),
                  const SizedBox(width: 8),
                  Expanded(flex: 2, child: _unitField(context)),
                  const SizedBox(width: 8),
                  Expanded(flex: 4, child: _nameField(context)),
                  _deleteButton(context),
                ],
              ),
      ),
    );
  }

  Widget _dragHandle(CulinaryEditorialPalette palette) => SizedBox(
    width: 40,
    height: 52,
    child: Icon(Icons.drag_indicator, color: palette.onSurfaceVariant),
  );

  Widget _amountField(BuildContext context) => TextFormField(
    key: ValueKey('${ingredient.id}-amount'),
    initialValue: ingredient.amount == null
        ? ''
        : cutDouble(ingredient.amount!),
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    decoration: editorialInputDecoration(context, label: S.of(context).amount),
    onChanged: (value) => _edit(context, amountText: value),
  );

  Widget _unitField(BuildContext context) => TextFormField(
    key: ValueKey('${ingredient.id}-unit'),
    initialValue: ingredient.unit ?? '',
    decoration: editorialInputDecoration(context, label: S.of(context).unit),
    onChanged: (value) => _edit(context, unit: value),
  );

  Widget _nameField(BuildContext context) => TextFormField(
    key: ValueKey('${ingredient.id}-name'),
    initialValue: ingredient.name,
    validator: (value) => value == null || value.trim().isEmpty
        ? S.of(context).field_must_not_be_empty
        : null,
    decoration: editorialInputDecoration(context, label: S.of(context).name),
    onChanged: (value) => _edit(context, name: value),
  );

  Widget _deleteButton(BuildContext context) => IconButton(
    tooltip: MaterialLocalizations.of(context).deleteButtonTooltip,
    constraints: const BoxConstraints.tightFor(width: 48, height: 52),
    onPressed: () => context.read<IngredientsSectionBloc>().add(
      RemoveIngredient(sectionIndex, ingredientIndex),
    ),
    icon: const Icon(Icons.close),
  );

  void _edit(
    BuildContext context, {
    String? amountText,
    String? unit,
    String? name,
  }) {
    final clearAmount = amountText != null && amountText.trim().isEmpty;
    final updated = ingredient.copyWith(
      name: name,
      amount: amountText == null || clearAmount
          ? null
          : getDoubleFromString(amountText),
      unit: unit,
      clearAmount: clearAmount,
    );
    context.read<IngredientsSectionBloc>().add(
      EditIngredient(updated, sectionIndex, ingredientIndex, sectionIndex),
    );
  }
}

class _IngredientSheet extends StatefulWidget {
  const _IngredientSheet({required this.ingredientNames});

  final List<String> ingredientNames;

  @override
  State<_IngredientSheet> createState() => _IngredientSheetState();
}

class _IngredientSheetState extends State<_IngredientSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amount = TextEditingController();
  final _unit = TextEditingController();
  final _name = TextEditingController();

  @override
  void dispose() {
    _amount.dispose();
    _unit.dispose();
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        18,
        20,
        MediaQuery.viewInsetsOf(context).bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              S.of(context).add_ingredient(''),
              style: CulinaryEditorialType.headline(
                palette,
                size: 24,
                weight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _amount,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (value) =>
                        value != null &&
                            value.isNotEmpty &&
                            getDoubleFromString(value) == null
                        ? S.of(context).no_valid_number
                        : null,
                    decoration: editorialInputDecoration(
                      context,
                      label: S.of(context).amount,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: _unit,
                    decoration: editorialInputDecoration(
                      context,
                      label: S.of(context).unit,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Autocomplete<String>(
              optionsBuilder: (value) {
                final query = value.text.trim().toLowerCase();
                if (query.isEmpty) return const Iterable<String>.empty();
                return widget.ingredientNames
                    .where((name) => name.toLowerCase().contains(query))
                    .take(8);
              },
              onSelected: (value) => _name.text = value,
              fieldViewBuilder: (_, controller, focusNode, onSubmitted) {
                controller.addListener(() => _name.text = controller.text);
                return TextFormField(
                  controller: controller,
                  focusNode: focusNode,
                  autofocus: true,
                  textInputAction: TextInputAction.done,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? S.of(context).field_must_not_be_empty
                      : null,
                  onFieldSubmitted: (_) => _save(),
                  decoration: editorialInputDecoration(
                    context,
                    label: S.of(context).name,
                  ),
                );
              },
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: _save,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                backgroundColor: palette.primary,
                foregroundColor: palette.onPrimary,
              ),
              child: Text(S.of(context).done),
            ),
          ],
        ),
      ),
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final amountText = _amount.text.trim();
    Navigator.of(context).pop(
      Ingredient(
        name: _name.text.trim(),
        amount: amountText.isEmpty ? null : getDoubleFromString(amountText),
        unit: _unit.text.trim(),
      ),
    );
  }
}

class _SectionTitleSheet extends StatefulWidget {
  const _SectionTitleSheet({required this.initialTitle, required this.title});

  final String initialTitle;
  final String title;

  @override
  State<_SectionTitleSheet> createState() => _SectionTitleSheetState();
}

class _SectionTitleSheetState extends State<_SectionTitleSheet> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialTitle);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        18,
        20,
        MediaQuery.viewInsetsOf(context).bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.title,
            style: CulinaryEditorialType.headline(
              palette,
              size: 24,
              weight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            autofocus: true,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
            decoration: editorialInputDecoration(
              context,
              label: S.of(context).name,
            ),
          ),
          const SizedBox(height: 18),
          FilledButton(
            onPressed: _submit,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              backgroundColor: palette.primary,
              foregroundColor: palette.onPrimary,
            ),
            child: Text(S.of(context).done),
          ),
        ],
      ),
    );
  }

  void _submit() => Navigator.of(context).pop(_controller.text);
}
