import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transparent_image/transparent_image.dart';

import '../ad_related/ad.dart';
import '../blocs/animated_stepper/animated_stepper_bloc.dart';
import '../blocs/recipe_screen_ingredients/recipe_screen_ingredients_bloc.dart';
import '../constants/global_settings.dart';
import '../generated/l10n.dart';
import '../models/ingredient.dart';
import 'culinary_editorial_theme.dart';
import 'gallery_view.dart';

class AnimatedStepper extends StatelessWidget {
  const AnimatedStepper(
    this.steps,
    this.stepTitles, {
    this.stepImages,
    this.fontFamily,
    this.lowResStepImages,
    this.ingredients = const [],
    this.stepIngredientIds = const [],
    super.key,
  });

  final List<String> steps;
  final List<String>? stepTitles;
  final String? fontFamily;
  final List<List<String>>? lowResStepImages;
  final List<List<String>>? stepImages;
  final List<List<Ingredient>> ingredients;
  final List<List<String>> stepIngredientIds;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    if (steps.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: palette.surfaceContainer,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(Icons.menu_book_outlined, color: palette.onSurfaceVariant),
            const SizedBox(height: 8),
            Text(
              S.maybeOf(context)?.recipe_instructions_empty ??
                  'This recipe has no instructions yet.',
              textAlign: TextAlign.center,
              style: CulinaryEditorialType.body(
                palette,
                color: palette.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }
    return BlocBuilder<AnimatedStepperBloc, AnimatedStepperState>(
      builder: (context, state) {
        final selected = state is SelectedStep ? state.selectedStep : null;
        return Column(
          children: List.generate(
            steps.length,
            (index) => Padding(
              padding: EdgeInsets.only(
                bottom: index == steps.length - 1 ? 0 : 14,
              ),
              child: _TimelineCard(
                index: index,
                title: index < (stepTitles?.length ?? 0)
                    ? stepTitles![index]
                    : '',
                description: steps[index],
                isSelected: selected == index,
                previewImages: _imagesAt(lowResStepImages, index),
                fullImages: _imagesAt(stepImages, index),
                allStepImages: stepImages ?? const [],
                allDescriptions: steps,
                ingredients: ingredients,
                assignedIngredientIds: index < stepIngredientIds.length
                    ? stepIngredientIds[index]
                    : const [],
                onPressed: () =>
                    context.read<AnimatedStepperBloc>().add(ChangeStep(index)),
              ),
            ),
          ),
        );
      },
    );
  }

  static List<String> _imagesAt(List<List<String>>? values, int index) {
    if (values == null || index >= values.length) return const [];
    return values[index];
  }
}

class _TimelineCard extends StatelessWidget {
  const _TimelineCard({
    required this.index,
    required this.title,
    required this.description,
    required this.isSelected,
    required this.previewImages,
    required this.fullImages,
    required this.allStepImages,
    required this.allDescriptions,
    required this.ingredients,
    required this.assignedIngredientIds,
    required this.onPressed,
  });

