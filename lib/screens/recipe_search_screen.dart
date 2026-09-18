import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../ad_related/ad.dart';
import '../blocs/recipe_calendar/recipe_calendar_bloc.dart';
import '../blocs/recipe_manager/recipe_manager_bloc.dart';
import '../blocs/shopping_cart/shopping_cart_bloc.dart';
import '../constants/global_constants.dart' as constants;
import '../constants/global_settings.dart';
import '../constants/routes.dart';
import '../generated/l10n.dart';
import '../local_storage/local_repository.dart';
import '../models/string_int_tuple.dart';
import '../widgets/culinary_editorial_theme.dart';
import 'recipe_overview.dart';
import 'recipe_screen.dart';

typedef OpenRecipeSearchResult = Future<bool> Function(String recipeName);
typedef OpenCategorySearchResult = void Function(String category);
typedef OpenTagSearchResult = void Function(StringIntTuple tag);

Future<void> openRecipeSearch(BuildContext context) {
  final repository = context.read<LocalRepository>();
  final shoppingCartBloc = context.read<ShoppingCartBloc>();
  final recipeCalendarBloc = context.read<RecipeCalendarBloc>();
  final recipeManagerBloc = context.read<RecipeManagerBloc>();

  final recipeNames = List<String>.of(repository.getRecipeNames());
  final categories = repository
      .getCategoryNames()
      .where((category) => category != constants.noCategory)
      .toList(growable: false);
  final tags = List<StringIntTuple>.of(repository.getRecipeTags());

  return Navigator.of(context).push<void>(
    MaterialPageRoute<void>(
      settings: const RouteSettings(name: 'recipe-search'),
      builder: (searchContext) => RecipeSearchScreen(
        recipeNames: recipeNames,
        categories: categories,
        tags: tags,
        onOpenRecipe: (recipeName) async {
          final recipe = await repository.getRecipeByName(recipeName);
          if (recipe == null || !searchContext.mounted) return false;

          if (GlobalSettings().standbyDisabled()) {
            await WakelockPlus.enable();
          }
          try {
            await Navigator.pushNamed(
              searchContext,
              RouteNames.recipeScreen,
              arguments: RecipeScreenArguments(
                shoppingCartBloc,
                recipeCalendarBloc,
                recipe,
                'search-${recipe.name}',
                recipeManagerBloc,
              ),
            );
          } finally {
            await WakelockPlus.disable();
            Ads.hideBottomBannerAd();
          }
          return true;
        },
        onOpenCategory: (category) {
          Navigator.pushNamed(
            searchContext,
            RouteNames.recipeCategories,
            arguments: RecipeGridViewArguments(
              category: category,
              shoppingCartBloc: shoppingCartBloc,
              recipeCalendarBloc: recipeCalendarBloc,
            ),
          ).then((_) => Ads.hideBottomBannerAd());
        },
        onOpenTag: (tag) {
          Navigator.pushNamed(
            searchContext,
            RouteNames.recipeTagOverview,
            arguments: RecipeGridViewArguments(
              recipeTag: tag,
              shoppingCartBloc: shoppingCartBloc,
              recipeCalendarBloc: recipeCalendarBloc,
            ),
          ).then((_) => Ads.hideBottomBannerAd());
        },
      ),
    ),
  );
}

class RecipeSearchScreen extends StatefulWidget {
  const RecipeSearchScreen({
    required this.recipeNames,
    required this.categories,
    required this.tags,
    required this.onOpenRecipe,
    required this.onOpenCategory,
    required this.onOpenTag,
    super.key,
  });

  final List<String> recipeNames;
  final List<String> categories;
  final List<StringIntTuple> tags;
  final OpenRecipeSearchResult onOpenRecipe;
  final OpenCategorySearchResult onOpenCategory;
  final OpenTagSearchResult onOpenTag;

  @override
  State<RecipeSearchScreen> createState() => _RecipeSearchScreenState();
}

