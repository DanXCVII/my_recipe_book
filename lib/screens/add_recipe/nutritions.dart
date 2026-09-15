import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../ad_related/ad.dart';
import '../../blocs/ad_manager/ad_manager_bloc.dart';
import '../../blocs/new_recipe/nutritions/nutritions_bloc.dart';
import '../../blocs/new_recipe/nutritions/nutritions_event.dart';
import '../../blocs/new_recipe/nutritions/nutritions_state.dart';
import '../../blocs/nutrition_manager/nutrition_manager_bloc.dart';
import '../../blocs/recipe_calendar/recipe_calendar_bloc.dart';
import '../../blocs/recipe_manager/recipe_manager_bloc.dart';
import '../../blocs/shopping_cart/shopping_cart_bloc.dart';
import '../../constants/global_settings.dart';
import '../../constants/routes.dart';
import '../../generated/l10n.dart';
import '../../models/nutrition.dart';
import '../../models/recipe.dart';
import '../../widgets/culinary_editorial_theme.dart';
import '../../widgets/dialogs/textfield_dialog.dart';
import '../../widgets/recipe_editor/editorial_editor_shell.dart';
import '../recipe_screen.dart';

class AddRecipeNutritionsArguments {
  final Recipe modifiedRecipe;
  final String? editingRecipeName;
  final ShoppingCartBloc shoppingCartBloc;
  final RecipeCalendarBloc recipeCalendarBloc;

  AddRecipeNutritionsArguments(
    this.modifiedRecipe,
    this.shoppingCartBloc,
    this.recipeCalendarBloc, {
    this.editingRecipeName,
  });
}

class AddRecipeNutritions extends StatefulWidget {
  final Recipe? modifiedRecipe;
  final String? editingRecipeName;

  const AddRecipeNutritions({
    this.modifiedRecipe,
    this.editingRecipeName,
    super.key,
  });

  @override
  State<AddRecipeNutritions> createState() => _AddRecipeNutritionsState();
}

