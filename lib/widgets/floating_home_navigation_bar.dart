import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'culinary_editorial_theme.dart';
import 'home_navigation_destination.dart';

class FloatingHomeNavigationBar extends StatelessWidget {
  const FloatingHomeNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.destinations,
    required this.onDestinationSelected,
  }) : assert(destinations.length >= 2 && destinations.length <= 5),
       assert(selectedIndex >= 0 && selectedIndex < destinations.length);

  static const double height = 64;
  static const double horizontalMargin = 20;
  static const double bottomMargin = 20;
  static const double narrowWidth = 346;

  final int selectedIndex;
  final List<HomeNavigationDestination> destinations;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final mediaQuery = MediaQuery.of(context);
    final isNarrow =
        mediaQuery.size.width < narrowWidth ||
        mediaQuery.textScaler.scale(1) > 1.15;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final animationDuration = reduceMotion
        ? Duration.zero
        : const Duration(milliseconds: 150);

    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(
        horizontalMargin,
        0,
        horizontalMargin,
        bottomMargin,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(height / 2),
          border: Border.all(
            color: palette.outline.withValues(
              alpha: Theme.of(context).brightness == Brightness.dark
                  ? .18
                  : .10,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: palette.shadow,
              blurRadius: 30,
              spreadRadius: -4,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(height / 2),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Material(
              color: palette.surface.withValues(alpha: .94),
              child: SizedBox(
                height: height,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    children: [
                      for (var index = 0; index < destinations.length; index++)
                        Expanded(
                          child: _NavigationItem(
                            key: ValueKey('home-navigation-destination-$index'),
                            destination: destinations[index],
                            selected: index == selectedIndex,
                            showLabel: !isNarrow || index == selectedIndex,
                            palette: palette,
                            animationDuration: animationDuration,
                            onTap: () => onDestinationSelected(index),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavigationItem extends StatelessWidget {
  const _NavigationItem({
    super.key,
    required this.destination,
    required this.selected,
    required this.showLabel,
    required this.palette,
    required this.animationDuration,
    required this.onTap,
  });

  final HomeNavigationDestination destination;
  final bool selected;
  final bool showLabel;
  final CulinaryEditorialPalette palette;
  final Duration animationDuration;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final contentColor = selected ? palette.primary : palette.onSurfaceVariant;

    return Semantics(
      button: true,
      selected: selected,
      label: destination.label,
      excludeSemantics: true,
      child: Tooltip(
        message: destination.label,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(28),
            overlayColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) {
                return palette.primary.withValues(alpha: .12);
              }
              if (states.contains(WidgetState.hovered) ||
                  states.contains(WidgetState.focused)) {
                return palette.primary.withValues(alpha: .08);
              }
              return null;
            }),
            child: SizedBox(
              height: 56,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TweenAnimationBuilder<Color?>(
                        tween: ColorTween(end: contentColor),
                        duration: animationDuration,
                        curve: Curves.easeOutCubic,
                        builder: (context, color, child) => IconTheme(
                          data: IconThemeData(color: color, size: 22),
                          child: child!,
                        ),
                        child: Icon(destination.icon),
                      ),
                      if (showLabel) ...[
                        const SizedBox(height: 2),
                        AnimatedDefaultTextStyle(
                          duration: animationDuration,
                          curve: Curves.easeOutCubic,
                          style: CulinaryEditorialType.body(
                            palette,
                            size: 11,
                            weight: selected
                                ? FontWeight.w700
                                : FontWeight.w600,
                            color: contentColor,
                            height: 1.15,
                            letterSpacing: .2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          child: Text(
                            destination.label,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
