import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/brand_assets.dart';
import '../generated/l10n.dart';
import '../widgets/culinary_editorial_theme.dart';

class AboutMeScreen extends StatefulWidget {
  const AboutMeScreen({super.key});

  @override
  State<AboutMeScreen> createState() => _AboutMeScreenState();
}

class _AboutMeScreenState extends State<AboutMeScreen> {
  static const _wideBreakpoint = 760.0;
  static const _maxContentWidth = 1040.0;
  static const _playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.release.my_recipe_book';
  static const _developerEmail = 'daniel.weissen.developer@gmail.com';

  late final Future<PackageInfo?> _packageInfo;

  @override
  void initState() {
    super.initState();
    _packageInfo = _loadPackageInfo();
  }

  Future<PackageInfo?> _loadPackageInfo() async {
    try {
      return await PackageInfo.fromPlatform();
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final editorialTheme = culinaryEditorialTheme(Theme.of(context), palette);

    return Theme(
      data: editorialTheme,
      child: Builder(
        builder: (context) {
          final lightTheme = Theme.of(context).brightness == Brightness.light;
          return Scaffold(
            key: const Key('about-support-screen'),
            backgroundColor: palette.background,
            appBar: AppBar(
              toolbarHeight: 72,
              elevation: 0,
              scrolledUnderElevation: 0,
              backgroundColor: palette.background,
              foregroundColor: palette.onSurface,
              surfaceTintColor: Colors.transparent,
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: lightTheme
                    ? Brightness.dark
                    : Brightness.light,
                statusBarBrightness: lightTheme
                    ? Brightness.light
                    : Brightness.dark,
              ),
              leadingWidth: 68,
              leading: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: IconButton(
                  key: const Key('about-back'),
                  tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                  onPressed: () => Navigator.maybePop(context),
                  style: IconButton.styleFrom(
                    minimumSize: const Size.square(48),
                    backgroundColor: palette.surfaceContainer,
                    foregroundColor: palette.onSurfaceVariant,
                  ),
                  icon: const Icon(Icons.arrow_back_rounded, size: 21),
                ),
              ),
              titleSpacing: 8,
              title: Text(
                S.of(context).about_title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: CulinaryEditorialType.headline(
                  palette,
                  size: 27,
                  weight: FontWeight.w600,
                  height: 1.08,
                ),
              ),
            ),
            body: SafeArea(
              top: false,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final wide = constraints.maxWidth >= _wideBreakpoint;
                  return SingleChildScrollView(
                    key: const Key('about-support-scroll-view'),
                    padding: EdgeInsets.fromLTRB(
                      wide ? 28 : 20,
                      14,
                      wide ? 28 : 20,
                      32,
                    ),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: _maxContentWidth,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (wide)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Expanded(flex: 5, child: _AboutHero()),
                                  const SizedBox(width: 24),
                                  Expanded(
                                    flex: 6,
                                    child: _SupportSection(
                                      onShare: _shareApp,
                                      onRate: _rateApp,
                                      onContact: _contactDeveloper,
                                    ),
                                  ),
                                ],
                              )
                            else ...[
                              const _AboutHero(),
                              const SizedBox(height: 28),
                              _SupportSection(
                                onShare: _shareApp,
                                onRate: _rateApp,
                                onContact: _contactDeveloper,
                              ),
                            ],
                            const SizedBox(height: 28),
                            _DetailsSection(
                              packageInfo: _packageInfo,
                              onLicenses: _openLicenses,
                              onDisclaimer: _showDisclaimer,
                            ),
                            const SizedBox(height: 30),
                            const _MakerSignature(),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _shareApp() async {
    try {
      final renderBox = context.findRenderObject() as RenderBox?;
      final shareOrigin = renderBox == null
          ? null
          : renderBox.localToGlobal(Offset.zero) & renderBox.size;
      await SharePlus.instance.share(
        ShareParams(
          text: S.of(context).share_this_app_desc(_playStoreUrl),
          subject: S.of(context).share_this_app_title,
          sharePositionOrigin: shareOrigin,
        ),
      );
    } catch (_) {
      _showError(S.of(context).about_share_failed);
    }
  }

  Future<void> _rateApp() async {
    try {
      final opened = await launchUrl(
        Uri.parse(_playStoreUrl),
        mode: LaunchMode.externalApplication,
      );
      if (!opened) _showError(S.of(context).about_rate_failed);
    } catch (_) {
      _showError(S.of(context).about_rate_failed);
    }
  }

  Future<void> _contactDeveloper() async {
    try {
      final opened = await launchUrl(
        Uri(scheme: 'mailto', path: _developerEmail),
      );
      if (!opened) _showError(S.of(context).about_contact_failed);
    } catch (_) {
      _showError(S.of(context).about_contact_failed);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    final palette = CulinaryEditorialPalette.of(context);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: palette.onSurface,
          content: Text(
            message,
            style: CulinaryEditorialType.body(
              palette,
              size: 13,
              color: palette.surface,
              weight: FontWeight.w600,
            ),
          ),
        ),
      );
  }

  Future<void> _openLicenses() async {
    final info = await _packageInfo;
    if (!mounted) return;

    final palette = CulinaryEditorialPalette.of(context);
    final baseTheme = culinaryEditorialTheme(Theme.of(context), palette);
    final licenseTheme = baseTheme.copyWith(
      appBarTheme: baseTheme.appBarTheme.copyWith(
        toolbarHeight: 72,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: palette.background,
        foregroundColor: palette.onSurface,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: CulinaryEditorialType.headline(
          palette,
          size: 24,
          weight: FontWeight.w600,
        ),
      ),
    );

    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => Theme(
          data: licenseTheme,
          child: LicensePage(
            applicationName: S.of(context).recipe_bible,
            applicationVersion: info == null ? null : _formatVersion(info),
            applicationIcon: _AppIcon(size: 56, palette: palette),
          ),
        ),
      ),
    );
  }

  Future<void> _showDisclaimer() async {
    if (MediaQuery.sizeOf(context).width >= _wideBreakpoint) {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => Dialog(
          backgroundColor: CulinaryEditorialPalette.of(dialogContext).surface,
          surfaceTintColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(28),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 540, maxHeight: 620),
            child: const _DisclaimerContent(),
          ),
        ),
      );
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: CulinaryEditorialPalette.of(context).surface,
      constraints: const BoxConstraints(maxWidth: 640),
      builder: (_) => const FractionallySizedBox(
        heightFactor: .66,
        child: _DisclaimerContent(showTopPadding: false),
      ),
    );
  }

  static String _formatVersion(PackageInfo info) {
    return info.buildNumber.isEmpty
        ? info.version
        : '${info.version} (${info.buildNumber})';
  }
}

