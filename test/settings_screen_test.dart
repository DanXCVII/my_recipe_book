import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_recipe_book/blocs/ad_manager/ad_manager_bloc.dart';
import 'package:my_recipe_book/blocs/g_drive/g_drive_sign_in/g_drive_sign_in_bloc.dart';
import 'package:my_recipe_book/blocs/g_drive/g_drive_sync/g_drive_bloc.dart';
import 'package:my_recipe_book/blocs/import_recipe/import_recipe_bloc.dart';
import 'package:my_recipe_book/blocs/recipe_calendar/recipe_calendar_bloc.dart';
import 'package:my_recipe_book/blocs/recipe_manager/recipe_manager_bloc.dart';
import 'package:my_recipe_book/blocs/shopping_cart/shopping_cart_bloc.dart';
import 'package:my_recipe_book/constants/global_settings.dart';
import 'package:my_recipe_book/generated/l10n.dart';
import 'package:my_recipe_book/local_storage/database.dart';
import 'package:my_recipe_book/local_storage/local_repository.dart';
import 'package:my_recipe_book/screens/settings_screen.dart';
import 'package:my_recipe_book/theming.dart';
import 'package:shared_preferences/shared_preferences.dart';

late AppDatabase database;
late DriftRepository repository;
late RecipeManagerBloc recipeManager;
late ImportRecipeBloc importRecipe;
late ShoppingCartBloc shoppingCart;
late RecipeCalendarBloc calendar;

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({
      'theme': 1,
      'showDecimal': false,
      'enableAnimations': true,
      'disableStandby': true,
    });
    database = AppDatabase(NativeDatabase.memory());
    repository = DriftRepository(database: database);
    await repository.initialize();
    await repository.addNutrition('Protein');
    await repository.addIngredient('Tomato');
    await repository.addRecipeTag('Weeknight', Colors.orange.toARGB32());
    await repository.addCategory('Dinner');
    recipeManager = RecipeManagerBloc(repository);
    importRecipe = ImportRecipeBloc(recipeManager, repository);
    shoppingCart = ShoppingCartBloc(recipeManager, repository);
    calendar = RecipeCalendarBloc(recipeManager, repository);
  });

  tearDown(() async {
    await importRecipe.close();
    await shoppingCart.close();
    await calendar.close();
    await recipeManager.close();
    await database.close();
  });

  testWidgets('renders truthful editorial settings on a phone', (tester) async {
    await _pumpSettings(tester, size: const Size(430, 900));

    expect(find.text('Settings & Preferences'), findsOneWidget);
    expect(find.text('Kitchen configuration'), findsNothing);
    expect(find.image(const AssetImage('images/icon.png')), findsOneWidget);
    expect(
      find.text('Sign in to sync recipes manually across devices.'),
      findsOneWidget,
    );
    expect(
      find.text('Select recipes and share them as a ZIP archive.'),
      findsOneWidget,
    );
    expect(
      find.text(
        'Manage names suggested while editing and searching. Existing recipes are not changed.',
      ),
      findsOneWidget,
    );
    expect(find.text('Auto-Cloud Sync'), findsNothing);
    expect(find.text('Unlimited OCR Scans'), findsNothing);
    expect(find.text('Measurement Standards'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('adapts to a tablet and enlarged German text', (tester) async {
    await _pumpSettings(
      tester,
      size: const Size(1024, 900),
      locale: const Locale('de', 'DE'),
      textScale: 1.3,
    );

    expect(find.text('Einstellungen & Präferenzen'), findsOneWidget);
    expect(find.text('DATEN & SYNCHRONISIERUNG'), findsOneWidget);
    expect(find.text('DARSTELLUNG & ANZEIGE'), findsOneWidget);
    expect(find.text('Automatische Cloud-Synchronisierung'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('loads and persists the existing appearance preferences', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'theme': 3,
      'showDecimal': true,
      'enableAnimations': false,
      'disableStandby': false,
    });

    await _pumpSettings(tester, size: const Size(430, 900));

    expect(tester.widgetList<Switch>(find.byType(Switch)).map((w) => w.value), [
      false,
      false,
    ]);

    await tester.ensureVisible(find.text('Auto'));
    await tester.tap(find.text('Auto'));
    await tester.tap(find.textContaining('Fractions'));
    await tester.tap(find.text('Keep screen awake'));
    await tester.tap(find.text('Complex animations'));
    await tester.pumpAndSettle();

    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getInt('theme'), 0);
    expect(preferences.getBool('showDecimal'), isFalse);
    expect(preferences.getBool('disableStandby'), isTrue);
    expect(preferences.getBool('enableAnimations'), isTrue);
    expect(GlobalSettings().showDecimal(), isFalse);
    expect(GlobalSettings().standbyDisabled(), isTrue);
    expect(GlobalSettings().animationsEnabled(), isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('renders purchased, signed-in, and Drive progress states', (
    tester,
  ) async {
    await _pumpSettings(
      tester,
      size: const Size(430, 900),
      adState: IsPurchased(),
      signInState: GDriveSignedIn('Ada Lovelace', 'ada@example.com', null),
      syncState: GDriveUploading('Tomato soup', 1, 4),
    );

    expect(find.text('Ada Lovelace'), findsOneWidget);
    expect(find.text('ada@example.com'), findsOneWidget);
    expect(find.text('Pro active'), findsOneWidget);
    expect(find.text('Ads are disabled on this device.'), findsOneWidget);
    expect(find.text('My RecipeBible Pro'), findsNothing);
    expect(find.textContaining('Tomato soup'), findsOneWidget);
    expect(
      tester
          .widgetList<LinearProgressIndicator>(
            find.byType(LinearProgressIndicator),
          )
          .any((indicator) => indicator.value == .25),
      isTrue,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('renders every manual Drive synchronization status', (
    tester,
  ) async {
    final cases = <(GDriveSyncState, String)>[
      (GDriveSyncing(), 'Comparing local and Google Drive recipes…'),
      (GDriveImporting('Imported pie', 1, 2), 'Imported recipe: Imported pie'),
      (GDriveUploading('Uploaded pie', 1, 2), 'Uploaded recipe: Uploaded pie'),
      (
        GDriveCloudDeleting('Cloud pie', 1, 2),
        'Deleted recipe in cloud: Cloud pie',
      ),
      (
        GDriveLocalDeleting('Local pie', 1, 2),
        'Deleted local recipe: Local pie',
      ),
      (GDriveCancellingSync(), 'Cancelling Sync...'),
      (
        GDriveSuccessfullySynced(),
        'Successfully synced recipes with Google Drive',
      ),
      (
        GDriveErrorSyncing(),
        'Error occured during syncing, maybe due to bad internet',
      ),
    ];

    for (final (state, expectedCopy) in cases) {
      await _pumpSettings(
        tester,
        size: const Size(430, 900),
        signInState: GDriveSignedIn('Ada', 'ada@example.com', null),
        syncState: state,
      );
      expect(find.text(expectedCopy), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('renders loading, temporary, offline, and failed ad states', (
    tester,
  ) async {
    await _pumpSettings(
      tester,
      size: const Size(430, 900),
      adState: LoadingVideo(),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await _pumpSettings(
      tester,
      size: const Size(430, 900),
      adState: AdFreeUntil(DateTime(2030, 1, 1, 12)),
    );
    expect(find.textContaining('Ad free until'), findsOneWidget);

    await _pumpSettings(
      tester,
      size: const Size(430, 900),
      adState: NotConnected(),
    );
    expect(find.byIcon(Icons.wifi_off_rounded), findsOneWidget);

    await _pumpSettings(
      tester,
      size: const Size(430, 900),
      adState: FailedLoadingRewardedVideo(),
    );
    expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('dispatches sign-in and manual sync actions', (tester) async {
    final signedOut = await _pumpSettings(tester, size: const Size(430, 900));

    await tester.tap(find.text('Sign in'));
    await tester.pump();
    expect(signedOut.driveSignInBloc.events.single, isA<GDriveSignIn>());

    final signedIn = await _pumpSettings(
      tester,
      size: const Size(430, 900),
      signInState: GDriveSignedIn('Ada', 'ada@example.com', null),
    );
    final syncButton = find.text('Sync recipes with Google Drive');
    await tester.ensureVisible(syncButton);
    await tester.tap(syncButton);
    await tester.pump();
    expect(signedIn.driveSyncBloc.events.single, isA<GDriveStartSync>());
    expect(tester.takeException(), isNull);
  });
}

Future<_SettingsHarness> _pumpSettings(
  WidgetTester tester, {
  required Size size,
  Locale locale = const Locale('en'),
  double textScale = 1,
  AdManagerState? adState,
  GDriveSignInState? signInState,
  GDriveSyncState? syncState,
}) async {
  final adManagerBloc = _TestAdManagerBloc(adState ?? AdManagerInitial());
  final driveSignInBloc = _TestDriveSignInBloc(
    signInState ?? GDriveSignedOut(),
  );
  final driveSyncBloc = _TestDriveSyncBloc(syncState ?? GDriveIdle());
  addTearDown(() async {
    await adManagerBloc.close();
    await driveSignInBloc.close();
    await driveSyncBloc.close();
  });

  await tester.binding.setSurfaceSize(size);
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await tester.pumpWidget(
    CustomTheme(
      initialThemeKey: MyThemeKeys.LIGHT,
      child: Builder(
        builder: (context) => MultiRepositoryProvider(
          providers: [
            RepositoryProvider<LocalRepository>.value(value: repository),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: recipeManager),
              BlocProvider.value(value: importRecipe),
              BlocProvider.value(value: shoppingCart),
              BlocProvider.value(value: calendar),
            ],
            child: MaterialApp(
              locale: locale,
              debugShowCheckedModeBanner: false,
              theme: CustomTheme.of(context),
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: S.delegate.supportedLocales,
              builder: (context, child) {
                final media = MediaQuery.of(context);
                return MediaQuery(
                  data: media.copyWith(
                    textScaler: TextScaler.linear(textScale),
                  ),
                  child: child!,
                );
              },
              home: Scaffold(
                body: Settings(
                  adManagerBloc: adManagerBloc,
                  driveSignInBloc: driveSignInBloc,
                  driveSyncBloc: driveSyncBloc,
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 250));
  return _SettingsHarness(adManagerBloc, driveSignInBloc, driveSyncBloc);
}

class _TestAdManagerBloc extends Bloc<AdManagerEvent, AdManagerState> {
  _TestAdManagerBloc(super.initialState) {
    on<AdManagerEvent>((event, emit) => events.add(event));
  }

  final events = <AdManagerEvent>[];
}

class _TestDriveSignInBloc extends Bloc<GDriveSignInEvent, GDriveSignInState> {
  _TestDriveSignInBloc(super.initialState) {
    on<GDriveSignInEvent>((event, emit) => events.add(event));
  }

  final events = <GDriveSignInEvent>[];
}

class _TestDriveSyncBloc extends Bloc<GDriveSyncEvent, GDriveSyncState> {
  _TestDriveSyncBloc(super.initialState) {
    on<GDriveSyncEvent>((event, emit) => events.add(event));
  }

  final events = <GDriveSyncEvent>[];
}

class _SettingsHarness {
  const _SettingsHarness(
    this.adManagerBloc,
    this.driveSignInBloc,
    this.driveSyncBloc,
  );

  final _TestAdManagerBloc adManagerBloc;
  final _TestDriveSignInBloc driveSignInBloc;
  final _TestDriveSyncBloc driveSyncBloc;
}