  final int index;
  final String title;
  final String description;
  final bool isSelected;
  final List<String> previewImages;
  final List<String> fullImages;
  final List<List<String>> allStepImages;
  final List<String> allDescriptions;
  final List<List<Ingredient>> ingredients;
  final List<String> assignedIngredientIds;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return Semantics(
      button: true,
      selected: isSelected,
      label:
          S.maybeOf(context)?.instruction_number(index + 1) ??
          'Instruction ${index + 1}',
      child: Material(
        color: isSelected ? palette.primarySoft : palette.surface,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          key: Key('recipe-instruction-$index'),
          onTap: onPressed,
          borderRadius: BorderRadius.circular(14),
          child: AnimatedContainer(
            duration: GlobalSettings().animationsEnabled()
                ? const Duration(milliseconds: 220)
                : Duration.zero,
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: palette.shadow,
                  blurRadius: isSelected ? 18 : 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 42,
                      child: Text(
                        '${index + 1}'.padLeft(2, '0'),
                        style:
                            CulinaryEditorialType.headline(
                              palette,
                              size: 25,
                              weight: FontWeight.w600,
                            ).copyWith(
                              color: isSelected
                                  ? palette.primary
                                  : palette.outline.withValues(alpha: .7),
                            ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (title.trim().isNotEmpty) ...[
                            Text(
                              title,
                              style: CulinaryEditorialType.body(
                                palette,
                                size: 14,
                                weight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                          ],
                          Text(
                            description,
                            style: CulinaryEditorialType.body(
                              palette,
                              size: 14,
                              color: palette.onSurfaceVariant,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                _AssignedIngredients(
                  ingredients: ingredients,
                  assignedIngredientIds: assignedIngredientIds,
                ),
                if (previewImages.isNotEmpty || fullImages.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  _StepImages(
                    stepIndex: index,
                    previewImages: previewImages,
                    fullImages: fullImages,
                    allStepImages: allStepImages,
                    allDescriptions: allDescriptions,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StepImages extends StatelessWidget {
  const _StepImages({
    required this.stepIndex,
    required this.previewImages,
    required this.fullImages,
    required this.allStepImages,
    required this.allDescriptions,
  });

  final int stepIndex;
  final List<String> previewImages;
  final List<String> fullImages;
  final List<List<String>> allStepImages;
  final List<String> allDescriptions;

  @override
  Widget build(BuildContext context) {
    final images = previewImages.isNotEmpty ? previewImages : fullImages;
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = images.length == 1
            ? constraints.maxWidth
            : (constraints.maxWidth - 8) / 2;
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(images.length, (imageIndex) {
            return SizedBox(
              width: width,
              child: AspectRatio(
                aspectRatio: images.length == 1 ? 16 / 9 : 4 / 3,
                child: Material(
                  color: CulinaryEditorialPalette.of(context).surfaceContainer,
                  borderRadius: BorderRadius.circular(10),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () =>
                        _showStepFullView(context, stepIndex, imageIndex),
                    child: Hero(
                      tag: GlobalSettings().animationsEnabled()
                          ? 'recipe-step-$stepIndex-$imageIndex'
                          : 'recipe-step-static-$stepIndex-$imageIndex',
                      child: FadeInImage(
                        fadeInDuration: const Duration(milliseconds: 120),
                        placeholder: MemoryImage(kTransparentImage),
                        image: FileImage(File(images[imageIndex])),
                        fit: BoxFit.cover,
                        imageErrorBuilder: (_, __, ___) => const Center(
                          child: Icon(Icons.broken_image_outlined),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  void _showStepFullView(
    BuildContext context,
    int selectedStep,
    int selectedImage,
  ) {
    final flatImages = <String>[];
    final descriptions = <String>[];
    final heroTags = <String>[];
    var initialIndex = 0;
    for (var step = 0; step < allStepImages.length; step++) {
      if (step < selectedStep) initialIndex += allStepImages[step].length;
      for (var image = 0; image < allStepImages[step].length; image++) {
        flatImages.add(allStepImages[step][image]);
        descriptions.add(
          step < allDescriptions.length ? allDescriptions[step] : '',
        );
        heroTags.add('recipe-step-$step-$image');
      }
    }
    if (flatImages.isEmpty) return;
    initialIndex += selectedImage;
    Ads.showBottomBannerAd();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Ads().getAdPage(
          GalleryPhotoView(
            initialIndex: initialIndex,
            galleryImagePaths: flatImages,
            descriptions: descriptions,
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
    required this.ingredients,
    required this.assignedIngredientIds,
  });

  final List<List<Ingredient>> ingredients;
  final List<String> assignedIngredientIds;

  @override
  Widget build(BuildContext context) {
    if (assignedIngredientIds.isEmpty) return const SizedBox.shrink();
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
        for (var section = 0; section < ingredients.length; section++) {
          for (var index = 0; index < ingredients[section].length; index++) {
            final original = ingredients[section][index];
            if (original.id == null ||
                !assignedIngredientIds.contains(original.id)) {
              continue;
            }
            final display =
                section < scaled.length && index < scaled[section].length
                ? scaled[section][index]
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
          padding: const EdgeInsets.only(top: 14, left: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.maybeOf(context)?.ingredients_for_step ??
                    'Ingredients for this step',
                style: CulinaryEditorialType.body(
                  palette,
                  size: 11,
                  weight: FontWeight.w700,
                  color: palette.tertiary,
                  letterSpacing: .55,
                ),
              ),
              const SizedBox(height: 7),
              Wrap(
                spacing: 7,
                runSpacing: 7,
                children: labels
                    .map(
                      (label) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: palette.tertiarySoft,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          label,
                          style: CulinaryEditorialType.body(
                            palette,
                            size: 12,
                            weight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
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
