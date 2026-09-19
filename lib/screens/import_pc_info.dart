import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../generated/l10n.dart';
import '../widgets/culinary_editorial_theme.dart';

class ImportPcInfo extends StatelessWidget {
  const ImportPcInfo({super.key});

  static final Uri _recipeBuilderUri = Uri.parse(
    'https://danxcvii.github.io/#/',
  );

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final themed = culinaryEditorialTheme(Theme.of(context), palette);

    return Theme(
      data: themed,
      child: Scaffold(
        backgroundColor: palette.background,
        body: CustomScrollView(
          slivers: [
            SliverAppBar.large(
              pinned: true,
              backgroundColor: palette.background,
              surfaceTintColor: palette.surfaceContainerHigh,
              foregroundColor: palette.onSurface,
              title: Text(
                S.of(context).settings_import_pc_title,
                key: const ValueKey('pc-import-screen-title'),
              ),
            ),
            SliverToBoxAdapter(
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 760),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      MediaQuery.sizeOf(context).width >= 600 ? 28 : 20,
                      8,
                      MediaQuery.sizeOf(context).width >= 600 ? 28 : 20,
                      40,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).recipe_import_pc_title,
                          style: CulinaryEditorialType.headline(
                            palette,
                            size: 24,
                            weight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          S.of(context).settings_import_pc_desc,
                          style: CulinaryEditorialType.body(
                            palette,
                            color: palette.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 22),
                        Material(
                          color: palette.surface,
                          borderRadius: BorderRadius.circular(14),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: SelectionArea(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Material(
                                    color: palette.primarySoft,
                                    borderRadius: BorderRadius.circular(12),
                                    clipBehavior: Clip.antiAlias,
                                    child: InkWell(
                                      key: const ValueKey(
                                        'pc-import-open-web-editor',
                                      ),
                                      onTap: () => launchUrl(
                                        _recipeBuilderUri,
                                        mode: LaunchMode.externalApplication,
                                      ),
                                      child: ConstrainedBox(
                                        constraints: const BoxConstraints(
                                          minHeight: 52,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 12,
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  '${S.of(context).visit}'
                                                  'danxcvii.github.io',
                                                  style:
                                                      CulinaryEditorialType.body(
                                                        palette,
                                                        size: 14,
                                                        weight: FontWeight.w700,
                                                        color: palette.primary,
                                                      ),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Icon(
                                                Icons.open_in_new_rounded,
                                                color: palette.primary,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  Text(
                                    S.of(context).import_computer_info,
                                    style: CulinaryEditorialType.body(
                                      palette,
                                      size: 15,
                                      height: 1.55,
                                    ),
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
          ],
        ),
      ),
    );
  }
}
