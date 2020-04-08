import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_recipe_book/constants/global_constants.dart';
import 'package:my_recipe_book/widgets/recipe_screen/complexity_wave.dart';
import 'package:my_recipe_book/widgets/recipe_screen/recipe_tag_wrap.dart';
import 'package:my_recipe_book/widgets/recipe_screen/time_info.dart';
import 'package:my_recipe_book/widgets/recipe_screen/time_info_chart.dart';

import '../constants/global_settings.dart';
import '../models/recipe.dart';
import 'animated_vegetable.dart';
import 'gallery_view.dart';

const Color textColor = Colors.white;
const String recipeScreenFontFamily = 'Questrial';

class RecipeInfoVertical extends StatelessWidget {
  final Recipe recipe;
  final String heroImageTag;

  const RecipeInfoVertical(
    this.recipe,
    this.heroImageTag, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 22, 0, 12),
            child: Hero(
              tag: GlobalSettings().animationsEnabled()
                  ? heroImageTag
                  : "heroImageTag2",
              child: Material(
                color: Colors.transparent,
                child: GestureDetector(
                  onTap: () {
                    _showPictureFullView(
                        recipe.imagePath, heroImageTag, context);
                  },
                  child: Container(
                    height: 140,
                    width: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: recipe.imagePath == noRecipeImage
                            ? AssetImage(noRecipeImage)
                            : FileImage(
                                File(recipe.imagePath),
                              ),
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: AnimatedVegetable(
                        recipe.vegetable,
                        small: true,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              "${recipe.name}",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: 24,
                fontWeight: FontWeight.w600,
                fontFamily: recipeScreenFontFamily,
              ),
            ),
          ),
        ),
        Center(
          child: _showComplexTopArea(
                  recipe.preperationTime, recipe.cookingTime, recipe.totalTime)
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TimeInfo(
                      textColor,
                      recipeScreenFontFamily,
                      recipe.preperationTime,
                      recipe.totalTime,
                      recipe.cookingTime,
                    ),
                    SizedBox(height: 12),
                    TimeInfoChart(
                      textColor,
                      recipe.preperationTime,
                      recipe.cookingTime,
                      recipe.totalTime,
                      recipeScreenFontFamily,
                      horizontal: true,
                    ),
                    SizedBox(height: 12),
                    ComplexityWave(
                      textColor,
                      recipeScreenFontFamily,
                      recipe.effort,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
                      child: RecipeTagWrap(
                        recipe.tags,
                        recipeScreenFontFamily,
                      ),
                    )
                  ],
                )
              : null,
        ),
        recipe.nutritions.isNotEmpty
            ? Container(
                height: 145,
              )
            : null,
      ]..removeWhere((item) => item == null),
    );
  }

  void _showPictureFullView(String image, String tag, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryPhotoView(
          initialIndex: 0,
          galleryImagePaths: [image],
          descriptions: [''],
          heroTags: [tag],
        ),
      ),
    );
  }

  /// method which determines if the circular chart and complexity termometer should be
  /// shown or only a minimal version
  bool _showComplexTopArea(
      double preperationTime, double cookingTime, double totalTime) {
    int validator = 0;

    if (preperationTime != 0) validator++;
    if (cookingTime != 0) validator++;
    if (totalTime != 0) validator++;
    if (preperationTime == totalTime || cookingTime == totalTime) return false;
    if (validator > 1) return true;
    return false;
  }
}
