import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_recipe_book/blocs/recipe_screen/recipe_screen_bloc.dart';

import './theming.dart';
import 'blocs/app/app.dart';
import 'blocs/app/app_event.dart';
import 'blocs/category_manager/category_manager_bloc.dart';
import 'blocs/category_overview/category_overview_bloc.dart';
import 'blocs/favorite_recipes/favorite_recipes_bloc.dart';
import 'blocs/import_recipe/import_recipe_bloc.dart';
import 'blocs/new_recipe/clear_recipe/clear_recipe_bloc.dart';
import 'blocs/new_recipe/general_info/general_info_bloc.dart';
import 'blocs/new_recipe/ingredients/ingredients_bloc.dart';
import 'blocs/new_recipe/nutritions/nutritions_bloc.dart';
import 'blocs/new_recipe/step_images/step_images_bloc.dart';
import 'blocs/new_recipe/step_images/step_images_event.dart';
import 'blocs/new_recipe/steps/steps_bloc.dart';
import 'blocs/nutrition_manager/nutrition_manager_bloc.dart';
import 'blocs/random_recipe_explorer/random_recipe_explorer_bloc.dart';
import 'blocs/random_recipe_explorer/random_recipe_explorer_event.dart';
import 'blocs/recipe_category_overview/recipe_category_overview_bloc.dart';
import 'blocs/recipe_category_overview/recipe_category_overview_event.dart';
import 'blocs/recipe_manager/recipe_manager_bloc.dart' show RecipeManagerBloc;
import 'blocs/recipe_overview/recipe_overview_bloc.dart';
import 'blocs/recipe_screen_ingredients/recipe_screen_ingredients.dart';
import 'blocs/shopping_cart/shopping_cart.dart';
import 'blocs/splash_screen/splash_screen.dart';
import 'blocs/splash_screen/splash_screen_event.dart';
import 'blocs/splash_screen/splash_screen_state.dart';
import 'generated/i18n.dart';
import 'screens/SplashScreen.dart';
import 'screens/add_recipe/general_info_screen/general_info_screen.dart';
import 'screens/add_recipe/ingredients_screen.dart';
import 'screens/add_recipe/nutritions.dart';
import 'screens/add_recipe/steps_screen/steps_screen.dart';
import 'screens/category_manager.dart';
import 'screens/homepage_screen.dart';
import 'screens/nutrition_manager.dart';
import 'screens/recipe_overview.dart';
import 'screens/recipe_screen.dart';

