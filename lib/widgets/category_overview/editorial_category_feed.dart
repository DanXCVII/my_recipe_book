import 'dart:io';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../constants/global_constants.dart' as constants;
import '../../constants/global_settings.dart';
import '../../generated/l10n.dart';
import '../../models/enums.dart';
import '../../models/recipe.dart';
import '../../models/tuple.dart';
import '../../util/helper.dart';
import '../culinary_editorial_theme.dart';
import '../recipe_overview/editorial_recipe_card.dart';

typedef OpenOverviewRecipe = void Function(Recipe recipe, String heroTag);
typedef ToggleOverviewFavorite = void Function(Recipe recipe);
typedef OpenOverviewCategory = void Function(String category);

class EditorialCategoryFeed extends StatelessWidget {
  const EditorialCategoryFeed({
    required this.sections,
    required this.featuredRecipe,
    required this.onOpenRecipe,
    required this.onToggleFavorite,
    required this.onOpenCategory,
    super.key,
  });

  final List<Tuple2<String, List<Recipe>>> sections;
  final Recipe? featuredRecipe;
  final OpenOverviewRecipe onOpenRecipe;
  final ToggleOverviewFavorite onToggleFavorite;
  final OpenOverviewCategory onOpenCategory;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final hasRecipes = sections.any((section) => section.item2.isNotEmpty);

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 1000;
        final horizontalPadding = wide ? 32.0 : 20.0;
        final contentWidth = math.min(1180.0, constraints.maxWidth);
        const cardListHeight = 216.0;
        final navigationClearance =
            constants.usesHomeNavigationRail(constraints.maxWidth)
            ? 0.0
            : MediaQuery.paddingOf(context).bottom;

        if (!hasRecipes) {
          return _EmptyLibrary(
            palette: palette,
            horizontalPadding: horizontalPadding,
          );
        }

        return CustomScrollView(
          key: const PageStorageKey('editorial-category-feed'),
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Center(
                child: SizedBox(
                  width: contentWidth,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      20,
                      horizontalPadding,
                      wide ? 40 : 34,
                    ),
                    child: featuredRecipe == null
                        ? const SizedBox.shrink()
                        : _FeaturedRecipeCard(
                            recipe: featuredRecipe!,
                            wide: wide,
                            onOpen: onOpenRecipe,
                            onToggleFavorite: onToggleFavorite,
                          ),
                  ),
                ),
              ),
            ),
            if (wide)
              SliverPadding(
                key: const Key('category-feed-sections-padding'),
                padding: EdgeInsets.fromLTRB(
                  math.max(32, (constraints.maxWidth - contentWidth) / 2 + 32),
                  0,
                  math.max(32, (constraints.maxWidth - contentWidth) / 2 + 32),
                  36 + navigationClearance,
                ),
                sliver: SliverGrid.builder(
                  itemCount: sections.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 28,
                    mainAxisSpacing: 8,
                    mainAxisExtent: cardListHeight + 48,
                  ),
                  itemBuilder: (context, index) => _CategorySection(
                    section: sections[index],
                    sectionIndex: index,
                    listHeight: cardListHeight,
                    onOpenRecipe: onOpenRecipe,
                    onToggleFavorite: onToggleFavorite,
                    onOpenCategory: onOpenCategory,
                  ),
                ),
              )
            else
              SliverPadding(
                key: const Key('category-feed-sections-padding'),
                padding: EdgeInsets.fromLTRB(0, 0, 0, 36 + navigationClearance),
                sliver: SliverList.separated(
                  itemCount: sections.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) => _CategorySection(
                    section: sections[index],
                    sectionIndex: index,
                    listHeight: cardListHeight,
                    horizontalInset: horizontalPadding,
                    onOpenRecipe: onOpenRecipe,
                    onToggleFavorite: onToggleFavorite,
                    onOpenCategory: onOpenCategory,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class CategoryOverviewLoading extends StatelessWidget {
  const CategoryOverviewLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 36),
          sliver: SliverList.list(
            children: [
              _SkeletonBox(
                key: const Key('category-overview-loading-hero'),
                height: 430,
                radius: 16,
                color: palette.surfaceContainer,
              ),
              const SizedBox(height: 36),
              _SkeletonSection(palette: palette),
              const SizedBox(height: 32),
              _SkeletonSection(palette: palette),
            ],
          ),
        ),
      ],
    );
  }
}