class _AboutHero extends StatelessWidget {
  const _AboutHero();

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Container(
      key: const Key('about-hero'),
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 26),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: palette.shadow,
            blurRadius: 18,
            spreadRadius: -3,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Column(
              key: const Key('about-identity-lockup'),
              mainAxisSize: MainAxisSize.min,
              children: [
                _AppIcon(size: 88, palette: palette),
                const SizedBox(height: 16),
                Text(
                  S.of(context).recipe_bible.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: CulinaryEditorialType.body(
                    palette,
                    size: 11,
                    weight: FontWeight.w700,
                    color: palette.primary,
                    letterSpacing: 1.1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            S.of(context).about_tagline,
            style: CulinaryEditorialType.headline(
              palette,
              size: 30,
              weight: FontWeight.w600,
              height: 1.14,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            S.of(context).about_description,
            style: CulinaryEditorialType.body(
              palette,
              size: 14,
              color: palette.onSurfaceVariant,
              height: 1.48,
            ),
          ),
        ],
      ),
    );
  }
}

class _AppIcon extends StatelessWidget {
  const _AppIcon({required this.size, required this.palette});

  final double size;
  final CulinaryEditorialPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * .12),
      decoration: BoxDecoration(
        color: palette.surfaceContainer,
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: Image.asset(
          BrandAssets.simplifiedLogo,
          fit: BoxFit.cover,
          semanticLabel: S.of(context).recipe_bible,
        ),
      ),
    );
  }
}

class _SupportSection extends StatelessWidget {
  const _SupportSection({
    required this.onShare,
    required this.onRate,
    required this.onContact,
  });

  final VoidCallback onShare;
  final VoidCallback onRate;
  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    return _AboutSection(
      title: strings.about_support_section,
      child: _GroupedSurface(
        children: [
          _AboutRow(
            key: const Key('about-share-action'),
            icon: Icons.ios_share_rounded,
            title: strings.about_share_title,
            description: strings.about_share_description,
            onTap: onShare,
          ),
          _AboutRow(
            key: const Key('about-rate-action'),
            icon: Icons.star_outline_rounded,
            title: strings.about_rate_title,
            description: strings.about_rate_description,
            onTap: onRate,
          ),
          _AboutRow(
            key: const Key('about-contact-action'),
            icon: Icons.mail_outline_rounded,
            title: strings.about_contact_title,
            description: strings.about_contact_description,
            onTap: onContact,
          ),
        ],
      ),
    );
  }
}

class _DetailsSection extends StatelessWidget {
  const _DetailsSection({
    required this.packageInfo,
    required this.onLicenses,
    required this.onDisclaimer,
  });

