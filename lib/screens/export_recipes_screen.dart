import 'dart:async';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../generated/l10n.dart';
import '../local_storage/io_operations.dart' as io_operations;
import '../local_storage/local_paths.dart';
import '../local_storage/local_repository.dart';
import '../widgets/culinary_editorial_theme.dart';

class ExportRecipes extends StatefulWidget {
  const ExportRecipes({super.key});

  @override
  State<ExportRecipes> createState() => _ExportRecipesState();
}

class _ExportRecipesState extends State<ExportRecipes> {
  late final List<String> _recipeNames;
  final Set<String> _selectedRecipeNames = {};

  bool get _allSelected =>
      _recipeNames.isNotEmpty &&
      setEquals(_selectedRecipeNames, _recipeNames.toSet());

  @override
  void initState() {
    super.initState();
    _recipeNames = context.read<LocalRepository>().getRecipeNames();
  }

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final themed = culinaryEditorialTheme(Theme.of(context), palette);

    return Theme(
      data: themed,
      child: Scaffold(
        backgroundColor: palette.background,
        body: CustomScrollView(
          key: const ValueKey('export-recipes-scroll-view'),
          slivers: [
            SliverAppBar.large(
              pinned: true,
              backgroundColor: palette.background,
              surfaceTintColor: palette.surfaceContainerHigh,
              foregroundColor: palette.onSurface,
              title: Text(
                S.of(context).settings_backup_title,
                key: const ValueKey('export-screen-title'),
              ),
            ),
            SliverToBoxAdapter(
              child: _ExportContentFrame(
                child: Text(
                  S.of(context).settings_backup_desc,
                  style: CulinaryEditorialType.body(
                    palette,
                    color: palette.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 18)),
            if (_recipeNames.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _ExportEmptyState(palette: palette),
              )
            else ...[
              SliverToBoxAdapter(
                child: _ExportContentFrame(
                  child: Material(
                    color: palette.surfaceContainer,
                    borderRadius: BorderRadius.circular(14),
                    clipBehavior: Clip.antiAlias,
                    child: CheckboxListTile(
                      key: const ValueKey('export-select-all'),
                      value: _allSelected,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(
                        S.of(context).select_all,
                        style: CulinaryEditorialType.body(
                          palette,
                          size: 15,
                          weight: FontWeight.w700,
                        ),
                      ),
                      secondary: Text(
                        '${_selectedRecipeNames.length}/${_recipeNames.length}',
                        style: CulinaryEditorialType.body(
                          palette,
                          weight: FontWeight.w700,
                          color: palette.onSurfaceVariant,
                        ),
                      ),
                      onChanged: (_) {
                        setState(() {
                          if (_allSelected) {
                            _selectedRecipeNames.clear();
                          } else {
                            _selectedRecipeNames
                              ..clear()
                              ..addAll(_recipeNames);
                          }
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 14)),
              SliverList.builder(
                itemCount: _recipeNames.length,
                itemBuilder: (context, index) {
                  final recipeName = _recipeNames[index];
                  final selected = _selectedRecipeNames.contains(recipeName);
                  return _ExportContentFrame(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Material(
                        color: palette.surface,
                        borderRadius: BorderRadius.circular(14),
                        clipBehavior: Clip.antiAlias,
                        child: CheckboxListTile(
                          key: ValueKey('export-recipe-$recipeName'),
                          value: selected,
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(
                            recipeName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: CulinaryEditorialType.body(
                              palette,
                              size: 15,
                              weight: FontWeight.w700,
                            ),
                          ),
                          onChanged: (_) {
                            setState(() {
                              if (selected) {
                                _selectedRecipeNames.remove(recipeName);
                              } else {
                                _selectedRecipeNames.add(recipeName);
                              }
                            });
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 116)),
            ],
          ],
        ),
        bottomNavigationBar: _recipeNames.isEmpty
            ? null
            : SafeArea(
                top: false,
                child: Material(
                  color: palette.surface,
                  elevation: 8,
                  shadowColor: palette.shadow,
                  child: _ExportContentFrame(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: FilledButton.icon(
                        key: const ValueKey('export-share-button'),
                        onPressed: _selectedRecipeNames.isEmpty
                            ? null
                            : _startExport,
                        icon: const Icon(Icons.ios_share_rounded),
                        label: Text(S.of(context).export_zip),
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  void _startExport() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => SaveExportRecipes(
        exportRecipes: _selectedRecipeNames.toList(growable: false),
      ),
    );
  }
}

class _ExportContentFrame extends StatelessWidget {
  const _ExportContentFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Align(
      alignment: Alignment.topCenter,
      heightFactor: 1,
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

class _ExportEmptyState extends StatelessWidget {
  const _ExportEmptyState({required this.palette});

  final CulinaryEditorialPalette palette;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 96),
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
              child: Icon(
                Icons.menu_book_outlined,
                size: 36,
                color: palette.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              S.of(context).no_recipes,
              textAlign: TextAlign.center,
              style: CulinaryEditorialType.headline(
                palette,
                size: 22,
                weight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SaveExportRecipes extends StatefulWidget {
  const SaveExportRecipes({required this.exportRecipes, super.key});

  final List<String> exportRecipes;

  @override
  State<SaveExportRecipes> createState() => _SaveExportRecipesState();
}

class _SaveExportRecipesState extends State<SaveExportRecipes> {
  int _exportRecipe = 1;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    unawaited(_exportAndShare());
  }

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return AlertDialog(
      icon: _finished
          ? Icon(Icons.check_circle_outline_rounded, color: palette.secondary)
          : null,
      title: Text(
        _finished ? S.of(context).almost_done : S.of(context).export_zip,
      ),
      content: Row(
        children: [
          if (!_finished) ...[
            const SizedBox.square(
              dimension: 24,
              child: CircularProgressIndicator(strokeWidth: 3),
            ),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: Text(
              _finished
                  ? S.of(context).almost_done
                  : '${S.of(context).exporting_recipe} $_exportRecipe '
                        '${S.of(context).out_of} ${widget.exportRecipes.length}',
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _exportAndShare() async {
    final path = await _exportRecipes();
    if (!mounted) return;
    setState(() => _finished = true);
    await SharePlus.instance.share(
      ShareParams(files: [XFile(path)], subject: 'mrb-recipes.zip'),
    );
    if (mounted) Navigator.of(context).pop();
  }

  Future<String> _exportRecipes() async {
    var exportDirectory = await PathProvider.pP.getShareMultiDir();
    final directory = Directory(exportDirectory);
    if (await directory.exists()) {
      await directory.delete(recursive: true);
    }
    exportDirectory = await PathProvider.pP.getShareMultiDir();

    for (var index = 0; index < widget.exportRecipes.length; index++) {
      await io_operations.saveRecipeZip(
        exportDirectory,
        widget.exportRecipes[index],
        context.read<LocalRepository>(),
      );
      if (mounted && index + 1 < widget.exportRecipes.length) {
        setState(() => _exportRecipe = index + 2);
      }
    }

    final exportFiles = Directory(exportDirectory).listSync();
    final encoder = ZipFileEncoder();
    final finalZipFilePath = PathProvider.pP.getZipFilePath(
      'mrb-recipes',
      exportDirectory,
    );
    encoder.create(finalZipFilePath);
    for (final file in exportFiles) {
      await encoder.addFile(file as File);
      await file.delete();
    }
    await encoder.close();
    return finalZipFilePath;
  }
}
