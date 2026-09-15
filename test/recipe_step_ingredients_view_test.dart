import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_recipe_book/blocs/animated_stepper/animated_stepper_bloc.dart';
import 'package:my_recipe_book/blocs/recipe_manager/recipe_manager_bloc.dart';
import 'package:my_recipe_book/blocs/recipe_screen_ingredients/recipe_screen_ingredients_bloc.dart';
import 'package:my_recipe_book/blocs/shopping_cart/shopping_cart_bloc.dart';
import 'package:my_recipe_book/local_storage/database.dart';
import 'package:my_recipe_book/local_storage/local_repository.dart';
import 'package:my_recipe_book/models/ingredient.dart';
import 'package:my_recipe_book/widgets/animated_stepper.dart';

void main() {
  testWidgets('assigned step ingredients follow serving scaling', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = DriftRepository(database: database);
    await repository.initialize();
    final manager = RecipeManagerBloc(repository);
    final cart = ShoppingCartBloc(manager, repository);
    final ingredientBloc = RecipeScreenIngredientsBloc(
      shoppingCartBloc: cart,
      repository: repository,
    );
    final stepperBloc = AnimatedStepperBloc(initialStep: 0);
    addTearDown(manager.close);
    addTearDown(cart.close);
    addTearDown(ingredientBloc.close);
    addTearDown(stepperBloc.close);

    const ingredients = [
      [Ingredient(id: 'flour', name: 'Flour', amount: 2, unit: 'cups')],
    ];
    final loaded = ingredientBloc.stream
        .where((state) => state is LoadedRecipeIngredients)
        .first;
    ingredientBloc.add(const InitializeIngredients('Bread', 2, ingredients));
    await loaded;

    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: ingredientBloc),
            BlocProvider.value(value: stepperBloc),
          ],
          child: Scaffold(
            body: AnimatedStepper(
              const ['Mix thoroughly'],
              const [''],
              ingredients: ingredients,
              stepIngredientIds: const [
                ['flour'],
              ],
              stepImages: const [[]],
              lowResStepImages: const [[]],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('2 cups Flour'), findsOneWidget);

    ingredientBloc.add(const UpdateServings(2, 4));
    await tester.pumpAndSettle();
    expect(find.text('4 cups Flour'), findsOneWidget);
  });
}
