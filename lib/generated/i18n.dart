import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types
// ignore_for_file: prefer_single_quotes
// ignore_for_file: unnecessary_brace_in_string_interps

//WARNING: This file is automatically generated. DO NOT EDIT, all your changes would be lost.

typedef LocaleChangeCallback = void Function(Locale locale);

class I18n implements WidgetsLocalizations {
  const I18n();
  static Locale _locale;
  static bool _shouldReload = false;

  static set locale(Locale newLocale) {
    _shouldReload = true;
    I18n._locale = newLocale;
  }

  static const GeneratedLocalizationsDelegate delegate = GeneratedLocalizationsDelegate();

  /// function to be invoked when changing the language
  static LocaleChangeCallback onLocaleChanged;

  static I18n of(BuildContext context) =>
    Localizations.of<I18n>(context, WidgetsLocalizations);

  @override
  TextDirection get textDirection => TextDirection.ltr;

  /// "The data is YOURS"
  String get the_data_is_YOURS => "The data is YOURS";
  /// "Your data will NEVER leave your device when you don’t explicitely intent it to."
  String get data_will_never_leave_your_device => "Your data will NEVER leave your device when you don’t explicitely intent it to.";
  /// "Choose a theme"
  String get choose_a_theme => "Choose a theme";
  /// "Swype your recipes"
  String get swype_your_recipes => "Swype your recipes";
  /// "If you can’t decide what recipe to cook, use random recipe explorer ;-)"
  String get if_you_cant_decide_random_recipe_explorer => "If you can’t decide what recipe to cook, use random recipe explorer ;-)";
  /// "EXPORT as text or zip"
  String get export_as_text_or_zip => "EXPORT as text or zip";
  /// "export as zip for using them on multiple devices, OR as text for people who sadly don’t have the app installed."
  String get multiple_devices_use_export_as_zip_etc => "export as zip for using them on multiple devices, OR as text for people who sadly don’t have the app installed.";
  /// "Add to shoppingcart"
  String get add_to_shoppingcart => "Add to shoppingcart";
  /// "you can add the ingredients of your recipe to your shoppingcart for more relaxed shopping."
  String get for_more_relaxed_shopping_add_to_shoppingcart => "you can add the ingredients of your recipe to your shoppingcart for more relaxed shopping.";
  /// "recipes"
  String get recipes => "recipes";
  /// "Nutritions"
  String get nutritions => "Nutritions";
  /// "delete recipe"
  String get delete_recipe => "delete recipe";
  /// "share recipe"
  String get share_recipe => "share recipe";
  /// "select recipes"
  String get select_recipes => "select recipes";
  /// "import recipe's"
  String get import_recipe_s => "import recipe's";
  /// "export recipe's"
  String get export_recipe_s => "export recipe's";
  /// "remove section"
  String get remove_section => "remove section";
  /// "remove ingredient"
  String get remove_ingredient => "remove ingredient";
  /// "remove step"
  String get remove_step => "remove step";
  /// "export as zip"
  String get export_zip => "export as zip";
  /// "export as text"
  String get export_text => "export as text";
  /// "edit"
  String get edit => "edit";
  /// "shoppingcart"
  String get shoppingcart => "shoppingcart";
  /// "shopping list"
  String get shopping_list => "shopping list";
  /// "add to shopping cart"
  String get add_to_cart => "add to shopping cart";
  /// "add"
  String get add => "add";
  /// "recipe name"
  String get recipe_name => "recipe name";
  /// "add recipe"
  String get add_recipe => "add recipe";
  /// "add favorites"
  String get add_favorites => "add favorites";
  /// "add section"
  String get add_section => "add section";
  /// "add ingredient"
  String get add_ingredient => "add ingredient";
  /// "your"
  String get your => "your";
  /// "add step"
  String get add_step => "add step";
  /// "add nutritions"
  String get add_nutritions => "add nutritions";
  /// "increase servings"
  String get increase_servings => "increase servings";
  /// "decrease servings"
  String get decrease_servings => "decrease servings";
  /// "Directions"
  String get directions => "Directions";
  /// "Notes"
  String get notes => "Notes";
  /// "Categories"
  String get categories => "Categories";
  /// "ingredients for"
  String get ingredients_for => "ingredients for";
  /// "ingredients"
  String get ingredients => "ingredients";
  /// "ingredient"
  String get ingredient => "ingredient";
  /// "servings"
  String get servings => "servings";
  /// "in minutes"
  String get in_minutes => "in minutes";
  /// "name"
  String get name => "name";
  /// "preperation time"
  String get prep_time => "preperation time";
  /// "cooking time"
  String get cook_time => "cooking time";
  /// "total time"
  String get total_time => "total time";
  /// "remaining time"
  String get remaining_time => "remaining time";
  /// "section name"
  String get section_name => "section name";
  /// "amnt"
  String get amnt => "amnt";
  /// "unit"
  String get unit => "unit";
  /// "with meat"
  String get with_meat => "with meat";
  /// "vegetarian"
  String get vegetarian => "vegetarian";
  /// "vegan"
  String get vegan => "vegan";
  /// "steps"
  String get steps => "steps";
  /// "description"
  String get description => "description";
  /// "complexity/effort"
  String get complexity_effort => "complexity/effort";
  /// "complexity"
  String get complexity => "complexity";
  /// "effort"
  String get effort => "effort";
  /// "select subcategories:"
  String get select_subcategories => "select subcategories:";
  /// "select a category"
  String get select_a_category => "select a category";
  /// "basket"
  String get basket => "basket";
  /// "Your shoppingcart is empty"
  String get shopping_cart_is_empty => "Your shoppingcart is empty";
  /// "explore"
  String get explore => "explore";
  /// "roll the dice"
  String get roll_the_dice => "roll the dice";
  /// "switch theme"
  String get switch_theme => "switch theme";
  /// "switch shopping cart look"
  String get switch_shopping_cart_look => "switch shopping cart look";
  /// "view intro"
  String get view_intro => "view intro";
  /// "manage nutritions"
  String get manage_nutritions => "manage nutritions";
  /// "manage categories"
  String get manage_categories => "manage categories";
  /// "no category"
  String get no_category => "no category";
  /// "all categories"
  String get all_categories => "all categories";
  /// "you have no categories"
  String get you_have_no_categories => "you have no categories";
  /// "you have no nutritions"
  String get you_have_no_nutritions => "you have no nutritions";
  /// "about me"
  String get about_me => "about me";
  /// "rate this app"
  String get rate_app => "rate this app";
  /// "settings"
  String get settings => "settings";
  /// "cancel"
  String get cancel => "cancel";
  /// "save"
  String get save => "save";
  /// "alright"
  String get alright => "alright";
  /// "favorites"
  String get favorites => "favorites";
  /// "You have no recipes under this category"
  String get no_recipes_under_this_category => "You have no recipes under this category";
  /// "You haven't added any favorites yet"
  String get no_added_favorites_yet => "You haven't added any favorites yet";
  /// "recipename taken"
  String get recipename_taken => "recipename taken";
  /// "change the recipename to something more detailed or maybe you just forgot, that you already saved this recipe :)"
  String get recipename_taken_description => "change the recipename to something more detailed or maybe you just forgot, that you already saved this recipe :)";
  /// "check your ingredients input"
  String get check_ingredients_input => "check your ingredients input";
  /// "it seems like your ingredients information aren't filled out correctly. They must be filled in like the following: \n- every ingredient must have a name\n- every ingredient with a unit must also have an amount"
  String get check_ingredients_input_description => "it seems like your ingredients information aren't filled out correctly. They must be filled in like the following: \n- every ingredient must have a name\n- every ingredient with a unit must also have an amount";
  /// "check your ingredients section fields."
  String get check_ingredient_section_fields => "check your ingredients section fields.";
  /// "if you have multiple sections, you need to provide a title for each section."
  String get check_ingredient_section_fields_description => "if you have multiple sections, you need to provide a title for each section.";
  /// "Check filled in information"
  String get check_filled_in_information => "Check filled in information";
  /// "it seems, that you haven’t filled in the required fields. Please check for any red marked text fields."
  String get check_filled_in_information_description => "it seems, that you haven’t filled in the required fields. Please check for any red marked text fields.";
  /// "you have no recipes to search through"
  String get no_recipes_to_search_through => "you have no recipes to search through";
  /// "almost done😊"
  String get almost_done => "almost done😊";
  /// "exporting recipe"
  String get exporting_recipe => "exporting recipe";
  /// "out of"
  String get out_of => "out of";
  /// "no valid number"
  String get no_valid_number => "no valid number";
  /// "data_required"
  String get data_required => "data_required";
  /// "not required (e.g. ingredients of sauce)"
  String get not_required_eg_ingredients_of_sauce => "not required (e.g. ingredients of sauce)";
  /// "you already have"
  String get you_already_have => "you already have";
  /// "imported"
  String get imported => "imported";
  /// "no valid importfile"
  String get no_valid_import_file => "no valid importfile";
  /// "hide"
  String get hide => "hide";
  /// "delete nutrition?"
  String get delete_nutrition => "delete nutrition?";
  /// "Are you sure you want to delete this nutrition:"
  String get sure_you_want_to_delete_this_nutrition => "Are you sure you want to delete this nutrition:";
  /// "delete category?"
  String get delete_category => "delete category?";
  /// "Are you sure you want to delete this category:"
  String get sure_you_want_to_delete_this_category => "Are you sure you want to delete this category:";
  /// "Are you sure that you want to delete this recipe:"
  String get sure_you_want_to_delete_this_recipe => "Are you sure that you want to delete this recipe:";
  /// "no"
  String get no => "no";
  /// "ja"
  String get yes => "ja";
  /// "verbergen"
  String get dismiss => "verbergen";
  /// "if supported, theme will be applied, when restarting the app :)"
  String get snackbar_automatic_theme_applied => "if supported, theme will be applied, when restarting the app :)";
  /// "bright theme applied"
  String get snackbar_bright_theme_applied => "bright theme applied";
  /// "dark theme applied"
  String get snackbar_dark_theme_applied => "dark theme applied";
  /// "midnight theme applied"
  String get snackbar_midnight_theme_applied => "midnight theme applied";
  /// "by name"
  String get by_name => "by name";
  /// "by effort"
  String get by_effort => "by effort";
  /// "by ingredientsamount"
  String get by_ingredientsamount => "by ingredientsamount";
  /// "category already exists"
  String get category_already_exists => "category already exists";
  /// "category name"
  String get categoryname => "category name";
  /// "ingredient search"
  String get ingredient_search => "ingredient search";
  /// "please enter some ingredients"
  String get please_enter_some_ingredients => "please enter some ingredients";
  /// "no matching recipes"
  String get no_matching_recipes => "no matching recipes";
  /// "matches"
  String get matches => "matches";
  /// "delete ingredient"
  String get delete_ingredient => "delete ingredient";
  /// "manage ingredients"
  String get manage_ingredients => "manage ingredients";
  /// "ingredient already exists"
  String get ingredient_already_exists => "ingredient already exists";
  /// "nutrition already exists"
  String get nutrition_already_exists => "nutrition already exists";
  /// "nutrition"
  String get nutrition => "nutrition";
  /// "you made it to the end"
  String get you_made_it_to_the_end => "you made it to the end";
  /// "no recipes"
  String get no_recipes => "no recipes";
  /// "finished"
  String get finished => "finished";
  /// "importing recipe/s"
  String get importing_recipes => "importing recipe/s";
  /// "select recipe/s to import"
  String get select_recipes_to_import => "select recipe/s to import";
  /// "ready"
  String get ready => "ready";
  /// "successful"
  String get successful => "successful";
  /// "duplicate"
  String get duplicate => "duplicate";
  /// "failed"
  String get failed => "failed";
  /// "summary"
  String get summary => "summary";
  /// "none"
  String get none => "none";
  /// "saving your input"
  String get saving_your_input => "saving your input";
  /// "please enter a name"
  String get please_enter_a_name => "please enter a name";
  /// "invalid name"
  String get invalid_name => "invalid name";
  /// "add general info"
  String get add_general_info => "add general info";
  /// "add steps"
  String get add_steps => "add steps";
  /// "Add steps description or remove image/s"
  String get too_many_images_for_the_steps => "Add steps description or remove image/s";
  /// "you have added more images for the steps, than steps with a description. So images would get lost. Please fix the issue."
  String get too_many_images_for_the_steps_description => "you have added more images for the steps, than steps with a description. So images would get lost. Please fix the issue.";
  /// "add ingredients info"
  String get add_ingredients_info => "add ingredients info";
  /// "category"
  String get categoy => "category";
  /// "do you want to import the recipe's?"
  String get do_you_want_to_import_the_recipe => "do you want to import the recipe's?";
  /// "you have no ingredients"
  String get you_have_no_ingredients => "you have no ingredients";
  /// "recipe for"
  String get recipe_for => "recipe for";
  /// "information"
  String get info => "information";
  /// "Here you can manage the ingredients, which you get suggested when adding a recipe or searching for them. When you edit or delete them, they don't change for the recipe. It's just for the suggestions for saving time when typing."
  String get ingredient_manager_description => "Here you can manage the ingredients, which you get suggested when adding a recipe or searching for them. When you edit or delete them, they don't change for the recipe. It's just for the suggestions for saving time when typing.";
  /// "Here you can manage your nutritions. When you edit or delete them, the recipes with nutritions stay the same. If you want to edit the nutrition of an existing recipe, you have to edit the recipe itself."
  String get nutrition_manager_description => "Here you can manage your nutritions. When you edit or delete them, the recipes with nutritions stay the same. If you want to edit the nutrition of an existing recipe, you have to edit the recipe itself.";
  /// "no recipes fit your filter"
  String get no_recipes_fit_your_filter => "no recipes fit your filter";
  /// "In no event shall the authors of My RecipeBook application be liable for any damages directly or indirectly caused by the application. You are acknowledging that you are 100% responsible for whatever you do with My RecipeBook."
  String get disclaimer_description => "In no event shall the authors of My RecipeBook application be liable for any damages directly or indirectly caused by the application. You are acknowledging that you are 100% responsible for whatever you do with My RecipeBook.";
  /// "share this app"
  String get share_this_app => "share this app";
  /// "recipe pinned to overview"
  String get recipe_pinned_to_overview => "recipe pinned to overview";
  /// "field must not be empty"
  String get field_must_not_be_empty => "field must not be empty";
  /// "by last modified"
  String get by_last_modified => "by last modified";
}

