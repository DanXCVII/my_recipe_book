import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../ad_related/ad.dart';
import '../blocs/ad_manager/ad_manager_bloc.dart';
import '../blocs/animated_stepper/animated_stepper_bloc.dart';
import '../blocs/recipe_bubble/recipe_bubble_bloc.dart';
import '../blocs/recipe_calendar/recipe_calendar_bloc.dart';
import '../blocs/recipe_manager/recipe_manager_bloc.dart';
import '../blocs/recipe_mods/recipe_mods_bloc.dart';
import '../blocs/recipe_screen/recipe_screen_bloc.dart';
import '../blocs/shopping_cart/shopping_cart_bloc.dart';
import '../constants/brand_assets.dart';
import '../constants/routes.dart';
import '../generated/l10n.dart';
import '../local_storage/io_operations.dart' as io_operations;
import '../local_storage/local_paths.dart';
import '../local_storage/local_repository.dart';
import '../models/recipe.dart';
import '../util/helper.dart';
import '../util/pdf_share.dart';
import '../widgets/culinary_editorial_theme.dart';
import '../widgets/icon_info_message.dart';
import '../widgets/recipe_screen/editorial_recipe_detail.dart';
import '../widgets/spinning_sync_icon.dart';
import 'add_recipe/general_info_screen/general_info_screen.dart';

enum PopupOptionsShare { exportZip, exportText, exportPdf }

enum _RecipeMoreAction { calendar, pin, edit, print, delete }

class RecipeScreenArguments {
  RecipeScreenArguments(
    this.shoppingCartBloc,
    this.recipeCalendarBloc,
    this.recipe,
    this.heroImageTag,
    this.recipeManagerBloc, {
    this.initialScrollOffset,
    this.initialSelectedStep,
    this.initialSection = RecipeDetailSection.ingredients,
  });

