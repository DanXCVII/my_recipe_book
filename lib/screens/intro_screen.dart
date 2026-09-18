import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/global_settings.dart';
import '../generated/l10n.dart';
import '../widgets/culinary_editorial_theme.dart';
import '../widgets/onboarding/editorial_onboarding.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  static const _pageCount = 4;

  late final PageController _controller;
  int _page = 0;
  bool _allowPop = false;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _reduceMotion =>
      !GlobalSettings().animationsEnabled() ||
      MediaQuery.disableAnimationsOf(context);

  void _close() {
    if (_page == 0) {
      Navigator.of(context).pop();
      return;
    }
    setState(() => _allowPop = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) Navigator.of(context).pop();
    });
  }

  void _goTo(int page) {
    if (page < 0 || page >= _pageCount) return;
    if (_reduceMotion) {
      _controller.jumpToPage(page);
      return;
    }
    _controller.animateToPage(
      page,
      duration: const Duration(milliseconds: 340),
      curve: Curves.easeOutCubic,
    );
  }

  void _next() {
    if (_page == _pageCount - 1) {
      _close();
    } else {
      _goTo(_page + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final dark = Theme.of(context).brightness == Brightness.dark;
    final strings = S.of(context);
    final editorialTheme = culinaryEditorialTheme(Theme.of(context), palette);

    return Theme(
      data: editorialTheme,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: dark ? Brightness.light : Brightness.dark,
          statusBarBrightness: dark ? Brightness.dark : Brightness.light,
          systemNavigationBarColor: palette.background,
          systemNavigationBarIconBrightness: dark
              ? Brightness.light
              : Brightness.dark,
        ),
        child: PopScope<Object?>(
          canPop: _allowPop || _page == 0,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop && _page > 0) _goTo(_page - 1);
          },
          child: Scaffold(
            key: const Key('onboarding-screen'),
            backgroundColor: palette.background,
            body: SafeArea(
              child: Column(
                children: [
                  _OnboardingHeader(onSkip: _close),
                  Expanded(
                    child: PageView(
                      key: const Key('onboarding-pager'),
                      controller: _controller,
                      physics: const NeverScrollableScrollPhysics(),
                      onPageChanged: (page) => setState(() => _page = page),
                      children: [
                        EditorialOnboardingPage(
                          key: const Key('onboarding-effort-page'),
                          title: strings.onboarding_effort_title,
                          description: strings.onboarding_effort_description,
                          child: EffortOnboardingDemo(isActive: _page == 0),
                        ),
                        EditorialOnboardingPage(
                          key: const Key('onboarding-cook-page'),
                          title: strings.onboarding_cook_title,
                          description: strings.onboarding_cook_description,
                          child: CookModeOnboardingDemo(isActive: _page == 1),
                        ),
                        EditorialOnboardingPage(
                          key: const Key('onboarding-pantry-page'),
                          title: strings.onboarding_pantry_title,
                          description: strings.onboarding_pantry_description,
                          child: PantryOnboardingDemo(isActive: _page == 2),
                        ),
                        EditorialOnboardingPage(
                          key: const Key('onboarding-explore-page'),
                          title: strings.onboarding_explore_title,
                          description: strings.onboarding_explore_description,
                          child: ExploreOnboardingDemo(isActive: _page == 3),
                        ),
                      ],
                    ),
                  ),
                  _OnboardingFooter(
                    page: _page,
                    pageCount: _pageCount,
                    onBack: _page == 0 ? null : () => _goTo(_page - 1),
                    onNext: _next,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OnboardingHeader extends StatelessWidget {
  const _OnboardingHeader({required this.onSkip});

  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 64),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        child: Row(
          children: [
            Expanded(
              child: Text(
                S.of(context).recipe_bible,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: CulinaryEditorialType.headline(
                  palette,
                  size: 23,
                  weight: FontWeight.w600,
                ).copyWith(color: palette.primary),
              ),
            ),
            TextButton(
              key: const Key('onboarding-skip'),
              onPressed: onSkip,
              style: TextButton.styleFrom(
                minimumSize: const Size(64, 48),
                foregroundColor: palette.onSurfaceVariant,
                textStyle: CulinaryEditorialType.body(
                  palette,
                  size: 13,
                  weight: FontWeight.w700,
                ),
              ),
              child: Text(S.of(context).skip),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingFooter extends StatelessWidget {
  const _OnboardingFooter({
    required this.page,
    required this.pageCount,
    required this.onBack,
    required this.onNext,
  });

  final int page;
  final int pageCount;
  final VoidCallback? onBack;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final strings = S.of(context);
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.surface,
        boxShadow: [
          BoxShadow(
            color: palette.shadow,
            blurRadius: 18,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(
              label: strings.onboarding_progress(page + 1, pageCount),
              child: ExcludeSemantics(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(pageCount, (index) {
                    final current = index == page;
                    final complete = index < page;
                    return AnimatedContainer(
                      key: Key('onboarding-progress-$index'),
                      duration: reduceMotion
                          ? Duration.zero
                          : const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      width: current ? 26 : 8,
                      height: 7,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: current
                            ? palette.primary
                            : complete
                            ? palette.secondary
                            : palette.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 7),
            Row(
              children: [
                if (onBack == null)
                  const SizedBox(width: 52, height: 52)
                else
                  TextButton.icon(
                    key: const Key('onboarding-back'),
                    onPressed: onBack,
                    icon: const Icon(Icons.arrow_back_rounded, size: 19),
                    label: Text(strings.back),
                    style: TextButton.styleFrom(
                      minimumSize: const Size(76, 52),
                      foregroundColor: palette.onSurfaceVariant,
                      textStyle: CulinaryEditorialType.body(
                        palette,
                        size: 13,
                        weight: FontWeight.w700,
                      ),
                    ),
                  ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton.icon(
                    key: const Key('onboarding-next'),
                    onPressed: onNext,
                    iconAlignment: IconAlignment.end,
                    icon: const Icon(Icons.arrow_forward_rounded, size: 19),
                    label: Text(
                      page == pageCount - 1
                          ? strings.onboarding_open_cookbook
                          : strings.onboarding_continue,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(0, 52),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      backgroundColor: palette.primary,
                      foregroundColor: palette.onPrimary,
                      textStyle: CulinaryEditorialType.body(
                        palette,
                        size: 13,
                        weight: FontWeight.w700,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
