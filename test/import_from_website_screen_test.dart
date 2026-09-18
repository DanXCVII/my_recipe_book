import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_recipe_book/blocs/ad_manager/ad_manager_bloc.dart';
import 'package:my_recipe_book/blocs/recipe_calendar/recipe_calendar_bloc.dart';
import 'package:my_recipe_book/blocs/recipe_manager/recipe_manager_bloc.dart';
import 'package:my_recipe_book/blocs/shopping_cart/shopping_cart_bloc.dart';
import 'package:my_recipe_book/blocs/website_import/website_import_bloc.dart';
import 'package:my_recipe_book/constants/routes.dart';
import 'package:my_recipe_book/generated/l10n.dart';
import 'package:my_recipe_book/local_storage/database.dart';
import 'package:my_recipe_book/local_storage/local_repository.dart';
import 'package:my_recipe_book/models/recipe.dart';
import 'package:my_recipe_book/screens/import_from_website.dart';
import 'package:my_recipe_book/widgets/culinary_editorial_theme.dart';

const _urlLauncherChannel = MethodChannel('plugins.flutter.io/url_launcher');

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase database;
  late DriftRepository repository;
  late RecipeManagerBloc recipeManager;
  late _ControlledWebsiteImportBloc websiteImport;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    repository = DriftRepository(database: database);
    await repository.initialize();
    recipeManager = RecipeManagerBloc(repository);
    websiteImport = _ControlledWebsiteImportBloc(recipeManager, repository);
  });

  tearDown(() async {
    await websiteImport.close();
    await recipeManager.close();
    await database.close();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_urlLauncherChannel, null);
  });

  testWidgets('validates locally and submits trimmed URLs from both actions', (
    tester,
  ) async {
    await _pumpImport(tester, websiteImport: websiteImport);

    await tester.tap(find.byKey(const Key('website-import-submit')));
    await tester.pump();
    expect(
      find.text(
        'Enter a complete recipe link beginning with http:// or https://.',
      ),
      findsOneWidget,
    );
    expect(websiteImport.imports, isEmpty);

    await tester.enterText(
      find.byKey(const Key('website-import-url-field')),
      'recipe.example/no-scheme',
    );
    await tester.tap(find.byKey(const Key('website-import-submit')));
    await tester.pump();
    expect(websiteImport.imports, isEmpty);

    await tester.enterText(
      find.byKey(const Key('website-import-url-field')),
      '  https://recipe.example/pasta  ',
    );
    await tester.tap(find.byKey(const Key('website-import-submit')));
    await tester.pump();
    expect(websiteImport.imports.single.url, 'https://recipe.example/pasta');
    final field = tester.widget<TextField>(
      find.byKey(const Key('website-import-url-field')),
    );
    expect(field.controller!.text, 'https://recipe.example/pasta');

    await tester.enterText(
      find.byKey(const Key('website-import-url-field')),
      'https://recipe.example/soup',
    );
    await tester.testTextInput.receiveAction(TextInputAction.go);
    await tester.pump();
    expect(websiteImport.imports.last.url, 'https://recipe.example/soup');
    expect(websiteImport.imports, hasLength(2));
  });

  testWidgets('disables duplicate submission and announces import progress', (
    tester,
  ) async {
    await _pumpImport(
      tester,
      websiteImport: websiteImport,
      initialWebsite: 'https://recipe.example/pasta',
    );
    websiteImport.show(ImportingRecipe());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    final button = tester.widget<FilledButton>(
      find.byKey(const Key('website-import-submit')),
    );
    final field = tester.widget<TextField>(
      find.byKey(const Key('website-import-url-field')),
    );
    expect(button.onPressed, isNull);
    expect(field.enabled, isFalse);
    expect(find.byKey(const Key('website-import-progress')), findsOneWidget);
    expect(
      find.bySemanticsLabel(
        'Reading recipe…. Looking for ingredients, instructions, and recipe details.',
      ),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const Key('website-import-submit')));
    expect(websiteImport.imports, isEmpty);
  });

  testWidgets('renders recoverable failure and duplicate states', (
    tester,
  ) async {
    await _pumpImport(
      tester,
      websiteImport: websiteImport,
      initialWebsite: 'https://recipe.example/pasta',
    );

    websiteImport.show(FailedToConnect());
    await tester.pumpAndSettle();
    expect(find.text('Couldn’t connect'), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);

    websiteImport.show(FailedImportingRecipe('https://recipe.example/pasta'));
    await tester.pumpAndSettle();
    expect(find.text('We couldn’t import this recipe'), findsOneWidget);
    expect(
      find.byKey(const Key('website-import-supported-list')),
      findsOneWidget,
    );

    websiteImport.show(InvalidUrl());
    await tester.pumpAndSettle();
    expect(find.text('This page isn’t supported yet'), findsOneWidget);

    websiteImport.show(AlreadyExists('Pasta al limone'));
    await tester.pumpAndSettle();
    expect(find.text('Already in your cookbook'), findsOneWidget);
    expect(
      find.text('Recipe with name "Pasta al limone" already exists'),
      findsOneWidget,
    );

    websiteImport.show(FailedToConnect());
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('website-import-submit')));
    expect(websiteImport.imports.single.url, 'https://recipe.example/pasta');
  });

  testWidgets('expands supported sites and opens an example externally', (
    tester,
  ) async {
    MethodCall? launchCall;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_urlLauncherChannel, (call) async {
          launchCall = call;
          return true;
        });
    await _pumpImport(tester, websiteImport: websiteImport);

    await tester.tap(find.byKey(const Key('website-import-supported-toggle')));
    await tester.pumpAndSettle();
    expect(find.text('EN · allrecipes.com'), findsOneWidget);

    await tester.tap(find.text('EN · allrecipes.com'));
    await tester.pump();
    expect(launchCall?.method, 'launch');
    expect(launchCall?.arguments.toString(), contains('allrecipes.com'));
  });

  testWidgets('shared URL is prefilled without a second automatic dispatch', (
    tester,
  ) async {
    await _pumpImport(
      tester,
      websiteImport: websiteImport,
      initialWebsite: 'https://recipe.example/shared',
    );

    final field = tester.widget<TextField>(
      find.byKey(const Key('website-import-url-field')),
    );
    expect(field.controller!.text, 'https://recipe.example/shared');
    expect(websiteImport.imports, isEmpty);
  });

  testWidgets('navigates imported recipes into the existing editor route', (
    tester,
  ) async {
    final adManager = _FakeAdManagerBloc();
    final shoppingCart = _FakeShoppingCartBloc();
    final calendar = _FakeRecipeCalendarBloc();
    Object? editorArguments;

    await _pumpImport(
      tester,
      websiteImport: websiteImport,
      adManager: adManager,
      shoppingCart: shoppingCart,
      calendar: calendar,
      onGenerateRoute: (settings) {
        if (settings.name == RouteNames.addRecipeGeneralInfo) {
          editorArguments = settings.arguments;
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => const Scaffold(body: Text('Recipe editor')),
          );
        }
        return null;
      },
    );

    websiteImport.show(ImportedRecipe(Recipe(name: 'Imported pasta')));
    await tester.pumpAndSettle();

    expect(find.text('Recipe editor'), findsOneWidget);
    expect(editorArguments, isNotNull);
    expect(adManager.events.whereType<LoadVideo>(), hasLength(1));
  });

  testWidgets('adapts German copy and enlarged text on a tablet', (
    tester,
  ) async {
    await _pumpImport(
      tester,
      websiteImport: websiteImport,
      locale: const Locale('de', 'DE'),
      size: const Size(1024, 900),
      textScale: 1.3,
    );

    expect(find.text('Ein Rezept aus dem Web holen'), findsOneWidget);
    expect(find.text('Rezept importieren'), findsOneWidget);
    expect(find.text('Welche Seiten funktionieren?'), findsOneWidget);
    expect(tester.takeException(), isNull);

    final cardWidth = tester
        .getSize(find.byKey(const Key('website-import-card')))
        .width;
    expect(cardWidth, lessThanOrEqualTo(704));
  });

  testWidgets('keeps tonal separation and minimum target sizes', (
    tester,
  ) async {
    final variants = <(ThemeData, CulinaryEditorialPalette)>[
      (ThemeData.light(), CulinaryEditorialPalette.light),
      (ThemeData.dark(), CulinaryEditorialPalette.dark),
      (
        ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),
        CulinaryEditorialPalette.oled,
      ),
    ];

    for (final (theme, palette) in variants) {
      await _pumpImport(tester, websiteImport: websiteImport, theme: theme);

      final scaffold = tester.widget<Scaffold>(
        find.byKey(const Key('website-import-screen')),
      );
      final card = tester.widget<DecoratedBox>(
        find.byKey(const Key('website-import-card')),
      );
      final decoration = card.decoration as BoxDecoration;
      expect(scaffold.backgroundColor, palette.background);
      expect(decoration.color, palette.surface);
      expect(decoration.color, isNot(scaffold.backgroundColor));
      expect(
        tester.getSize(find.byKey(const Key('website-import-submit'))).height,
        greaterThanOrEqualTo(52),
      );
      expect(
        tester
            .getSize(find.byKey(const Key('website-import-supported-toggle')))
            .height,
        greaterThanOrEqualTo(48),
      );
      expect(tester.takeException(), isNull);
    }
  });
}

