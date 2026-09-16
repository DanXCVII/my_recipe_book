import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../constants/global_constants.dart' as constants;
import '../../generated/l10n.dart';
import '../../models/enums.dart';
import '../../models/recipe.dart';
import '../../models/tuple.dart';
import '../../util/helper.dart';
import '../culinary_editorial_theme.dart';

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
        final cardListHeight = _cardListHeight(context);
        final navigationClearance =
            constraints.maxWidth <= constants.sideBarWidth
            ? MediaQuery.paddingOf(context).bottom
            : 0.0;

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

  double _cardListHeight(BuildContext context) {
    final scaled = MediaQuery.textScalerOf(context).scale(16) / 16;
    return 240 + ((scaled - 1).clamp(0, .6) * 108);
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

class _FeaturedRecipeCard extends StatelessWidget {
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

  String get _heroTag => 'category-feed-featured-${recipe.name}';

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final radius = BorderRadius.circular(16);
    final image = _FeaturedImage(
      recipe: recipe,
      heroTag: _heroTag,
      onOpen: () => onOpen(recipe, _heroTag),
      onToggleFavorite: () => onToggleFavorite(recipe),
    );
    final details = _FeaturedDetails(
      recipe: recipe,
      wide: wide,
      onOpen: () => onOpen(recipe, _heroTag),
    );

    return Semantics(
      container: true,
      label: '${S.of(context).dish_of_the_day}: ${recipe.name}',
      child: SizedBox(
        width: double.infinity,
        child: Material(
          key: const Key('category-featured-card'),
          color: palette.surface,
          borderRadius: radius,
          clipBehavior: Clip.antiAlias,
          elevation: 2,
          shadowColor: palette.shadow,
          child: wide
              ? SizedBox(
                  height: 370,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(flex: 6, child: image),
                      Expanded(flex: 4, child: details),
                    ],
                  ),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 264, child: image),
                    details,
                  ],
                ),
        ),
      ),
    );
  }
}

class _FeaturedImage extends StatelessWidget {
  const _FeaturedImage({
    required this.recipe,
    required this.heroTag,
    required this.onOpen,
    required this.onToggleFavorite,
  });

