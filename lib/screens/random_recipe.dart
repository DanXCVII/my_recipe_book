import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../ad_related/ad.dart';
import '../blocs/random_recipe_explorer/random_recipe_explorer_bloc.dart';
import '../blocs/recipe_calendar/recipe_calendar_bloc.dart';
import '../blocs/recipe_manager/recipe_manager_bloc.dart';
import '../blocs/shopping_cart/shopping_cart_bloc.dart';
import '../constants/global_constants.dart' as constants;
import '../constants/global_settings.dart';
import '../constants/routes.dart';
import '../generated/l10n.dart';
import '../models/ingredient.dart';
import '../models/recipe.dart';
import '../models/string_int_tuple.dart';
import '../util/helper.dart';
import '../widgets/culinary_editorial_theme.dart';
import 'cook_mode_screen.dart';
import 'recipe_screen.dart';

class SwypingCardsScreen extends StatelessWidget {
  const SwypingCardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return ColoredBox(
      color: palette.background,
      child: SafeArea(
        bottom: false,
        child: BlocBuilder<RandomRecipeExplorerBloc, RandomRecipeExplorerState>(
          builder: (context, state) {
            if (state is LoadedRandomRecipeExplorer) {
              return _ExploreDeck(
                key: ValueKey(
                  '${state.filter.kind.name}:${state.filter.value ?? 'all'}:'
                  '${state.randomRecipes.map((recipe) => recipe.name).join('|')}:'
                  '${state.revision}',
                ),
                state: state,
              );
            }
            if (state is FailedRandomRecipeExplorer) {
              return _ExploreStatusScreen(
                state: state,
                icon: Icons.cloud_off_rounded,
                title: S.of(context).explore_error_title,
                message: S.of(context).explore_error_message,
                actionLabel: S.of(context).explore_retry,
                onAction: () => context.read<RandomRecipeExplorerBloc>().add(
                  const ReloadRandomRecipeExplorer(),
                ),
              );
            }
            return _ExploreLoadingScreen(state: state);
          },
        ),
      ),
    );
  }
}

class _ExploreDeck extends StatefulWidget {
  const _ExploreDeck({super.key, required this.state});

  final LoadedRandomRecipeExplorer state;

  @override
  State<_ExploreDeck> createState() => _ExploreDeckState();
}

class _ExploreDeckState extends State<_ExploreDeck> {
  late final CardSwiperController _controller;
  int _currentIndex = 0;
  bool _complete = false;

  List<Recipe> get _recipes => widget.state.randomRecipes;

