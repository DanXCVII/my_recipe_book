import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../generated/l10n.dart';
import 'culinary_editorial_theme.dart';

class RecipeCreationFabMenu extends StatefulWidget {
  const RecipeCreationFabMenu({
    super.key,
    required this.onCreateManually,
    required this.onImportFromWebsite,
    this.busy = false,
    this.busyLabel,
  });

  final VoidCallback onCreateManually;
  final VoidCallback onImportFromWebsite;
  final bool busy;
  final String? busyLabel;

  @override
  State<RecipeCreationFabMenu> createState() => _RecipeCreationFabMenuState();
}

enum _RecipeCreationAction { createManually, importFromWebsite }

class _RecipeCreationFabMenuState extends State<RecipeCreationFabMenu> {
  static const double _compactWidthBreakpoint = 340;
  static const double _compactHeightBreakpoint = 480;
  static const double _largeTextBreakpoint = 1.3;
  static const Duration _openDuration = Duration(milliseconds: 220);
  static const Duration _closeDuration = Duration(milliseconds: 160);

  final LayerLink _anchorLink = LayerLink();
  final GlobalKey _anchorKey = GlobalKey();
  final FocusNode _anchorFocusNode = FocusNode(
    debugLabel: 'recipe-creation-fab',
  );

  bool _menuOpen = false;

