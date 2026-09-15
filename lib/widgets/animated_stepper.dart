import 'dart:io';

import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../ad_related/ad.dart';
import '../constants/global_settings.dart';
import 'clipper.dart';

import 'package:transparent_image/transparent_image.dart';

import '../blocs/animated_stepper/animated_stepper_bloc.dart';
import '../blocs/recipe_screen_ingredients/recipe_screen_ingredients_bloc.dart';
import '../models/ingredient.dart';
import 'culinary_editorial_theme.dart';
import 'gallery_view.dart';

class AnimatedStepper extends StatelessWidget {
  final List<String> steps;
  final List<String>? stepTitles;
  final String? fontFamily;
  // if losResStepImages are provided, also stepImages must be provided
  final List<List<String>>? lowResStepImages;
  final List<List<String>>? stepImages;
  final List<List<Ingredient>> ingredients;
  final List<List<String>> stepIngredientIds;

  AnimatedStepper(
    this.steps,
    this.stepTitles, {
    this.stepImages,
    this.fontFamily,
    this.lowResStepImages,
    this.ingredients = const [],
    this.stepIngredientIds = const [],
    Key? key,
  }) : super(key: key) {
    if (stepTitles != null && stepTitles!.length > steps.length) {
      for (int i = steps.length; i < stepTitles!.length; i++) {
        stepTitles!.removeLast();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: _getStepsWithTitle(stepTitles, steps));
  }

  List<Widget> _getStepsWithTitle(
    List<String>? stepTitles,
    List<String> selectedSteps,
  ) {
    if (stepTitles == null) {
      return _getSteps(selectedSteps, 0);
    }

    List<Widget> fullList = [];
    for (int i = 0; i < stepTitles.length; i++) {
      if (i == 0 || stepTitles[i] != "") {
        int nextTitleIndex = stepTitles.length;
        if (i + 1 < stepTitles.length) {
          String? nextTitle = stepTitles
              .sublist(i + 1)
              .firstWhereOrNull((e) => e != "");
          if (nextTitle == null) {
            nextTitleIndex = stepTitles.length;
          } else {
            nextTitleIndex =
                stepTitles.sublist(i + 1).indexOf(nextTitle) + i + 1;
          }
        }
        if (stepTitles[i] != "") {
          fullList.add(
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipPath(
                    clipper: LeftArrow(),
                    child: Container(
                      height: 17,
                      width: 25,
                      color: Colors.amberAccent[700],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      child: Text(
                        stepTitles[i],
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Questrial",
                        ),
                      ),
                    ),
                  ),
                  ClipPath(
                    clipper: RightArrow(),
                    child: Container(
                      height: 17,
                      width: 25,
                      color: Colors.amberAccent[700],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        fullList.addAll(_getSteps(selectedSteps.sublist(i, nextTitleIndex), i));
      }
    }
    return fullList;
  }

  List<Widget> _getSteps(List<String> selectedSteps, int globalIndex) {
    return List<Widget>.generate(
      selectedSteps.length,
      (index) => BlocBuilder<AnimatedStepperBloc, AnimatedStepperState>(
        builder: (context, state) {
          if (state is SelectedStep) {
            return Padding(
              padding: const EdgeInsets.only(top: 10),
              child: InkWell(
                onTap: () {
                  BlocProvider.of<AnimatedStepperBloc>(context)
                      .add(ChangeStep(globalIndex + index));
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  color: Color.fromRGBO(
                    0,
                    0,
                    0,
                    state.selectedStep == index + globalIndex ? 0.5 : 0,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 12, 12),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0, top: 20),
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(2, 2),
                                    blurRadius: 3,
                                    spreadRadius: 1,
                                    color: Colors.black26,
                                  ),
                                ],

                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors:
                                      state.selectedStep == index + globalIndex
                                      ? [Color(0xffBE4400), Color(0xffFF7A00)]
                                      : [
                                          Color(0xff933500),
                                          Color(0xff933500)
                                              .withAlpha((0.3 * 255).round()),
                                        ],
                                ),
                                // color: stepsColors[i % (stepsColors.length)],
                              ),
                              child: Center(
                                child: Text(
                                  "${globalIndex + index + 1}.",
                                  style: TextStyle(
                                    color:
                                        state.selectedStep ==
                                            index + globalIndex
                                        ? Color(0xff4F3D00)
                                        : Colors.amber,
                                    fontSize: globalIndex + index > 8 ? 32 : 42,
                                    fontFamily: "Quando",
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  BlocProvider.of<AnimatedStepperBloc>(context)
                                      .add(ChangeStep(index + globalIndex));
                                },
                                child: Container(
                                  padding: EdgeInsets.only(top: 15),
                                  child: Text(
                                    selectedSteps[index],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: fontFamily,
                                    ),
                                  ),
                                ),
                              ),
                              _AssignedIngredients(
                                stepIndex: index + globalIndex,
                                ingredients: ingredients,
                                stepIngredientIds: stepIngredientIds,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 12.0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width - 90,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Wrap(
                                      runSpacing: 10,
                                      spacing: 10,
                                      children: List<Widget>.generate(
                                        lowResStepImages == null
                                            ? stepImages![index + globalIndex]
                                                  .length
                                            : lowResStepImages![index +
                                                      globalIndex]
                                                  .length,
                                        (wrapIndex) => GestureDetector(
                                          onTap: () {
                                            _showStepFullView(
                                              stepImages!,
                                              steps,
                                              index + globalIndex,
                                              wrapIndex,
                                              context,
                                            );
                                          },
                                          child: Hero(
                                            tag:
                                                GlobalSettings()
                                                    .animationsEnabled()
                                                ? "Schritt$index:$wrapIndex"
                                                : "Schritt$index:${wrapIndex}3",
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                              child: Container(
                                                width: 100,
                                                height: 80,
                                                child: FadeInImage(
                                                  fadeInDuration: Duration(
                                                    milliseconds: 100,
                                                  ),
                                                  placeholder: MemoryImage(
                                                    kTransparentImage,
                                                  ),
                                                  image: FileImage(
                                                    File(
                                                      lowResStepImages == null
                                                          ? stepImages![index +
                                                                globalIndex][wrapIndex]
                                                          : lowResStepImages![index +
                                                                globalIndex][wrapIndex],
                                                    ),
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Text(state.toString());
          }
        },
      ),
    );
  }

  void _showStepFullView(
    List<List<String>> stepImages,
    List<String> description,
    int stepNumber,
    int imageNumber,
    BuildContext context,
  ) {
    List<String> flatStepImages = [];
    List<String> imageDescription = [];
    List<String> heroTags = [];
    int imageIndex = 0;
    for (int i = 0; i < stepImages.length; i++) {
      if (i < stepNumber) imageIndex += stepImages[i].length;
      for (int j = 0; j < stepImages[i].length; j++) {
        imageDescription.add(description[i]);
        flatStepImages.add(stepImages[i][j]);
        heroTags.add("Schritt$i:$j");
      }
    }
    imageIndex += imageNumber;

    Ads.showBottomBannerAd();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Ads().getAdPage(
          GalleryPhotoView(
            initialIndex: imageIndex,
            galleryImagePaths: flatStepImages,
            descriptions: imageDescription,
            heroTags: heroTags,
          ),
          context,
        ),
      ),
    ).then((_) => Ads.hideBottomBannerAd());
  }
}

class _AssignedIngredients extends StatelessWidget {
  const _AssignedIngredients({
    required this.stepIndex,
    required this.ingredients,
    required this.stepIngredientIds,
  });

  final int stepIndex;
  final List<List<Ingredient>> ingredients;
  final List<List<String>> stepIngredientIds;

  @override
  Widget build(BuildContext context) {
    if (stepIndex >= stepIngredientIds.length ||
        stepIngredientIds[stepIndex].isEmpty) {
      return const SizedBox.shrink();
    }
    return BlocBuilder<
      RecipeScreenIngredientsBloc,
      RecipeScreenIngredientsState
    >(
      builder: (context, state) {
        final palette = CulinaryEditorialPalette.of(context);
        final scaled = state is LoadedRecipeIngredients
            ? state.ingredients
            : const <List<CheckableIngredient>>[];
        final labels = <String>[];
        for (
          var sectionIndex = 0;
          sectionIndex < ingredients.length;
          sectionIndex++
        ) {
          for (
            var ingredientIndex = 0;
            ingredientIndex < ingredients[sectionIndex].length;
            ingredientIndex++
          ) {
            final original = ingredients[sectionIndex][ingredientIndex];
            if (original.id == null ||
                !stepIngredientIds[stepIndex].contains(original.id)) {
              continue;
            }
            final display =
                sectionIndex < scaled.length &&
                    ingredientIndex < scaled[sectionIndex].length
                ? scaled[sectionIndex][ingredientIndex]
                : CheckableIngredient(
                    original.name,
                    original.amount,
                    original.unit,
                    false,
                  );
            labels.add(_ingredientLabel(display));
          }
        }
        if (labels.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Wrap(
            spacing: 7,
            runSpacing: 7,
            children: labels
                .map(
                  (label) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: palette.tertiarySoft,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: palette.tertiary.withValues(alpha: .55),
                      ),
                    ),
                    child: Text(
                      label,
                      style: CulinaryEditorialType.body(
                        palette,
                        size: 13,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}

String _ingredientLabel(CheckableIngredient ingredient) {
  final amount = ingredient.amount == null
      ? ''
      : ingredient.amount! % 1 == 0
      ? ingredient.amount!.toInt().toString()
      : ingredient.amount!
            .toStringAsFixed(2)
            .replaceFirst(RegExp(r'0+$'), '')
            .replaceFirst(RegExp(r'\.$'), '');
  return [amount, ingredient.unit, ingredient.name]
      .where((part) => part != null && part.toString().trim().isNotEmpty)
      .join(' ');
}
