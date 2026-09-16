import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import 'editorial_recipe_card.dart';
import 'recipe_overview_theme.dart';

class RecipeLayoutSwitch extends StatelessWidget {
  const RecipeLayoutSwitch({
    required this.layout,
    required this.onChanged,
    this.keyPrefix = 'recipe-overview',
    super.key,
  });

  final RecipeOverviewCardLayout layout;
  final ValueChanged<RecipeOverviewCardLayout> onChanged;
  final String keyPrefix;

  @override
  Widget build(BuildContext context) {
    final palette = RecipeOverviewPalette.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.surfaceContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ViewChoice(
            key: Key('$keyPrefix-grid-toggle'),
            icon: Icons.grid_view_rounded,
            label: S.of(context).grid_view,
            selected: layout == RecipeOverviewCardLayout.grid,
            onTap: () => onChanged(RecipeOverviewCardLayout.grid),
          ),
          _ViewChoice(
            key: Key('$keyPrefix-list-toggle'),
            icon: Icons.view_agenda_outlined,
            label: S.of(context).list_view,
            selected: layout == RecipeOverviewCardLayout.list,
            onTap: () => onChanged(RecipeOverviewCardLayout.list),
          ),
        ],
      ),
    );
  }
}

class _ViewChoice extends StatelessWidget {
  const _ViewChoice({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = RecipeOverviewPalette.of(context);
    return Semantics(
      button: true,
      selected: selected,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: AnimatedContainer(
          duration: MediaQuery.disableAnimationsOf(context)
              ? Duration.zero
              : const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 9),
          decoration: BoxDecoration(
            color: selected ? palette.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: palette.shadow,
                      offset: const Offset(0, 1),
                      blurRadius: 5,
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 17,
                color: selected ? palette.primary : palette.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: RecipeOverviewType.body(
                  palette,
                  size: 11,
                  weight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected
                      ? palette.onSurface
                      : palette.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
