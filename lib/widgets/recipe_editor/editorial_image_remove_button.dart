import 'package:flutter/material.dart';

import '../culinary_editorial_theme.dart';

class EditorialImageRemoveButton extends StatelessWidget {
  const EditorialImageRemoveButton({
    super.key,
    required this.onPressed,
    required this.tooltip,
  });

  static const double touchTargetSize = 48;
  static const double badgeSize = 30;

  final VoidCallback onPressed;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return SizedBox.square(
      dimension: touchTargetSize,
      child: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints.tightFor(
          width: touchTargetSize,
          height: touchTargetSize,
        ),
        style: IconButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: palette.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        icon: SizedBox.square(
          dimension: badgeSize,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: palette.primarySoft,
              borderRadius: BorderRadius.circular(9),
              boxShadow: [
                BoxShadow(
                  color: palette.shadow,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.close, size: 18),
          ),
        ),
      ),
    );
  }
}