class _I18n_en_US extends I18n {
  const _I18n_en_US();

  @override
  TextDirection get textDirection => TextDirection.ltr;
}

class _I18n_de_DE extends I18n {
  const _I18n_de_DE();

  /// "Die Daten gehörten DIR"
  @override
  String get the_data_is_YOURS => "Die Daten gehörten DIR";
  /// "Deine Daten werden nie dein Gerät verlassen, wenn die es nicht explizit forderst."
  @override
  String get data_will_never_leave_your_device => "Deine Daten werden nie dein Gerät verlassen, wenn die es nicht explizit forderst.";
  /// "Wähle ein Theme"
  @override
  String get choose_a_theme => "Wähle ein Theme";
  /// "Wische durch deine Rezepte"
  @override
  String get swype_your_recipes => "Wische durch deine Rezepte";
  /// "Wenn du nicht weißt, was du kochen willst, wische durch zufällige deiner Rezepte ;-)"
  @override
  String get if_you_cant_decide_random_recipe_explorer => "Wenn du nicht weißt, was du kochen willst, wische durch zufällige deiner Rezepte ;-)";
  /// "exportiere als zip, zum Benutzen auf mehreren Geräten oder als Text, wenn die andere Person die App nicht besitzt."
  @override
  String get multiple_devices_use_export_as_zip_etc => "exportiere als zip, zum Benutzen auf mehreren Geräten oder als Text, wenn die andere Person die App nicht besitzt.";
  /// "Dem Einkaufswagen hinzufügen"
  @override
  String get add_to_shoppingcart => "Dem Einkaufswagen hinzufügen";
  /// "Für ein entspannteres Einkaufserlebnis kannst du die Zutaten der Rezepte deiner Einkaufsliste hinzufügen :-)"
  @override
  String get for_more_relaxed_shopping_add_to_shoppingcart => "Für ein entspannteres Einkaufserlebnis kannst du die Zutaten der Rezepte deiner Einkaufsliste hinzufügen :-)";
  /// "Rezepte"
  @override
  String get recipes => "Rezepte";
  /// "Nährwerte"
  @override
  String get nutritions => "Nährwerte";
  /// "Rezept löschen"
  @override
  String get delete_recipe => "Rezept löschen";
  /// "Rezept teilen"
  @override
  String get share_recipe => "Rezept teilen";
  /// "Rezepte auswählen"
  @override
  String get select_recipes => "Rezepte auswählen";
  /// "Rezept/e importieren"
  @override
  String get import_recipe_s => "Rezept/e importieren";
  /// "Rezept/e exportieren"
  @override
  String get export_recipe_s => "Rezept/e exportieren";
  /// "Bereich entfernen"
  @override
  String get remove_section => "Bereich entfernen";
  /// "Zutat entfernen"
  @override
  String get remove_ingredient => "Zutat entfernen";
  /// "Schritt entfernen"
  @override
  String get remove_step => "Schritt entfernen";
  /// "als zip exportieren"
  @override
  String get export_zip => "als zip exportieren";
  /// "als text exportieren"
  @override
  String get export_text => "als text exportieren";
  /// "editieren"
  @override
  String get edit => "editieren";
  /// "Einkaufswagen"
  @override
  String get shoppingcart => "Einkaufswagen";
  /// "Einkaufsliste"
  @override
  String get shopping_list => "Einkaufsliste";
  /// "Einkaufsliste hinzufügen"
  @override
  String get add_to_cart => "Einkaufsliste hinzufügen";
  /// "hinzufügen"
  @override
  String get add => "hinzufügen";
  /// "Rezeptname"
  @override
  String get recipe_name => "Rezeptname";
  /// "Rezept hinzufügen"
  @override
  String get add_recipe => "Rezept hinzufügen";
  /// "Favoriten hinzufügen"
  @override
  String get add_favorites => "Favoriten hinzufügen";
  /// "Bereich hinzufügen"
  @override
  String get add_section => "Bereich hinzufügen";
  /// "Zutat hinzufügen"
  @override
  String get add_ingredient => "Zutat hinzufügen";
  /// "Deine"
  @override
  String get your => "Deine";
  /// "Schritt hinzufügen"
  @override
  String get add_step => "Schritt hinzufügen";
  /// "Nährwerte hinzufügen"
  @override
  String get add_nutritions => "Nährwerte hinzufügen";
  /// "Portionen erhöhen"
  @override
  String get increase_servings => "Portionen erhöhen";
  /// "Portionen verringern"
  @override
  String get decrease_servings => "Portionen verringern";
  /// "Schritte"
  @override
  String get directions => "Schritte";
  /// "Notizen"
  @override
  String get notes => "Notizen";
  /// "Kategorien"
  @override
  String get categories => "Kategorien";
  /// "Zutaten für:"
  @override
  String get ingredients_for => "Zutaten für:";
  /// "Zutaten"
  @override
  String get ingredients => "Zutaten";
  /// "Zutat"
  @override
  String get ingredient => "Zutat";
  /// "Portionen"
  @override
  String get servings => "Portionen";
  /// "in Minuten"
  @override
  String get in_minutes => "in Minuten";
  /// "Name"
  @override
  String get name => "Name";
  /// "Vorb..zeit"
  @override
  String get prep_time => "Vorb..zeit";
  /// "Kochzeit"
  @override
  String get cook_time => "Kochzeit";
  /// "Gesamtzeit"
  @override
  String get total_time => "Gesamtzeit";
  /// "Restzeit"
  @override
  String get remaining_time => "Restzeit";
  /// "Name"
  @override
  String get section_name => "Name";
  /// "Menge"
  @override
  String get amnt => "Menge";
  /// "Einheit"
  @override
  String get unit => "Einheit";
  /// "mit Fleisch"
  @override
  String get with_meat => "mit Fleisch";
  /// "vegetarisch"
  @override
  String get vegetarian => "vegetarisch";
  /// "vegan"
  @override
  String get vegan => "vegan";
  /// "Schritte"
  @override
  String get steps => "Schritte";
  /// "Beschreibung"
  @override
  String get description => "Beschreibung";
  /// "Aufwand"
  @override
  String get complexity_effort => "Aufwand";
  /// "Aufwand"
  @override
  String get complexity => "Aufwand";
  /// "Aufwand"
  @override
  String get effort => "Aufwand";
  /// "Unterkategorien auswählen"
  @override
  String get select_subcategories => "Unterkategorien auswählen";
  /// "Kategorie auswählen"
  @override
  String get select_a_category => "Kategorie auswählen";
  /// "einkaufen"
  @override
  String get basket => "einkaufen";
  /// "Dein Einkaufswagen ist leer"
  @override
  String get shopping_cart_is_empty => "Dein Einkaufswagen ist leer";
  /// "wische"
  @override
  String get explore => "wische";
  /// "zufällige Rezepte"
  @override
  String get roll_the_dice => "zufällige Rezepte";
  /// "theme wechseln"
  @override
  String get switch_theme => "theme wechseln";
  /// "Einkaufwagenansicht ändern"
  @override
  String get switch_shopping_cart_look => "Einkaufwagenansicht ändern";
  /// "Einführung anschauen"
  @override
  String get view_intro => "Einführung anschauen";
  /// "Nährwerte verwalten"
  @override
  String get manage_nutritions => "Nährwerte verwalten";
  /// "Kategorien verwalten"
  @override
  String get manage_categories => "Kategorien verwalten";
  /// "ohne Kategorie"
  @override
  String get no_category => "ohne Kategorie";
  /// "alle Kategorien"
  @override
  String get all_categories => "alle Kategorien";
  /// "du hast noch keine Kategorien hinzugefügt"
  @override
  String get you_have_no_categories => "du hast noch keine Kategorien hinzugefügt";
  /// "du hast noch keine Nährwerte hinzugefügt"
  @override
  String get you_have_no_nutritions => "du hast noch keine Nährwerte hinzugefügt";
  /// "über mich"
  @override
  String get about_me => "über mich";
  /// "bewerte diese App"
  @override
  String get rate_app => "bewerte diese App";
  /// "Einstellungen"
  @override
  String get settings => "Einstellungen";
  /// "Abbrechen"
  @override
  String get cancel => "Abbrechen";
  /// "Speichern"
  @override
  String get save => "Speichern";
  /// "Alles klar!"
  @override
  String get alright => "Alles klar!";
  /// "Favoriten"
  @override
  String get favorites => "Favoriten";
  /// "Du hast keine Rezepte unter dieser Kategorie"
  @override
  String get no_recipes_under_this_category => "Du hast keine Rezepte unter dieser Kategorie";
  /// "Du hast noch keine Favoriten hinzugefügt"
  @override
  String get no_added_favorites_yet => "Du hast noch keine Favoriten hinzugefügt";
  /// "Rezeptname vergeben"
  @override
  String get recipename_taken => "Rezeptname vergeben";
  /// "Ändere den Rezeptnamen zu etwas mehr detailliertem oder du haste einfach nur vergessen, dass du dieses Rezept schon hinzugefügt hast :)"
  @override
  String get recipename_taken_description => "Ändere den Rezeptnamen zu etwas mehr detailliertem oder du haste einfach nur vergessen, dass du dieses Rezept schon hinzugefügt hast :)";
  /// "Überprüfe die Zutatenliste"
  @override
  String get check_ingredients_input => "Überprüfe die Zutatenliste";
  /// "Die Zutatenliste ist nicht korrekt ausgefüllt. Sie muss foldendermaßen ausgefüllt werden: \n- Jede Zutat muss einen Namen haben \n- Wenn füre eine Zutat die Einheit angegeben ist, muss auch die Menge angegeben sein"
  @override
  String get check_ingredients_input_description => "Die Zutatenliste ist nicht korrekt ausgefüllt. Sie muss foldendermaßen ausgefüllt werden: \n- Jede Zutat muss einen Namen haben \n- Wenn füre eine Zutat die Einheit angegeben ist, muss auch die Menge angegeben sein";
  /// "Prüfe die Zutatenliste"
  @override
  String get check_ingredient_section_fields => "Prüfe die Zutatenliste";
  /// "Wenn du mehrere Bereiche in der Zutatenliste festgelegt hast, müssen diese eine Überschrift tragen wie zB. (Teig)."
  @override
  String get check_ingredient_section_fields_description => "Wenn du mehrere Bereiche in der Zutatenliste festgelegt hast, müssen diese eine Überschrift tragen wie zB. (Teig).";
  /// "Prüfe eingegebene Informationen"
  @override
  String get check_filled_in_information => "Prüfe eingegebene Informationen";
  /// "Es scheint so, als hättest du nicht alle geforderten Felder ausgefüllt. Bitte prüfe nach rot markierten Feldern."
  @override
  String get check_filled_in_information_description => "Es scheint so, als hättest du nicht alle geforderten Felder ausgefüllt. Bitte prüfe nach rot markierten Feldern.";
  /// "Du hast keine Rezepte zum durchsuchen"
  @override
  String get no_recipes_to_search_through => "Du hast keine Rezepte zum durchsuchen";
  /// "Fast fertig😊"
  @override
  String get almost_done => "Fast fertig😊";
  /// "exportiere Rezept"
  @override
  String get exporting_recipe => "exportiere Rezept";
  /// "von"
  @override
  String get out_of => "von";
  /// "keine valide Nummber"
  @override
  String get no_valid_number => "keine valide Nummber";
  /// "darf nicht leer sein"
  @override
  String get data_required => "darf nicht leer sein";
  /// "nicht verpflichtend (zB. Zutaten Sauce)"
  @override
  String get not_required_eg_ingredients_of_sauce => "nicht verpflichtend (zB. Zutaten Sauce)";
  /// "es gibt schon einen Eintrag"
  @override
  String get you_already_have => "es gibt schon einen Eintrag";
  /// "hinzugefügt"
  @override
  String get imported => "hinzugefügt";
  /// "keine gültige import-Datei"
  @override
  String get no_valid_import_file => "keine gültige import-Datei";
  /// "verbergen"
  @override
  String get hide => "verbergen";
  /// "Nährwert löschen?"
  @override
  String get delete_nutrition => "Nährwert löschen?";
  /// "Bist du dir sicher, dass du diesen Nährwert endgültig löschen willst: "
  @override
  String get sure_you_want_to_delete_this_nutrition => "Bist du dir sicher, dass du diesen Nährwert endgültig löschen willst: ";
  /// "Kategorie löschen?"
  @override
  String get delete_category => "Kategorie löschen?";
  /// "Bist du dir sicher, dass du diese Kategorie endgültig löschen willst: "
  @override
  String get sure_you_want_to_delete_this_category => "Bist du dir sicher, dass du diese Kategorie endgültig löschen willst: ";
  /// "Bist du dir sicher, dass du dieses Rezept endgültig:"
  @override
  String get sure_you_want_to_delete_this_recipe => "Bist du dir sicher, dass du dieses Rezept endgültig:";
  /// "nein"
  @override
  String get no => "nein";
  /// "ja"
  @override
  String get yes => "ja";
  /// "verbergen"
  @override
  String get dismiss => "verbergen";
  /// "das Theme wird, wenn unterstützt bei neustart angewendet"
  @override
  String get snackbar_automatic_theme_applied => "das Theme wird, wenn unterstützt bei neustart angewendet";
  /// "helles Theme angewendet"
  @override
  String get snackbar_bright_theme_applied => "helles Theme angewendet";
  /// "dunkles Theme angewendet"
  @override
  String get snackbar_dark_theme_applied => "dunkles Theme angewendet";
  /// "schwarzes Theme angewendet"
  @override
  String get snackbar_midnight_theme_applied => "schwarzes Theme angewendet";
  /// "nach Name"
  @override
  String get by_name => "nach Name";
  /// "nach Aufwand"
  @override
  String get by_effort => "nach Aufwand";
  /// "nach Zutatenmenge"
  @override
  String get by_ingredientsamount => "nach Zutatenmenge";
  /// "Kategorie schon vorhanden"
  @override
  String get category_already_exists => "Kategorie schon vorhanden";
  /// "Kategoriename"
  @override
  String get categoryname => "Kategoriename";
  /// "Zutaten-Suche"
  @override
  String get ingredient_search => "Zutaten-Suche";
  /// "Gebe die Zutaten ein"
  @override
  String get please_enter_some_ingredients => "Gebe die Zutaten ein";
  /// "Keine passenden Rezpete gefunden"
  @override
  String get no_matching_recipes => "Keine passenden Rezpete gefunden";
  /// "Trffer"
  @override
  String get matches => "Trffer";
  /// "Zutat löschen"
  @override
  String get delete_ingredient => "Zutat löschen";
  /// "Zutaten verwalten"
  @override
  String get manage_ingredients => "Zutaten verwalten";
  /// "Zutat existiert bereits"
  @override
  String get ingredient_already_exists => "Zutat existiert bereits";
  /// "Nährwert existiert bereits"
  @override
  String get nutrition_already_exists => "Nährwert existiert bereits";
  /// "Nährwert"
  @override
  String get nutrition => "Nährwert";
  /// "Du bist am Ende angekommen"
  @override
  String get you_made_it_to_the_end => "Du bist am Ende angekommen";
  /// "keine Rezepte"
  @override
  String get no_recipes => "keine Rezepte";
  /// "fertig"
  @override
  String get finished => "fertig";
  /// "importiere Rezept/e"
  @override
  String get importing_recipes => "importiere Rezept/e";
  /// "Wählre Rezept/e zum importieren aus"
  @override
  String get select_recipes_to_import => "Wählre Rezept/e zum importieren aus";
  /// "bereit"
  @override
  String get ready => "bereit";
  /// "erfolgreich"
  @override
  String get successful => "erfolgreich";
  /// "Duplikat"
  @override
  String get duplicate => "Duplikat";
  /// "fehlgeschlagen"
  @override
  String get failed => "fehlgeschlagen";
  /// "Zusammenfassung"
  @override
  String get summary => "Zusammenfassung";
  /// "keine"
  @override
  String get none => "keine";
  /// "speichere Daten"
  @override
  String get saving_your_input => "speichere Daten";
  /// "Bitte gebe einen Namen ein"
  @override
  String get please_enter_a_name => "Bitte gebe einen Namen ein";
  /// "ungültiger name"
  @override
  String get invalid_name => "ungültiger name";
  /// "Allgemeine Informationen"
  @override
  String get add_general_info => "Allgemeine Informationen";
  /// "Füge Schritte hinzu"
  @override
  String get add_steps => "Füge Schritte hinzu";
  /// "Beschreibung hinzufügen oder Biler entfernen"
  @override
  String get too_many_images_for_the_steps => "Beschreibung hinzufügen oder Biler entfernen";
  /// "Du hast zu mehr Schritten Bilder hinzugefügt, als du eine Beschreibung gegeben hast. Bitte passe es an, sodass keine Daten verloren gehen."
  @override
  String get too_many_images_for_the_steps_description => "Du hast zu mehr Schritten Bilder hinzugefügt, als du eine Beschreibung gegeben hast. Bitte passe es an, sodass keine Daten verloren gehen.";
  /// "Zutateninformationen"
  @override
  String get add_ingredients_info => "Zutateninformationen";
  /// "Kategorie"
  @override
  String get categoy => "Kategorie";
  /// "Willst du das/die Rezept/e importieren?"
  @override
  String get do_you_want_to_import_the_recipe => "Willst du das/die Rezept/e importieren?";
  /// "Du hast noch keine Zuaten hinzugefügt"
  @override
  String get you_have_no_ingredients => "Du hast noch keine Zuaten hinzugefügt";
  /// "Rezept für"
  @override
  String get recipe_for => "Rezept für";
  /// "Hilfe"
  @override
  String get info => "Hilfe";
  /// "Hier kannst du die Namen der Zutaten, die dir vorgeschlagen werden ändern oder hinzufügen. Wenn du dies tust, werden die Zutaten nicht für die bereits existierenden Rezepte geändert. Es dient lediglich der Zeitersparnis beim Eintippen der Zutaten."
  @override
  String get ingredient_manager_description => "Hier kannst du die Namen der Zutaten, die dir vorgeschlagen werden ändern oder hinzufügen. Wenn du dies tust, werden die Zutaten nicht für die bereits existierenden Rezepte geändert. Es dient lediglich der Zeitersparnis beim Eintippen der Zutaten.";
  /// "Hier kannst du die Namen der Nährstoffe verwalten. Beim ändern oder löschen der exisiterenden werden nicht die Nährwerte, der bereits hinzugefügten Rezepte geändert. Diese bleiben so wie sie sind, solange das Rezept nicht an sich bearbeitet wird."
  @override
  String get nutrition_manager_description => "Hier kannst du die Namen der Nährstoffe verwalten. Beim ändern oder löschen der exisiterenden werden nicht die Nährwerte, der bereits hinzugefügten Rezepte geändert. Diese bleiben so wie sie sind, solange das Rezept nicht an sich bearbeitet wird.";
  /// "Keine Rezepte passen zum angegebenen Filter"
  @override
  String get no_recipes_fit_your_filter => "Keine Rezepte passen zum angegebenen Filter";
  /// "In no event shall the authors of My RecipeBook application be liable for any damages directly or indirectly caused by the application. You are acknowledging that you are 100% responsible for whatever you do with My RecipeBook."
  @override
  String get disclaimer_description => "In no event shall the authors of My RecipeBook application be liable for any damages directly or indirectly caused by the application. You are acknowledging that you are 100% responsible for whatever you do with My RecipeBook.";
  /// "teile diese App"
  @override
  String get share_this_app => "teile diese App";
  /// "Rezept an Hauptansicht angepinnt"
  @override
  String get recipe_pinned_to_overview => "Rezept an Hauptansicht angepinnt";
  /// "Textfeld darf nicht leer sein"
  @override
  String get field_must_not_be_empty => "Textfeld darf nicht leer sein";
  /// "nach Änderungsdatum"
  @override
  String get by_last_modified => "nach Änderungsdatum";

