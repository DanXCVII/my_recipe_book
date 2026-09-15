import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reorderables/reorderables.dart';

import '../../../blocs/new_recipe/step_images/step_images_bloc.dart';
import '../../../constants/global_constants.dart' as constants;
import '../../../generated/l10n.dart';
import '../../../models/ingredient.dart';
import '../../../util/helper.dart';
import '../../../widgets/culinary_editorial_theme.dart';
import '../../../widgets/dialogs/are_you_sure_dialog.dart';
import '../../../widgets/recipe_editor/editorial_editor_shell.dart';

class Steps extends StatelessWidget {
  const Steps({
    super.key,
    this.editRecipeName = constants.newRecipeLocalPathString,
    this.ingredients = const [],
    this.ingredientGlossary = const [],
  });

  final String? editRecipeName;
  final List<List<Ingredient>> ingredients;
  final List<String> ingredientGlossary;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StepImagesBloc, StepImagesState>(
      builder: (context, state) {
        if (state is! LoadedStepImages) {
          return const Center(child: CircularProgressIndicator());
        }
        final editingRecipe =
            editRecipeName != constants.newRecipeLocalPathString;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (state.steps.isEmpty)
              EditorialCard(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    S.of(context).instructions_empty,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: CulinaryEditorialPalette.of(context)
                          .onSurfaceVariant,
                    ),
                  ),
                ),
              )
            else
              ReorderableColumn(
                needsLongPressDraggable: false,
                onReorder: (oldIndex, newIndex) => context
                    .read<StepImagesBloc>()
                    .add(MoveStep(oldIndex, newIndex)),
                children: [
                  for (var index = 0; index < state.steps.length; index++)
                    Padding(
                      key: state.stepKeys[index],
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _StepCard(
                        stepIndex: index,
                        stepTitle: state.stepTitles[index],
                        step: state.steps[index],
                        stepImages: index < state.stepImages.length
                            ? state.stepImages[index]
                            : const [],
                        ingredients: ingredients,
                        ingredientGlossary: ingredientGlossary,
                        assignedIngredientIds: state.stepIngredientIds[index],
                        onEditTitle: (value) => context
                            .read<StepImagesBloc>()
                            .add(EditStepTitle(value, index)),
                        onEditStep: (value) => context
                            .read<StepImagesBloc>()
                            .add(EditStep(value, index)),
                        onRemoveStep: () => _removeStep(context, index),
                        onAddImage: (file) => context
                            .read<StepImagesBloc>()
                            .add(AddImage(file, index, editingRecipe)),
                        onRemoveImage: (imageIndex) => context
                            .read<StepImagesBloc>()
                            .add(RemoveImage(index, imageIndex, editingRecipe)),
                        onAssignmentsChanged: (ids) => context
                            .read<StepImagesBloc>()
                            .add(UpdateStepIngredients(index, ids)),
                      ),
                    ),
                ],
              ),
            OutlinedButton.icon(
              onPressed: () => context.read<StepImagesBloc>().add(
                AddStep('', DateTime.now()),
              ),
              icon: const Icon(Icons.add),
              label: Text(S.of(context).add_step('')),
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

  Future<void> _removeStep(BuildContext context, int index) async {
    final bloc = context.read<StepImagesBloc>();
    await showDialog<void>(
      context: context,
      builder: (_) => AreYouSureDialog(
        '${S.of(context).remove_step('')}?',
        S.of(context).remove_step_desc,
        () {
          bloc.add(
            RemoveStep(
              editRecipeName ?? constants.newRecipeLocalPathString,
              DateTime.now(),
              stepNumber: index,
            ),
          );
          Navigator.of(context).pop();
        },
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({
    required this.stepIndex,
    required this.stepTitle,
    required this.step,
    required this.stepImages,
    required this.ingredients,
    required this.ingredientGlossary,
    required this.assignedIngredientIds,
    required this.onEditTitle,
    required this.onEditStep,
    required this.onRemoveStep,
    required this.onAddImage,
    required this.onRemoveImage,
    required this.onAssignmentsChanged,
  });

  final int stepIndex;
  final String stepTitle;
  final String step;
  final List<String> stepImages;
  final List<List<Ingredient>> ingredients;
  final List<String> ingredientGlossary;
  final List<String> assignedIngredientIds;
  final ValueChanged<String> onEditTitle;
  final ValueChanged<String> onEditStep;
  final VoidCallback onRemoveStep;
  final ValueChanged<File> onAddImage;
  final ValueChanged<int> onRemoveImage;
  final ValueChanged<List<String>> onAssignmentsChanged;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return EditorialCard(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 48,
                height: 48,
                child: Center(
                  child: Text(
                    '${stepIndex + 1}'.padLeft(2, '0'),
                    style: CulinaryEditorialType.headline(
                      palette,
                      size: 25,
                      weight: FontWeight.w600,
                    ).copyWith(color: palette.primary),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  key: ValueKey('step-$stepIndex-title'),
                  initialValue: stepTitle,
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: onEditTitle,
                  decoration: editorialInputDecoration(
                    context,
                    label: S.of(context).step_title,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              SizedBox(
                width: 48,
                height: 48,
                child: Icon(
                  Icons.drag_indicator,
                  color: palette.onSurfaceVariant,
                ),
              ),
              IconButton(
                tooltip: MaterialLocalizations.of(context).deleteButtonTooltip,
                constraints: const BoxConstraints.tightFor(
                  width: 48,
                  height: 48,
                ),
                onPressed: onRemoveStep,
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextFormField(
            key: ValueKey('step-$stepIndex-description'),
            initialValue: step,
            textCapitalization: TextCapitalization.sentences,
            keyboardType: TextInputType.multiline,
            minLines: 3,
            maxLines: 10,
            onChanged: onEditStep,
            decoration: editorialInputDecoration(
              context,
              label: S.of(context).description,
              hint: S.of(context).step_description_hint,
            ),
          ),
          const SizedBox(height: 14),
          _IngredientAssignments(
            ingredients: ingredients,
            ingredientGlossary: ingredientGlossary,
            assignedIngredientIds: assignedIngredientIds,
            onChanged: onAssignmentsChanged,
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var index = 0; index < stepImages.length; index++)
                ImageBox(
                  size: 72,
                  onPress: () => onRemoveImage(index),
                  imagePath: stepImages[index],
                ),
              AddImageBox(size: 72, iconSize: 21, onNewImage: onAddImage),
            ],
          ),
        ],
      ),
    );
  }
}

class _IngredientAssignments extends StatelessWidget {
  const _IngredientAssignments({
    required this.ingredients,
    required this.ingredientGlossary,
    required this.assignedIngredientIds,
    required this.onChanged,
  });

  final List<List<Ingredient>> ingredients;
  final List<String> ingredientGlossary;
  final List<String> assignedIngredientIds;
  final ValueChanged<List<String>> onChanged;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final byId = <String, Ingredient>{
      for (final section in ingredients)
        for (final ingredient in section)
          if (ingredient.id != null) ingredient.id!: ingredient,
    };
    final assigned = assignedIngredientIds
        .where(byId.containsKey)
        .map((id) => byId[id]!)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).ingredients_for_step,
          style: CulinaryEditorialType.body(
            palette,
            size: 12,
            weight: FontWeight.w700,
            color: palette.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final ingredient in assigned)
              InputChip(
                avatar: const Icon(Icons.restaurant_outlined, size: 16),
                label: Text(_ingredientLabel(ingredient)),
                onDeleted: () => onChanged(
                  assignedIngredientIds
                      .where((id) => id != ingredient.id)
                      .toList(),
                ),
              ),
            ActionChip(
              avatar: const Icon(Icons.add, size: 18),
              label: Text(S.of(context).assign_ingredients),
              onPressed: () => _showAssignmentSheet(context),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _showAssignmentSheet(BuildContext context) async {
    final selected = assignedIngredientIds.toSet();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setSheetState) => DraggableScrollableSheet(
          initialChildSize: .68,
          minChildSize: .35,
          maxChildSize: .92,
          expand: false,
          builder: (context, scrollController) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 4, 24, 16),
                child: Text(
                  S.of(context).assign_ingredients,
                  style: CulinaryEditorialType.headline(
                    CulinaryEditorialPalette.of(context),
                    size: 24,
                    weight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: ingredients.length,
                  itemBuilder: (context, sectionIndex) {
                    final section = ingredients[sectionIndex];
                    final heading =
                        sectionIndex < ingredientGlossary.length &&
                            ingredientGlossary[sectionIndex].trim().isNotEmpty
                        ? ingredientGlossary[sectionIndex]
                        : S.of(context).ingredients;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 18, 24, 6),
                          child: Text(
                            heading,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                        for (final ingredient in section)
                          if (ingredient.id != null)
                            CheckboxListTile(
                              value: selected.contains(ingredient.id),
                              title: Text(_ingredientLabel(ingredient)),
                              controlAffinity: ListTileControlAffinity.leading,
                              onChanged: (checked) {
                                setSheetState(() {
                                  if (checked ?? false) {
                                    selected.add(ingredient.id!);
                                  } else {
                                    selected.remove(ingredient.id);
                                  }
                                });
                              },
                            ),
                      ],
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                child: FilledButton(
                  onPressed: () {
                    final ordered = <String>[
                      for (final section in ingredients)
                        for (final ingredient in section)
                          if (ingredient.id != null &&
                              selected.contains(ingredient.id))
                            ingredient.id!,
                    ];
                    onChanged(ordered);
                    Navigator.pop(sheetContext);
                  },
                  child: Text(S.of(context).done),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _ingredientLabel(Ingredient ingredient) {
  final amount = ingredient.amount == null ? '' : cutDouble(ingredient.amount!);
  return [amount, ingredient.unit, ingredient.name]
      .where((part) => part != null && part.toString().trim().isNotEmpty)
      .join(' ');
}

class ImageBox extends StatelessWidget {
  const ImageBox({
    super.key,
    required this.onPress,
    required this.imagePath,
    this.size = 80,
  });

  final VoidCallback onPress;
  final String imagePath;
  final double size;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox.square(
        dimension: size,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.file(
              File(imagePath),
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => ColoredBox(
                color: palette.surfaceContainer,
                child: Icon(
                  Icons.broken_image_outlined,
                  color: palette.outline,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: IconButton.filledTonal(
                constraints: const BoxConstraints.tightFor(
                  width: 48,
                  height: 48,
                ),
                onPressed: onPress,
                icon: const Icon(Icons.close, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddImageBox extends StatelessWidget {
  const AddImageBox({
    super.key,
    this.size = 80,
    this.iconSize,
    required this.onNewImage,
  });

  final ValueChanged<File> onNewImage;
  final double size;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return SizedBox.square(
      dimension: size,
      child: OutlinedButton(
        onPressed: () => _pickImage(context),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          side: BorderSide(color: palette.outline.withValues(alpha: .55)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Icon(Icons.add_a_photo_outlined, size: iconSize),
      ),
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null && context.mounted) onNewImage(File(picked.path));
  }
}