class _RecipeSearchScreenState extends State<RecipeSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _openingRecipe = false;

  String get _query => _controller.text.trim();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    final editorialTheme = culinaryEditorialTheme(Theme.of(context), palette);
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Theme(
      data: editorialTheme,
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
          key: const Key('recipe-search-screen'),
          backgroundColor: palette.background,
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                _SearchHeader(
                  controller: _controller,
                  focusNode: _focusNode,
                  onChanged: (_) => setState(() {}),
                ),
                Expanded(child: _buildBody(palette)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(CulinaryEditorialPalette palette) {
    final query = _query;
    final animationsEnabled =
        GlobalSettings().animationsEnabled() &&
        !MediaQuery.disableAnimationsOf(context);
    final duration = animationsEnabled
        ? const Duration(milliseconds: 180)
        : Duration.zero;

    late final Widget body;
    if (query.isEmpty) {
      body = _SearchPrompt(
        key: const ValueKey('search-prompt'),
        recipeCount: widget.recipeNames.length,
        categoryCount: widget.categories.length,
        tagCount: widget.tags.length,
      );
    } else {
      final normalizedQuery = query.toLowerCase();
      final recipes = widget.recipeNames
          .where((name) => name.toLowerCase().contains(normalizedQuery))
          .toList(growable: false);
      final categories = widget.categories
          .where((category) => category.toLowerCase().contains(normalizedQuery))
          .toList(growable: false);
      final tags = widget.tags
          .where((tag) => tag.text.toLowerCase().contains(normalizedQuery))
          .toList(growable: false);

      body = recipes.isEmpty && categories.isEmpty && tags.isEmpty
          ? _NoSearchResults(
              key: ValueKey('no-results-$normalizedQuery'),
              query: query,
            )
          : _GroupedSearchResults(
              key: ValueKey('results-$normalizedQuery'),
              recipes: recipes,
              categories: categories,
              tags: tags,
              onOpenRecipe: _openRecipe,
              onOpenCategory: widget.onOpenCategory,
              onOpenTag: widget.onOpenTag,
            );
    }

    return AnimatedSwitcher(
      duration: duration,
      reverseDuration: duration,
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      layoutBuilder: (currentChild, previousChildren) => Stack(
        alignment: Alignment.topCenter,
        fit: StackFit.expand,
        children: [...previousChildren, if (currentChild != null) currentChild],
      ),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween<double>(begin: .985, end: 1).animate(animation),
          child: child,
        ),
      ),
      child: body,
    );
  }

  Future<void> _openRecipe(String recipeName) async {
    if (_openingRecipe) return;
    setState(() => _openingRecipe = true);
    final opened = await widget.onOpenRecipe(recipeName);
    if (!mounted) return;
    setState(() => _openingRecipe = false);
    if (!opened) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).cookbook_search_recipe_missing)),
      );
    }
  }
}

