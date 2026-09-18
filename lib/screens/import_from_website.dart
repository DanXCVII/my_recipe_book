import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../ad_related/ad.dart';
import '../blocs/ad_manager/ad_manager_bloc.dart';
import '../blocs/recipe_calendar/recipe_calendar_bloc.dart';
import '../blocs/shopping_cart/shopping_cart_bloc.dart';
import '../blocs/website_import/website_import_bloc.dart';
import '../constants/routes.dart';
import '../generated/l10n.dart';
import '../widgets/culinary_editorial_theme.dart';
import 'add_recipe/general_info_screen/general_info_screen.dart';

class ImportFromWebsiteArguments {
  final ShoppingCartBloc shoppingCartBloc;
  final RecipeCalendarBloc recipeCalendarBloc;
  final AdManagerBloc adManagerBloc;
  final String? initialWebsite;

  ImportFromWebsiteArguments(
    this.shoppingCartBloc,
    this.recipeCalendarBloc,
    this.adManagerBloc, {
    this.initialWebsite,
  });
}

class ImportFromWebsiteScreen extends StatefulWidget {
  final String initialWebsite;

  const ImportFromWebsiteScreen({this.initialWebsite = '', super.key});

  @override
  State<ImportFromWebsiteScreen> createState() =>
      _ImportFromWebsiteScreenState();
}

class _ImportFromWebsiteScreenState extends State<ImportFromWebsiteScreen> {
  static const _maxContentWidth = 760.0;

