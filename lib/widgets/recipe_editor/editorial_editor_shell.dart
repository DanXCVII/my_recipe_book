import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants/global_constants.dart' as constants;
import '../../generated/l10n.dart';
import '../../models/recipe.dart';
import '../culinary_editorial_theme.dart';

class EditorialEditorShell extends StatelessWidget {
  const EditorialEditorShell({
    super.key,
    required this.stage,
    required this.recipe,
    required this.title,
    required this.body,
    required this.primaryLabel,
    required this.onBack,
    required this.onPrimary,
    this.busy = false,
    this.showSummary = true,
  });

  final int stage;
  final Recipe recipe;
  final String title;
  final Widget body;
  final String primaryLabel;
  final VoidCallback? onBack;
  final VoidCallback? onPrimary;
  final bool busy;
  final bool showSummary;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final lightSystemIcons = Theme.of(context).brightness == Brightness.dark;
    return Theme(
      data: culinaryEditorialTheme(Theme.of(context), palette),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: lightSystemIcons
              ? Brightness.light
              : Brightness.dark,
          statusBarBrightness: lightSystemIcons
              ? Brightness.dark
              : Brightness.light,
          systemNavigationBarColor: palette.background,
          systemNavigationBarIconBrightness: lightSystemIcons
              ? Brightness.light
              : Brightness.dark,
        ),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: palette.background,
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                _EditorHeader(stage: stage, onBack: onBack),
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 760),
                      child: ListView(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                        children: [
                          if (showSummary) ...[
                            EditorialRecipeSummary(recipe: recipe),
                            const SizedBox(height: 22),
                          ],
                          Text(
                            title,
                            style: CulinaryEditorialType.headline(
                              palette,
                              size: 26,
                              weight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 14),
                          body,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
            top: false,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: palette.background,
                boxShadow: [
                  BoxShadow(
                    color: palette.shadow,
                    blurRadius: 18,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                child: Row(
                  children: [
                    TextButton.icon(
                      onPressed: busy ? null : onBack,
                      icon: const Icon(Icons.west),
                      label: Text(S.of(context).back),
                      style: TextButton.styleFrom(
                        minimumSize: const Size(92, 52),
                        foregroundColor: palette.onSurfaceVariant,
                        textStyle: CulinaryEditorialType.body(
                          palette,
                          size: 14,
                          weight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: busy ? null : onPrimary,
                        iconAlignment: IconAlignment.end,
                        icon: busy
                            ? SizedBox.square(
                                dimension: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: palette.onPrimary,
                                ),
                              )
                            : Icon(
                                stage == 4
                                    ? Icons.menu_book_outlined
                                    : Icons.east,
                              ),
                        label: Text(primaryLabel),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(52),
                          backgroundColor: palette.primary,
                          foregroundColor: palette.onPrimary,
                          disabledBackgroundColor: palette.surfaceContainerHigh,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: CulinaryEditorialType.body(
                            palette,
                            size: 14,
                            weight: FontWeight.w700,
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
      ),
    );
  }
}

class _EditorHeader extends StatelessWidget {
  const _EditorHeader({required this.stage, required this.onBack});

  final int stage;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.background,
        boxShadow: [
          BoxShadow(
            color: palette.shadow,
            blurRadius: 10,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 6, 20, 12),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(9),
                  child: Image.asset('images/icon.png', width: 36, height: 36),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).recipe_studio.toUpperCase(),
                        style: CulinaryEditorialType.body(
                          palette,
                          size: 11,
                          weight: FontWeight.w700,
                          color: palette.primary,
                          letterSpacing: .8,
                        ),
                      ),
                      Text(
                        S.of(context).recipe_editor,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: CulinaryEditorialType.headline(
                          palette,
                          size: 19,
                          weight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: List.generate(
                      4,
                      (index) => Expanded(
                        child: Container(
                          height: 5,
                          margin: EdgeInsets.only(right: index == 3 ? 0 : 5),
                          decoration: BoxDecoration(
                            color: index + 1 <= stage
                                ? palette.primary
                                : palette.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  S.of(context).editor_progress(stage, 4),
                  style: CulinaryEditorialType.body(
                    palette,
                    size: 11,
                    weight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EditorialRecipeSummary extends StatelessWidget {
  const EditorialRecipeSummary({super.key, required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final ingredientCount = recipe.ingredients.fold<int>(
      0,
      (count, group) => count + group.length,
    );
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: palette.surfaceContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          _RecipeThumbnail(recipe: recipe),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe.name.isEmpty
                      ? S.of(context).untitled_recipe
                      : recipe.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: CulinaryEditorialType.headline(
                    palette,
                    size: 18,
                    weight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  S.of(context).ingredient_count(ingredientCount) +
                      (recipe.totalTime > 0
                          ? '  •  ${_formatDuration(recipe.totalTime)} ${S.of(context).total_time.toLowerCase()}'
                          : ''),
                  style: CulinaryEditorialType.body(
                    palette,
                    size: 12,
                    color: palette.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (recipe.effort != null)
            Text(
              '${S.of(context).effort} ${recipe.effort}/10',
              style: CulinaryEditorialType.body(
                palette,
                size: 11,
                weight: FontWeight.w700,
                color: palette.tertiary,
              ),
            ),
        ],
      ),
    );
  }
}

class _RecipeThumbnail extends StatelessWidget {
  const _RecipeThumbnail({required this.recipe});

  final Recipe recipe;
  static const _editorFallback = 'assets/plates/recipe-thumbnail.png';

  @override
  Widget build(BuildContext context) {
    final image = recipe.imagePreviewPath;
    final child =
        image == constants.noRecipeImage || image.startsWith('images/')
        ? Image.asset(image, fit: BoxFit.cover)
        : Image.file(
            File(image),
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                Image.asset(_editorFallback, fit: BoxFit.cover),
          );
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox.square(dimension: 58, child: child),
    );
  }
}

class EditorialCard extends StatelessWidget {
  const EditorialCard({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
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
      child: child,
    );
  }
}

InputDecoration editorialInputDecoration(
  BuildContext context, {
  String? label,
  String? hint,
  Widget? suffix,
}) {
  final palette = CulinaryEditorialPalette.of(context);
  return InputDecoration(
    labelText: label,
    hintText: hint,
    suffixIcon: suffix,
    filled: true,
    fillColor: palette.surfaceContainer,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: palette.primary, width: 1.5),
    ),
  );
}

String _formatDuration(double minutes) {
  final total = minutes.round();
  final hours = total ~/ 60;
  final remainder = total % 60;
  if (hours == 0) return '${remainder}m';
  return remainder == 0 ? '${hours}h' : '${hours}h ${remainder}m';
}
