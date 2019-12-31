import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_recipe_book/blocs/new_recipe/ingredients/ingredients.dart';
import 'package:my_recipe_book/blocs/new_recipe/step_images/step_images_bloc.dart';
import 'package:my_recipe_book/blocs/nutrition_manager/nutrition_manager.dart';
import 'package:my_recipe_book/recipe_overview/add_recipe_screen/ingredients_info/ingredients_screen.dart';
import 'package:my_recipe_book/recipe_overview/add_recipe_screen/steps_info/steps_screen.dart';
import 'package:my_recipe_book/screens/category_manager.dart';
import 'package:my_recipe_book/screens/nutrition_manager.dart';

import './theming.dart';
import 'blocs/app/app_bloc.dart';
import 'blocs/app/app_event.dart';
import 'blocs/category_manager/category_manager.dart';
import 'blocs/category_overview/category_overview_bloc.dart';
import 'blocs/category_overview/category_overview_event.dart';
import 'blocs/favorite_recipes/favorite_recipes_bloc.dart';
import 'blocs/favorite_recipes/favorite_recipes_event.dart';
import 'blocs/new_recipe/general_info/general_info_bloc.dart';
import 'blocs/new_recipe/steps/steps_bloc.dart';
import 'blocs/random_recipe_explorer/random_recipe_explorer.dart';
import 'blocs/recipe_category_overview/recipe_category_overview_bloc.dart';
import 'blocs/recipe_category_overview/recipe_category_overview_event.dart';
import 'blocs/recipe_manager/recipe_manager_bloc.dart';
import 'blocs/recipe_screen_ingredients/recipe_screen_ingredients_bloc.dart';
import 'blocs/recipe_screen_ingredients/recipe_screen_ingredients_event.dart';
import 'blocs/shopping_cart/shopping_cart.dart';
import 'blocs/shopping_cart/shopping_cart_bloc.dart';
import 'blocs/splash_screen/splash_screen_bloc.dart';
import 'blocs/splash_screen/splash_screen_event.dart';
import 'blocs/splash_screen/splash_screen_state.dart';
import 'generated/i18n.dart';
import 'models/shopping_cart.dart';
import 'recipe_overview/add_recipe_screen/general_info/general_info_screen.dart';
import 'recipe_overview/recipe_screen.dart';
import 'screens/SplashScreen.dart';
import 'screens/homepage_screen.dart';

void main() {
  debugPaintSizeEnabled = false;
  runApp(
    CustomTheme(
      initialThemeKey: MyThemeKeys.LIGHT,
      child: MyApp(
        ShoppingCartKeeper(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final ShoppingCartKeeper scKeeper;
  final appTitle = 'Drawer Demo';
  static bool initialized = false;

  MyApp(
    this.scKeeper,
  );

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return BlocProvider<RecipeManagerBloc>(
      builder: (context) => RecipeManagerBloc(),
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
                  builder: (context) =>
                      SplashScreenBloc()..add(SPInitializeData(context)),
                  child: BlocBuilder<SplashScreenBloc, SplashScreenState>(
                      builder: (context, state) {
                    if (state is InitializingData) {
                      return SplashScreen();
                    } else if (state is InitializedData) {
                      return BlocProvider<AppBloc>(
                        builder: (context) => AppBloc()
                          ..add(InitializeData(context,
                              state.recipeCategoryOverview, state.showIntro)),
                        child: MultiBlocProvider(providers: [
                          BlocProvider<CategoryOverviewBloc>(
                            builder: (context) => CategoryOverviewBloc(
                              recipeManagerBloc:
                                  BlocProvider.of<RecipeManagerBloc>(context),
                            )..add(COLoadCategoryOverview()),
                          ),
                          BlocProvider<RecipeCategoryOverviewBloc>(
                            builder: (context) => RecipeCategoryOverviewBloc(
                              recipeManagerBloc:
                                  BlocProvider.of<RecipeManagerBloc>(context),
                            )..add(RCOLoadRecipeCategoryOverview()),
                          ),
                          BlocProvider<FavoriteRecipesBloc>(
                              builder: (context) => FavoriteRecipesBloc(
                                    recipeManagerBloc:
                                        BlocProvider.of<RecipeManagerBloc>(
                                            context),
                                  )..add(LoadFavorites())),
                          BlocProvider<RandomRecipeExplorerBloc>(
                            builder: (context) => RandomRecipeExplorerBloc(
                              recipeManagerBloc:
                                  BlocProvider.of<RecipeManagerBloc>(context),
                            )..add(InitializeRandomRecipeExplorer()),
                          ),
                          BlocProvider<ShoppingCartBloc>(
                            builder: (context) =>
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
                builder: (context) => BlocProvider<RecipeScreenIngredientsBloc>(
                  builder: (context) => RecipeScreenIngredientsBloc(
                      shoppingCartBloc: args.shoppingCartBloc)
                    ..add(InitializeIngredients(
                      args.recipe.name,
                      args.recipe.servings,
                      args.recipe.ingredients,
                    )),
                  child: RecipeScreen(
                    recipe: args.recipe,
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
                    BlocProvider<GeneralInfoBloc>(
                      builder: (context) => GeneralInfoBloc(),
                    ),
                    BlocProvider<CategoryManagerBloc>(
                      builder: (context) => CategoryManagerBloc(
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
                  builder: (context) => IngredientsBloc(),
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
                  builder: (context) => StepImagesBloc(),
                  child: BlocProvider<StepsBloc>(
                    builder: (context) =>
                        StepsBloc(BlocProvider.of<StepImagesBloc>(context)),
                    child: StepsScreen(
                      modifiedRecipe: args.modifiedRecipe,
                      editingRecipeName: args.editingRecipeName,
                    ),
                  ),
                ),
              );

            case "/manage-categories":
              return MaterialPageRoute(
                builder: (context) => BlocProvider(
                  builder: (context) => CategoryManagerBloc(
                    recipeManagerBloc:
                        BlocProvider.of<RecipeManagerBloc>(context),
                  )..add(InitializeCategoryManager()),
                  child: CategoryManager(),
                ),
              );

            case "/manage-nutritions":
              return MaterialPageRoute(
                builder: (context) => BlocProvider<NutritionManagerBloc>(
                  builder: (context) =>
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
