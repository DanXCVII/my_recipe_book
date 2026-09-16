import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_recipe_book/blocs/recipe_category_overview/recipe_category_overview_bloc.dart';
import 'package:my_recipe_book/blocs/recipe_manager/recipe_manager_bloc.dart';
import 'package:my_recipe_book/generated/l10n.dart';
import 'package:my_recipe_book/local_storage/database.dart';
import 'package:my_recipe_book/local_storage/local_repository.dart';
import 'package:my_recipe_book/models/recipe.dart';
import 'package:my_recipe_book/screens/r_category_overview.dart';
import 'package:my_recipe_book/theming.dart';

void main() {
  testWidgets('pull to refresh shares the feed vertical viewport', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final database = AppDatabase(NativeDatabase.memory());
    final repository = DriftRepository(database: database);
    await repository.initialize();

    for (var index = 0; index < 6; index++) {
      final category = 'Category $index';
      await repository.addCategory(category);
      await repository.saveRecipe(
        Recipe(name: 'Recipe $index', categories: [category]),
      );
    }

    final manager = RecipeManagerBloc(repository);
    final overview = RecipeCategoryOverviewBloc(
      recipeManagerBloc: manager,
      repository: repository,
    );
    addTearDown(() async {
      await overview.close();
      await manager.close();
      await database.close();
    });

    final loaded = overview.stream.firstWhere(
      (state) => state is LoadedRecipeCategoryOverview,
    );
    overview.add(RCOLoadRecipeCategoryOverview());
    await loaded;

    await tester.pumpWidget(
      CustomTheme(
        child: Builder(
          builder: (context) => MaterialApp(
            theme: CustomTheme.of(context),
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            home: MultiBlocProvider(
              providers: [
                BlocProvider<RecipeManagerBloc>.value(value: manager),
                BlocProvider<RecipeCategoryOverviewBloc>.value(value: overview),
              ],
              child: const Scaffold(body: RecipeCategoryOverview()),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('category-overview-refresh')), findsOneWidget);

    final verticalScrollable = find.byWidgetPredicate(
      (widget) =>
          widget is Scrollable &&
          (widget.axisDirection == AxisDirection.down ||
              widget.axisDirection == AxisDirection.up),
    );
    expect(verticalScrollable, findsOneWidget);

    final scrollableState = tester.state<ScrollableState>(verticalScrollable);
    var previousOffset = scrollableState.position.pixels;
    for (var gesture = 0; gesture < 5; gesture++) {
      await tester.fling(verticalScrollable, const Offset(0, -500), 1200);
      await tester.pumpAndSettle();
      final offset = scrollableState.position.pixels;
      expect(offset, greaterThanOrEqualTo(previousOffset));
      previousOffset = offset;
    }
    expect(previousOffset, greaterThan(0));
  });
}