  final Recipe recipe;
  final String heroTag;
  final VoidCallback onOpen;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Stack(
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
              stops: [0, .5, 1],
              colors: [Color(0x08000000), Color(0x18000000), Color(0xD6000000)],
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
          left: 16,
          top: 16,
          child: _LightBadge(
            label: S.of(context).dish_of_the_day.toUpperCase(),
            color: palette.primary,
          ),
        ),
        Positioned(
          right: 10,
          top: 8,
          child: _FavoriteButton(
            recipe: recipe,
            onPressed: onToggleFavorite,
            prominent: true,
            controlKey: ValueKey('category-featured-favorite-${recipe.name}'),
          ),
        ),
        Positioned(
          left: 17,
          right: 17,
          bottom: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _categoryLine(context, recipe),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: CulinaryEditorialType.body(
                  palette,
                  size: 11,
                  weight: FontWeight.w700,
                  color: const Color(0xFFFFE4DB),
                  letterSpacing: .7,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                recipe.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style:
                    CulinaryEditorialType.headline(
                      palette,
                      size: 27,
                      weight: FontWeight.w600,
                      height: 1.16,
                    ).copyWith(
                      color: const Color(0xFFFFF9F4),
                      shadows: const [
                        Shadow(
                          color: Color(0x66000000),
                          offset: Offset(0, 1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FeaturedDetails extends StatelessWidget {
  const _FeaturedDetails({
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
    final tags = recipe.tags.take(wide ? 3 : 1).toList(growable: false);
    final metadata = <Widget>[];

    void addMetadata({
      required Key key,
      required String label,
      Color? color,
      FontWeight weight = FontWeight.w600,
    }) {
      metadata.add(
        Text(
          metadata.isEmpty ? label : '· $label',
          key: key,
          style: CulinaryEditorialType.body(
            palette,
            size: 10,
            weight: weight,
            color: color ?? palette.onSurfaceVariant,
          ),
        ),
      );
    }

    addMetadata(
      key: const Key('category-featured-effort'),
      label: recipe.effort == null
          ? S.of(context).category_effort_not_set
          : S.of(context).category_effort_value(recipe.effort!),
      color: _effortColor(palette, recipe.effort),
      weight: FontWeight.w700,
    );
    if (recipe.preperationTime > 0) {
      addMetadata(
        key: const Key('category-featured-prep'),
        label: S
            .of(context)
            .category_prep_value(_compactCategoryTime(recipe.preperationTime)),
      );
    }
    if (recipe.cookingTime > 0) {
      addMetadata(
        key: const Key('category-featured-cook'),
        label: S
            .of(context)
            .category_cook_value(_compactCategoryTime(recipe.cookingTime)),
      );
    }
    if (recipe.preperationTime <= 0 &&
        recipe.cookingTime <= 0 &&
        recipe.totalTime > 0) {
      addMetadata(
        key: const Key('category-featured-total'),
        label: S
            .of(context)
            .category_total_value(_compactCategoryTime(recipe.totalTime)),
      );
    }

    return Padding(
      padding: wide
          ? const EdgeInsets.fromLTRB(18, 18, 18, 20)
          : const EdgeInsets.all(14),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            key: const Key('category-featured-metadata'),
            spacing: 0,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: metadata,
          ),
          const SizedBox(height: 12),
          Wrap(
            key: const Key('category-featured-actions'),
            spacing: 7,
            runSpacing: 7,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _DietChip(vegetable: recipe.vegetable, compact: !wide),
              for (final tag in tags)
                _TagChip(label: '#${tag.text}', compact: !wide),
              if (recipe.tags.length > tags.length)
                _TagChip(
                  label: '+${recipe.tags.length - tags.length}',
                  compact: !wide,
                ),
              Semantics(
                button: true,
                label: S.of(context).open_recipe,
                excludeSemantics: true,
                child: Tooltip(
                  message: S.of(context).open_recipe,
                  child: FilledButton.icon(
                    key: const Key('category-featured-open'),
                    onPressed: onOpen,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(0, 48),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
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
                    iconAlignment: IconAlignment.end,
                    icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                    label: Text(S.of(context).category_open),
                  ),
                ),
              ),
            ],
          ),
        ],
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
                    final cardWidth = math.min(200.0, constraints.maxWidth);
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
                          width: cardWidth,
                          child: _CompactRecipeCard(
                            key: ValueKey('category-card-$sectionIndex-$index'),
                            recipe: recipe,
                            heroTag: heroTag,
                            onOpen: () => onOpenRecipe(recipe, heroTag),
                            onToggleFavorite: () => onToggleFavorite(recipe),
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

class _CompactRecipeCard extends StatelessWidget {
  const _CompactRecipeCard({
    required this.recipe,
    required this.heroTag,
    required this.onOpen,
    required this.onToggleFavorite,
    super.key,
  });

  final Recipe recipe;
  final String heroTag;
  final VoidCallback onOpen;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final radius = BorderRadius.circular(14);
    final hasPreparationTime = recipe.preperationTime > 0;
    final hasCookingTime = recipe.cookingTime > 0;
    final tags = recipe.tags.take(2).toList(growable: false);

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
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  key: ValueKey('category-card-image-$heroTag'),
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    height: 116,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Hero(
                          tag: heroTag,
                          child: Material(
                            color: palette.surfaceContainerHigh,
                            child: _RecipeImage(path: recipe.imagePreviewPath),
                          ),
                        ),
                        Positioned(
                          left: 8,
                          top: 8,
                          child: _EffortBadge(effort: recipe.effort),
                        ),
                        Positioned(
                          right: 2,
                          top: 0,
                          child: _FavoriteButton(
                            recipe: recipe,
                            onPressed: onToggleFavorite,
                            controlKey: ValueKey(
                              'category-card-favorite-$heroTag',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (hasPreparationTime || hasCookingTime) ...[
                        Row(
                          children: [
                            if (hasPreparationTime)
                              Expanded(
                                flex: 3,
                                child: _CompactTimingItem(
                                  key: ValueKey('category-card-prep-$heroTag'),
                                  icon: Icons.timer_outlined,
                                  label: S.of(context).category_prep_short,
                                  value: getTimeHoursMinutes(
                                    recipe.preperationTime,
                                  ),
                                ),
                              ),
                            if (hasPreparationTime && hasCookingTime)
                              const SizedBox(width: 6),
                            if (hasCookingTime)
                              Expanded(
                                flex: 2,
                                child: _CompactTimingItem(
                                  key: ValueKey('category-card-cook-$heroTag'),
                                  icon: Icons.soup_kitchen_outlined,
                                  label: S.of(context).category_cook_short,
                                  value: getTimeHoursMinutes(
                                    recipe.cookingTime,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 5),
                      ],
                      Text(
                        recipe.name,
                        key: ValueKey('category-card-title-$heroTag'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: CulinaryEditorialType.headline(
                          palette,
                          size: 16,
                          weight: FontWeight.w600,
                          height: 1.18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 5,
                        children: [
                          _DietChip(vegetable: recipe.vegetable, compact: true),
                          for (final tag in tags)
                            _TagChip(label: '#${tag.text}', compact: true),
                          if (recipe.tags.length > tags.length)
                            _TagChip(
                              label: '+${recipe.tags.length - tags.length}',
                              compact: true,
                            ),
                        ],
                      ),
                    ],
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

class _CompactTimingItem extends StatelessWidget {
  const _CompactTimingItem({
    required this.icon,
    required this.label,
    required this.value,
    super.key,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Semantics(
      label: '$label $value',
      child: Row(
        children: [
          Icon(icon, size: 14, color: palette.outline),
          const SizedBox(width: 3),
          Expanded(
            child: Text(
              '$label $value',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: CulinaryEditorialType.body(
                palette,
                size: 10,
                weight: FontWeight.w600,
                color: palette.onSurfaceVariant,
              ),
            ),
          ),
        ],
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
    final color = _effortColor(palette, effort);
    final background = _effortBackground(palette, effort);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background.withAlpha(242),
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: palette.shadow,
            offset: const Offset(0, 2),
            blurRadius: 7,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_effortIcon(effort), size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              effort == null ? '—' : '$effort/10',
              style: CulinaryEditorialType.body(
                palette,
                size: 11,
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

class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({
    required this.recipe,
    required this.onPressed,
    this.prominent = false,
    this.controlKey,
  });

  final Recipe recipe;
  final VoidCallback onPressed;
  final bool prominent;
  final Key? controlKey;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final label = recipe.isFavorite
        ? S.of(context).remove_from_favorites
        : S.of(context).add_to_favorites;
    return Semantics(
      button: true,
      label: label,
      child: SizedBox(
        width: 48,
        height: 48,
        child: IconButton(
          key: controlKey,
          tooltip: label,
          onPressed: onPressed,
          icon: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: palette.surface.withAlpha(prominent ? 244 : 235),
              boxShadow: [
                BoxShadow(
                  color: palette.shadow,
                  offset: const Offset(0, 2),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(prominent ? 9 : 8),
              child: Icon(
                recipe.isFavorite
                    ? Icons.bookmark_rounded
                    : Icons.bookmark_border_rounded,
                size: prominent ? 22 : 19,
                color: recipe.isFavorite
                    ? palette.primary
                    : palette.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DietChip extends StatelessWidget {
  const _DietChip({required this.vegetable, this.compact = false});

  final Vegetable vegetable;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final (icon, label, color, background) = switch (vegetable) {
      Vegetable.VEGAN => (
        Icons.eco_rounded,
        S.of(context).vegan,
        palette.secondary,
        palette.secondarySoft,
      ),
      Vegetable.VEGETARIAN => (
        Icons.spa_rounded,
        S.of(context).vegetarian,
        palette.secondary,
        palette.secondarySoft,
      ),
      Vegetable.NON_VEGETARIAN => (
        Icons.restaurant_rounded,
        S.of(context).with_meat,
        palette.primary,
        palette.primarySoft,
      ),
    };
    return _MetadataChip(
      icon: icon,
      label: label,
      foreground: color,
      background: background,
      compact: compact,
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.label, this.compact = false});

  final String label;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return _MetadataChip(
      label: label,
      foreground: palette.onSurfaceVariant,
      background: palette.surfaceContainer,
      compact: compact,
    );
  }
}

class _MetadataChip extends StatelessWidget {
  const _MetadataChip({
    required this.label,
    required this.foreground,
    required this.background,
    required this.compact,
    this.icon,
  });

  final IconData? icon;
  final String label;
  final Color foreground;
  final Color background;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 6 : 10,
          vertical: compact ? 3 : 6,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: compact ? 12 : 14, color: foreground),
              const SizedBox(width: 4),
            ],
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: compact ? 94 : 150),
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: CulinaryEditorialType.body(
                  palette,
                  size: compact ? 10 : 11,
                  weight: FontWeight.w600,
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

String _categoryLine(BuildContext context, Recipe recipe) {
  final categories = recipe.categories.take(2).toList(growable: false);
  if (categories.isEmpty) return S.of(context).no_category.toUpperCase();
  return categories.join(' • ').toUpperCase();
}

String _compactCategoryTime(double minutes) =>
    getTimeHoursMinutes(minutes)
        .replaceAll(' min', 'm')
        .replaceAll('h ', 'h')
        .trim();

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

Color _effortBackground(CulinaryEditorialPalette palette, int? effort) {
  if (effort == null) return palette.surfaceContainer;
  if (effort <= 3) return palette.secondarySoft;
  if (effort <= 7) return palette.tertiarySoft;
  return palette.primarySoft;
}
