import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/category_manager/category_manager_bloc.dart';
import '../blocs/recipe_manager/recipe_manager_bloc.dart';
import '../generated/l10n.dart';
import '../local_storage/local_repository.dart';
import '../widgets/culinary_editorial_theme.dart';
import '../widgets/editorial_catalog_manager.dart';

class CategoryManagerArguments {
  final CategoryManagerBloc? categoryManagerBloc;

  CategoryManagerArguments({this.categoryManagerBloc});
}

class CategoryManager extends StatelessWidget {
  const CategoryManager();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryManagerBloc, CategoryManagerState>(
      builder: (context, state) {
        if (state is LoadingCategoryManager) {
          return EditorialCatalogManagerShell(
            title: S.of(context).manage_categories,
            description: S.of(context).catalog_categories_description,
            itemCount: 0,
            headerIcon: Icons.folder_special_outlined,
            addLabel: S.of(context).catalog_add_category,
            emptyTitle: S.of(context).catalog_categories_empty_title,
            emptyDescription: S
                .of(context)
                .catalog_categories_empty_description,
            emptyIcon: Icons.folder_copy_outlined,
            onAdd: () {},
            contentSlivers: const [],
            loading: true,
          );
        }

        if (state is! LoadedCategoryManager) {
          return const SizedBox.shrink();
        }

        final categories = state.categories
            .where((category) => category != noCategoryName)
            .toList(growable: false);
        return EditorialCatalogManagerShell(
          title: S.of(context).manage_categories,
          description: S.of(context).catalog_categories_description,
          itemCount: categories.length,
          headerIcon: Icons.folder_special_outlined,
          addLabel: S.of(context).catalog_add_category,
          emptyTitle: S.of(context).catalog_categories_empty_title,
          emptyDescription: S.of(context).catalog_categories_empty_description,
          emptyIcon: Icons.folder_copy_outlined,
          onAdd: () => _showEditor(context, state.categories),
          contentSlivers: [
            SliverReorderableList(
              itemCount: categories.length,
              onReorderItem: (oldIndex, destination) {
                if (destination == oldIndex) return;
                context.read<CategoryManagerBloc>().recipeManagerBloc.add(
                  RMMoveCategory(oldIndex, destination, DateTime.now()),
                );
              },
              itemBuilder: (context, index) {
                final categoryName = categories[index];
                return EditorialCatalogContentFrame(
                  key: ValueKey('category-row-$categoryName'),
                  child: EditorialCatalogRowSurface(
                    leading: _CategoryOrderBadge(index: index),
                    title: categoryName,
                    subtitle: S.of(context).catalog_category_order(index + 1),
                    onTap: () => _showEditor(
                      context,
                      state.categories,
                      currentName: categoryName,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ReorderableDragStartListener(
                          index: index,
                          child: Tooltip(
                            message: S
                                .of(context)
                                .catalog_reorder_category(categoryName),
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
                              .catalog_more_actions(categoryName),
                          editLabel: S.of(context).edit,
                          deleteLabel: S.of(context).delete,
                          onEdit: () => _showEditor(
                            context,
                            state.categories,
                            currentName: categoryName,
                          ),
                          onDelete: () =>
                              _showDeleteDialog(context, categoryName),
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
    List<String> categories, {
    String? currentName,
  }) {
    showCategoryEditorSheet(
      context: context,
      title: currentName == null
          ? S.of(context).catalog_add_category
          : S.of(context).catalog_edit_category,
      fieldLabel: S.of(context).categoryname,
      saveLabel: S.of(context).save,
      cancelLabel: S.of(context).cancel,
      emptyError: S.of(context).field_must_not_be_empty,
      duplicateError: S.of(context).category_already_exists,
      existingNames: categories,
      initialName: currentName,
      onSave: (name) {
        final manager = context.read<CategoryManagerBloc>().recipeManagerBloc;
        manager.add(
          currentName == null
              ? RMAddCategories([name])
              : RMUpdateCategory(currentName, name),
        );
      },
    );
  }

  Future<void> _showDeleteDialog(
    BuildContext context,
    String categoryName,
  ) async {
    final palette = CulinaryEditorialPalette.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: Icon(Icons.delete_outline_rounded, color: palette.primary),
        title: Text(S.of(context).catalog_delete_category_title(categoryName)),
        content: Text(S.of(context).catalog_delete_category_description),
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
      context.read<RecipeManagerBloc>().add(RMDeleteCategory(categoryName));
    }
  }
}

class _CategoryOrderBadge extends StatelessWidget {
  const _CategoryOrderBadge({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Container(
      width: 48,
      height: 52,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: palette.primarySoft,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '${index + 1}'.padLeft(2, '0'),
        style: CulinaryEditorialType.headline(
          palette,
          size: 18,
          weight: FontWeight.w600,
        ).copyWith(color: palette.primary),
      ),
    );
  }
}
