import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../constants/global_settings.dart';
import '../generated/l10n.dart';
import 'culinary_editorial_theme.dart';

enum EditorialCatalogRowAction { edit, delete }

class EditorialCatalogManagerShell extends StatelessWidget {
  const EditorialCatalogManagerShell({
    super.key,
    required this.title,
    required this.description,
    required this.itemCount,
    required this.headerIcon,
    required this.addLabel,
    required this.emptyTitle,
    required this.emptyDescription,
    required this.emptyIcon,
    required this.onAdd,
    required this.contentSlivers,
    this.loading = false,
  });

  final String title;
  final String description;
  final int itemCount;
  final IconData headerIcon;
  final String addLabel;
  final String emptyTitle;
  final String emptyDescription;
  final IconData emptyIcon;
  final VoidCallback onAdd;
  final List<Widget> contentSlivers;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final themed = culinaryEditorialTheme(Theme.of(context), palette);
    final width = MediaQuery.sizeOf(context).width;
    final wideColumnInset = width >= 600
        ? ((width - 760).clamp(0, double.infinity) / 2) + 28 - 16
        : 0.0;

    return Theme(
      data: themed,
      child: Scaffold(
        backgroundColor: palette.background,
        floatingActionButton: !loading && itemCount > 0
            ? Padding(
                padding: EdgeInsets.only(right: wideColumnInset),
                child: FloatingActionButton.extended(
                  key: const ValueKey('catalog-fab-add'),
                  onPressed: onAdd,
                  backgroundColor: palette.primary,
                  foregroundColor: palette.onPrimary,
                  icon: const Icon(Icons.add_rounded),
                  label: Text(addLabel),
                ),
              )
            : null,
        body: CustomScrollView(
          key: const ValueKey('catalog-manager-scroll-view'),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            SliverAppBar.large(
              pinned: true,
              backgroundColor: palette.background,
              surfaceTintColor: palette.surfaceContainerHigh,
              foregroundColor: palette.onSurface,
              title: Padding(
                padding: EdgeInsets.only(left: wideColumnInset),
                child: Text(
                  title,
                  key: const ValueKey('catalog-title'),
                  style: CulinaryEditorialType.headline(
                    palette,
                    size: 30,
                    weight: FontWeight.w600,
                    height: 1.08,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: EditorialCatalogContentFrame(
                child: _CatalogIntroduction(
                  key: const ValueKey('catalog-introduction'),
                  icon: headerIcon,
                  description: description,
                  countLabel: S.of(context).settings_item_count(itemCount),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 14)),
            if (loading)
              SliverFillRemaining(
                hasScrollBody: false,
                child: EditorialCatalogContentFrame(
                  child: _CatalogLoading(label: S.of(context).loading_data),
                ),
              )
            else if (itemCount == 0)
              SliverFillRemaining(
                hasScrollBody: false,
                child: EditorialCatalogContentFrame(
                  child: _CatalogEmptyState(
                    icon: emptyIcon,
                    title: emptyTitle,
                    description: emptyDescription,
                    addLabel: addLabel,
                    onAdd: onAdd,
                  ),
                ),
              )
            else
              ...contentSlivers,
            if (!loading && itemCount > 0)
              const SliverToBoxAdapter(child: SizedBox(height: 112)),
          ],
        ),
      ),
    );
  }
}

class EditorialCatalogContentFrame extends StatelessWidget {
  const EditorialCatalogContentFrame({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width >= 600 ? 28 : 20),
          child: child,
        ),
      ),
    );
  }
}

class EditorialCatalogRowSurface extends StatelessWidget {
  const EditorialCatalogRowSurface({
    super.key,
    required this.leading,
    required this.title,
    required this.onTap,
    required this.trailing,
    this.subtitle,
  });

  final Widget leading;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: palette.surface,
        borderRadius: BorderRadius.circular(14),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 76),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 6, 10),
              child: Row(
                children: [
                  leading,
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: CulinaryEditorialType.body(
                            palette,
                            size: 15,
                            weight: FontWeight.w700,
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 3),
                          Text(
                            subtitle!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: CulinaryEditorialType.body(
                              palette,
                              size: 12,
                              color: palette.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  trailing,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EditorialCatalogMenuButton extends StatelessWidget {
  const EditorialCatalogMenuButton({
    super.key,
    required this.tooltip,
    required this.editLabel,
    required this.deleteLabel,
    required this.onEdit,
    required this.onDelete,
  });

  final String tooltip;
  final String editLabel;
  final String deleteLabel;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final error = Theme.of(context).colorScheme.error;
    return PopupMenuButton<EditorialCatalogRowAction>(
      tooltip: tooltip,
      icon: const Icon(Icons.more_vert_rounded),
      onSelected: (action) {
        switch (action) {
          case EditorialCatalogRowAction.edit:
            onEdit();
            return;
          case EditorialCatalogRowAction.delete:
            onDelete();
            return;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: EditorialCatalogRowAction.edit,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.edit_outlined),
            title: Text(editLabel),
          ),
        ),
        PopupMenuItem(
          value: EditorialCatalogRowAction.delete,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.delete_outline_rounded, color: error),
            title: Text(deleteLabel, style: TextStyle(color: error)),
          ),
        ),
      ],
    );
  }
}