class _AddRecipeNutritionsState extends State<AddRecipeNutritions>
    with WidgetsBindingObserver {
  final Map<String, TextEditingController> _controllers = {};
  final Set<String> _pendingDeleted = {};
  final Map<String, String> _pendingRenames = {};
  final FocusNode _lifecycleFocus = FocusNode();
  FocusNode? _exitFocusNode;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _lifecycleFocus.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _exitFocusNode = FocusScope.of(context).focusedChild;
      FocusScope.of(context).requestFocus(_lifecycleFocus);
    } else if (state == AppLifecycleState.resumed) {
      FocusScope.of(context).requestFocus(_exitFocusNode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _finishedEditingNutritions(true);
      },
      child: BlocListener<NutritionsBloc, NutritionsState>(
        listener: _onSaveState,
        child: BlocBuilder<NutritionManagerBloc, NutritionManagerState>(
          builder: (context, managerState) {
            if (managerState is! LoadedNutritionManager) {
              return const Scaffold(
                body: SafeArea(
                  child: Center(child: CircularProgressIndicator()),
                ),
              );
            }
            _syncControllers(managerState.nutritions);
            final visibleNutritions = managerState.nutritions
                .where((name) => !_pendingDeleted.contains(name))
                .toList();
            return BlocBuilder<NutritionsBloc, NutritionsState>(
              builder: (context, saveState) {
                final busy =
                    saveState is NEditingFinished ||
                    saveState is NEditingFinishedGoBack ||
                    saveState is NSavingTmpData;
                return EditorialEditorShell(
                  stage: 4,
                  recipe: widget.modifiedRecipe!,
                  title: S.of(context).editor_nutrition,
                  primaryLabel: widget.editingRecipeName == null
                      ? S.of(context).save_recipe
                      : S.of(context).save_changes,
                  busy: busy,
                  onBack: busy ? null : () => _finishedEditingNutritions(true),
                  onPrimary: busy
                      ? null
                      : () => _finishedEditingNutritions(false),
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).values_per_serving_optional,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 14),
                      if (visibleNutritions.isEmpty)
                        _EmptyNutrition(onAdd: () => _addNutrition(context))
                      else
                        ReorderableListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          buildDefaultDragHandles: false,
                          itemCount: visibleNutritions.length,
                          onReorderItem: (oldIndex, newIndex) {
                            context.read<NutritionManagerBloc>().add(
                              MoveNutrition(oldIndex, newIndex),
                            );
                          },
                          itemBuilder: (context, index) {
                            final name = visibleNutritions[index];
                            return _NutritionRow(
                              key: ValueKey(name),
                              name: name,
                              controller: _controllers[name]!,
                              index: index,
                              onRename: () => _renameNutrition(
                                context,
                                name,
                                visibleNutritions,
                              ),
                              onDelete: () => _deleteNutrition(context, name),
                            );
                          },
                        ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => _addNutrition(context),
                          icon: const Icon(Icons.add),
                          label: Text(S.of(context).add_nutrition_item),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(52),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _syncControllers(List<String> names) {
    _pendingDeleted.removeWhere((name) => !names.contains(name));
    _pendingRenames.removeWhere(
      (oldName, newName) => names.contains(newName) && !names.contains(oldName),
    );
    for (final name in names) {
      if (_pendingDeleted.contains(name)) continue;
      _controllers.putIfAbsent(name, () {
        final matching = widget.modifiedRecipe!.nutritions.where(
          (nutrition) => nutrition.name == name,
        );
        return TextEditingController(
          text: matching.isEmpty ? '' : matching.first.amountUnit,
        );
      });
    }
    final removed = _controllers.keys.where((key) => !names.contains(key));
    for (final name in removed.toList()) {
      _controllers.remove(name)?.dispose();
    }
  }

  void _addNutrition(BuildContext context) {
    final existing = context.read<NutritionManagerBloc>().state;
    final names = existing is LoadedNutritionManager
        ? existing.nutritions
        : const <String>[];
    showDialog<void>(
      context: context,
      builder: (_) => TextFieldDialog(
        validation: (name) => _validateNutritionName(context, name, names),
        save: (name) =>
            context.read<NutritionManagerBloc>().add(AddNutrition(name)),
        hintText: S.of(context).nutrition,
      ),
    );
  }

  void _renameNutrition(
    BuildContext context,
    String oldName,
    List<String> names,
  ) {
    showDialog<void>(
      context: context,
      builder: (_) => TextFieldDialog(
        validation: (name) => name == oldName
            ? null
            : _validateNutritionName(context, name, names),
        save: (name) {
          final controller = _controllers.remove(oldName)!;
          _controllers[name] = controller;
          _pendingRenames[oldName] = name;
          context.read<NutritionManagerBloc>().add(
            UpdateNutrition(oldName, name),
          );
        },
        hintText: S.of(context).nutrition,
        prefilledText: oldName,
      ),
    );
  }

  String? _validateNutritionName(
    BuildContext context,
    String? name,
    List<String> names,
  ) {
    if (name == null || name.trim().isEmpty) {
      return S.of(context).field_must_not_be_empty;
    }
    if (names.contains(name)) return S.of(context).nutrition_already_exists;
    return null;
  }

  void _deleteNutrition(BuildContext context, String name) {
    setState(() {
      _pendingDeleted.add(name);
      _controllers.remove(name)?.dispose();
    });
    context.read<NutritionManagerBloc>().add(DeleteNutrition(name));
  }

  Future<void> _finishedEditingNutritions(bool goBack) async {
    FocusScope.of(context).unfocus();
    final managerState = context.read<NutritionManagerBloc>().state;
    final names = managerState is LoadedNutritionManager
        ? managerState.nutritions
        : _controllers.keys.toList();
    final recipeNutritions = <Nutrition>[];
    for (final managerName in names) {
      if (_pendingDeleted.contains(managerName)) continue;
      final name = _pendingRenames[managerName] ?? managerName;
      final value = _controllers[name]?.text.trim() ?? '';
      if (value.isNotEmpty) {
        recipeNutritions.add(Nutrition(name: name, amountUnit: value));
      }
    }

    context.read<NutritionsBloc>().add(
      FinishedEditing(
        widget.editingRecipeName,
        goBack,
        recipeNutritions,
        context.read<RecipeManagerBloc>(),
      ),
    );
  }

  void _onSaveState(BuildContext context, NutritionsState state) {
    if (state is NEditingFinishedGoBack) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(S.of(context).saving_your_input)));
    } else if (state is NSavedGoBack) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      Navigator.pop(context);
    } else if (state is NSaved) {
      final recipe = state.recipe!;
      if (widget.editingRecipeName == null) {
        Future.delayed(const Duration(milliseconds: 200)).then((_) {
          if (!context.mounted) return;
          Navigator.of(context)
              .pushNamedAndRemoveUntil(
                RouteNames.recipeScreen,
                (route) => route.isFirst,
                arguments: RecipeScreenArguments(
                  context.read<ShoppingCartBloc>(),
                  context.read<RecipeCalendarBloc>(),
                  recipe,
                  'heroImageTag',
                  context.read<RecipeManagerBloc>(),
                ),
              )
              .then((_) => Ads.hideBottomBannerAd());
        });
        context.read<AdManagerBloc>().add(
          StartWatchingVideo(DateTime.now(), false, false),
        );
      } else {
        Future.delayed(const Duration(milliseconds: 300)).then((_) {
          if (!context.mounted) return;
          if (GlobalSettings().standbyDisabled()) WakelockPlus.enable();
          Navigator.pushNamedAndRemoveUntil(
            context,
            RouteNames.recipeScreen,
            ModalRoute.withName('recipeRoute'),
            arguments: RecipeScreenArguments(
              context.read<ShoppingCartBloc>(),
              context.read<RecipeCalendarBloc>(),
              recipe,
              'heroImageTag',
              context.read<RecipeManagerBloc>(),
            ),
          ).then((_) {
            WakelockPlus.disable();
            Ads.hideBottomBannerAd();
          });
        });
      }
    }
  }
}

class _NutritionRow extends StatelessWidget {
  const _NutritionRow({
    super.key,
    required this.name,
    required this.controller,
    required this.index,
    required this.onRename,
    required this.onDelete,
  });

  final String name;
  final TextEditingController controller;
  final int index;
  final VoidCallback onRename;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Container(
      decoration: BoxDecoration(
        color: palette.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: palette.outline.withValues(alpha: .12),
        ),
      ),
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(6, 10, 8, 10),
      child: Row(
        children: [
          ReorderableDragStartListener(
            index: index,
            child: const SizedBox(
              width: 48,
              height: 48,
              child: Icon(Icons.drag_indicator),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: onRename,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 13),
                child: Text(
                  name,
                  style: Theme.of(context).textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 116,
            child: TextField(
              controller: controller,
              textAlign: TextAlign.end,
              decoration: InputDecoration(
                hintText: S.of(context).nutrition_value_hint,
                isDense: true,
              ),
            ),
          ),
          IconButton(
            tooltip: MaterialLocalizations.of(context).deleteButtonTooltip,
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
    );
  }
}

class _EmptyNutrition extends StatelessWidget {
  const _EmptyNutrition({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return EditorialCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 28),
        child: Column(
          children: [
            Icon(
              Icons.restaurant_menu,
              size: 52,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 14),
            Text(
              S.of(context).you_have_no_nutritions,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: Text(S.of(context).add_nutrition_item),
            ),
          ],
        ),
      ),
    );
  }
}
