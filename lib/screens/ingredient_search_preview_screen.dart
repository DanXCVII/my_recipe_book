import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/ad_manager/ad_manager_bloc.dart';
import '../blocs/ingredient_search/ingredient_search_bloc.dart';
import '../blocs/recipe_manager/recipe_manager_bloc.dart';
import '../generated/l10n.dart';
import '../local_storage/local_repository.dart';
import '../widgets/culinary_editorial_theme.dart';
import 'ingredient_search.dart';

const double ingredientSearchPreviewTwoPaneBreakpoint = 720;

class IngredientSearchAccessGate extends StatefulWidget {
  const IngredientSearchAccessGate({
    required this.arguments,
    required this.repository,
    super.key,
  });

  final IngredientSearchScreenArguments arguments;
  final LocalRepository repository;

  @override
  State<IngredientSearchAccessGate> createState() =>
      _IngredientSearchAccessGateState();
}

class _IngredientSearchAccessGateState
    extends State<IngredientSearchAccessGate> {
  late bool _unlocked;

  @override
  void initState() {
    super.initState();
    _unlocked =
        widget.arguments.hasPremium ||
        context.read<Bloc<AdManagerEvent, AdManagerState>>().state
            is IsPurchased;
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    return BlocListener<Bloc<AdManagerEvent, AdManagerState>, AdManagerState>(
      listener: (context, state) {
        if (!_unlocked && state is IsPurchased) {
          setState(() => _unlocked = true);
        }
      },
      child: AnimatedSwitcher(
        duration: reduceMotion
            ? Duration.zero
            : const Duration(milliseconds: 180),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeOutCubic,
        child: _unlocked ? _buildIngredientSearch() : _buildPreview(context),
      ),
    );
  }

  Widget _buildPreview(BuildContext context) {
    return IngredientSearchPreviewScreen(
      key: const ValueKey('ingredient-search-preview'),
      onPurchase: () => context
          .read<Bloc<AdManagerEvent, AdManagerState>>()
          .add(PurchaseProVersion()),
    );
  }

  Widget _buildIngredientSearch() {
    return MultiBlocProvider(
      key: const ValueKey('ingredient-search-unlocked'),
      providers: [
        BlocProvider<IngredientSearchBloc>(
          create: (context) => IngredientSearchBloc(
            repository: widget.repository,
            recipeManagerBloc: context.read<RecipeManagerBloc>(),
          ),
        ),
        BlocProvider.value(value: widget.arguments.shoppingCartBloc),
        BlocProvider.value(value: widget.arguments.recipeCalendarBloc),
      ],
      child: const IngredientSearchScreen(),
    );
  }
}

class IngredientSearchPreviewScreen extends StatelessWidget {
  const IngredientSearchPreviewScreen({required this.onPurchase, super.key});

  final VoidCallback onPurchase;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final editorialTheme = culinaryEditorialTheme(Theme.of(context), palette);
    return Theme(
      data: editorialTheme,
      child: Scaffold(
        key: const Key('ingredient-search-preview-screen'),
        backgroundColor: palette.background,
        appBar: AppBar(
          backgroundColor: palette.background,
          foregroundColor: palette.onSurface,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          title: Text(
            S.of(context).ingredient_search_title,
            style: CulinaryEditorialType.body(
              palette,
              size: 16,
              weight: FontWeight.w700,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 16),
              child: Center(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: palette.primarySoft,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 6,
                    ),
                    child: Text(
                      S.of(context).ingredient_search_preview_pro_badge,
                      style: CulinaryEditorialType.body(
                        palette,
                        size: 10,
                        weight: FontWeight.w700,
                        color: palette.primary,
                        letterSpacing: .8,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          top: false,
          bottom: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final twoPane =
                  constraints.maxWidth >=
                  ingredientSearchPreviewTwoPaneBreakpoint;
              return SingleChildScrollView(
                key: const Key('ingredient-search-preview-scroll'),
                padding: EdgeInsets.fromLTRB(
                  twoPane ? 32 : 20,
                  twoPane ? 28 : 12,
                  twoPane ? 32 : 20,
                  32,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1040),
                    child: twoPane
                        ? const _TwoPanePreview(
                            key: Key('ingredient-search-preview-tablet'),
                          )
                        : const _PhonePreview(
                            key: Key('ingredient-search-preview-phone'),
                          ),
                  ),
                ),
              );
            },
          ),
        ),
        bottomNavigationBar: _PurchaseBar(onPurchase: onPurchase),
      ),
    );
  }
}