class _SearchHeader extends StatelessWidget {
  const _SearchHeader({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

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
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 20, 12),
            child: Row(
              children: [
                IconButton(
                  key: const Key('recipe-search-back'),
                  tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                  constraints: const BoxConstraints.tightFor(
                    width: 48,
                    height: 52,
                  ),
                  onPressed: () => Navigator.maybePop(context),
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: TextField(
                      key: const Key('recipe-search-field'),
                      controller: controller,
                      focusNode: focusNode,
                      autofocus: true,
                      onChanged: onChanged,
                      textInputAction: TextInputAction.search,
                      style: CulinaryEditorialType.body(
                        palette,
                        size: 15,
                        weight: FontWeight.w600,
                      ),
                      cursorColor: palette.primary,
                      decoration: InputDecoration(
                        hintText: S.of(context).cookbook_search_hint,
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: palette.onSurfaceVariant,
                        ),
                        suffixIcon: controller.text.isEmpty
                            ? null
                            : IconButton(
                                key: const Key('recipe-search-clear'),
                                tooltip: S.of(context).clear_search,
                                onPressed: () {
                                  controller.clear();
                                  onChanged('');
                                  focusNode.requestFocus();
                                },
                                icon: const Icon(Icons.close_rounded),
                              ),
                        fillColor: palette.surfaceContainer,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: palette.primary,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchPrompt extends StatelessWidget {
  const _SearchPrompt({
    required this.recipeCount,
    required this.categoryCount,
    required this.tagCount,
    super.key,
  });

  final int recipeCount;
  final int categoryCount;
  final int tagCount;

  bool get _catalogIsEmpty =>
      recipeCount == 0 && categoryCount == 0 && tagCount == 0;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return SingleChildScrollView(
      key: const Key('recipe-search-prompt'),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.fromLTRB(
        MediaQuery.sizeOf(context).width >= 600 ? 28 : 20,
        52,
        MediaQuery.sizeOf(context).width >= 600 ? 28 : 20,
        32 + MediaQuery.paddingOf(context).bottom,
      ),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                header: true,
                child: Text(
                  _catalogIsEmpty
                      ? S.of(context).nothing_to_search_through
                      : S.of(context).cookbook_search_prompt_title,
                  style: CulinaryEditorialType.headline(
                    palette,
                    size: 30,
                    weight: FontWeight.w600,
                    height: 1.15,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Text(
                  _catalogIsEmpty
                      ? S.of(context).cookbook_search_empty_description
                      : S.of(context).cookbook_search_prompt_description,
                  style: CulinaryEditorialType.body(
                    palette,
                    size: 15,
                    color: palette.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
              ),
              if (!_catalogIsEmpty) ...[
                const SizedBox(height: 28),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _CatalogCount(
                      icon: Icons.menu_book_rounded,
                      count: recipeCount,
                      label: S.of(context).recipes,
                    ),
                    _CatalogCount(
                      icon: Icons.grid_view_rounded,
                      count: categoryCount,
                      label: S.of(context).categories,
                    ),
                    _CatalogCount(
                      icon: Icons.sell_rounded,
                      count: tagCount,
                      label: S.of(context).tags,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _CatalogCount extends StatelessWidget {
  const _CatalogCount({
    required this.icon,
    required this.count,
    required this.label,
  });

  final IconData icon;
  final int count;
  final String label;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Semantics(
      label: '$label: $count',
      excludeSemantics: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: palette.surfaceContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: palette.primary),
              const SizedBox(width: 8),
              Text(
                '$count',
                style: CulinaryEditorialType.body(
                  palette,
                  size: 13,
                  weight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 5),
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
      ),
    );
  }
}

class _GroupedSearchResults extends StatelessWidget {
  const _GroupedSearchResults({
    required this.recipes,
    required this.categories,
    required this.tags,
    required this.onOpenRecipe,
    required this.onOpenCategory,
    required this.onOpenTag,
    super.key,
  });

  final List<String> recipes;
  final List<String> categories;
  final List<StringIntTuple> tags;
  final ValueChanged<String> onOpenRecipe;
  final ValueChanged<String> onOpenCategory;
  final ValueChanged<StringIntTuple> onOpenTag;

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const Key('recipe-search-results'),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.fromLTRB(
        MediaQuery.sizeOf(context).width >= 600 ? 28 : 20,
        24,
        MediaQuery.sizeOf(context).width >= 600 ? 28 : 20,
        32 + MediaQuery.paddingOf(context).bottom,
      ),
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (recipes.isNotEmpty)
                  _ResultSection(
                    title: S.of(context).recipes,
                    count: recipes.length,
                    children: [
                      for (final recipe in recipes)
                        _SearchResultRow(
                          key: ValueKey('recipe-search-recipe-$recipe'),
                          icon: Icons.menu_book_rounded,
                          label: recipe,
                          onTap: () => onOpenRecipe(recipe),
                        ),
                    ],
                  ),
                if (categories.isNotEmpty) ...[
                  if (recipes.isNotEmpty) const SizedBox(height: 28),
                  _ResultSection(
                    title: S.of(context).categories,
                    count: categories.length,
                    children: [
                      for (final category in categories)
                        _SearchResultRow(
                          key: ValueKey('recipe-search-category-$category'),
                          icon: Icons.grid_view_rounded,
                          label: category,
                          onTap: () => onOpenCategory(category),
                        ),
                    ],
                  ),
                ],
                if (tags.isNotEmpty) ...[
                  if (recipes.isNotEmpty || categories.isNotEmpty)
                    const SizedBox(height: 28),
                  _ResultSection(
                    title: S.of(context).tags,
                    count: tags.length,
                    children: [
                      for (final tag in tags)
                        _SearchResultRow(
                          key: ValueKey('recipe-search-tag-${tag.text}'),
                          label: '#${tag.text}',
                          tagColor: Color(tag.number),
                          onTap: () => onOpenTag(tag),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ResultSection extends StatelessWidget {
  const _ResultSection({
    required this.title,
    required this.count,
    required this.children,
  });

  final String title;
  final int count;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          header: true,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: CulinaryEditorialType.headline(
                    palette,
                    size: 20,
                    weight: FontWeight.w600,
                  ),
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: palette.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  child: Text(
                    '$count',
                    style: CulinaryEditorialType.body(
                      palette,
                      size: 12,
                      weight: FontWeight.w700,
                      color: palette.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Material(
          color: palette.surface,
          borderRadius: BorderRadius.circular(14),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              for (var index = 0; index < children.length; index++) ...[
                children[index],
                if (index < children.length - 1)
                  Divider(
                    height: 1,
                    indent: 56,
                    color: palette.outline.withValues(alpha: .2),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SearchResultRow extends StatelessWidget {
  const _SearchResultRow({
    required this.label,
    required this.onTap,
    this.icon,
    this.tagColor,
    super.key,
  }) : assert(icon != null || tagColor != null);

  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final Color? tagColor;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 64),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
          child: Row(
            children: [
              SizedBox.square(
                dimension: 32,
                child: tagColor == null
                    ? Icon(icon, size: 21, color: palette.onSurfaceVariant)
                    : Center(
                        child: ExcludeSemantics(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: tagColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: palette.outline.withValues(alpha: .55),
                              ),
                            ),
                            child: const SizedBox.square(dimension: 24),
                          ),
                        ),
                      ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: CulinaryEditorialType.body(
                    palette,
                    size: 14,
                    weight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 22,
                color: palette.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
            ],
          ),
        ),
      ),
    );
  }
}

class _NoSearchResults extends StatelessWidget {
  const _NoSearchResults({required this.query, super.key});

  final String query;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return SingleChildScrollView(
      key: const Key('recipe-search-no-results'),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.fromLTRB(
        20,
        52,
        20,
        32 + MediaQuery.paddingOf(context).bottom,
      ),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                header: true,
                child: Text(
                  S.of(context).cookbook_search_no_results_title(query),
                  style: CulinaryEditorialType.headline(
                    palette,
                    size: 28,
                    weight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                S.of(context).cookbook_search_no_results_description,
                style: CulinaryEditorialType.body(
                  palette,
                  size: 15,
                  color: palette.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
