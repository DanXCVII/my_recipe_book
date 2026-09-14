import 'dart:io';

import 'package:flutter/material.dart';

import '../../constants/global_constants.dart' as constants;
import '../../constants/global_settings.dart';
import '../../generated/l10n.dart';
import '../../models/enums.dart';
import '../../models/recipe.dart';
import '../../util/helper.dart';
import 'recipe_overview_theme.dart';

enum RecipeOverviewCardLayout { grid, list }

class EditorialRecipeCard extends StatelessWidget {
  const EditorialRecipeCard({
    required this.recipe,
    required this.heroImageTag,
    required this.layout,
    required this.onOpen,
    required this.onBookmarkToggle,
    super.key,
  });

  final Recipe recipe;
  final String heroImageTag;
  final RecipeOverviewCardLayout layout;
  final VoidCallback onOpen;
  final VoidCallback onBookmarkToggle;

  @override
  Widget build(BuildContext context) {
    final palette = RecipeOverviewPalette.of(context);
    final radius = BorderRadius.circular(14);

    return Semantics(
      button: true,
      label: recipe.name,
      child: Material(
        color: palette.surface,
        borderRadius: radius,
        shadowColor: palette.shadow,
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onOpen,
          child: layout == RecipeOverviewCardLayout.grid
              ? _GridCard(recipe: recipe, image: _image(context))
              : _ListCard(recipe: recipe, image: _image(context)),
        ),
      ),
    );
  }

  Widget _image(BuildContext context) {
    final palette = RecipeOverviewPalette.of(context);
    final animationsEnabled =
        GlobalSettings().animationsEnabled() &&
        !MediaQuery.disableAnimationsOf(context);
    final image = Image(
      image: recipe.imagePreviewPath == constants.noRecipeImage
          ? AssetImage(recipe.imagePreviewPath) as ImageProvider<Object>
          : FileImage(File(recipe.imagePreviewPath)),
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

    return Stack(
      fit: StackFit.expand,
      children: [
        Hero(
          tag: animationsEnabled ? heroImageTag : '$heroImageTag-editorial',
          child: Material(color: palette.surfaceContainerHigh, child: image),
        ),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Color(0x66000000)],
              stops: [0.55, 1],
            ),
          ),
        ),
        Positioned(left: 8, bottom: 7, child: _TimeBadge(recipe: recipe)),
        Positioned(
          top: 0,
          right: 0,
          child: Semantics(
            button: true,
            label: recipe.isFavorite
                ? S.of(context).remove_from_favorites
                : S.of(context).add_to_favorites,
            child: SizedBox(
              width: 48,
              height: 48,
              child: IconButton(
                tooltip: recipe.isFavorite
                    ? S.of(context).remove_from_favorites
                    : S.of(context).add_to_favorites,
                onPressed: onBookmarkToggle,
                icon: DecoratedBox(
                  decoration: BoxDecoration(
                    color: palette.surface.withAlpha(235),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: palette.shadow,
                        offset: const Offset(0, 2),
                        blurRadius: 7,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(7),
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
    );
  }
}

class _GridCard extends StatelessWidget {
  const _GridCard({required this.recipe, required this.image});

  final Recipe recipe;
  final Widget image;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(aspectRatio: 4 / 3, child: image),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 9, 10, 10),
          child: _RecipeMetadata(recipe: recipe, compact: true),
        ),
      ],
    );
  }
}

class _ListCard extends StatelessWidget {
  const _ListCard({required this.recipe, required this.image});

  final Recipe recipe;
  final Widget image;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 148,
      child: LayoutBuilder(
        builder: (context, constraints) => Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: (constraints.maxWidth * 0.38).clamp(124.0, 176.0),
              child: image,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(13, 11, 13, 11),
                child: _RecipeMetadata(recipe: recipe, compact: false),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecipeMetadata extends StatelessWidget {
  const _RecipeMetadata({required this.recipe, required this.compact});

  final Recipe recipe;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final palette = RecipeOverviewPalette.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 5,
          runSpacing: 5,
          children: [
            _EffortBadge(effort: recipe.effort),
            _DietBadge(vegetable: recipe.vegetable),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          recipe.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: RecipeOverviewType.headline(
            palette,
            size: compact ? 15 : 18,
            weight: FontWeight.w600,
            height: 1.18,
          ),
        ),
        const SizedBox(height: 7),
        Divider(height: 1, thickness: 1, color: palette.surfaceContainer),
        const SizedBox(height: 7),
        _TagWrap(recipe: recipe),
      ],
    );
  }
}

class _TimeBadge extends StatelessWidget {
  const _TimeBadge({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final palette = RecipeOverviewPalette.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.surface.withAlpha(235),
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: palette.shadow,
            offset: const Offset(0, 1),
            blurRadius: 4,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        child: Text(
          getTimeHoursMinutes(recipe.totalTime),
          style: RecipeOverviewType.body(
            palette,
            size: 10,
            weight: FontWeight.w700,
            height: 1,
          ),
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
    final palette = RecipeOverviewPalette.of(context);
    final value = effort;
    final color = value == null || value <= 3
        ? palette.secondary
        : value <= 7
        ? palette.tertiary
        : palette.primary;
    final background = value == null || value <= 3
        ? palette.secondarySoft
        : value <= 7
        ? palette.tertiarySoft
        : palette.primarySoft;
    return _MetadataBadge(
      icon: value != null && value >= 8
          ? Icons.local_fire_department_rounded
          : value != null && value >= 4
          ? Icons.tune_rounded
          : Icons.eco_rounded,
      label: '${value ?? '—'}/10',
      color: color,
      background: background,
    );
  }
}

class _DietBadge extends StatelessWidget {
  const _DietBadge({required this.vegetable});

  final Vegetable vegetable;

  @override
  Widget build(BuildContext context) {
    final palette = RecipeOverviewPalette.of(context);
    switch (vegetable) {
      case Vegetable.VEGAN:
        return _MetadataBadge(
          icon: Icons.eco_rounded,
          label: S.of(context).vegan,
          color: palette.secondary,
          background: palette.secondarySoft,
        );
      case Vegetable.VEGETARIAN:
        return _MetadataBadge(
          icon: Icons.spa_rounded,
          label: S.of(context).vegetarian,
          color: palette.secondary,
          background: palette.secondarySoft,
        );
      case Vegetable.NON_VEGETARIAN:
        return _MetadataBadge(
          icon: Icons.restaurant_rounded,
          label: S.of(context).with_meat,
          color: palette.primary,
          background: palette.primarySoft,
        );
    }
  }
}

class _MetadataBadge extends StatelessWidget {
  const _MetadataBadge({
    required this.icon,
    required this.label,
    required this.color,
    required this.background,
  });

  final IconData icon;
  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    final palette = RecipeOverviewPalette.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 3),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: RecipeOverviewType.body(
                palette,
                size: 10,
                weight: FontWeight.w700,
                color: color,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TagWrap extends StatelessWidget {
  const _TagWrap({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final tags = recipe.tags.take(3).toList();
    if (tags.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 5,
      runSpacing: 5,
      children: [
        for (final tag in tags) _Tag(label: '#${tag.text}'),
        if (recipe.tags.length > tags.length)
          _Tag(label: '+${recipe.tags.length - tags.length}'),
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final palette = RecipeOverviewPalette.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.surfaceContainer,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: RecipeOverviewType.body(
            palette,
            size: 10,
            weight: FontWeight.w500,
            color: palette.outline,
            height: 1,
          ),
        ),
      ),
    );
  }
}