class _PhonePreview extends StatelessWidget {
  const _PhonePreview({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PreviewIntroduction(),
        SizedBox(height: 24),
        _IngredientSearchDemonstration(),
        SizedBox(height: 30),
        _BenefitList(),
        SizedBox(height: 24),
        _ProBenefitCallout(),
      ],
    );
  }
}

class _TwoPanePreview extends StatelessWidget {
  const _TwoPanePreview({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PreviewIntroduction(),
              SizedBox(height: 32),
              _BenefitList(),
              SizedBox(height: 24),
              _ProBenefitCallout(),
            ],
          ),
        ),
        SizedBox(width: 42),
        Expanded(child: _IngredientSearchDemonstration()),
      ],
    );
  }
}

class _PreviewIntroduction extends StatelessWidget {
  const _PreviewIntroduction();

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).ingredient_search_heading,
          style: CulinaryEditorialType.headline(
            palette,
            size: 32,
            weight: FontWeight.w600,
            height: 1.14,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          S.of(context).ingredient_search_preview_description,
          style: CulinaryEditorialType.body(
            palette,
            size: 15,
            color: palette.onSurfaceVariant,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _IngredientSearchDemonstration extends StatelessWidget {
  const _IngredientSearchDemonstration();

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final strings = S.of(context);
    return Semantics(
      container: true,
      label: strings.ingredient_search_preview_semantics,
      child: ExcludeSemantics(
        child: Material(
          key: const Key('ingredient-search-preview-demo'),
          color: palette.surface,
          elevation: 2,
          shadowColor: palette.shadow,
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.kitchen_rounded,
                      size: 20,
                      color: palette.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        strings.ingredient_search_basket_count(3),
                        style: CulinaryEditorialType.body(
                          palette,
                          size: 11,
                          weight: FontWeight.w700,
                          color: palette.primary,
                          letterSpacing: .7,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: [
                    _PreviewPill(
                      label: strings.ingredient_search_preview_spinach,
                      icon: Icons.check_rounded,
                      background: palette.primarySoft,
                      foreground: palette.primary,
                    ),
                    _PreviewPill(
                      label: strings.ingredient_search_preview_pasta,
                      icon: Icons.check_rounded,
                      background: palette.primarySoft,
                      foreground: palette.primary,
                    ),
                    _PreviewPill(
                      label: strings.ingredient_search_preview_tomatoes,
                      icon: Icons.check_rounded,
                      background: palette.primarySoft,
                      foreground: palette.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  strings.ingredient_search_preview_filtered_by,
                  style: CulinaryEditorialType.body(
                    palette,
                    size: 10,
                    weight: FontWeight.w700,
                    color: palette.onSurfaceVariant,
                    letterSpacing: .7,
                  ),
                ),
                const SizedBox(height: 9),
                Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: [
                    _PreviewPill(
                      label: strings.ingredient_search_vegetarian,
                      icon: Icons.eco_rounded,
                      background: palette.secondarySoft,
                      foreground: palette.secondary,
                    ),
                    _PreviewPill(
                      label: strings.ingredient_search_minutes(30),
                      icon: Icons.schedule_rounded,
                      background: palette.surfaceContainer,
                      foreground: palette.onSurfaceVariant,
                    ),
                    _PreviewPill(
                      label: strings.ingredient_search_preview_effort_cap,
                      icon: Icons.local_fire_department_rounded,
                      background: palette.tertiarySoft,
                      foreground: palette.tertiary,
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: palette.surfaceContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'images/randomFood.jpg',
                            width: 68,
                            height: 68,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                strings.ingredient_search_preview_example,
                                style: CulinaryEditorialType.body(
                                  palette,
                                  size: 10,
                                  weight: FontWeight.w700,
                                  color: palette.primary,
                                  letterSpacing: .6,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                strings
                                    .ingredient_search_preview_example_recipe,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: CulinaryEditorialType.headline(
                                  palette,
                                  size: 18,
                                  weight: FontWeight.w600,
                                  height: 1.16,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                strings.ingredient_search_match_summary(2, 3),
                                style: CulinaryEditorialType.body(
                                  palette,
                                  size: 11,
                                  weight: FontWeight.w600,
                                  color: palette.secondary,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '${strings.ingredient_search_preview_recipe_time} · '
                                '${strings.ingredient_search_effort_value(3)}',
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
        ),
      ),
    );
  }
}

class _PreviewPill extends StatelessWidget {
  const _PreviewPill({
    required this.label,
    required this.icon,
    required this.background,
    required this.foreground,
  });

  final String label;
  final IconData icon;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: foreground),
            const SizedBox(width: 5),
            Text(
              label,
              style: CulinaryEditorialType.body(
                palette,
                size: 11,
                weight: FontWeight.w700,
                color: foreground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BenefitList extends StatelessWidget {
  const _BenefitList();

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    return Column(
      children: [
        _BenefitRow(
          icon: Icons.menu_book_rounded,
          title: strings.ingredient_search_preview_own_title,
          description: strings.ingredient_search_preview_own_description,
        ),
        const SizedBox(height: 18),
        _BenefitRow(
          icon: Icons.tune_rounded,
          title: strings.ingredient_search_preview_refine_title,
          description: strings.ingredient_search_preview_refine_description,
        ),
        const SizedBox(height: 18),
        _BenefitRow(
          icon: Icons.bookmark_add_outlined,
          title: strings.ingredient_search_preview_save_title,
          description: strings.ingredient_search_preview_save_description,
        ),
      ],
    );
  }
}

class _BenefitRow extends StatelessWidget {
  const _BenefitRow({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: palette.primarySoft,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 21, color: palette.primary),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: CulinaryEditorialType.body(
                  palette,
                  size: 14,
                  weight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                description,
                style: CulinaryEditorialType.body(
                  palette,
                  size: 13,
                  color: palette.onSurfaceVariant,
                  height: 1.42,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProBenefitCallout extends StatelessWidget {
  const _ProBenefitCallout();

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.primarySoft,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.workspace_premium_rounded,
              size: 23,
              color: palette.primary,
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).ingredient_search_preview_pro_title,
                    style: CulinaryEditorialType.body(
                      palette,
                      size: 13,
                      weight: FontWeight.w700,
                      color: palette.primary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    S.of(context).ingredient_search_preview_pro_description,
                    style: CulinaryEditorialType.body(
                      palette,
                      size: 12,
                      color: palette.onSurfaceVariant,
                      height: 1.42,
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

class _PurchaseBar extends StatelessWidget {
  const _PurchaseBar({required this.onPurchase});

  final VoidCallback onPurchase;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Material(
      color: palette.surface,
      elevation: 8,
      shadowColor: palette.shadow,
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(20, 12, 20, 12),
        child: Center(
          heightFactor: 1,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton.icon(
                    key: const Key('ingredient-search-preview-purchase'),
                    onPressed: onPurchase,
                    iconAlignment: IconAlignment.end,
                    icon: const Icon(Icons.arrow_forward_rounded, size: 20),
                    label: Text(S.of(context).ingredient_search_preview_unlock),
                    style: FilledButton.styleFrom(
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
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  S.of(context).ingredient_search_preview_unlock_description,
                  textAlign: TextAlign.center,
                  style: CulinaryEditorialType.body(
                    palette,
                    size: 10,
                    color: palette.onSurfaceVariant,
                    height: 1.3,
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