Future<void> showCategoryEditorSheet({
  required BuildContext context,
  required String title,
  required String fieldLabel,
  required String saveLabel,
  required String cancelLabel,
  required String emptyError,
  required String duplicateError,
  required Iterable<String> existingNames,
  required ValueChanged<String> onSave,
  String? initialName,
}) {
  final palette = CulinaryEditorialPalette.of(context);
  final editorialTheme = culinaryEditorialTheme(Theme.of(context), palette);
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    backgroundColor: palette.surface,
    constraints: const BoxConstraints(maxWidth: 600),
    sheetAnimationStyle: _animationStyle(context),
    builder: (sheetContext) => Theme(
      data: editorialTheme,
      child: _CatalogNameSheet(
        title: title,
        fieldLabel: fieldLabel,
        saveLabel: saveLabel,
        cancelLabel: cancelLabel,
        emptyError: emptyError,
        duplicateError: duplicateError,
        existingNames: existingNames,
        initialName: initialName,
        onSave: onSave,
      ),
    ),
  );
}

Future<void> showTagEditorSheet({
  required BuildContext context,
  required String title,
  required String fieldLabel,
  required String saveLabel,
  required String cancelLabel,
  required String emptyError,
  required String duplicateError,
  required String chooseColorLabel,
  required String customColorLabel,
  required String colorPreviewLabel,
  required Iterable<String> existingNames,
  required void Function(String name, int color) onSave,
  String? initialName,
  Color initialColor = const Color(0xFFA83211),
}) {
  final palette = CulinaryEditorialPalette.of(context);
  final editorialTheme = culinaryEditorialTheme(Theme.of(context), palette);
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    backgroundColor: palette.surface,
    constraints: const BoxConstraints(maxWidth: 600),
    sheetAnimationStyle: _animationStyle(context),
    builder: (sheetContext) => Theme(
      data: editorialTheme,
      child: _TagEditorSheet(
        title: title,
        fieldLabel: fieldLabel,
        saveLabel: saveLabel,
        cancelLabel: cancelLabel,
        emptyError: emptyError,
        duplicateError: duplicateError,
        chooseColorLabel: chooseColorLabel,
        customColorLabel: customColorLabel,
        colorPreviewLabel: colorPreviewLabel,
        existingNames: existingNames,
        initialName: initialName,
        initialColor: initialColor,
        onSave: onSave,
      ),
    ),
  );
}

AnimationStyle? _animationStyle(BuildContext context) {
  final disableSystemAnimations =
      MediaQuery.maybeOf(context)?.disableAnimations ?? false;
  return disableSystemAnimations || !GlobalSettings().animationsEnabled()
      ? AnimationStyle.noAnimation
      : null;
}

class _CatalogIntroduction extends StatelessWidget {
  const _CatalogIntroduction({
    super.key,
    required this.icon,
    required this.description,
    required this.countLabel,
  });

  final IconData icon;
  final String description;
  final String countLabel;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.surfaceContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final stacked = constraints.maxWidth < 360 || textScale > 1.2;
          final iconWidget = Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: palette.primarySoft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: palette.primary),
          );
          final descriptionWidget = Text(
            description,
            style: CulinaryEditorialType.body(
              palette,
              size: 13,
              color: palette.onSurfaceVariant,
            ),
          );
          final countWidget = _CatalogCountBadge(label: countLabel);

          if (stacked) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    iconWidget,
                    const SizedBox(width: 12),
                    countWidget,
                  ],
                ),
                const SizedBox(height: 12),
                descriptionWidget,
              ],
            );
          }
          return Row(
            children: [
              iconWidget,
              const SizedBox(width: 12),
              Expanded(child: descriptionWidget),
              const SizedBox(width: 12),
              countWidget,
            ],
          );
        },
      ),
    );
  }
}