  late final TextEditingController _urlController;
  late final FocusNode _urlFocusNode;
  String? _urlError;
  bool _supportedWebsitesExpanded = false;
  bool _hideStatusUntilNextSubmission = false;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController(text: widget.initialWebsite);
    _urlFocusNode = FocusNode(debugLabel: 'website-import-url');
  }

  @override
  void dispose() {
    _urlController.dispose();
    _urlFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final editorialTheme = culinaryEditorialTheme(Theme.of(context), palette);

    return Theme(
      data: editorialTheme,
      child: BlocListener<WebsiteImportBloc, WebsiteImportState>(
        listener: _onImportStateChanged,
        child: Scaffold(
          key: const Key('website-import-screen'),
          backgroundColor: palette.background,
          resizeToAvoidBottomInset: true,
          body: CustomScrollView(
            key: const Key('website-import-scroll-view'),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: [
              SliverAppBar.large(
                pinned: true,
                backgroundColor: palette.background,
                surfaceTintColor: palette.surfaceContainerHigh,
                foregroundColor: palette.onSurface,
                title: Text(
                  S.of(context).import_from_website_short,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: CulinaryEditorialType.headline(
                    palette,
                    size: 30,
                    weight: FontWeight.w600,
                    height: 1.08,
                  ),
                ),
              ),
              SliverSafeArea(
                top: false,
                sliver: SliverToBoxAdapter(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: _maxContentWidth,
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          MediaQuery.sizeOf(context).width >= 600 ? 28 : 20,
                          12,
                          MediaQuery.sizeOf(context).width >= 600 ? 28 : 20,
                          32,
                        ),
                        child:
                            BlocBuilder<WebsiteImportBloc, WebsiteImportState>(
                              builder: (context, state) => _ImportWorkspace(
                                controller: _urlController,
                                focusNode: _urlFocusNode,
                                urlError: _urlError,
                                state: state,
                                showStatus: !_hideStatusUntilNextSubmission,
                                supportedWebsitesExpanded:
                                    _supportedWebsitesExpanded,
                                onUrlChanged: _onUrlChanged,
                                onSubmit: () => _submit(state),
                                onSupportedWebsitesExpansionChanged:
                                    _setSupportedWebsitesExpanded,
                                onOpenWebsite: _openWebsite,
                              ),
                            ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onUrlChanged(String value) {
    if (_urlError == null && _hideStatusUntilNextSubmission) return;
    setState(() {
      _urlError = null;
      _hideStatusUntilNextSubmission = true;
    });
  }

  void _submit(WebsiteImportState state) {
    if (state is ImportingRecipe) return;

    final url = _urlController.text.trim();
    final parsed = Uri.tryParse(url);
    final isValid =
        parsed != null &&
        (parsed.scheme == 'http' || parsed.scheme == 'https') &&
        parsed.host.isNotEmpty;

    if (!isValid) {
      setState(() {
        _urlError = S.of(context).website_import_invalid_url_input;
        _hideStatusUntilNextSubmission = true;
      });
      _urlFocusNode.requestFocus();
      return;
    }

    _urlController.value = TextEditingValue(
      text: url,
      selection: TextSelection.collapsed(offset: url.length),
    );
    setState(() {
      _urlError = null;
      _hideStatusUntilNextSubmission = false;
    });
    _urlFocusNode.unfocus();
    context.read<WebsiteImportBloc>().add(ImportRecipe(url));
  }

  void _setSupportedWebsitesExpanded(bool expanded) {
    if (_supportedWebsitesExpanded == expanded) return;
    setState(() => _supportedWebsitesExpanded = expanded);
  }

  Future<void> _openWebsite(_SupportedWebsite website) async {
    final opened = await launchUrl(
      Uri.parse(website.url),
      mode: LaunchMode.externalApplication,
    );
    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).website_import_link_failed)),
      );
    }
  }

  void _onImportStateChanged(BuildContext context, WebsiteImportState state) {
    if (state is InvalidUrl || state is FailedImportingRecipe) {
      _setSupportedWebsitesExpanded(true);
    }

    if (state is! ImportedRecipe) return;

    imageCache.clear();
    context.read<AdManagerBloc>().add(LoadVideo());
    Navigator.pushNamed(
      context,
      RouteNames.addRecipeGeneralInfo,
      arguments: GeneralInfoArguments(
        state.recipe,
        context.read<ShoppingCartBloc>(),
        context.read<RecipeCalendarBloc>(),
      ),
    ).then((_) => Ads.hideBottomBannerAd());
  }
}

class _ImportWorkspace extends StatelessWidget {
  const _ImportWorkspace({
    required this.controller,
    required this.focusNode,
    required this.urlError,
    required this.state,
    required this.showStatus,
    required this.supportedWebsitesExpanded,
    required this.onUrlChanged,
    required this.onSubmit,
    required this.onSupportedWebsitesExpansionChanged,
    required this.onOpenWebsite,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String? urlError;
  final WebsiteImportState state;
  final bool showStatus;
  final bool supportedWebsitesExpanded;
  final ValueChanged<String> onUrlChanged;
  final VoidCallback onSubmit;
  final ValueChanged<bool> onSupportedWebsitesExpansionChanged;
  final ValueChanged<_SupportedWebsite> onOpenWebsite;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final strings = S.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          strings.website_import_intro_title,
          style: CulinaryEditorialType.headline(
            palette,
            size: 26,
            weight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          strings.website_import_intro_body,
          style: CulinaryEditorialType.body(
            palette,
            size: 15,
            color: palette.onSurfaceVariant,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 22),
        _ImportCard(
          controller: controller,
          focusNode: focusNode,
          urlError: urlError,
          state: state,
          showStatus: showStatus,
          onUrlChanged: onUrlChanged,
          onSubmit: onSubmit,
        ),
        const SizedBox(height: 16),
        _SupportedWebsites(
          expanded: supportedWebsitesExpanded,
          onExpansionChanged: onSupportedWebsitesExpansionChanged,
          onOpenWebsite: onOpenWebsite,
        ),
        const SizedBox(height: 16),
        const _BrowserShareTip(),
      ],
    );
  }
}

class _ImportCard extends StatelessWidget {
  const _ImportCard({
    required this.controller,
    required this.focusNode,
    required this.urlError,
    required this.state,
    required this.showStatus,
    required this.onUrlChanged,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String? urlError;
  final WebsiteImportState state;
  final bool showStatus;
  final ValueChanged<String> onUrlChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final strings = S.of(context);
    final importing = state is ImportingRecipe;
    final retrying =
        state is FailedToConnect ||
        state is InvalidUrl ||
        state is FailedImportingRecipe;
    final motionDuration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : const Duration(milliseconds: 180);

    return DecoratedBox(
      key: const Key('website-import-card'),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: palette.shadow,
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              key: const Key('website-import-url-field'),
              controller: controller,
              focusNode: focusNode,
              enabled: !importing,
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.go,
              autocorrect: false,
              enableSuggestions: false,
              smartDashesType: SmartDashesType.disabled,
              smartQuotesType: SmartQuotesType.disabled,
              onChanged: onUrlChanged,
              onSubmitted: importing ? null : (_) => onSubmit(),
              decoration: InputDecoration(
                labelText: strings.website_import_field_label,
                hintText: strings.website_import_field_hint,
                errorText: urlError,
                prefixIcon: const Icon(Icons.link_rounded),
              ),
            ),
            const SizedBox(height: 14),
            FilledButton(
              key: const Key('website-import-submit'),
              onPressed: importing ? null : onSubmit,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                backgroundColor: palette.primary,
                foregroundColor: palette.onPrimary,
                disabledBackgroundColor: palette.surfaceContainerHigh,
                disabledForegroundColor: palette.onSurfaceVariant,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: CulinaryEditorialType.body(
                  palette,
                  size: 14,
                  weight: FontWeight.w700,
                  color: importing
                      ? palette.onSurfaceVariant
                      : palette.onPrimary,
                ),
              ),
              child: importing
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(
                            key: const Key('website-import-progress'),
                            strokeWidth: 2.2,
                            color: palette.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(child: Text(strings.website_import_loading)),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.download_rounded, size: 21),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            retrying
                                ? strings.website_import_try_again
                                : strings.website_import_action,
                          ),
                        ),
                      ],
                    ),
            ),
            AnimatedSwitcher(
              duration: motionDuration,
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: SizeTransition(
                  sizeFactor: animation,
                  alignment: Alignment.topCenter,
                  child: child,
                ),
              ),
              child: showStatus
                  ? _WebsiteImportStatus(state: state)
                  : const SizedBox.shrink(
                      key: Key('website-import-status-hidden'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WebsiteImportStatus extends StatelessWidget {
  const _WebsiteImportStatus({required this.state});

  final WebsiteImportState state;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final scheme = Theme.of(context).colorScheme;
    final strings = S.of(context);

    final _StatusContent? content = switch (state) {
      ImportingRecipe() => _StatusContent(
        key: 'loading',
        icon: Icons.auto_stories_rounded,
        title: strings.website_import_loading,
        body: strings.website_import_loading_body,
        background: palette.primarySoft,
        foreground: palette.primary,
      ),
      FailedToConnect() => _StatusContent(
        key: 'connection',
        icon: Icons.wifi_off_rounded,
        title: strings.website_import_connection_title,
        body: strings.website_import_connection_body,
        background: scheme.errorContainer,
        foreground: scheme.onErrorContainer,
      ),
      InvalidUrl() => _StatusContent(
        key: 'unsupported',
        icon: Icons.link_off_rounded,
        title: strings.website_import_unsupported_title,
        body: strings.website_import_unsupported_body,
        background: scheme.errorContainer,
        foreground: scheme.onErrorContainer,
      ),
      FailedImportingRecipe() => _StatusContent(
        key: 'failed',
        icon: Icons.error_outline_rounded,
        title: strings.website_import_failed_title,
        body: strings.website_import_failed_body,
        background: scheme.errorContainer,
        foreground: scheme.onErrorContainer,
      ),
      AlreadyExists(:final recipeName) => _StatusContent(
        key: 'duplicate',
        icon: Icons.content_copy_rounded,
        title: strings.website_import_duplicate_title,
        body: strings.recipe_already_exists(recipeName),
        background: palette.tertiarySoft,
        foreground: palette.tertiary,
      ),
      _ => null,
    };

    if (content == null) {
      return const SizedBox.shrink(key: Key('website-import-status-empty'));
    }

    return Padding(
      key: ValueKey('website-import-status-${content.key}'),
      padding: const EdgeInsets.only(top: 14),
      child: Semantics(
        container: true,
        liveRegion: true,
        label: '${content.title}. ${content.body}',
        excludeSemantics: true,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: content.background,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(content.icon, color: content.foreground, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        content.title,
                        style: CulinaryEditorialType.body(
                          palette,
                          size: 14,
                          weight: FontWeight.w700,
                          color: content.foreground,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        content.body,
                        style: CulinaryEditorialType.body(
                          palette,
                          size: 13,
                          color: content.foreground,
                          height: 1.45,
                        ),
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

class _StatusContent {
  const _StatusContent({
    required this.key,
    required this.icon,
    required this.title,
    required this.body,
    required this.background,
    required this.foreground,
  });

  final String key;
  final IconData icon;
  final String title;
  final String body;
  final Color background;
  final Color foreground;
}

class _SupportedWebsites extends StatelessWidget {
  const _SupportedWebsites({
    required this.expanded,
    required this.onExpansionChanged,
    required this.onOpenWebsite,
  });

  static const websites = [
    _SupportedWebsite('EN · allrecipes.com', 'https://www.allrecipes.com/'),
    _SupportedWebsite('EN · food.com', 'https://www.food.com/'),
    _SupportedWebsite('DE · chefkoch.de', 'https://www.chefkoch.de'),
    _SupportedWebsite('DE · lecker.de', 'https://www.lecker.de'),
    _SupportedWebsite('DE · kochbar.de', 'https://www.kochbar.de/'),
    _SupportedWebsite(
      'DE · essen-und-trinken.de',
      'https://www.essen-und-trinken.de/',
    ),
    _SupportedWebsite('DE · eatsmarter.de', 'https://eatsmarter.de/'),
  ];

  final bool expanded;
  final ValueChanged<bool> onExpansionChanged;
  final ValueChanged<_SupportedWebsite> onOpenWebsite;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final strings = S.of(context);
    final duration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : const Duration(milliseconds: 180);

    return Material(
      key: const Key('website-import-supported-sites'),
      color: palette.surfaceContainer,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            button: true,
            expanded: expanded,
            label: strings.supported_websites,
            hint: expanded
                ? strings.website_import_collapse_sites
                : strings.website_import_expand_sites,
            excludeSemantics: true,
            child: InkWell(
              key: const Key('website-import-supported-toggle'),
              onTap: () => onExpansionChanged(!expanded),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 64),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 10, 10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.language_rounded,
                        color: palette.onSurfaceVariant,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          strings.supported_websites,
                          style: CulinaryEditorialType.body(
                            palette,
                            size: 14,
                            weight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox.square(
                        dimension: 48,
                        child: Center(
                          child: AnimatedRotation(
                            duration: duration,
                            turns: expanded ? .5 : 0,
                            child: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          AnimatedSize(
            duration: duration,
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: expanded
                ? Column(
                    key: const Key('website-import-supported-list'),
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Divider(
                        height: 1,
                        color: palette.outline.withValues(alpha: .22),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                        child: Text(
                          strings.standardized_format,
                          style: CulinaryEditorialType.body(
                            palette,
                            size: 13,
                            color: palette.onSurfaceVariant,
                            height: 1.45,
                          ),
                        ),
                      ),
                      for (final website in websites)
                        ListTile(
                          key: ValueKey('website-import-site-${website.url}'),
                          minTileHeight: 48,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          title: Text(
                            website.label,
                            style: CulinaryEditorialType.body(
                              palette,
                              size: 14,
                              weight: FontWeight.w600,
                              color: palette.primary,
                            ),
                          ),
                          trailing: Icon(
                            Icons.open_in_new_rounded,
                            color: palette.primary,
                            size: 20,
                          ),
                          onTap: () => onOpenWebsite(website),
                        ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        child: Text(
                          strings.and_many_more,
                          style: CulinaryEditorialType.body(
                            palette,
                            size: 13,
                            weight: FontWeight.w700,
                            color: palette.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _BrowserShareTip extends StatelessWidget {
  const _BrowserShareTip();

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final strings = S.of(context);

    return DecoratedBox(
      key: const Key('website-import-share-tip'),
      decoration: BoxDecoration(
        color: palette.primarySoft,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.share_rounded, color: palette.primary, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    strings.website_import_share_tip_title,
                    style: CulinaryEditorialType.body(
                      palette,
                      size: 14,
                      weight: FontWeight.w700,
                      color: palette.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    strings.website_import_info,
                    style: CulinaryEditorialType.body(
                      palette,
                      size: 13,
                      color: palette.primary,
                      height: 1.45,
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

class _SupportedWebsite {
  const _SupportedWebsite(this.label, this.url);

  final String label;
  final String url;
}
