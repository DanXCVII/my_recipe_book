import 'package:flutter/material.dart';

import 'culinary_editorial_theme.dart';
import 'home_navigation_destination.dart';

class CulinaryEditorialNavigationRail extends StatelessWidget {
  const CulinaryEditorialNavigationRail({
    super.key,
    required this.selectedIndex,
    required this.destinations,
    required this.onDestinationSelected,
    required this.calendarOpen,
    required this.onCalendarPressed,
    required this.calendarLabel,
  }) : assert(destinations.length >= 2 && destinations.length <= 5),
       assert(selectedIndex >= 0 && selectedIndex < destinations.length);

  static const double width = 96;

  final int selectedIndex;
  final List<HomeNavigationDestination> destinations;
  final ValueChanged<int> onDestinationSelected;
  final bool calendarOpen;
  final VoidCallback onCalendarPressed;
  final String calendarLabel;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.surface,
        border: BorderDirectional(
          end: BorderSide(color: palette.outline.withValues(alpha: .18)),
        ),
      ),
      child: SafeArea(
        right: false,
        child: SizedBox(
          width: width,
          child: NavigationRail(
            key: const Key('culinary-editorial-navigation-rail'),
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            minWidth: width,
            labelType: NavigationRailLabelType.all,
            backgroundColor: Colors.transparent,
            groupAlignment: -1,
            scrollable: true,
            trailingAtBottom: true,
            useIndicator: true,
            indicatorColor: palette.primarySoft,
            indicatorShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            selectedIconTheme: IconThemeData(color: palette.primary, size: 24),
            unselectedIconTheme: IconThemeData(
              color: palette.onSurfaceVariant,
              size: 24,
            ),
            selectedLabelTextStyle: CulinaryEditorialType.body(
              palette,
              size: 11,
              weight: FontWeight.w700,
              color: palette.primary,
              height: 1.15,
              letterSpacing: .2,
            ),
            unselectedLabelTextStyle: CulinaryEditorialType.body(
              palette,
              size: 11,
              weight: FontWeight.w600,
              color: palette.onSurfaceVariant,
              height: 1.15,
              letterSpacing: .2,
            ),
            destinations: [
              for (var index = 0; index < destinations.length; index++)
                NavigationRailDestination(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  icon: Tooltip(
                    message: destinations[index].label,
                    child: Icon(
                      destinations[index].icon,
                      key: ValueKey('home-navigation-destination-$index'),
                    ),
                  ),
                  selectedIcon: Tooltip(
                    message: destinations[index].label,
                    child: Icon(
                      destinations[index].icon,
                      key: ValueKey(
                        'home-navigation-selected-destination-$index',
                      ),
                    ),
                  ),
                  label: Text(
                    destinations[index].label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
            trailing: _CalendarAction(
              label: calendarLabel,
              selected: calendarOpen,
              onPressed: onCalendarPressed,
              palette: palette,
            ),
          ),
        ),
      ),
    );
  }
}

class _CalendarAction extends StatelessWidget {
  const _CalendarAction({
    required this.label,
    required this.selected,
    required this.onPressed,
    required this.palette,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;
  final CulinaryEditorialPalette palette;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final foreground = selected ? palette.primary : palette.onSurfaceVariant;

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(
            height: 16,
            indent: 8,
            endIndent: 8,
            color: palette.outline.withValues(alpha: .22),
          ),
          Semantics(
            button: true,
            expanded: selected,
            label: label,
            onTap: onPressed,
            excludeSemantics: true,
            child: Tooltip(
              message: label,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  key: const Key('home-navigation-calendar'),
                  onTap: onPressed,
                  borderRadius: BorderRadius.circular(14),
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
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 80,
                      minHeight: 64,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedContainer(
                            duration: reduceMotion
                                ? Duration.zero
                                : const Duration(milliseconds: 150),
                            curve: Curves.easeOutCubic,
                            width: 56,
                            height: 32,
                            decoration: BoxDecoration(
                              color: selected
                                  ? palette.primarySoft
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              Icons.calendar_today_rounded,
                              color: foreground,
                              size: 22,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            label,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: CulinaryEditorialType.body(
                              palette,
                              size: 11,
                              weight: selected
                                  ? FontWeight.w700
                                  : FontWeight.w600,
                              color: foreground,
                              height: 1.15,
                              letterSpacing: .2,
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
        ],
      ),
    );
  }
}