  final ShoppingCartBloc shoppingCartBloc;
  final RecipeCalendarBloc recipeCalendarBloc;
  final Recipe? recipe;
  final String heroImageTag;
  final RecipeManagerBloc recipeManagerBloc;
  final double? initialScrollOffset;
  final int? initialSelectedStep;
  final RecipeDetailSection initialSection;
}

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({
    super.key,
    this.heroImageTag,
    this.initialScrollOffset,
    this.initialSection = RecipeDetailSection.ingredients,
  });

  final String? heroImageTag;
  final double? initialScrollOffset;
  final RecipeDetailSection initialSection;

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  late final ScrollController _scrollController;
  late RecipeDetailSection _selectedSection;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(
      initialScrollOffset: widget.initialScrollOffset ?? 0,
      keepScrollOffset: false,
    );
    _selectedSection = widget.initialSection;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeScreenBloc, RecipeScreenState>(
      builder: (context, state) {
        if (state is RecipeScreenInfo) {
          return BlocListener<AdManagerBloc, AdManagerState>(
            listener: (context, adState) {
              if (adState is ShowAds &&
                  ModalRoute.of(context)?.isCurrent == true) {
                final stepState = context.read<AnimatedStepperBloc>().state;
                Navigator.popAndPushNamed(
                  context,
                  RouteNames.recipeScreen,
                  arguments: RecipeScreenArguments(
                    context.read<ShoppingCartBloc>(),
                    context.read<RecipeCalendarBloc>(),
                    state.recipe,
                    '',
                    context.read<RecipeManagerBloc>(),
                    initialScrollOffset: _scrollController.hasClients
                        ? _scrollController.offset
                        : null,
                    initialSelectedStep: stepState is SelectedStep
                        ? stepState.selectedStep
                        : null,
                    initialSection: _selectedSection,
                  ),
                ).then((_) => Ads.hideBottomBannerAd());
              }
            },
            child: _RecipeScaffold(
              recipe: state.recipe,
              heroImageTag: widget.heroImageTag,
              scrollController: _scrollController,
              selectedSection: _selectedSection,
              onSectionChanged: (section) {
                if (_selectedSection == section) return;
                setState(() => _selectedSection = section);
              },
            ),
          );
        }
        if (state is RecipeEditedDeleted) {
          return _UnavailableRecipeScaffold();
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _RecipeScaffold extends StatelessWidget {
  const _RecipeScaffold({
    required this.recipe,
    required this.heroImageTag,
    required this.scrollController,
    required this.selectedSection,
    required this.onSectionChanged,
  });

  final Recipe recipe;
  final String? heroImageTag;
  final ScrollController scrollController;
  final RecipeDetailSection selectedSection;
  final ValueChanged<RecipeDetailSection> onSectionChanged;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Theme(
      data: culinaryEditorialTheme(Theme.of(context), palette),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: dark ? Brightness.light : Brightness.dark,
          statusBarBrightness: dark ? Brightness.dark : Brightness.light,
          systemNavigationBarColor: palette.background,
          systemNavigationBarIconBrightness: dark
              ? Brightness.light
              : Brightness.dark,
        ),
        child: Scaffold(
          backgroundColor: palette.background,
          body: SafeArea(
            bottom: false,
            child: BlocListener<RecipeCalendarBloc, RecipeCalendarState>(
              listener: _showCalendarConfirmation,
              child: Column(
                children: [
                  _RecipeDetailHeader(recipe: recipe),
                  Expanded(
                    child: EditorialRecipeDetailBody(
                      recipe: recipe,
                      heroImageTag: heroImageTag,
                      scrollController: scrollController,
                      selectedSection: selectedSection,
                      onSectionChanged: onSectionChanged,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showCalendarConfirmation(
    BuildContext context,
    RecipeCalendarState state,
  ) {
    final addedRecipe = switch (state) {
      LoadedRecipeCalendarWeek() => state.addedRecipe,
      _ => null,
    };
    if (addedRecipe == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          S
              .of(context)
              .undo_added_to_planner_description(
                addedRecipe.item2,
                addedRecipe.item1.year.toString(),
                addedRecipe.item1.month.toString(),
                addedRecipe.item1.day.toString(),
              ),
        ),
        action: SnackBarAction(
          label: S.of(context).undo,
          onPressed: () => context.read<RecipeCalendarBloc>().add(
            RemoveRecipeFromDateEvent(addedRecipe.item1, addedRecipe.item2),
          ),
        ),
      ),
    );
  }
}

class _RecipeDetailHeader extends StatelessWidget {
  const _RecipeDetailHeader({required this.recipe});

  final Recipe recipe;

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
      child: SizedBox(
        height: 64,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              IconButton(
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                onPressed: () => Navigator.maybePop(context),
                icon: const Icon(Icons.arrow_back),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: Image.asset(
                  BrandAssets.simplifiedLogo,
                  width: 36,
                  height: 36,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  S.of(context).recipe_detail,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: CulinaryEditorialType.headline(
                    palette,
                    size: 19,
                    weight: FontWeight.w600,
                  ),
                ),
              ),
              PopupMenuButton<PopupOptionsShare>(
                key: const Key('recipe-share-button'),
                tooltip: S.of(context).share_recipe,
                icon: const Icon(Icons.share_outlined),
                onSelected: (value) => _share(value, context),
                itemBuilder: (context) => [
                  _shareItem(
                    PopupOptionsShare.exportText,
                    Icons.text_snippet_outlined,
                    S.of(context).export_text,
                  ),
                  _shareItem(
                    PopupOptionsShare.exportZip,
                    Icons.folder_zip_outlined,
                    S.of(context).export_zip,
                  ),
                  _shareItem(
                    PopupOptionsShare.exportPdf,
                    Icons.picture_as_pdf_outlined,
                    S.of(context).export_pdf,
                  ),
                ],
              ),
              BlocBuilder<RecipeModsBloc, RecipeModsState>(
                builder: (context, modsState) {
                  final canEdit = modsState is UnblockModsState;
                  return BlocBuilder<RecipeBubbleBloc, RecipeBubbleState>(
                    builder: (context, bubbleState) {
                      final pinned =
                          bubbleState is LoadedRecipeBubbles &&
                          bubbleState.recipes.contains(recipe);
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!canEdit)
                            Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: SizedBox.square(
                                dimension: 24,
                                child: SpinningSyncIcon(),
                              ),
                            ),
                          PopupMenuButton<_RecipeMoreAction>(
                            key: const Key('recipe-more-actions'),
                            tooltip: S.of(context).recipe_more_actions,
                            icon: const Icon(Icons.more_vert),
                            onSelected: (value) =>
                                _handleMoreAction(context, value, bubbleState),
                            itemBuilder: (context) => [
                              _moreItem(
                                _RecipeMoreAction.calendar,
                                Icons.event_available_outlined,
                                S.of(context).add_to_calendar,
                              ),
                              _moreItem(
                                _RecipeMoreAction.pin,
                                pinned
                                    ? MdiIcons.pinOffOutline
                                    : MdiIcons.pinOutline,
                                pinned
                                    ? S.of(context).unpin_recipe
                                    : S.of(context).pin_recipe,
                              ),
                              if (canEdit)
                                _moreItem(
                                  _RecipeMoreAction.edit,
                                  Icons.edit_outlined,
                                  S.of(context).edit,
                                ),
                              _moreItem(
                                _RecipeMoreAction.print,
                                Icons.print_outlined,
                                S.of(context).print_recipe,
                              ),
                              _moreItem(
                                _RecipeMoreAction.delete,
                                Icons.delete_outline,
                                S.of(context).delete_recipe,
                                destructive: true,
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  PopupMenuItem<PopupOptionsShare> _shareItem(
    PopupOptionsShare value,
    IconData icon,
    String label,
  ) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [Icon(icon), const SizedBox(width: 12), Text(label)],
      ),
    );
  }

  PopupMenuItem<_RecipeMoreAction> _moreItem(
    _RecipeMoreAction value,
    IconData icon,
    String label, {
    bool destructive = false,
  }) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: destructive ? Colors.red : null),
          const SizedBox(width: 12),
          Text(label, style: TextStyle(color: destructive ? Colors.red : null)),
        ],
      ),
    );
  }

  Future<void> _handleMoreAction(
    BuildContext context,
    _RecipeMoreAction action,
    RecipeBubbleState bubbleState,
  ) async {
    switch (action) {
      case _RecipeMoreAction.calendar:
        final date = await showOmniDateTimePicker(
          context: context,
          initialDate: DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
          ),
          is24HourMode: true,
        );
        if (date != null && context.mounted) {
          context.read<RecipeCalendarBloc>().add(
            AddRecipeToCalendarEvent(date, recipe.name),
          );
        }
      case _RecipeMoreAction.pin:
        _togglePin(context, bubbleState);
      case _RecipeMoreAction.edit:
        await _editRecipe(context);
      case _RecipeMoreAction.print:
        final pdf = await getRecipePdf(recipe, context);
        await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf);
      case _RecipeMoreAction.delete:
        await _showDeleteDialog(context);
    }
  }

  void _togglePin(BuildContext context, RecipeBubbleState state) {
    if (state is! LoadedRecipeBubbles) return;
    final pinned = state.recipes.contains(recipe);
    if (!pinned && state.recipes.length == 3) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(S.of(context).maximum_recipe_pin_count_exceeded),
            action: SnackBarAction(
              label: S.of(context).dismiss,
              onPressed: ScaffoldMessenger.of(context).hideCurrentSnackBar,
            ),
          ),
        );
      return;
    }
    context.read<RecipeBubbleBloc>().add(
      pinned ? RemoveRecipeBubble([recipe]) : AddRecipeBubble([recipe]),
    );
    if (!pinned) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(S.of(context).recipe_pinned_to_overview),
            action: SnackBarAction(
              label: S.of(context).dismiss,
              onPressed: ScaffoldMessenger.of(context).hideCurrentSnackBar,
            ),
          ),
        );
    }
  }

  Future<void> _editRecipe(BuildContext context) async {
    Ads.hideBottomBannerAd();
    await context.read<LocalRepository>().saveTmpEditingRecipe(recipe);
    if (!context.mounted) return;
    context.read<AdManagerBloc>().add(LoadVideo());
    await Navigator.pushNamed(
      context,
      RouteNames.addRecipeGeneralInfo,
      arguments: GeneralInfoArguments(
        recipe,
        context.read<ShoppingCartBloc>(),
        context.read<RecipeCalendarBloc>(),
        editingRecipeName: recipe.name,
      ),
    );
    Ads.showBottomBannerAd();
  }

  Future<void> _share(PopupOptionsShare value, BuildContext context) async {
    switch (value) {
      case PopupOptionsShare.exportText:
        await SharePlus.instance.share(
          ShareParams(
            text: _recipeAsText(context),
            subject: stringReplaceSpaceUnderscore(recipe.name),
          ),
        );
      case PopupOptionsShare.exportZip:
        final zipPath = await io_operations.saveRecipeZip(
          await PathProvider.pP.getShareDir(),
          recipe.name,
          context.read<LocalRepository>(),
        );
        await SharePlus.instance.share(
          ShareParams(
            files: [XFile(zipPath)],
            subject: '${stringReplaceSpaceUnderscore(recipe.name)}.zip',
          ),
        );
      case PopupOptionsShare.exportPdf:
        final pdf = await getRecipePdf(recipe, context);
        await Printing.sharePdf(
          bytes: pdf,
          filename: '${stringReplaceSpaceUnderscore(recipe.name)}.pdf',
        );
    }
  }

  Future<void> _showDeleteDialog(BuildContext context) async {
    await showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(S.of(context).delete_recipe),
        content: Text(
          '${S.of(context).sure_you_want_to_delete_this_recipe} ${recipe.name}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(S.of(context).no),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red[700]),
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.pop(context);
              context.read<RecipeManagerBloc>().add(
                RMDeleteRecipe(recipe.name, deleteFiles: true),
              );
              Future.delayed(const Duration(milliseconds: 60))
                  .then((_) => io_operations.deleteRecipeData(recipe.name));
            },
            child: Text(S.of(context).yes),
          ),
        ],
      ),
    );
  }

  String _recipeAsText(BuildContext context) {
    final buffer = StringBuffer()
      ..writeln('${S.of(context).recipe_name}: ${recipe.name}')
      ..writeln('====================');
    if (recipe.preperationTime > 0) {
      buffer.writeln(
        '${S.of(context).prep_time}: ${getTimeHoursMinutes(recipe.preperationTime)}',
      );
    }
    if (recipe.cookingTime > 0) {
      buffer.writeln(
        '${S.of(context).cook_time}: ${getTimeHoursMinutes(recipe.cookingTime)}',
      );
    }
    if (recipe.totalTime > 0) {
      buffer.writeln(
        '${S.of(context).total_time}: ${getTimeHoursMinutes(recipe.totalTime)}',
      );
    }
    buffer
      ..writeln('====================')
      ..writeln(
        recipe.servings == null
            ? '${S.of(context).ingredients}:'
            : '${S.of(context).ingredients_for} ${recipe.servings} ${recipe.servingName ?? S.of(context).servings}:',
      );
    for (var section = 0; section < recipe.ingredients.length; section++) {
      if (section < recipe.ingredientsGlossary.length &&
          recipe.ingredientsGlossary[section].isNotEmpty) {
        buffer.writeln(recipe.ingredientsGlossary[section]);
      }
      for (final ingredient in recipe.ingredients[section]) {
        buffer.writeln(
          [ingredient.amount, ingredient.unit, ingredient.name]
              .where((part) => part != null && part.toString().isNotEmpty)
              .join(' '),
        );
      }
    }
    if (recipe.steps.isNotEmpty) {
      buffer
        ..writeln('====================')
        ..writeln('${S.of(context).directions}:');
      for (var index = 0; index < recipe.steps.length; index++) {
        final title = index < (recipe.stepTitles?.length ?? 0)
            ? recipe.stepTitles![index]
            : '';
        if (title.isNotEmpty) buffer.writeln(title);
        buffer.writeln('${index + 1}. ${recipe.steps[index]}');
      }
    }
    if (recipe.tags.isNotEmpty) {
      buffer
        ..writeln('====================')
        ..writeln(
          '${S.of(context).tags}: ${recipe.tags.map((tag) => tag.text).join(', ')}',
        );
    }
    if (recipe.notes.isNotEmpty) {
      buffer
        ..writeln('====================')
        ..writeln('${S.of(context).notes}: ${recipe.notes}');
    }
    if (recipe.source?.isNotEmpty == true) {
      buffer
        ..writeln('====================')
        ..writeln('${S.of(context).source}: ${recipe.source}');
    }
    return buffer.toString();
  }
}

class _UnavailableRecipeScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Theme(
      data: culinaryEditorialTheme(Theme.of(context), palette),
      child: Scaffold(
        backgroundColor: palette.background,
        appBar: AppBar(title: Text(S.of(context).recipe_detail)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: IconInfoMessage(
              iconWidget: const Icon(
                MdiIcons.alertCircle,
                color: Colors.red,
                size: 70,
              ),
              description: S.of(context).recipe_edited_or_deleted,
            ),
          ),
        ),
      ),
    );
  }
}