Future<void> _pumpImport(
  WidgetTester tester, {
  required _ControlledWebsiteImportBloc websiteImport,
  String initialWebsite = '',
  Locale locale = const Locale('en'),
  Size size = const Size(430, 900),
  double textScale = 1,
  ThemeData? theme,
  AdManagerBloc? adManager,
  ShoppingCartBloc? shoppingCart,
  RecipeCalendarBloc? calendar,
  RouteFactory? onGenerateRoute,
}) async {
  await tester.binding.setSurfaceSize(size);
  addTearDown(() => tester.binding.setSurfaceSize(null));

  Widget child = ImportFromWebsiteScreen(initialWebsite: initialWebsite);
  if (adManager != null && shoppingCart != null && calendar != null) {
    child = MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AdManagerBloc>.value(value: adManager),
        RepositoryProvider<ShoppingCartBloc>.value(value: shoppingCart),
        RepositoryProvider<RecipeCalendarBloc>.value(value: calendar),
      ],
      child: child,
    );
  }

  await tester.pumpWidget(
    BlocProvider<WebsiteImportBloc>.value(
      value: websiteImport,
      child: MaterialApp(
        locale: locale,
        theme: theme ?? ThemeData.light(),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        onGenerateRoute: onGenerateRoute,
        builder: (context, child) {
          final media = MediaQuery.of(context);
          return MediaQuery(
            data: media.copyWith(textScaler: TextScaler.linear(textScale)),
            child: child!,
          );
        },
        home: child,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

class _ControlledWebsiteImportBloc extends WebsiteImportBloc {
  _ControlledWebsiteImportBloc(super.recipeManagerBloc, super.repository);

  final imports = <ImportRecipe>[];

  @override
  void add(WebsiteImportEvent? event) {
    if (event is ImportRecipe) imports.add(event);
  }

  void show(WebsiteImportState next) => emit(next);
}

class _FakeAdManagerBloc implements AdManagerBloc {
  final events = <AdManagerEvent>[];

  @override
  void add(AdManagerEvent event) => events.add(event);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeShoppingCartBloc implements ShoppingCartBloc {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeRecipeCalendarBloc implements RecipeCalendarBloc {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