  @override
  void dispose() {
    _anchorFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final strings = S.of(context);
    final busyLabel = widget.busyLabel ?? strings.syncing_recipes_drive;

    return CompositedTransformTarget(
      link: _anchorLink,
      child: Opacity(
        key: const Key('recipe-creation-anchor-visibility'),
        opacity: _menuOpen ? 0 : 1,
        child: Semantics(
          key: const Key('recipe-creation-fab-semantics'),
          button: true,
          enabled: !widget.busy,
          expanded: _menuOpen,
          label: widget.busy ? busyLabel : strings.recipe_actions,
          value: _menuOpen
              ? strings.recipe_actions_expanded
              : strings.recipe_actions_collapsed,
          hint: widget.busy ? null : strings.recipe_actions_hint,
          liveRegion: widget.busy,
          excludeSemantics: true,
          onTap: widget.busy ? null : _showActions,
          child: Tooltip(
            message: widget.busy ? busyLabel : strings.add_recipe,
            child: FloatingActionButton.extended(
              key: _anchorKey,
              heroTag: null,
              focusNode: _anchorFocusNode,
              elevation: 6,
              focusElevation: 8,
              hoverElevation: 8,
              highlightElevation: 6,
              backgroundColor: widget.busy
                  ? palette.surfaceContainerHigh
                  : palette.primarySoft,
              foregroundColor: widget.busy
                  ? palette.onSurfaceVariant
                  : palette.primary,
              shape: const StadiumBorder(),
              extendedPadding: const EdgeInsetsDirectional.only(
                start: 18,
                end: 20,
              ),
              extendedIconLabelSpacing: 10,
              extendedTextStyle: CulinaryEditorialType.body(
                palette,
                size: 14,
                weight: FontWeight.w700,
                color: widget.busy ? palette.onSurfaceVariant : palette.primary,
              ),
              icon: widget.busy
                  ? SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: palette.onSurfaceVariant,
                      ),
                    )
                  : const Icon(Icons.edit_rounded, size: 24),
              label: Text(
                widget.busy ? busyLabel : strings.add_recipe,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onPressed: widget.busy ? null : _showActions,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showActions() async {
    if (_menuOpen || widget.busy) return;

    final mediaQuery = MediaQuery.of(context);
    final useBottomSheet =
        mediaQuery.size.width < _compactWidthBreakpoint ||
        mediaQuery.size.height < _compactHeightBreakpoint ||
        mediaQuery.textScaler.scale(1) > _largeTextBreakpoint;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    setState(() => _menuOpen = true);

    final action = useBottomSheet
        ? await _showBottomSheet(reduceMotion: reduceMotion)
        : await _showAnchoredMenu(reduceMotion: reduceMotion);

    if (!mounted) return;
    setState(() => _menuOpen = false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _anchorFocusNode.requestFocus();
    });

    switch (action) {
      case _RecipeCreationAction.createManually:
        widget.onCreateManually();
      case _RecipeCreationAction.importFromWebsite:
        widget.onImportFromWebsite();
      case null:
        break;
    }
  }

  Future<_RecipeCreationAction?> _showAnchoredMenu({
    required bool reduceMotion,
  }) {
    final palette = CulinaryEditorialPalette.of(context);
    final anchorWidth = _anchorKey.currentContext?.size?.width ?? 168;
    final route = PageRouteBuilder<_RecipeCreationAction>(
      settings: const RouteSettings(name: 'recipe-creation-actions'),
      requestFocus: true,
      opaque: false,
      barrierDismissible: true,
      barrierColor: Theme.of(context).colorScheme.scrim.withValues(alpha: .20),
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      transitionDuration: reduceMotion ? Duration.zero : _openDuration,
      reverseTransitionDuration: reduceMotion ? Duration.zero : _closeDuration,
      pageBuilder: (routeContext, animation, secondaryAnimation) {
        return _AnchoredRecipeActionMenu(
          anchorLink: _anchorLink,
          anchorWidth: anchorWidth,
          animation: animation,
          palette: palette,
        );
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          child,
    );

    return Navigator.of(context).push(route);
  }

  Future<_RecipeCreationAction?> _showBottomSheet({
    required bool reduceMotion,
  }) {
    final palette = CulinaryEditorialPalette.of(context);
    final scheme = Theme.of(context).colorScheme;

    return showModalBottomSheet<_RecipeCreationAction>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: palette.surface,
      barrierColor: scheme.scrim.withValues(alpha: .20),
      sheetAnimationStyle: reduceMotion
          ? AnimationStyle.noAnimation
          : const AnimationStyle(
              duration: _openDuration,
              reverseDuration: _closeDuration,
            ),
      builder: (sheetContext) => _RecipeActionBottomSheet(palette: palette),
    );
  }
}

class _AnchoredRecipeActionMenu extends StatelessWidget {
  const _AnchoredRecipeActionMenu({
    required this.anchorLink,
    required this.anchorWidth,
    required this.animation,
    required this.palette,
  });

  final LayerLink anchorLink;
  final double anchorWidth;
  final Animation<double> animation;
  final CulinaryEditorialPalette palette;

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final availableWidth = MediaQuery.sizeOf(context).width - 32;
    final menuWidth = math.min(280.0, math.max(200.0, availableWidth));

    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: Shortcuts(
          shortcuts: const {
            SingleActivator(LogicalKeyboardKey.escape): DismissIntent(),
          },
          child: Actions(
            actions: {
              DismissIntent: CallbackAction<DismissIntent>(
                onInvoke: (_) {
                  Navigator.of(context).maybePop();
                  return null;
                },
              ),
            },
            child: FocusTraversalGroup(
              policy: OrderedTraversalPolicy(),
              child: Stack(
                fit: StackFit.loose,
                children: [
                  CompositedTransformFollower(
                    link: anchorLink,
                    showWhenUnlinked: false,
                    targetAnchor: Alignment.bottomRight,
                    followerAnchor: Alignment.bottomRight,
                    child: Semantics(
                      scopesRoute: true,
                      namesRoute: true,
                      explicitChildNodes: true,
                      label: strings.add_recipe,
                      child: SizedBox(
                        width: math.max(menuWidth, anchorWidth),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _AnimatedMenuEntry(
                              animation: animation,
                              interval: const Interval(
                                .28,
                                1,
                                curve: Curves.easeOutCubic,
                              ),
                              child: _RecipeActionMenuItem(
                                key: const Key('recipe-creation-import-action'),
                                width: menuWidth,
                                icon: Icons.cloud_download_rounded,
                                label: strings.import_from_website_short,
                                palette: palette,
                                focusOrder: 2,
                                onPressed: () => Navigator.of(
                                  context,
                                ).pop(_RecipeCreationAction.importFromWebsite),
                              ),
                            ),
                            const SizedBox(height: 4),
                            _AnimatedMenuEntry(
                              animation: animation,
                              interval: const Interval(
                                .14,
                                .86,
                                curve: Curves.easeOutCubic,
                              ),
                              child: _RecipeActionMenuItem(
                                key: const Key('recipe-creation-manual-action'),
                                width: menuWidth,
                                icon: Icons.edit_note_rounded,
                                label: strings.create_manually,
                                palette: palette,
                                focusOrder: 1,
                                autofocus: true,
                                onPressed: () => Navigator.of(context)
                                    .pop(_RecipeCreationAction.createManually),
                              ),
                            ),
                            const SizedBox(height: 8),
                            _MorphingCloseFab(
                              animation: animation,
                              initialWidth: anchorWidth,
                              palette: palette,
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
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
    );
  }
}

class _AnimatedMenuEntry extends StatelessWidget {
  const _AnimatedMenuEntry({
    required this.animation,
    required this.interval,
    required this.child,
  });

  final Animation<double> animation;
  final Interval interval;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (context, child) {
        final progress = interval.transform(animation.value);
        return Opacity(
          opacity: progress,
          child: Transform.translate(
            offset: Offset(0, 12 * (1 - progress)),
            child: Transform.scale(
              alignment: Alignment.bottomRight,
              scale: .94 + (.06 * progress),
              child: child,
            ),
          ),
        );
      },
    );
  }
}

class _RecipeActionMenuItem extends StatelessWidget {
  const _RecipeActionMenuItem({
    super.key,
    required this.width,
    required this.icon,
    required this.label,
    required this.palette,
    required this.focusOrder,
    required this.onPressed,
    this.autofocus = false,
  });

  final double width;
  final IconData icon;
  final String label;
  final CulinaryEditorialPalette palette;
  final double focusOrder;
  final VoidCallback onPressed;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return FocusTraversalOrder(
      order: NumericFocusOrder(focusOrder),
      child: Semantics(
        button: true,
        enabled: true,
        label: label,
        excludeSemantics: true,
        onTap: onPressed,
        child: Material(
          color: palette.primarySoft,
          elevation: 6,
          shadowColor: palette.shadow,
          shape: const StadiumBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            autofocus: autofocus,
            onTap: onPressed,
            overlayColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) {
                return palette.primary.withValues(alpha: .12);
              }
              if (states.contains(WidgetState.focused) ||
                  states.contains(WidgetState.hovered)) {
                return palette.primary.withValues(alpha: .08);
              }
              return null;
            }),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: 56, minWidth: width),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(24, 12, 24, 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ExcludeSemantics(
                      child: Icon(icon, size: 24, color: palette.primary),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        label,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: CulinaryEditorialType.body(
                          palette,
                          size: 14,
                          weight: FontWeight.w700,
                          color: palette.primary,
                        ),
                      ),
                    ),
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

class _MorphingCloseFab extends StatelessWidget {
  const _MorphingCloseFab({
    required this.animation,
    required this.initialWidth,
    required this.palette,
    required this.onPressed,
  });

  final Animation<double> animation;
  final double initialWidth;
  final CulinaryEditorialPalette palette;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    return FocusTraversalOrder(
      order: const NumericFocusOrder(0),
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          final progress = Curves.easeOutCubic.transform(animation.value);
          final width = initialWidth + ((56 - initialWidth) * progress);
          final color = Color.lerp(
            palette.primarySoft,
            palette.primary,
            progress,
          )!;
          final foreground = Color.lerp(
            palette.primary,
            palette.onPrimary,
            progress,
          )!;
          final editOpacity = (1 - (progress / .45)).clamp(0.0, 1.0);
          final closeOpacity = ((progress - .35) / .45).clamp(0.0, 1.0);

          return Semantics(
            button: true,
            enabled: true,
            expanded: true,
            label: strings.recipe_actions,
            value: strings.recipe_actions_expanded,
            hint: strings.close_recipe_actions,
            excludeSemantics: true,
            onTap: onPressed,
            child: Tooltip(
              message: strings.close_recipe_actions,
              child: Material(
                key: const Key('recipe-creation-close-action'),
                color: color,
                elevation: 6,
                shadowColor: palette.shadow,
                shape: const StadiumBorder(),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: onPressed,
                  child: SizedBox(
                    width: width,
                    height: 56,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Opacity(
                          opacity: editOpacity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.edit_rounded,
                                size: 24,
                                color: foreground,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                strings.add_recipe,
                                maxLines: 1,
                                style: CulinaryEditorialType.body(
                                  palette,
                                  size: 14,
                                  weight: FontWeight.w700,
                                  color: foreground,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Opacity(
                          opacity: closeOpacity,
                          child: Icon(
                            Icons.close_rounded,
                            size: 20,
                            color: foreground,
                          ),
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
    );
  }
}

class _RecipeActionBottomSheet extends StatelessWidget {
  const _RecipeActionBottomSheet({required this.palette});

  final CulinaryEditorialPalette palette;

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final width = MediaQuery.sizeOf(context).width - 40;

    return Semantics(
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      label: strings.add_recipe,
      child: FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            20,
            4,
            20,
            20 + MediaQuery.paddingOf(context).bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      strings.add_recipe,
                      style: CulinaryEditorialType.headline(
                        palette,
                        size: 24,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ),
                  FocusTraversalOrder(
                    order: const NumericFocusOrder(0),
                    child: IconButton(
                      key: const Key('recipe-creation-sheet-close'),
                      tooltip: strings.close_recipe_actions,
                      constraints: const BoxConstraints.tightFor(
                        width: 48,
                        height: 48,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _RecipeActionMenuItem(
                key: const Key('recipe-creation-import-action'),
                width: width,
                icon: Icons.cloud_download_rounded,
                label: strings.import_from_website_short,
                palette: palette,
                focusOrder: 2,
                onPressed: () =>
                    Navigator.of(context)
                        .pop(_RecipeCreationAction.importFromWebsite),
              ),
              const SizedBox(height: 8),
              _RecipeActionMenuItem(
                key: const Key('recipe-creation-manual-action'),
                width: width,
                icon: Icons.edit_note_rounded,
                label: strings.create_manually,
                palette: palette,
                focusOrder: 1,
                autofocus: true,
                onPressed: () =>
                    Navigator.of(context)
                        .pop(_RecipeCreationAction.createManually),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
