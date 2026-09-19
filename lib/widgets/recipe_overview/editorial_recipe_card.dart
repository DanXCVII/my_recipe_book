import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../constants/global_constants.dart' as constants;
import '../../constants/global_settings.dart';
import '../../generated/l10n.dart';
import '../../models/enums.dart';
import '../../models/recipe.dart';
import 'recipe_overview_theme.dart';

enum RecipeOverviewCardLayout { grid, list }

class EditorialRecipeCard extends StatelessWidget {
  const EditorialRecipeCard({
    required this.recipe,
    required this.heroImageTag,
    required this.layout,
    required this.onOpen,
    required this.onBookmarkToggle,
    required this.onCookAction,
    super.key,
  });

  final Recipe recipe;
  final String heroImageTag;
  final RecipeOverviewCardLayout layout;
  final VoidCallback onOpen;
  final VoidCallback onBookmarkToggle;
  final VoidCallback? onCookAction;

  @override
  Widget build(BuildContext context) {
    final palette = RecipeOverviewPalette.of(context);
    final isGrid = layout == RecipeOverviewCardLayout.grid;
    final radius = BorderRadius.circular(isGrid ? 12 : 14);

    return Semantics(
      button: true,
      label: recipe.name,
      child: Material(
        color: isGrid ? palette.onSurface : palette.surface,
        borderRadius: radius,
        shadowColor: palette.shadow,
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onOpen,
          child: isGrid
              ? _GridCard(
                  recipe: recipe,
                  image: _bareImage(context),
                  onBookmarkToggle: onBookmarkToggle,
                )
              : _ListCard(
                  recipe: recipe,
                  image: _bareImage(context),
                  onBookmarkToggle: onBookmarkToggle,
                  onCookAction: onCookAction,
                ),
        ),
      ),
    );
  }

  Widget _bareImage(BuildContext context) {
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

    return Hero(
      tag: animationsEnabled ? heroImageTag : '$heroImageTag-editorial',
      child: Material(color: palette.surfaceContainerHigh, child: image),
    );
  }
}

class _GridCard extends StatelessWidget {
  const _GridCard({
    required this.recipe,
    required this.image,
    required this.onBookmarkToggle,
  });

  final Recipe recipe;
  final Widget image;
  final VoidCallback onBookmarkToggle;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      key: const Key('recipe-card-grid-aspect'),
      aspectRatio: 8 / 9,
      child: Stack(
        fit: StackFit.expand,
        children: [
          image,
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Color(0xB3000000)],
                stops: [0.38, 1],
              ),
            ),
          ),
          Positioned(top: 8, left: 8, child: _GridTimeBadge(recipe: recipe)),
          Positioned(
            top: 0,
            right: 0,
            child: _GridBookmarkAction(
              isFavorite: recipe.isFavorite,
              onPressed: onBookmarkToggle,
            ),
          ),
          Positioned(
            left: 6,
            right: 6,
            bottom: 6,
            child: _GridMetadataHud(recipe: recipe),
          ),
        ],
      ),
    );
  }
}

class _GridBookmarkAction extends StatelessWidget {
  const _GridBookmarkAction({
    required this.isFavorite,
    required this.onPressed,
  });

  final bool isFavorite;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final palette = RecipeOverviewPalette.of(context);
    final isLight = Theme.of(context).brightness == Brightness.light;
    final label = isFavorite
        ? S.of(context).remove_from_favorites
        : S.of(context).add_to_favorites;

