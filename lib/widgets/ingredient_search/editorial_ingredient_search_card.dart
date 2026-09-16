import 'dart:io';

import 'package:flutter/material.dart';

import '../../constants/global_constants.dart' as constants;
import '../../generated/l10n.dart';
import '../../models/enums.dart';
import '../../models/recipe.dart';
import '../../util/helper.dart';
import '../culinary_editorial_theme.dart';

class EditorialIngredientSearchCard extends StatelessWidget {
  const EditorialIngredientSearchCard({
    required this.recipe,
    required this.matchedIngredientCount,
    required this.selectedIngredientCount,
    required this.heroImageTag,
    required this.onOpen,
    required this.onBookmarkToggle,
    super.key,
  });

  final Recipe recipe;
  final int matchedIngredientCount;
  final int selectedIngredientCount;
  final String heroImageTag;
  final VoidCallback onOpen;
  final VoidCallback onBookmarkToggle;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final radius = BorderRadius.circular(16);

    return Semantics(
      button: true,
      label: recipe.name,
      child: Material(
        color: palette.surface,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        elevation: 2,
        shadowColor: palette.shadow,
        child: InkWell(
          onTap: onOpen,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Hero(
                      tag: heroImageTag,
                      child: Material(
                        color: palette.surfaceContainerHigh,
                        child: _RecipeImage(recipe: recipe),
                      ),
                    ),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Color(0x4D000000)],
                          stops: [0.55, 1],
                        ),
                      ),
                    ),
                    if (selectedIngredientCount > 0)
                      Positioned(
                        left: 12,
                        top: 12,
                        child: _MatchBadge(
                          matched: matchedIngredientCount,
                          total: selectedIngredientCount,
                        ),
                      ),
                    Positioned(
                      right: 4,
                      top: 4,
                      child: Semantics(
                        button: true,
                        label: recipe.isFavorite
                            ? S.of(context).remove_from_favorites
                            : S.of(context).add_to_favorites,
                        child: SizedBox(
                          width: 48,
                          height: 48,
                          child: IconButton(
                            key: Key(
                              'ingredient-search-bookmark-${recipe.name}',
                            ),
                            tooltip: recipe.isFavorite
                                ? S.of(context).remove_from_favorites
                                : S.of(context).add_to_favorites,
                            onPressed: onBookmarkToggle,
                            icon: DecoratedBox(
                              decoration: BoxDecoration(
                                color: palette.surface.withAlpha(240),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: palette.shadow,
                                    offset: const Offset(0, 2),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Icon(
                                  recipe.isFavorite
                                      ? Icons.bookmark_rounded
                                      : Icons.bookmark_border_rounded,
                                  size: 18,
                                  color: palette.primary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: 17,
                          color: palette.onSurfaceVariant,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          recipe.totalTime > 0
                              ? getTimeHoursMinutes(recipe.totalTime)
                              : S.of(context).ingredient_search_time_unknown,
                          style: CulinaryEditorialType.body(
                            palette,
                            size: 12,
                            weight: FontWeight.w600,
                            color: palette.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '· ${_dietLabel(context, recipe.vegetable)}',
                          style: CulinaryEditorialType.body(
                            palette,
                            size: 12,
                            weight: FontWeight.w600,
                            color: palette.onSurfaceVariant,
                          ),
                        ),
                        const Spacer(),
                        _EffortBadge(effort: recipe.effort),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      recipe.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: CulinaryEditorialType.headline(
                        palette,
                        size: 20,
                        weight: FontWeight.w600,
                        height: 1.18,
                      ),
                    ),
                    if (selectedIngredientCount > 0) ...[
                      const SizedBox(height: 12),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: palette.secondarySoft,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 11,
                            vertical: 9,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle_rounded,
                                size: 18,
                                color: palette.secondary,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  S
                                      .of(context)
                                      .ingredient_search_match_summary(
                                        matchedIngredientCount,
                                        selectedIngredientCount,
                                      ),
                                  style: CulinaryEditorialType.body(
                                    palette,
                                    size: 12,
                                    weight: FontWeight.w600,
                                    color: palette.secondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: FilledButton.icon(
                        key: Key('ingredient-search-open-${recipe.name}'),
                        onPressed: onOpen,
                        iconAlignment: IconAlignment.end,
                        icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                        label: Text(S.of(context).open_recipe),
                        style: FilledButton.styleFrom(
                          backgroundColor: palette.primary,
                          foregroundColor: palette.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          textStyle: CulinaryEditorialType.body(
                            palette,
                            size: 13,
                            weight: FontWeight.w700,
                            color: palette.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _dietLabel(BuildContext context, Vegetable vegetable) {
    switch (vegetable) {
      case Vegetable.VEGAN:
        return S.of(context).vegan;
      case Vegetable.VEGETARIAN:
        return S.of(context).vegetarian;
      case Vegetable.NON_VEGETARIAN:
        return S.of(context).with_meat;
    }
  }
}

class _RecipeImage extends StatelessWidget {
  const _RecipeImage({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final imageProvider = recipe.imagePreviewPath == constants.noRecipeImage
        ? AssetImage(recipe.imagePreviewPath) as ImageProvider<Object>
        : FileImage(File(recipe.imagePreviewPath));
    return Image(
      image: imageProvider,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      gaplessPlayback: true,
      errorBuilder: (context, error, stackTrace) => Image.asset(
        constants.noRecipeImage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
}

class _MatchBadge extends StatelessWidget {
  const _MatchBadge({required this.matched, required this.total});

  final int matched;
  final int total;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.secondarySoft,
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: palette.shadow,
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.eco_rounded, size: 14, color: palette.secondary),
            const SizedBox(width: 5),
            Text(
              S.of(context).ingredient_search_match_badge(matched, total),
              style: CulinaryEditorialType.body(
                palette,
                size: 11,
                weight: FontWeight.w700,
                color: palette.secondary,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EffortBadge extends StatelessWidget {
  const _EffortBadge({required this.effort});

  final int? effort;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.surfaceContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          effort == null
              ? S.of(context).ingredient_search_effort_unknown
              : S.of(context).ingredient_search_effort_value(effort!),
          style: CulinaryEditorialType.body(
            palette,
            size: 10,
            weight: FontWeight.w700,
            color: palette.onSurfaceVariant,
            height: 1,
          ),
        ),
      ),
    );
  }
}
