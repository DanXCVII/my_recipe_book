import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/recipe_manager/recipe_manager_bloc.dart';
import '../blocs/recipe_tag_manager/recipe_tag_manager_bloc.dart';
import '../generated/l10n.dart';
import '../models/string_int_tuple.dart';
import '../widgets/culinary_editorial_theme.dart';
import '../widgets/editorial_catalog_manager.dart';

class RecipeTagManagerArguments {
  final RecipeTagManagerBloc? recipeTagManagerBloc;

  RecipeTagManagerArguments({this.recipeTagManagerBloc});
}

class RecipeTagManager extends StatelessWidget {
  const RecipeTagManager();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeTagManagerBloc, RecipeTagManagerState>(
      builder: (context, state) {
        if (state is LoadingRecipeTagManager) {
          return EditorialCatalogManagerShell(
            title: S.of(context).manage_recipe_tags,
            description: S.of(context).catalog_tags_description,
            itemCount: 0,
            headerIcon: Icons.tag_rounded,
            addLabel: S.of(context).catalog_add_tag,
            emptyTitle: S.of(context).catalog_tags_empty_title,
            emptyDescription: S.of(context).catalog_tags_empty_description,
            emptyIcon: Icons.sell_outlined,
            onAdd: () {},
            contentSlivers: const [],
            loading: true,
          );
        }

        if (state is! LoadedRecipeTagManager) {
          return const SizedBox.shrink();
        }

        return EditorialCatalogManagerShell(
          title: S.of(context).manage_recipe_tags,
          description: S.of(context).catalog_tags_description,
          itemCount: state.recipeTags.length,
          headerIcon: Icons.tag_rounded,
          addLabel: S.of(context).catalog_add_tag,
          emptyTitle: S.of(context).catalog_tags_empty_title,
          emptyDescription: S.of(context).catalog_tags_empty_description,
          emptyIcon: Icons.sell_outlined,
          onAdd: () => _showEditor(context, state.recipeTags),
          contentSlivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final recipeTag = state.recipeTags[index];
                return EditorialCatalogContentFrame(
                  key: ValueKey('tag-row-${recipeTag.text}'),
                  child: EditorialCatalogRowSurface(
                    leading: _TagColorBadge(color: Color(recipeTag.number)),
                    title: '#${recipeTag.text}',
                    subtitle: S.of(context).catalog_tag_row_description,
                    onTap: () => _showEditor(
                      context,
                      state.recipeTags,
                      currentTag: recipeTag,
                    ),
                    trailing: EditorialCatalogMenuButton(
                      tooltip: S
                          .of(context)
                          .catalog_more_actions(recipeTag.text),
                      editLabel: S.of(context).edit,
                      deleteLabel: S.of(context).delete,
                      onEdit: () => _showEditor(
                        context,
                        state.recipeTags,
                        currentTag: recipeTag,
                      ),
                      onDelete: () => _showDeleteDialog(context, recipeTag),
                    ),
                  ),
                );
              }, childCount: state.recipeTags.length),
            ),
          ],
        );
      },
    );
  }

  void _showEditor(
    BuildContext context,
    List<StringIntTuple> recipeTags, {
    StringIntTuple? currentTag,
  }) {
    showTagEditorSheet(
      context: context,
      title: currentTag == null
          ? S.of(context).catalog_add_tag
          : S.of(context).catalog_edit_tag,
      fieldLabel: S.of(context).recipe_tag,
      saveLabel: S.of(context).save,
      cancelLabel: S.of(context).cancel,
      emptyError: S.of(context).field_must_not_be_empty,
      duplicateError: S.of(context).recipe_tag_already_exists,
      chooseColorLabel: S.of(context).catalog_choose_tag_color,
      customColorLabel: S.of(context).catalog_custom_tag_color,
      colorPreviewLabel: S.of(context).catalog_tag_preview,
      existingNames: recipeTags.map((tag) => tag.text),
      initialName: currentTag?.text,
      initialColor: currentTag == null
          ? const Color(0xFFA83211)
          : Color(currentTag.number),
      onSave: (name, color) {
        final manager = context.read<RecipeTagManagerBloc>().recipeManagerBloc;
        final updatedTag = StringIntTuple(text: name, number: color);
        if (currentTag == null) {
          manager.add(RMAddRecipeTag([updatedTag]));
        } else if (updatedTag != currentTag) {
          manager.add(RMUpdateRecipeTag(currentTag, updatedTag));
        }
      },
    );
  }

  Future<void> _showDeleteDialog(
    BuildContext context,
    StringIntTuple recipeTag,
  ) async {
    final palette = CulinaryEditorialPalette.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: Icon(Icons.delete_outline_rounded, color: palette.primary),
        title: Text(S.of(context).catalog_delete_tag_title(recipeTag.text)),
        content: Text(S.of(context).catalog_delete_tag_description),
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
      context.read<RecipeManagerBloc>().add(RMDeleteRecipeTag(recipeTag));
    }
  }
}

class _TagColorBadge extends StatelessWidget {
  const _TagColorBadge({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Container(
      width: 48,
      height: 52,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Color.alphaBlend(
          color.withValues(alpha: .14),
          palette.surfaceContainer,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: palette.onSurface.withValues(alpha: .18)),
        ),
      ),
    );
  }
}
