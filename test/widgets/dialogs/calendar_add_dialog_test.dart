import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_recipe_book/generated/l10n.dart';
import 'package:my_recipe_book/local_storage/database.dart';
import 'package:my_recipe_book/local_storage/local_repository.dart';
import 'package:my_recipe_book/models/recipe.dart';
import 'package:my_recipe_book/widgets/dialogs/calendar_add_dialog.dart';

void main() {
  testWidgets('fixed recipe flow keeps time optional and clearable', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(430, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final database = AppDatabase(NativeDatabase.memory());
    final repository = DriftRepository(database: database);
    await repository.initialize();
    await repository.saveRecipe(Recipe(name: 'Brown Butter Gnocchi'));
    addTearDown(database.close);
    CalendarScheduleSelection? selection;

    await tester.pumpWidget(
      RepositoryProvider<LocalRepository>.value(
        value: repository,
        child: MaterialApp(
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: FilledButton(
                  onPressed: () async {
                    selection = await showCalendarSchedule(
                      context,
                      fixedRecipeName: 'Brown Butter Gnocchi',
                    );
                  },
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const Key('calendar-schedule-fixed-recipe')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('calendar-schedule-recipe')), findsNothing);
    expect(find.text('No time'), findsOneWidget);

    await tester.tap(find.byKey(const Key('calendar-schedule-time')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const Key('calendar-schedule-clear-time')),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const Key('calendar-schedule-clear-time')));
    await tester.pump();
    expect(find.text('No time'), findsOneWidget);

    await tester.tap(find.byKey(const Key('calendar-schedule-submit')));
    await tester.pumpAndSettle();
    expect(selection?.recipeName, 'Brown Butter Gnocchi');
    expect(selection?.scheduledAt.hour, 0);
    expect(selection?.scheduledAt.minute, 0);
    expect(tester.takeException(), isNull);
  });

  testWidgets('empty recipe collection explains why add is unavailable', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(430, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final database = AppDatabase(NativeDatabase.memory());
    final repository = DriftRepository(database: database);
    await repository.initialize();
    addTearDown(database.close);

    await tester.pumpWidget(
      RepositoryProvider<LocalRepository>.value(
        value: repository,
        child: MaterialApp(
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: FilledButton(
                  onPressed: () => showCalendarSchedule(context),
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('calendar-schedule-empty-recipes')),
      findsOneWidget,
    );
    expect(
      find.text('Save a recipe before adding it to your meal plan.'),
      findsOneWidget,
    );
    expect(
      tester
          .widget<FilledButton>(
            find.byKey(const Key('calendar-schedule-submit')),
          )
          .onPressed,
      isNull,
    );
    expect(tester.takeException(), isNull);
  });
}
