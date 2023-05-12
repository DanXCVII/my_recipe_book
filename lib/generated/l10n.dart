// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `EN`
  String get two_char_locale {
    return Intl.message(
      'EN',
      name: 'two_char_locale',
      desc: '',
      args: [],
    );
  }

  /// `en_US`
  String get locale_full {
    return Intl.message(
      'en_US',
      name: 'locale_full',
      desc: '',
      args: [],
    );
  }

  /// `My RecipeBible`
  String get recipe_bible {
    return Intl.message(
      'My RecipeBible',
      name: 'recipe_bible',
      desc: '',
      args: [],
    );
  }

  /// `Choose a theme`
  String get choose_a_theme {
    return Intl.message(
      'Choose a theme',
      name: 'choose_a_theme',
      desc: '',
      args: [],
    );
  }

  /// `Swype your recipes`
  String get swype_your_recipes {
    return Intl.message(
      'Swype your recipes',
      name: 'swype_your_recipes',
      desc: '',
      args: [],
    );
  }

  /// `If you can’t decide what to cook, use random-recipe-explorer.`
  String get if_you_cant_decide_random_recipe_explorer {
    return Intl.message(
      'If you can’t decide what to cook, use random-recipe-explorer.',
      name: 'if_you_cant_decide_random_recipe_explorer',
      desc: '',
      args: [],
    );
  }

  /// `EXPORT as text or zip`
  String get export_as_text_or_zip {
    return Intl.message(
      'EXPORT as text or zip',
      name: 'export_as_text_or_zip',
      desc: '',
      args: [],
    );
  }

  /// `Export your recipes as zip file for using them on multiple devices. Alternatively you can also generate a pdf or text with all the information.`
  String get multiple_devices_use_export_as_zip_etc {
    return Intl.message(
      'Export your recipes as zip file for using them on multiple devices. Alternatively you can also generate a pdf or text with all the information.',
      name: 'multiple_devices_use_export_as_zip_etc',
      desc: '',
      args: [],
    );
  }

  /// `Add to shoppingcart`
  String get add_to_shoppingcart {
    return Intl.message(
      'Add to shoppingcart',
      name: 'add_to_shoppingcart',
      desc: '',
      args: [],
    );
  }

  /// `you can add the ingredients of your recipe to your shoppingcart for more relaxed shopping.`
  String get for_more_relaxed_shopping_add_to_shoppingcart {
    return Intl.message(
      'you can add the ingredients of your recipe to your shoppingcart for more relaxed shopping.',
      name: 'for_more_relaxed_shopping_add_to_shoppingcart',
      desc: '',
      args: [],
    );
  }

  /// `recipes`
  String get recipes {
    return Intl.message(
      'recipes',
      name: 'recipes',
      desc: '',
      args: [],
    );
  }

  /// `RATE`
  String get rate {
    return Intl.message(
      'RATE',
      name: 'rate',
      desc: '',
      args: [],
    );
  }

  /// `change ad preferences`
  String get change_ad_preferences {
    return Intl.message(
      'change ad preferences',
      name: 'change_ad_preferences',
      desc: '',
      args: [],
    );
  }

  /// `MAYBE LATER`
  String get maybe_later {
    return Intl.message(
      'MAYBE LATER',
      name: 'maybe_later',
      desc: '',
      args: [],
    );
  }

  /// `NO THANKS`
  String get no_thanks {
    return Intl.message(
      'NO THANKS',
      name: 'no_thanks',
      desc: '',
      args: [],
    );
  }

  /// `number notation`
  String get fraction_or_decimal {
    return Intl.message(
      'number notation',
      name: 'fraction_or_decimal',
      desc: '',
      args: [],
    );
  }

  /// `enabled: decimal, disabled: fraction`
  String get fraction_or_decimal_desc {
    return Intl.message(
      'enabled: decimal, disabled: fraction',
      name: 'fraction_or_decimal_desc',
      desc: '',
      args: [],
    );
  }

  /// `Nutritions`
  String get nutritions {
    return Intl.message(
      'Nutritions',
      name: 'nutritions',
      desc: '',
      args: [],
    );
  }

  /// `delete recipe`
  String get delete_recipe {
    return Intl.message(
      'delete recipe',
      name: 'delete_recipe',
      desc: '',
      args: [],
    );
  }

  /// `share recipe`
  String get share_recipe {
    return Intl.message(
      'share recipe',
      name: 'share_recipe',
      desc: '',
      args: [],
    );
  }

  /// `select recipes`
  String get select_recipes {
    return Intl.message(
      'select recipes',
      name: 'select_recipes',
      desc: '',
      args: [],
    );
  }

  /// `import recipe/s`
  String get import_recipe_s {
    return Intl.message(
      'import recipe/s',
      name: 'import_recipe_s',
      desc: '',
      args: [],
    );
  }

  /// `share/backup recipe/s`
  String get export_recipe_s {
    return Intl.message(
      'share/backup recipe/s',
      name: 'export_recipe_s',
      desc: '',
      args: [],
    );
  }

  /// `remove {newLine}section`
  String remove_section(Object newLine) {
    return Intl.message(
      'remove ${newLine}section',
      name: 'remove_section',
      desc: '',
      args: [newLine],
    );
  }

  /// `remove {newLine}ingredient`
  String remove_ingredient(Object newLine) {
    return Intl.message(
      'remove ${newLine}ingredient',
      name: 'remove_ingredient',
      desc: '',
      args: [newLine],
    );
  }

  /// `remove {newLine}step`
  String remove_step(Object newLine) {
    return Intl.message(
      'remove ${newLine}step',
      name: 'remove_step',
      desc: '',
      args: [newLine],
    );
  }

  /// `share/save as file`
  String get export_zip {
    return Intl.message(
      'share/save as file',
      name: 'export_zip',
      desc: '',
      args: [],
    );
  }

  /// `share as PDF`
  String get export_pdf {
    return Intl.message(
      'share as PDF',
      name: 'export_pdf',
      desc: '',
      args: [],
    );
  }

  /// `share in textform`
  String get export_text {
    return Intl.message(
      'share in textform',
      name: 'export_text',
      desc: '',
      args: [],
    );
  }

  /// `edit`
  String get edit {
    return Intl.message(
      'edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `shoppingcart`
  String get shoppingcart {
    return Intl.message(
      'shoppingcart',
      name: 'shoppingcart',
      desc: '',
      args: [],
    );
  }

  /// `shopping list`
  String get shopping_list {
    return Intl.message(
      'shopping list',
      name: 'shopping_list',
      desc: '',
      args: [],
    );
  }

  /// `add to shopping cart`
  String get add_to_cart {
    return Intl.message(
      'add to shopping cart',
      name: 'add_to_cart',
      desc: '',
      args: [],
    );
  }

  /// `add`
  String get add {
    return Intl.message(
      'add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `recipe name`
  String get recipe_name {
    return Intl.message(
      'recipe name',
      name: 'recipe_name',
      desc: '',
      args: [],
    );
  }

  /// `add recipe`
  String get add_recipe {
    return Intl.message(
      'add recipe',
      name: 'add_recipe',
      desc: '',
      args: [],
    );
  }

  /// `add favorites`
  String get add_favorites {
    return Intl.message(
      'add favorites',
      name: 'add_favorites',
      desc: '',
      args: [],
    );
  }

  /// `add {newLine}section`
  String add_section(Object newLine) {
    return Intl.message(
      'add ${newLine}section',
      name: 'add_section',
      desc: '',
      args: [newLine],
    );
  }

  /// `add {newLine}ingredient`
  String add_ingredient(Object newLine) {
    return Intl.message(
      'add ${newLine}ingredient',
      name: 'add_ingredient',
      desc: '',
      args: [newLine],
    );
  }

  /// `your`
  String get your {
    return Intl.message(
      'your',
      name: 'your',
      desc: '',
      args: [],
    );
  }

  /// `add {newLine}step`
  String add_step(Object newLine) {
    return Intl.message(
      'add ${newLine}step',
      name: 'add_step',
      desc: '',
      args: [newLine],
    );
  }

  /// `add nutritions`
  String get add_nutritions {
    return Intl.message(
      'add nutritions',
      name: 'add_nutritions',
      desc: '',
      args: [],
    );
  }

  /// `increase servings`
  String get increase_servings {
    return Intl.message(
      'increase servings',
      name: 'increase_servings',
      desc: '',
      args: [],
    );
  }

  /// `decrease servings`
  String get decrease_servings {
    return Intl.message(
      'decrease servings',
      name: 'decrease_servings',
      desc: '',
      args: [],
    );
  }

  /// `Directions`
  String get directions {
    return Intl.message(
      'Directions',
      name: 'directions',
      desc: '',
      args: [],
    );
  }

  /// `notes`
  String get notes {
    return Intl.message(
      'notes',
      name: 'notes',
      desc: '',
      args: [],
    );
  }

  /// `categories`
  String get categories {
    return Intl.message(
      'categories',
      name: 'categories',
      desc: '',
      args: [],
    );
  }

  /// `ingredients for`
  String get ingredients_for {
    return Intl.message(
      'ingredients for',
      name: 'ingredients_for',
      desc: '',
      args: [],
    );
  }

  /// `ingredients`
  String get ingredients {
    return Intl.message(
      'ingredients',
      name: 'ingredients',
      desc: '',
      args: [],
    );
  }

  /// `ingredient`
  String get ingredient {
    return Intl.message(
      'ingredient',
      name: 'ingredient',
      desc: '',
      args: [],
    );
  }

  /// `servings`
  String get servings {
    return Intl.message(
      'servings',
      name: 'servings',
      desc: '',
      args: [],
    );
  }

  /// `in minutes`
  String get in_minutes {
    return Intl.message(
      'in minutes',
      name: 'in_minutes',
      desc: '',
      args: [],
    );
  }

  /// `name`
  String get name {
    return Intl.message(
      'name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `fill in/ remove unit`
  String get fill_remove_unit {
    return Intl.message(
      'fill in/ remove unit',
      name: 'fill_remove_unit',
      desc: '',
      args: [],
    );
  }

  /// `prep. time`
  String get prep_time {
    return Intl.message(
      'prep. time',
      name: 'prep_time',
      desc: '',
      args: [],
    );
  }

  /// `cook. time`
  String get cook_time {
    return Intl.message(
      'cook. time',
      name: 'cook_time',
      desc: '',
      args: [],
    );
  }

  /// `import file from PC`
  String get import_pc_title_info {
    return Intl.message(
      'import file from PC',
      name: 'import_pc_title_info',
      desc: '',
      args: [],
    );
  }

  /// `1. Visit `
  String get visit {
    return Intl.message(
      '1. Visit ',
      name: 'visit',
      desc: '',
      args: [],
    );
  }

  /// `to create your recipes (at the current state pictures can only be imported in the App)\n\n 2. After generating the file with all the recipes, load it onto your mobile phone. You can also upload it to the cloud if you have access to it on your mobile phone.\n\n3. Then you have two options:\n\n3.1. Tap the generated ".json" file in your file manager and open it with My RecipeBible or\n\n3.2. Open My RecipeBible and go into the settings and tap "import recipes" and select the file to import`
  String get import_computer_info {
    return Intl.message(
      'to create your recipes (at the current state pictures can only be imported in the App)\n\n 2. After generating the file with all the recipes, load it onto your mobile phone. You can also upload it to the cloud if you have access to it on your mobile phone.\n\n3. Then you have two options:\n\n3.1. Tap the generated ".json" file in your file manager and open it with My RecipeBible or\n\n3.2. Open My RecipeBible and go into the settings and tap "import recipes" and select the file to import',
      name: 'import_computer_info',
      desc: '',
      args: [],
    );
  }

  /// `total time`
  String get total_time {
    return Intl.message(
      'total time',
      name: 'total_time',
      desc: '',
      args: [],
    );
  }

  /// `remaining time`
  String get remaining_time {
    return Intl.message(
      'remaining time',
      name: 'remaining_time',
      desc: '',
      args: [],
    );
  }

  /// `section name`
  String get section_name {
    return Intl.message(
      'section name',
      name: 'section_name',
      desc: '',
      args: [],
    );
  }

  /// `amnt`
  String get amnt {
    return Intl.message(
      'amnt',
      name: 'amnt',
      desc: '',
      args: [],
    );
  }

  /// `unit`
  String get unit {
    return Intl.message(
      'unit',
      name: 'unit',
      desc: '',
      args: [],
    );
  }

  /// `with meat`
  String get with_meat {
    return Intl.message(
      'with meat',
      name: 'with_meat',
      desc: '',
      args: [],
    );
  }

  /// `vegetarian`
  String get vegetarian {
    return Intl.message(
      'vegetarian',
      name: 'vegetarian',
      desc: '',
      args: [],
    );
  }

  /// `vegan`
  String get vegan {
    return Intl.message(
      'vegan',
      name: 'vegan',
      desc: '',
      args: [],
    );
  }

  /// `steps`
  String get steps {
    return Intl.message(
      'steps',
      name: 'steps',
      desc: '',
      args: [],
    );
  }

  /// `description`
  String get description {
    return Intl.message(
      'description',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `complexity/effort`
  String get complexity_effort {
    return Intl.message(
      'complexity/effort',
      name: 'complexity_effort',
      desc: '',
      args: [],
    );
  }

  /// `complexity`
  String get complexity {
    return Intl.message(
      'complexity',
      name: 'complexity',
      desc: '',
      args: [],
    );
  }

  /// `effort`
  String get effort {
    return Intl.message(
      'effort',
      name: 'effort',
      desc: '',
      args: [],
    );
  }

  /// `select categories:`
  String get select_subcategories {
    return Intl.message(
      'select categories:',
      name: 'select_subcategories',
      desc: '',
      args: [],
    );
  }

  /// `select a category`
  String get select_a_category {
    return Intl.message(
      'select a category',
      name: 'select_a_category',
      desc: '',
      args: [],
    );
  }

  /// `shopping`
  String get basket {
    return Intl.message(
      'shopping',
      name: 'basket',
      desc: '',
      args: [],
    );
  }

  /// `Your shoppingcart is empty`
  String get shopping_cart_is_empty {
    return Intl.message(
      'Your shoppingcart is empty',
      name: 'shopping_cart_is_empty',
      desc: '',
      args: [],
    );
  }

  /// `explore`
  String get explore {
    return Intl.message(
      'explore',
      name: 'explore',
      desc: '',
      args: [],
    );
  }

  /// `roll the dice`
  String get roll_the_dice {
    return Intl.message(
      'roll the dice',
      name: 'roll_the_dice',
      desc: '',
      args: [],
    );
  }

  /// `change theme`
  String get switch_theme {
    return Intl.message(
      'change theme',
      name: 'switch_theme',
      desc: '',
      args: [],
    );
  }

  /// `change shopping cart look`
  String get switch_shopping_cart_look {
    return Intl.message(
      'change shopping cart look',
      name: 'switch_shopping_cart_look',
      desc: '',
      args: [],
    );
  }

  /// `view intro`
  String get view_intro {
    return Intl.message(
      'view intro',
      name: 'view_intro',
      desc: '',
      args: [],
    );
  }

  /// `manage nutritions`
  String get manage_nutritions {
    return Intl.message(
      'manage nutritions',
      name: 'manage_nutritions',
      desc: '',
      args: [],
    );
  }

  /// `manage categories`
  String get manage_categories {
    return Intl.message(
      'manage categories',
      name: 'manage_categories',
      desc: '',
      args: [],
    );
  }

  /// `no category`
  String get no_category {
    return Intl.message(
      'no category',
      name: 'no_category',
      desc: '',
      args: [],
    );
  }

  /// `all categories`
  String get all_categories {
    return Intl.message(
      'all categories',
      name: 'all_categories',
      desc: '',
      args: [],
    );
  }

  /// `you have no categories`
  String get you_have_no_categories {
    return Intl.message(
      'you have no categories',
      name: 'you_have_no_categories',
      desc: '',
      args: [],
    );
  }

  /// `you have no nutritions`
  String get you_have_no_nutritions {
    return Intl.message(
      'you have no nutritions',
      name: 'you_have_no_nutritions',
      desc: '',
      args: [],
    );
  }

  /// `info`
  String get about_me {
    return Intl.message(
      'info',
      name: 'about_me',
      desc: '',
      args: [],
    );
  }

  /// `rate this app`
  String get rate_app {
    return Intl.message(
      'rate this app',
      name: 'rate_app',
      desc: '',
      args: [],
    );
  }

  /// `settings`
  String get settings {
    return Intl.message(
      'settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `cancel`
  String get cancel {
    return Intl.message(
      'cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `save`
  String get save {
    return Intl.message(
      'save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `alright`
  String get alright {
    return Intl.message(
      'alright',
      name: 'alright',
      desc: '',
      args: [],
    );
  }

  /// `favorites`
  String get favorites {
    return Intl.message(
      'favorites',
      name: 'favorites',
      desc: '',
      args: [],
    );
  }

  /// `You have no recipes under this category`
  String get no_recipes_under_this_category {
    return Intl.message(
      'You have no recipes under this category',
      name: 'no_recipes_under_this_category',
      desc: '',
      args: [],
    );
  }

  /// `You have no recipes with this tag`
  String get no_recipes_with_this_tag {
    return Intl.message(
      'You have no recipes with this tag',
      name: 'no_recipes_with_this_tag',
      desc: '',
      args: [],
    );
  }

  /// `You haven't added any favorites yet`
  String get no_added_favorites_yet {
    return Intl.message(
      'You haven\'t added any favorites yet',
      name: 'no_added_favorites_yet',
      desc: '',
      args: [],
    );
  }

  /// `recipename taken`
  String get recipename_taken {
    return Intl.message(
      'recipename taken',
      name: 'recipename_taken',
      desc: '',
      args: [],
    );
  }

  /// `change the recipename to something more detailed or maybe you just forgot, that you already saved this recipe :)`
  String get recipename_taken_description {
    return Intl.message(
      'change the recipename to something more detailed or maybe you just forgot, that you already saved this recipe :)',
      name: 'recipename_taken_description',
      desc: '',
      args: [],
    );
  }

  /// `check your ingredients input`
  String get check_ingredients_input {
    return Intl.message(
      'check your ingredients input',
      name: 'check_ingredients_input',
      desc: '',
      args: [],
    );
  }

  /// `please complete ingredient info. The format must be: \n- ingredients must have a name\n- ingredients with a unit must also have an amount`
  String get check_ingredients_input_description {
    return Intl.message(
      'please complete ingredient info. The format must be: \n- ingredients must have a name\n- ingredients with a unit must also have an amount',
      name: 'check_ingredients_input_description',
      desc: '',
      args: [],
    );
  }

  /// `check your ingredients section fields.`
  String get check_ingredient_section_fields {
    return Intl.message(
      'check your ingredients section fields.',
      name: 'check_ingredient_section_fields',
      desc: '',
      args: [],
    );
  }

  /// `if you have multiple sections, you need to provide a title for each section.`
  String get check_ingredient_section_fields_description {
    return Intl.message(
      'if you have multiple sections, you need to provide a title for each section.',
      name: 'check_ingredient_section_fields_description',
      desc: '',
      args: [],
    );
  }

  /// `Check filled in information`
  String get check_filled_in_information {
    return Intl.message(
      'Check filled in information',
      name: 'check_filled_in_information',
      desc: '',
      args: [],
    );
  }

  /// `Please check for any red marked text fields. For the recipename: it shouldn't be empty and the name must not exceed 70 characters.`
  String get check_filled_in_information_description {
    return Intl.message(
      'Please check for any red marked text fields. For the recipename: it shouldn\'t be empty and the name must not exceed 70 characters.',
      name: 'check_filled_in_information_description',
      desc: '',
      args: [],
    );
  }

  /// `nothing to search through`
  String get nothing_to_search_through {
    return Intl.message(
      'nothing to search through',
      name: 'nothing_to_search_through',
      desc: '',
      args: [],
    );
  }

  /// `almost done😊`
  String get almost_done {
    return Intl.message(
      'almost done😊',
      name: 'almost_done',
      desc: '',
      args: [],
    );
  }

  /// `exporting recipe`
  String get exporting_recipe {
    return Intl.message(
      'exporting recipe',
      name: 'exporting_recipe',
      desc: '',
      args: [],
    );
  }

  /// `out of`
  String get out_of {
    return Intl.message(
      'out of',
      name: 'out_of',
      desc: '',
      args: [],
    );
  }

  /// `no valid number`
  String get no_valid_number {
    return Intl.message(
      'no valid number',
      name: 'no_valid_number',
      desc: '',
      args: [],
    );
  }

  /// `data_required`
  String get data_required {
    return Intl.message(
      'data_required',
      name: 'data_required',
      desc: '',
      args: [],
    );
  }

  /// `not required (e.g. ingredients of sauce)`
  String get not_required_eg_ingredients_of_sauce {
    return Intl.message(
      'not required (e.g. ingredients of sauce)',
      name: 'not_required_eg_ingredients_of_sauce',
      desc: '',
      args: [],
    );
  }

  /// `you already have`
  String get you_already_have {
    return Intl.message(
      'you already have',
      name: 'you_already_have',
      desc: '',
      args: [],
    );
  }

  /// `imported`
  String get imported {
    return Intl.message(
      'imported',
      name: 'imported',
      desc: '',
      args: [],
    );
  }

  /// `no valid importfile`
  String get no_valid_import_file {
    return Intl.message(
      'no valid importfile',
      name: 'no_valid_import_file',
      desc: '',
      args: [],
    );
  }

  /// `hide`
  String get hide {
    return Intl.message(
      'hide',
      name: 'hide',
      desc: '',
      args: [],
    );
  }

  /// `delete nutrition?`
  String get delete_nutrition {
    return Intl.message(
      'delete nutrition?',
      name: 'delete_nutrition',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this nutrition:`
  String get sure_you_want_to_delete_this_nutrition {
    return Intl.message(
      'Are you sure you want to delete this nutrition:',
      name: 'sure_you_want_to_delete_this_nutrition',
      desc: '',
      args: [],
    );
  }

  /// `delete category?`
  String get delete_category {
    return Intl.message(
      'delete category?',
      name: 'delete_category',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this category:`
  String get sure_you_want_to_delete_this_category {
    return Intl.message(
      'Are you sure you want to delete this category:',
      name: 'sure_you_want_to_delete_this_category',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure that you want to delete this recipe:`
  String get sure_you_want_to_delete_this_recipe {
    return Intl.message(
      'Are you sure that you want to delete this recipe:',
      name: 'sure_you_want_to_delete_this_recipe',
      desc: '',
      args: [],
    );
  }

  /// `no`
  String get no {
    return Intl.message(
      'no',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `yes`
  String get yes {
    return Intl.message(
      'yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `verbergen`
  String get dismiss {
    return Intl.message(
      'verbergen',
      name: 'dismiss',
      desc: '',
      args: [],
    );
  }

  /// `if supported, theme will be applied, when restarting the app :)`
  String get snackbar_automatic_theme_applied {
    return Intl.message(
      'if supported, theme will be applied, when restarting the app :)',
      name: 'snackbar_automatic_theme_applied',
      desc: '',
      args: [],
    );
  }

  /// `bright theme applied`
  String get snackbar_bright_theme_applied {
    return Intl.message(
      'bright theme applied',
      name: 'snackbar_bright_theme_applied',
      desc: '',
      args: [],
    );
  }

  /// `dark theme applied`
  String get snackbar_dark_theme_applied {
    return Intl.message(
      'dark theme applied',
      name: 'snackbar_dark_theme_applied',
      desc: '',
      args: [],
    );
  }

  /// `midnight theme applied`
  String get snackbar_midnight_theme_applied {
    return Intl.message(
      'midnight theme applied',
      name: 'snackbar_midnight_theme_applied',
      desc: '',
      args: [],
    );
  }

  /// `by name`
  String get by_name {
    return Intl.message(
      'by name',
      name: 'by_name',
      desc: '',
      args: [],
    );
  }

  /// `by effort`
  String get by_effort {
    return Intl.message(
      'by effort',
      name: 'by_effort',
      desc: '',
      args: [],
    );
  }

  /// `by ingredientsamount`
  String get by_ingredientsamount {
    return Intl.message(
      'by ingredientsamount',
      name: 'by_ingredientsamount',
      desc: '',
      args: [],
    );
  }

  /// `category already exists`
  String get category_already_exists {
    return Intl.message(
      'category already exists',
      name: 'category_already_exists',
      desc: '',
      args: [],
    );
  }

  /// `category name`
  String get categoryname {
    return Intl.message(
      'category name',
      name: 'categoryname',
      desc: '',
      args: [],
    );
  }

  /// `category`
  String get category {
    return Intl.message(
      'category',
      name: 'category',
      desc: '',
      args: [],
    );
  }

  /// `advanced search`
  String get professional_search {
    return Intl.message(
      'advanced search',
      name: 'professional_search',
      desc: '',
      args: [],
    );
  }

  /// `enter some ingredients`
  String get enter_some_information {
    return Intl.message(
      'enter some ingredients',
      name: 'enter_some_information',
      desc: '',
      args: [],
    );
  }

  /// `no matching recipes`
  String get no_matching_recipes {
    return Intl.message(
      'no matching recipes',
      name: 'no_matching_recipes',
      desc: '',
      args: [],
    );
  }

  /// `matching ingredients`
  String get ingredient_matches {
    return Intl.message(
      'matching ingredients',
      name: 'ingredient_matches',
      desc: '',
      args: [],
    );
  }

  /// `delete ingredient`
  String get delete_ingredient {
    return Intl.message(
      'delete ingredient',
      name: 'delete_ingredient',
      desc: '',
      args: [],
    );
  }

  /// `manage ingredients`
  String get manage_ingredients {
    return Intl.message(
      'manage ingredients',
      name: 'manage_ingredients',
      desc: '',
      args: [],
    );
  }

  /// `ingredient already exists`
  String get ingredient_already_exists {
    return Intl.message(
      'ingredient already exists',
      name: 'ingredient_already_exists',
      desc: '',
      args: [],
    );
  }

  /// `nutrition already exists`
  String get nutrition_already_exists {
    return Intl.message(
      'nutrition already exists',
      name: 'nutrition_already_exists',
      desc: '',
      args: [],
    );
  }

  /// `nutrition`
  String get nutrition {
    return Intl.message(
      'nutrition',
      name: 'nutrition',
      desc: '',
      args: [],
    );
  }

  /// `you made it to the end`
  String get you_made_it_to_the_end {
    return Intl.message(
      'you made it to the end',
      name: 'you_made_it_to_the_end',
      desc: '',
      args: [],
    );
  }

  /// `no recipes`
  String get no_recipes {
    return Intl.message(
      'no recipes',
      name: 'no_recipes',
      desc: '',
      args: [],
    );
  }

  /// `finished`
  String get finished {
    return Intl.message(
      'finished',
      name: 'finished',
      desc: '',
      args: [],
    );
  }

  /// `importing recipe/s`
  String get importing_recipes {
    return Intl.message(
      'importing recipe/s',
      name: 'importing_recipes',
      desc: '',
      args: [],
    );
  }

  /// `select recipe/s to import`
  String get select_recipes_to_import {
    return Intl.message(
      'select recipe/s to import',
      name: 'select_recipes_to_import',
      desc: '',
      args: [],
    );
  }

  /// `ready`
  String get ready {
    return Intl.message(
      'ready',
      name: 'ready',
      desc: '',
      args: [],
    );
  }

  /// `successful`
  String get successful {
    return Intl.message(
      'successful',
      name: 'successful',
      desc: '',
      args: [],
    );
  }

  /// `duplicate`
  String get duplicate {
    return Intl.message(
      'duplicate',
      name: 'duplicate',
      desc: '',
      args: [],
    );
  }

  /// `failed`
  String get failed {
    return Intl.message(
      'failed',
      name: 'failed',
      desc: '',
      args: [],
    );
  }

  /// `summary`
  String get summary {
    return Intl.message(
      'summary',
      name: 'summary',
      desc: '',
      args: [],
    );
  }

  /// `none`
  String get none {
    return Intl.message(
      'none',
      name: 'none',
      desc: '',
      args: [],
    );
  }

  /// `saving your input`
  String get saving_your_input {
    return Intl.message(
      'saving your input',
      name: 'saving_your_input',
      desc: '',
      args: [],
    );
  }

  /// `please enter a name`
  String get please_enter_a_name {
    return Intl.message(
      'please enter a name',
      name: 'please_enter_a_name',
      desc: '',
      args: [],
    );
  }

  /// `invalid name`
  String get invalid_name {
    return Intl.message(
      'invalid name',
      name: 'invalid_name',
      desc: '',
      args: [],
    );
  }

  /// `add general info`
  String get add_general_info {
    return Intl.message(
      'add general info',
      name: 'add_general_info',
      desc: '',
      args: [],
    );
  }

  /// `add steps`
  String get add_steps {
    return Intl.message(
      'add steps',
      name: 'add_steps',
      desc: '',
      args: [],
    );
  }

  /// `Add steps description or remove image/s`
  String get too_many_images_for_the_steps {
    return Intl.message(
      'Add steps description or remove image/s',
      name: 'too_many_images_for_the_steps',
      desc: '',
      args: [],
    );
  }

  /// `you have added more images for the steps, than steps with a description. So images would get lost. Please fix the issue.`
  String get too_many_images_for_the_steps_description {
    return Intl.message(
      'you have added more images for the steps, than steps with a description. So images would get lost. Please fix the issue.',
      name: 'too_many_images_for_the_steps_description',
      desc: '',
      args: [],
    );
  }

  /// `add ingredients info`
  String get add_ingredients_info {
    return Intl.message(
      'add ingredients info',
      name: 'add_ingredients_info',
      desc: '',
      args: [],
    );
  }

  /// `category`
  String get categoy {
    return Intl.message(
      'category',
      name: 'categoy',
      desc: '',
      args: [],
    );
  }

  /// `you have no ingredients`
  String get you_have_no_ingredients {
    return Intl.message(
      'you have no ingredients',
      name: 'you_have_no_ingredients',
      desc: '',
      args: [],
    );
  }

  /// `recipe for`
  String get recipe_for {
    return Intl.message(
      'recipe for',
      name: 'recipe_for',
      desc: '',
      args: [],
    );
  }

  /// `Information`
  String get info {
    return Intl.message(
      'Information',
      name: 'info',
      desc: '',
      args: [],
    );
  }

  /// `Here you can manage the ingredients, which you are suggested when adding a recipe or searching for them. When you edit or delete them, only the suggestions are updated and not the recipes with the ingredient.`
  String get ingredient_manager_description {
    return Intl.message(
      'Here you can manage the ingredients, which you are suggested when adding a recipe or searching for them. When you edit or delete them, only the suggestions are updated and not the recipes with the ingredient.',
      name: 'ingredient_manager_description',
      desc: '',
      args: [],
    );
  }

  /// `Here you can manage your nutritions. When you edit or delete them, the recipes with the specific nutrition don't change. If you want to edit the nutrition of an existing recipe, you have to edit the recipe itself.`
  String get nutrition_manager_description {
    return Intl.message(
      'Here you can manage your nutritions. When you edit or delete them, the recipes with the specific nutrition don\'t change. If you want to edit the nutrition of an existing recipe, you have to edit the recipe itself.',
      name: 'nutrition_manager_description',
      desc: '',
      args: [],
    );
  }

  /// `no recipes fit your filter`
  String get no_recipes_fit_your_filter {
    return Intl.message(
      'no recipes fit your filter',
      name: 'no_recipes_fit_your_filter',
      desc: '',
      args: [],
    );
  }

  /// `In no event shall the author of My RecipeBible application be liable for any damages directly or indirectly caused by the application. You are acknowledging that you are 100% responsible for whatever you do with My RecipeBible.`
  String get disclaimer_description {
    return Intl.message(
      'In no event shall the author of My RecipeBible application be liable for any damages directly or indirectly caused by the application. You are acknowledging that you are 100% responsible for whatever you do with My RecipeBible.',
      name: 'disclaimer_description',
      desc: '',
      args: [],
    );
  }

  /// `share this app`
  String get share_this_app {
    return Intl.message(
      'share this app',
      name: 'share_this_app',
      desc: '',
      args: [],
    );
  }

  /// `Check out this!`
  String get share_this_app_title {
    return Intl.message(
      'Check out this!',
      name: 'share_this_app_title',
      desc: '',
      args: [],
    );
  }

  /// `recipe pinned to overview`
  String get recipe_pinned_to_overview {
    return Intl.message(
      'recipe pinned to overview',
      name: 'recipe_pinned_to_overview',
      desc: '',
      args: [],
    );
  }

  /// `field must not be empty`
  String get field_must_not_be_empty {
    return Intl.message(
      'field must not be empty',
      name: 'field_must_not_be_empty',
      desc: '',
      args: [],
    );
  }

  /// `I now manage my recipes with the App My RecipeBible {link}`
  String share_this_app_desc(Object link) {
    return Intl.message(
      'I now manage my recipes with the App My RecipeBible $link',
      name: 'share_this_app_desc',
      desc: '',
      args: [link],
    );
  }

  /// `by last modified`
  String get by_last_modified {
    return Intl.message(
      'by last modified',
      name: 'by_last_modified',
      desc: '',
      args: [],
    );
  }

  /// `import`
  String get import {
    return Intl.message(
      'import',
      name: 'import',
      desc: '',
      args: [],
    );
  }

  /// `purchase pro version`
  String get purchase_pro {
    return Intl.message(
      'purchase pro version',
      name: 'purchase_pro',
      desc: '',
      args: [],
    );
  }

  /// `watch video ad to remove banner ads`
  String get video_to_remove_ads {
    return Intl.message(
      'watch video ad to remove banner ads',
      name: 'video_to_remove_ads',
      desc: '',
      args: [],
    );
  }

  /// `by pressing "watch", you'll see an advertisement video and no more banner ads will be displayed for 30 min. You can stack this.`
  String get video_to_remove_ads_desc {
    return Intl.message(
      'by pressing "watch", you\'ll see an advertisement video and no more banner ads will be displayed for 30 min. You can stack this.',
      name: 'video_to_remove_ads_desc',
      desc: '',
      args: [],
    );
  }

  /// `watch`
  String get watch {
    return Intl.message(
      'watch',
      name: 'watch',
      desc: '',
      args: [],
    );
  }

  /// `watch video → remove ads`
  String get watch_video_remove_ads {
    return Intl.message(
      'watch video → remove ads',
      name: 'watch_video_remove_ads',
      desc: '',
      args: [],
    );
  }

  /// `ad free until`
  String get ad_free_until {
    return Intl.message(
      'ad free until',
      name: 'ad_free_until',
      desc: '',
      args: [],
    );
  }

  /// `pro version`
  String get pro_version {
    return Intl.message(
      'pro version',
      name: 'pro_version',
      desc: '',
      args: [],
    );
  }

  /// `purchase pro version in settings to get access to ingredient filter`
  String get ingredient_filter_description {
    return Intl.message(
      'purchase pro version in settings to get access to ingredient filter',
      name: 'ingredient_filter_description',
      desc: '',
      args: [],
    );
  }

  /// `pull down to refresh page and show imported recipes`
  String get pull_down_to_refresh {
    return Intl.message(
      'pull down to refresh page and show imported recipes',
      name: 'pull_down_to_refresh',
      desc: '',
      args: [],
    );
  }

  /// `remove ads\nupgrade in settings`
  String get remove_ads_upgrade_in_settings {
    return Intl.message(
      'remove ads\nupgrade in settings',
      name: 'remove_ads_upgrade_in_settings',
      desc: '',
      args: [],
    );
  }

  /// `no internet connection`
  String get no_internet_connection {
    return Intl.message(
      'no internet connection',
      name: 'no_internet_connection',
      desc: '',
      args: [],
    );
  }

  /// `could not connect to the internet and therefore not load the video.`
  String get no_internet_connection_desc {
    return Intl.message(
      'could not connect to the internet and therefore not load the video.',
      name: 'no_internet_connection_desc',
      desc: '',
      args: [],
    );
  }

  /// `failed loading ad`
  String get failed_loading_ad {
    return Intl.message(
      'failed loading ad',
      name: 'failed_loading_ad',
      desc: '',
      args: [],
    );
  }

  /// `solutions can be: better internet connection, tapping "watch" again or restarting the app`
  String get failed_loading_ad_desc {
    return Intl.message(
      'solutions can be: better internet connection, tapping "watch" again or restarting the app',
      name: 'failed_loading_ad_desc',
      desc: '',
      args: [],
    );
  }

  /// `if recipes don't show up in overview, pull down to refresh the page or go to another tab and back.`
  String get recipes_not_in_overview {
    return Intl.message(
      'if recipes don\'t show up in overview, pull down to refresh the page or go to another tab and back.',
      name: 'recipes_not_in_overview',
      desc: '',
      args: [],
    );
  }

  /// `recipes not showing up?`
  String get recipes_not_showing_up {
    return Intl.message(
      'recipes not showing up?',
      name: 'recipes_not_showing_up',
      desc: '',
      args: [],
    );
  }

  /// `if recipes are missing, scroll down to refresh.`
  String get recipes_not_showing_up_desc {
    return Intl.message(
      'if recipes are missing, scroll down to refresh.',
      name: 'recipes_not_showing_up_desc',
      desc: '',
      args: [],
    );
  }

  /// `backup/share your recipes`
  String get share_recipes_settings {
    return Intl.message(
      'backup/share your recipes',
      name: 'share_recipes_settings',
      desc: '',
      args: [],
    );
  }

  /// `on this screen, you can:\n- select the recipes you want to share to a friend as a single file\n- select the recipes you want to save to import on another device or just to make sure, they don't get lost.`
  String get share_recipes_settings_desc {
    return Intl.message(
      'on this screen, you can:\n- select the recipes you want to share to a friend as a single file\n- select the recipes you want to save to import on another device or just to make sure, they don\'t get lost.',
      name: 'share_recipes_settings_desc',
      desc: '',
      args: [],
    );
  }

  /// `here you can add a new recipe`
  String get tap_here_to_add_recipe {
    return Intl.message(
      'here you can add a new recipe',
      name: 'tap_here_to_add_recipe',
      desc: '',
      args: [],
    );
  }

  /// `here you can manage\nyour recipe categories`
  String get tap_here_to_manage_categories {
    return Intl.message(
      'here you can manage\nyour recipe categories',
      name: 'tap_here_to_manage_categories',
      desc: '',
      args: [],
    );
  }

  /// `contact me`
  String get contact_me {
    return Intl.message(
      'contact me',
      name: 'contact_me',
      desc: '',
      args: [],
    );
  }

  /// `includes ingredient filter, removal of ads and support of future development`
  String get pro_version_desc {
    return Intl.message(
      'includes ingredient filter, removal of ads and support of future development',
      name: 'pro_version_desc',
      desc: '',
      args: [],
    );
  }

  /// `buy pro version`
  String get buy_pro_version {
    return Intl.message(
      'buy pro version',
      name: 'buy_pro_version',
      desc: '',
      args: [],
    );
  }

  /// `import failed`
  String get failed_import {
    return Intl.message(
      'import failed',
      name: 'failed_import',
      desc: '',
      args: [],
    );
  }

  /// `import failed for unknown reasons. Please switch to the settings tab and import the recipes there.`
  String get failed_import_desc {
    return Intl.message(
      'import failed for unknown reasons. Please switch to the settings tab and import the recipes there.',
      name: 'failed_import_desc',
      desc: '',
      args: [],
    );
  }

  /// `need to access storage`
  String get need_to_access_storage {
    return Intl.message(
      'need to access storage',
      name: 'need_to_access_storage',
      desc: '',
      args: [],
    );
  }

  /// `Access to storage required for reading the file from an external location and import it. By pressing ok, you'll get a prompt asking you for that`
  String get need_to_access_storage_desc {
    return Intl.message(
      'Access to storage required for reading the file from an external location and import it. By pressing ok, you\'ll get a prompt asking you for that',
      name: 'need_to_access_storage_desc',
      desc: '',
      args: [],
    );
  }

  /// `select all`
  String get select_all {
    return Intl.message(
      'select all',
      name: 'select_all',
      desc: '',
      args: [],
    );
  }

  /// `manage recipe tags`
  String get manage_recipe_tags {
    return Intl.message(
      'manage recipe tags',
      name: 'manage_recipe_tags',
      desc: '',
      args: [],
    );
  }

  /// `recipe tag already exists`
  String get recipe_tag_already_exists {
    return Intl.message(
      'recipe tag already exists',
      name: 'recipe_tag_already_exists',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this recipe tag:`
  String get sure_you_want_to_delete_this_recipe_tag {
    return Intl.message(
      'Are you sure you want to delete this recipe tag:',
      name: 'sure_you_want_to_delete_this_recipe_tag',
      desc: '',
      args: [],
    );
  }

  /// `select recipe tags:`
  String get select_recipe_tags {
    return Intl.message(
      'select recipe tags:',
      name: 'select_recipe_tags',
      desc: '',
      args: [],
    );
  }

  /// `recipetag`
  String get recipe_tag {
    return Intl.message(
      'recipetag',
      name: 'recipe_tag',
      desc: '',
      args: [],
    );
  }

  /// `delete recipe tag?`
  String get delete_recipe_tag {
    return Intl.message(
      'delete recipe tag?',
      name: 'delete_recipe_tag',
      desc: '',
      args: [],
    );
  }

  /// `you have no recipe tags`
  String get you_have_no_recipe_tags {
    return Intl.message(
      'you have no recipe tags',
      name: 'you_have_no_recipe_tags',
      desc: '',
      args: [],
    );
  }

  /// `import recipes from website`
  String get import_from_website {
    return Intl.message(
      'import recipes from website',
      name: 'import_from_website',
      desc: '',
      args: [],
    );
  }

  /// `import from website`
  String get import_from_website_short {
    return Intl.message(
      'import from website',
      name: 'import_from_website_short',
      desc: '',
      args: [],
    );
  }

  /// `Failed to import recipe for an unknown reason`
  String get failed_to_import_recipe_unknown_reason {
    return Intl.message(
      'Failed to import recipe for an unknown reason',
      name: 'failed_to_import_recipe_unknown_reason',
      desc: '',
      args: [],
    );
  }

  /// `recipe with name "{name}" already exists`
  String recipe_already_exists(Object name) {
    return Intl.message(
      'recipe with name "$name" already exists',
      name: 'recipe_already_exists',
      desc: '',
      args: [name],
    );
  }

  /// `failed to connect to given url`
  String get failed_to_connect_to_url {
    return Intl.message(
      'failed to connect to given url',
      name: 'failed_to_connect_to_url',
      desc: '',
      args: [],
    );
  }

  /// `unsupported url:\ncheck the info about supported websites in the infopanel below`
  String get invalid_url {
    return Intl.message(
      'unsupported url:\ncheck the info about supported websites in the infopanel below',
      name: 'invalid_url',
      desc: '',
      args: [],
    );
  }

  /// `enter URL of website with recipe:`
  String get enter_url {
    return Intl.message(
      'enter URL of website with recipe:',
      name: 'enter_url',
      desc: '',
      args: [],
    );
  }

  /// `info about supported websites:`
  String get supported_websites {
    return Intl.message(
      'info about supported websites:',
      name: 'supported_websites',
      desc: '',
      args: [],
    );
  }

  /// `Import failed. Page seems not yet supported`
  String get failed_import_not_supported {
    return Intl.message(
      'Import failed. Page seems not yet supported',
      name: 'failed_import_not_supported',
      desc: '',
      args: [],
    );
  }

  /// `All websites are supported which contain a standardized format. Thet's why only a part of the supported websites are listed here. In practise most websites shoulb be supported.`
  String get standardized_format {
    return Intl.message(
      'All websites are supported which contain a standardized format. Thet\'s why only a part of the supported websites are listed here. In practise most websites shoulb be supported.',
      name: 'standardized_format',
      desc: '',
      args: [],
    );
  }

  /// `recipe-url`
  String get recipe_url {
    return Intl.message(
      'recipe-url',
      name: 'recipe_url',
      desc: '',
      args: [],
    );
  }

  /// `source/url`
  String get source {
    return Intl.message(
      'source/url',
      name: 'source',
      desc: '',
      args: [],
    );
  }

  /// `recipe has been edited or deleted:\ngo back to man view and view it`
  String get recipe_edited_or_deleted {
    return Intl.message(
      'recipe has been edited or deleted:\ngo back to man view and view it',
      name: 'recipe_edited_or_deleted',
      desc: '',
      args: [],
    );
  }

  /// `recipe screen`
  String get recipe_screen {
    return Intl.message(
      'recipe screen',
      name: 'recipe_screen',
      desc: '',
      args: [],
    );
  }

  /// `more coming soon...`
  String get more_coming_soon {
    return Intl.message(
      'more coming soon...',
      name: 'more_coming_soon',
      desc: '',
      args: [],
    );
  }

  /// `done`
  String get done {
    return Intl.message(
      'done',
      name: 'done',
      desc: '',
      args: [],
    );
  }

  /// `next`
  String get next {
    return Intl.message(
      'next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `back`
  String get back {
    return Intl.message(
      'back',
      name: 'back',
      desc: '',
      args: [],
    );
  }

  /// `skip`
  String get skip {
    return Intl.message(
      'skip',
      name: 'skip',
      desc: '',
      args: [],
    );
  }

  /// `maximum pin count of 3 exceeded`
  String get maximum_recipe_pin_count_exceeded {
    return Intl.message(
      'maximum pin count of 3 exceeded',
      name: 'maximum_recipe_pin_count_exceeded',
      desc: '',
      args: [],
    );
  }

  /// `information`
  String get information {
    return Intl.message(
      'information',
      name: 'information',
      desc: '',
      args: [],
    );
  }

  /// `It's recommended to sometimes save your recipes as zip, just i case that your smartphone gets lost or the app breaks for whatever reason.`
  String get info_export_description {
    return Intl.message(
      'It\'s recommended to sometimes save your recipes as zip, just i case that your smartphone gets lost or the app breaks for whatever reason.',
      name: 'info_export_description',
      desc: '',
      args: [],
    );
  }

  /// `tags`
  String get tags {
    return Intl.message(
      'tags',
      name: 'tags',
      desc: '',
      args: [],
    );
  }

  /// `shoppingcart help`
  String get shopping_cart_help {
    return Intl.message(
      'shoppingcart help',
      name: 'shopping_cart_help',
      desc: '',
      args: [],
    );
  }

  /// `To add ingredients to your shopping cart, press the + icon at the bottom right. To remove ingredients from your cart, swype them left or right. You can also delete all ingredients of one recipe by swyping the recipe in one direction.`
  String get shopping_cart_help_desc {
    return Intl.message(
      'To add ingredients to your shopping cart, press the + icon at the bottom right. To remove ingredients from your cart, swype them left or right. You can also delete all ingredients of one recipe by swyping the recipe in one direction.',
      name: 'shopping_cart_help_desc',
      desc: '',
      args: [],
    );
  }

  /// `enable complex animations`
  String get complex_animations {
    return Intl.message(
      'enable complex animations',
      name: 'complex_animations',
      desc: '',
      args: [],
    );
  }

  /// `keep screen on`
  String get keep_screen_on {
    return Intl.message(
      'keep screen on',
      name: 'keep_screen_on',
      desc: '',
      args: [],
    );
  }

  /// `only on recipe screen`
  String get only_recipe_screen {
    return Intl.message(
      'only on recipe screen',
      name: 'only_recipe_screen',
      desc: '',
      args: [],
    );
  }

  /// `The changes you make, when adding a recipe are saved, when you go back and forth. So don't worry if you mistyped an information on one screen.`
  String get general_info_changes_will_be_saved {
    return Intl.message(
      'The changes you make, when adding a recipe are saved, when you go back and forth. So don\'t worry if you mistyped an information on one screen.',
      name: 'general_info_changes_will_be_saved',
      desc: '',
      args: [],
    );
  }

  /// `Tap on a step to select it so that you know, what you have to do next`
  String get steps_intro {
    return Intl.message(
      'Tap on a step to select it so that you know, what you have to do next',
      name: 'steps_intro',
      desc: '',
      args: [],
    );
  }

  /// `general infos`
  String get general_infos {
    return Intl.message(
      'general infos',
      name: 'general_infos',
      desc: '',
      args: [],
    );
  }

  /// `preperation time`
  String get preperation_time {
    return Intl.message(
      'preperation time',
      name: 'preperation_time',
      desc: '',
      args: [],
    );
  }

  /// `for "{number}" persons`
  String for_persons(Object number) {
    return Intl.message(
      'for "$number" persons',
      name: 'for_persons',
      desc: '',
      args: [number],
    );
  }

  /// `for`
  String get for_word {
    return Intl.message(
      'for',
      name: 'for_word',
      desc: '',
      args: [],
    );
  }

  /// `persons`
  String get persons {
    return Intl.message(
      'persons',
      name: 'persons',
      desc: '',
      args: [],
    );
  }

  /// `print recipe`
  String get print_recipe {
    return Intl.message(
      'print recipe',
      name: 'print_recipe',
      desc: '',
      args: [],
    );
  }

  /// `supported formats:\n- .zip (file of this app)\n- .mcp`
  String get import_recipe_description {
    return Intl.message(
      'supported formats:\n- .zip (file of this app)\n- .mcp',
      name: 'import_recipe_description',
      desc: '',
      args: [],
    );
  }

  /// `invalid file`
  String get invalid_file {
    return Intl.message(
      'invalid file',
      name: 'invalid_file',
      desc: '',
      args: [],
    );
  }

  /// `the file is not supported {fileName}.`
  String file_not_supported(Object fileName) {
    return Intl.message(
      'the file is not supported $fileName.',
      name: 'file_not_supported',
      desc: '',
      args: [fileName],
    );
  }

  /// `invalid datatype`
  String get invalid_datatype {
    return Intl.message(
      'invalid datatype',
      name: 'invalid_datatype',
      desc: '',
      args: [],
    );
  }

  /// `the datatype of the selected file "{datatype}" is not supported\nsupported formats: ".zip", ".mcb"`
  String datatype_not_supported(Object datatype) {
    return Intl.message(
      'the datatype of the selected file "$datatype" is not supported\nsupported formats: ".zip", ".mcb"',
      name: 'datatype_not_supported',
      desc: '',
      args: [datatype],
    );
  }

  /// `Start Recipes`
  String get first_start_recipes {
    return Intl.message(
      'Start Recipes',
      name: 'first_start_recipes',
      desc: '',
      args: [],
    );
  }

  /// `A few example recipes in german are already in this app.\nOf course you can delete them.`
  String get first_start_recipes_desc {
    return Intl.message(
      'A few example recipes in german are already in this app.\nOf course you can delete them.',
      name: 'first_start_recipes_desc',
      desc: '',
      args: [],
    );
  }

  /// `To import recipes faster from the internet, use the share functionality of your preferred browser and select this app, to instantly import it without having to copy the link.`
  String get website_import_info {
    return Intl.message(
      'To import recipes faster from the internet, use the share functionality of your preferred browser and select this app, to instantly import it without having to copy the link.',
      name: 'website_import_info',
      desc: '',
      args: [],
    );
  }

  /// `show overview`
  String get show_overview {
    return Intl.message(
      'show overview',
      name: 'show_overview',
      desc: '',
      args: [],
    );
  }

  /// `How do I create a recipe on PC and import it in the App?`
  String get recipe_import_pc_title {
    return Intl.message(
      'How do I create a recipe on PC and import it in the App?',
      name: 'recipe_import_pc_title',
      desc: '',
      args: [],
    );
  }

  /// `Rate this app`
  String get rate_this_app {
    return Intl.message(
      'Rate this app',
      name: 'rate_this_app',
      desc: '',
      args: [],
    );
  }

  /// `If you like this app, please take a little bit of your time to review it!\nIt really helps us and it shouldn't take you more than one minute.`
  String get rate_this_app_desc {
    return Intl.message(
      'If you like this app, please take a little bit of your time to review it!\nIt really helps us and it shouldn\'t take you more than one minute.',
      name: 'rate_this_app_desc',
      desc: '',
      args: [],
    );
  }

  /// `and many more!`
  String get and_many_more {
    return Intl.message(
      'and many more!',
      name: 'and_many_more',
      desc: '',
      args: [],
    );
  }

  /// `Do you really want to remove this step with its description?`
  String get remove_step_desc {
    return Intl.message(
      'Do you really want to remove this step with its description?',
      name: 'remove_step_desc',
      desc: '',
      args: [],
    );
  }

  /// `amount`
  String get amount {
    return Intl.message(
      'amount',
      name: 'amount',
      desc: '',
      args: [],
    );
  }

  /// `Fix the issues with the red marked text fields`
  String get check_red_fields_desc {
    return Intl.message(
      'Fix the issues with the red marked text fields',
      name: 'check_red_fields_desc',
      desc: '',
      args: [],
    );
  }

  /// `Delete recipe data?`
  String get clean_recipe_info {
    return Intl.message(
      'Delete recipe data?',
      name: 'clean_recipe_info',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure, that you want to delete the prefilled recipe data?`
  String get clean_recipe_info_desc {
    return Intl.message(
      'Are you sure, that you want to delete the prefilled recipe data?',
      name: 'clean_recipe_info_desc',
      desc: '',
      args: [],
    );
  }

  /// `tap here to imoprt\n a recipe online`
  String get tap_here_to_import_recipe_online {
    return Intl.message(
      'tap here to imoprt\n a recipe online',
      name: 'tap_here_to_import_recipe_online',
      desc: '',
      args: [],
    );
  }

  /// `Delete section?`
  String get delete_section {
    return Intl.message(
      'Delete section?',
      name: 'delete_section',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure, that you want to delete this section with it's containing ingredients`
  String get delete_section_desc {
    return Intl.message(
      'Are you sure, that you want to delete this section with it\'s containing ingredients',
      name: 'delete_section_desc',
      desc: '',
      args: [],
    );
  }

  /// `add title`
  String get add_title {
    return Intl.message(
      'add title',
      name: 'add_title',
      desc: '',
      args: [],
    );
  }

  /// `To add another section, you need to give the first one a title like e.g. (ingredients for) sauce.`
  String get add_title_desc {
    return Intl.message(
      'To add another section, you need to give the first one a title like e.g. (ingredients for) sauce.',
      name: 'add_title_desc',
      desc: '',
      args: [],
    );
  }

  /// `Loading data...`
  String get loading_data {
    return Intl.message(
      'Loading data...',
      name: 'loading_data',
      desc: '',
      args: [],
    );
  }

  /// `undo`
  String get undo {
    return Intl.message(
      'undo',
      name: 'undo',
      desc: '',
      args: [],
    );
  }

  /// `You added {recipeName} to your the recipe planner for the following date:\n {year}-{month}-{day}`
  String undo_added_to_planner_description(
      Object recipeName, Object year, Object month, Object day) {
    return Intl.message(
      'You added $recipeName to your the recipe planner for the following date:\n $year-$month-$day',
      name: 'undo_added_to_planner_description',
      desc: '',
      args: [recipeName, year, month, day],
    );
  }

  /// `mealplaner`
  String get recipe_planer {
    return Intl.message(
      'mealplaner',
      name: 'recipe_planer',
      desc: '',
      args: [],
    );
  }

  /// `you can only add recipes that you have saved in the app.`
  String get no_recipe_with_this_name {
    return Intl.message(
      'you can only add recipes that you have saved in the app.',
      name: 'no_recipe_with_this_name',
      desc: '',
      args: [],
    );
  }

  /// `select a date`
  String get select_a_date_first {
    return Intl.message(
      'select a date',
      name: 'select_a_date_first',
      desc: '',
      args: [],
    );
  }

  /// `select date`
  String get add_date {
    return Intl.message(
      'select date',
      name: 'add_date',
      desc: '',
      args: [],
    );
  }

  /// `add recipe`
  String get add_to_calendar {
    return Intl.message(
      'add recipe',
      name: 'add_to_calendar',
      desc: '',
      args: [],
    );
  }

  /// `Jan.`
  String get jan {
    return Intl.message(
      'Jan.',
      name: 'jan',
      desc: '',
      args: [],
    );
  }

  /// `Feb.`
  String get feb {
    return Intl.message(
      'Feb.',
      name: 'feb',
      desc: '',
      args: [],
    );
  }

  /// `Mar.`
  String get mar {
    return Intl.message(
      'Mar.',
      name: 'mar',
      desc: '',
      args: [],
    );
  }

  /// `Apr.`
  String get apr {
    return Intl.message(
      'Apr.',
      name: 'apr',
      desc: '',
      args: [],
    );
  }

  /// `May`
  String get may {
    return Intl.message(
      'May',
      name: 'may',
      desc: '',
      args: [],
    );
  }

  /// `Jun.`
  String get jun {
    return Intl.message(
      'Jun.',
      name: 'jun',
      desc: '',
      args: [],
    );
  }

  /// `Jul.`
  String get jul {
    return Intl.message(
      'Jul.',
      name: 'jul',
      desc: '',
      args: [],
    );
  }

  /// `Aug.`
  String get aug {
    return Intl.message(
      'Aug.',
      name: 'aug',
      desc: '',
      args: [],
    );
  }

  /// `Sep.`
  String get sep {
    return Intl.message(
      'Sep.',
      name: 'sep',
      desc: '',
      args: [],
    );
  }

  /// `Oct.`
  String get oct {
    return Intl.message(
      'Oct.',
      name: 'oct',
      desc: '',
      args: [],
    );
  }

  /// `Nov.`
  String get nov {
    return Intl.message(
      'Nov.',
      name: 'nov',
      desc: '',
      args: [],
    );
  }

  /// `Dec.`
  String get dec {
    return Intl.message(
      'Dec.',
      name: 'dec',
      desc: '',
      args: [],
    );
  }

  /// `January`
  String get january {
    return Intl.message(
      'January',
      name: 'january',
      desc: '',
      args: [],
    );
  }

  /// `February`
  String get february {
    return Intl.message(
      'February',
      name: 'february',
      desc: '',
      args: [],
    );
  }

  /// `March`
  String get march {
    return Intl.message(
      'March',
      name: 'march',
      desc: '',
      args: [],
    );
  }

  /// `April`
  String get april {
    return Intl.message(
      'April',
      name: 'april',
      desc: '',
      args: [],
    );
  }

  /// `May`
  String get may_full {
    return Intl.message(
      'May',
      name: 'may_full',
      desc: '',
      args: [],
    );
  }

  /// `June`
  String get june {
    return Intl.message(
      'June',
      name: 'june',
      desc: '',
      args: [],
    );
  }

  /// `July`
  String get july {
    return Intl.message(
      'July',
      name: 'july',
      desc: '',
      args: [],
    );
  }

  /// `August`
  String get august {
    return Intl.message(
      'August',
      name: 'august',
      desc: '',
      args: [],
    );
  }

  /// `September`
  String get september {
    return Intl.message(
      'September',
      name: 'september',
      desc: '',
      args: [],
    );
  }

  /// `October`
  String get october {
    return Intl.message(
      'October',
      name: 'october',
      desc: '',
      args: [],
    );
  }

  /// `November`
  String get november {
    return Intl.message(
      'November',
      name: 'november',
      desc: '',
      args: [],
    );
  }

  /// `December`
  String get december {
    return Intl.message(
      'December',
      name: 'december',
      desc: '',
      args: [],
    );
  }

  /// `Monday`
  String get monday {
    return Intl.message(
      'Monday',
      name: 'monday',
      desc: '',
      args: [],
    );
  }

  /// `Tuesday`
  String get tuesday {
    return Intl.message(
      'Tuesday',
      name: 'tuesday',
      desc: '',
      args: [],
    );
  }

  /// `Wednesday`
  String get wednesday {
    return Intl.message(
      'Wednesday',
      name: 'wednesday',
      desc: '',
      args: [],
    );
  }

  /// `Thursday`
  String get thursday {
    return Intl.message(
      'Thursday',
      name: 'thursday',
      desc: '',
      args: [],
    );
  }

  /// `Friday`
  String get friday {
    return Intl.message(
      'Friday',
      name: 'friday',
      desc: '',
      args: [],
    );
  }

  /// `Saturday`
  String get saturday {
    return Intl.message(
      'Saturday',
      name: 'saturday',
      desc: '',
      args: [],
    );
  }

  /// `Sunday`
  String get sunday {
    return Intl.message(
      'Sunday',
      name: 'sunday',
      desc: '',
      args: [],
    );
  }

  /// `If you added multiple steps, you can move them by tapping and holding one step. This feature is only available, if no images for the steps are added. The same with removing steps from the middle.`
  String get steps_info_desc {
    return Intl.message(
      'If you added multiple steps, you can move them by tapping and holding one step. This feature is only available, if no images for the steps are added. The same with removing steps from the middle.',
      name: 'steps_info_desc',
      desc: '',
      args: [],
    );
  }

  /// `sync recipes with Google Drive`
  String get sync_recipes_drive {
    return Intl.message(
      'sync recipes with Google Drive',
      name: 'sync_recipes_drive',
      desc: '',
      args: [],
    );
  }

  /// `syncing recipes with Google Drive`
  String get syncing_recipes_drive {
    return Intl.message(
      'syncing recipes with Google Drive',
      name: 'syncing_recipes_drive',
      desc: '',
      args: [],
    );
  }

  /// `importing recipe: {recipeName}`
  String importing_recipe_drive(Object recipeName) {
    return Intl.message(
      'importing recipe: $recipeName',
      name: 'importing_recipe_drive',
      desc: '',
      args: [recipeName],
    );
  }

  /// `uploading recipe: {recipeName}`
  String uploading_recipe_drive(Object recipeName) {
    return Intl.message(
      'uploading recipe: $recipeName',
      name: 'uploading_recipe_drive',
      desc: '',
      args: [recipeName],
    );
  }

  /// `deleting recipe in cloud: {recipeName}`
  String deleting_recipe_drive(Object recipeName) {
    return Intl.message(
      'deleting recipe in cloud: $recipeName',
      name: 'deleting_recipe_drive',
      desc: '',
      args: [recipeName],
    );
  }

  /// `deleting local recipe: {recipeName}`
  String deleting_recipe_local(Object recipeName) {
    return Intl.message(
      'deleting local recipe: $recipeName',
      name: 'deleting_recipe_local',
      desc: '',
      args: [recipeName],
    );
  }

  /// `successfully synced recipes with Google Drive`
  String get successfully_synced_drive {
    return Intl.message(
      'successfully synced recipes with Google Drive',
      name: 'successfully_synced_drive',
      desc: '',
      args: [],
    );
  }

  /// `Cancelling Sync...`
  String get cancelling_sync {
    return Intl.message(
      'Cancelling Sync...',
      name: 'cancelling_sync',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'de', countryCode: 'DE'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