  @override
  void initState() {
    super.initState();
    _controller = CardSwiperController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final compactNavigation = !constants.usesHomeNavigationRail(
      MediaQuery.sizeOf(context).width,
    );
    final bottomClearance = compactNavigation ? 104.0 : 24.0;
    return LayoutBuilder(
      builder: (context, viewport) => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, bottomClearance),
            child: Column(
              children: [
                _ExploreHeader(
                  current: _recipes.isEmpty
                      ? null
                      : math.min(_currentIndex + 1, _recipes.length),
                  total: _recipes.isEmpty ? null : _recipes.length,
                  filter: widget.state.filter,
                  onFilterPressed: _openFilters,
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: _recipes.isEmpty
                      ? _EmptyDeck(onChangeFilter: _openFilters)
                      : LayoutBuilder(
                          builder: (context, constraints) {
                            final deckHeight = math.min(
                              540.0,
                              math.max(0.0, constraints.maxHeight - 76),
                            );
                            final compactCard = deckHeight < 430;
                            return Column(
                              children: [
                                SizedBox(
                                  height: deckHeight,
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      IgnorePointer(
                                        ignoring: _complete,
                                        child: AnimatedOpacity(
                                          opacity: _complete ? 0 : 1,
                                          duration: _motionDuration,
                                          child: CardSwiper(
                                            key: const Key(
                                              'explore-card-swiper',
                                            ),
                                            controller: _controller,
                                            cardsCount: _recipes.length,
                                            numberOfCardsDisplayed: math.min(
                                              3,
                                              _recipes.length,
                                            ),
                                            padding: EdgeInsets.zero,
                                            backCardOffset: const Offset(0, 14),
                                            scale: .955,
                                            maxAngle: 22,
                                            threshold: 34,
                                            duration: _motionDuration,
                                            isLoop: false,
                                            allowedSwipeDirection:
                                                const AllowedSwipeDirection.only(
                                                  left: true,
                                                  right: true,
                                                  up: true,
                                                ),
                                            cardBuilder:
                                                (
                                                  context,
                                                  index,
                                                  horizontal,
                                                  vertical,
                                                ) => _ExploreRecipeCard(
                                                  recipe: _recipes[index],
                                                  horizontalDrag: horizontal,
                                                  verticalDrag: vertical,
                                                  compact: compactCard,
                                                  onOpen: () =>
                                                      _openRecipeDetail(
                                                        _recipes[index],
                                                      ),
                                                ),
                                            onSwipe: _onSwipe,
                                            onUndo: _onUndo,
                                            onEnd: () {
                                              if (mounted) {
                                                setState(
                                                  () => _complete = true,
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      if (_complete)
                                        _CompleteDeck(
                                          onRestart: () => context
                                              .read<RandomRecipeExplorerBloc>()
                                              .add(
                                                const ReloadRandomRecipeExplorer(),
                                              ),
                                        ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _ExploreActionDock(
                                  canRewind: _currentIndex > 0 || _complete,
                                  saved:
                                      !_complete &&
                                      _recipes[_currentIndex].isFavorite,
                                  onRewind: () => _controller.undo(),
                                  onPass: _complete
                                      ? null
                                      : () => _controller.swipe(
                                          CardSwiperDirection.left,
                                        ),
                                  onSave: _complete
                                      ? null
                                      : () => _controller.swipe(
                                          CardSwiperDirection.top,
                                        ),
                                  onCook: _complete
                                      ? null
                                      : () => _controller.swipe(
                                          CardSwiperDirection.right,
                                        ),
                                ),
                              ],
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Duration get _motionDuration => GlobalSettings().animationsEnabled()
      ? const Duration(milliseconds: 260)
      : const Duration(milliseconds: 1);

  bool _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
    final recipe = _recipes[previousIndex];
    if (direction == CardSwiperDirection.top && !recipe.isFavorite) {
      context.read<RecipeManagerBloc>().add(RMAddFavorite(recipe));
    }
    if (mounted) {
      setState(() {
        _currentIndex = currentIndex ?? previousIndex;
      });
    }
    if (direction == CardSwiperDirection.right) {
      Future<void>.microtask(() => _openCookDestination(recipe));
    }
    return true;
  }

  bool _onUndo(
    int? previousIndex,
    int currentIndex,
    CardSwiperDirection direction,
  ) {
    setState(() {
      _currentIndex = currentIndex;
      _complete = false;
    });
    return true;
  }

  Future<void> _openFilters() async {
    final selected = await showModalBottomSheet<ExploreFilter>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ExploreFilterSheet(
        categories: widget.state.categories,
        tags: widget.state.tags,
        selected: widget.state.filter,
      ),
    );
    if (!mounted || selected == null || selected == widget.state.filter) return;
    context.read<RandomRecipeExplorerBloc>().add(ChangeExploreFilter(selected));
  }

  void _openCookDestination(Recipe recipe) {
    if (!mounted) return;
    if (recipe.steps.isNotEmpty) {
      Navigator.pushNamed(
        context,
        RouteNames.cookMode,
        arguments: CookModeArguments(
          recipe: recipe,
          effectiveIngredients: recipe.ingredients,
        ),
      );
      return;
    }
    _openRecipeDetail(recipe);
  }

  void _openRecipeDetail(Recipe recipe) {
    if (GlobalSettings().standbyDisabled()) WakelockPlus.enable();
    Navigator.pushNamed(
      context,
      RouteNames.recipeScreen,
      arguments: RecipeScreenArguments(
        context.read<ShoppingCartBloc>(),
        context.read<RecipeCalendarBloc>(),
        recipe,
        'explore-${recipe.name}',
        context.read<RecipeManagerBloc>(),
      ),
    ).then((_) {
      WakelockPlus.disable();
      Ads.hideBottomBannerAd();
    });
  }
}

class _ExploreHeader extends StatelessWidget {
  const _ExploreHeader({
    required this.current,
    required this.total,
    required this.filter,
    required this.onFilterPressed,
  });

  final int? current;
  final int? total;
  final ExploreFilter filter;
  final VoidCallback? onFilterPressed;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final strings = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    strings.explore,
                    style: CulinaryEditorialType.headline(
                      palette,
                      size: 30,
                      weight: FontWeight.w600,
                      height: 1.08,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    strings.explore_discover.toUpperCase(),
                    style: CulinaryEditorialType.body(
                      palette,
                      size: 11,
                      weight: FontWeight.w700,
                      color: palette.outline,
                      letterSpacing: 1.05,
                    ),
                  ),
                ],
              ),
            ),
            if (current != null && total != null)
              Container(
                key: const Key('explore-card-counter'),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: palette.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.local_fire_department_rounded,
                      size: 18,
                      color: palette.primary,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      strings.explore_card_counter(current!, total!),
                      style:
                          CulinaryEditorialType.body(
                            palette,
                            size: 12,
                            weight: FontWeight.w700,
                          ).copyWith(
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton.tonalIcon(
            key: const Key('explore-filter-button'),
            onPressed: onFilterPressed,
            icon: const Icon(Icons.tune_rounded, size: 18),
            label: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 190),
              child: Text(
                _filterLabel(context, filter),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            style: FilledButton.styleFrom(
              minimumSize: const Size(0, 48),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              backgroundColor: palette.surfaceContainerHigh,
              foregroundColor: palette.onSurfaceVariant,
              textStyle: CulinaryEditorialType.body(
                palette,
                size: 13,
                weight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ExploreRecipeCard extends StatelessWidget {
  const _ExploreRecipeCard({
    required this.recipe,
    required this.horizontalDrag,
    required this.verticalDrag,
    required this.compact,
    required this.onOpen,
  });

  final Recipe recipe;
  final int horizontalDrag;
  final int verticalDrag;
  final bool compact;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final strings = S.of(context);
    final totalMinutes = recipe.totalTime > 0
        ? recipe.totalTime
        : recipe.preperationTime + recipe.cookingTime;
    final ingredients = recipe.ingredients
        .expand((group) => group)
        .take(compact ? 3 : 4)
        .toList(growable: false);
    return Semantics(
      label: recipe.name,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: palette.shadow.withValues(alpha: .7),
              blurRadius: 28,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Hero(
                          tag: 'explore-${recipe.name}',
                          child: _RecipeImage(recipe: recipe),
                        ),
                        const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Color(0x16000000),
                                Color(0xB8000000),
                              ],
                              stops: [0, .5, 1],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 14,
                          top: 14,
                          right: 14,
                          child: Row(
                            children: [
                              if (recipe.effort != null)
                                _ImageMetric(
                                  color: palette.primary,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 7,
                                        height: 7,
                                        decoration: BoxDecoration(
                                          color: palette.primary,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        compact
                                            ? '${recipe.effort}'
                                            : strings.explore_effort(
                                                recipe.effort!,
                                              ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              if (recipe.effort != null && totalMinutes > 0)
                                const SizedBox(width: 7),
                              if (totalMinutes > 0)
                                _ImageMetric(
                                  color: palette.onSurface,
                                  child: Text(
                                    getTimeHoursMinutes(totalMinutes),
                                  ),
                                ),
                              const Spacer(),
                              IconButton.filledTonal(
                                key: Key('explore-open-${recipe.name}'),
                                tooltip: strings.explore_open_recipe,
                                onPressed: onOpen,
                                style: IconButton.styleFrom(
                                  minimumSize: const Size.square(48),
                                  backgroundColor: palette.surface,
                                  foregroundColor: palette.onSurface,
                                ),
                                icon: const Icon(
                                  Icons.north_east_rounded,
                                  size: 22,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    key: Key('explore-card-content-${recipe.name}'),
                    padding: EdgeInsets.fromLTRB(
                      16,
                      compact ? 12 : 14,
                      16,
                      compact ? 10 : 14,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (recipe.tags.isNotEmpty) ...[
                          SizedBox(
                            height: 24,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: math.min(3, recipe.tags.length),
                              separatorBuilder: (_, _) =>
                                  const SizedBox(width: 6),
                              itemBuilder: (context, index) => _RecipeTag(
                                tag: recipe.tags[index].text,
                                index: index,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                        ],
                        Text(
                          recipe.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: CulinaryEditorialType.headline(
                            palette,
                            size: compact ? 18 : 20,
                            weight: FontWeight.w600,
                            height: 1.15,
                          ),
                        ),
                        if (!compact && recipe.notes.trim().isNotEmpty) ...[
                          const SizedBox(height: 5),
                          Text(
                            recipe.notes.trim().replaceAll('\n', ' '),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: CulinaryEditorialType.body(
                              palette,
                              size: 12,
                              color: palette.onSurfaceVariant,
                              height: 1.35,
                            ),
                          ),
                        ],
                        if (recipe.categories.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Row(
                            key: Key('explore-category-${recipe.name}'),
                            children: [
                              Icon(
                                Icons.folder_open_rounded,
                                size: 15,
                                color: palette.primary,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  recipe.categories
                                      .map(
                                        (category) =>
                                            _categoryLabel(context, category),
                                      )
                                      .join(' · ')
                                      .toUpperCase(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: CulinaryEditorialType.body(
                                    palette,
                                    size: 10,
                                    weight: FontWeight.w700,
                                    color: palette.primary,
                                    letterSpacing: .8,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                        if (!compact && ingredients.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Text(
                            strings.explore_ingredients_snapshot.toUpperCase(),
                            style: CulinaryEditorialType.body(
                              palette,
                              size: 10,
                              weight: FontWeight.w700,
                              color: palette.outline,
                              letterSpacing: .8,
                            ),
                          ),
                          const SizedBox(height: 6),
                          SizedBox(
                            height: 30,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: ingredients.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(width: 6),
                              itemBuilder: (context, index) => _IngredientChip(
                                ingredient: ingredients[index],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              ..._feedbackStamps(context),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _feedbackStamps(BuildContext context) {
    final strings = S.of(context);
    final palette = CulinaryEditorialPalette.of(context);
    final horizontalStrength = (horizontalDrag.abs() / 100).clamp(0.0, 1.0);
    final verticalStrength = (-verticalDrag / 100).clamp(0.0, 1.0);
    return [
      if (horizontalDrag < 0)
        Positioned(
          left: 22,
          top: 54,
          child: _SwipeStamp(
            label: strings.explore_pass,
            color: Theme.of(context).colorScheme.error,
            opacity: horizontalStrength,
            angle: -.12,
          ),
        ),
      if (horizontalDrag > 0)
        Positioned(
          right: 22,
          top: 54,
          child: _SwipeStamp(
            label: strings.explore_cook_tonight,
            color: palette.secondary,
            opacity: horizontalStrength,
            angle: .12,
          ),
        ),
      if (verticalDrag < 0 && horizontalDrag.abs() < 20)
        Positioned(
          left: 0,
          right: 0,
          top: 142,
          child: Center(
            child: _SwipeStamp(
              label: strings.explore_saved,
              color: palette.tertiary,
              opacity: verticalStrength,
            ),
          ),
        ),
    ];
  }
}

class _RecipeImage extends StatelessWidget {
  const _RecipeImage({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final fallback = Image.asset(
      constants.noRecipeImage,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
    if (recipe.imagePath == constants.noRecipeImage ||
        recipe.imagePath.startsWith('images/')) {
      return Image.asset(
        recipe.imagePath,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => fallback,
      );
    }
    return Image.file(
      File(recipe.imagePath),
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => fallback,
    );
  }
}

class _ImageMetric extends StatelessWidget {
  const _ImageMetric({required this.child, required this.color});

  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return DefaultTextStyle(
      style: CulinaryEditorialType.body(
        palette,
        size: 11,
        weight: FontWeight.w700,
        color: color,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: palette.surface.withValues(alpha: .94),
          borderRadius: BorderRadius.circular(999),
          boxShadow: [
            BoxShadow(
              color: palette.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

class _RecipeTag extends StatelessWidget {
  const _RecipeTag({required this.tag, required this.index});

  final String tag;
  final int index;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final fills = [
      palette.primarySoft,
      palette.tertiarySoft,
      palette.secondarySoft,
    ];
    final inks = [palette.primary, palette.tertiary, palette.secondary];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: fills[index % fills.length],
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        '#$tag',
        style: CulinaryEditorialType.body(
          palette,
          size: 10,
          weight: FontWeight.w700,
          color: inks[index % inks.length],
        ),
      ),
    );
  }
}

class _IngredientChip extends StatelessWidget {
  const _IngredientChip({required this.ingredient});

  final Ingredient ingredient;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: palette.surfaceContainer,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.restaurant_rounded, size: 14, color: palette.primary),
          const SizedBox(width: 5),
          Text(
            _ingredientLabel(ingredient),
            style: CulinaryEditorialType.body(
              palette,
              size: 10,
              weight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _SwipeStamp extends StatelessWidget {
  const _SwipeStamp({
    required this.label,
    required this.color,
    required this.opacity,
    this.angle = 0,
  });

  final String label;
  final Color color;
  final double opacity;
  final double angle;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Opacity(
      opacity: opacity,
      child: Transform.rotate(
        angle: angle,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
          decoration: BoxDecoration(
            color: palette.surface.withValues(alpha: .94),
            border: Border.all(color: color, width: 3),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: palette.shadow,
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            label.toUpperCase(),
            style: CulinaryEditorialType.headline(
              palette,
              size: 15,
              weight: FontWeight.w700,
            ).copyWith(color: color, letterSpacing: .65),
          ),
        ),
      ),
    );
  }
}

class _ExploreActionDock extends StatelessWidget {
  const _ExploreActionDock({
    required this.canRewind,
    required this.saved,
    required this.onRewind,
    required this.onPass,
    required this.onSave,
    required this.onCook,
  });

  final bool canRewind;
  final bool saved;
  final VoidCallback onRewind;
  final VoidCallback? onPass;
  final VoidCallback? onSave;
  final VoidCallback? onCook;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final strings = S.of(context);
    return SizedBox(
      height: 68,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _DockButton(
            key: const Key('explore-rewind'),
            tooltip: strings.explore_rewind,
            icon: Icons.replay_rounded,
            color: palette.tertiary,
            size: 48,
            onPressed: canRewind ? onRewind : null,
          ),
          _DockButton(
            key: const Key('explore-pass'),
            tooltip: strings.explore_pass,
            icon: Icons.close_rounded,
            color: Theme.of(context).colorScheme.error,
            size: 56,
            onPressed: onPass,
          ),
          _DockButton(
            key: const Key('explore-save'),
            tooltip: strings.explore_save,
            icon: saved ? Icons.bookmark_rounded : Icons.bookmark_add_rounded,
            color: palette.tertiary,
            size: 56,
            onPressed: onSave,
          ),
          _DockButton(
            key: const Key('explore-cook'),
            tooltip: strings.explore_cook,
            icon: Icons.restaurant_rounded,
            color: palette.onPrimary,
            background: palette.primary,
            size: 64,
            onPressed: onCook,
          ),
        ],
      ),
    );
  }
}

class _DockButton extends StatelessWidget {
  const _DockButton({
    super.key,
    required this.tooltip,
    required this.icon,
    required this.color,
    required this.size,
    required this.onPressed,
    this.background,
  });

  final String tooltip;
  final IconData icon;
  final Color color;
  final double size;
  final VoidCallback? onPressed;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      constraints: BoxConstraints.tightFor(width: size, height: size),
      style: IconButton.styleFrom(
        backgroundColor: background ?? palette.surface,
        foregroundColor: color,
        disabledBackgroundColor: palette.surfaceContainer,
        disabledForegroundColor: palette.outline.withValues(alpha: .45),
        shadowColor: palette.shadow,
        elevation: onPressed == null ? 0 : 3,
      ),
      icon: Icon(icon, size: size >= 60 ? 30 : 26),
    );
  }
}

class _ExploreFilterSheet extends StatelessWidget {
  const _ExploreFilterSheet({
    required this.categories,
    required this.tags,
    required this.selected,
  });

  final List<String> categories;
  final List<StringIntTuple> tags;
  final ExploreFilter selected;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final strings = S.of(context);
    return SafeArea(
      top: false,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * .78,
        ),
        child: Material(
          color: palette.surface,
          clipBehavior: Clip.antiAlias,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: palette.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 12, 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        strings.explore_filter_title,
                        style: CulinaryEditorialType.headline(
                          palette,
                          size: 23,
                          weight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: MaterialLocalizations.of(context)
                          .closeButtonTooltip,
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
                  children: [
                    _FilterOption(
                      icon: Icons.restaurant_menu_rounded,
                      label: strings.explore_all_recipes,
                      selected: selected.kind == ExploreFilterKind.all,
                      onTap: () =>
                          Navigator.pop(context, const ExploreFilter.all()),
                    ),
                    if (categories.isNotEmpty) ...[
                      _FilterSectionLabel(label: strings.categories),
                      for (final category in categories)
                        _FilterOption(
                          icon: Icons.folder_outlined,
                          label: _categoryLabel(context, category),
                          selected:
                              selected == ExploreFilter.category(category),
                          onTap: () => Navigator.pop(
                            context,
                            ExploreFilter.category(category),
                          ),
                        ),
                    ],
                    if (tags.isNotEmpty) ...[
                      _FilterSectionLabel(label: strings.tags),
                      for (final tag in tags)
                        _FilterOption(
                          icon: Icons.sell_outlined,
                          label: tag.text,
                          selected: selected == ExploreFilter.tag(tag.text),
                          onTap: () => Navigator.pop(
                            context,
                            ExploreFilter.tag(tag.text),
                          ),
                        ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterSectionLabel extends StatelessWidget {
  const _FilterSectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 18, 12, 6),
      child: Text(
        label,
        style: CulinaryEditorialType.body(
          palette,
          size: 11,
          weight: FontWeight.w700,
          color: palette.outline,
          letterSpacing: .8,
        ),
      ),
    );
  }
}

class _FilterOption extends StatelessWidget {
  const _FilterOption({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return ListTile(
      minTileHeight: 52,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      tileColor: selected ? palette.primarySoft : Colors.transparent,
      leading: Icon(
        icon,
        color: selected ? palette.primary : palette.onSurfaceVariant,
      ),
      title: Text(
        label,
        style: CulinaryEditorialType.body(
          palette,
          size: 14,
          weight: selected ? FontWeight.w700 : FontWeight.w500,
          color: selected ? palette.primary : palette.onSurface,
        ),
      ),
      trailing: selected
          ? Icon(Icons.check_rounded, color: palette.primary)
          : null,
      onTap: onTap,
    );
  }
}

class _ExploreLoadingScreen extends StatelessWidget {
  const _ExploreLoadingScreen({required this.state});

  final RandomRecipeExplorerState state;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return _ExploreFrame(
      header: _ExploreHeader(
        current: null,
        total: null,
        filter: state.filter,
        onFilterPressed: null,
      ),
      child: Center(child: CircularProgressIndicator(color: palette.primary)),
    );
  }
}

class _ExploreStatusScreen extends StatelessWidget {
  const _ExploreStatusScreen({
    required this.state,
    required this.icon,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  final RandomRecipeExplorerState state;
  final IconData icon;
  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return _ExploreFrame(
      header: _ExploreHeader(
        current: null,
        total: null,
        filter: state.filter,
        onFilterPressed: null,
      ),
      child: _EditorialEmptyState(
        icon: icon,
        title: title,
        message: message,
        actionLabel: actionLabel,
        onAction: onAction,
      ),
    );
  }
}

class _ExploreFrame extends StatelessWidget {
  const _ExploreFrame({required this.header, required this.child});

  final Widget header;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final compactNavigation = !constants.usesHomeNavigationRail(
      MediaQuery.sizeOf(context).width,
    );
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            10,
            20,
            compactNavigation ? 104 : 24,
          ),
          child: Column(
            children: [
              header,
              const SizedBox(height: 20),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyDeck extends StatelessWidget {
  const _EmptyDeck({required this.onChangeFilter});

  final VoidCallback onChangeFilter;

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    return _EditorialEmptyState(
      icon: Icons.restaurant_menu_rounded,
      title: strings.explore_empty_title,
      message: strings.explore_empty_message,
      actionLabel: strings.explore_change_filter,
      onAction: onChangeFilter,
    );
  }
}

class _CompleteDeck extends StatelessWidget {
  const _CompleteDeck({required this.onRestart});

  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    return _EditorialEmptyState(
      key: const Key('explore-complete'),
      icon: Icons.auto_awesome_rounded,
      title: strings.explore_complete_title,
      message: strings.explore_complete_message,
      actionLabel: strings.explore_restart,
      onAction: onRestart,
    );
  }
}

class _EditorialEmptyState extends StatelessWidget {
  const _EditorialEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 58, color: palette.primary),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: CulinaryEditorialType.headline(
                palette,
                size: 23,
                weight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: CulinaryEditorialType.body(
                palette,
                size: 13,
                color: palette.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 22),
            FilledButton(
              onPressed: onAction,
              style: FilledButton.styleFrom(
                minimumSize: const Size(0, 48),
                backgroundColor: palette.primary,
                foregroundColor: palette.onPrimary,
              ),
              child: Text(actionLabel),
            ),
          ],
        ),
      ),
    );
  }
}

String _filterLabel(BuildContext context, ExploreFilter filter) {
  if (filter.kind == ExploreFilterKind.all)
    return S.of(context).explore_filters;
  if (filter.kind == ExploreFilterKind.category) {
    return _categoryLabel(context, filter.value!);
  }
  return '#${filter.value!}';
}

String _categoryLabel(BuildContext context, String category) {
  if (category == 'no category') return S.of(context).no_category;
  if (category == 'all categories') return S.of(context).all_categories;
  return category;
}

String _ingredientLabel(Ingredient ingredient) {
  final amount = ingredient.amount;
  final amountLabel = amount == null
      ? ''
      : amount == amount.roundToDouble()
      ? amount.toInt().toString()
      : amount.toStringAsFixed(1);
  return [
    amountLabel,
    if (ingredient.unit?.trim().isNotEmpty == true) ingredient.unit!.trim(),
    ingredient.name,
  ].where((part) => part.isNotEmpty).join(' ');
}
