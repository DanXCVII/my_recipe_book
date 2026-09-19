import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';

import '../ad_related/ad.dart';
import '../blocs/splash_screen/splash_screen_bloc.dart';
import '../constants/brand_assets.dart';
import '../constants/routes.dart';
import '../generated/l10n.dart';
import '../widgets/culinary_editorial_theme.dart';
import 'homepage_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final Future<String?> _version;

  @override
  void initState() {
    super.initState();
    _version = _loadVersion();
    Future<void>.delayed(const Duration(milliseconds: 1200)).then((_) {
      if (mounted) context.read<SplashScreenBloc>().add(SPFinished());
    });
  }

  Future<String?> _loadVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      return info.version.isEmpty ? null : 'v${info.version}';
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.sizeOf(context).width >= 468) {
      Ads.showWideBannerAds();
    }

    return BlocConsumer<SplashScreenBloc, SplashScreenState>(
      listener: (context, state) {
        if (state is InitializedData) {
          Future<void>.delayed(const Duration(milliseconds: 100)).then((_) {
            if (!context.mounted) return;
            Navigator.popAndPushNamed(
              context,
              RouteNames.home,
              arguments: MyHomePageArguments(
                context,
                state.showShoppingCartSummary,
                state.recipeCategoryOverview,
              ),
            );
            if (state.showIntro ?? false) {
              Navigator.of(context).pushNamed(RouteNames.intro);
            }
          });
        }
      },
      builder: (context, state) => FutureBuilder<String?>(
        future: _version,
        builder: (context, snapshot) => SplashScreenView(
          state: state,
          version: snapshot.data,
          onRetry: () =>
              context.read<SplashScreenBloc>().add(SPRetryMigration(context)),
          onShareReport: state is StorageMigrationFailed
              ? () => SharePlus.instance.share(
                  ShareParams(
                    text:
                        'My Recipe Book storage migration failed: ${state.errorCode}',
                  ),
                )
              : null,
        ),
      ),
    );
  }
}

/// The visual splash surface, separated from startup orchestration so every
/// initialization state can be covered by widget tests.
class SplashScreenView extends StatelessWidget {
  const SplashScreenView({
    super.key,
    required this.state,
    required this.version,
    this.onRetry,
    this.onShareReport,
  });

  final SplashScreenState state;
  final String? version;
  final VoidCallback? onRetry;
  final VoidCallback? onShareReport;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final light = Theme.of(context).brightness == Brightness.light;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      key: const Key('splash-system-overlay'),
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: light ? Brightness.dark : Brightness.light,
        statusBarBrightness: light ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: palette.background,
        systemNavigationBarIconBrightness: light
            ? Brightness.dark
            : Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: palette.background,
        body: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              const _AmbientBackground(),
              LayoutBuilder(
                builder: (context, constraints) {
                  final compactHeight = constraints.maxHeight < 650;
                  final expanded = constraints.maxWidth >= 600;
                  final horizontalPadding = expanded ? 40.0 : 24.0;
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          horizontalPadding,
                          compactHeight ? 16 : 24,
                          horizontalPadding,
                          compactHeight ? 16 : 20,
                        ),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: expanded ? 520 : 420,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const _EstablishedCrest(),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: compactHeight ? 24 : 42,
                                  ),
                                  child: _BrandLockup(
                                    compact: compactHeight,
                                    expanded: expanded,
                                  ),
                                ),
                                _LoadingStatus(
                                  state: state,
                                  version: version,
                                  onRetry: onRetry,
                                  onShareReport: onShareReport,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AmbientBackground extends StatelessWidget {
  const _AmbientBackground();

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            left: -110,
            top: -110,
            child: _AmbientGlow(color: palette.primarySoft, size: 330),
          ),
          Positioned(
            right: -120,
            bottom: -120,
            child: _AmbientGlow(color: palette.secondarySoft, size: 360),
          ),
          Align(
            alignment: const Alignment(0, -0.05),
            child: _AmbientGlow(
              color: palette.primarySoft,
              size: 300,
              opacity: 0.34,
            ),
          ),
        ],
      ),
    );
  }
}

class _AmbientGlow extends StatelessWidget {
  const _AmbientGlow({
    required this.color,
    required this.size,
    this.opacity = 0.5,
  });

  final Color color;
  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withValues(alpha: opacity),
              color.withValues(alpha: 0),
            ],
          ),
        ),
      ),
    );
  }
}

