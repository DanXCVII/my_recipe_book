import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/nutrition_manager/nutrition_manager_bloc.dart';
import '../generated/l10n.dart';
import '../models/recipe.dart';
import '../widgets/culinary_editorial_theme.dart';
import '../widgets/editorial_catalog_manager.dart';

class NutritionManager extends StatelessWidget {
  const NutritionManager({super.key, this.newRecipe});

  final Recipe? newRecipe;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NutritionManagerBloc, NutritionManagerState>(
      builder: (context, state) {
        if (state is! LoadedNutritionManager) {
          return EditorialCatalogManagerShell(
            title: S.of(context).manage_nutritions,
            description: S.of(context).catalog_nutritions_description,
            itemCount: 0,
            addLabel: S.of(context).catalog_add_nutrition,
            emptyTitle: S.of(context).catalog_nutritions_empty_title,
            emptyDescription: S
                .of(context)
                .catalog_nutritions_empty_description,
            emptyIcon: Icons.fact_check_outlined,
            onAdd: () {},
            contentSlivers: const [],
            loading: true,
          );
        }

        final nutritions = state.nutritions;
        return EditorialCatalogManagerShell(
          title: S.of(context).manage_nutritions,
          description: S.of(context).catalog_nutritions_description,
          itemCount: nutritions.length,
          addLabel: S.of(context).catalog_add_nutrition,
          emptyTitle: S.of(context).catalog_nutritions_empty_title,
          emptyDescription: S.of(context).catalog_nutritions_empty_description,
          emptyIcon: Icons.fact_check_outlined,
          onAdd: () => _showEditor(context, nutritions),
          contentSlivers: [
            SliverReorderableList(
              itemCount: nutritions.length,
              onReorderItem: (oldIndex, destination) {
                if (destination == oldIndex) return;
                context.read<NutritionManagerBloc>().add(
                  MoveNutrition(oldIndex, destination),
                );
              },
              itemBuilder: (context, index) {
                final nutritionName = nutritions[index];
                return EditorialCatalogContentFrame(
                  key: ValueKey('nutrition-row-$nutritionName'),
                  child: EditorialCatalogRowSurface(
                    leading: EditorialCatalogOrderBadge(
                      position: index + 1,
                      semanticLabel: S
                          .of(context)
                          .catalog_nutrition_order(index + 1),
                    ),
                    title: nutritionName,
                    onTap: () => _showEditor(
                      context,
                      nutritions,
                      currentName: nutritionName,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ReorderableDragStartListener(
                          index: index,
                          child: Tooltip(
                            message: S
                                .of(context)
                                .catalog_reorder_nutrition(nutritionName),
                            excludeFromSemantics: true,
                            child: const SizedBox.square(
                              dimension: 48,
                              child: Icon(Icons.drag_handle_rounded),
                            ),
                          ),
                        ),
                        EditorialCatalogMenuButton(
                          tooltip: S
                              .of(context)
                              .catalog_more_actions(nutritionName),
                          editLabel: S.of(context).edit,
                          deleteLabel: S.of(context).delete,
                          onEdit: () => _showEditor(
                            context,
                            nutritions,
                            currentName: nutritionName,
                          ),
                          onDelete: () =>
                              _showDeleteDialog(context, nutritionName),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditor(
    BuildContext context,
    List<String> nutritions, {
    String? currentName,
  }) {
    showCatalogNameEditorSheet(
      context: context,
      title: currentName == null
          ? S.of(context).catalog_add_nutrition
          : S.of(context).catalog_edit_nutrition,
      fieldLabel: S.of(context).nutrition,
      saveLabel: S.of(context).save,
      cancelLabel: S.of(context).cancel,
      emptyError: S.of(context).field_must_not_be_empty,
      duplicateError: S.of(context).nutrition_already_exists,
      existingNames: nutritions,
      initialName: currentName,
      onSave: (name) {
        final manager = context.read<NutritionManagerBloc>();
        if (currentName == null) {
          manager.add(AddNutrition(name));
        } else if (name != currentName) {
          manager.add(UpdateNutrition(currentName, name));
        }
      },
    );
  }

  Future<void> _showDeleteDialog(
    BuildContext context,
    String nutritionName,
  ) async {
    final palette = CulinaryEditorialPalette.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: Icon(Icons.delete_outline_rounded, color: palette.primary),
        title: Text(
          S.of(context).catalog_delete_nutrition_title(nutritionName),
        ),
        content: Text(S.of(context).catalog_delete_nutrition_description),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(S.of(context).cancel),
          ),
          FilledButton(
            key: const ValueKey('catalog-confirm-delete'),
            onPressed: () => Navigator.pop(dialogContext, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: Text(S.of(context).delete),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context.read<NutritionManagerBloc>().add(DeleteNutrition(nutritionName));
    }
  }
}
