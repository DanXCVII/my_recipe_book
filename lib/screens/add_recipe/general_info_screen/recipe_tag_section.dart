import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../ad_related/ad.dart';
import '../../../blocs/recipe_manager/recipe_manager_bloc.dart';
import '../../../blocs/recipe_tag_manager/recipe_tag_manager_bloc.dart';
import '../../../constants/routes.dart';

import 'package:my_recipe_book/generated/l10n.dart';

import '../../../models/string_int_tuple.dart';
import '../../../widgets/culinary_editorial_theme.dart';
import '../../../widgets/dialogs/text_color_dialog.dart';
import '../../recipe_tag_manager_screen.dart';
import 'editorial_classification_section.dart';

class RecipeTagSection extends StatelessWidget {
  const RecipeTagSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeTagManagerBloc, RecipeTagManagerState>(
      builder: (context, state) {
        if (state is LoadingRecipeTagManager) {
          return CircularProgressIndicator();
        } else if (state is LoadedRecipeTagManager) {
          return EditorialClassificationSection(
            title: S.of(context).select_recipe_tags,
            addTooltip: S.of(context).add,
            manageTooltip: S.of(context).manage_recipe_tags,
            onAdd: () {
              showDialog(
                context: context,
                builder: (_) => TextColorDialog(
                  validation: (String? name) {
                    if (state.recipeTags.firstWhereOrNull(
                          (element) => element.text == name,
                        ) !=
                        null) {
                      return S.of(context).recipe_tag_already_exists;
                    } else if (name == "") {
                      return S.of(context).field_must_not_be_empty;
                    } else {
                      return null;
                    }
                  },
                  save: (String name, int color) {
                    BlocProvider.of<RecipeTagManagerBloc>(context)
                        .recipeManagerBloc
                        .add(
                          RMAddRecipeTag([
                            StringIntTuple(text: name, number: color),
                          ]),
                        );
                  },
                  hintText: S.of(context).recipe_tag,
                ),
              );
            },
            onManage: () {
              Navigator.pushNamed(
                context,
                RouteNames.manageRecipeTags,
                arguments: RecipeTagManagerArguments(
                  recipeTagManagerBloc: BlocProvider.of<RecipeTagManagerBloc>(
                    context,
                  ),
                ),
              ).then((_) => Ads.hideBottomBannerAd());
            },
            children: state.recipeTags.map((recipeTag) {
              return MyRecipeTagFilterChip(
                recipeTag: recipeTag,
                isSelected: state.selectedTags.any(
                  (selectedTag) => selectedTag.text == recipeTag.text,
                ),
                onSelected: (isSelected) {
                  context.read<RecipeTagManagerBloc>().add(
                    isSelected
                        ? SelectRecipeTag(recipeTag)
                        : UnselectRecipeTag(recipeTag),
                  );
                },
              );
            }).toList(),
          );
        } else {
          return Text(state.toString());
        }
      },
    );
  }
}

// creates a filterClip with the given name
class MyRecipeTagFilterChip extends StatelessWidget {
  final StringIntTuple recipeTag;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  const MyRecipeTagFilterChip({
    super.key,
    required this.recipeTag,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final tagColor = Color(recipeTag.number);
    final backgroundColor = Color.alphaBlend(
      tagColor.withValues(alpha: .16),
      palette.surfaceContainer,
    );
    final selectedColor = Color.alphaBlend(
      tagColor.withValues(alpha: .28),
      palette.surfaceContainer,
    );
    final outlineColor = Color.alphaBlend(
      tagColor.withValues(alpha: isSelected ? .55 : .32),
      palette.outline,
    );

    return FilterChip(
      key: ValueKey('recipe-tag-${recipeTag.text}'),
      avatar: Container(
        key: ValueKey('recipe-tag-color-${recipeTag.text}'),
        width: 9,
        height: 9,
        decoration: BoxDecoration(
          color: tagColor,
          shape: BoxShape.circle,
          border: Border.all(color: palette.onSurface.withValues(alpha: .18)),
        ),
      ),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              '#${recipeTag.text}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (isSelected) ...[
            const SizedBox(width: 8),
            Icon(
              Icons.close_rounded,
              key: ValueKey('recipe-tag-remove-${recipeTag.text}'),
              size: 18,
              color: palette.onSurfaceVariant,
            ),
          ],
        ],
      ),
      labelStyle: CulinaryEditorialType.body(
        palette,
        size: 14,
        weight: isSelected ? FontWeight.w700 : FontWeight.w600,
      ),
      labelPadding: EdgeInsets.only(left: 3, right: isSelected ? 7 : 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      backgroundColor: backgroundColor,
      selectedColor: selectedColor,
      side: BorderSide(color: outlineColor),
      shape: const StadiumBorder(),
      showCheckmark: false,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      visualDensity: VisualDensity.standard,
      selected: isSelected,
      onSelected: onSelected,
    );
  }
}