class CategoryOverviewFailure extends StatelessWidget {
  const CategoryOverviewFailure({required this.onRetry, super.key});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.cloud_off_rounded,
                      size: 42,
                      color: palette.primary,
                    ),
                    const SizedBox(height: 18),
                    Text(
                      S.of(context).recipe_overview_failed,
                      textAlign: TextAlign.center,
                      style: CulinaryEditorialType.headline(
                        palette,
                        size: 24,
                        weight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      S.of(context).recipe_overview_failed_description,
                      textAlign: TextAlign.center,
                      style: CulinaryEditorialType.body(
                        palette,
                        size: 14,
                        color: palette.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 22),
                    FilledButton.icon(
                      onPressed: onRetry,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(160, 52),
                        backgroundColor: palette.primary,
                        foregroundColor: palette.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: CulinaryEditorialType.body(
                          palette,
                          size: 14,
                          weight: FontWeight.w700,
                          color: palette.onPrimary,
                        ),
                      ),
                      icon: const Icon(Icons.refresh_rounded),
                      label: Text(S.of(context).retry),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FeaturedRecipeCard extends StatefulWidget {
  const _FeaturedRecipeCard({
    required this.recipe,
    required this.wide,
    required this.onOpen,
    required this.onToggleFavorite,
  });

  final Recipe recipe;
  final bool wide;
  final OpenOverviewRecipe onOpen;
  final ToggleOverviewFavorite onToggleFavorite;

  @override
  State<_FeaturedRecipeCard> createState() => _FeaturedRecipeCardState();
}

class _FeaturedRecipeCardState extends State<_FeaturedRecipeCard> {
  bool _expanded = true;

  Recipe get recipe => widget.recipe;
  String get _heroTag => 'category-feed-featured-${recipe.name}';

  @override
  Widget build(BuildContext context) {
    final animationsEnabled =
        GlobalSettings().animationsEnabled() &&
        !MediaQuery.disableAnimationsOf(context);
    final duration = animationsEnabled
        ? const Duration(milliseconds: 280)
        : Duration.zero;
    final child = _expanded
        ? _ExpandedFeaturedRecipe(
            key: const ValueKey('category-featured-expanded'),
            recipe: recipe,
            heroTag: _heroTag,
            wide: widget.wide,
            onOpen: () => widget.onOpen(recipe, _heroTag),
            onCollapse: () => setState(() => _expanded = false),
            onToggleFavorite: () => widget.onToggleFavorite(recipe),
          )
        : _CollapsedFeaturedRecipe(
            key: const ValueKey('category-featured-collapsed'),
            recipe: recipe,
            onExpand: () => setState(() => _expanded = true),
          );

    return Semantics(
      container: true,
      label: '${S.of(context).dish_of_the_day}: ${recipe.name}',
      child: ClipRect(
        child: AnimatedSize(
          alignment: Alignment.topCenter,
          duration: duration,
          curve: Curves.easeOutCubic,
          child: AnimatedSwitcher(
            duration: duration,
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (child, animation) =>
                FadeTransition(opacity: animation, child: child),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _ExpandedFeaturedRecipe extends StatelessWidget {
  const _ExpandedFeaturedRecipe({
    required this.recipe,
    required this.heroTag,
    required this.wide,
    required this.onOpen,
    required this.onCollapse,
    required this.onToggleFavorite,
    super.key,
  });

  final Recipe recipe;
  final String heroTag;
  final bool wide;
  final VoidCallback onOpen;
  final VoidCallback onCollapse;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final card = Material(
      key: const Key('category-featured-card'),
      color: palette.onSurface,
      elevation: 2,
      shadowColor: palette.shadow,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Hero(
            tag: heroTag,
            child: Material(
              color: palette.surfaceContainerHigh,
              child: _RecipeImage(path: recipe.imagePath),
            ),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0, .42, 1],
                colors: [
                  Color(0x1A000000),
                  Color(0x26000000),
                  Color(0xD9000000),
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onOpen,
                splashColor: palette.primarySoft.withAlpha(70),
              ),
            ),
          ),
          Positioned(
            left: 10,
            right: 10,
            bottom: 10,
            child: _FeaturedDetailsOverlay(
              recipe: recipe,
              wide: wide,
              onOpen: onOpen,
            ),
          ),
          Positioned(
            top: 8,
            left: 12,
            right: 8,
            child: _FeaturedTopBar(
              recipe: recipe,
              wide: wide,
              onCollapse: onCollapse,
              onToggleFavorite: onToggleFavorite,
            ),
          ),
        ],
      ),
    );

    if (wide) return SizedBox(height: 444, child: card);
    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = MediaQuery.textScalerOf(context).scale(16) / 16;
        final accessibilityHeight = ((scale - 1).clamp(0, .6) * 240).toDouble();
        return SizedBox(
          height: constraints.maxWidth * .9 + accessibilityHeight,
          child: card,
        );
      },
    );
  }
}

class _FeaturedTopBar extends StatelessWidget {
  const _FeaturedTopBar({
    required this.recipe,
    required this.wide,
    required this.onCollapse,
    required this.onToggleFavorite,
  });

  final Recipe recipe;
  final bool wide;
  final VoidCallback onCollapse;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Wrap(
            spacing: 6,
            runSpacing: 5,
            children: [
              _LightBadge(
                label: S.of(context).dish_of_the_day.toUpperCase(),
                color: palette.primary,
              ),
              _FeaturedTimeBadge(
                key: const Key('category-featured-time'),
                recipe: recipe,
                dark: true,
              ),
            ],
          ),
        ),
        const SizedBox(width: 4),
        _FeaturedOverlayAction(
          key: const Key('category-featured-collapse'),
          tooltip: S.of(context).collapse_dish_of_the_day,
          icon: Icons.expand_less_rounded,
          label: wide ? S.of(context).collapse : null,
          onPressed: onCollapse,
        ),
        _FeaturedOverlayAction(
          key: ValueKey('category-featured-favorite-${recipe.name}'),
          tooltip: recipe.isFavorite
              ? S.of(context).remove_from_favorites
              : S.of(context).add_to_favorites,
          icon: recipe.isFavorite
              ? Icons.bookmark_rounded
              : Icons.bookmark_border_rounded,
          onPressed: onToggleFavorite,
        ),
      ],
    );
  }
}

