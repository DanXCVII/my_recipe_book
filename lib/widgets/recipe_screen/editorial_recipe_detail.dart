import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../ad_related/ad.dart';
import '../../blocs/recipe_calendar/recipe_calendar_bloc.dart';
import '../../blocs/recipe_manager/recipe_manager_bloc.dart';
import '../../blocs/shopping_cart/shopping_cart_bloc.dart';
import '../../constants/global_constants.dart' as constants;
import '../../constants/global_settings.dart';
import '../../constants/routes.dart';
import '../../generated/l10n.dart';
import '../../local_storage/local_paths.dart';
import '../../local_storage/local_repository.dart';
import '../../models/enums.dart';
import '../../models/nutrition.dart';
import '../../models/recipe.dart';
import '../../models/string_int_tuple.dart';
import '../../screens/recipe_overview.dart';
import '../../util/helper.dart';
import '../animated_stepper.dart';
import '../culinary_editorial_theme.dart';
import '../gallery_view.dart';
import '../recipe_editor/editorial_editor_shell.dart';
import 'editorial_ingredients_panel.dart';

enum RecipeDetailSection { ingredients, instructions }

class EditorialRecipeDetailBody extends StatelessWidget {
  const EditorialRecipeDetailBody({
    super.key,
    required this.recipe,
    required this.scrollController,
    required this.selectedSection,
    required this.onSectionChanged,
    this.heroImageTag,
  });

  final Recipe recipe;
  final ScrollController scrollController;
  final RecipeDetailSection selectedSection;
  final ValueChanged<RecipeDetailSection> onSectionChanged;
  final String? heroImageTag;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 600;
    final palette = CulinaryEditorialPalette.of(context);
    return CustomScrollView(
      key: const Key('recipe-detail-scroll-view'),
      controller: scrollController,
      slivers: [
        SliverToBoxAdapter(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1180),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _RecipeHero(recipe: recipe, heroImageTag: heroImageTag),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      compact ? 20 : 28,
                      24,
                      compact ? 20 : 28,
                      18,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recipe.name,
                          style: CulinaryEditorialType.headline(
                            palette,
                            size: compact ? 28 : 34,
                            weight: FontWeight.w600,
                            height: 1.16,
                          ),
                        ),
                        if (recipe.categories.isNotEmpty ||
                            recipe.tags.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          _RecipeChips(recipe: recipe),
                        ],
                        if (_hasEffortOrTime(recipe)) ...[
                          const SizedBox(height: 18),
                          _EffortAndTimeCard(recipe: recipe),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (compact)
          SliverPersistentHeader(
            pinned: true,
            delegate: _SectionHeaderDelegate(
              selectedSection: selectedSection,
              ingredientCount: _ingredientCount(recipe),
              instructionCount: recipe.steps.length,
              onChanged: onSectionChanged,
              background: palette.background,
            ),
          ),
        SliverToBoxAdapter(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1180),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  compact ? 20 : 28,
                  compact ? 14 : 4,
                  compact ? 20 : 28,
                  compact ? 120 : 48,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (compact)
                      AnimatedSwitcher(
                        duration: GlobalSettings().animationsEnabled()
                            ? const Duration(milliseconds: 220)
                            : Duration.zero,
                        switchInCurve: Curves.easeOutCubic,
                        transitionBuilder: (child, animation) => FadeTransition(
                          opacity: animation,
                          child: SizeTransition(
                            sizeFactor: animation,
                            alignment: AlignmentDirectional.topStart,
                            child: child,
                          ),
                        ),
                        child:
                            selectedSection == RecipeDetailSection.ingredients
                            ? EditorialIngredientsPanel(
                                key: const ValueKey('ingredients'),
                                recipe: recipe,
                              )
                            : _InstructionsPanel(
                                key: const ValueKey('instructions'),
                                recipe: recipe,
                              ),
                      )
                    else
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 5,
                            child: EditorialIngredientsPanel(recipe: recipe),
                          ),
                          const SizedBox(width: 28),
                          Expanded(
                            flex: 6,
                            child: _InstructionsPanel(recipe: recipe),
                          ),
                        ],
                      ),
                    if (_hasSupportingDetails(recipe)) ...[
                      const SizedBox(height: 32),
                      _SupportingDetails(recipe: recipe),
                    ],
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

class _RecipeHero extends StatelessWidget {
  const _RecipeHero({required this.recipe, this.heroImageTag});