  @override
  TextDirection get textDirection => TextDirection.ltr;
}

class GeneratedLocalizationsDelegate extends LocalizationsDelegate<WidgetsLocalizations> {
  const GeneratedLocalizationsDelegate();
  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale("en", "US"),
      Locale("de", "DE")
    ];
  }

  LocaleResolutionCallback resolution({Locale fallback}) {
    return (Locale locale, Iterable<Locale> supported) {
      if (isSupported(locale)) {
        return locale;
      }
      final Locale fallbackLocale = fallback ?? supported.first;
      return fallbackLocale;
    };
  }

  @override
  Future<WidgetsLocalizations> load(Locale locale) {
    I18n._locale ??= locale;
    I18n._shouldReload = false;
    final String lang = I18n._locale != null ? I18n._locale.toString() : "";
    final String languageCode = I18n._locale != null ? I18n._locale.languageCode : "";
    if ("en_US" == lang) {
      return SynchronousFuture<WidgetsLocalizations>(const _I18n_en_US());
    }
    else if ("de_DE" == lang) {
      return SynchronousFuture<WidgetsLocalizations>(const _I18n_de_DE());
    }
    else if ("en" == languageCode) {
      return SynchronousFuture<WidgetsLocalizations>(const _I18n_en_US());
    }
    else if ("de" == languageCode) {
      return SynchronousFuture<WidgetsLocalizations>(const _I18n_de_DE());
    }

    return SynchronousFuture<WidgetsLocalizations>(const I18n());
  }

  @override
  bool isSupported(Locale locale) {
    for (var i = 0; i < supportedLocales.length && locale != null; i++) {
      final l = supportedLocales[i];
      if (l.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }

  @override
  bool shouldReload(GeneratedLocalizationsDelegate old) => I18n._shouldReload;
}