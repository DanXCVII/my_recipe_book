import 'package:flutter/material.dart';

import '../../../widgets/culinary_editorial_theme.dart';

class EditorialClassificationSection extends StatelessWidget {
  const EditorialClassificationSection({
    super.key,
    required this.title,
    required this.addTooltip,
    required this.manageTooltip,
    required this.onAdd,
    required this.onManage,
    required this.children,
  });

  final String title;
  final String addTooltip;
  final String manageTooltip;
  final VoidCallback onAdd;
  final VoidCallback onManage;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: CulinaryEditorialType.headline(
                  palette,
                  size: 18,
                  weight: FontWeight.w600,
                ),
              ),
            ),
            IconButton(
              tooltip: addTooltip,
              onPressed: onAdd,
              color: palette.primary,
              icon: const Icon(Icons.add_circle_outline),
            ),
            IconButton(
              tooltip: manageTooltip,
              onPressed: onManage,
              color: palette.onSurfaceVariant,
              icon: const Icon(Icons.open_in_full_rounded),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(spacing: 8, runSpacing: 8, children: children),
      ],
    );
  }
}