void main() {
  debugPaintSizeEnabled = false;
  runApp(
    CustomTheme(
      initialThemeKey: MyThemeKeys.LIGHT,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final appTitle = 'Drawer Demo';
  static bool initialized = false;

  MyApp();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return BlocProvider<RecipeManagerBloc>(
      create: (context) => RecipeManagerBloc(),
      child: MaterialApp(
        localizationsDelegates: [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        showPerformanceOverlay: false,
        theme: CustomTheme.of(context),
        initialRoute: "/",
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case "/":
              return MaterialPageRoute(
                builder: (context) => BlocProvider<SplashScreenBloc>(
                  create: (context) =>
                      SplashScreenBloc()..add(SPInitializeData(context)),
                  child: BlocBuilder<SplashScreenBloc, SplashScreenState>(
                      builder: (context, state) {
                    if (state is InitializingData) {
                      return SplashScreen();
                    } else if (state is InitializedData) {
                      return BlocProvider<AppBloc>(
                        create: (context) => AppBloc()
                          ..add(InitializeData(context,
                              state.recipeCategoryOverview, state.showIntro)),
                        child: MultiBlocProvider(providers: [
                          BlocProvider<CategoryOverviewBloc>(
                            create: (context) => CategoryOverviewBloc(
                              recipeManagerBloc:
                                  BlocProvider.of<RecipeManagerBloc>(context),
                            )..add(COLoadCategoryOverview()),
                          ),
                          BlocProvider<RecipeCategoryOverviewBloc>(
                            create: (context) => RecipeCategoryOverviewBloc(
                              recipeManagerBloc:
                                  BlocProvider.of<RecipeManagerBloc>(context),
                            )..add(RCOLoadRecipeCategoryOverview()),
                          ),
                          BlocProvider<FavoriteRecipesBloc>(
                              create: (context) => FavoriteRecipesBloc(
                                    recipeManagerBloc:
                                        BlocProvider.of<RecipeManagerBloc>(
                                            context),
                                  )..add(LoadFavorites())),
                          BlocProvider<RandomRecipeExplorerBloc>(
                            create: (context) => RandomRecipeExplorerBloc(
                              recipeManagerBloc:
                                  BlocProvider.of<RecipeManagerBloc>(context),
                            )..add(InitializeRandomRecipeExplorer()),
                          ),
                          BlocProvider<ImportRecipeBloc>(
                              create: (context) => ImportRecipeBloc(
                                  BlocProvider.of<RecipeManagerBloc>(context))),
                          BlocProvider<ShoppingCartBloc>(
                            create: (context) =>
                                ShoppingCartBloc()..add(LoadShoppingCart()),
                          ),
                        ], child: MyHomePage()),
                      );
                    } else {
                      return Text(state.toString());
                    }
                  }),
                ),
              );

            case "/recipe-screen":
              final RecipeScreenArguments args = settings.arguments;

              return MaterialPageRoute(
                builder: (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider<RecipeScreenBloc>(
                        create: (context) => RecipeScreenBloc(
                              args.recipe,
                              args.recipeManagerBloc,
                            )..add(InitRecipeScreen(
                                args.recipe,
                              ))),
                    BlocProvider<RecipeScreenIngredientsBloc>(
                        create: (context) => RecipeScreenIngredientsBloc(
                            shoppingCartBloc: args.shoppingCartBloc)
                          ..add(InitializeIngredients(
                            args.recipe.name,
                            args.recipe.servings,
                            args.recipe.ingredients,
                          ))),
                  ],
                  child: RecipeScreen(
                    primaryColor: args.primaryColor,
                    heroImageTag: args.heroImageTag,
                  ),
                ),
              );
            case "/add-recipe/general-info":
              final GeneralInfoArguments args = settings.arguments;

              return MaterialPageRoute(
                builder: (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider<ClearRecipeBloc>(
                      create: (context) => ClearRecipeBloc(),
                    ),
                    BlocProvider<GeneralInfoBloc>(
                      create: (context) => GeneralInfoBloc(),
                    ),
                    BlocProvider<CategoryManagerBloc>(
                      create: (context) => CategoryManagerBloc(
                          recipeManagerBloc:
                              BlocProvider.of<RecipeManagerBloc>(context))
                        ..add(InitializeCategoryManager()),
                    ),
                  ],
                  child: GeneralInfoScreen(
                    modifiedRecipe: args.modifiedRecipe,
                    editingRecipeName: args.editingRecipeName,
                  ),
                ),
              );

            case "/add-recipe/ingredients":
              final IngredientsArguments args = settings.arguments;

              return MaterialPageRoute(
                builder: (context) => BlocProvider<IngredientsBloc>(
                  create: (context) => IngredientsBloc(),
                  child: IngredientsAddScreen(
                    modifiedRecipe: args.modifiedRecipe,
                    editingRecipeName: args.editingRecipeName,
                  ),
                ),
              );

            case "/add-recipe/steps":
              final StepsArguments args = settings.arguments;

              return MaterialPageRoute(
                builder: (context) => BlocProvider<StepImagesBloc>(
                  create: (context) => StepImagesBloc()
                    ..add(InitializeStepImages(
                        stepImages: args.modifiedRecipe.stepImages)),
                  child: BlocProvider<StepsBloc>(
                    create: (context) =>
                        StepsBloc(BlocProvider.of<StepImagesBloc>(context)),
                    child: StepsScreen(
                      modifiedRecipe: args.modifiedRecipe,
                      editingRecipeName: args.editingRecipeName,
                    ),
                  ),
                ),
              );

            case "/recipe-categories":
              final RecipeGridViewArguments args = settings.arguments;

              return CupertinoPageRoute(
                  builder: (BuildContext context) => MultiBlocProvider(
                        providers: [
                          BlocProvider<ShoppingCartBloc>.value(
                              value: args.shoppingCartBloc),
                          BlocProvider<RecipeOverviewBloc>(
                            create: (context) => RecipeOverviewBloc(
                                recipeManagerBloc:
                                    BlocProvider.of<RecipeManagerBloc>(context))
                              ..add(
                                LoadCategoryRecipeOverview(args.category),
                              ),
                          ),
                        ],
                        child: RecipeGridView(),
                      ));

            case "/vegetable-recipes-oveview":
              final RecipeGridViewArguments args = settings.arguments;

              return CupertinoPageRoute(
                builder: (BuildContext context) => MultiBlocProvider(
                  providers: [
                    BlocProvider<ShoppingCartBloc>.value(
                        value: args.shoppingCartBloc),
                    BlocProvider<RecipeOverviewBloc>(
                      create: (context) => RecipeOverviewBloc(
                          recipeManagerBloc:
                              BlocProvider.of<RecipeManagerBloc>(context))
                        ..add(
                          LoadVegetableRecipeOverview(args.vegetable),
                        ),
                    ),
                  ],
                  child: RecipeGridView(),
                ),
              );

            case "/add-recipe/nutritions":
              final AddRecipeNutritionsArguments args = settings.arguments;

              return MaterialPageRoute(
                builder: (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider<NutritionManagerBloc>(
                        create: (context) => NutritionManagerBloc()
                          ..add(LoadNutritionManager())),
                    BlocProvider<NutritionsBloc>(
                      create: (context) => NutritionsBloc(),
                    )
                  ],
                  child: AddRecipeNutritions(
                    modifiedRecipe: args.modifiedRecipe,
                    editingRecipeName: args.editingRecipeName,
                  ),
                ),
              );

            case "/manage-categories":
              return MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => CategoryManagerBloc(
                    recipeManagerBloc:
                        BlocProvider.of<RecipeManagerBloc>(context),
                  )..add(InitializeCategoryManager()),
                  child: CategoryManager(),
                ),
              );

            case "/manage-nutritions":
              return MaterialPageRoute(
                builder: (context) => BlocProvider<NutritionManagerBloc>(
                  create: (context) =>
                      NutritionManagerBloc()..add(LoadNutritionManager()),
                  child: NutritionManager(),
                ),
              );

            default:
              return MaterialPageRoute(
                  builder: (context) => Text("failllll kek"));
          }
        },
      ),
    );
  }
}
