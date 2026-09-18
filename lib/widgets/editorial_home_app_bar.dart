import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'culinary_editorial_theme.dart';

class EditorialHomeAppBarAction {
  const EditorialHomeAppBarAction({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.key,
  });

  final Key? key;
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
}

class EditorialHomeOverflowAction {
  const EditorialHomeOverflowAction({
    required this.icon,
    required this.label,
    required this.onSelected,
    this.key,
  });

  final Key? key;
  final IconData icon;
  final String label;
  final VoidCallback? onSelected;
}

class EditorialHomeAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const EditorialHomeAppBar({
    required this.title,
    required this.visibleActions,
    required this.overflowActions,
    required this.overflowTooltip,
    required this.syncInProgress,
    super.key,
  });

  static const double toolbarHeight = 72;

  final String title;
  final List<EditorialHomeAppBarAction> visibleActions;
  final List<EditorialHomeOverflowAction> overflowActions;
  final String overflowTooltip;
  final bool syncInProgress;

  @override
  Size get preferredSize => const Size.fromHeight(toolbarHeight);

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final lightTheme = Theme.of(context).brightness == Brightness.light;

    return AppBar(
      key: const Key('editorial-home-app-bar'),
      automaticallyImplyLeading: false,
      toolbarHeight: toolbarHeight,
      titleSpacing: 20,
      elevation: 0,
      scrolledUnderElevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      backgroundColor: palette.background,
      foregroundColor: palette.onSurface,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: lightTheme
            ? Brightness.dark
            : Brightness.light,
        statusBarBrightness: lightTheme ? Brightness.light : Brightness.dark,
      ),
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: CulinaryEditorialType.headline(
          palette,
          size: 30,
          weight: FontWeight.w600,
          height: 1.08,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var index = 0; index < visibleActions.length; index++) ...[
                if (index > 0) const SizedBox(width: 4),
                _HeaderAction(
                  key: visibleActions[index].key,
                  action: visibleActions[index],
                  palette: palette,
                ),
              ],
              if (overflowActions.isNotEmpty) ...[
                if (visibleActions.isNotEmpty) const SizedBox(width: 4),
                _OverflowMenu(
                  actions: overflowActions,
                  tooltip: overflowTooltip,
                  syncInProgress: syncInProgress,
                  palette: palette,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _HeaderAction extends StatelessWidget {
  const _HeaderAction({required this.action, required this.palette, super.key});

  final EditorialHomeAppBarAction action;
  final CulinaryEditorialPalette palette;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: action.tooltip,
      constraints: const BoxConstraints.tightFor(width: 48, height: 48),
      style: IconButton.styleFrom(
        backgroundColor: palette.surfaceContainer,
        foregroundColor: palette.onSurfaceVariant,
      ),
      onPressed: action.onPressed,
      icon: Icon(action.icon, size: 20),
    );
  }
}

class _OverflowMenu extends StatelessWidget {
  const _OverflowMenu({
    required this.actions,
    required this.tooltip,
    required this.syncInProgress,
    required this.palette,
  });

  final List<EditorialHomeOverflowAction> actions;
  final String tooltip;
  final bool syncInProgress;
  final CulinaryEditorialPalette palette;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: palette.surfaceContainer,
      shape: const CircleBorder(),
      child: SizedBox.square(
        dimension: 48,
        child: PopupMenuButton<int>(
          key: const Key('editorial-home-overflow'),
          tooltip: tooltip,
          color: palette.surface,
          surfaceTintColor: Colors.transparent,
          position: PopupMenuPosition.under,
          offset: const Offset(0, 8),
          constraints: const BoxConstraints(minWidth: 220, maxWidth: 320),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          icon: _OverflowIcon(syncInProgress: syncInProgress, palette: palette),
          iconColor: palette.onSurfaceVariant,
          iconSize: 20,
          onSelected: (index) => actions[index].onSelected?.call(),
          itemBuilder: (context) => [
            for (var index = 0; index < actions.length; index++)
              PopupMenuItem<int>(
                key: actions[index].key,
                value: index,
                enabled: actions[index].onSelected != null,
                child: Row(
                  children: [
                    Icon(
                      actions[index].icon,
                      size: 20,
                      color: actions[index].onSelected == null
                          ? palette.outline.withValues(alpha: .55)
                          : palette.onSurfaceVariant,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        actions[index].label,
                        style: CulinaryEditorialType.body(
                          palette,
                          size: 14,
                          weight: FontWeight.w600,
                          color: actions[index].onSelected == null
                              ? palette.outline.withValues(alpha: .72)
                              : palette.onSurface,
                        ),
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

class _OverflowIcon extends StatelessWidget {
  const _OverflowIcon({required this.syncInProgress, required this.palette});

  final bool syncInProgress;
  final CulinaryEditorialPalette palette;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        const Icon(Icons.more_vert_rounded),
        if (syncInProgress)
          Positioned(
            right: -3,
            bottom: -3,
            child: SizedBox.square(
              dimension: 12,
              child: CircularProgressIndicator(
                key: const Key('editorial-home-sync-progress'),
                strokeWidth: 2,
                color: palette.primary,
              ),
            ),
          ),
      ],
    );
  }
}