class _CatalogCountBadge extends StatelessWidget {
  const _CatalogCountBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: palette.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: CulinaryEditorialType.body(
          palette,
          size: 11,
          weight: FontWeight.w700,
          color: palette.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _CatalogLoading extends StatelessWidget {
  const _CatalogLoading({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              label,
              style: CulinaryEditorialType.body(
                palette,
                size: 13,
                color: palette.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CatalogEmptyState extends StatelessWidget {
  const _CatalogEmptyState({
    required this.icon,
    required this.title,
    required this.description,
    required this.addLabel,
    required this.onAdd,
  });

  final IconData icon;
  final String title;
  final String description;
  final String addLabel;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 36, 16, 72),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: palette.primarySoft,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Icon(icon, size: 36, color: palette.primary),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: CulinaryEditorialType.headline(
                palette,
                size: 22,
                weight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: CulinaryEditorialType.body(
                  palette,
                  size: 13,
                  color: palette.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: 22),
            FilledButton.icon(
              key: const ValueKey('catalog-empty-add'),
              onPressed: onAdd,
              icon: const Icon(Icons.add_rounded),
              label: Text(addLabel),
              style: FilledButton.styleFrom(
                minimumSize: const Size(220, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CatalogNameSheet extends StatefulWidget {
  const _CatalogNameSheet({
    required this.title,
    required this.fieldLabel,
    required this.saveLabel,
    required this.cancelLabel,
    required this.emptyError,
    required this.duplicateError,
    required this.existingNames,
    required this.onSave,
    this.initialName,
  });

  final String title;
  final String fieldLabel;
  final String saveLabel;
  final String cancelLabel;
  final String emptyError;
  final String duplicateError;
  final Iterable<String> existingNames;
  final ValueChanged<String> onSave;
  final String? initialName;

  @override
  State<_CatalogNameSheet> createState() => _CatalogNameSheetState();
}

class _CatalogNameSheetState extends State<_CatalogNameSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _EditorSheetLayout(
      title: widget.title,
      cancelLabel: widget.cancelLabel,
      saveLabel: widget.saveLabel,
      onSave: _submit,
      child: Form(
        key: _formKey,
        child: TextFormField(
          key: const ValueKey('catalog-name-field'),
          controller: _controller,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _submit(),
          validator: _validate,
          decoration: InputDecoration(labelText: widget.fieldLabel),
        ),
      ),
    );
  }

  String? _validate(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return widget.emptyError;
    final duplicate = widget.existingNames.any(
      (existing) => existing != widget.initialName && existing == name,
    );
    return duplicate ? widget.duplicateError : null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    widget.onSave(_controller.text.trim());
    Navigator.pop(context);
  }
}

class _TagEditorSheet extends StatefulWidget {
  const _TagEditorSheet({
    required this.title,
    required this.fieldLabel,
    required this.saveLabel,
    required this.cancelLabel,
    required this.emptyError,
    required this.duplicateError,
    required this.chooseColorLabel,
    required this.customColorLabel,
    required this.colorPreviewLabel,
    required this.existingNames,
    required this.initialColor,
    required this.onSave,
    this.initialName,
  });

  final String title;
  final String fieldLabel;
  final String saveLabel;
  final String cancelLabel;
  final String emptyError;
  final String duplicateError;
  final String chooseColorLabel;
  final String customColorLabel;
  final String colorPreviewLabel;
  final Iterable<String> existingNames;
  final String? initialName;
  final Color initialColor;
  final void Function(String name, int color) onSave;

  @override
  State<_TagEditorSheet> createState() => _TagEditorSheetState();
}

class _TagEditorSheetState extends State<_TagEditorSheet> {
  static const _quickColors = [
    Color(0xFFA83211),
    Color(0xFFC62828),
    Color(0xFFAD1457),
    Color(0xFF6A1B9A),
    Color(0xFF3949AB),
    Color(0xFF1565C0),
    Color(0xFF00838F),
    Color(0xFF2E7D32),
    Color(0xFF558B2F),
    Color(0xFFEF6C00),
    Color(0xFF795548),
    Color(0xFF546E7A),
  ];

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;
  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName ?? '');
    _selectedColor = widget.initialColor;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return _EditorSheetLayout(
      title: widget.title,
      cancelLabel: widget.cancelLabel,
      saveLabel: widget.saveLabel,
      onSave: _submit,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              key: const ValueKey('catalog-name-field'),
              controller: _controller,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.done,
              onChanged: (_) => setState(() {}),
              onFieldSubmitted: (_) => _submit(),
              validator: _validate,
              decoration: InputDecoration(labelText: widget.fieldLabel),
            ),
            const SizedBox(height: 16),
            Semantics(
              label:
                  '${widget.colorPreviewLabel}, ${_colorHex(_selectedColor)}',
              child: Container(
                key: const ValueKey('tag-color-preview'),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: palette.surfaceContainer,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  runSpacing: 8,
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: _selectedColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: palette.onSurface.withValues(alpha: .2),
                        ),
                      ),
                    ),
                    Text(
                      '#${_controller.text.trim().isEmpty ? widget.fieldLabel : _controller.text.trim()}',
                      style: CulinaryEditorialType.body(
                        palette,
                        size: 14,
                        weight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              widget.chooseColorLabel,
              style: CulinaryEditorialType.body(
                palette,
                size: 13,
                weight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (var index = 0; index < _quickColors.length; index++)
                  _ColorSwatchButton(
                    key: ValueKey('tag-color-$index'),
                    color: _quickColors[index],
                    selected:
                        _quickColors[index].toARGB32() ==
                        _selectedColor.toARGB32(),
                    semanticsLabel: S
                        .of(context)
                        .catalog_color_swatch(
                          _quickColorName(context, index),
                          _colorHex(_quickColors[index]),
                        ),
                    onTap: () =>
                        setState(() => _selectedColor = _quickColors[index]),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _openCustomColorPicker,
              icon: const Icon(Icons.palette_outlined),
              label: Text(widget.customColorLabel),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _validate(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return widget.emptyError;
    final duplicate = widget.existingNames.any(
      (existing) => existing != widget.initialName && existing == name,
    );
    return duplicate ? widget.duplicateError : null;
  }

  String _quickColorName(BuildContext context, int index) {
    final strings = S.of(context);
    return [
      strings.catalog_color_paprika,
      strings.catalog_color_red,
      strings.catalog_color_pink,
      strings.catalog_color_purple,
      strings.catalog_color_indigo,
      strings.catalog_color_blue,
      strings.catalog_color_teal,
      strings.catalog_color_green,
      strings.catalog_color_olive,
      strings.catalog_color_orange,
      strings.catalog_color_brown,
      strings.catalog_color_blue_grey,
    ][index];
  }

  String _colorHex(Color color) =>
      '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';

  Future<void> _openCustomColorPicker() async {
    var draftColor = _selectedColor;
    final chosen = await showDialog<Color>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(widget.chooseColorLabel),
        content: SingleChildScrollView(
          child: BlockPicker(
            pickerColor: draftColor,
            onColorChanged: (color) => draftColor = color,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(widget.cancelLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, draftColor),
            child: Text(widget.saveLabel),
          ),
        ],
      ),
    );
    if (chosen != null && mounted) {
      setState(() => _selectedColor = chosen);
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    widget.onSave(_controller.text.trim(), _selectedColor.toARGB32());
    Navigator.pop(context);
  }
}

class _ColorSwatchButton extends StatelessWidget {
  const _ColorSwatchButton({
    super.key,
    required this.color,
    required this.selected,
    required this.semanticsLabel,
    required this.onTap,
  });

  final Color color;
  final bool selected;
  final String semanticsLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Semantics(
      button: true,
      selected: selected,
      label: semanticsLabel,
      child: Material(
        color: Colors.transparent,
        child: InkResponse(
          onTap: onTap,
          radius: 28,
          child: SizedBox.square(
            dimension: 48,
            child: Center(
              child: AnimatedContainer(
                duration: _animationStyle(context) == null
                    ? const Duration(milliseconds: 180)
                    : Duration.zero,
                width: selected ? 38 : 32,
                height: selected ? 38 : 32,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected ? palette.onSurface : palette.outline,
                    width: selected ? 3 : 1,
                  ),
                ),
                child: selected
                    ? Icon(
                        Icons.check_rounded,
                        color: _onColor(color),
                        size: 20,
                      )
                    : null,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _onColor(Color color) {
    return ThemeData.estimateBrightnessForColor(color) == Brightness.dark
        ? Colors.white
        : Colors.black;
  }
}

class _EditorSheetLayout extends StatelessWidget {
  const _EditorSheetLayout({
    required this.title,
    required this.cancelLabel,
    required this.saveLabel,
    required this.onSave,
    required this.child,
  });

  final String title;
  final String cancelLabel;
  final String saveLabel;
  final VoidCallback onSave;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return AnimatedPadding(
      duration: _animationStyle(context) == null
          ? const Duration(milliseconds: 180)
          : Duration.zero,
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                style: CulinaryEditorialType.headline(
                  palette,
                  size: 24,
                  weight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 18),
              child,
              const SizedBox(height: 22),
              Row(
                children: [
                  TextButton(
                    key: const ValueKey('catalog-sheet-cancel'),
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      minimumSize: const Size(88, 52),
                    ),
                    child: Text(cancelLabel),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton.icon(
                      key: const ValueKey('catalog-sheet-save'),
                      onPressed: onSave,
                      icon: const Icon(Icons.check_rounded),
                      label: Text(saveLabel),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
