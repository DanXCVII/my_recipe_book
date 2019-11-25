import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import './theming.dart';
import 'blocs/app/app_bloc.dart';
import 'blocs/app/app_event.dart';
import 'blocs/category_overview/category_overview_bloc.dart';
import 'blocs/category_overview/category_overview_event.dart';
import 'blocs/favorite_recipes/favorite_recipes_bloc.dart';
import 'blocs/favorite_recipes/favorite_recipes_event.dart';
import 'blocs/random_recipe_explorer/random_recipe_explorer.dart';
import 'blocs/recipe_category_overview/recipe_category_overview_bloc.dart';
import 'blocs/recipe_category_overview/recipe_category_overview_event.dart';
import 'blocs/recipe_manager/recipe_manager_bloc.dart';
import 'blocs/shopping_cart/shopping_cart.dart';
import 'blocs/shopping_cart/shopping_cart_bloc.dart';
import 'blocs/splash_screen/splash_screen_bloc.dart';
import 'blocs/splash_screen/splash_screen_event.dart';
import 'blocs/splash_screen/splash_screen_state.dart';
import 'generated/i18n.dart';
import 'models/recipe_keeper.dart';
import 'models/shopping_cart.dart';
import 'recipe_overview/add_recipe_screen/general_info/general_info_screen.dart';
import 'routes.dart';
import 'screens/SplashScreen.dart';
import 'screens/homepage_screen.dart';

void main() {
  debugPaintSizeEnabled = false;
  runApp(
    CustomTheme(
      initialThemeKey: MyThemeKeys.LIGHT,
      child: MyApp(
        RecipeKeeper(),
        ShoppingCartKeeper(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final RecipeKeeper recipeKeeper;
  final ShoppingCartKeeper scKeeper;
  final appTitle = 'Drawer Demo';
  static bool initialized = false;

  MyApp(
    this.recipeKeeper,
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
        routes: {
          "/": (context) => BlocProvider<SplashScreenBloc>(
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
          addRecipe: (context) => GeneralInfoScreen(),
          // manageCategories: (context) =>
        },
      ),
    );
  }
}