  final Recipe recipe;
  final String? heroImageTag;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final compact = MediaQuery.sizeOf(context).width < 600;
    final heroTag = heroImageTag?.isNotEmpty == true
        ? heroImageTag!
        : 'recipe-detail-${recipe.name}';
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: compact ? 340 : 410),
      child: AspectRatio(
        aspectRatio: compact ? 4 / 3 : 16 / 7,
        child: GestureDetector(
          onTap: _isFileImage(recipe.imagePath)
              ? () => _showPictureFullView(context, heroTag)
              : null,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Hero(
                tag: GlobalSettings().animationsEnabled()
                    ? heroTag
                    : '$heroTag-static',
                child: _RecipeImage(path: recipe.imagePath),
              ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x38000000),
                      Colors.transparent,
                      Color(0xB8000000),
                    ],
                    stops: [0, .48, 1],
                  ),
                ),
              ),
              Positioned(
                top: 16,
                left: 20,
                child: _DietaryBadge(vegetable: recipe.vegetable),
              ),
              Positioned(
                top: 12,
                right: 16,
                child: _FavoriteHeroButton(recipe: recipe),
              ),
              if (recipe.categories.isNotEmpty)
                Positioned(
                  bottom: 16,
                  left: 20,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.sizeOf(context).width * .6,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xB31B1B21),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      recipe.categories.first +
                          (recipe.categories.length > 1
                              ? '  +${recipe.categories.length - 1}'
                              : ''),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: CulinaryEditorialType.body(
                        palette,
                        size: 11,
                        weight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: .6,
                      ),
                    ),
                  ),
                ),
              if (recipe.rating != null)
                Positioned(
                  bottom: 16,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xA61B1B21),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, size: 16, color: palette.tertiarySoft),
                        const SizedBox(width: 4),
                        Text(
                          '${recipe.rating}/5',
                          style: CulinaryEditorialType.body(
                            palette,
                            size: 12,
                            weight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPictureFullView(BuildContext context, String heroTag) {
    Ads.showBottomBannerAd();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Ads().getAdPage(
          GalleryPhotoView(
            initialIndex: 0,
            galleryImagePaths: [recipe.imagePath],
            descriptions: const [''],
            heroTags: [heroTag],
          ),
          context,
        ),
      ),
    ).then((_) => Ads.hideBottomBannerAd());
  }
}

class _RecipeImage extends StatelessWidget {
  const _RecipeImage({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    if (!_isFileImage(path)) {
      return Image.asset(path, fit: BoxFit.cover);
    }
    return Image.file(
      File(path),
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) =>
          Image.asset(constants.noRecipeImage, fit: BoxFit.cover),
    );
  }
}

class _FavoriteHeroButton extends StatefulWidget {
  const _FavoriteHeroButton({required this.recipe});

  final Recipe recipe;

  @override
  State<_FavoriteHeroButton> createState() => _FavoriteHeroButtonState();
}

class _FavoriteHeroButtonState extends State<_FavoriteHeroButton> {
  late bool _favorite;

  @override
  void initState() {
    super.initState();
    _favorite = context.read<LocalRepository>().isRecipeFavorite(
      widget.recipe.name,
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Material(
      color: palette.surface.withValues(alpha: .92),
      elevation: 3,
      shadowColor: palette.shadow,
      shape: const CircleBorder(),
      child: IconButton(
        key: const Key('recipe-favorite-button'),
        tooltip: _favorite
            ? S.of(context).remove_from_favorites
            : S.of(context).add_to_favorites,
        onPressed: () {
          setState(() => _favorite = !_favorite);
          context.read<RecipeManagerBloc>().add(
            _favorite
                ? RMAddFavorite(widget.recipe)
                : RMRemoveFavorite(widget.recipe),
          );
        },
        icon: Icon(
          _favorite ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
          color: palette.primary,
        ),
      ),
    );
  }
}

class _DietaryBadge extends StatelessWidget {
  const _DietaryBadge({required this.vegetable});

