import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/ingredinets_manager/ingredients_manager_bloc.dart';
import '../generated/l10n.dart';
import '../models/recipe.dart';
import '../widgets/culinary_editorial_theme.dart';
import '../widgets/editorial_catalog_manager.dart';

class IngredientsManager extends StatelessWidget {
  const IngredientsManager({super.key, this.editRecipeName, this.newRecipe});

  final String? editRecipeName;
  final Recipe? newRecipe;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IngredientsManagerBloc, IngredientsManagerState>(
      builder: (context, state) {
        if (state is LoadingIngredientsManager ||
            state is IngredientsManagerInitial) {
          return EditorialCatalogManagerShell(
            title: S.of(context).manage_ingredients,
            description: S.of(context).ingredient_manager_description,
            itemCount: 0,
            addLabel: S.of(context).add,
            emptyTitle: S.of(context).you_have_no_ingredients,
            emptyDescription: S.of(context).ingredient_manager_description,
            emptyIcon: Icons.local_grocery_store_outlined,
            onAdd: () {},
            contentSlivers: const [],
            loading: true,
          );
        }

        if (state is! LoadedIngredientsManager) {
          return const SizedBox.shrink();
        }

        return EditorialCatalogManagerShell(
          title: S.of(context).manage_ingredients,
          description: S.of(context).ingredient_manager_description,
          itemCount: state.ingredients.length,
          addLabel: S.of(context).add,
          emptyTitle: S.of(context).you_have_no_ingredients,
          emptyDescription: S.of(context).ingredient_manager_description,
          emptyIcon: Icons.local_grocery_store_outlined,
          onAdd: () => _showEditor(context, state.ingredients),
          contentSlivers: [
            SliverList.builder(
              itemCount: state.ingredients.length,
              itemBuilder: (context, index) {
                final ingredientName = state.ingredients[index];
                return EditorialCatalogContentFrame(
                  child: EditorialCatalogRowSurface(
                    key: ValueKey('ingredient-row-$ingredientName'),
                    leading: EditorialCatalogOrderBadge(
                      position: index + 1,
                      semanticLabel: ingredientName,
                    ),
                    title: ingredientName,
                    subtitle: S.of(context).ingredient,
                    onTap: () => _showEditor(
                      context,
                      state.ingredients,
                      currentName: ingredientName,
                    ),
                    trailing: EditorialCatalogMenuButton(
                      tooltip: ingredientName,
                      editLabel: S.of(context).edit,
                      deleteLabel: S.of(context).delete,
                      onEdit: () => _showEditor(
                        context,
                        state.ingredients,
                        currentName: ingredientName,
                      ),
                      onDelete: () =>
                          _showDeleteDialog(context, ingredientName),
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
    List<String> ingredients, {
    String? currentName,
  }) {
    showCatalogNameEditorSheet(
      context: context,
      title: currentName == null ? S.of(context).add : S.of(context).edit,
      fieldLabel: S.of(context).ingredient,
      saveLabel: S.of(context).save,
      cancelLabel: S.of(context).cancel,
      emptyError: S.of(context).field_must_not_be_empty,
      duplicateError: S.of(context).ingredient_already_exists,
      existingNames: ingredients,
      initialName: currentName,
      onSave: (name) {
        final manager = context.read<IngredientsManagerBloc>();
        if (currentName == null) {
          manager.add(AddIngredient(name));
        } else if (name != currentName) {
          manager.add(UpdateIngredient(currentName, name));
        }
      },
    );
  }

  Future<void> _showDeleteDialog(
    BuildContext context,
    String ingredientName,
  ) async {
    final palette = CulinaryEditorialPalette.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: Icon(Icons.delete_outline_rounded, color: palette.primary),
        title: Text(S.of(context).delete_ingredient),
        content: Text(ingredientName),
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
      context.read<IngredientsManagerBloc>().add(
        DeleteIngredient(ingredientName),
      );
    }
  }
}
