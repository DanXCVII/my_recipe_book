import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

import '../../generated/l10n.dart';
import '../culinary_editorial_theme.dart';

class EditorialOnboardingPage extends StatelessWidget {
  const EditorialOnboardingPage({
    super.key,
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: CulinaryEditorialType.headline(
                    palette,
                    size: constraints.maxWidth >= 600 ? 34 : 29,
                    weight: FontWeight.w600,
                    height: 1.08,
                  ),
                ),
                const SizedBox(height: 10),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 620),
                  child: Text(
                    description,
                    style: CulinaryEditorialType.body(
                      palette,
                      size: 15,
                      color: palette.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EffortOnboardingDemo extends StatefulWidget {
  const EffortOnboardingDemo({super.key, required this.isActive});

  final bool isActive;

  @override
  State<EffortOnboardingDemo> createState() => _EffortOnboardingDemoState();
}

class _EffortOnboardingDemoState extends State<EffortOnboardingDemo> {
  int _effort = 3;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final strings = S.of(context);
    final color = _effort <= 3
        ? palette.secondary
        : _effort <= 7
        ? palette.tertiary
        : palette.primary;
    final tier = _effort <= 3
        ? strings.onboarding_effort_gentle
        : _effort <= 7
        ? strings.onboarding_effort_balanced
        : strings.onboarding_effort_ambitious;
    final lowEffort = _effort <= 5;

    return _ShowcaseSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_fire_department_rounded, color: color, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  strings.onboarding_effort_scale,
                  style: CulinaryEditorialType.body(
                    palette,
                    size: 15,
                    weight: FontWeight.w700,
                  ),
                ),
              ),
              _TonalLabel(label: tier, color: color),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: Text(
                  strings.onboarding_effort_level(_effort),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: CulinaryEditorialType.body(
                    palette,
                    size: 12,
                    weight: FontWeight.w700,
                    color: palette.onSurfaceVariant,
                    letterSpacing: .65,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  tier,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: CulinaryEditorialType.body(
                    palette,
                    size: 12,
                    weight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: List.generate(10, (index) {
              final value = index + 1;
              final active = value <= _effort;
              final segmentColor = value <= 3
                  ? palette.secondary
                  : value <= 7
                  ? palette.tertiary
                  : palette.primary;
              return Expanded(
                child: Semantics(
                  button: true,
                  selected: value == _effort,
                  label: strings.onboarding_effort_choose(value),
                  child: InkResponse(
                    key: Key('onboarding-effort-$value'),
                    onTap: () => setState(() => _effort = value),
                    radius: 24,
                    child: SizedBox(
                      height: 48,
                      child: Center(
                        child: AnimatedContainer(
                          duration: MediaQuery.disableAnimationsOf(context)
                              ? Duration.zero
                              : const Duration(milliseconds: 180),
                          height: value == _effort ? 15 : 11,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: active
                                ? segmentColor
                                : palette.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(999),
                            boxShadow: value == _effort
                                ? [
                                    BoxShadow(
                                      color: segmentColor.withValues(
                                        alpha: .28,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ]
                                : null,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          Row(
            children:
                [
                  strings.onboarding_effort_one,
                  strings.onboarding_effort_five,
                  strings.onboarding_effort_ten,
                ].map((label) {
                  return Expanded(
                    child: Text(
                      label,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: label == strings.onboarding_effort_one
                          ? TextAlign.start
                          : label == strings.onboarding_effort_ten
                          ? TextAlign.end
                          : TextAlign.center,
                      style: CulinaryEditorialType.body(
                        palette,
                        size: 10,
                        weight: FontWeight.w600,
                        color: palette.outline,
                      ),
                    ),
                  );
                }).toList(),
          ),
          const SizedBox(height: 18),
          AnimatedSwitcher(
            duration: MediaQuery.disableAnimationsOf(context)
                ? Duration.zero
                : const Duration(milliseconds: 220),
            child: _EffortRecipePreview(
              key: ValueKey(lowEffort),
              imagePath: lowEffort
                  ? 'images/salatLowRes.jpg'
                  : 'images/cuisine.jpg',
              title: lowEffort
                  ? strings.onboarding_effort_easy_recipe
                  : strings.onboarding_effort_project_recipe,
              detail: lowEffort
                  ? strings.onboarding_effort_easy_detail
                  : strings.onboarding_effort_project_detail,
              color: color,
              effort: _effort,
            ),
          ),
        ],
      ),
    );
  }
}

class _EffortRecipePreview extends StatelessWidget {
  const _EffortRecipePreview({
    super.key,
    required this.imagePath,
    required this.title,
    required this.detail,
    required this.color,
    required this.effort,
  });

  final String imagePath;
  final String title;
  final String detail;
  final Color color;
  final int effort;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.surfaceContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                imagePath,
                width: 82,
                height: 82,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TonalLabel(
                    label: S.of(context).onboarding_effort_badge(effort),
                    color: color,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: CulinaryEditorialType.headline(
                      palette,
                      size: 18,
                      weight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    detail,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: CulinaryEditorialType.body(
                      palette,
                      size: 12,
                      color: palette.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CookModeOnboardingDemo extends StatefulWidget {
  const CookModeOnboardingDemo({super.key, required this.isActive});

  final bool isActive;

  @override
  State<CookModeOnboardingDemo> createState() => _CookModeOnboardingDemoState();
}

class _CookModeOnboardingDemoState extends State<CookModeOnboardingDemo>
    with AutomaticKeepAliveClientMixin<CookModeOnboardingDemo> {
  static const _initialSeconds = 8 * 60 + 30;

  Timer? _timer;
  int _remainingSeconds = _initialSeconds;
  bool _running = false;

  @override
  void didUpdateWidget(covariant CookModeOnboardingDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.isActive && _running) _pause();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  void _toggle() => _running ? _pause() : _start();

  void _start() {
    _timer?.cancel();
    setState(() => _running = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || !widget.isActive) {
        _pause();
        return;
      }
      if (_remainingSeconds <= 0) {
        _pause();
        return;
      }
      setState(() => _remainingSeconds -= 1);
    });
  }

  void _pause() {
    _timer?.cancel();
    _timer = null;
    if (mounted && _running) setState(() => _running = false);
  }

  void _addMinute() => setState(() => _remainingSeconds += 60);

  String get _formatted {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final palette = CulinaryEditorialPalette.of(context);
    final strings = S.of(context);
    return Column(
      children: [
        _ShowcaseSurface(
          padding: EdgeInsets.zero,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Column(
              children: [
                SizedBox(
                  height: 152,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset('images/cuisine.jpg', fit: BoxFit.cover),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Color(0xB01B1514)],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 14,
                        right: 14,
                        bottom: 12,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                strings.onboarding_cook_sample_recipe,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: CulinaryEditorialType.body(
                                  palette,
                                  size: 12,
                                  weight: FontWeight.w700,
                                  color: const Color(0xFFFFF8F2),
                                  letterSpacing: .7,
                                ),
                              ),
                            ),
                            _ImagePill(
                              label: strings.onboarding_cook_step_count,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '03',
                            style: CulinaryEditorialType.headline(
                              palette,
                              size: 22,
                              weight: FontWeight.w600,
                            ).copyWith(color: palette.primary),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              strings.onboarding_cook_sample_step,
                              style: CulinaryEditorialType.headline(
                                palette,
                                size: 21,
                                weight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.check_circle_outline_rounded,
                            color: palette.secondary,
                            size: 24,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        strings.onboarding_cook_sample_instruction,
                        style: CulinaryEditorialType.body(
                          palette,
                          size: 14,
                          color: palette.onSurfaceVariant,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        strings.cook_mode_required_ingredients(1).toUpperCase(),
                        style: CulinaryEditorialType.body(
                          palette,
                          size: 10,
                          weight: FontWeight.w700,
                          color: palette.outline,
                          letterSpacing: .8,
                        ),
                      ),
                      const SizedBox(height: 7),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: palette.surfaceContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Icon(
                                Icons.wine_bar_outlined,
                                color: palette.primary,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  strings.onboarding_cook_sample_ingredient,
                                  style: CulinaryEditorialType.body(
                                    palette,
                                    size: 13,
                                    weight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: palette.surfaceContainer,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Icon(
                                Icons.timer_outlined,
                                color: palette.primary,
                                size: 22,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Semantics(
                                  label: strings.cook_mode_timer,
                                  value: _formatted,
                                  child: ExcludeSemantics(
                                    child: Text(
                                      _formatted,
                                      key: const Key('onboarding-timer-value'),
                                      style:
                                          CulinaryEditorialType.body(
                                            palette,
                                            size: 27,
                                            weight: FontWeight.w700,
                                          ).copyWith(
                                            fontFeatures: const [
                                              FontFeature.tabularFigures(),
                                            ],
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                              OutlinedButton(
                                key: const Key('onboarding-timer-add'),
                                onPressed: _addMinute,
                                style: OutlinedButton.styleFrom(
                                  minimumSize: const Size(64, 48),
                                  foregroundColor: palette.onSurface,
                                  side: BorderSide(
                                    color: palette.outline.withValues(
                                      alpha: .5,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  strings.cook_mode_add_minute_compact,
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton.filled(
                                key: const Key('onboarding-timer-toggle'),
                                onPressed: _toggle,
                                tooltip: _running
                                    ? strings.cook_mode_pause_timer
                                    : strings.cook_mode_start_timer,
                                style: IconButton.styleFrom(
                                  minimumSize: const Size.square(48),
                                  backgroundColor: palette.primary,
                                  foregroundColor: palette.onPrimary,
                                ),
                                icon: Icon(
                                  _running
                                      ? Icons.pause_rounded
                                      : Icons.play_arrow_rounded,
                                ),
                              ),
                            ],
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
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _FeatureNote(
                icon: Icons.visibility_outlined,
                title: strings.onboarding_cook_glanceable_title,
                description: strings.onboarding_cook_glanceable_description,
                color: palette.secondary,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _FeatureNote(
                icon: Icons.screen_lock_portrait_outlined,
                title: strings.onboarding_cook_awake_title,
                description: strings.onboarding_cook_awake_description,
                color: palette.tertiary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class PantryOnboardingDemo extends StatefulWidget {
  const PantryOnboardingDemo({super.key, required this.isActive});

  final bool isActive;

  @override
  State<PantryOnboardingDemo> createState() => _PantryOnboardingDemoState();
}

class _PantryOnboardingDemoState extends State<PantryOnboardingDemo> {
  final Set<int> _selected = {0, 1, 2};
  final Set<int> _checked = {0};

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final strings = S.of(context);
    final ingredients = [
      strings.onboarding_pantry_spinach,
      strings.onboarding_pantry_pasta,
      strings.onboarding_pantry_tomatoes,
    ];
    final shoppingItems = [
      strings.onboarding_shopping_parmesan,
      strings.onboarding_shopping_garlic,
      strings.onboarding_shopping_cream,
    ];

    return Column(
      children: [
        _ShowcaseSurface(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.kitchen_outlined,
                    color: palette.primary,
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      strings.onboarding_pantry_search_title,
                      style: CulinaryEditorialType.body(
                        palette,
                        size: 15,
                        weight: FontWeight.w700,
                      ),
                    ),
                  ),
                  _TonalLabel(
                    label: strings.onboarding_pantry_pro,
                    color: palette.primary,
                  ),
                ],
              ),
              const SizedBox(height: 13),
              Wrap(
                spacing: 7,
                runSpacing: 7,
                children: List.generate(ingredients.length, (index) {
                  final selected = _selected.contains(index);
                  return FilterChip(
                    key: Key('onboarding-pantry-chip-$index'),
                    selected: selected,
                    label: Text(ingredients[index]),
                    avatar: Icon(
                      selected ? Icons.check_rounded : Icons.add_rounded,
                      size: 17,
                    ),
                    onSelected: (_) => setState(() {
                      if (selected) {
                        _selected.remove(index);
                      } else {
                        _selected.add(index);
                      }
                    }),
                    showCheckmark: false,
                    selectedColor: palette.primarySoft,
                    backgroundColor: palette.surfaceContainer,
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 14),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: palette.surfaceContainer,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'images/randomFood.jpg',
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 11),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              strings.onboarding_pantry_match(
                                _selected.length,
                                ingredients.length,
                              ),
                              style: CulinaryEditorialType.body(
                                palette,
                                size: 10,
                                weight: FontWeight.w700,
                                color: palette.primary,
                                letterSpacing: .65,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              strings.onboarding_pantry_sample_recipe,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: CulinaryEditorialType.headline(
                                palette,
                                size: 18,
                                weight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              strings.onboarding_pantry_sample_detail,
                              style: CulinaryEditorialType.body(
                                palette,
                                size: 11,
                                color: palette.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _ShowcaseSurface(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.shopping_cart_checkout_rounded,
                    color: palette.tertiary,
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      strings.onboarding_shopping_title,
                      style: CulinaryEditorialType.body(
                        palette,
                        size: 15,
                        weight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    strings.onboarding_shopping_servings,
                    style: CulinaryEditorialType.body(
                      palette,
                      size: 11,
                      weight: FontWeight.w700,
                      color: palette.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ...List.generate(shoppingItems.length, (index) {
                final checked = _checked.contains(index);
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index == shoppingItems.length - 1 ? 0 : 7,
                  ),
                  child: Material(
                    color: palette.surfaceContainer,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      key: Key('onboarding-shopping-item-$index'),
                      onTap: () => setState(() {
                        if (checked) {
                          _checked.remove(index);
                        } else {
                          _checked.add(index);
                        }
                      }),
                      borderRadius: BorderRadius.circular(10),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minHeight: 48),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          child: Row(
                            children: [
                              AnimatedContainer(
                                duration:
                                    MediaQuery.disableAnimationsOf(context)
                                    ? Duration.zero
                                    : const Duration(milliseconds: 160),
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: checked
                                      ? palette.secondary
                                      : Colors.transparent,
                                  border: checked
                                      ? null
                                      : Border.all(color: palette.outline),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: checked
                                    ? Icon(
                                        Icons.check_rounded,
                                        color: palette.background,
                                        size: 17,
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  shoppingItems[index],
                                  style:
                                      CulinaryEditorialType.body(
                                        palette,
                                        size: 13,
                                        weight: FontWeight.w600,
                                      ).copyWith(
                                        decoration: checked
                                            ? TextDecoration.lineThrough
                                            : null,
                                        color: checked
                                            ? palette.onSurfaceVariant
                                            : palette.onSurface,
                                      ),
                                ),
                              ),
                              Text(
                                ['120 g', '2', '150 ml'][index],
                                style: CulinaryEditorialType.body(
                                  palette,
                                  size: 11,
                                  weight: FontWeight.w700,
                                  color: palette.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}

class ExploreOnboardingDemo extends StatefulWidget {
  const ExploreOnboardingDemo({super.key, required this.isActive});

  final bool isActive;

  @override
  State<ExploreOnboardingDemo> createState() => _ExploreOnboardingDemoState();
}

class _ExploreOnboardingDemoState extends State<ExploreOnboardingDemo> {
  late final CardSwiperController _controller;
  int _current = 0;
  String? _feedback;

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
    final palette = CulinaryEditorialPalette.of(context);
    final strings = S.of(context);
    final cards = [
      _DemoRecipe(
        title: strings.onboarding_explore_recipe_one,
        image: 'images/cuisine.jpg',
        detail: strings.onboarding_explore_recipe_one_detail,
        effort: 4,
      ),
      _DemoRecipe(
        title: strings.onboarding_explore_recipe_two,
        image: 'images/salatLowRes.jpg',
        detail: strings.onboarding_explore_recipe_two_detail,
        effort: 2,
      ),
      _DemoRecipe(
        title: strings.onboarding_explore_recipe_three,
        image: 'images/randomFood.jpg',
        detail: strings.onboarding_explore_recipe_three_detail,
        effort: 7,
      ),
    ];

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                strings.explore_discover.toUpperCase(),
                style: CulinaryEditorialType.body(
                  palette,
                  size: 11,
                  weight: FontWeight.w700,
                  color: palette.outline,
                  letterSpacing: 1,
                ),
              ),
            ),
            _TonalLabel(
              label: strings.onboarding_explore_card(
                _current + 1,
                cards.length,
              ),
              color: palette.primary,
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 360,
          child: CardSwiper(
            key: const Key('onboarding-explore-swiper'),
            controller: _controller,
            cardsCount: cards.length,
            numberOfCardsDisplayed: cards.length,
            isLoop: true,
            padding: EdgeInsets.zero,
            backCardOffset: const Offset(0, 12),
            scale: .955,
            maxAngle: 18,
            threshold: 36,
            duration: MediaQuery.disableAnimationsOf(context)
                ? const Duration(milliseconds: 1)
                : const Duration(milliseconds: 250),
            allowedSwipeDirection: const AllowedSwipeDirection.only(
              left: true,
              right: true,
              up: true,
            ),
            cardBuilder: (context, index, horizontal, vertical) =>
                _ExploreDemoCard(
                  recipe: cards[index],
                  horizontal: horizontal,
                  vertical: vertical,
                ),
            onSwipe: (previous, current, direction) {
              setState(() {
                _current = current ?? 0;
                _feedback = switch (direction) {
                  CardSwiperDirection.left => strings.explore_pass,
                  CardSwiperDirection.top => strings.explore_saved,
                  CardSwiperDirection.right => strings.explore_cook_tonight,
                  _ => null,
                };
              });
              return true;
            },
            onUndo: (_, current, _) {
              setState(() {
                _current = current;
                _feedback = null;
              });
              return true;
            },
          ),
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _ExploreAction(
              key: const Key('onboarding-explore-rewind'),
              icon: Icons.undo_rounded,
              tooltip: strings.explore_rewind,
              color: palette.tertiary,
              onPressed: () => _controller.undo(),
            ),
            const SizedBox(width: 12),
            _ExploreAction(
              key: const Key('onboarding-explore-pass'),
              icon: Icons.close_rounded,
              tooltip: strings.explore_pass,
              color: Theme.of(context).colorScheme.error,
              onPressed: () => _controller.swipe(CardSwiperDirection.left),
            ),
            const SizedBox(width: 12),
            _ExploreAction(
              key: const Key('onboarding-explore-save'),
              icon: Icons.bookmark_add_outlined,
              tooltip: strings.explore_save,
              color: palette.tertiary,
              onPressed: () => _controller.swipe(CardSwiperDirection.top),
            ),
            const SizedBox(width: 12),
            _ExploreAction(
              key: const Key('onboarding-explore-cook'),
              icon: Icons.restaurant_rounded,
              tooltip: strings.explore_cook,
              color: palette.primary,
              filled: true,
              onPressed: () => _controller.swipe(CardSwiperDirection.right),
            ),
          ],
        ),
        AnimatedSize(
          duration: MediaQuery.disableAnimationsOf(context)
              ? Duration.zero
              : const Duration(milliseconds: 180),
          child: _feedback == null
              ? const SizedBox(height: 14)
              : Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    _feedback!,
                    key: const Key('onboarding-explore-feedback'),
                    style: CulinaryEditorialType.body(
                      palette,
                      size: 12,
                      weight: FontWeight.w700,
                      color: palette.primary,
                    ),
                  ),
                ),
        ),
        const SizedBox(height: 8),
        Text(
          strings.onboarding_explore_fallback,
          textAlign: TextAlign.center,
          style: CulinaryEditorialType.body(
            palette,
            size: 12,
            color: palette.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _ExploreDemoCard extends StatelessWidget {
  const _ExploreDemoCard({
    required this.recipe,
    required this.horizontal,
    required this.vertical,
  });

  final _DemoRecipe recipe;
  final int horizontal;
  final int vertical;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final strings = S.of(context);
    final horizontalStrength = (horizontal.abs() / 100).clamp(0.0, 1.0);
    final verticalStrength = (-vertical / 100).clamp(0.0, 1.0);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: palette.shadow.withValues(alpha: .8),
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
                      Image.asset(recipe.image, fit: BoxFit.cover),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Color(0xB81B1514)],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 14,
                        left: 14,
                        child: _ImagePill(
                          label: strings.explore_effort(recipe.effort),
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
                      Text(
                        recipe.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: CulinaryEditorialType.headline(
                          palette,
                          size: 20,
                          weight: FontWeight.w600,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        recipe.detail,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: CulinaryEditorialType.body(
                          palette,
                          size: 12,
                          color: palette.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (horizontal < 0)
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
            if (horizontal > 0)
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
            if (vertical < 0 && horizontal.abs() < 20)
              Positioned(
                left: 0,
                right: 0,
                top: 110,
                child: Center(
                  child: _SwipeStamp(
                    label: strings.explore_saved,
                    color: palette.tertiary,
                    opacity: verticalStrength,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ShowcaseSurface extends StatelessWidget {
  const _ShowcaseSurface({
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: palette.shadow,
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}

class _FeatureNote extends StatelessWidget {
  const _FeatureNote({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.surfaceContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 8),
            Text(
              title,
              style: CulinaryEditorialType.body(
                palette,
                size: 13,
                weight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              description,
              style: CulinaryEditorialType.body(
                palette,
                size: 11,
                color: palette.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TonalLabel extends StatelessWidget {
  const _TonalLabel({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: Color.alphaBlend(
          color.withValues(alpha: .16),
          palette.surfaceContainer,
        ),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: CulinaryEditorialType.body(
          palette,
          size: 10,
          weight: FontWeight.w700,
          color: color,
          letterSpacing: .35,
        ),
      ),
    );
  }
}

class _ImagePill extends StatelessWidget {
  const _ImagePill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFFDF8F2).withValues(alpha: .92),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          label,
          style: const TextStyle(
            color: Color(0xFF2D211E),
            fontFamily: CulinaryEditorialType.bodyFamily,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _ExploreAction extends StatelessWidget {
  const _ExploreAction({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.color,
    required this.onPressed,
    this.filled = false,
  });

  final IconData icon;
  final String tooltip;
  final Color color;
  final VoidCallback onPressed;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      style: IconButton.styleFrom(
        minimumSize: const Size.square(52),
        backgroundColor: filled ? color : palette.surface,
        foregroundColor: filled ? palette.onPrimary : color,
        shadowColor: palette.shadow,
        elevation: filled ? 5 : 2,
      ),
      icon: Icon(icon, size: 24),
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
    return Transform.rotate(
      angle: angle,
      child: Opacity(
        opacity: opacity,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xFFFDF8F2).withValues(alpha: .94),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
            child: Text(
              label.toUpperCase(),
              style: TextStyle(
                color: color,
                fontFamily: CulinaryEditorialType.bodyFamily,
                fontSize: 13,
                fontWeight: FontWeight.w800,
                letterSpacing: .7,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DemoRecipe {
  const _DemoRecipe({
    required this.title,
    required this.image,
    required this.detail,
    required this.effort,
  });

  final String title;
  final String image;
  final String detail;
  final int effort;
}