    return Semantics(
      button: true,
      label: label,
      child: SizedBox(
        key: const Key('recipe-card-grid-bookmark-action'),
        width: 48,
        height: 48,
        child: IconButton(
          tooltip: label,
          onPressed: onPressed,
          padding: const EdgeInsets.all(9),
          icon: DecoratedBox(
            key: const Key('recipe-card-grid-bookmark-visual'),
            decoration: BoxDecoration(
              color: isLight
                  ? palette.surface.withAlpha(242)
                  : const Color(0xB31A1719),
              shape: BoxShape.circle,
              border: Border.all(
                color: isLight
                    ? palette.onSurface.withValues(alpha: .08)
                    : const Color(0x2EFFF7F2),
              ),
              boxShadow: [
                BoxShadow(
                  color: palette.shadow,
                  offset: const Offset(0, 2),
                  blurRadius: 7,
                ),
              ],
            ),
            child: SizedBox.square(
              dimension: 30,
              child: Icon(
                isFavorite
                    ? Icons.bookmark_rounded
                    : Icons.bookmark_border_rounded,
                size: 18,
                color: palette.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GridTimeBadge extends StatelessWidget {
  const _GridTimeBadge({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final palette = RecipeOverviewPalette.of(context);
    final isLight = Theme.of(context).brightness == Brightness.light;
    final foreground = isLight ? palette.onSurface : const Color(0xFFFDF6F1);

    return DecoratedBox(
      key: const Key('recipe-card-grid-time-badge'),
      decoration: BoxDecoration(
        color: isLight
            ? palette.surface.withAlpha(242)
            : const Color(0x991A1719),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: isLight
              ? palette.onSurface.withValues(alpha: .08)
              : const Color(0x2EFFF7F2),
        ),
        boxShadow: [
          BoxShadow(
            color: palette.shadow,
            offset: const Offset(0, 1),
            blurRadius: 4,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.schedule_rounded, size: 12, color: palette.primary),
            const SizedBox(width: 4),
            Text(
              _compactTime(recipe.totalTime),
              style: RecipeOverviewType.body(
                palette,
                size: 10,
                weight: FontWeight.w600,
                color: foreground,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GridMetadataHud extends StatelessWidget {
  const _GridMetadataHud({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final palette = RecipeOverviewPalette.of(context);
    final isLight = Theme.of(context).brightness == Brightness.light;
    final foreground = isLight ? palette.onSurface : const Color(0xFFFDF6F1);

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: DecoratedBox(
          key: const Key('recipe-card-grid-hud'),
          decoration: BoxDecoration(
            color: isLight
                ? palette.surface.withAlpha(238)
                : const Color(0xB31A1719),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isLight
                  ? palette.onSurface.withValues(alpha: .08)
                  : const Color(0x24FFF7F2),
            ),
            boxShadow: [
              BoxShadow(
                color: palette.shadow,
                offset: const Offset(0, 3),
                blurRadius: 10,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 5,
                  runSpacing: 4,
                  children: [
                    _GridEffortBadge(effort: recipe.effort, isLight: isLight),
                    _GridDietBadge(
                      vegetable: recipe.vegetable,
                      isLight: isLight,
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  recipe.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: RecipeOverviewType.headline(
                    palette,
                    size: 14,
                    weight: FontWeight.w700,
                    height: 1.12,
                  ).copyWith(color: foreground, letterSpacing: -.18),
                ),
                if (recipe.tags.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  _GridTagRow(
                    labels: recipe.tags
                        .take(2)
                        .map((tag) => '#${tag.text}')
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GridTagRow extends StatelessWidget {
  const _GridTagRow({required this.labels});

  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var index = 0; index < labels.length; index++) ...[
          if (index > 0) const SizedBox(width: 8),
          Flexible(child: _GridTag(label: labels[index])),
        ],
      ],
    );
  }
}

class _GridTag extends StatelessWidget {
  const _GridTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final palette = RecipeOverviewPalette.of(context);
    return Text(
      label,
      key: Key('recipe-card-grid-tag-$label'),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: RecipeOverviewType.body(
        palette,
        size: 9.5,
        weight: FontWeight.w600,
        color: palette.onSurfaceVariant,
        height: 1.15,
        letterSpacing: .08,
      ),
    );
  }
}

class _GridEffortBadge extends StatelessWidget {
  const _GridEffortBadge({required this.effort, required this.isLight});

  final int? effort;
  final bool isLight;

  @override
  Widget build(BuildContext context) {
    final palette = RecipeOverviewPalette.of(context);
    final value = effort?.clamp(0, 10);
    final color = _effortColor(palette, value);
    final background = value == null || value <= 3
        ? palette.secondarySoft
        : value <= 7
        ? palette.tertiarySoft
        : palette.primarySoft;
    final icon = value != null && value >= 8
        ? Icons.local_fire_department_rounded
        : value != null && value >= 4
        ? Icons.tune_rounded
        : Icons.eco_rounded;

    return _GridBadge(
      icon: icon,
      label: '${value ?? '—'}/10',
      foreground: isLight ? color : const Color(0xFFFDF6F1),
      background: isLight ? background : color.withValues(alpha: .72),
    );
  }
}

class _GridDietBadge extends StatelessWidget {
  const _GridDietBadge({required this.vegetable, required this.isLight});

  final Vegetable vegetable;
  final bool isLight;

  @override
  Widget build(BuildContext context) {
    final palette = RecipeOverviewPalette.of(context);
    late final IconData icon;
    late final String label;
    late final Color color;
    late final Color background;

    switch (vegetable) {
      case Vegetable.VEGAN:
        icon = Icons.eco_rounded;
        label = S.of(context).vegan;
        color = palette.secondary;
        background = palette.secondarySoft;
      case Vegetable.VEGETARIAN:
        icon = Icons.spa_rounded;
        label = S.of(context).vegetarian;
        color = palette.secondary;
        background = palette.secondarySoft;
      case Vegetable.NON_VEGETARIAN:
        icon = Icons.restaurant_rounded;
        label = S.of(context).with_meat;
        color = palette.primary;
        background = palette.primarySoft;
    }

    return _GridBadge(
      icon: icon,
      label: label,
      foreground: isLight ? color : const Color(0xFFFDF6F1),
      background: isLight ? background : const Color(0x3DFFF7F2),
    );
  }
}

class _GridBadge extends StatelessWidget {
  const _GridBadge({
    required this.icon,
    required this.label,
    required this.foreground,
    required this.background,
  });

  final IconData icon;
  final String label;
  final Color foreground;
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
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 11, color: foreground),
            const SizedBox(width: 3),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: RecipeOverviewType.body(
                palette,
                size: 9.5,
                weight: FontWeight.w700,
                color: foreground,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ListCard extends StatelessWidget {
  const _ListCard({
    required this.recipe,
    required this.image,
    required this.onBookmarkToggle,
    required this.onCookAction,
  });

  final Recipe recipe;
  final Widget image;
  final VoidCallback onBookmarkToggle;
  final VoidCallback? onCookAction;

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final isCompact = textScale <= 1.3;

    final content = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            key: const Key('recipe-card-list-image'),
            width: 96,
            height: 96,
            child: image,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _ListMetadata(recipe: recipe, compact: isCompact),
        ),
        const SizedBox(width: 4),
        SizedBox(
          key: const Key('recipe-card-list-action-rail'),
          width: 48,
          height: 96,
          child: Column(
            children: [
              _BookmarkAction(
                isFavorite: recipe.isFavorite,
                onPressed: onBookmarkToggle,
              ),
              _CookAction(onPressed: onCookAction),
            ],
          ),
        ),
      ],
    );

    return Padding(
      key: const Key('recipe-card-list-padding'),
      padding: const EdgeInsets.all(8),
      child: isCompact
          ? SizedBox(
              key: const Key('recipe-card-list-content'),
              height: 96,
              child: content,
            )
          : KeyedSubtree(
              key: const Key('recipe-card-list-content'),
              child: content,
            ),
    );
  }
}

class _ListMetadata extends StatelessWidget {
  const _ListMetadata({required this.recipe, required this.compact});

  final Recipe recipe;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final palette = RecipeOverviewPalette.of(context);
    final rows = <Widget>[
      Text(
        recipe.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: RecipeOverviewType.headline(
          palette,
          size: 16,
          weight: FontWeight.w600,
          height: 1.2,
        ),
      ),
      _EffortGauge(effort: recipe.effort),
      Row(
        children: [
          Expanded(child: _TimeBreakdown(recipe: recipe)),
          const SizedBox(width: 4),
          Flexible(child: _DietBadge(vegetable: recipe.vegetable)),
        ],
      ),
      _ListTagRow(recipe: recipe, compact: compact),
    ];

    return Column(
      mainAxisSize: compact ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: compact
          ? MainAxisAlignment.spaceBetween
          : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: compact
          ? rows
          : [
              for (var index = 0; index < rows.length; index++) ...[
                if (index > 0) const SizedBox(height: 4),
                rows[index],
              ],
            ],
    );
  }
}

class _ListTagRow extends StatelessWidget {
  const _ListTagRow({required this.recipe, required this.compact});

  final Recipe recipe;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final visibleTags = recipe.tags.take(2).toList();
    final hiddenCount = recipe.tags.length - visibleTags.length;
    final labels = [
      ...visibleTags.map((tag) => '#${tag.text}'),
      if (hiddenCount > 0) '+$hiddenCount',
    ];

    if (labels.isEmpty) {
      return SizedBox(
        key: const Key('recipe-card-list-tags'),
        height: compact ? 20 : MediaQuery.textScalerOf(context).scale(11) + 8,
      );
    }

    return Row(
      key: const Key('recipe-card-list-tags'),
      children: [
        for (var index = 0; index < labels.length; index++) ...[
          if (index > 0) const SizedBox(width: 4),
          Flexible(
            child: _ListTag(label: labels[index], compact: compact),
          ),
        ],
      ],
    );
  }
}

class _ListTag extends StatelessWidget {
  const _ListTag({required this.label, required this.compact});

  final String label;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final palette = RecipeOverviewPalette.of(context);
    final tag = DecoratedBox(
      decoration: BoxDecoration(
        color: palette.surfaceContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 6 : 8,
          vertical: compact ? 0 : 4,
        ),
        child: Center(
          widthFactor: 1,
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: RecipeOverviewType.body(
              palette,
              size: 11,
              weight: FontWeight.w500,
              color: palette.outline,
              height: 1,
            ),
          ),
        ),
      ),
    );

    return SizedBox(
      key: Key('recipe-card-list-tag-$label'),
      height: compact ? 20 : null,
      child: tag,
    );
  }
}

class _BookmarkAction extends StatelessWidget {
  const _BookmarkAction({required this.isFavorite, required this.onPressed});

  final bool isFavorite;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final palette = RecipeOverviewPalette.of(context);
    final label = isFavorite
        ? S.of(context).remove_from_favorites
        : S.of(context).add_to_favorites;
    return SizedBox(
      key: const Key('recipe-card-bookmark-action'),
      width: 48,
      height: 48,
      child: IconButton(
        tooltip: label,
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        icon: Icon(
          isFavorite ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
          size: 22,
          color: palette.primary,
        ),
      ),
    );
  }
}

class _CookAction extends StatelessWidget {
  const _CookAction({required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final palette = RecipeOverviewPalette.of(context);
    return SizedBox(
      key: const Key('recipe-card-cook-action'),
      width: 48,
      height: 48,
      child: IconButton(
        tooltip: S.of(context).start_cooking,
        onPressed: onPressed,
        padding: const EdgeInsets.all(8),
        icon: SizedBox(
          key: const Key('recipe-card-cook-visual'),
          width: 32,
          height: 32,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: onPressed == null
                  ? palette.surfaceContainerHigh
                  : palette.primarySoft,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.soup_kitchen_rounded,
              size: 18,
              color: onPressed == null
                  ? palette.onSurfaceVariant.withValues(alpha: .45)
                  : palette.primary,
            ),
          ),
        ),
      ),
    );
  }
}

class _EffortGauge extends StatelessWidget {
  const _EffortGauge({required this.effort});

  final int? effort;

  @override
  Widget build(BuildContext context) {
    final palette = RecipeOverviewPalette.of(context);
    final value = effort?.clamp(0, 10);
    final color = _effortColor(palette, value);
    return Row(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(10, (index) {
            final active = value != null && index < value;
            return Padding(
              padding: EdgeInsets.only(right: index == 9 ? 0 : 2),
              child: DecoratedBox(
                key: Key('recipe-effort-segment-$index'),
                decoration: BoxDecoration(
                  color: active ? color : palette.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const SizedBox(width: 5, height: 9),
              ),
            );
          }),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            S.of(context).recipe_card_effort_value('${value ?? '—'}'),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: RecipeOverviewType.body(
              palette,
              size: 11,
              weight: FontWeight.w700,
              color: value == null ? palette.onSurfaceVariant : color,
              height: 1.1,
            ),
          ),
        ),
      ],
    );
  }
}

Color _effortColor(RecipeOverviewPalette palette, int? effort) {
  if (effort == null || effort <= 3) return palette.secondary;
  if (effort <= 7) return palette.tertiary;
  return palette.primary;
}

class _TimeBreakdown extends StatelessWidget {
  const _TimeBreakdown({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final palette = RecipeOverviewPalette.of(context);
    final prep = recipe.preperationTime;
    final cook = recipe.cookingTime;
    final labels = <String>[];
    if (prep > 0 && cook > 0) {
      labels
        ..add(S.of(context).recipe_card_prep_time(_compactTime(prep)))
        ..add(S.of(context).recipe_card_cook_time(_compactTime(cook)));
    } else if (recipe.totalTime > 0) {
      labels.add(
        S.of(context).recipe_card_total_time(_compactTime(recipe.totalTime)),
      );
    } else if (prep > 0) {
      labels.add(S.of(context).recipe_card_prep_time(_compactTime(prep)));
    } else if (cook > 0) {
      labels.add(S.of(context).recipe_card_cook_time(_compactTime(cook)));
    }

    return Row(
      children: [
        Icon(Icons.schedule_rounded, size: 16, color: palette.primary),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            labels.isEmpty
                ? S.of(context).recipe_card_time_unknown
                : labels.join(' · '),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: RecipeOverviewType.body(
              palette,
              size: 11,
              weight: FontWeight.w600,
              height: 1.15,
            ),
          ),
        ),
      ],
    );
  }
}

String _compactTime(double minutes) {
  final hours = minutes ~/ 60;
  final remaining = minutes - (hours * 60);
  final parts = <String>[];
  if (hours > 0) parts.add('${hours}h');
  if (remaining > 0 || hours == 0) {
    final minuteLabel = remaining == remaining.roundToDouble()
        ? remaining.toInt().toString()
        : remaining.toStringAsFixed(1);
    parts.add('${minuteLabel}m');
  }
  return parts.join(' ');
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
            Flexible(
              child: Text(
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
            ),
          ],
        ),
      ),
    );
  }
}
