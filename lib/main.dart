import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_recipe_book/blocs/new_recipe/ingredients_section/ingredients_section_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:showcaseview/showcase_widget.dart';

import './theming.dart';
import 'ad_related/ad.dart';
import 'blocs/ad_manager/ad_manager_bloc.dart';
import 'blocs/animated_stepper/animated_stepper_bloc.dart';
import 'blocs/app/app_bloc.dart';
import 'blocs/category_manager/category_manager_bloc.dart';
import 'blocs/category_overview/category_overview_bloc.dart';
import 'blocs/favorite_recipes/favorite_recipes_bloc.dart';
import 'blocs/import_recipe/import_recipe_bloc.dart';
import 'blocs/ingredient_search/ingredient_search_bloc.dart';
import 'blocs/ingredinets_manager/ingredients_manager_bloc.dart';
import 'blocs/new_recipe/clear_recipe/clear_recipe_bloc.dart';
import 'blocs/new_recipe/general_info/general_info_bloc.dart';
import 'blocs/new_recipe/ingredients/ingredients_bloc.dart';
import 'blocs/new_recipe/nutritions/nutritions_bloc.dart';
import 'blocs/new_recipe/step_images/step_images_bloc.dart';
import 'blocs/new_recipe/steps/steps_bloc.dart';
import 'blocs/nutrition_manager/nutrition_manager_bloc.dart';
import 'blocs/random_recipe_explorer/random_recipe_explorer_bloc.dart';
import 'blocs/recipe_bubble/recipe_bubble_bloc.dart';
import 'blocs/recipe_category_overview/recipe_category_overview_bloc.dart';
import 'blocs/recipe_manager/recipe_manager_bloc.dart' show RecipeManagerBloc;
import 'blocs/recipe_overview/recipe_overview_bloc.dart';
import 'blocs/recipe_screen/recipe_screen_bloc.dart';
import 'blocs/recipe_screen_ingredients/recipe_screen_ingredients_bloc.dart';
import 'blocs/recipe_tag_manager/recipe_tag_manager_bloc.dart';
import 'blocs/shopping_cart/shopping_cart_bloc.dart';
import 'blocs/splash_screen/splash_screen_bloc.dart';
import 'blocs/website_import/website_import_bloc.dart';
import 'generated/i18n.dart';
import 'screens/SplashScreen.dart';
import 'screens/about_me.dart';
import 'screens/import_pc_info.dart';
import 'screens/add_recipe/general_info_screen/general_info_screen.dart';
import 'screens/add_recipe/ingredients_screen.dart';
import 'screens/add_recipe/nutritions.dart';
import 'screens/add_recipe/steps_screen/steps_screen.dart';
import 'screens/category_manager.dart';
import 'screens/homepage_screen.dart';
import 'screens/import_from_website.dart';
import 'screens/ingredient_search.dart';
import 'screens/ingredient_search_preview_screen.dart';
import 'screens/ingredients_manager.dart';
import 'screens/intro_screen.dart';
import 'screens/nutrition_manager.dart';
import 'screens/recipe_overview.dart';
import 'screens/recipe_screen.dart';
import 'screens/recipe_tag_manager_screen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

  runApp(
    CustomTheme(
      initialThemeKey: MyThemeKeys.LIGHT,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RecipeManagerBloc>(
          create: (context) => RecipeManagerBloc(),
        ),
        BlocProvider<RecipeBubbleBloc>(
          create: (context) => RecipeBubbleBloc(
              recipeManagerBloc: BlocProvider.of<RecipeManagerBloc>(context)),
        ),
        BlocProvider<AdManagerBloc>(
          create: (context) => AdManagerBloc()..add(InitializeAds()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          I18n.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        color: Colors.amber,
        supportedLocales: I18n.delegate.supportedLocales,
        showPerformanceOverlay: false,
        theme: CustomTheme.of(context),
        initialRoute: "/",
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case "/":
              return PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) =>
                    BlocProvider<SplashScreenBloc>(
                  create: (context) => SplashScreenBloc()
                    ..add(
                      SPInitializeData(context),
                    ),
                  child: SplashScreen(),
                ),
              );

            case "/home":
              final MyHomePageArguments args = settings.arguments;

              return PageTransition(
                type: PageTransitionType.fade,
                settings: RouteSettings(name: "recipeRoute"),
                child: MultiBlocProvider(
                  providers: [
                    BlocProvider<AppBloc>(
                      create: (context) => AppBloc()
                        ..add(InitializeData(
                          args.context,
                          args.recipeCategoryOverview,
                          args.showIntro,
                        )),
                    ),
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
                                  BlocProvider.of<RecipeManagerBloc>(context),
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
                      create: (context) => ShoppingCartBloc(
                          BlocProvider.of<RecipeManagerBloc>(context))
                        ..add(LoadShoppingCart()),
                    ),
                  ],
                  child: ShowCaseWidget(
                    builder: Builder(
                      builder: (context) => MyHomePage(
                        showIntro: args.showIntro,
                      ),
                    ),
                  ),
                ),
              );

            case "/recipe-screen":
              final RecipeScreenArguments args = settings.arguments;

              Ads.showBottomBannerAd();

              return MaterialPageRoute(
                settings: RouteSettings(name: "recipe-screen"),
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
                    BlocProvider<AnimatedStepperBloc>(
                      create: (context) => AnimatedStepperBloc(
                          initialStep: args.initialSelectedStep),
                    ),
                    BlocProvider<ShoppingCartBloc>.value(
                        value: args.shoppingCartBloc),
                  ],
                  child: Ads().getAdPage(
                      RecipeScreen(
                        heroImageTag: args.heroImageTag,
                        initialScrollOffset: args.initialScrollOffset,
                      ),
                      context),
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
                              BlocProvider.of<RecipeManagerBloc>(context),
                          selectedCategories: args.modifiedRecipe.categories)
                        ..add(InitializeCategoryManager()),
                    ),
                    BlocProvider<RecipeTagManagerBloc>(
                      create: (context) => RecipeTagManagerBloc(
                          recipeManagerBloc:
                              BlocProvider.of<RecipeManagerBloc>(context),
                          selectedTags: args.modifiedRecipe.tags)
                        ..add(
                          InitializeRecipeTagManager(),
                        ),
                    ),
                    BlocProvider<ShoppingCartBloc>.value(
                        value: args.shoppingCartBloc),
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
                builder: (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider<IngredientsBloc>(
                        create: (context) => IngredientsBloc()),
                    BlocProvider<ShoppingCartBloc>.value(
                        value: args.shoppingCartBloc),
                    BlocProvider<IngredientsSectionBloc>(
                      create: (context) => IngredientsSectionBloc()
                        ..add(
                          InitializeIngredientsSection(
                            args.modifiedRecipe.ingredientsGlossary,
                            args.modifiedRecipe.ingredients,
                          ),
                        ),
                    ),
                  ],
                  child: IngredientsAddScreen(
                    modifiedRecipe: args.modifiedRecipe,
                    editingRecipeName: args.editingRecipeName,
                  ),
                ),
              );

            case "/add-recipe/steps":
              final StepsArguments args = settings.arguments;

              return MaterialPageRoute(
                builder: (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider<StepImagesBloc>(
                        create: (context) => StepImagesBloc()
                          ..add(InitializeStepImages(
                              stepImages: args.modifiedRecipe.stepImages))),
                    BlocProvider<StepsBloc>(
                      create: (context) =>
                          StepsBloc(BlocProvider.of<StepImagesBloc>(context)),
                    ),
                    BlocProvider<ShoppingCartBloc>.value(
                        value: args.shoppingCartBloc),
                  ],
                  child: StepsScreen(
                    modifiedRecipe: args.modifiedRecipe,
                    editingRecipeName: args.editingRecipeName,
                  ),
                ),
              );

            case "/recipe-categories":
              final RecipeGridViewArguments args = settings.arguments;

              Ads.showBottomBannerAd();

              return CupertinoPageRoute(
                  settings: RouteSettings(name: "recipeRoute"),
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
                        child: Ads().getAdPage(RecipeGridView(), context),
                      ));

            case "/vegetable-recipes-oveview":
              final RecipeGridViewArguments args = settings.arguments;

              Ads.showBottomBannerAd();

              return CupertinoPageRoute(
                settings: RouteSettings(name: "recipeRoute"),
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
                  child: Ads().getAdPage(RecipeGridView(), context),
                ),
              );

            case "/recipe-tag-recipes-overview":
              final RecipeGridViewArguments args = settings.arguments;

              Ads.showBottomBannerAd();

              return CupertinoPageRoute(
                settings: RouteSettings(name: "recipeRoute"),
                builder: (BuildContext context) => MultiBlocProvider(
                  providers: [
                    BlocProvider<ShoppingCartBloc>.value(
                        value: args.shoppingCartBloc),
                    BlocProvider<RecipeOverviewBloc>(
                      create: (context) => RecipeOverviewBloc(
                          recipeManagerBloc:
                              BlocProvider.of<RecipeManagerBloc>(context))
                        ..add(
                          LoadRecipeTagRecipeOverview(args.recipeTag),
                        ),
                    ),
                  ],
                  child: Ads().getAdPage(RecipeGridView(), context),
                ),
              );

            case "/add-recipe/nutritions":
              final AddRecipeNutritionsArguments args = settings.arguments;

              return MaterialPageRoute(
                builder: (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider<NutritionManagerBloc>(
                      create: (context) => NutritionManagerBloc()
                        ..add(
                          LoadNutritionManager(args.editingRecipeName),
                        ),
                    ),
                    BlocProvider<NutritionsBloc>(
                      create: (context) => NutritionsBloc(),
                    ),
                    BlocProvider<ShoppingCartBloc>.value(
                        value: args.shoppingCartBloc),
                  ],
                  child: AddRecipeNutritions(
                    modifiedRecipe: args.modifiedRecipe,
                    editingRecipeName: args.editingRecipeName,
                  ),
                ),
              );

            case "/ingredient-search":
              final IngredientSearchScreenArguments args = settings.arguments;

              if (args.hasPremium) {
                return MaterialPageRoute(
                  settings: RouteSettings(name: "recipeRoute"),
                  builder: (context) => MultiBlocProvider(
                    providers: [
                      BlocProvider<IngredientSearchBloc>(
                        create: (context) => IngredientSearchBloc(),
                      ),
                      BlocProvider<ShoppingCartBloc>.value(
                          value: args.shoppingCartBloc)
                    ],
                    child: IngredientSearchScreen(),
                  ),
                );
              } else {
                return MaterialPageRoute(
                  builder: (context) => BlocProvider<AdManagerBloc>.value(
                      value: args.adManagerBloc,
                      child: IngredinetSearchPreviewScreen()),
                );
              }
              break;

            case "/manage-categories":
              Ads.showBottomBannerAd();
              final CategoryManagerArguments args = settings.arguments;

              if (args != null) {
                return MaterialPageRoute(
                  builder: (context) => BlocProvider<CategoryManagerBloc>.value(
                    value: args.categoryManagerBloc,
                    child: Ads().getAdPage(CategoryManager(), context),
                  ),
                );
              } else {
                return MaterialPageRoute(
                  builder: (context) => BlocProvider<CategoryManagerBloc>(
                    create: (context) => CategoryManagerBloc(
                      recipeManagerBloc:
                          BlocProvider.of<RecipeManagerBloc>(context),
                    )..add(InitializeCategoryManager()),
                    child: Ads().getAdPage(CategoryManager(), context),
                  ),
                );
              }
              break;

            case "/manage-recipe-tags":
              Ads.showBottomBannerAd();
              final RecipeTagManagerArguments args = settings.arguments;

              if (args != null) {
                return MaterialPageRoute(
                  builder: (context) =>
                      BlocProvider<RecipeTagManagerBloc>.value(
                    value: args.recipeTagManagerBloc,
                    child: Ads().getAdPage(RecipeTagManager(), context),
                  ),
                );
              } else {
                return MaterialPageRoute(
                  builder: (context) => BlocProvider<RecipeTagManagerBloc>(
                    create: (context) => RecipeTagManagerBloc(
                      recipeManagerBloc:
                          BlocProvider.of<RecipeManagerBloc>(context),
                    )..add(InitializeRecipeTagManager()),
                    child: Ads().getAdPage(RecipeTagManager(), context),
                  ),
                );
              }
              break;

            case "/manage-nutritions":
              Ads.showBottomBannerAd();

              return MaterialPageRoute(
                builder: (context) => BlocProvider<NutritionManagerBloc>(
                  create: (context) =>
                      NutritionManagerBloc()..add(LoadNutritionManager()),
                  child: Ads().getAdPage(NutritionManager(), context),
                ),
              );

            case "/manage-ingredients":
              Ads.showBottomBannerAd();

              return MaterialPageRoute(
                builder: (context) => BlocProvider<IngredientsManagerBloc>(
                  create: (context) =>
                      IngredientsManagerBloc()..add(LoadIngredientsManager()),
                  child: Ads().getAdPage(IngredientsManager(), context),
                ),
              );

            case "/import-recipes-from-website":
              final ImportFromWebsiteArguments args = settings.arguments;

              return MaterialPageRoute(
                builder: (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider<WebsiteImportBloc>(
                        create: (_) => WebsiteImportBloc(
                            BlocProvider.of<RecipeManagerBloc>(context))
                          ..add(args.initialWebsite == null
                              ? null
                              : ImportRecipe(args.initialWebsite))),
                    BlocProvider<ShoppingCartBloc>.value(
                      value: args.shoppingCartBloc,
                    ),
                    BlocProvider<AdManagerBloc>.value(
                      value: args.adManagerBloc,
                    )
                  ],
                  child: ImportFromWebsiteScreen(
                    initialWebsite: args.initialWebsite ?? "",
                  ),
                ),
              );

            case "/intro":
              SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

              return MaterialPageRoute(
                builder: (context) => WillPopScope(
                  onWillPop: () async {
                    SystemChrome.setEnabledSystemUIOverlays(
                        SystemUiOverlay.values);
                    return true;
                  },
                  child: IntroScreen(),
                ),
              );

            case "/computer-import-info":
              return MaterialPageRoute(
                builder: (context) => ImportPcInfo(),
              );

            case "/about-me":
              return MaterialPageRoute(
                builder: (context) => AboutMeScreen(),
              );

            default:
              return MaterialPageRoute(
                builder: (context) => Text("failllll kek"),
              );
          }
        },
      ),
    );
  }
}
