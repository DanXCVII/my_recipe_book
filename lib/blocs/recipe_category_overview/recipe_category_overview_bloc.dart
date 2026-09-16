import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../local_storage/local_repository.dart';
import '../../models/recipe.dart';
import '../../models/tuple.dart';
import '../category_overview/category_overview_bloc.dart';
import '../random_recipe_explorer/random_recipe_explorer_bloc.dart';
import '../recipe_manager/recipe_manager_bloc.dart' as RM;

part 'recipe_category_overview_event.dart';
part 'recipe_category_overview_state.dart';

class RecipeCategoryOverviewBloc
    extends Bloc<RecipeCategoryOverviewEvent, RecipeCategoryOverviewState> {
  final RM.RecipeManagerBloc recipeManagerBloc;
  final LocalRepository repository;
  late StreamSubscription subscription;

  RecipeCategoryOverviewBloc({
    required this.recipeManagerBloc,
    required this.repository,
  }) : super(LoadingRecipeCategoryOverviewState()) {
    subscription = recipeManagerBloc.stream.listen((rmState) {
      if (state is LoadedRecipeCategoryOverview) {
        if (rmState is RM.AddRecipesState) {
          add(RCOAddRecipes(rmState.recipes));
        } else if (rmState is RM.DeleteRecipeState) {
          add(RCODeleteRecipe(rmState.recipe));
        } else if (rmState is RM.UpdateRecipeState) {
          add(RCOUpdateRecipe(rmState.oldRecipe, rmState.updatedRecipe));
        } else if (rmState is RM.AddFavoriteState) {
          add(RCOUpdateFavoriteStatus(rmState.recipe));
        } else if (rmState is RM.RemoveFavoriteState) {
          add(RCOUpdateFavoriteStatus(rmState.recipe));
        } else if (rmState is RM.AddCategoriesState) {
          add(RCOAddCategory(rmState.categories));
        } else if (rmState is RM.DeleteCategoryState) {
          add(RCODeleteCategory(rmState.category));
        } else if (rmState is RM.UpdateCategoryState) {
          add(RCOUpdateCategory(rmState.oldCategory, rmState.updatedCategory));
        } else if (rmState is RM.MoveCategoryState) {
          add(RCOMoveCategory(rmState.oldIndex, rmState.newIndex));
        } else if (rmState is RM.DeleteRecipeTagState ||
            rmState is RM.UpdateRecipeTagState) {
          add(RCOLoadRecipeCategoryOverview());
        }
      }
    });

    on<RCOLoadRecipeCategoryOverview>((event, emit) async {
      if (state is! LoadedRecipeCategoryOverview) {
        emit(LoadingRecipeCategoryOverviewState());
      }

      try {
        if (event.reopenBoxes) await repository.reopenBoxes();

        final categoryRecipes = <Tuple2<String, List<Recipe>>>[];
        final categories = repository.getCategoryNames();

        for (final category in categories) {
          final recipes = await repository.getCategoryRecipes(category);
          if (category != "no category" || recipes.isNotEmpty) {
            categoryRecipes.add(Tuple2(category, recipes));
          }
        }

        emit(LoadedRecipeCategoryOverview(categoryRecipes));

        final overviewContext = event.categoryOverviewContext;
        if (overviewContext != null && overviewContext.mounted) {
          BlocProvider.of<RandomRecipeExplorerBloc>(overviewContext)
              .add(InitializeRandomRecipeExplorer());
          BlocProvider.of<CategoryOverviewBloc>(overviewContext)
              .add(COLoadCategoryOverview());
        }
      } catch (error) {
        emit(FailedRecipeCategoryOverviewState(error));
      }
    });

    on<RCOAddRecipes>((event, emit) async {
      if (state is LoadedRecipeCategoryOverview) {
        final recipeCategoryOverview = _addRecipesToOverview(
          event.recipes,
          (state as LoadedRecipeCategoryOverview).rCategoryOverview,
        );

        emit(LoadedRecipeCategoryOverview(recipeCategoryOverview));
      }
    });

    on<RCOUpdateRecipe>((event, emit) async {
      if (state is LoadedRecipeCategoryOverview) {
        final List<Tuple2<String, List<Recipe>>> recipeCategoryOverviewVone =
            _removeRecipeFromOverview(
              event.oldRecipe,
              (state as LoadedRecipeCategoryOverview).rCategoryOverview,
            );
        final List<Tuple2<String, List<Recipe>>> recipeCategoryOverviewVtwo =
            _addRecipesToOverview([
              event.updatedRecipe,
            ], recipeCategoryOverviewVone);

        emit(LoadedRecipeCategoryOverview(recipeCategoryOverviewVtwo));
      }
    });

    on<RCOUpdateFavoriteStatus>((event, emit) {
      if (state is LoadedRecipeCategoryOverview) {
        final sections = (state as LoadedRecipeCategoryOverview)
            .rCategoryOverview
            .map(
              (section) => Tuple2<String, List<Recipe>>(
                section.item1,
                section.item2
                    .map(
                      (recipe) => recipe.name == event.recipe.name
                          ? event.recipe
                          : recipe,
                    )
                    .toList(growable: false),
              ),
            )
            .toList(growable: false);
        emit(LoadedRecipeCategoryOverview(sections));
      }
    });

    on<RCOAddCategory>((event, emit) async {
      if (state is LoadedRecipeCategoryOverview) {
        final recipeCategoryOverview = List<Tuple2<String, List<Recipe>>>.from(
          (state as LoadedRecipeCategoryOverview).rCategoryOverview,
        );
        final noCategoryIndex = recipeCategoryOverview.indexWhere(
          (section) => section.item1 == "no category",
        );
        recipeCategoryOverview.insertAll(
          noCategoryIndex < 0 ? recipeCategoryOverview.length : noCategoryIndex,
          event.categories.map(
            (category) => Tuple2<String, List<Recipe>>(category, const []),
          ),
        );

        emit(LoadedRecipeCategoryOverview(recipeCategoryOverview));
      }
    });

    on<RCODeleteRecipe>((event, emit) async {
      if (state is LoadedRecipeCategoryOverview) {
        final List<Tuple2<String, List<Recipe>>> recipeCategoryOverview =
            _removeRecipeFromOverview(
              event.recipe,
              (state as LoadedRecipeCategoryOverview).rCategoryOverview,
            );

        emit(LoadedRecipeCategoryOverview(recipeCategoryOverview));
      }
    });

    on<RCODeleteCategory>((event, emit) async {
      if (state is LoadedRecipeCategoryOverview) {
        this.add(RCOLoadRecipeCategoryOverview());
      }
    });

    on<RCOMoveCategory>((event, emit) async {
      if (state is LoadedRecipeCategoryOverview) {
        final newrCategoryOverview = List<Tuple2<String, List<Recipe>>>.from(
          (state as LoadedRecipeCategoryOverview).rCategoryOverview,
        );
        newrCategoryOverview
          ..insert(event.newIndex, newrCategoryOverview[event.oldIndex])
          ..removeAt(
            event.oldIndex > event.newIndex
                ? event.oldIndex + 1
                : event.oldIndex,
          );

        emit(LoadedRecipeCategoryOverview(newrCategoryOverview));
      }
    });

    on<RCOUpdateCategory>((event, emit) async {
      if (state is LoadedRecipeCategoryOverview) {
        final List<Tuple2<String, List<Recipe>>> recipeCategoryOverview =
            ((state as LoadedRecipeCategoryOverview).rCategoryOverview.map((
              tuple,
            ) {
              String overviewItemName = tuple.item1;
              if (tuple.item1 == event.oldCategory) {
                overviewItemName = event.updatedCategory;
              }
              return Tuple2<String, List<Recipe>>(
                overviewItemName,
                tuple.item2
                    .map(
                      (recipe) => recipe.copyWith(
                        categories: recipe.categories
                            .map(
                              (category) => category == event.oldCategory
                                  ? event.updatedCategory
                                  : category,
                            )
                            .toList(),
                      ),
                    )
                    .toList(),
              );
            }).toList());

        emit(LoadedRecipeCategoryOverview(recipeCategoryOverview));
      }
    });
  }

  List<Tuple2<String, List<Recipe>>> _removeRecipeFromOverview(
    Recipe recipe,
    List<Tuple2<String, List<Recipe>>> recipeCategoryOverview,
  ) {
    return recipeCategoryOverview
        .map((tuple) {
          final updatedOverviewItem = Tuple2<String, List<Recipe>>(
            tuple.item1,
            tuple.item2
                .where((item) => item.name != recipe.name)
                .toList(growable: false),
          );
          return updatedOverviewItem.item1 == "no category" &&
                  updatedOverviewItem.item2.isEmpty
              ? null
              : updatedOverviewItem;
        })
        .whereType<Tuple2<String, List<Recipe>>>()
        .toList();
  }

  List<Tuple2<String, List<Recipe>>> _addRecipesToOverview(
    List<Recipe> recipes,
    List<Tuple2<String, List<Recipe>>> recipeCategoryOverview,
  ) {
    final sections = recipeCategoryOverview
        .map(
          (section) => Tuple2<String, List<Recipe>>(
            section.item1,
            List<Recipe>.from(section.item2),
          ),
        )
        .toList();

    for (Recipe recipe in recipes) {
      for (String c in recipe.categories) {
        bool alreadyAdded = false;
        for (Tuple2<String, List<Recipe>> t in sections) {
          if (t.item1 == c) {
            t.item2.add(recipe);
            alreadyAdded = true;
          }
        }
        // if it's not yet added
        if (!alreadyAdded) {
          final noCategoryIndex = sections.indexWhere(
            (section) => section.item1 == "no category",
          );
          sections.insert(
            noCategoryIndex < 0 ? sections.length : noCategoryIndex,
            Tuple2<String, List<Recipe>>(c, [recipe]),
          );
        }
      }

      if (recipe.categories.isEmpty) {
        final noCategoryIndex = sections.indexWhere(
          (section) => section.item1 == "no category",
        );
        if (noCategoryIndex >= 0) {
          sections[noCategoryIndex].item2.add(recipe);
        } else {
          sections.add(Tuple2<String, List<Recipe>>("no category", [recipe]));
        }
      }
    }

    return sections;
  }

  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }
}