class _EstablishedCrest extends StatelessWidget {
  const _EstablishedCrest();

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: palette.shadow,
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.restaurant_menu, size: 15, color: palette.primary),
            const SizedBox(width: 7),
            Text(
              S.of(context).splash_established,
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                color: palette.onSurfaceVariant,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BrandLockup extends StatelessWidget {
  const _BrandLockup({required this.compact, required this.expanded});

  final bool compact;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final emblemSize = compact
        ? 112.0
        : expanded
        ? 160.0
        : 136.0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(
          label: S.of(context).recipe_bible,
          image: true,
          child: ExcludeSemantics(
            child: SizedBox.square(
              key: const Key('splash-emblem'),
              dimension: emblemSize,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: palette.surface,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: palette.shadow.withValues(alpha: 0.35),
                            blurRadius: 28,
                            spreadRadius: 2,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(13),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(19),
                          child: Image.asset(
                            BrandAssets.detailedLogo,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: -7,
                    right: 22,
                    child: Container(
                      width: 19,
                      height: 32,
                      decoration: BoxDecoration(
                        color: palette.primary,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(3),
                          bottomRight: Radius.circular(3),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x30000000),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      alignment: const Alignment(0, 0.68),
                      child: Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: palette.surface.withValues(alpha: 0.78),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: compact ? 24 : 34),
        Text(
          S.of(context).recipe_bible,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'PlayfairDisplay',
            color: palette.onSurface,
            fontSize: compact
                ? 30
                : expanded
                ? 40
                : 36,
            fontWeight: FontWeight.w600,
            height: 1.15,
            letterSpacing: -0.7,
          ),
        ),
        const SizedBox(height: 13),
        const _FlameDivider(),
        const SizedBox(height: 13),
        Text(
          S.of(context).splash_subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'PlayfairDisplay',
            color: palette.onSurfaceVariant,
            fontSize: compact
                ? 16
                : expanded
                ? 20
                : 18,
            fontStyle: FontStyle.italic,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}

class _FlameDivider extends StatelessWidget {
  const _FlameDivider();

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 38,
          child: Divider(
            color: palette.outline.withValues(alpha: 0.45),
            height: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Icon(
            Icons.local_fire_department,
            color: palette.primary,
            size: 18,
          ),
        ),
        SizedBox(
          width: 38,
          child: Divider(
            color: palette.outline.withValues(alpha: 0.45),
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _LoadingStatus extends StatelessWidget {
  const _LoadingStatus({
    required this.state,
    required this.version,
    this.onRetry,
    this.onShareReport,
  });

  final SplashScreenState state;
  final String? version;
  final VoidCallback? onRetry;
  final VoidCallback? onShareReport;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final dark = Theme.of(context).brightness == Brightness.dark;
    final errorColor = dark ? const Color(0xFFFFB4AB) : const Color(0xFF93000A);
    final migration = state is MigratingData ? state as MigratingData : null;
    final failure = state is StorageMigrationFailed;
    final hasProgress = migration != null && migration.progress.total > 0;
    final double? progress = hasProgress
        ? (migration.progress.current / migration.progress.total).clamp(
            0.0,
            1.0,
          )
        : failure
        ? 0
        : null;
    final statusText = failure
        ? S.of(context).splash_migration_failed
        : migration != null
        ? S.of(context).splash_migrating
        : S.of(context).splash_loading;

    return Semantics(
      container: true,
      liveRegion: true,
      label: statusText,
      value: hasProgress ? '${(progress! * 100).round()}%' : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                Icons.soup_kitchen_outlined,
                key: const Key('splash-static-loading-icon'),
                color: palette.primary,
                size: 19,
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  statusText,
                  key: const Key('splash-loading-label'),
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    color: failure ? errorColor : palette.onSurfaceVariant,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              if (hasProgress)
                Text(
                  '${(progress! * 100).round()}%',
                  key: const Key('splash-progress-percentage'),
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    color: palette.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 11),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              key: const Key('splash-progress-bar'),
              value: progress,
              minHeight: 6,
              backgroundColor: palette.surfaceContainerHigh,
              color: failure
                  ? palette.outline.withValues(alpha: 0.45)
                  : palette.primary,
            ),
          ),
          if (failure) ...[
            const SizedBox(height: 16),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              runSpacing: 10,
              children: [
                FilledButton(
                  key: const Key('splash-retry-action'),
                  onPressed: onRetry,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(112, 48),
                    backgroundColor: palette.primary,
                    foregroundColor: palette.onPrimary,
                    textStyle: const TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: Text(S.of(context).splash_retry),
                ),
                OutlinedButton.icon(
                  key: const Key('splash-share-action'),
                  onPressed: onShareReport,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(144, 48),
                    foregroundColor: palette.primary,
                    side: BorderSide(color: palette.outline),
                    textStyle: const TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  icon: const Icon(Icons.share_outlined, size: 18),
                  label: Text(S.of(context).splash_share_report),
                ),
              ],
            ),
          ],
          if (version != null) ...[
            const SizedBox(height: 18),
            Text(
              version!,
              key: const Key('splash-version'),
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                color: palette.outline,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.7,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
