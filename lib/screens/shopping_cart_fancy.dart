import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../blocs/app/app_bloc.dart';
import '../blocs/shopping_cart/shopping_cart_bloc.dart';
import '../constants/global_settings.dart';
import '../generated/l10n.dart';
import '../models/ingredient.dart';
import '../models/shopping_cart_data.dart';
import '../util/helper.dart';
import '../widgets/culinary_editorial_theme.dart';
import '../widgets/dialogs/info_dialog.dart';
import '../widgets/dialogs/shopping_cart_add_dialog.dart';
import 'recipe_search_screen.dart';

class FancyShoppingCartScreen extends StatefulWidget {
  const FancyShoppingCartScreen(this.shoppingCartImage, {super.key});

  // Kept for source compatibility with the unchanged wide-screen cart shell.
  final Image? shoppingCartImage;

  @override
  State<FancyShoppingCartScreen> createState() =>
      _FancyShoppingCartScreenState();
}

class _FancyShoppingCartScreenState extends State<FancyShoppingCartScreen>
    with WidgetsBindingObserver {
  final _quickAddController = TextEditingController();
  final _quickAddFocus = FocusNode();
  bool _keepAwake = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _quickAddController.dispose();
    _quickAddFocus.dispose();
    if (_keepAwake) WakelockPlus.disable();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_keepAwake) return;
    if (state == AppLifecycleState.resumed && _isShoppingTabActive) {
      WakelockPlus.enable();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      WakelockPlus.disable();
    }
  }

  bool get _isShoppingTabActive {
    final state = context.read<AppBloc>().state;
    return state is LoadedState && state.selectedIndex == 2;
  }

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return BlocListener<AppBloc, AppState>(
      listenWhen: (previous, current) =>
          current is LoadedState && current.selectedIndex != 2,
      listener: (_, __) {
        if (_keepAwake) _setKeepAwake(false);
      },
      child: BlocConsumer<ShoppingCartBloc, ShoppingCartState>(
        listener: _listenForCartFeedback,
        builder: (context, state) {
          return ColoredBox(
            color: palette.background,
            child: SafeArea(
              bottom: false,
              child: switch (state) {
                LoadingShoppingCart() => _LoadingCart(palette: palette),
                FailedShoppingCart() => _FailureCart(
                  palette: palette,
                  onRetry: () =>
                      context.read<ShoppingCartBloc>().add(LoadShoppingCart()),
                ),
                LoadedShoppingCart() => _buildLoaded(context, state, palette),
                _ => const SizedBox.shrink(),
              },
            ),
          );
        },
      ),
    );
  }

  void _listenForCartFeedback(BuildContext context, ShoppingCartState state) {
    if (state is! LoadedShoppingCart) return;
    final messenger = ScaffoldMessenger.of(context);
    if (state.actionError != null) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(S.of(context).shopping_action_failed)),
        );
      return;
    }
    final snapshot = state.undoSnapshot;
    if (snapshot == null) {
      messenger.hideCurrentSnackBar();
      return;
    }
    final removedCount = _checkedItemCount(snapshot);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(S.of(context).shopping_removed_items(removedCount)),
          action: SnackBarAction(
            label: S.of(context).undo,
            onPressed: () => context.read<ShoppingCartBloc>().add(
              RestoreShoppingCart(snapshot),
            ),
          ),
        ),
      );
  }

  Widget _buildLoaded(
    BuildContext context,
    LoadedShoppingCart state,
    CulinaryEditorialPalette palette,
  ) {
    final data = state.data;
    final items = data.consolidatedItems;
    final appState = context.watch<AppBloc>().state;
    final showPlainList = appState is LoadedState
        ? appState.showShoppingCartSummary
        : true;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Stack(
      children: [
        CustomScrollView(
          key: const PageStorageKey('culinary-shopping-cart'),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            SliverToBoxAdapter(
              child: _CartHeader(
                data: data,
                palette: palette,
                onShare: items.isEmpty ? null : () => _share(data),
                onRemoveChecked: _checkedItemCount(data) == 0
                    ? null
                    : () => _confirmRemoveChecked(data),
                onSearch: _showRecipeSearch,
                onHelp: _showHelp,
              ),
            ),
            if (data.recipeSources.any((source) => source.recipe != null))
              SliverToBoxAdapter(
                child: _RecipeSourceStrip(
                  data: data,
                  palette: palette,
                  onAdjust: () => _showServingsSheet(palette),
                ),
              ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: _ProgressCard(items: items, palette: palette),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: _ViewSwitcher(
                  showPlainList: showPlainList,
                  palette: palette,
                  onChanged: (plain) => context.read<AppBloc>().add(
                    ShoppingCartShowSummary(plain),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
                child: _buildQuickAdd(palette),
              ),
            ),
            if (items.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 92 + bottomInset),
                  child: _EmptyCart(palette: palette),
                ),
              )
            else
              _buildListSliver(data, showPlainList, palette),
            if (items.isNotEmpty)
              SliverToBoxAdapter(child: SizedBox(height: 92 + bottomInset)),
          ],
        ),
        Positioned(
          left: 20,
          right: 20,
          bottom: 12 + bottomInset,
          child: _KeepAwakeDock(
            active: _keepAwake,
            palette: palette,
            onChanged: _setKeepAwake,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAdd(CulinaryEditorialPalette palette) {
    final canAdd = _quickAddController.text.trim().isNotEmpty;
    return Container(
      constraints: const BoxConstraints(minHeight: 60),
      padding: const EdgeInsets.fromLTRB(4, 4, 6, 4),
      decoration: _cardDecoration(palette, radius: 14),
      child: Row(
        children: [
          IconButton(
            tooltip: S.of(context).shopping_add_details,
            onPressed: _showDetailedAdd,
            icon: Icon(Icons.add_circle_outline, color: palette.outline),
          ),
          Expanded(
            child: TextField(
              key: const Key('shopping-cart-quick-add'),
              controller: _quickAddController,
              focusNode: _quickAddFocus,
              textInputAction: TextInputAction.done,
              onChanged: (_) => setState(() {}),
              onSubmitted: (_) => _quickAdd(),
              style: CulinaryEditorialType.body(palette, size: 14),
              decoration: InputDecoration.collapsed(
                hintText: S.of(context).shopping_quick_add_hint,
                hintStyle: CulinaryEditorialType.body(
                  palette,
                  size: 13,
                  color: palette.outline,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          FilledButton(
            onPressed: canAdd ? _quickAdd : null,
            style: FilledButton.styleFrom(
              minimumSize: const Size(58, 48),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              backgroundColor: palette.primary,
              foregroundColor: palette.onPrimary,
              disabledBackgroundColor: palette.surfaceContainerHigh,
              disabledForegroundColor: palette.outline,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(S.of(context).add),
          ),
        ],
      ),
    );
  }

  Widget _buildListSliver(
    ShoppingCartData data,
    bool showPlainList,
    CulinaryEditorialPalette palette,
  ) {
    if (showPlainList) {
      final rows = <Widget>[];
      for (var index = 0; index < data.consolidatedItems.length; index++) {
        final item = data.consolidatedItems[index];
        rows.add(
          _ShoppingItemRow(
            key: ValueKey('summary-${item.name}-${item.unit}-$index'),
            source: data.summary!,
            item: item,
            sourceNames: _sourceNames(data, item),
            palette: palette,
          ),
        );
        if (index != data.consolidatedItems.length - 1) {
          rows.add(const SizedBox(height: 8));
        }
      }
      return SliverPadding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        sliver: SliverList(delegate: SliverChildListDelegate(rows)),
      );
    }

    final sections = <Widget>[];
    for (final source in data.recipeSources) {
      sections.add(_RecipeGroup(source: source, palette: palette));
      sections.add(const SizedBox(height: 22));
    }
    final otherItems = data.consolidatedItems
        .where((item) => _sourceNames(data, item).isEmpty)
        .toList(growable: false);
    if (otherItems.isNotEmpty && data.summary != null) {
      sections.add(
        _OtherItemsGroup(
          source: data.summary!,
          items: otherItems,
          palette: palette,
        ),
      );
    }
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      sliver: SliverList(delegate: SliverChildListDelegate(sections)),
    );
  }

  List<String> _sourceNames(ShoppingCartData data, CheckableIngredient item) {
    return data.recipeSources
        .where(
          (source) => source.items.any(
            (candidate) =>
                candidate.name == item.name && candidate.unit == item.unit,
          ),
        )
        .map((source) => source.displayName)
        .toSet()
        .toList(growable: false);
  }

  void _quickAdd() {
    final name = _quickAddController.text.trim();
    if (name.isEmpty) return;
    context.read<ShoppingCartBloc>().add(
      AddShoppingCartIngredient(Ingredient(name: name, unit: '')),
    );
    _quickAddController.clear();
    _quickAddFocus.unfocus();
    setState(() {});
  }

  void _showDetailedAdd() {
    showDialog<void>(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<ShoppingCartBloc>(),
        child: const ShoppingCartAddDialog(),
      ),
    );
  }

  Future<void> _setKeepAwake(bool enabled) async {
    if (_keepAwake == enabled) return;
    setState(() => _keepAwake = enabled);
    try {
      if (enabled && _isShoppingTabActive) {
        await WakelockPlus.enable();
      } else {
        await WakelockPlus.disable();
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _keepAwake = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).shopping_action_failed)),
      );
    }
  }

  Future<void> _confirmRemoveChecked(ShoppingCartData data) async {
    final count = _checkedItemCount(data);
    final palette = CulinaryEditorialPalette.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: palette.surface,
        title: Text(
          S.of(context).shopping_remove_checked_title,
          style: CulinaryEditorialType.headline(palette, size: 21),
        ),
        content: Text(
          S.of(context).shopping_remove_checked_description(count),
          style: CulinaryEditorialType.body(palette, size: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(S.of(context).cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: palette.primary,
              foregroundColor: palette.onPrimary,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(S.of(context).shopping_remove_checked),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      context.read<ShoppingCartBloc>().add(RemoveCheckedIngredients());
    }
  }

  void _share(ShoppingCartData data) {
    final buffer = StringBuffer('${S.of(context).shopping_list}:\n');
    for (final ingredient in data.consolidatedItems) {
      if (ingredient.checked) buffer.write('✅ ');
      if (ingredient.amount != null) {
        buffer.write(
          '${GlobalSettings().showDecimal() ? cutDouble(ingredient.amount!) : getFractionDouble(ingredient.amount!)} ',
        );
      }
      if (ingredient.unit?.isNotEmpty == true) {
        buffer.write('${ingredient.unit} ');
      }
      buffer.writeln(ingredient.name);
    }
    SharePlus.instance.share(
      ShareParams(
        text: buffer.toString(),
        subject: S.of(context).shopping_list,
      ),
    );
  }

  void _showRecipeSearch() {
    openRecipeSearch(context);
  }

  void _showHelp() {
    showDialog<void>(
      context: context,
      builder: (_) => InfoDialog(
        title: S.of(context).shopping_cart_help,
        body: S.of(context).shopping_cart_help_desc,
      ),
    );
  }

  void _showServingsSheet(CulinaryEditorialPalette palette) {
    final shoppingCartBloc = context.read<ShoppingCartBloc>();
    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: palette.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => BlocProvider.value(
        value: shoppingCartBloc,
        child: BlocBuilder<ShoppingCartBloc, ShoppingCartState>(
          builder: (context, state) {
            final sources = state is LoadedShoppingCart
                ? state.data.recipeSources
                      .where(
                        (source) =>
                            source.recipe != null &&
                            source.effectiveServings != null &&
                            source.effectiveServings! > 0,
                      )
                      .toList(growable: false)
                : const <ShoppingCartSourceData>[];
            return Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                12,
                20,
                20 + MediaQuery.viewInsetsOf(sheetContext).bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 42,
                      height: 4,
                      decoration: BoxDecoration(
                        color: palette.outline.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    S.of(context).shopping_adjust_servings,
                    style: CulinaryEditorialType.headline(palette, size: 24),
                  ),
                  const SizedBox(height: 16),
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: sources.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) => _ServingRow(
                        source: sources[index],
                        palette: palette,
                        onSet: (value) => context.read<ShoppingCartBloc>().add(
                          UpdateShoppingCartServings(sources[index].key, value),
                        ),
                        onEnter: () =>
                            _showServingEntry(sources[index], palette),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _showServingEntry(
    ShoppingCartSourceData source,
    CulinaryEditorialPalette palette,
  ) async {
    final controller = TextEditingController(
      text: _formatNumber(source.effectiveServings!),
    );
    final formKey = GlobalKey<FormState>();
    final value = await showDialog<double>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: palette.surface,
        title: Text(
          source.displayName,
          style: CulinaryEditorialType.headline(palette, size: 20),
        ),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: S.of(context).servings),
            validator: (text) {
              final parsed = getDoubleFromString(text ?? '');
              if (parsed == null || parsed <= 0) {
                return S.of(context).shopping_invalid_servings;
              }
              return null;
            },
            onFieldSubmitted: (_) {
              if (formKey.currentState!.validate()) {
                Navigator.pop(
                  dialogContext,
                  getDoubleFromString(controller.text),
                );
              }
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(S.of(context).cancel),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(
                  dialogContext,
                  getDoubleFromString(controller.text),
                );
              }
            },
            child: Text(S.of(context).done),
          ),
        ],
      ),
    );
    controller.dispose();
    if (value != null && mounted) {
      context.read<ShoppingCartBloc>().add(
        UpdateShoppingCartServings(source.key, value),
      );
    }
  }
}

enum _CartMenuAction { search, help }

class _CartHeader extends StatelessWidget {
  const _CartHeader({
    required this.data,
    required this.palette,
    required this.onShare,
    required this.onRemoveChecked,
    required this.onSearch,
    required this.onHelp,
  });

  final ShoppingCartData data;
  final CulinaryEditorialPalette palette;
  final VoidCallback? onShare;
  final VoidCallback? onRemoveChecked;
  final VoidCallback onSearch;
  final VoidCallback onHelp;

  @override
  Widget build(BuildContext context) {
    final total = data.consolidatedItems.length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 12, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      S.of(context).shopping_list,
                      style: CulinaryEditorialType.headline(palette),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: palette.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        S.of(context).shopping_item_count(total),
                        style: CulinaryEditorialType.body(
                          palette,
                          size: 11,
                          weight: FontWeight.w600,
                          color: palette.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _HeaderAction(
            icon: Icons.ios_share_outlined,
            tooltip: S.of(context).share_shopping_list,
            palette: palette,
            onPressed: onShare,
          ),
          _HeaderAction(
            icon: Icons.cleaning_services_outlined,
            tooltip: S.of(context).shopping_remove_checked,
            palette: palette,
            onPressed: onRemoveChecked,
          ),
          PopupMenuButton<_CartMenuAction>(
            tooltip: S.of(context).shopping_more_actions,
            color: palette.surface,
            icon: Icon(Icons.more_vert, color: palette.onSurfaceVariant),
            onSelected: (action) {
              if (action == _CartMenuAction.search) {
                onSearch();
              } else {
                onHelp();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: _CartMenuAction.search,
                child: _MenuLabel(
                  icon: Icons.search,
                  label: S.of(context).shopping_search_recipes,
                  palette: palette,
                ),
              ),
              PopupMenuItem(
                value: _CartMenuAction.help,
                child: _MenuLabel(
                  icon: Icons.help_outline,
                  label: S.of(context).shopping_cart_help,
                  palette: palette,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderAction extends StatelessWidget {
  const _HeaderAction({
    required this.icon,
    required this.tooltip,
    required this.palette,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final CulinaryEditorialPalette palette;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      constraints: const BoxConstraints.tightFor(width: 48, height: 48),
      style: IconButton.styleFrom(
        backgroundColor: onPressed == null
            ? Colors.transparent
            : palette.surfaceContainer,
        foregroundColor: palette.onSurfaceVariant,
        disabledForegroundColor: palette.outline.withValues(alpha: 0.45),
      ),
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
    );
  }
}

class _MenuLabel extends StatelessWidget {
  const _MenuLabel({
    required this.icon,
    required this.label,
    required this.palette,
  });

  final IconData icon;
  final String label;
  final CulinaryEditorialPalette palette;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: palette.onSurfaceVariant, size: 20),
        const SizedBox(width: 12),
        Flexible(
          child: Text(label, style: CulinaryEditorialType.body(palette)),
        ),
      ],
    );
  }
}

class _RecipeSourceStrip extends StatelessWidget {
  const _RecipeSourceStrip({
    required this.data,
    required this.palette,
    required this.onAdjust,
  });

  final ShoppingCartData data;
  final CulinaryEditorialPalette palette;
  final VoidCallback onAdjust;

  @override
  Widget build(BuildContext context) {
    final sources = data.recipeSources
        .where((source) => source.recipe != null)
        .toList(growable: false);
    final adjustable = sources.any(
      (source) =>
          source.effectiveServings != null && source.effectiveServings! > 0,
    );
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    S.of(context).shopping_for_recipes(sources.length),
                    style: CulinaryEditorialType.body(
                      palette,
                      size: 11,
                      weight: FontWeight.w600,
                      color: palette.onSurfaceVariant,
                    ),
                  ),
                ),
                TextButton.icon(
                  key: const Key('shopping-cart-adjust-servings'),
                  onPressed: adjustable ? onAdjust : null,
                  icon: const Icon(Icons.tune, size: 16),
                  label: Text(S.of(context).shopping_adjust_servings),
                  style: TextButton.styleFrom(
                    foregroundColor: palette.primary,
                    minimumSize: const Size(48, 48),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 62,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: sources.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final source = sources[index];
                final serving = source.effectiveServings;
                final accent = [
                  palette.primary,
                  palette.tertiary,
                  palette.secondary,
                ][index % 3];
                return Container(
                  constraints: const BoxConstraints(
                    minWidth: 132,
                    maxWidth: 190,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: _cardDecoration(palette, radius: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.restaurant_menu, color: accent, size: 19),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              source.displayName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: CulinaryEditorialType.body(
                                palette,
                                size: 12,
                                weight: FontWeight.w700,
                              ),
                            ),
                            if (serving != null && serving > 0)
                              Text(
                                S
                                    .of(context)
                                    .shopping_serving_value(
                                      _formatNumber(serving),
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: CulinaryEditorialType.body(
                                  palette,
                                  size: 10,
                                  color: palette.outline,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({required this.items, required this.palette});

  final List<CheckableIngredient> items;
  final CulinaryEditorialPalette palette;

  @override
  Widget build(BuildContext context) {
    final checked = items.where((item) => item.checked).length;
    final percent = items.isEmpty
        ? 0
        : ((checked / items.length) * 100).round();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(palette, radius: 14),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.shopping_basket_outlined,
                color: palette.primary,
                size: 20,
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  S.of(context).shopping_progress(checked, items.length),
                  style: CulinaryEditorialType.body(
                    palette,
                    size: 12,
                    weight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                S.of(context).shopping_percent_gathered(percent),
                style: CulinaryEditorialType.body(
                  palette,
                  size: 10,
                  weight: FontWeight.w700,
                  color: palette.outline,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: SizedBox(
              key: const Key('shopping-cart-progress-track'),
              height: 8,
              child: ColoredBox(
                color: palette.surfaceContainerHigh,
                child: LayoutBuilder(
                  builder: (context, constraints) =>
                      TweenAnimationBuilder<double>(
                        tween: Tween(end: percent / 100),
                        duration: MediaQuery.disableAnimationsOf(context)
                            ? Duration.zero
                            : const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                        builder: (_, value, __) => Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            key: const Key('shopping-cart-progress-fill'),
                            width: constraints.maxWidth * value,
                            height: constraints.maxHeight,
                            child: ColoredBox(color: palette.primary),
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

class _ViewSwitcher extends StatelessWidget {
  const _ViewSwitcher({
    required this.showPlainList,
    required this.palette,
    required this.onChanged,
  });

  final bool showPlainList;
  final CulinaryEditorialPalette palette;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      child: Container(
        height: 48,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: palette.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: _ViewOption(
                key: const Key('shopping-cart-plain-view'),
                label: S.of(context).shopping_plain_list,
                selected: showPlainList,
                palette: palette,
                onTap: () => onChanged(true),
              ),
            ),
            Expanded(
              child: _ViewOption(
                key: const Key('shopping-cart-recipe-view'),
                label: S.of(context).shopping_by_recipe,
                selected: !showPlainList,
                palette: palette,
                onTap: () => onChanged(false),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ViewOption extends StatelessWidget {
  const _ViewOption({
    super.key,
    required this.label,
    required this.selected,
    required this.palette,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final CulinaryEditorialPalette palette;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected ? palette.surface : Colors.transparent,
        borderRadius: BorderRadius.circular(9),
        elevation: selected ? 1 : 0,
        shadowColor: palette.shadow,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(9),
          child: Center(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: CulinaryEditorialType.body(
                palette,
                size: 12,
                weight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? palette.onSurface : palette.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RecipeGroup extends StatefulWidget {
  const _RecipeGroup({required this.source, required this.palette});

  final ShoppingCartSourceData source;
  final CulinaryEditorialPalette palette;

  @override
  State<_RecipeGroup> createState() => _RecipeGroupState();
}

class _RecipeGroupState extends State<_RecipeGroup> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    final source = widget.source;
    final palette = widget.palette;
    return Dismissible(
      key: ValueKey('recipe-group-${source.key}'),
      background: _DismissBackground(palette: palette),
      secondaryBackground: _DismissBackground(palette: palette, end: true),
      onDismissed: (_) => context.read<ShoppingCartBloc>().add(
        RemoveIngredients(null, source.legacyRecipe),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            button: true,
            expanded: _expanded,
            child: InkWell(
              onTap: () => setState(() => _expanded = !_expanded),
              borderRadius: BorderRadius.circular(10),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 48),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: palette.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        source.displayName,
                        style: CulinaryEditorialType.headline(
                          palette,
                          size: 18,
                          weight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      S.of(context).shopping_item_count(source.items.length),
                      style: CulinaryEditorialType.body(
                        palette,
                        size: 10,
                        weight: FontWeight.w600,
                        color: palette.outline,
                      ),
                    ),
                    const SizedBox(width: 4),
                    AnimatedRotation(
                      turns: _expanded ? 0 : -0.25,
                      duration: MediaQuery.disableAnimationsOf(context)
                          ? Duration.zero
                          : const Duration(milliseconds: 180),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: palette.outline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedCrossFade(
            duration: MediaQuery.disableAnimationsOf(context)
                ? Duration.zero
                : const Duration(milliseconds: 180),
            crossFadeState: _expanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Column(
              children: [
                for (var index = 0; index < source.items.length; index++) ...[
                  _ShoppingItemRow(
                    key: ValueKey(
                      '${source.key}-${source.items[index].name}-${source.items[index].unit}-$index',
                    ),
                    source: source,
                    item: source.items[index],
                    sourceNames: const [],
                    palette: palette,
                  ),
                  if (index != source.items.length - 1)
                    const SizedBox(height: 8),
                ],
              ],
            ),
            secondChild: const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}

class _OtherItemsGroup extends StatelessWidget {
  const _OtherItemsGroup({
    required this.source,
    required this.items,
    required this.palette,
  });

  final ShoppingCartSourceData source;
  final List<CheckableIngredient> items;
  final CulinaryEditorialPalette palette;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: palette.tertiary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  S.of(context).shopping_other_items,
                  style: CulinaryEditorialType.headline(
                    palette,
                    size: 18,
                    weight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                S.of(context).shopping_item_count(items.length),
                style: CulinaryEditorialType.body(
                  palette,
                  size: 10,
                  weight: FontWeight.w600,
                  color: palette.outline,
                ),
              ),
            ],
          ),
        ),
        for (var index = 0; index < items.length; index++) ...[
          _ShoppingItemRow(
            key: ValueKey(
              'other-${items[index].name}-${items[index].unit}-$index',
            ),
            source: source,
            item: items[index],
            sourceNames: const [],
            palette: palette,
          ),
          if (index != items.length - 1) const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _ShoppingItemRow extends StatelessWidget {
  const _ShoppingItemRow({
    super.key,
    required this.source,
    required this.item,
    required this.sourceNames,
    required this.palette,
  });

  final ShoppingCartSourceData source;
  final CheckableIngredient item;
  final List<String> sourceNames;
  final CulinaryEditorialPalette palette;

  @override
  Widget build(BuildContext context) {
    final amount = _ingredientAmount(item);
    void removeItem() => context.read<ShoppingCartBloc>().add(
      RemoveIngredients([item.getIngredient()], source.legacyRecipe),
    );

    return Dismissible(
      key: ValueKey('dismiss-${source.key}-${item.name}-${item.unit}'),
      background: _DismissBackground(palette: palette),
      secondaryBackground: _DismissBackground(palette: palette, end: true),
      onDismissed: (_) => removeItem(),
      child: Semantics(
        button: true,
        checked: item.checked,
        label: item.name,
        customSemanticsActions: {
          CustomSemanticsAction(
            label: S.of(context).shopping_remove_item(item.name),
          ): removeItem,
        },
        child: Material(
          color: palette.surface,
          borderRadius: BorderRadius.circular(14),
          elevation: 1,
          shadowColor: palette.shadow,
          child: InkWell(
            onTap: () => context.read<ShoppingCartBloc>().add(
              CheckIngredients([item], source.legacyRecipe),
            ),
            borderRadius: BorderRadius.circular(14),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 68),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: sourceNames.isEmpty
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: AnimatedContainer(
                        duration: MediaQuery.disableAnimationsOf(context)
                            ? Duration.zero
                            : const Duration(milliseconds: 160),
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: item.checked
                              ? palette.secondary
                              : palette.surfaceContainerHigh,
                          shape: BoxShape.circle,
                        ),
                        child: item.checked
                            ? Icon(
                                Icons.check,
                                size: 16,
                                color:
                                    ThemeData.estimateBrightnessForColor(
                                          palette.secondary,
                                        ) ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  item.name,
                                  style:
                                      CulinaryEditorialType.body(
                                        palette,
                                        size: 14,
                                        weight: FontWeight.w600,
                                        color: item.checked
                                            ? palette.outline
                                            : palette.onSurface,
                                      ).copyWith(
                                        decoration: item.checked
                                            ? TextDecoration.lineThrough
                                            : null,
                                      ),
                                ),
                              ),
                              if (amount.isNotEmpty) ...[
                                const SizedBox(width: 10),
                                Text(
                                  amount,
                                  textAlign: TextAlign.end,
                                  style: CulinaryEditorialType.body(
                                    palette,
                                    size: 11,
                                    weight: FontWeight.w700,
                                    color: palette.primary,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          if (sourceNames.isNotEmpty) ...[
                            const SizedBox(height: 5),
                            Wrap(
                              spacing: 4,
                              runSpacing: 4,
                              children: sourceNames
                                  .map(
                                    (name) => Container(
                                      constraints: const BoxConstraints(
                                        maxWidth: 190,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: palette.surfaceContainer,
                                        borderRadius: BorderRadius.circular(99),
                                      ),
                                      child: Text(
                                        name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: CulinaryEditorialType.body(
                                          palette,
                                          size: 9,
                                          weight: FontWeight.w600,
                                          color: palette.onSurfaceVariant,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(growable: false),
                            ),
                          ],
                        ],
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

class _DismissBackground extends StatelessWidget {
  const _DismissBackground({required this.palette, this.end = false});

  final CulinaryEditorialPalette palette;
  final bool end;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: end ? Alignment.centerRight : Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(
        Icons.delete_outline,
        color: Theme.of(context).colorScheme.onErrorContainer,
      ),
    );
  }
}

class _ServingRow extends StatelessWidget {
  const _ServingRow({
    required this.source,
    required this.palette,
    required this.onSet,
    required this.onEnter,
  });

  final ShoppingCartSourceData source;
  final CulinaryEditorialPalette palette;
  final ValueChanged<double> onSet;
  final VoidCallback onEnter;

  @override
  Widget build(BuildContext context) {
    final servings = source.effectiveServings!;
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 8, 8, 8),
      decoration: BoxDecoration(
        color: palette.surfaceContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              source.displayName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: CulinaryEditorialType.body(
                palette,
                size: 13,
                weight: FontWeight.w700,
              ),
            ),
          ),
          IconButton(
            tooltip: S.of(context).decrease_servings,
            onPressed: servings > 1
                ? () => onSet(servings - 1 < 1 ? 1 : servings - 1)
                : null,
            icon: const Icon(Icons.remove),
          ),
          TextButton(
            onPressed: onEnter,
            style: TextButton.styleFrom(
              minimumSize: const Size(56, 48),
              foregroundColor: palette.onSurface,
            ),
            child: Text(_formatNumber(servings)),
          ),
          IconButton(
            tooltip: S.of(context).increase_servings,
            onPressed: () => onSet(servings + 1),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

class _KeepAwakeDock extends StatelessWidget {
  const _KeepAwakeDock({
    required this.active,
    required this.palette,
    required this.onChanged,
  });

  final bool active;
  final CulinaryEditorialPalette palette;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      toggled: active,
      child: Material(
        key: const Key('shopping-cart-keep-awake'),
        color: active ? palette.secondarySoft : palette.surface,
        borderRadius: BorderRadius.circular(18),
        elevation: 8,
        shadowColor: palette.shadow,
        child: InkWell(
          onTap: () => onChanged(!active),
          borderRadius: BorderRadius.circular(18),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 64),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  Icon(
                    active ? Icons.visibility : Icons.visibility_outlined,
                    color: active ? palette.secondary : palette.primary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).keep_screen_on,
                          style: CulinaryEditorialType.body(
                            palette,
                            size: 12,
                            weight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          active
                              ? S.of(context).shopping_mode_active
                              : S.of(context).shopping_mode,
                          style: CulinaryEditorialType.body(
                            palette,
                            size: 10,
                            color: palette.outline,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: active,
                    onChanged: onChanged,
                    activeThumbColor: palette.secondary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart({required this.palette});

  final CulinaryEditorialPalette palette;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 110),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_basket_outlined,
              size: 48,
              color: palette.primary,
            ),
            const SizedBox(height: 14),
            Text(
              S.of(context).shopping_cart_is_empty,
              textAlign: TextAlign.center,
              style: CulinaryEditorialType.headline(palette, size: 22),
            ),
            const SizedBox(height: 8),
            Text(
              S.of(context).shopping_empty_description,
              textAlign: TextAlign.center,
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

class _LoadingCart extends StatelessWidget {
  const _LoadingCart({required this.palette});

  final CulinaryEditorialPalette palette;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: S.of(context).loading_data,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SkeletonBar(width: 112, height: 10, palette: palette),
            const SizedBox(height: 10),
            _SkeletonBar(width: 220, height: 32, palette: palette),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(child: _SkeletonBar(height: 62, palette: palette)),
                const SizedBox(width: 8),
                Expanded(child: _SkeletonBar(height: 62, palette: palette)),
              ],
            ),
            const SizedBox(height: 18),
            _SkeletonBar(height: 78, palette: palette),
            const SizedBox(height: 16),
            _SkeletonBar(height: 48, palette: palette),
            const SizedBox(height: 16),
            _SkeletonBar(height: 60, palette: palette),
            const Spacer(),
            Center(
              child: SizedBox.square(
                dimension: 24,
                child: CircularProgressIndicator(
                  color: palette.primary,
                  strokeWidth: 2.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkeletonBar extends StatelessWidget {
  const _SkeletonBar({this.width, required this.height, required this.palette});

  final double? width;
  final double height;
  final CulinaryEditorialPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: palette.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(height > 40 ? 14 : 8),
      ),
    );
  }
}

class _FailureCart extends StatelessWidget {
  const _FailureCart({required this.palette, required this.onRetry});

  final CulinaryEditorialPalette palette;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: palette.primary),
            const SizedBox(height: 14),
            Text(
              S.of(context).shopping_load_failed,
              textAlign: TextAlign.center,
              style: CulinaryEditorialType.headline(palette, size: 22),
            ),
            const SizedBox(height: 8),
            Text(
              S.of(context).shopping_load_failed_description,
              textAlign: TextAlign.center,
              style: CulinaryEditorialType.body(
                palette,
                size: 13,
                color: palette.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(S.of(context).retry),
              style: FilledButton.styleFrom(
                minimumSize: const Size(120, 48),
                backgroundColor: palette.primary,
                foregroundColor: palette.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

BoxDecoration _cardDecoration(
  CulinaryEditorialPalette palette, {
  required double radius,
}) {
  return BoxDecoration(
    color: palette.surface,
    borderRadius: BorderRadius.circular(radius),
    boxShadow: [
      BoxShadow(
        color: palette.shadow,
        blurRadius: 16,
        offset: const Offset(0, 4),
      ),
    ],
  );
}

int _checkedItemCount(ShoppingCartData data) {
  final checkedKeys = <String>{};
  for (final source in data.sources) {
    for (final item in source.items.where((item) => item.checked)) {
      checkedKeys.add('${item.name}\u0000${item.unit ?? ''}');
    }
  }
  return checkedKeys.length;
}

String _ingredientAmount(CheckableIngredient ingredient) {
  final amount = ingredient.amount == null
      ? ''
      : GlobalSettings().showDecimal()
      ? cutDouble(ingredient.amount!)
      : getFractionDouble(ingredient.amount!);
  final unit = ingredient.unit?.trim() ?? '';
  if (amount.isEmpty) return unit;
  if (unit.isEmpty) return amount;
  return '$amount $unit';
}

String _formatNumber(double value) => cutDouble(value);
