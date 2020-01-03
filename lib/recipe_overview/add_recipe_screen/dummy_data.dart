import 'dart:io';

import 'package:flutter/services.dart';

import '../../local_storage/io_operations.dart' as IO;
import '../../models/enums.dart';
import '../../models/ingredient.dart';
import '../../models/recipe.dart';
import '../../local_storage/local_paths.dart';

class DummyData {
  Future<Recipe> getDummyRecipe() async {
    String recipeName = 'Steak mit Bratsauce';

    String imagePath = PathProvider.pP.getRecipePath(recipeName, '.jpg');
    String imagePreviewPath =
        PathProvider.pP.getRecipePreviewPath(recipeName, '.jpg');

    String recipeImage = await loadAsset('images/meat.jpg', 'meat.jpg');

    await IO.saveRecipeImage(File(recipeImage), recipeName);

    Recipe r1 = Recipe(
      name: recipeName,
      imagePath: imagePath,
      imagePreviewPath: imagePreviewPath,
      preperationTime: 15,
      cookingTime: 60,
      totalTime: 90,
      servings: 3,
      ingredientsGlossary: ['Steacksauce', 'Steack'],
      ingredients: [
        [
          Ingredient(name: 'Rosmarin', amount: 5, unit: 'Zweige'),
          Ingredient(name: 'Mehl', amount: 300, unit: 'g'),
          Ingredient(name: 'Curry', amount: 1, unit: 'EL'),
          Ingredient(name: 'Gewürze', amount: 3, unit: 'Priesen')
        ],
        [
          Ingredient(name: 'Rohrzucker', amount: 50, unit: 'g'),
          Ingredient(name: 'Steak', amount: 700, unit: 'g')
        ],
      ],
      effort: 4,
      vegetable: Vegetable.NON_VEGETARIAN,
      steps: [
        'Flank Steak mit Rohrzucker und Salz bestreuen, anschließend mit Teriyakisauce marinieren '
            'und sanft einmassieren. Im Kühlschrank für 2 bis 3 Stunden ziehen lassen und danach 30 '
            'Minuten bei Zimmertemperatur ruhen lassen.',
        'Flank Steak etwa 2 Minuten bei geschlossenem Deckel grillen, für ein Rautenmuster um 45 Grad '
            'drehen und bei geschlossenem Deckel etwa 2 Minuten weitergrillen. Die Rückseite des Steaks '
            'auf die gleiche Weise grillen.',
        'Das gegrillte Steak wieder in die Teriyakisauce zurücklegen und auf dem Grill eine indirekte '
            'Zone einrichten. Einen Bratenkorb mittig auf den Grill legen, Steak hineinlegen und Deckel '
            'schließen. Nach 10 bis 15 Minuten Steak herausnehmen und kurz ruhen lassen.'
      ],
      stepImages: [
        [
          await IO.saveStepImage(
            File(recipeImage),
            0,
            recipeName: recipeName,
          )
        ],
        [
          await IO.saveStepImage(
            File(recipeImage),
            1,
            recipeName: recipeName,
          ),
          await IO.saveStepImage(
            File(recipeImage),
            1,
            recipeName: recipeName,
          )
        ],
        []
      ],
      notes: 'Steak gegen die Faser in feine Tranchen schneiden.',
      isFavorite: false,
      categories: ['Hauptspeisen'],
      nutritions: [],
    );
    return r1;
  }
}

Future<String> loadAsset(String asset, String finalFileName) async {
  final filename = finalFileName;
  var bytes = await rootBundle.load(asset);
  String dir = await PathProvider.pP.getTmpRecipeDir();
  writeToFile(bytes, '$dir/$filename');
  return '$dir/$filename';
}

Future<void> writeToFile(ByteData data, String path) {
  final buffer = data.buffer;
  return new File(path)
      .writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
}