  final Vegetable vegetable;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final vegetarian = vegetable != Vegetable.NON_VEGETARIAN;
    final label = switch (vegetable) {
      Vegetable.NON_VEGETARIAN => S.of(context).diet_meat,
      Vegetable.VEGETARIAN => S.of(context).diet_vegetarian,
      Vegetable.VEGAN => S.of(context).diet_vegan,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: vegetarian ? palette.secondary : palette.primary,
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: palette.shadow,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            vegetarian ? Icons.eco_outlined : Icons.restaurant_outlined,
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            label.toUpperCase(),
            style: CulinaryEditorialType.body(
              palette,
              size: 10,
              weight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: .7,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecipeChips extends StatelessWidget {
  const _RecipeChips({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...recipe.categories.map(
          (category) => ActionChip(
            avatar: const Icon(Icons.dinner_dining_outlined, size: 16),
            label: Text(category),
            onPressed: () => _openCategory(context, category),
            backgroundColor: palette.primarySoft,
            side: BorderSide.none,
            labelStyle: CulinaryEditorialType.body(
              palette,
              size: 12,
              weight: FontWeight.w700,
            ),
          ),
        ),
        ...recipe.tags.map(
          (tag) => ActionChip(
            avatar: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Color(tag.number),
                shape: BoxShape.circle,
              ),
            ),
            label: Text('#${tag.text}'),
            onPressed: () => _openTag(context, tag),
            backgroundColor: palette.surfaceContainer,
            side: BorderSide.none,
            labelStyle: CulinaryEditorialType.body(
              palette,
              size: 12,
              weight: FontWeight.w600,
              color: palette.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  void _openCategory(BuildContext context, String category) {
    Navigator.pushNamed(
      context,
      RouteNames.recipeCategories,
      arguments: RecipeGridViewArguments(
        category: category,
        shoppingCartBloc: context.read<ShoppingCartBloc>(),
        recipeCalendarBloc: context.read<RecipeCalendarBloc>(),
      ),
    );
  }

  void _openTag(BuildContext context, StringIntTuple tag) {
    Navigator.pushNamed(
      context,
      RouteNames.recipeTagOverview,
      arguments: RecipeGridViewArguments(
        recipeTag: tag,
        shoppingCartBloc: context.read<ShoppingCartBloc>(),
        recipeCalendarBloc: context.read<RecipeCalendarBloc>(),
      ),
    );
  }
}

class _EffortAndTimeCard extends StatelessWidget {
  const _EffortAndTimeCard({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final times = _timeMetrics(context, recipe);
    return EditorialCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (recipe.effort != null) ...[
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: palette.primarySoft,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.local_fire_department_outlined,
                    color: palette.primary,
                    size: 21,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    S.of(context).effort_calibration,
                    style: CulinaryEditorialType.headline(
                      palette,
                      size: 18,
                      weight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: _effortColor(palette, recipe.effort!),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${recipe.effort}/10',
                    style: CulinaryEditorialType.body(
                      palette,
                      size: 13,
                      weight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: List.generate(
                10,
                (index) => Expanded(
                  child: Container(
                    height: 7,
                    margin: EdgeInsets.only(right: index == 9 ? 0 : 4),
                    decoration: BoxDecoration(
                      color: index < recipe.effort!
                          ? _segmentColor(palette, index + 1)
                          : palette.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              ),
            ),
          ],
          if (recipe.effort != null && times.isNotEmpty)
            const SizedBox(height: 14),
          if (times.isNotEmpty)
            LayoutBuilder(
              builder: (context, constraints) {
                final tileWidth =
                    (constraints.maxWidth - (times.length - 1) * 8) /
                    times.length;
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: times
                      .map(
                        (metric) => SizedBox(
                          width: tileWidth,
                          child: _TimeMetricTile(metric: metric),
                        ),
                      )
                      .toList(),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _TimeMetric {
  const _TimeMetric(this.label, this.value, this.icon, {this.primary = false});

  final String label;
  final String value;
  final IconData icon;
  final bool primary;
}

class _TimeMetricTile extends StatelessWidget {
  const _TimeMetricTile({required this.metric});

  final _TimeMetric metric;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Container(
      constraints: const BoxConstraints(minHeight: 72),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: metric.primary ? palette.primarySoft : palette.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(metric.icon, size: 15, color: palette.onSurfaceVariant),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  metric.label,
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
          const SizedBox(height: 5),
          Text(
            metric.value,
            style: CulinaryEditorialType.body(
              palette,
              size: 14,
              weight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeaderDelegate extends SliverPersistentHeaderDelegate {
  _SectionHeaderDelegate({
    required this.selectedSection,
    required this.ingredientCount,
    required this.instructionCount,
    required this.onChanged,
    required this.background,
  });

  final RecipeDetailSection selectedSection;
  final int ingredientCount;
  final int instructionCount;
  final ValueChanged<RecipeDetailSection> onChanged;
  final Color background;

  @override
  double get minExtent => 66;

  @override
  double get maxExtent => 66;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final palette = CulinaryEditorialPalette.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background.withValues(alpha: .97),
        boxShadow: overlapsContent
            ? [
                BoxShadow(
                  color: palette.shadow,
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 9, 20, 9),
        child: SegmentedButton<RecipeDetailSection>(
          key: const Key('recipe-detail-section-tabs'),
          segments: [
            ButtonSegment(
              value: RecipeDetailSection.ingredients,
              icon: const Icon(Icons.tune, size: 18),
              label: Text('${S.of(context).ingredients} ($ingredientCount)'),
            ),
            ButtonSegment(
              value: RecipeDetailSection.instructions,
              icon: const Icon(Icons.format_list_numbered, size: 18),
              label: Text('${S.of(context).directions} ($instructionCount)'),
            ),
          ],
          selected: {selectedSection},
          onSelectionChanged: (selection) => onChanged(selection.first),
          showSelectedIcon: false,
          style: SegmentedButton.styleFrom(
            minimumSize: const Size(0, 48),
            selectedBackgroundColor: palette.primary,
            selectedForegroundColor: palette.onPrimary,
            backgroundColor: palette.surfaceContainer,
            foregroundColor: palette.onSurfaceVariant,
            side: BorderSide.none,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
            textStyle: CulinaryEditorialType.body(
              palette,
              size: 11,
              weight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _SectionHeaderDelegate oldDelegate) {
    return selectedSection != oldDelegate.selectedSection ||
        ingredientCount != oldDelegate.ingredientCount ||
        instructionCount != oldDelegate.instructionCount ||
        background != oldDelegate.background;
  }
}

class _InstructionsPanel extends StatelessWidget {
  const _InstructionsPanel({super.key, required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).preparation_timeline,
          style: CulinaryEditorialType.headline(
            palette,
            size: 20,
            weight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          S.of(context).instruction_count(recipe.steps.length),
          style: CulinaryEditorialType.body(
            palette,
            size: 12,
            color: palette.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        if (recipe.steps.isNotEmpty && GlobalSettings().showStepsIntro()) ...[
          const _StepsIntro(),
          const SizedBox(height: 12),
        ],
        if (recipe.steps.isEmpty)
          AnimatedStepper(
            recipe.steps,
            recipe.stepTitles,
            stepImages: recipe.stepImages,
            ingredients: recipe.ingredients,
            stepIngredientIds: recipe.stepIngredientIds,
          )
        else
          FutureBuilder<List<List<String>>>(
            future: PathProvider.pP.getRecipeStepPreviewPathList(
              recipe.stepImages,
              recipe.name,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return AnimatedStepper(
                recipe.steps,
                recipe.stepTitles,
                stepImages: recipe.stepImages,
                lowResStepImages: snapshot.data,
                ingredients: recipe.ingredients,
                stepIngredientIds: recipe.stepIngredientIds,
              );
            },
          ),
      ],
    );
  }
}

class _StepsIntro extends StatefulWidget {
  const _StepsIntro();

  @override
  State<_StepsIntro> createState() => _StepsIntroState();
}

class _StepsIntroState extends State<_StepsIntro> {
  var _visible = true;

  @override
  Widget build(BuildContext context) {
    if (!_visible) return const SizedBox.shrink();
    final palette = CulinaryEditorialPalette.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 6, 10),
      decoration: BoxDecoration(
        color: palette.secondarySoft,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.touch_app_outlined, color: palette.secondary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              S.of(context).steps_intro,
              style: CulinaryEditorialType.body(palette, size: 12),
            ),
          ),
          IconButton(
            tooltip: S.of(context).dismiss,
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('showStepsIntro', false);
              GlobalSettings().hasSeenStepIntro(true);
              if (mounted) setState(() => _visible = false);
            },
            icon: const Icon(Icons.close, size: 20),
          ),
        ],
      ),
    );
  }
}

class _SupportingDetails extends StatelessWidget {
  const _SupportingDetails({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          S.of(context).recipe_details,
          style: CulinaryEditorialType.headline(
            palette,
            size: 22,
            weight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        if (recipe.notes.trim().isNotEmpty) ...[
          _DetailCard(
            icon: Icons.sticky_note_2_outlined,
            title: S.of(context).notes,
            child: Text(
              recipe.notes,
              style: CulinaryEditorialType.body(
                palette,
                size: 14,
                color: palette.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
        if (recipe.source?.trim().isNotEmpty == true) ...[
          _DetailCard(
            icon: Icons.link,
            title: S.of(context).source,
            child: InkWell(
              onTap: () => _openSource(context, recipe.source!),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        recipe.source!,
                        style:
                            CulinaryEditorialType.body(
                              palette,
                              size: 13,
                              weight: FontWeight.w600,
                              color: palette.primary,
                            ).copyWith(
                              decoration: TextDecoration.underline,
                              decorationColor: palette.primary,
                            ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.open_in_new, size: 18, color: palette.primary),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
        if (recipe.nutritions.isNotEmpty)
          _DetailCard(
            icon: Icons.monitor_heart_outlined,
            title: S.of(context).nutritions,
            child: _NutritionRows(nutritions: recipe.nutritions),
          ),
      ],
    );
  }

  Future<void> _openSource(BuildContext context, String source) async {
    final uri = Uri.tryParse(source);
    if (uri == null || !await launchUrl(uri)) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).source_could_not_open)),
      );
    }
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({
    required this.icon,
    required this.title,
    required this.child,
  });

  final IconData icon;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return EditorialCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: palette.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: CulinaryEditorialType.headline(
                  palette,
                  size: 18,
                  weight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _NutritionRows extends StatelessWidget {
  const _NutritionRows({required this.nutritions});

  final List<Nutrition> nutritions;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Column(
      children: List.generate(
        nutritions.length,
        (index) => Container(
          margin: EdgeInsets.only(
            bottom: index == nutritions.length - 1 ? 0 : 7,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: palette.surfaceContainer,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  nutritions[index].name,
                  style: CulinaryEditorialType.body(palette, size: 13),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                nutritions[index].amountUnit,
                style: CulinaryEditorialType.body(
                  palette,
                  size: 13,
                  weight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<_TimeMetric> _timeMetrics(BuildContext context, Recipe recipe) {
  final metrics = <_TimeMetric>[];
  if (recipe.preperationTime > 0) {
    metrics.add(
      _TimeMetric(
        S.of(context).prep_time,
        getTimeHoursMinutes(recipe.preperationTime),
        Icons.restaurant_outlined,
      ),
    );
  }
  if (recipe.cookingTime > 0) {
    metrics.add(
      _TimeMetric(
        S.of(context).cook_time,
        getTimeHoursMinutes(recipe.cookingTime),
        Icons.soup_kitchen_outlined,
      ),
    );
  }
  final remaining =
      recipe.totalTime - recipe.preperationTime - recipe.cookingTime;
  if (remaining > 0) {
    metrics.add(
      _TimeMetric(
        S.of(context).remaining_time,
        getTimeHoursMinutes(remaining),
        Icons.hourglass_bottom_outlined,
      ),
    );
  }
  if (recipe.totalTime > 0) {
    metrics.add(
      _TimeMetric(
        S.of(context).total_time,
        getTimeHoursMinutes(recipe.totalTime),
        Icons.schedule_outlined,
        primary: true,
      ),
    );
  }
  return metrics;
}

Color _effortColor(CulinaryEditorialPalette palette, int effort) {
  if (effort <= 3) return palette.secondary;
  if (effort <= 7) return palette.tertiary;
  return palette.primary;
}

Color _segmentColor(CulinaryEditorialPalette palette, int segment) {
  if (segment <= 3) return palette.secondary;
  if (segment <= 7) return palette.tertiary;
  return palette.primary;
}

bool _hasEffortOrTime(Recipe recipe) =>
    recipe.effort != null ||
    recipe.preperationTime > 0 ||
    recipe.cookingTime > 0 ||
    recipe.totalTime > 0;

bool _hasSupportingDetails(Recipe recipe) =>
    recipe.notes.trim().isNotEmpty ||
    recipe.source?.trim().isNotEmpty == true ||
    recipe.nutritions.isNotEmpty;

int _ingredientCount(Recipe recipe) =>
    recipe.ingredients.fold<int>(0, (count, section) => count + section.length);

bool _isFileImage(String path) =>
    path != constants.noRecipeImage &&
    !path.startsWith('images/') &&
    !path.startsWith('assets/');
