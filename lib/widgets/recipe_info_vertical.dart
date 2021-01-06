import 'dart:io';

import 'package:flutter/material.dart';

import '../ad_related/ad.dart';
import '../constants/global_constants.dart' as Constants;
import '../constants/global_settings.dart';
import '../models/recipe.dart';
import '../screens/recipe_screen.dart';
import 'animated_vegetable.dart';
import 'gallery_view.dart';
import 'recipe_screen/complexity_wave.dart';
import 'recipe_screen/recipe_tag_wrap.dart';
import 'recipe_screen/time_info.dart';
import 'recipe_screen/time_info_chart.dart';

const Color textColor = Colors.white;
const String recipeScreenFontFamily = 'Questrial';

class RecipeInfoVertical extends StatelessWidget {
  final Recipe recipe;
  final String heroImageTag;
  final double width;
  final List<String> categoriesFiles;

  const RecipeInfoVertical(
    this.recipe,
    this.width,
    this.categoriesFiles,
    this.heroImageTag, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            _showPictureFullView(recipe.imagePath, heroImageTag, context);
          },
          child: Container(
            height: 250,
            child: Stack(children: <Widget>[
              Hero(
                tag: GlobalSettings().animationsEnabled()
                    ? heroImageTag
                    : "heroImageTag2",
                child: Material(
                  color: Colors.transparent,
                  child: ClipPath(
                    clipper: MyClipper(),
                    child: Container(
                        height: 250,
                        child: recipe.imagePath == Constants.noRecipeImage
                            ? Image.asset(Constants.noRecipeImage,
                                width: double.infinity, fit: BoxFit.cover)
                            : Image.file(File(recipe.imagePath),
                                width: double.infinity, fit: BoxFit.cover)),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
                  child: AnimatedVegetable(recipe.vegetable),
                ),
              )
            ]),
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
        SizedBox(height: 12),
        Center(
          child: _showComplexTopArea(
                  recipe.preperationTime, recipe.cookingTime, recipe.totalTime)
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: Wrap(
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.center,
                    runSpacing: 25,
                    spacing: 20,
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
                        recipe.preperationTime ?? 0,
                        recipe.cookingTime ?? 0,
                        recipe.totalTime ?? 0,
                        recipeScreenFontFamily,
                        horizontal: false,
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
                      ),
                    ]..removeWhere((item) => item == null),
                  ),
                )
              : null,
        ),
        width >= 350 && recipe.notes != ""
            ? NotesSection(notes: recipe.notes)
            : null,
        width >= 350 && recipe.source != null && recipe.source != ""
            ? RecipeSource(recipe.source)
            : null,
        width >= 350 && recipe.categories.length > 0
            ? CategoriesSection(
                categories: recipe.categories,
                categoriesFiles: categoriesFiles,
              )
            : null,
        recipe.nutritions.isNotEmpty
            ? Container(
                height: 100,
              )
            : null,
      ]
        ..add(
          recipe.nutritions.isNotEmpty &&
                  MediaQuery.of(context).size.width > 550 &&
                  Ads.shouldShowAds()
              ? Container(height: 160)
              : Container(),
        )
        ..removeWhere((item) => item == null),
    );
  }

  void _showPictureFullView(String image, String tag, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Ads().getAdPage(
          GalleryPhotoView(
            initialIndex: 0,
            galleryImagePaths: [image],
            descriptions: [''],
            heroTags: [tag],
          ),
          context,
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