  final Future<PackageInfo?> packageInfo;
  final VoidCallback onLicenses;
  final VoidCallback onDisclaimer;

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    return _AboutSection(
      title: strings.about_details_section,
      child: _GroupedSurface(
        children: [
          FutureBuilder<PackageInfo?>(
            future: packageInfo,
            builder: (context, snapshot) {
              final loading = snapshot.connectionState != ConnectionState.done;
              final info = snapshot.data;
              final version = info == null
                  ? strings.about_version_unavailable
                  : _AboutMeScreenState._formatVersion(info);
              return _AboutRow(
                key: const Key('about-version-row'),
                icon: Icons.info_outline_rounded,
                title: strings.about_version_title,
                description: loading ? null : version,
                trailing: loading
                    ? const SizedBox.square(
                        key: Key('about-version-loading'),
                        dimension: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : null,
              );
            },
          ),
          _AboutRow(
            key: const Key('about-licenses-action'),
            icon: Icons.article_outlined,
            title: strings.about_licenses_title,
            description: strings.about_licenses_description,
            onTap: onLicenses,
          ),
          _AboutRow(
            key: const Key('about-disclaimer-action'),
            icon: Icons.gavel_outlined,
            title: strings.about_disclaimer_title,
            description: strings.about_disclaimer_summary,
            onTap: onDisclaimer,
          ),
        ],
      ),
    );
  }
}

class _AboutSection extends StatelessWidget {
  const _AboutSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title.toUpperCase(),
            style: CulinaryEditorialType.body(
              palette,
              size: 10,
              weight: FontWeight.w700,
              color: palette.outline,
              letterSpacing: 1,
            ),
          ),
        ),
        child,
      ],
    );
  }
}

class _GroupedSurface extends StatelessWidget {
  const _GroupedSurface({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Container(
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: palette.shadow,
            blurRadius: 16,
            spreadRadius: -3,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var index = 0; index < children.length; index++) ...[
            children[index],
            if (index != children.length - 1)
              Padding(
                padding: const EdgeInsets.only(left: 70, right: 14),
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: palette.surfaceContainer,
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _AboutRow extends StatelessWidget {
  const _AboutRow({
    required this.icon,
    required this.title,
    this.description,
    this.onTap,
    this.trailing,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? description;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final interactive = onTap != null;
    return MergeSemantics(
      child: Semantics(
        button: interactive,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 76),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: palette.surfaceContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        icon,
                        size: 21,
                        color: palette.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            style: CulinaryEditorialType.body(
                              palette,
                              size: 14,
                              weight: FontWeight.w700,
                            ),
                          ),
                          if (description != null) ...[
                            const SizedBox(height: 3),
                            Text(
                              description!,
                              style: CulinaryEditorialType.body(
                                palette,
                                size: 12,
                                color: palette.onSurfaceVariant,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (trailing != null) ...[
                      const SizedBox(width: 10),
                      trailing!,
                    ] else if (interactive) ...[
                      const SizedBox(width: 10),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 22,
                        color: palette.outline,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MakerSignature extends StatelessWidget {
  const _MakerSignature();

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Semantics(
      label: S.of(context).about_made_in_muenster,
      child: ExcludeSemantics(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_rounded, size: 15, color: palette.primary),
            const SizedBox(width: 7),
            Flexible(
              child: Text(
                S.of(context).about_made_in_muenster,
                textAlign: TextAlign.center,
                style: CulinaryEditorialType.body(
                  palette,
                  size: 11,
                  weight: FontWeight.w600,
                  color: palette.outline,
                  letterSpacing: .25,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DisclaimerContent extends StatelessWidget {
  const _DisclaimerContent({this.showTopPadding = true});

  final bool showTopPadding;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(24, showTopPadding ? 24 : 4, 24, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  S.of(context).about_disclaimer_title,
                  style: CulinaryEditorialType.headline(
                    palette,
                    size: 24,
                    weight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                key: const Key('about-disclaimer-close'),
                tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                onPressed: () => Navigator.pop(context),
                style: IconButton.styleFrom(
                  minimumSize: const Size.square(48),
                  backgroundColor: palette.surfaceContainer,
                  foregroundColor: palette.onSurfaceVariant,
                ),
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                S.of(context).disclaimer_description,
                style: CulinaryEditorialType.body(
                  palette,
                  size: 14,
                  color: palette.onSurfaceVariant,
                  height: 1.55,
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.tonal(
              style: FilledButton.styleFrom(
                minimumSize: const Size(96, 48),
                backgroundColor: palette.primarySoft,
                foregroundColor: palette.primary,
              ),
              onPressed: () => Navigator.pop(context),
              child: Text(S.of(context).alright),
            ),
          ),
        ],
      ),
    );
  }
}
