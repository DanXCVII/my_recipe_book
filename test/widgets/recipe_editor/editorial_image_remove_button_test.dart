import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_recipe_book/blocs/new_recipe/clear_recipe/clear_recipe_bloc.dart';
import 'package:my_recipe_book/generated/l10n.dart';
import 'package:my_recipe_book/local_storage/database.dart';
import 'package:my_recipe_book/local_storage/local_repository.dart';
import 'package:my_recipe_book/screens/add_recipe/steps_screen/steps_section.dart';
import 'package:my_recipe_book/widgets/image_selector.dart';
import 'package:my_recipe_book/widgets/recipe_editor/editorial_image_remove_button.dart';

void main() {
  testWidgets('step image uses a compact badge with an accessible tap target', (
    tester,
  ) async {
    var removed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ImageBox(
            imagePath: 'missing-step-image.jpg',
            onPress: () => removed = true,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    _expectCompactRemoveButton(tester);
    await tester.tap(find.byType(EditorialImageRemoveButton));
    expect(removed, isTrue);
  });

  testWidgets('cover image uses the same compact accessible remove action', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = DriftRepository(database: database);
    await repository.initialize();
    final clearRecipeBloc = ClearRecipeBloc(repository);
    addTearDown(clearRecipeBloc.close);
    var removed = false;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: BlocProvider.value(
          value: clearRecipeBloc,
          child: Scaffold(
            body: ImageSelector(
              prefilledImage: 'missing-cover-image.jpg',
              onNewImage: (_) {},
              circleSize: 132,
              color: Colors.red,
              onCancel: () => removed = true,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    _expectCompactRemoveButton(tester);
    await tester.tap(find.byType(EditorialImageRemoveButton));
    await tester.pump();
    expect(removed, isTrue);
    expect(find.byType(EditorialImageRemoveButton), findsNothing);
  });
}

void _expectCompactRemoveButton(WidgetTester tester) {
  final removeButton = find.byType(EditorialImageRemoveButton);
  expect(removeButton, findsOneWidget);
  final iconButton = find.descendant(
    of: removeButton,
    matching: find.byType(IconButton),
  );
  expect(tester.getSize(iconButton), const Size.square(48));

  final widget = tester.widget<IconButton>(iconButton);
  expect(widget.tooltip, isNotEmpty);
  expect(widget.icon, isA<SizedBox>());
  final badge = widget.icon as SizedBox;
  expect(badge.width, EditorialImageRemoveButton.badgeSize);
  expect(badge.height, EditorialImageRemoveButton.badgeSize);
}