class _FeaturedDetailsOverlay extends StatelessWidget {
  const _FeaturedDetailsOverlay({
    required this.recipe,
    required this.wide,
    required this.onOpen,
  });

  final Recipe recipe;
  final bool wide;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final tags = recipe.tags.take(wide ? 3 : 2).toList(growable: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xB81A1412),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0x24FFF7F2)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x40000000),
                offset: Offset(0, 4),
                blurRadius: 14,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 11),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Wrap(
                        key: const Key('category-featured-metadata'),
                        spacing: 6,
                        runSpacing: 5,
                        children: [
                          _FeaturedEffortChip(recipe: recipe),
                          _FeaturedDietChip(vegetable: recipe.vegetable),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton.icon(
                      key: const Key('category-featured-open'),
                      onPressed: onOpen,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(0, 48),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        backgroundColor: palette.primary,
                        foregroundColor: palette.onPrimary,
                        shape: const StadiumBorder(),
                        textStyle: CulinaryEditorialType.body(
                          palette,
                          size: 13,
                          weight: FontWeight.w700,
                          color: palette.onPrimary,
                        ),
                      ),
                      iconAlignment: IconAlignment.end,
                      icon: const Icon(Icons.play_arrow_rounded, size: 18),
                      label: Text(S.of(context).category_start),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  recipe.name,
                  key: const Key('category-featured-title'),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style:
                      CulinaryEditorialType.headline(
                        palette,
                        size: wide ? 25 : 20,
                        weight: FontWeight.w700,
                        height: 1.14,
                      ).copyWith(
                        color: const Color(0xFFFFF9F4),
                        shadows: const [
                          Shadow(
                            color: Color(0x66000000),
                            offset: Offset(0, 1),
                            blurRadius: 3,
                          ),
                        ],
                      ),
                ),
                if (tags.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 5,
                    children: [
                      for (final tag in tags)
                        _FeaturedTagChip(label: '#${tag.text}'),
                      if (recipe.tags.length > tags.length)
                        _FeaturedTagChip(
                          label: '+${recipe.tags.length - tags.length}',
                        ),
                    ],
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

class _CollapsedFeaturedRecipe extends StatelessWidget {
  const _CollapsedFeaturedRecipe({
    required this.recipe,
    required this.onExpand,
    super.key,
  });

  final Recipe recipe;
  final VoidCallback onExpand;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Semantics(
      button: true,
      label: S.of(context).expand_dish_of_the_day,
      excludeSemantics: true,
      child: Material(
        key: const Key('category-featured-collapsed-card'),
        color: palette.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        elevation: 1,
        shadowColor: palette.shadow,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onExpand,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 56),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 7, 4, 7),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox.square(
                      dimension: 40,
                      child: _RecipeImage(path: recipe.imagePreviewPath),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).dish_of_the_day.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: CulinaryEditorialType.body(
                            palette,
                            size: 10,
                            weight: FontWeight.w700,
                            color: palette.primary,
                            letterSpacing: .55,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          recipe.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: CulinaryEditorialType.headline(
                            palette,
                            size: 14,
                            weight: FontWeight.w600,
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  _FeaturedTimeBadge(
                    key: const Key('category-featured-collapsed-time'),
                    recipe: recipe,
                    compact: true,
                  ),
                  _FeaturedExpandControl(onPressed: onExpand),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FeaturedTimeBadge extends StatelessWidget {
  const _FeaturedTimeBadge({
    required this.recipe,
    this.dark = false,
    this.compact = false,
    super.key,
  });

  final Recipe recipe;
  final bool dark;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final foreground = dark
        ? const Color(0xFFFCEFEA)
        : palette.onSurfaceVariant;
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: compact ? 92 : double.infinity),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: dark ? const Color(0xA64B3A34) : palette.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(999),
          border: dark ? Border.all(color: const Color(0x2EFFF7F2)) : null,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.schedule_rounded, size: 14, color: palette.primary),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  compact
                      ? _collapsedTimeLabel(context, recipe)
                      : _featuredTimeLabel(context, recipe),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: CulinaryEditorialType.body(
                    palette,
                    size: 11,
                    weight: FontWeight.w600,
                    color: foreground,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeaturedOverlayAction extends StatelessWidget {
  const _FeaturedOverlayAction({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
    this.label,
    super.key,
  });

  final String tooltip;
  final IconData icon;
  final String? label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final button = label == null
        ? IconButton(
            onPressed: onPressed,
            style: IconButton.styleFrom(
              minimumSize: const Size.square(48),
              foregroundColor: const Color(0xFFFCEFEA),
              backgroundColor: const Color(0xA64B3A34),
              shape: const CircleBorder(),
              side: const BorderSide(color: Color(0x2EFFF7F2)),
            ),
            icon: Icon(icon, size: 19),
          )
        : TextButton.icon(
            onPressed: onPressed,
            style: TextButton.styleFrom(
              minimumSize: const Size(48, 48),
              padding: const EdgeInsets.symmetric(horizontal: 13),
              foregroundColor: const Color(0xFFFCEFEA),
              backgroundColor: const Color(0xA64B3A34),
              shape: const StadiumBorder(),
              side: const BorderSide(color: Color(0x2EFFF7F2)),
              textStyle: CulinaryEditorialType.body(
                palette,
                size: 11,
                weight: FontWeight.w600,
                color: const Color(0xFFFCEFEA),
              ),
            ),
            icon: Icon(icon, size: 19),
            label: Text(label!),
          );
    return Semantics(
      button: true,
      label: tooltip,
      excludeSemantics: true,
      child: Tooltip(
        message: tooltip,
        child: SizedBox(height: 48, child: button),
      ),
    );
  }
}

class _FeaturedExpandControl extends StatelessWidget {
  const _FeaturedExpandControl({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return SizedBox.square(
      dimension: 48,
      child: IconButton(
        key: const Key('category-featured-expand'),
        tooltip: S.of(context).expand_dish_of_the_day,
        onPressed: onPressed,
        icon: Icon(
          Icons.expand_more_rounded,
          size: 22,
          color: palette.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _FeaturedEffortChip extends StatelessWidget {
  const _FeaturedEffortChip({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final color = _effortColor(palette, recipe.effort);
    final foreground =
        ThemeData.estimateBrightnessForColor(color) == Brightness.dark
        ? const Color(0xFFFFF9F4)
        : const Color(0xFF2A1711);
    return _FeaturedMetadataChip(
      key: const Key('category-featured-effort'),
      icon: _effortIcon(recipe.effort),
      label: recipe.effort == null
          ? S.of(context).category_effort_not_set
          : S.of(context).category_effort_value(recipe.effort!),
      foreground: foreground,
      background: color.withAlpha(230),
    );
  }
}

class _FeaturedDietChip extends StatelessWidget {
  const _FeaturedDietChip({required this.vegetable});

  final Vegetable vegetable;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final (icon, label) = switch (vegetable) {
      Vegetable.VEGAN => (Icons.eco_rounded, S.of(context).vegan),
      Vegetable.VEGETARIAN => (Icons.spa_rounded, S.of(context).vegetarian),
      Vegetable.NON_VEGETARIAN => (
        Icons.restaurant_rounded,
        S.of(context).with_meat,
      ),
    };
    return _FeaturedMetadataChip(
      icon: icon,
      label: label,
      foreground: const Color(0xFFFCEFEA),
      background: const Color(0x3DFFF7F2),
      iconColor: vegetable == Vegetable.NON_VEGETARIAN
          ? palette.primary
          : palette.secondarySoft,
    );
  }
}

class _FeaturedTagChip extends StatelessWidget {
  const _FeaturedTagChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return _FeaturedMetadataChip(
      label: label,
      foreground: const Color(0xFFFCEFEA),
      background: const Color(0x2EFFF7F2),
    );
  }
}

class _FeaturedMetadataChip extends StatelessWidget {
  const _FeaturedMetadataChip({
    required this.label,
    required this.foreground,
    required this.background,
    this.icon,
    this.iconColor,
    super.key,
  });

  final String label;
  final Color foreground;
  final Color background;
  final IconData? icon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 13, color: iconColor ?? foreground),
              const SizedBox(width: 4),
            ],
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: CulinaryEditorialType.body(
                  palette,
                  size: 10,
                  weight: FontWeight.w700,
                  color: foreground,
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

class _CategorySection extends StatelessWidget {
  const _CategorySection({
    required this.section,
    required this.sectionIndex,
    required this.listHeight,
    this.horizontalInset = 0,
    required this.onOpenRecipe,
    required this.onToggleFavorite,
    required this.onOpenCategory,
  });

  final Tuple2<String, List<Recipe>> section;
  final int sectionIndex;
  final double listHeight;
  final double horizontalInset;
  final OpenOverviewRecipe onOpenRecipe;
  final ToggleOverviewFavorite onToggleFavorite;
  final OpenOverviewCategory onOpenCategory;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final category = section.item1;
    final recipes = section.item2;
    final title = category == constants.noCategory
        ? S.of(context).no_category
        : category;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalInset),
          child: SizedBox(
            height: 48,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.restaurant_menu_rounded,
                  size: 21,
                  color: palette.primary,
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: CulinaryEditorialType.headline(
                      palette,
                      size: 20,
                      weight: FontWeight.w600,
                      height: 1.12,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  key: ValueKey('category-see-all-$category'),
                  onPressed: () => onOpenCategory(category),
                  style: TextButton.styleFrom(
                    minimumSize: const Size(48, 48),
                    foregroundColor: palette.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    textStyle: CulinaryEditorialType.body(
                      palette,
                      size: 12,
                      weight: FontWeight.w700,
                      color: palette.primary,
                    ),
                  ),
                  child: Text(S.of(context).category_see_all(recipes.length)),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: listHeight,
          child: recipes.isEmpty
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalInset),
                  child: _EmptyCategory(palette: palette),
                )
              : LayoutBuilder(
                  builder: (context, constraints) {
                    final cardWidth = math.min(192.0, constraints.maxWidth);
                    return ListView.separated(
                      key: PageStorageKey('category-row-$category'),
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalInset,
                      ),
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: recipes.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final recipe = recipes[index];
                        final heroTag =
                            'category-feed-$sectionIndex-$index-${recipe.name}';
                        return SizedBox(
                          key: ValueKey('category-card-$sectionIndex-$index'),
                          width: cardWidth,
                          child: EditorialRecipeCard(
                            recipe: recipe,
                            heroImageTag: heroTag,
                            layout: RecipeOverviewCardLayout.grid,
                            onOpen: () => onOpenRecipe(recipe, heroTag),
                            onBookmarkToggle: () => onToggleFavorite(recipe),
                            onCookAction: () => onOpenRecipe(recipe, heroTag),
                          ),
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _LightBadge extends StatelessWidget {
  const _LightBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.surface.withAlpha(244),
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
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
        child: Text(
          label,
          style: CulinaryEditorialType.body(
            palette,
            size: 10,
            weight: FontWeight.w700,
            color: color,
            letterSpacing: .5,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _RecipeImage extends StatelessWidget {
  const _RecipeImage({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    final image = path == constants.noRecipeImage
        ? Image.asset(
            constants.noRecipeImage,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          )
        : Image.file(
            File(path),
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
    return ExcludeSemantics(child: image);
  }
}

class _EmptyLibrary extends StatelessWidget {
  const _EmptyLibrary({required this.palette, required this.horizontalPadding});

  final CulinaryEditorialPalette palette;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: palette.primarySoft,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Icon(
                          Icons.menu_book_rounded,
                          size: 38,
                          color: palette.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      S.of(context).category_overview_empty_title,
                      textAlign: TextAlign.center,
                      style: CulinaryEditorialType.headline(
                        palette,
                        size: 25,
                        weight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Text(
                      S.of(context).category_overview_empty_description,
                      textAlign: TextAlign.center,
                      style: CulinaryEditorialType.body(
                        palette,
                        size: 14,
                        color: palette.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyCategory extends StatelessWidget {
  const _EmptyCategory({required this.palette});

  final CulinaryEditorialPalette palette;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 240, minHeight: 92),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: palette.surfaceContainer,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.add_photo_alternate_outlined,
                  color: palette.outline,
                ),
                const SizedBox(width: 11),
                Flexible(
                  child: Text(
                    S.of(context).category_section_empty,
                    style: CulinaryEditorialType.body(
                      palette,
                      size: 13,
                      color: palette.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SkeletonSection extends StatelessWidget {
  const _SkeletonSection({required this.palette});

  final CulinaryEditorialPalette palette;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SkeletonBox(
          height: 24,
          width: 220,
          radius: 8,
          color: palette.surfaceContainer,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _SkeletonBox(
                height: 290,
                radius: 14,
                color: palette.surfaceContainer,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _SkeletonBox(
                height: 290,
                radius: 14,
                color: palette.surfaceContainer,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({
    required this.height,
    required this.radius,
    required this.color,
    this.width,
    super.key,
  });

  final double height;
  final double? width;
  final double radius;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

String _compactCategoryTime(double minutes) =>
    getTimeHoursMinutes(minutes)
        .replaceAll(' min', 'm')
        .replaceAll('h ', 'h')
        .trim();

String _featuredTimeLabel(BuildContext context, Recipe recipe) {
  final values = <String>[];
  if (recipe.preperationTime > 0) {
    values.add(
      S
          .of(context)
          .category_prep_value(_compactCategoryTime(recipe.preperationTime)),
    );
  }
  if (recipe.cookingTime > 0) {
    values.add(
      S
          .of(context)
          .category_cook_value(_compactCategoryTime(recipe.cookingTime)),
    );
  }
  if (values.isNotEmpty) return values.join(' • ');
  if (recipe.totalTime > 0) {
    return S
        .of(context)
        .category_total_value(_compactCategoryTime(recipe.totalTime));
  }
  return S.of(context).recipe_card_time_unknown;
}

String _collapsedTimeLabel(BuildContext context, Recipe recipe) {
  if (recipe.totalTime > 0) return _compactCategoryTime(recipe.totalTime);
  if (recipe.cookingTime > 0) return _compactCategoryTime(recipe.cookingTime);
  if (recipe.preperationTime > 0) {
    return _compactCategoryTime(recipe.preperationTime);
  }
  return S.of(context).recipe_card_time_unknown;
}

IconData _effortIcon(int? effort) {
  if (effort == null) return Icons.help_outline_rounded;
  if (effort <= 3) return Icons.eco_rounded;
  if (effort <= 7) return Icons.tune_rounded;
  return Icons.local_fire_department_rounded;
}

Color _effortColor(CulinaryEditorialPalette palette, int? effort) {
  if (effort == null) return palette.outline;
  if (effort <= 3) return palette.secondary;
  if (effort <= 7) return palette.tertiary;
  return palette.primary;
}
