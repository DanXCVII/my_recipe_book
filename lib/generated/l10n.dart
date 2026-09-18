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
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
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
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `EN`
  String get two_char_locale {
    return Intl.message('EN', name: 'two_char_locale', desc: '', args: []);
  }

  /// `en_US`
  String get locale_full {
    return Intl.message('en_US', name: 'locale_full', desc: '', args: []);
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

  /// `Continue`
  String get onboarding_continue {
    return Intl.message(
      'Continue',
      name: 'onboarding_continue',
      desc: '',
      args: [],
    );
  }

  /// `Open my cookbook`
  String get onboarding_open_cookbook {
    return Intl.message(
      'Open my cookbook',
      name: 'onboarding_open_cookbook',
      desc: '',
      args: [],
    );
  }

  /// `Step {current} of {total}`
  String onboarding_progress(int current, int total) {
    return Intl.message(
      'Step $current of $total',
      name: 'onboarding_progress',
      desc: '',
      args: [current, total],
    );
  }

  /// `Choose a recipe that fits your energy.`
  String get onboarding_effort_title {
    return Intl.message(
      'Choose a recipe that fits your energy.',
      name: 'onboarding_effort_title',
      desc: '',
      args: [],
    );
  }

  /// `Give recipes an effort score from 1 to 10, then sort your collection when choosing what to cook.`
  String get onboarding_effort_description {
    return Intl.message(
      'Give recipes an effort score from 1 to 10, then sort your collection when choosing what to cook.',
      name: 'onboarding_effort_description',
      desc: '',
      args: [],
    );
  }

  /// `Your effort scale`
  String get onboarding_effort_scale {
    return Intl.message(
      'Your effort scale',
      name: 'onboarding_effort_scale',
      desc: '',
      args: [],
    );
  }

  /// `LEVEL {effort} / 10`
  String onboarding_effort_level(int effort) {
    return Intl.message(
      'LEVEL $effort / 10',
      name: 'onboarding_effort_level',
      desc: '',
      args: [effort],
    );
  }

  /// `Choose effort level {effort}`
  String onboarding_effort_choose(int effort) {
    return Intl.message(
      'Choose effort level $effort',
      name: 'onboarding_effort_choose',
      desc: '',
      args: [effort],
    );
  }

  /// `Gentle`
  String get onboarding_effort_gentle {
    return Intl.message(
      'Gentle',
      name: 'onboarding_effort_gentle',
      desc: '',
      args: [],
    );
  }

  /// `Balanced`
  String get onboarding_effort_balanced {
    return Intl.message(
      'Balanced',
      name: 'onboarding_effort_balanced',
      desc: '',
      args: [],
    );
  }

  /// `Ambitious`
  String get onboarding_effort_ambitious {
    return Intl.message(
      'Ambitious',
      name: 'onboarding_effort_ambitious',
      desc: '',
      args: [],
    );
  }

  /// `1 Gentle`
  String get onboarding_effort_one {
    return Intl.message(
      '1 Gentle',
      name: 'onboarding_effort_one',
      desc: '',
      args: [],
    );
  }

  /// `5 Balanced`
  String get onboarding_effort_five {
    return Intl.message(
      '5 Balanced',
      name: 'onboarding_effort_five',
      desc: '',
      args: [],
    );
  }

  /// `10 Ambitious`
  String get onboarding_effort_ten {
    return Intl.message(
      '10 Ambitious',
      name: 'onboarding_effort_ten',
      desc: '',
      args: [],
    );
  }

  /// `Crisp garden salad`
  String get onboarding_effort_easy_recipe {
    return Intl.message(
      'Crisp garden salad',
      name: 'onboarding_effort_easy_recipe',
      desc: '',
      args: [],
    );
  }

  /// `A lighter recipe for a busy evening.`
  String get onboarding_effort_easy_detail {
    return Intl.message(
      'A lighter recipe for a busy evening.',
      name: 'onboarding_effort_easy_detail',
      desc: '',
      args: [],
    );
  }

  /// `Slow-roasted vegetable pasta`
  String get onboarding_effort_project_recipe {
    return Intl.message(
      'Slow-roasted vegetable pasta',
      name: 'onboarding_effort_project_recipe',
      desc: '',
      args: [],
    );
  }

  /// `More time and attention for an unhurried day.`
  String get onboarding_effort_project_detail {
    return Intl.message(
      'More time and attention for an unhurried day.',
      name: 'onboarding_effort_project_detail',
      desc: '',
      args: [],
    );
  }

  /// `Effort {effort}/10`
  String onboarding_effort_badge(int effort) {
    return Intl.message(
      'Effort $effort/10',
      name: 'onboarding_effort_badge',
      desc: '',
      args: [effort],
    );
  }

  /// `Never lose your place at the stove.`
  String get onboarding_cook_title {
    return Intl.message(
      'Never lose your place at the stove.',
      name: 'onboarding_cook_title',
      desc: '',
      args: [],
    );
  }

  /// `Work through one recipe step at a time, see its assigned ingredients, and keep a timer within reach.`
  String get onboarding_cook_description {
    return Intl.message(
      'Work through one recipe step at a time, see its assigned ingredients, and keep a timer within reach.',
      name: 'onboarding_cook_description',
      desc: '',
      args: [],
    );
  }

  /// `ROASTED TOMATO PASTA`
  String get onboarding_cook_sample_recipe {
    return Intl.message(
      'ROASTED TOMATO PASTA',
      name: 'onboarding_cook_sample_recipe',
      desc: '',
      args: [],
    );
  }

  /// `3 of 7`
  String get onboarding_cook_step_count {
    return Intl.message(
      '3 of 7',
      name: 'onboarding_cook_step_count',
      desc: '',
      args: [],
    );
  }

  /// `Deglaze and reduce`
  String get onboarding_cook_sample_step {
    return Intl.message(
      'Deglaze and reduce',
      name: 'onboarding_cook_sample_step',
      desc: '',
      args: [],
    );
  }

  /// `Add the wine, scrape the browned fond from the pan, and simmer until reduced by half.`
  String get onboarding_cook_sample_instruction {
    return Intl.message(
      'Add the wine, scrape the browned fond from the pan, and simmer until reduced by half.',
      name: 'onboarding_cook_sample_instruction',
      desc: '',
      args: [],
    );
  }

  /// `1 cup dry red wine`
  String get onboarding_cook_sample_ingredient {
    return Intl.message(
      '1 cup dry red wine',
      name: 'onboarding_cook_sample_ingredient',
      desc: '',
      args: [],
    );
  }

  /// `Glanceable steps`
  String get onboarding_cook_glanceable_title {
    return Intl.message(
      'Glanceable steps',
      name: 'onboarding_cook_glanceable_title',
      desc: '',
      args: [],
    );
  }

  /// `One clear instruction at a time.`
  String get onboarding_cook_glanceable_description {
    return Intl.message(
      'One clear instruction at a time.',
      name: 'onboarding_cook_glanceable_description',
      desc: '',
      args: [],
    );
  }

  /// `Keep the screen awake`
  String get onboarding_cook_awake_title {
    return Intl.message(
      'Keep the screen awake',
      name: 'onboarding_cook_awake_title',
      desc: '',
      args: [],
    );
  }

  /// `Enable it for the current cooking session.`
  String get onboarding_cook_awake_description {
    return Intl.message(
      'Enable it for the current cooking session.',
      name: 'onboarding_cook_awake_description',
      desc: '',
      args: [],
    );
  }

  /// `Cook with what you have. Shop for what you need.`
  String get onboarding_pantry_title {
    return Intl.message(
      'Cook with what you have. Shop for what you need.',
      name: 'onboarding_pantry_title',
      desc: '',
      args: [],
    );
  }

  /// `Pro ingredient search matches your kitchen against recipes saved on this device. Any recipe can add ingredients to a checkable shopping list.`
  String get onboarding_pantry_description {
    return Intl.message(
      'Pro ingredient search matches your kitchen against recipes saved on this device. Any recipe can add ingredients to a checkable shopping list.',
      name: 'onboarding_pantry_description',
      desc: '',
      args: [],
    );
  }

  /// `Ingredient search`
  String get onboarding_pantry_search_title {
    return Intl.message(
      'Ingredient search',
      name: 'onboarding_pantry_search_title',
      desc: '',
      args: [],
    );
  }

  /// `PRO FEATURE`
  String get onboarding_pantry_pro {
    return Intl.message(
      'PRO FEATURE',
      name: 'onboarding_pantry_pro',
      desc: '',
      args: [],
    );
  }

  /// `Spinach`
  String get onboarding_pantry_spinach {
    return Intl.message(
      'Spinach',
      name: 'onboarding_pantry_spinach',
      desc: '',
      args: [],
    );
  }

  /// `Pasta`
  String get onboarding_pantry_pasta {
    return Intl.message(
      'Pasta',
      name: 'onboarding_pantry_pasta',
      desc: '',
      args: [],
    );
  }

  /// `Tomatoes`
  String get onboarding_pantry_tomatoes {
    return Intl.message(
      'Tomatoes',
      name: 'onboarding_pantry_tomatoes',
      desc: '',
      args: [],
    );
  }

  /// `{matched}/{total} INGREDIENTS MATCH`
  String onboarding_pantry_match(int matched, int total) {
    return Intl.message(
      '$matched/$total INGREDIENTS MATCH',
      name: 'onboarding_pantry_match',
      desc: '',
      args: [matched, total],
    );
  }

  /// `Creamy spinach pasta`
  String get onboarding_pantry_sample_recipe {
    return Intl.message(
      'Creamy spinach pasta',
      name: 'onboarding_pantry_sample_recipe',
      desc: '',
      args: [],
    );
  }

  /// `25 min · Effort 4/10`
  String get onboarding_pantry_sample_detail {
    return Intl.message(
      '25 min · Effort 4/10',
      name: 'onboarding_pantry_sample_detail',
      desc: '',
      args: [],
    );
  }

  /// `Recipe shopping list`
  String get onboarding_shopping_title {
    return Intl.message(
      'Recipe shopping list',
      name: 'onboarding_shopping_title',
      desc: '',
      args: [],
    );
  }

  /// `4 servings`
  String get onboarding_shopping_servings {
    return Intl.message(
      '4 servings',
      name: 'onboarding_shopping_servings',
      desc: '',
      args: [],
    );
  }

  /// `Parmesan`
  String get onboarding_shopping_parmesan {
    return Intl.message(
      'Parmesan',
      name: 'onboarding_shopping_parmesan',
      desc: '',
      args: [],
    );
  }

  /// `Garlic`
  String get onboarding_shopping_garlic {
    return Intl.message(
      'Garlic',
      name: 'onboarding_shopping_garlic',
      desc: '',
      args: [],
    );
  }

  /// `Cooking cream`
  String get onboarding_shopping_cream {
    return Intl.message(
      'Cooking cream',
      name: 'onboarding_shopping_cream',
      desc: '',
      args: [],
    );
  }

  /// `Swipe until dinner feels obvious.`
  String get onboarding_explore_title {
    return Intl.message(
      'Swipe until dinner feels obvious.',
      name: 'onboarding_explore_title',
      desc: '',
      args: [],
    );
  }

  /// `Browse your own recipes as a deck: left to pass, up to save, and right to cook.`
  String get onboarding_explore_description {
    return Intl.message(
      'Browse your own recipes as a deck: left to pass, up to save, and right to cook.',
      name: 'onboarding_explore_description',
      desc: '',
      args: [],
    );
  }

  /// `Card {current} of {total}`
  String onboarding_explore_card(int current, int total) {
    return Intl.message(
      'Card $current of $total',
      name: 'onboarding_explore_card',
      desc: '',
      args: [current, total],
    );
  }

  /// `Roasted vegetable pasta`
  String get onboarding_explore_recipe_one {
    return Intl.message(
      'Roasted vegetable pasta',
      name: 'onboarding_explore_recipe_one',
      desc: '',
      args: [],
    );
  }

  /// `A colorful pantry dinner with herbs and tomatoes.`
  String get onboarding_explore_recipe_one_detail {
    return Intl.message(
      'A colorful pantry dinner with herbs and tomatoes.',
      name: 'onboarding_explore_recipe_one_detail',
      desc: '',
      args: [],
    );
  }

  /// `Summer garden salad`
  String get onboarding_explore_recipe_two {
    return Intl.message(
      'Summer garden salad',
      name: 'onboarding_explore_recipe_two',
      desc: '',
      args: [],
    );
  }

  /// `Fresh fruit, greens, avocado, and toasted nuts.`
  String get onboarding_explore_recipe_two_detail {
    return Intl.message(
      'Fresh fruit, greens, avocado, and toasted nuts.',
      name: 'onboarding_explore_recipe_two_detail',
      desc: '',
      args: [],
    );
  }

  /// `Tomato basil spaghetti`
  String get onboarding_explore_recipe_three {
    return Intl.message(
      'Tomato basil spaghetti',
      name: 'onboarding_explore_recipe_three',
      desc: '',
      args: [],
    );
  }

  /// `A familiar weeknight favorite from your own collection.`
  String get onboarding_explore_recipe_three_detail {
    return Intl.message(
      'A familiar weeknight favorite from your own collection.',
      name: 'onboarding_explore_recipe_three_detail',
      desc: '',
      args: [],
    );
  }

  /// `Recipes without steps open in recipe detail instead.`
  String get onboarding_explore_fallback {
    return Intl.message(
      'Recipes without steps open in recipe detail instead.',
      name: 'onboarding_explore_fallback',
      desc: '',
      args: [],
    );
  }

  /// `Recipes`
  String get recipes {
    return Intl.message('Recipes', name: 'recipes', desc: '', args: []);
  }

  /// `RATE`
  String get rate {
    return Intl.message('RATE', name: 'rate', desc: '', args: []);
  }

  /// `Change ad preferences`
  String get change_ad_preferences {
    return Intl.message(
      'Change ad preferences',
      name: 'change_ad_preferences',
      desc: '',
      args: [],
    );
  }

  /// `MAYBE LATER`
  String get maybe_later {
    return Intl.message('MAYBE LATER', name: 'maybe_later', desc: '', args: []);
  }

  /// `NO THANKS`
  String get no_thanks {
    return Intl.message('NO THANKS', name: 'no_thanks', desc: '', args: []);
  }

  /// `Number notation`
  String get fraction_or_decimal {
    return Intl.message(
      'Number notation',
      name: 'fraction_or_decimal',
      desc: '',
      args: [],
    );
  }

  /// `Enabled: decimal, disabled: fraction`
  String get fraction_or_decimal_desc {
    return Intl.message(
      'Enabled: decimal, disabled: fraction',
      name: 'fraction_or_decimal_desc',
      desc: '',
      args: [],
    );
  }

  /// `Nutritions`
  String get nutritions {
    return Intl.message('Nutritions', name: 'nutritions', desc: '', args: []);
  }

  /// `Delete recipe`
  String get delete_recipe {
    return Intl.message(
      'Delete recipe',
      name: 'delete_recipe',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Share recipe`
  String get share_recipe {
    return Intl.message(
      'Share recipe',
      name: 'share_recipe',
      desc: '',
      args: [],
    );
  }

  /// `Select recipes`
  String get select_recipes {
    return Intl.message(
      'Select recipes',
      name: 'select_recipes',
      desc: '',
      args: [],
    );
  }

  /// `Import recipe/s`
  String get import_recipe_s {
    return Intl.message(
      'Import recipe/s',
      name: 'import_recipe_s',
      desc: '',
      args: [],
    );
  }

  /// `Share/backup recipe/s`
  String get export_recipe_s {
    return Intl.message(
      'Share/backup recipe/s',
      name: 'export_recipe_s',
      desc: '',
      args: [],
    );
  }

  /// `Remove {newLine}section`
  String remove_section(Object newLine) {
    return Intl.message(
      'Remove ${newLine}section',
      name: 'remove_section',
      desc: '',
      args: [newLine],
    );
  }

  /// `Remove {newLine}ingredient`
  String remove_ingredient(Object newLine) {
    return Intl.message(
      'Remove ${newLine}ingredient',
      name: 'remove_ingredient',
      desc: '',
      args: [newLine],
    );
  }

  /// `Remove {newLine}step`
  String remove_step(Object newLine) {
    return Intl.message(
      'Remove ${newLine}step',
      name: 'remove_step',
      desc: '',
      args: [newLine],
    );
  }

  /// `Share/save as file`
  String get export_zip {
    return Intl.message(
      'Share/save as file',
      name: 'export_zip',
      desc: '',
      args: [],
    );
  }

  /// `Share as PDF`
  String get export_pdf {
    return Intl.message('Share as PDF', name: 'export_pdf', desc: '', args: []);
  }

  /// `Share in textform`
  String get export_text {
    return Intl.message(
      'Share in textform',
      name: 'export_text',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message('Edit', name: 'edit', desc: '', args: []);
  }

  /// `Shoppingcart`
  String get shoppingcart {
    return Intl.message(
      'Shoppingcart',
      name: 'shoppingcart',
      desc: '',
      args: [],
    );
  }

  /// `Shopping list`
  String get shopping_list {
    return Intl.message(
      'Shopping list',
      name: 'shopping_list',
      desc: '',
      args: [],
    );
  }

  /// `Add to shopping cart`
  String get add_to_cart {
    return Intl.message(
      'Add to shopping cart',
      name: 'add_to_cart',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message('Add', name: 'add', desc: '', args: []);
  }

  /// `Recipe name`
  String get recipe_name {
    return Intl.message('Recipe name', name: 'recipe_name', desc: '', args: []);
  }

  /// `Add recipe`
  String get add_recipe {
    return Intl.message('Add recipe', name: 'add_recipe', desc: '', args: []);
  }

  /// `Create manually`
  String get create_manually {
    return Intl.message(
      'Create manually',
      name: 'create_manually',
      desc: '',
      args: [],
    );
  }

  /// `Recipe actions`
  String get recipe_actions {
    return Intl.message(
      'Recipe actions',
      name: 'recipe_actions',
      desc: '',
      args: [],
    );
  }

  /// `Expanded`
  String get recipe_actions_expanded {
    return Intl.message(
      'Expanded',
      name: 'recipe_actions_expanded',
      desc: '',
      args: [],
    );
  }

  /// `Collapsed`
  String get recipe_actions_collapsed {
    return Intl.message(
      'Collapsed',
      name: 'recipe_actions_collapsed',
      desc: '',
      args: [],
    );
  }

  /// `Shows ways to add a recipe`
  String get recipe_actions_hint {
    return Intl.message(
      'Shows ways to add a recipe',
      name: 'recipe_actions_hint',
      desc: '',
      args: [],
    );
  }

  /// `Close recipe actions`
  String get close_recipe_actions {
    return Intl.message(
      'Close recipe actions',
      name: 'close_recipe_actions',
      desc: '',
      args: [],
    );
  }

  /// `Add bookmarks`
  String get add_favorites {
    return Intl.message(
      'Add bookmarks',
      name: 'add_favorites',
      desc: '',
      args: [],
    );
  }

  /// `Add {newLine}section`
  String add_section(Object newLine) {
    return Intl.message(
      'Add ${newLine}section',
      name: 'add_section',
      desc: '',
      args: [newLine],
    );
  }

  /// `Add {newLine}ingredient`
  String add_ingredient(Object newLine) {
    return Intl.message(
      'Add ${newLine}ingredient',
      name: 'add_ingredient',
      desc: '',
      args: [newLine],
    );
  }

  /// `Your`
  String get your {
    return Intl.message('Your', name: 'your', desc: '', args: []);
  }

  /// `Add {newLine}step`
  String add_step(Object newLine) {
    return Intl.message(
      'Add ${newLine}step',
      name: 'add_step',
      desc: '',
      args: [newLine],
    );
  }

  /// `Add nutritions`
  String get add_nutritions {
    return Intl.message(
      'Add nutritions',
      name: 'add_nutritions',
      desc: '',
      args: [],
    );
  }

  /// `Increase servings`
  String get increase_servings {
    return Intl.message(
      'Increase servings',
      name: 'increase_servings',
      desc: '',
      args: [],
    );
  }

  /// `Decrease servings`
  String get decrease_servings {
    return Intl.message(
      'Decrease servings',
      name: 'decrease_servings',
      desc: '',
      args: [],
    );
  }

  /// `Directions`
  String get directions {
    return Intl.message('Directions', name: 'directions', desc: '', args: []);
  }

  /// `Notes`
  String get notes {
    return Intl.message('Notes', name: 'notes', desc: '', args: []);
  }

  /// `Categories`
  String get categories {
    return Intl.message('Categories', name: 'categories', desc: '', args: []);
  }

  /// `Ingredients for`
  String get ingredients_for {
    return Intl.message(
      'Ingredients for',
      name: 'ingredients_for',
      desc: '',
      args: [],
    );
  }

  /// `Ingredients`
  String get ingredients {
    return Intl.message('Ingredients', name: 'ingredients', desc: '', args: []);
  }

  /// `Ingredient`
  String get ingredient {
    return Intl.message('Ingredient', name: 'ingredient', desc: '', args: []);
  }

  /// `Servings`
  String get servings {
    return Intl.message('Servings', name: 'servings', desc: '', args: []);
  }

  /// `In minutes`
  String get in_minutes {
    return Intl.message('In minutes', name: 'in_minutes', desc: '', args: []);
  }

  /// `Name`
  String get name {
    return Intl.message('Name', name: 'name', desc: '', args: []);
  }

  /// `Fill in/ remove unit`
  String get fill_remove_unit {
    return Intl.message(
      'Fill in/ remove unit',
      name: 'fill_remove_unit',
      desc: '',
      args: [],
    );
  }

  /// `Prep. time`
  String get prep_time {
    return Intl.message('Prep. time', name: 'prep_time', desc: '', args: []);
  }

  /// `Cook. time`
  String get cook_time {
    return Intl.message('Cook. time', name: 'cook_time', desc: '', args: []);
  }

  /// `Import file from PC`
  String get import_pc_title_info {
    return Intl.message(
      'Import file from PC',
      name: 'import_pc_title_info',
      desc: '',
      args: [],
    );
  }

  /// `1. Visit `
  String get visit {
    return Intl.message('1. Visit ', name: 'visit', desc: '', args: []);
  }

  /// `To create your recipes (at the current state pictures can only be imported in the App)\n\n 2. After generating the file with all the recipes, load it onto your mobile phone. You can also upload it to the cloud if you have access to it on your mobile phone.\n\n3. Then you have two options:\n\n3.1. Tap the generated ".json" file in your file manager and open it with My RecipeBible or\n\n3.2. Open My RecipeBible and go into the settings and tap "import recipes" and select the file to import`
  String get import_computer_info {
    return Intl.message(
      'To create your recipes (at the current state pictures can only be imported in the App)\n\n 2. After generating the file with all the recipes, load it onto your mobile phone. You can also upload it to the cloud if you have access to it on your mobile phone.\n\n3. Then you have two options:\n\n3.1. Tap the generated ".json" file in your file manager and open it with My RecipeBible or\n\n3.2. Open My RecipeBible and go into the settings and tap "import recipes" and select the file to import',
      name: 'import_computer_info',
      desc: '',
      args: [],
    );
  }

  /// `Total time`
  String get total_time {
    return Intl.message('Total time', name: 'total_time', desc: '', args: []);
  }

  /// `Remaining time`
  String get remaining_time {
    return Intl.message(
      'Remaining time',
      name: 'remaining_time',
      desc: '',
      args: [],
    );
  }

  /// `Section name`
  String get section_name {
    return Intl.message(
      'Section name',
      name: 'section_name',
      desc: '',
      args: [],
    );
  }

  /// `Amnt`
  String get amnt {
    return Intl.message('Amnt', name: 'amnt', desc: '', args: []);
  }

  /// `Unit`
  String get unit {
    return Intl.message('Unit', name: 'unit', desc: '', args: []);
  }

  /// `With meat`
  String get with_meat {
    return Intl.message('With meat', name: 'with_meat', desc: '', args: []);
  }

  /// `Vegetarian`
  String get vegetarian {
    return Intl.message('Vegetarian', name: 'vegetarian', desc: '', args: []);
  }

  /// `Vegan`
  String get vegan {
    return Intl.message('Vegan', name: 'vegan', desc: '', args: []);
  }

  /// `Steps`
  String get steps {
    return Intl.message('Steps', name: 'steps', desc: '', args: []);
  }

  /// `Description`
  String get description {
    return Intl.message('Description', name: 'description', desc: '', args: []);
  }

  /// `Complexity/effort`
  String get complexity_effort {
    return Intl.message(
      'Complexity/effort',
      name: 'complexity_effort',
      desc: '',
      args: [],
    );
  }

  /// `Complexity`
  String get complexity {
    return Intl.message('Complexity', name: 'complexity', desc: '', args: []);
  }

  /// `Effort`
  String get effort {
    return Intl.message('Effort', name: 'effort', desc: '', args: []);
  }

  /// `Select categories:`
  String get select_subcategories {
    return Intl.message(
      'Select categories:',
      name: 'select_subcategories',
      desc: '',
      args: [],
    );
  }

  /// `Select a category`
  String get select_a_category {
    return Intl.message(
      'Select a category',
      name: 'select_a_category',
      desc: '',
      args: [],
    );
  }

  /// `Shopping`
  String get basket {
    return Intl.message('Shopping', name: 'basket', desc: '', args: []);
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

  /// `Explore`
  String get explore {
    return Intl.message('Explore', name: 'explore', desc: '', args: []);
  }

  /// `Roll the dice`
  String get roll_the_dice {
    return Intl.message(
      'Roll the dice',
      name: 'roll_the_dice',
      desc: '',
      args: [],
    );
  }

  /// `Change theme`
  String get switch_theme {
    return Intl.message(
      'Change theme',
      name: 'switch_theme',
      desc: '',
      args: [],
    );
  }

  /// `Change shopping cart look`
  String get switch_shopping_cart_look {
    return Intl.message(
      'Change shopping cart look',
      name: 'switch_shopping_cart_look',
      desc: '',
      args: [],
    );
  }

  /// `View intro`
  String get view_intro {
    return Intl.message('View intro', name: 'view_intro', desc: '', args: []);
  }

  /// `Manage nutritions`
  String get manage_nutritions {
    return Intl.message(
      'Manage nutritions',
      name: 'manage_nutritions',
      desc: '',
      args: [],
    );
  }

  /// `Manage categories`
  String get manage_categories {
    return Intl.message(
      'Manage categories',
      name: 'manage_categories',
      desc: '',
      args: [],
    );
  }

  /// `Set the order categories use across your cookbook. Drag the handle to reorganize them.`
  String get catalog_categories_description {
    return Intl.message(
      'Set the order categories use across your cookbook. Drag the handle to reorganize them.',
      name: 'catalog_categories_description',
      desc: '',
      args: [],
    );
  }

  /// `Add category`
  String get catalog_add_category {
    return Intl.message(
      'Add category',
      name: 'catalog_add_category',
      desc: '',
      args: [],
    );
  }

  /// `Edit category`
  String get catalog_edit_category {
    return Intl.message(
      'Edit category',
      name: 'catalog_edit_category',
      desc: '',
      args: [],
    );
  }

  /// `No categories yet`
  String get catalog_categories_empty_title {
    return Intl.message(
      'No categories yet',
      name: 'catalog_categories_empty_title',
      desc: '',
      args: [],
    );
  }

  /// `Create a category to group recipes by meal, occasion, cuisine, or any system that fits your cookbook.`
  String get catalog_categories_empty_description {
    return Intl.message(
      'Create a category to group recipes by meal, occasion, cuisine, or any system that fits your cookbook.',
      name: 'catalog_categories_empty_description',
      desc: '',
      args: [],
    );
  }

  /// `Order {position}`
  String catalog_category_order(int position) {
    return Intl.message(
      'Order $position',
      name: 'catalog_category_order',
      desc: '',
      args: [position],
    );
  }

  /// `Reorder {name}`
  String catalog_reorder_category(String name) {
    return Intl.message(
      'Reorder $name',
      name: 'catalog_reorder_category',
      desc: '',
      args: [name],
    );
  }

  /// `More actions for {name}`
  String catalog_more_actions(String name) {
    return Intl.message(
      'More actions for $name',
      name: 'catalog_more_actions',
      desc: '',
      args: [name],
    );
  }

  /// `Delete “{name}”?`
  String catalog_delete_category_title(String name) {
    return Intl.message(
      'Delete “$name”?',
      name: 'catalog_delete_category_title',
      desc: '',
      args: [name],
    );
  }

  /// `Recipes will stay in your cookbook. This category will be removed from every recipe that uses it.`
  String get catalog_delete_category_description {
    return Intl.message(
      'Recipes will stay in your cookbook. This category will be removed from every recipe that uses it.',
      name: 'catalog_delete_category_description',
      desc: '',
      args: [],
    );
  }

  /// `No category`
  String get no_category {
    return Intl.message('No category', name: 'no_category', desc: '', args: []);
  }

  /// `All categories`
  String get all_categories {
    return Intl.message(
      'All categories',
      name: 'all_categories',
      desc: '',
      args: [],
    );
  }

  /// `You have no categories`
  String get you_have_no_categories {
    return Intl.message(
      'You have no categories',
      name: 'you_have_no_categories',
      desc: '',
      args: [],
    );
  }

  /// `You have no nutritions`
  String get you_have_no_nutritions {
    return Intl.message(
      'You have no nutritions',
      name: 'you_have_no_nutritions',
      desc: '',
      args: [],
    );
  }

  /// `Info`
  String get about_me {
    return Intl.message('Info', name: 'about_me', desc: '', args: []);
  }

  /// `Rate this app`
  String get rate_app {
    return Intl.message('Rate this app', name: 'rate_app', desc: '', args: []);
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Alright`
  String get alright {
    return Intl.message('Alright', name: 'alright', desc: '', args: []);
  }

  /// `Bookmarks`
  String get favorites {
    return Intl.message('Bookmarks', name: 'favorites', desc: '', args: []);
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

  /// `You haven't added any bookmarks yet`
  String get no_added_favorites_yet {
    return Intl.message(
      'You haven\'t added any bookmarks yet',
      name: 'no_added_favorites_yet',
      desc: '',
      args: [],
    );
  }

  /// `Recipename taken`
  String get recipename_taken {
    return Intl.message(
      'Recipename taken',
      name: 'recipename_taken',
      desc: '',
      args: [],
    );
  }

  /// `Change the recipename to something more detailed or maybe you just forgot, that you already saved this recipe :)`
  String get recipename_taken_description {
    return Intl.message(
      'Change the recipename to something more detailed or maybe you just forgot, that you already saved this recipe :)',
      name: 'recipename_taken_description',
      desc: '',
      args: [],
    );
  }

  /// `Check your ingredients input`
  String get check_ingredients_input {
    return Intl.message(
      'Check your ingredients input',
      name: 'check_ingredients_input',
      desc: '',
      args: [],
    );
  }

  /// `Please complete ingredient info. The format must be: \n- ingredients must have a name\n- ingredients with a unit must also have an amount`
  String get check_ingredients_input_description {
    return Intl.message(
      'Please complete ingredient info. The format must be: \n- ingredients must have a name\n- ingredients with a unit must also have an amount',
      name: 'check_ingredients_input_description',
      desc: '',
      args: [],
    );
  }

  /// `Check your ingredients section fields.`
  String get check_ingredient_section_fields {
    return Intl.message(
      'Check your ingredients section fields.',
      name: 'check_ingredient_section_fields',
      desc: '',
      args: [],
    );
  }

  /// `If you have multiple sections, you need to provide a title for each section.`
  String get check_ingredient_section_fields_description {
    return Intl.message(
      'If you have multiple sections, you need to provide a title for each section.',
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

  /// `Nothing to search through`
  String get nothing_to_search_through {
    return Intl.message(
      'Nothing to search through',
      name: 'nothing_to_search_through',
      desc: '',
      args: [],
    );
  }

  /// `Almost done😊`
  String get almost_done {
    return Intl.message(
      'Almost done😊',
      name: 'almost_done',
      desc: '',
      args: [],
    );
  }

  /// `Exporting recipe`
  String get exporting_recipe {
    return Intl.message(
      'Exporting recipe',
      name: 'exporting_recipe',
      desc: '',
      args: [],
    );
  }

  /// `out of`
  String get out_of {
    return Intl.message('out of', name: 'out_of', desc: '', args: []);
  }

  /// `No valid number`
  String get no_valid_number {
    return Intl.message(
      'No valid number',
      name: 'no_valid_number',
      desc: '',
      args: [],
    );
  }

  /// `Data_required`
  String get data_required {
    return Intl.message(
      'Data_required',
      name: 'data_required',
      desc: '',
      args: [],
    );
  }

  /// `Not required (e.g. ingredients of sauce)`
  String get not_required_eg_ingredients_of_sauce {
    return Intl.message(
      'Not required (e.g. ingredients of sauce)',
      name: 'not_required_eg_ingredients_of_sauce',
      desc: '',
      args: [],
    );
  }

  /// `You already have`
  String get you_already_have {
    return Intl.message(
      'You already have',
      name: 'you_already_have',
      desc: '',
      args: [],
    );
  }

  /// `Imported`
  String get imported {
    return Intl.message('Imported', name: 'imported', desc: '', args: []);
  }

  /// `No valid importfile`
  String get no_valid_import_file {
    return Intl.message(
      'No valid importfile',
      name: 'no_valid_import_file',
      desc: '',
      args: [],
    );
  }

  /// `Hide`
  String get hide {
    return Intl.message('Hide', name: 'hide', desc: '', args: []);
  }

  /// `Delete nutrition?`
  String get delete_nutrition {
    return Intl.message(
      'Delete nutrition?',
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

  /// `Delete category?`
  String get delete_category {
    return Intl.message(
      'Delete category?',
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

  /// `No`
  String get no {
    return Intl.message('No', name: 'no', desc: '', args: []);
  }

  /// `Yes`
  String get yes {
    return Intl.message('Yes', name: 'yes', desc: '', args: []);
  }

  /// `Verbergen`
  String get dismiss {
    return Intl.message('Verbergen', name: 'dismiss', desc: '', args: []);
  }

  /// `If supported, theme will be applied, when restarting the app :)`
  String get snackbar_automatic_theme_applied {
    return Intl.message(
      'If supported, theme will be applied, when restarting the app :)',
      name: 'snackbar_automatic_theme_applied',
      desc: '',
      args: [],
    );
  }

  /// `Bright theme applied`
  String get snackbar_bright_theme_applied {
    return Intl.message(
      'Bright theme applied',
      name: 'snackbar_bright_theme_applied',
      desc: '',
      args: [],
    );
  }

  /// `Dark theme applied`
  String get snackbar_dark_theme_applied {
    return Intl.message(
      'Dark theme applied',
      name: 'snackbar_dark_theme_applied',
      desc: '',
      args: [],
    );
  }

  /// `Midnight theme applied`
  String get snackbar_midnight_theme_applied {
    return Intl.message(
      'Midnight theme applied',
      name: 'snackbar_midnight_theme_applied',
      desc: '',
      args: [],
    );
  }

  /// `By name`
  String get by_name {
    return Intl.message('By name', name: 'by_name', desc: '', args: []);
  }

  /// `By effort`
  String get by_effort {
    return Intl.message('By effort', name: 'by_effort', desc: '', args: []);
  }

  /// `By ingredient count`
  String get by_ingredientsamount {
    return Intl.message(
      'By ingredient count',
      name: 'by_ingredientsamount',
      desc: '',
      args: [],
    );
  }

  /// `Category already exists`
  String get category_already_exists {
    return Intl.message(
      'Category already exists',
      name: 'category_already_exists',
      desc: '',
      args: [],
    );
  }

  /// `Category name`
  String get categoryname {
    return Intl.message(
      'Category name',
      name: 'categoryname',
      desc: '',
      args: [],
    );
  }

  /// `Category`
  String get category {
    return Intl.message('Category', name: 'category', desc: '', args: []);
  }

  /// `Advanced search`
  String get professional_search {
    return Intl.message(
      'Advanced search',
      name: 'professional_search',
      desc: '',
      args: [],
    );
  }

  /// `Enter some ingredients`
  String get enter_some_information {
    return Intl.message(
      'Enter some ingredients',
      name: 'enter_some_information',
      desc: '',
      args: [],
    );
  }

  /// `No matching recipes`
  String get no_matching_recipes {
    return Intl.message(
      'No matching recipes',
      name: 'no_matching_recipes',
      desc: '',
      args: [],
    );
  }

  /// `Matching ingredients`
  String get ingredient_matches {
    return Intl.message(
      'Matching ingredients',
      name: 'ingredient_matches',
      desc: '',
      args: [],
    );
  }

  /// `Delete ingredient`
  String get delete_ingredient {
    return Intl.message(
      'Delete ingredient',
      name: 'delete_ingredient',
      desc: '',
      args: [],
    );
  }

  /// `Manage ingredients`
  String get manage_ingredients {
    return Intl.message(
      'Manage ingredients',
      name: 'manage_ingredients',
      desc: '',
      args: [],
    );
  }

  /// `Ingredient already exists`
  String get ingredient_already_exists {
    return Intl.message(
      'Ingredient already exists',
      name: 'ingredient_already_exists',
      desc: '',
      args: [],
    );
  }

  /// `Nutrition already exists`
  String get nutrition_already_exists {
    return Intl.message(
      'Nutrition already exists',
      name: 'nutrition_already_exists',
      desc: '',
      args: [],
    );
  }

  /// `Nutrition`
  String get nutrition {
    return Intl.message('Nutrition', name: 'nutrition', desc: '', args: []);
  }

  /// `You made it to the end`
  String get you_made_it_to_the_end {
    return Intl.message(
      'You made it to the end',
      name: 'you_made_it_to_the_end',
      desc: '',
      args: [],
    );
  }

  /// `No recipes`
  String get no_recipes {
    return Intl.message('No recipes', name: 'no_recipes', desc: '', args: []);
  }

  /// `Finished`
  String get finished {
    return Intl.message('Finished', name: 'finished', desc: '', args: []);
  }

  /// `Importing recipe/s`
  String get importing_recipes {
    return Intl.message(
      'Importing recipe/s',
      name: 'importing_recipes',
      desc: '',
      args: [],
    );
  }

  /// `Select recipe/s to import`
  String get select_recipes_to_import {
    return Intl.message(
      'Select recipe/s to import',
      name: 'select_recipes_to_import',
      desc: '',
      args: [],
    );
  }

  /// `Ready`
  String get ready {
    return Intl.message('Ready', name: 'ready', desc: '', args: []);
  }

  /// `Successful`
  String get successful {
    return Intl.message('Successful', name: 'successful', desc: '', args: []);
  }

  /// `Duplicate`
  String get duplicate {
    return Intl.message('Duplicate', name: 'duplicate', desc: '', args: []);
  }

  /// `Failed`
  String get failed {
    return Intl.message('Failed', name: 'failed', desc: '', args: []);
  }

  /// `Summary`
  String get summary {
    return Intl.message('Summary', name: 'summary', desc: '', args: []);
  }

  /// `None`
  String get none {
    return Intl.message('None', name: 'none', desc: '', args: []);
  }

  /// `Saving your input`
  String get saving_your_input {
    return Intl.message(
      'Saving your input',
      name: 'saving_your_input',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a name`
  String get please_enter_a_name {
    return Intl.message(
      'Please enter a name',
      name: 'please_enter_a_name',
      desc: '',
      args: [],
    );
  }

  /// `Invalid name`
  String get invalid_name {
    return Intl.message(
      'Invalid name',
      name: 'invalid_name',
      desc: '',
      args: [],
    );
  }

  /// `Add general info`
  String get add_general_info {
    return Intl.message(
      'Add general info',
      name: 'add_general_info',
      desc: '',
      args: [],
    );
  }

  /// `Add steps`
  String get add_steps {
    return Intl.message('Add steps', name: 'add_steps', desc: '', args: []);
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

  /// `You have added more images for the steps, than steps with a description. So images would get lost. Please fix the issue.`
  String get too_many_images_for_the_steps_description {
    return Intl.message(
      'You have added more images for the steps, than steps with a description. So images would get lost. Please fix the issue.',
      name: 'too_many_images_for_the_steps_description',
      desc: '',
      args: [],
    );
  }

  /// `Add ingredients info`
  String get add_ingredients_info {
    return Intl.message(
      'Add ingredients info',
      name: 'add_ingredients_info',
      desc: '',
      args: [],
    );
  }

  /// `Category`
  String get categoy {
    return Intl.message('Category', name: 'categoy', desc: '', args: []);
  }

  /// `You have no ingredients`
  String get you_have_no_ingredients {
    return Intl.message(
      'You have no ingredients',
      name: 'you_have_no_ingredients',
      desc: '',
      args: [],
    );
  }

  /// `Recipe for`
  String get recipe_for {
    return Intl.message('Recipe for', name: 'recipe_for', desc: '', args: []);
  }

  /// `Information`
  String get info {
    return Intl.message('Information', name: 'info', desc: '', args: []);
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

  /// `No recipes fit your filter`
  String get no_recipes_fit_your_filter {
    return Intl.message(
      'No recipes fit your filter',
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

  /// `Share this app`
  String get share_this_app {
    return Intl.message(
      'Share this app',
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

  /// `Recipe pinned to overview`
  String get recipe_pinned_to_overview {
    return Intl.message(
      'Recipe pinned to overview',
      name: 'recipe_pinned_to_overview',
      desc: '',
      args: [],
    );
  }

  /// `Field must not be empty`
  String get field_must_not_be_empty {
    return Intl.message(
      'Field must not be empty',
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

  /// `By last modified`
  String get by_last_modified {
    return Intl.message(
      'By last modified',
      name: 'by_last_modified',
      desc: '',
      args: [],
    );
  }

  /// `Import`
  String get import {
    return Intl.message('Import', name: 'import', desc: '', args: []);
  }

  /// `Purchase pro version`
  String get purchase_pro {
    return Intl.message(
      'Purchase pro version',
      name: 'purchase_pro',
      desc: '',
      args: [],
    );
  }

  /// `Watch video ad to remove banner ads`
  String get video_to_remove_ads {
    return Intl.message(
      'Watch video ad to remove banner ads',
      name: 'video_to_remove_ads',
      desc: '',
      args: [],
    );
  }

  /// `By pressing "watch", you'll see an advertisement video and no more banner ads will be displayed for 30 min. You can stack this.`
  String get video_to_remove_ads_desc {
    return Intl.message(
      'By pressing "watch", you\'ll see an advertisement video and no more banner ads will be displayed for 30 min. You can stack this.',
      name: 'video_to_remove_ads_desc',
      desc: '',
      args: [],
    );
  }

  /// `Watch`
  String get watch {
    return Intl.message('Watch', name: 'watch', desc: '', args: []);
  }

  /// `Watch video → remove ads`
  String get watch_video_remove_ads {
    return Intl.message(
      'Watch video → remove ads',
      name: 'watch_video_remove_ads',
      desc: '',
      args: [],
    );
  }

  /// `Ad free until`
  String get ad_free_until {
    return Intl.message(
      'Ad free until',
      name: 'ad_free_until',
      desc: '',
      args: [],
    );
  }

  /// `Pro version`
  String get pro_version {
    return Intl.message('Pro version', name: 'pro_version', desc: '', args: []);
  }

  /// `Purchase pro version in settings to get access to ingredient filter`
  String get ingredient_filter_description {
    return Intl.message(
      'Purchase pro version in settings to get access to ingredient filter',
      name: 'ingredient_filter_description',
      desc: '',
      args: [],
    );
  }

  /// `Pull down to refresh page and show imported recipes`
  String get pull_down_to_refresh {
    return Intl.message(
      'Pull down to refresh page and show imported recipes',
      name: 'pull_down_to_refresh',
      desc: '',
      args: [],
    );
  }

  /// `Remove ads\nupgrade in settings`
  String get remove_ads_upgrade_in_settings {
    return Intl.message(
      'Remove ads\nupgrade in settings',
      name: 'remove_ads_upgrade_in_settings',
      desc: '',
      args: [],
    );
  }

  /// `No internet connection`
  String get no_internet_connection {
    return Intl.message(
      'No internet connection',
      name: 'no_internet_connection',
      desc: '',
      args: [],
    );
  }

  /// `Could not connect to the internet and therefore not load the video.`
  String get no_internet_connection_desc {
    return Intl.message(
      'Could not connect to the internet and therefore not load the video.',
      name: 'no_internet_connection_desc',
      desc: '',
      args: [],
    );
  }

  /// `Failed loading ad`
  String get failed_loading_ad {
    return Intl.message(
      'Failed loading ad',
      name: 'failed_loading_ad',
      desc: '',
      args: [],
    );
  }

  /// `Solutions can be: better internet connection, tapping "watch" again or restarting the app`
  String get failed_loading_ad_desc {
    return Intl.message(
      'Solutions can be: better internet connection, tapping "watch" again or restarting the app',
      name: 'failed_loading_ad_desc',
      desc: '',
      args: [],
    );
  }

  /// `If recipes don't show up in overview, pull down to refresh the page or go to another tab and back.`
  String get recipes_not_in_overview {
    return Intl.message(
      'If recipes don\'t show up in overview, pull down to refresh the page or go to another tab and back.',
      name: 'recipes_not_in_overview',
      desc: '',
      args: [],
    );
  }

  /// `Recipes not showing up?`
  String get recipes_not_showing_up {
    return Intl.message(
      'Recipes not showing up?',
      name: 'recipes_not_showing_up',
      desc: '',
      args: [],
    );
  }

  /// `If recipes are missing, scroll down to refresh.`
  String get recipes_not_showing_up_desc {
    return Intl.message(
      'If recipes are missing, scroll down to refresh.',
      name: 'recipes_not_showing_up_desc',
      desc: '',
      args: [],
    );
  }

  /// `Backup/share your recipes`
  String get share_recipes_settings {
    return Intl.message(
      'Backup/share your recipes',
      name: 'share_recipes_settings',
      desc: '',
      args: [],
    );
  }

  /// `On this screen, you can:\n- select the recipes you want to share to a friend as a single file\n- select the recipes you want to save to import on another device or just to make sure, they don't get lost.`
  String get share_recipes_settings_desc {
    return Intl.message(
      'On this screen, you can:\n- select the recipes you want to share to a friend as a single file\n- select the recipes you want to save to import on another device or just to make sure, they don\'t get lost.',
      name: 'share_recipes_settings_desc',
      desc: '',
      args: [],
    );
  }

  /// `Contact me`
  String get contact_me {
    return Intl.message('Contact me', name: 'contact_me', desc: '', args: []);
  }

  /// `Includes ingredient filter, removal of ads and support of future development`
  String get pro_version_desc {
    return Intl.message(
      'Includes ingredient filter, removal of ads and support of future development',
      name: 'pro_version_desc',
      desc: '',
      args: [],
    );
  }

  /// `Buy pro version`
  String get buy_pro_version {
    return Intl.message(
      'Buy pro version',
      name: 'buy_pro_version',
      desc: '',
      args: [],
    );
  }

  /// `Import failed`
  String get failed_import {
    return Intl.message(
      'Import failed',
      name: 'failed_import',
      desc: '',
      args: [],
    );
  }

  /// `Import failed for unknown reasons. Please switch to the settings tab and import the recipes there.`
  String get failed_import_desc {
    return Intl.message(
      'Import failed for unknown reasons. Please switch to the settings tab and import the recipes there.',
      name: 'failed_import_desc',
      desc: '',
      args: [],
    );
  }

  /// `Need to access storage`
  String get need_to_access_storage {
    return Intl.message(
      'Need to access storage',
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

  /// `Select all`
  String get select_all {
    return Intl.message('Select all', name: 'select_all', desc: '', args: []);
  }

  /// `Manage recipe tags`
  String get manage_recipe_tags {
    return Intl.message(
      'Manage recipe tags',
      name: 'manage_recipe_tags',
      desc: '',
      args: [],
    );
  }

  /// `Use color-coded tags to make recipes easier to spot, group, and filter.`
  String get catalog_tags_description {
    return Intl.message(
      'Use color-coded tags to make recipes easier to spot, group, and filter.',
      name: 'catalog_tags_description',
      desc: '',
      args: [],
    );
  }

  /// `Add tag`
  String get catalog_add_tag {
    return Intl.message('Add tag', name: 'catalog_add_tag', desc: '', args: []);
  }

  /// `Edit tag`
  String get catalog_edit_tag {
    return Intl.message(
      'Edit tag',
      name: 'catalog_edit_tag',
      desc: '',
      args: [],
    );
  }

  /// `No recipe tags yet`
  String get catalog_tags_empty_title {
    return Intl.message(
      'No recipe tags yet',
      name: 'catalog_tags_empty_title',
      desc: '',
      args: [],
    );
  }

  /// `Create a color-coded tag for themes such as quick, seasonal, family favorite, or meal prep.`
  String get catalog_tags_empty_description {
    return Intl.message(
      'Create a color-coded tag for themes such as quick, seasonal, family favorite, or meal prep.',
      name: 'catalog_tags_empty_description',
      desc: '',
      args: [],
    );
  }

  /// `Color-coded recipe tag`
  String get catalog_tag_row_description {
    return Intl.message(
      'Color-coded recipe tag',
      name: 'catalog_tag_row_description',
      desc: '',
      args: [],
    );
  }

  /// `Choose a tag color`
  String get catalog_choose_tag_color {
    return Intl.message(
      'Choose a tag color',
      name: 'catalog_choose_tag_color',
      desc: '',
      args: [],
    );
  }

  /// `More colors`
  String get catalog_custom_tag_color {
    return Intl.message(
      'More colors',
      name: 'catalog_custom_tag_color',
      desc: '',
      args: [],
    );
  }

  /// `Tag preview`
  String get catalog_tag_preview {
    return Intl.message(
      'Tag preview',
      name: 'catalog_tag_preview',
      desc: '',
      args: [],
    );
  }

  /// `{name}, {hex}`
  String catalog_color_swatch(String name, String hex) {
    return Intl.message(
      '$name, $hex',
      name: 'catalog_color_swatch',
      desc: '',
      args: [name, hex],
    );
  }

  /// `Paprika`
  String get catalog_color_paprika {
    return Intl.message(
      'Paprika',
      name: 'catalog_color_paprika',
      desc: '',
      args: [],
    );
  }

  /// `Red`
  String get catalog_color_red {
    return Intl.message('Red', name: 'catalog_color_red', desc: '', args: []);
  }

  /// `Pink`
  String get catalog_color_pink {
    return Intl.message('Pink', name: 'catalog_color_pink', desc: '', args: []);
  }

  /// `Purple`
  String get catalog_color_purple {
    return Intl.message(
      'Purple',
      name: 'catalog_color_purple',
      desc: '',
      args: [],
    );
  }

  /// `Indigo`
  String get catalog_color_indigo {
    return Intl.message(
      'Indigo',
      name: 'catalog_color_indigo',
      desc: '',
      args: [],
    );
  }

  /// `Blue`
  String get catalog_color_blue {
    return Intl.message('Blue', name: 'catalog_color_blue', desc: '', args: []);
  }

  /// `Teal`
  String get catalog_color_teal {
    return Intl.message('Teal', name: 'catalog_color_teal', desc: '', args: []);
  }

  /// `Green`
  String get catalog_color_green {
    return Intl.message(
      'Green',
      name: 'catalog_color_green',
      desc: '',
      args: [],
    );
  }

  /// `Olive green`
  String get catalog_color_olive {
    return Intl.message(
      'Olive green',
      name: 'catalog_color_olive',
      desc: '',
      args: [],
    );
  }

  /// `Orange`
  String get catalog_color_orange {
    return Intl.message(
      'Orange',
      name: 'catalog_color_orange',
      desc: '',
      args: [],
    );
  }

  /// `Brown`
  String get catalog_color_brown {
    return Intl.message(
      'Brown',
      name: 'catalog_color_brown',
      desc: '',
      args: [],
    );
  }

  /// `Blue grey`
  String get catalog_color_blue_grey {
    return Intl.message(
      'Blue grey',
      name: 'catalog_color_blue_grey',
      desc: '',
      args: [],
    );
  }

  /// `Delete “{name}”?`
  String catalog_delete_tag_title(String name) {
    return Intl.message(
      'Delete “$name”?',
      name: 'catalog_delete_tag_title',
      desc: '',
      args: [name],
    );
  }

  /// `Recipes will stay in your cookbook. This tag will be removed from every recipe that uses it.`
  String get catalog_delete_tag_description {
    return Intl.message(
      'Recipes will stay in your cookbook. This tag will be removed from every recipe that uses it.',
      name: 'catalog_delete_tag_description',
      desc: '',
      args: [],
    );
  }

  /// `Recipe tag already exists`
  String get recipe_tag_already_exists {
    return Intl.message(
      'Recipe tag already exists',
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

  /// `Select recipe tags:`
  String get select_recipe_tags {
    return Intl.message(
      'Select recipe tags:',
      name: 'select_recipe_tags',
      desc: '',
      args: [],
    );
  }

  /// `Recipetag`
  String get recipe_tag {
    return Intl.message('Recipetag', name: 'recipe_tag', desc: '', args: []);
  }

  /// `Delete recipe tag?`
  String get delete_recipe_tag {
    return Intl.message(
      'Delete recipe tag?',
      name: 'delete_recipe_tag',
      desc: '',
      args: [],
    );
  }

  /// `You have no recipe tags`
  String get you_have_no_recipe_tags {
    return Intl.message(
      'You have no recipe tags',
      name: 'you_have_no_recipe_tags',
      desc: '',
      args: [],
    );
  }

  /// `Import recipes from website`
  String get import_from_website {
    return Intl.message(
      'Import recipes from website',
      name: 'import_from_website',
      desc: '',
      args: [],
    );
  }

  /// `Import from website`
  String get import_from_website_short {
    return Intl.message(
      'Import from website',
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

  /// `Recipe with name "{name}" already exists`
  String recipe_already_exists(Object name) {
    return Intl.message(
      'Recipe with name "$name" already exists',
      name: 'recipe_already_exists',
      desc: '',
      args: [name],
    );
  }

  /// `Failed to connect to given url`
  String get failed_to_connect_to_url {
    return Intl.message(
      'Failed to connect to given url',
      name: 'failed_to_connect_to_url',
      desc: '',
      args: [],
    );
  }

  /// `Unsupported url:\ncheck the info about supported websites in the infopanel below`
  String get invalid_url {
    return Intl.message(
      'Unsupported url:\ncheck the info about supported websites in the infopanel below',
      name: 'invalid_url',
      desc: '',
      args: [],
    );
  }

  /// `Enter URL of website with recipe:`
  String get enter_url {
    return Intl.message(
      'Enter URL of website with recipe:',
      name: 'enter_url',
      desc: '',
      args: [],
    );
  }

  /// `Info about supported websites:`
  String get supported_websites {
    return Intl.message(
      'Info about supported websites:',
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

  /// `Recipe-url`
  String get recipe_url {
    return Intl.message('Recipe-url', name: 'recipe_url', desc: '', args: []);
  }

  /// `Source/url`
  String get source {
    return Intl.message('Source/url', name: 'source', desc: '', args: []);
  }

  /// `Recipe has been edited or deleted:\ngo back to man view and view it`
  String get recipe_edited_or_deleted {
    return Intl.message(
      'Recipe has been edited or deleted:\ngo back to man view and view it',
      name: 'recipe_edited_or_deleted',
      desc: '',
      args: [],
    );
  }

  /// `Recipe screen`
  String get recipe_screen {
    return Intl.message(
      'Recipe screen',
      name: 'recipe_screen',
      desc: '',
      args: [],
    );
  }

  /// `More coming soon...`
  String get more_coming_soon {
    return Intl.message(
      'More coming soon...',
      name: 'more_coming_soon',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get done {
    return Intl.message('Done', name: 'done', desc: '', args: []);
  }

  /// `Next`
  String get next {
    return Intl.message('Next', name: 'next', desc: '', args: []);
  }

  /// `Back`
  String get back {
    return Intl.message('Back', name: 'back', desc: '', args: []);
  }

  /// `Skip`
  String get skip {
    return Intl.message('Skip', name: 'skip', desc: '', args: []);
  }

  /// `Maximum pin count of 3 exceeded`
  String get maximum_recipe_pin_count_exceeded {
    return Intl.message(
      'Maximum pin count of 3 exceeded',
      name: 'maximum_recipe_pin_count_exceeded',
      desc: '',
      args: [],
    );
  }

  /// `Information`
  String get information {
    return Intl.message('Information', name: 'information', desc: '', args: []);
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

  /// `Tags`
  String get tags {
    return Intl.message('Tags', name: 'tags', desc: '', args: []);
  }

  /// `Shoppingcart help`
  String get shopping_cart_help {
    return Intl.message(
      'Shoppingcart help',
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

  /// `Enable complex animations`
  String get complex_animations {
    return Intl.message(
      'Enable complex animations',
      name: 'complex_animations',
      desc: '',
      args: [],
    );
  }

  /// `Keep screen on`
  String get keep_screen_on {
    return Intl.message(
      'Keep screen on',
      name: 'keep_screen_on',
      desc: '',
      args: [],
    );
  }

  /// `Only on recipe screen`
  String get only_recipe_screen {
    return Intl.message(
      'Only on recipe screen',
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

  /// `General infos`
  String get general_infos {
    return Intl.message(
      'General infos',
      name: 'general_infos',
      desc: '',
      args: [],
    );
  }

  /// `Preperation time`
  String get preperation_time {
    return Intl.message(
      'Preperation time',
      name: 'preperation_time',
      desc: '',
      args: [],
    );
  }

  /// `For "{number}" persons`
  String for_persons(Object number) {
    return Intl.message(
      'For "$number" persons',
      name: 'for_persons',
      desc: '',
      args: [number],
    );
  }

  /// `for`
  String get for_word {
    return Intl.message('for', name: 'for_word', desc: '', args: []);
  }

  /// `Persons`
  String get persons {
    return Intl.message('Persons', name: 'persons', desc: '', args: []);
  }

  /// `Print recipe`
  String get print_recipe {
    return Intl.message(
      'Print recipe',
      name: 'print_recipe',
      desc: '',
      args: [],
    );
  }

  /// `Supported formats:\n- .zip (file of this app)\n- .mcp`
  String get import_recipe_description {
    return Intl.message(
      'Supported formats:\n- .zip (file of this app)\n- .mcp',
      name: 'import_recipe_description',
      desc: '',
      args: [],
    );
  }

  /// `Invalid file`
  String get invalid_file {
    return Intl.message(
      'Invalid file',
      name: 'invalid_file',
      desc: '',
      args: [],
    );
  }

  /// `The file is not supported {fileName}.`
  String file_not_supported(Object fileName) {
    return Intl.message(
      'The file is not supported $fileName.',
      name: 'file_not_supported',
      desc: '',
      args: [fileName],
    );
  }

  /// `Invalid datatype`
  String get invalid_datatype {
    return Intl.message(
      'Invalid datatype',
      name: 'invalid_datatype',
      desc: '',
      args: [],
    );
  }

  /// `The datatype of the selected file "{datatype}" is not supported\nsupported formats: ".zip", ".mcb"`
  String datatype_not_supported(Object datatype) {
    return Intl.message(
      'The datatype of the selected file "$datatype" is not supported\nsupported formats: ".zip", ".mcb"',
      name: 'datatype_not_supported',
      desc: '',
      args: [datatype],
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

  /// `Show overview`
  String get show_overview {
    return Intl.message(
      'Show overview',
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

  /// `And many more!`
  String get and_many_more {
    return Intl.message(
      'And many more!',
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

  /// `Amount`
  String get amount {
    return Intl.message('Amount', name: 'amount', desc: '', args: []);
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

  /// `Add title`
  String get add_title {
    return Intl.message('Add title', name: 'add_title', desc: '', args: []);
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

  /// `Undo`
  String get undo {
    return Intl.message('Undo', name: 'undo', desc: '', args: []);
  }

  /// `You added {recipeName} to your the recipe planner for the following date:\n {year}-{month}-{day}`
  String undo_added_to_planner_description(
    Object recipeName,
    Object year,
    Object month,
    Object day,
  ) {
    return Intl.message(
      'You added $recipeName to your the recipe planner for the following date:\n $year-$month-$day',
      name: 'undo_added_to_planner_description',
      desc: '',
      args: [recipeName, year, month, day],
    );
  }

  /// `Meal planner`
  String get recipe_planer {
    return Intl.message(
      'Meal planner',
      name: 'recipe_planer',
      desc: '',
      args: [],
    );
  }

  /// `You can only add recipes that you have saved in the app.`
  String get no_recipe_with_this_name {
    return Intl.message(
      'You can only add recipes that you have saved in the app.',
      name: 'no_recipe_with_this_name',
      desc: '',
      args: [],
    );
  }

  /// `Select a date`
  String get select_a_date_first {
    return Intl.message(
      'Select a date',
      name: 'select_a_date_first',
      desc: '',
      args: [],
    );
  }

  /// `Select date`
  String get add_date {
    return Intl.message('Select date', name: 'add_date', desc: '', args: []);
  }

  /// `Add recipe`
  String get add_to_calendar {
    return Intl.message(
      'Add recipe',
      name: 'add_to_calendar',
      desc: '',
      args: [],
    );
  }

  /// `Jan.`
  String get jan {
    return Intl.message('Jan.', name: 'jan', desc: '', args: []);
  }

  /// `Feb.`
  String get feb {
    return Intl.message('Feb.', name: 'feb', desc: '', args: []);
  }

  /// `Mar.`
  String get mar {
    return Intl.message('Mar.', name: 'mar', desc: '', args: []);
  }

  /// `Apr.`
  String get apr {
    return Intl.message('Apr.', name: 'apr', desc: '', args: []);
  }

  /// `May`
  String get may {
    return Intl.message('May', name: 'may', desc: '', args: []);
  }

  /// `Jun.`
  String get jun {
    return Intl.message('Jun.', name: 'jun', desc: '', args: []);
  }

  /// `Jul.`
  String get jul {
    return Intl.message('Jul.', name: 'jul', desc: '', args: []);
  }

  /// `Aug.`
  String get aug {
    return Intl.message('Aug.', name: 'aug', desc: '', args: []);
  }

  /// `Sep.`
  String get sep {
    return Intl.message('Sep.', name: 'sep', desc: '', args: []);
  }

  /// `Oct.`
  String get oct {
    return Intl.message('Oct.', name: 'oct', desc: '', args: []);
  }

  /// `Nov.`
  String get nov {
    return Intl.message('Nov.', name: 'nov', desc: '', args: []);
  }

  /// `Dec.`
  String get dec {
    return Intl.message('Dec.', name: 'dec', desc: '', args: []);
  }

  /// `January`
  String get january {
    return Intl.message('January', name: 'january', desc: '', args: []);
  }

  /// `February`
  String get february {
    return Intl.message('February', name: 'february', desc: '', args: []);
  }

  /// `March`
  String get march {
    return Intl.message('March', name: 'march', desc: '', args: []);
  }

  /// `April`
  String get april {
    return Intl.message('April', name: 'april', desc: '', args: []);
  }

  /// `May`
  String get may_full {
    return Intl.message('May', name: 'may_full', desc: '', args: []);
  }

  /// `June`
  String get june {
    return Intl.message('June', name: 'june', desc: '', args: []);
  }

  /// `July`
  String get july {
    return Intl.message('July', name: 'july', desc: '', args: []);
  }

  /// `August`
  String get august {
    return Intl.message('August', name: 'august', desc: '', args: []);
  }

  /// `September`
  String get september {
    return Intl.message('September', name: 'september', desc: '', args: []);
  }

  /// `October`
  String get october {
    return Intl.message('October', name: 'october', desc: '', args: []);
  }

  /// `November`
  String get november {
    return Intl.message('November', name: 'november', desc: '', args: []);
  }

  /// `December`
  String get december {
    return Intl.message('December', name: 'december', desc: '', args: []);
  }

  /// `Monday`
  String get monday {
    return Intl.message('Monday', name: 'monday', desc: '', args: []);
  }

  /// `Tuesday`
  String get tuesday {
    return Intl.message('Tuesday', name: 'tuesday', desc: '', args: []);
  }

  /// `Wednesday`
  String get wednesday {
    return Intl.message('Wednesday', name: 'wednesday', desc: '', args: []);
  }

  /// `Thursday`
  String get thursday {
    return Intl.message('Thursday', name: 'thursday', desc: '', args: []);
  }

  /// `Friday`
  String get friday {
    return Intl.message('Friday', name: 'friday', desc: '', args: []);
  }

  /// `Saturday`
  String get saturday {
    return Intl.message('Saturday', name: 'saturday', desc: '', args: []);
  }

  /// `Sunday`
  String get sunday {
    return Intl.message('Sunday', name: 'sunday', desc: '', args: []);
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

  /// `Sync recipes with Google Drive`
  String get sync_recipes_drive {
    return Intl.message(
      'Sync recipes with Google Drive',
      name: 'sync_recipes_drive',
      desc: '',
      args: [],
    );
  }

  /// `Syncing recipes with Google Drive`
  String get syncing_recipes_drive {
    return Intl.message(
      'Syncing recipes with Google Drive',
      name: 'syncing_recipes_drive',
      desc: '',
      args: [],
    );
  }

  /// `Imported recipe: {recipeName}`
  String importing_recipe_drive(Object recipeName) {
    return Intl.message(
      'Imported recipe: $recipeName',
      name: 'importing_recipe_drive',
      desc: '',
      args: [recipeName],
    );
  }

  /// `Uploaded recipe: {recipeName}`
  String uploading_recipe_drive(Object recipeName) {
    return Intl.message(
      'Uploaded recipe: $recipeName',
      name: 'uploading_recipe_drive',
      desc: '',
      args: [recipeName],
    );
  }

  /// `Deleted recipe in cloud: {recipeName}`
  String deleting_recipe_drive(Object recipeName) {
    return Intl.message(
      'Deleted recipe in cloud: $recipeName',
      name: 'deleting_recipe_drive',
      desc: '',
      args: [recipeName],
    );
  }

  /// `Deleted local recipe: {recipeName}`
  String deleting_recipe_local(Object recipeName) {
    return Intl.message(
      'Deleted local recipe: $recipeName',
      name: 'deleting_recipe_local',
      desc: '',
      args: [recipeName],
    );
  }

  /// `Successfully synced recipes with Google Drive`
  String get successfully_synced_drive {
    return Intl.message(
      'Successfully synced recipes with Google Drive',
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

  /// `Failed to sign in maybe due to no internet`
  String get failed_sign_in {
    return Intl.message(
      'Failed to sign in maybe due to no internet',
      name: 'failed_sign_in',
      desc: '',
      args: [],
    );
  }

  /// `Error occured during syncing, maybe due to bad internet`
  String get failed_syncing {
    return Intl.message(
      'Error occured during syncing, maybe due to bad internet',
      name: 'failed_syncing',
      desc: '',
      args: [],
    );
  }

  /// `Grid`
  String get grid_view {
    return Intl.message('Grid', name: 'grid_view', desc: '', args: []);
  }

  /// `List`
  String get list_view {
    return Intl.message('List', name: 'list_view', desc: '', args: []);
  }

  /// `Bookmarked Recipes`
  String get bookmarked_recipes {
    return Intl.message(
      'Bookmarked Recipes',
      name: 'bookmarked_recipes',
      desc: '',
      args: [],
    );
  }

  /// `{count, plural, =0{No saved recipes} =1{1 saved recipe} other{{count} saved recipes}}`
  String bookmark_recipe_count(int count) {
    return Intl.plural(
      count,
      zero: 'No saved recipes',
      one: '1 saved recipe',
      other: '$count saved recipes',
      name: 'bookmark_recipe_count',
      desc: '',
      args: [count],
    );
  }

  /// `{count, plural, =0{no collections} =1{1 collection} other{{count} collections}}`
  String bookmark_collection_count(int count) {
    return Intl.plural(
      count,
      zero: 'no collections',
      one: '1 collection',
      other: '$count collections',
      name: 'bookmark_collection_count',
      desc: '',
      args: [count],
    );
  }

  /// `Search saved recipes, ingredients, and tags…`
  String get search_bookmarks {
    return Intl.message(
      'Search saved recipes, ingredients, and tags…',
      name: 'search_bookmarks',
      desc: '',
      args: [],
    );
  }

  /// `New`
  String get new_collection {
    return Intl.message('New', name: 'new_collection', desc: '', args: []);
  }

  /// `Manage collections`
  String get manage_bookmark_collections {
    return Intl.message(
      'Manage collections',
      name: 'manage_bookmark_collections',
      desc: '',
      args: [],
    );
  }

  /// `Bookmark a recipe to keep it close at hand.`
  String get bookmarks_empty_description {
    return Intl.message(
      'Bookmark a recipe to keep it close at hand.',
      name: 'bookmarks_empty_description',
      desc: '',
      args: [],
    );
  }

  /// `Filter recipes...`
  String get filter_recipes {
    return Intl.message(
      'Filter recipes...',
      name: 'filter_recipes',
      desc: '',
      args: [],
    );
  }

  /// `Sort: {sort}`
  String sort_by(Object sort) {
    return Intl.message('Sort: $sort', name: 'sort_by', desc: '', args: [sort]);
  }

  /// `All`
  String get all_recipes_filter {
    return Intl.message('All', name: 'all_recipes_filter', desc: '', args: []);
  }

  /// `Filters`
  String get more_filters {
    return Intl.message('Filters', name: 'more_filters', desc: '', args: []);
  }

  /// `Clear filters`
  String get clear_filters {
    return Intl.message(
      'Clear filters',
      name: 'clear_filters',
      desc: '',
      args: [],
    );
  }

  /// `Clear search`
  String get clear_search {
    return Intl.message(
      'Clear search',
      name: 'clear_search',
      desc: '',
      args: [],
    );
  }

  /// `Avg effort`
  String get average_effort {
    return Intl.message(
      'Avg effort',
      name: 'average_effort',
      desc: '',
      args: [],
    );
  }

  /// `{count, plural, =0{No recipes} =1{1 recipe} other{{count} recipes}}`
  String recipe_count(int count) {
    return Intl.plural(
      count,
      zero: 'No recipes',
      one: '1 recipe',
      other: '$count recipes',
      name: 'recipe_count',
      desc: '',
      args: [count],
    );
  }

  /// `{count, plural, =0{No recipes} =1{1 recipe} other{{count} recipes}} • Avg effort {effort}`
  String recipe_summary_with_effort(int count, String effort) {
    return Intl.message(
      '${Intl.plural(count, zero: 'No recipes', one: '1 recipe', other: '$count recipes')} • Avg effort $effort',
      name: 'recipe_summary_with_effort',
      desc: '',
      args: [count, effort],
    );
  }

  /// `Add bookmark`
  String get add_to_favorites {
    return Intl.message(
      'Add bookmark',
      name: 'add_to_favorites',
      desc: '',
      args: [],
    );
  }

  /// `Remove bookmark`
  String get remove_from_favorites {
    return Intl.message(
      'Remove bookmark',
      name: 'remove_from_favorites',
      desc: '',
      args: [],
    );
  }

  /// `Ascending`
  String get ascending {
    return Intl.message('Ascending', name: 'ascending', desc: '', args: []);
  }

  /// `Descending`
  String get descending {
    return Intl.message('Descending', name: 'descending', desc: '', args: []);
  }

  /// `No recipes here yet`
  String get no_recipes_in_collection {
    return Intl.message(
      'No recipes here yet',
      name: 'no_recipes_in_collection',
      desc: '',
      args: [],
    );
  }

  /// `No recipes match these filters`
  String get no_filtered_recipes {
    return Intl.message(
      'No recipes match these filters',
      name: 'no_filtered_recipes',
      desc: '',
      args: [],
    );
  }

  /// `You have no recipes for this dietary selection`
  String get no_recipes_for_diet {
    return Intl.message(
      'You have no recipes for this dietary selection',
      name: 'no_recipes_for_diet',
      desc: '',
      args: [],
    );
  }

  /// `Recipes couldn't be loaded`
  String get recipe_overview_failed {
    return Intl.message(
      'Recipes couldn\'t be loaded',
      name: 'recipe_overview_failed',
      desc: '',
      args: [],
    );
  }

  /// `Check your storage and try again.`
  String get recipe_overview_failed_description {
    return Intl.message(
      'Check your storage and try again.',
      name: 'recipe_overview_failed_description',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get retry {
    return Intl.message('Retry', name: 'retry', desc: '', args: []);
  }

  /// `MARKET PROVISIONS`
  String get shopping_market_provisions {
    return Intl.message(
      'MARKET PROVISIONS',
      name: 'shopping_market_provisions',
      desc: '',
      args: [],
    );
  }

  /// `{count, plural, =0{No items} =1{1 item} other{{count} items}}`
  String shopping_item_count(int count) {
    return Intl.plural(
      count,
      zero: 'No items',
      one: '1 item',
      other: '$count items',
      name: 'shopping_item_count',
      desc: '',
      args: [count],
    );
  }

  /// `{count, plural, =1{Gathering for 1 recipe} other{Gathering for {count} recipes}}`
  String shopping_for_recipes(int count) {
    return Intl.plural(
      count,
      one: 'Gathering for 1 recipe',
      other: 'Gathering for $count recipes',
      name: 'shopping_for_recipes',
      desc: '',
      args: [count],
    );
  }

  /// `Adjust servings`
  String get shopping_adjust_servings {
    return Intl.message(
      'Adjust servings',
      name: 'shopping_adjust_servings',
      desc: '',
      args: [],
    );
  }

  /// `{checked} of {total} items gathered`
  String shopping_progress(int checked, int total) {
    return Intl.message(
      '$checked of $total items gathered',
      name: 'shopping_progress',
      desc: '',
      args: [checked, total],
    );
  }

  /// `{percent}% gathered`
  String shopping_percent_gathered(int percent) {
    return Intl.message(
      '$percent% gathered',
      name: 'shopping_percent_gathered',
      desc: '',
      args: [percent],
    );
  }

  /// `Plain list`
  String get shopping_plain_list {
    return Intl.message(
      'Plain list',
      name: 'shopping_plain_list',
      desc: '',
      args: [],
    );
  }

  /// `By recipe`
  String get shopping_by_recipe {
    return Intl.message(
      'By recipe',
      name: 'shopping_by_recipe',
      desc: '',
      args: [],
    );
  }

  /// `Add an ingredient…`
  String get shopping_quick_add_hint {
    return Intl.message(
      'Add an ingredient…',
      name: 'shopping_quick_add_hint',
      desc: '',
      args: [],
    );
  }

  /// `Add ingredient with amount, unit, or recipe`
  String get shopping_add_details {
    return Intl.message(
      'Add ingredient with amount, unit, or recipe',
      name: 'shopping_add_details',
      desc: '',
      args: [],
    );
  }

  /// `Other items`
  String get shopping_other_items {
    return Intl.message(
      'Other items',
      name: 'shopping_other_items',
      desc: '',
      args: [],
    );
  }

  /// `Shopping mode`
  String get shopping_mode {
    return Intl.message(
      'Shopping mode',
      name: 'shopping_mode',
      desc: '',
      args: [],
    );
  }

  /// `Screen stays awake`
  String get shopping_mode_active {
    return Intl.message(
      'Screen stays awake',
      name: 'shopping_mode_active',
      desc: '',
      args: [],
    );
  }

  /// `Remove checked items`
  String get shopping_remove_checked {
    return Intl.message(
      'Remove checked items',
      name: 'shopping_remove_checked',
      desc: '',
      args: [],
    );
  }

  /// `Remove gathered items?`
  String get shopping_remove_checked_title {
    return Intl.message(
      'Remove gathered items?',
      name: 'shopping_remove_checked_title',
      desc: '',
      args: [],
    );
  }

  /// `{count, plural, =1{This removes 1 checked item from your list.} other{This removes {count} checked items from your list.}}`
  String shopping_remove_checked_description(int count) {
    return Intl.plural(
      count,
      one: 'This removes 1 checked item from your list.',
      other: 'This removes $count checked items from your list.',
      name: 'shopping_remove_checked_description',
      desc: '',
      args: [count],
    );
  }

  /// `{count, plural, =1{1 item removed} other{{count} items removed}}`
  String shopping_removed_items(int count) {
    return Intl.plural(
      count,
      one: '1 item removed',
      other: '$count items removed',
      name: 'shopping_removed_items',
      desc: '',
      args: [count],
    );
  }

  /// `The shopping list could not be updated. Try again.`
  String get shopping_action_failed {
    return Intl.message(
      'The shopping list could not be updated. Try again.',
      name: 'shopping_action_failed',
      desc: '',
      args: [],
    );
  }

  /// `Your shopping list could not be loaded`
  String get shopping_load_failed {
    return Intl.message(
      'Your shopping list could not be loaded',
      name: 'shopping_load_failed',
      desc: '',
      args: [],
    );
  }

  /// `Check your storage and try again.`
  String get shopping_load_failed_description {
    return Intl.message(
      'Check your storage and try again.',
      name: 'shopping_load_failed_description',
      desc: '',
      args: [],
    );
  }

  /// `Add ingredients here or from one of your recipes.`
  String get shopping_empty_description {
    return Intl.message(
      'Add ingredients here or from one of your recipes.',
      name: 'shopping_empty_description',
      desc: '',
      args: [],
    );
  }

  /// `{value} servings`
  String shopping_serving_value(String value) {
    return Intl.message(
      '$value servings',
      name: 'shopping_serving_value',
      desc: '',
      args: [value],
    );
  }

  /// `Enter a number greater than zero`
  String get shopping_invalid_servings {
    return Intl.message(
      'Enter a number greater than zero',
      name: 'shopping_invalid_servings',
      desc: '',
      args: [],
    );
  }

  /// `Share shopping list`
  String get share_shopping_list {
    return Intl.message(
      'Share shopping list',
      name: 'share_shopping_list',
      desc: '',
      args: [],
    );
  }

  /// `More shopping-list actions`
  String get shopping_more_actions {
    return Intl.message(
      'More shopping-list actions',
      name: 'shopping_more_actions',
      desc: '',
      args: [],
    );
  }

  /// `Search recipes`
  String get shopping_search_recipes {
    return Intl.message(
      'Search recipes',
      name: 'shopping_search_recipes',
      desc: '',
      args: [],
    );
  }

  /// `Remove {item}`
  String shopping_remove_item(String item) {
    return Intl.message(
      'Remove $item',
      name: 'shopping_remove_item',
      desc: '',
      args: [item],
    );
  }

  /// `Recipe Studio`
  String get recipe_studio {
    return Intl.message(
      'Recipe Studio',
      name: 'recipe_studio',
      desc: '',
      args: [],
    );
  }

  /// `Recipe editor`
  String get recipe_editor {
    return Intl.message(
      'Recipe editor',
      name: 'recipe_editor',
      desc: '',
      args: [],
    );
  }

  /// `Step {step} of {total}`
  String editor_progress(int step, int total) {
    return Intl.message(
      'Step $step of $total',
      name: 'editor_progress',
      desc: '',
      args: [step, total],
    );
  }

  /// `Dish basics & timing`
  String get dish_basics_timing {
    return Intl.message(
      'Dish basics & timing',
      name: 'dish_basics_timing',
      desc: '',
      args: [],
    );
  }

  /// `Yield & portions`
  String get yield_portions {
    return Intl.message(
      'Yield & portions',
      name: 'yield_portions',
      desc: '',
      args: [],
    );
  }

  /// `Dietary preference`
  String get dietary_preference {
    return Intl.message(
      'Dietary preference',
      name: 'dietary_preference',
      desc: '',
      args: [],
    );
  }

  /// `Continue to ingredients`
  String get continue_to_ingredients {
    return Intl.message(
      'Continue to ingredients',
      name: 'continue_to_ingredients',
      desc: '',
      args: [],
    );
  }

  /// `Continue to instructions`
  String get continue_to_instructions {
    return Intl.message(
      'Continue to instructions',
      name: 'continue_to_instructions',
      desc: '',
      args: [],
    );
  }

  /// `Continue to nutrition`
  String get continue_to_nutrition {
    return Intl.message(
      'Continue to nutrition',
      name: 'continue_to_nutrition',
      desc: '',
      args: [],
    );
  }

  /// `Save recipe`
  String get save_recipe {
    return Intl.message('Save recipe', name: 'save_recipe', desc: '', args: []);
  }

  /// `Save changes`
  String get save_changes {
    return Intl.message(
      'Save changes',
      name: 'save_changes',
      desc: '',
      args: [],
    );
  }

  /// `Values per serving · Optional`
  String get values_per_serving_optional {
    return Intl.message(
      'Values per serving · Optional',
      name: 'values_per_serving_optional',
      desc: '',
      args: [],
    );
  }

  /// `Add nutrition`
  String get add_nutrition_item {
    return Intl.message(
      'Add nutrition',
      name: 'add_nutrition_item',
      desc: '',
      args: [],
    );
  }

  /// `Assign ingredients`
  String get assign_ingredients {
    return Intl.message(
      'Assign ingredients',
      name: 'assign_ingredients',
      desc: '',
      args: [],
    );
  }

  /// `Ingredients for this step`
  String get ingredients_for_step {
    return Intl.message(
      'Ingredients for this step',
      name: 'ingredients_for_step',
      desc: '',
      args: [],
    );
  }

  /// `Untitled recipe`
  String get untitled_recipe {
    return Intl.message(
      'Untitled recipe',
      name: 'untitled_recipe',
      desc: '',
      args: [],
    );
  }

  /// `{count, plural, =0{No ingredients} =1{1 ingredient} other{{count} ingredients}}`
  String ingredient_count(int count) {
    return Intl.plural(
      count,
      zero: 'No ingredients',
      one: '1 ingredient',
      other: '$count ingredients',
      name: 'ingredient_count',
      desc: '',
      args: [count],
    );
  }

  /// `Add cover photo`
  String get add_cover_photo {
    return Intl.message(
      'Add cover photo',
      name: 'add_cover_photo',
      desc: '',
      args: [],
    );
  }

  /// `Change cover photo`
  String get change_cover_photo {
    return Intl.message(
      'Change cover photo',
      name: 'change_cover_photo',
      desc: '',
      args: [],
    );
  }

  /// `Meat`
  String get diet_meat {
    return Intl.message('Meat', name: 'diet_meat', desc: '', args: []);
  }

  /// `Vegetarian`
  String get diet_vegetarian {
    return Intl.message(
      'Vegetarian',
      name: 'diet_vegetarian',
      desc: '',
      args: [],
    );
  }

  /// `Vegan`
  String get diet_vegan {
    return Intl.message('Vegan', name: 'diet_vegan', desc: '', args: []);
  }

  /// `No ingredients in this section yet.`
  String get ingredient_section_empty {
    return Intl.message(
      'No ingredients in this section yet.',
      name: 'ingredient_section_empty',
      desc: '',
      args: [],
    );
  }

  /// `Start with the first instruction for this recipe.`
  String get instructions_empty {
    return Intl.message(
      'Start with the first instruction for this recipe.',
      name: 'instructions_empty',
      desc: '',
      args: [],
    );
  }

  /// `Step title (optional)`
  String get step_title {
    return Intl.message(
      'Step title (optional)',
      name: 'step_title',
      desc: '',
      args: [],
    );
  }

  /// `Describe what to do in this step…`
  String get step_description_hint {
    return Intl.message(
      'Describe what to do in this step…',
      name: 'step_description_hint',
      desc: '',
      args: [],
    );
  }

  /// `E.g. 18 g`
  String get nutrition_value_hint {
    return Intl.message(
      'E.g. 18 g',
      name: 'nutrition_value_hint',
      desc: '',
      args: [],
    );
  }

  /// `General`
  String get editor_general {
    return Intl.message('General', name: 'editor_general', desc: '', args: []);
  }

  /// `Ingredients`
  String get editor_ingredients {
    return Intl.message(
      'Ingredients',
      name: 'editor_ingredients',
      desc: '',
      args: [],
    );
  }

  /// `Instructions`
  String get editor_instructions {
    return Intl.message(
      'Instructions',
      name: 'editor_instructions',
      desc: '',
      args: [],
    );
  }

  /// `Nutrition`
  String get editor_nutrition {
    return Intl.message(
      'Nutrition',
      name: 'editor_nutrition',
      desc: '',
      args: [],
    );
  }

  /// `Recipe detail`
  String get recipe_detail {
    return Intl.message(
      'Recipe detail',
      name: 'recipe_detail',
      desc: '',
      args: [],
    );
  }

  /// `More recipe actions`
  String get recipe_more_actions {
    return Intl.message(
      'More recipe actions',
      name: 'recipe_more_actions',
      desc: '',
      args: [],
    );
  }

  /// `Pin recipe`
  String get pin_recipe {
    return Intl.message('Pin recipe', name: 'pin_recipe', desc: '', args: []);
  }

  /// `Unpin recipe`
  String get unpin_recipe {
    return Intl.message(
      'Unpin recipe',
      name: 'unpin_recipe',
      desc: '',
      args: [],
    );
  }

  /// `Pantry checklist`
  String get pantry_checklist {
    return Intl.message(
      'Pantry checklist',
      name: 'pantry_checklist',
      desc: '',
      args: [],
    );
  }

  /// `Tap ingredients to add or remove them from your shopping list.`
  String get pantry_checklist_help {
    return Intl.message(
      'Tap ingredients to add or remove them from your shopping list.',
      name: 'pantry_checklist_help',
      desc: '',
      args: [],
    );
  }

  /// `Add all ({count}) to shopping list`
  String add_all_to_shopping_list(int count) {
    return Intl.message(
      'Add all ($count) to shopping list',
      name: 'add_all_to_shopping_list',
      desc: '',
      args: [count],
    );
  }

  /// `Add remaining ({count}) to shopping list`
  String add_remaining_to_shopping_list(int count) {
    return Intl.message(
      'Add remaining ($count) to shopping list',
      name: 'add_remaining_to_shopping_list',
      desc: '',
      args: [count],
    );
  }

  /// `Remove all from shopping list`
  String get remove_all_from_shopping_list {
    return Intl.message(
      'Remove all from shopping list',
      name: 'remove_all_from_shopping_list',
      desc: '',
      args: [],
    );
  }

  /// `Add section`
  String get add_section_to_cart {
    return Intl.message(
      'Add section',
      name: 'add_section_to_cart',
      desc: '',
      args: [],
    );
  }

  /// `Remove section`
  String get remove_section_from_cart {
    return Intl.message(
      'Remove section',
      name: 'remove_section_from_cart',
      desc: '',
      args: [],
    );
  }

  /// `Serving adjuster`
  String get serving_adjuster {
    return Intl.message(
      'Serving adjuster',
      name: 'serving_adjuster',
      desc: '',
      args: [],
    );
  }

  /// `This recipe has no ingredients yet.`
  String get recipe_ingredients_empty {
    return Intl.message(
      'This recipe has no ingredients yet.',
      name: 'recipe_ingredients_empty',
      desc: '',
      args: [],
    );
  }

  /// `This recipe has no instructions yet.`
  String get recipe_instructions_empty {
    return Intl.message(
      'This recipe has no instructions yet.',
      name: 'recipe_instructions_empty',
      desc: '',
      args: [],
    );
  }

  /// `Effort calibration`
  String get effort_calibration {
    return Intl.message(
      'Effort calibration',
      name: 'effort_calibration',
      desc: '',
      args: [],
    );
  }

  /// `Preparation timeline`
  String get preparation_timeline {
    return Intl.message(
      'Preparation timeline',
      name: 'preparation_timeline',
      desc: '',
      args: [],
    );
  }

  /// `{count, plural, =0{No steps} =1{1 sequenced step} other{{count} sequenced steps}}`
  String instruction_count(int count) {
    return Intl.plural(
      count,
      zero: 'No steps',
      one: '1 sequenced step',
      other: '$count sequenced steps',
      name: 'instruction_count',
      desc: '',
      args: [count],
    );
  }

  /// `Instruction {number}`
  String instruction_number(int number) {
    return Intl.message(
      'Instruction $number',
      name: 'instruction_number',
      desc: '',
      args: [number],
    );
  }

  /// `Recipe details`
  String get recipe_details {
    return Intl.message(
      'Recipe details',
      name: 'recipe_details',
      desc: '',
      args: [],
    );
  }

  /// `Start cooking`
  String get start_cooking {
    return Intl.message(
      'Start cooking',
      name: 'start_cooking',
      desc: '',
      args: [],
    );
  }

  /// `Cook mode`
  String get cook_mode_title {
    return Intl.message(
      'Cook mode',
      name: 'cook_mode_title',
      desc: '',
      args: [],
    );
  }

  /// `Cooking assistant`
  String get cook_mode_assistant {
    return Intl.message(
      'Cooking assistant',
      name: 'cook_mode_assistant',
      desc: '',
      args: [],
    );
  }

  /// `Step {step} of {total}`
  String cook_mode_step_progress(int step, int total) {
    return Intl.message(
      'Step $step of $total',
      name: 'cook_mode_step_progress',
      desc: '',
      args: [step, total],
    );
  }

  /// `{percent}% complete`
  String cook_mode_percent_complete(int percent) {
    return Intl.message(
      '$percent% complete',
      name: 'cook_mode_percent_complete',
      desc: '',
      args: [percent],
    );
  }

  /// `Active phase · {recipe}`
  String cook_mode_active_phase(String recipe) {
    return Intl.message(
      'Active phase · $recipe',
      name: 'cook_mode_active_phase',
      desc: '',
      args: [recipe],
    );
  }

  /// `Step {number}`
  String cook_mode_step_fallback(int number) {
    return Intl.message(
      'Step $number',
      name: 'cook_mode_step_fallback',
      desc: '',
      args: [number],
    );
  }

  /// `Required for this step ({count})`
  String cook_mode_required_ingredients(int count) {
    return Intl.message(
      'Required for this step ($count)',
      name: 'cook_mode_required_ingredients',
      desc: '',
      args: [count],
    );
  }

  /// `No ingredients are assigned to this step.`
  String get cook_mode_no_assigned_ingredients {
    return Intl.message(
      'No ingredients are assigned to this step.',
      name: 'cook_mode_no_assigned_ingredients',
      desc: '',
      args: [],
    );
  }

  /// `Prepared`
  String get cook_mode_prepared {
    return Intl.message(
      'Prepared',
      name: 'cook_mode_prepared',
      desc: '',
      args: [],
    );
  }

  /// `Step instructions`
  String get cook_mode_step_instructions {
    return Intl.message(
      'Step instructions',
      name: 'cook_mode_step_instructions',
      desc: '',
      args: [],
    );
  }

  /// `Previous`
  String get cook_mode_previous {
    return Intl.message(
      'Previous',
      name: 'cook_mode_previous',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get cook_mode_next {
    return Intl.message('Next', name: 'cook_mode_next', desc: '', args: []);
  }

  /// `Finish`
  String get cook_mode_finish {
    return Intl.message('Finish', name: 'cook_mode_finish', desc: '', args: []);
  }

  /// `Keep screen awake`
  String get cook_mode_keep_awake {
    return Intl.message(
      'Keep screen awake',
      name: 'cook_mode_keep_awake',
      desc: '',
      args: [],
    );
  }

  /// `Allow screen to sleep`
  String get cook_mode_allow_sleep {
    return Intl.message(
      'Allow screen to sleep',
      name: 'cook_mode_allow_sleep',
      desc: '',
      args: [],
    );
  }

  /// `Timer`
  String get cook_mode_timer {
    return Intl.message('Timer', name: 'cook_mode_timer', desc: '', args: []);
  }

  /// `Set time`
  String get cook_mode_set_timer {
    return Intl.message(
      'Set time',
      name: 'cook_mode_set_timer',
      desc: '',
      args: [],
    );
  }

  /// `Start timer`
  String get cook_mode_start_timer {
    return Intl.message(
      'Start timer',
      name: 'cook_mode_start_timer',
      desc: '',
      args: [],
    );
  }

  /// `Pause timer`
  String get cook_mode_pause_timer {
    return Intl.message(
      'Pause timer',
      name: 'cook_mode_pause_timer',
      desc: '',
      args: [],
    );
  }

  /// `Resume timer`
  String get cook_mode_resume_timer {
    return Intl.message(
      'Resume timer',
      name: 'cook_mode_resume_timer',
      desc: '',
      args: [],
    );
  }

  /// `Add one minute`
  String get cook_mode_add_minute {
    return Intl.message(
      'Add one minute',
      name: 'cook_mode_add_minute',
      desc: '',
      args: [],
    );
  }

  /// `+1 min`
  String get cook_mode_add_minute_compact {
    return Intl.message(
      '+1 min',
      name: 'cook_mode_add_minute_compact',
      desc: '',
      args: [],
    );
  }

  /// `Reset timer`
  String get cook_mode_reset_timer {
    return Intl.message(
      'Reset timer',
      name: 'cook_mode_reset_timer',
      desc: '',
      args: [],
    );
  }

  /// `Cancel timer`
  String get cook_mode_cancel_timer {
    return Intl.message(
      'Cancel timer',
      name: 'cook_mode_cancel_timer',
      desc: '',
      args: [],
    );
  }

  /// `Collapse timer`
  String get cook_mode_collapse_timer {
    return Intl.message(
      'Collapse timer',
      name: 'cook_mode_collapse_timer',
      desc: '',
      args: [],
    );
  }

  /// `Expand timer`
  String get cook_mode_expand_timer {
    return Intl.message(
      'Expand timer',
      name: 'cook_mode_expand_timer',
      desc: '',
      args: [],
    );
  }

  /// `Timer complete`
  String get cook_mode_timer_complete {
    return Intl.message(
      'Timer complete',
      name: 'cook_mode_timer_complete',
      desc: '',
      args: [],
    );
  }

  /// `Time is up for this cooking step.`
  String get cook_mode_timer_complete_message {
    return Intl.message(
      'Time is up for this cooking step.',
      name: 'cook_mode_timer_complete_message',
      desc: '',
      args: [],
    );
  }

  /// `Restart`
  String get cook_mode_restart_timer {
    return Intl.message(
      'Restart',
      name: 'cook_mode_restart_timer',
      desc: '',
      args: [],
    );
  }

  /// `Set cooking timer`
  String get cook_mode_timer_sheet_title {
    return Intl.message(
      'Set cooking timer',
      name: 'cook_mode_timer_sheet_title',
      desc: '',
      args: [],
    );
  }

  /// `Hours`
  String get cook_mode_timer_hours {
    return Intl.message(
      'Hours',
      name: 'cook_mode_timer_hours',
      desc: '',
      args: [],
    );
  }

  /// `Minutes`
  String get cook_mode_timer_minutes {
    return Intl.message(
      'Minutes',
      name: 'cook_mode_timer_minutes',
      desc: '',
      args: [],
    );
  }

  /// `Seconds`
  String get cook_mode_timer_seconds {
    return Intl.message(
      'Seconds',
      name: 'cook_mode_timer_seconds',
      desc: '',
      args: [],
    );
  }

  /// `Enter a duration greater than zero.`
  String get cook_mode_timer_invalid {
    return Intl.message(
      'Enter a duration greater than zero.',
      name: 'cook_mode_timer_invalid',
      desc: '',
      args: [],
    );
  }

  /// `Set timer`
  String get cook_mode_timer_save {
    return Intl.message(
      'Set timer',
      name: 'cook_mode_timer_save',
      desc: '',
      args: [],
    );
  }

  /// `End cook mode?`
  String get cook_mode_exit_title {
    return Intl.message(
      'End cook mode?',
      name: 'cook_mode_exit_title',
      desc: '',
      args: [],
    );
  }

  /// `Leaving will stop the active timer and discard this cook session.`
  String get cook_mode_exit_message {
    return Intl.message(
      'Leaving will stop the active timer and discard this cook session.',
      name: 'cook_mode_exit_message',
      desc: '',
      args: [],
    );
  }

  /// `Keep cooking`
  String get cook_mode_stay {
    return Intl.message(
      'Keep cooking',
      name: 'cook_mode_stay',
      desc: '',
      args: [],
    );
  }

  /// `End session`
  String get cook_mode_end_session {
    return Intl.message(
      'End session',
      name: 'cook_mode_end_session',
      desc: '',
      args: [],
    );
  }

  /// `Cooking complete`
  String get cook_mode_finish_title {
    return Intl.message(
      'Cooking complete',
      name: 'cook_mode_finish_title',
      desc: '',
      args: [],
    );
  }

  /// `You have reached the final step.`
  String get cook_mode_finish_message {
    return Intl.message(
      'You have reached the final step.',
      name: 'cook_mode_finish_message',
      desc: '',
      args: [],
    );
  }

  /// `You have reached the final step. Finishing will also stop the active timer.`
  String get cook_mode_finish_timer_message {
    return Intl.message(
      'You have reached the final step. Finishing will also stop the active timer.',
      name: 'cook_mode_finish_timer_message',
      desc: '',
      args: [],
    );
  }

  /// `Finish and stop timer`
  String get cook_mode_finish_and_stop {
    return Intl.message(
      'Finish and stop timer',
      name: 'cook_mode_finish_and_stop',
      desc: '',
      args: [],
    );
  }

  /// `The recipe source could not be opened.`
  String get source_could_not_open {
    return Intl.message(
      'The recipe source could not be opened.',
      name: 'source_could_not_open',
      desc: '',
      args: [],
    );
  }

  /// `Dish of the day`
  String get dish_of_the_day {
    return Intl.message(
      'Dish of the day',
      name: 'dish_of_the_day',
      desc: '',
      args: [],
    );
  }

  /// `Open recipe`
  String get open_recipe {
    return Intl.message('Open recipe', name: 'open_recipe', desc: '', args: []);
  }

  /// `Open`
  String get category_open {
    return Intl.message('Open', name: 'category_open', desc: '', args: []);
  }

  /// `Start`
  String get category_start {
    return Intl.message('Start', name: 'category_start', desc: '', args: []);
  }

  /// `Collapse`
  String get collapse {
    return Intl.message('Collapse', name: 'collapse', desc: '', args: []);
  }

  /// `Expand Dish of the Day`
  String get expand_dish_of_the_day {
    return Intl.message(
      'Expand Dish of the Day',
      name: 'expand_dish_of_the_day',
      desc: '',
      args: [],
    );
  }

  /// `Collapse Dish of the Day`
  String get collapse_dish_of_the_day {
    return Intl.message(
      'Collapse Dish of the Day',
      name: 'collapse_dish_of_the_day',
      desc: '',
      args: [],
    );
  }

  /// `{effort}/10 Effort`
  String recipe_card_effort_value(String effort) {
    return Intl.message(
      '$effort/10 Effort',
      name: 'recipe_card_effort_value',
      desc: '',
      args: [effort],
    );
  }

  /// `{time} prep`
  String recipe_card_prep_time(String time) {
    return Intl.message(
      '$time prep',
      name: 'recipe_card_prep_time',
      desc: '',
      args: [time],
    );
  }

  /// `{time} cook`
  String recipe_card_cook_time(String time) {
    return Intl.message(
      '$time cook',
      name: 'recipe_card_cook_time',
      desc: '',
      args: [time],
    );
  }

  /// `{time} total`
  String recipe_card_total_time(String time) {
    return Intl.message(
      '$time total',
      name: 'recipe_card_total_time',
      desc: '',
      args: [time],
    );
  }

  /// `Time not set`
  String get recipe_card_time_unknown {
    return Intl.message(
      'Time not set',
      name: 'recipe_card_time_unknown',
      desc: '',
      args: [],
    );
  }

  /// `See all ({count})`
  String category_see_all(int count) {
    return Intl.message(
      'See all ($count)',
      name: 'category_see_all',
      desc: '',
      args: [count],
    );
  }

  /// `Effort: {effort}/10`
  String category_effort_value(int effort) {
    return Intl.message(
      'Effort: $effort/10',
      name: 'category_effort_value',
      desc: '',
      args: [effort],
    );
  }

  /// `Effort not set`
  String get category_effort_not_set {
    return Intl.message(
      'Effort not set',
      name: 'category_effort_not_set',
      desc: '',
      args: [],
    );
  }

  /// `Prep {time}`
  String category_prep_value(String time) {
    return Intl.message(
      'Prep $time',
      name: 'category_prep_value',
      desc: '',
      args: [time],
    );
  }

  /// `Cook {time}`
  String category_cook_value(String time) {
    return Intl.message(
      'Cook $time',
      name: 'category_cook_value',
      desc: '',
      args: [time],
    );
  }

  /// `Total: {time}`
  String category_total_value(String time) {
    return Intl.message(
      'Total: $time',
      name: 'category_total_value',
      desc: '',
      args: [time],
    );
  }

  /// `Prep`
  String get category_prep_short {
    return Intl.message(
      'Prep',
      name: 'category_prep_short',
      desc: '',
      args: [],
    );
  }

  /// `Cook`
  String get category_cook_short {
    return Intl.message(
      'Cook',
      name: 'category_cook_short',
      desc: '',
      args: [],
    );
  }

  /// `Total`
  String get category_total_short {
    return Intl.message(
      'Total',
      name: 'category_total_short',
      desc: '',
      args: [],
    );
  }

  /// `Your cookbook is ready`
  String get category_overview_empty_title {
    return Intl.message(
      'Your cookbook is ready',
      name: 'category_overview_empty_title',
      desc: '',
      args: [],
    );
  }

  /// `Add your first recipe with the + button and it will appear here.`
  String get category_overview_empty_description {
    return Intl.message(
      'Add your first recipe with the + button and it will appear here.',
      name: 'category_overview_empty_description',
      desc: '',
      args: [],
    );
  }

  /// `No recipes in this category yet.`
  String get category_section_empty {
    return Intl.message(
      'No recipes in this category yet.',
      name: 'category_section_empty',
      desc: '',
      args: [],
    );
  }

  /// `Ingredient search`
  String get ingredient_search_title {
    return Intl.message(
      'Ingredient search',
      name: 'ingredient_search_title',
      desc: '',
      args: [],
    );
  }

  /// `Cook from what you have`
  String get ingredient_search_heading {
    return Intl.message(
      'Cook from what you have',
      name: 'ingredient_search_heading',
      desc: '',
      args: [],
    );
  }

  /// `Add ingredients from your kitchen, refine the filters, and find recipes that fit.`
  String get ingredient_search_description {
    return Intl.message(
      'Add ingredients from your kitchen, refine the filters, and find recipes that fit.',
      name: 'ingredient_search_description',
      desc: '',
      args: [],
    );
  }

  /// `PRO FEATURE`
  String get ingredient_search_preview_pro_badge {
    return Intl.message(
      'PRO FEATURE',
      name: 'ingredient_search_preview_pro_badge',
      desc: '',
      args: [],
    );
  }

  /// `Choose ingredients from your kitchen and find matching recipes in your own collection. Refine them by diet, time, effort, categories, or tags.`
  String get ingredient_search_preview_description {
    return Intl.message(
      'Choose ingredients from your kitchen and find matching recipes in your own collection. Refine them by diet, time, effort, categories, or tags.',
      name: 'ingredient_search_preview_description',
      desc: '',
      args: [],
    );
  }

  /// `Read-only example of an ingredient search with spinach, pasta, and tomatoes, refined to a vegetarian recipe under 30 minutes and effort level 5.`
  String get ingredient_search_preview_semantics {
    return Intl.message(
      'Read-only example of an ingredient search with spinach, pasta, and tomatoes, refined to a vegetarian recipe under 30 minutes and effort level 5.',
      name: 'ingredient_search_preview_semantics',
      desc: '',
      args: [],
    );
  }

  /// `Spinach`
  String get ingredient_search_preview_spinach {
    return Intl.message(
      'Spinach',
      name: 'ingredient_search_preview_spinach',
      desc: '',
      args: [],
    );
  }

  /// `Pasta`
  String get ingredient_search_preview_pasta {
    return Intl.message(
      'Pasta',
      name: 'ingredient_search_preview_pasta',
      desc: '',
      args: [],
    );
  }

  /// `Tomatoes`
  String get ingredient_search_preview_tomatoes {
    return Intl.message(
      'Tomatoes',
      name: 'ingredient_search_preview_tomatoes',
      desc: '',
      args: [],
    );
  }

  /// `FILTERED BY`
  String get ingredient_search_preview_filtered_by {
    return Intl.message(
      'FILTERED BY',
      name: 'ingredient_search_preview_filtered_by',
      desc: '',
      args: [],
    );
  }

  /// `Effort ≤5`
  String get ingredient_search_preview_effort_cap {
    return Intl.message(
      'Effort ≤5',
      name: 'ingredient_search_preview_effort_cap',
      desc: '',
      args: [],
    );
  }

  /// `EXAMPLE MATCH`
  String get ingredient_search_preview_example {
    return Intl.message(
      'EXAMPLE MATCH',
      name: 'ingredient_search_preview_example',
      desc: '',
      args: [],
    );
  }

  /// `Creamy spinach pasta`
  String get ingredient_search_preview_example_recipe {
    return Intl.message(
      'Creamy spinach pasta',
      name: 'ingredient_search_preview_example_recipe',
      desc: '',
      args: [],
    );
  }

  /// `25 min`
  String get ingredient_search_preview_recipe_time {
    return Intl.message(
      '25 min',
      name: 'ingredient_search_preview_recipe_time',
      desc: '',
      args: [],
    );
  }

  /// `Search your cookbook`
  String get ingredient_search_preview_own_title {
    return Intl.message(
      'Search your cookbook',
      name: 'ingredient_search_preview_own_title',
      desc: '',
      args: [],
    );
  }

  /// `Match ingredients against the recipes saved on this device.`
  String get ingredient_search_preview_own_description {
    return Intl.message(
      'Match ingredients against the recipes saved on this device.',
      name: 'ingredient_search_preview_own_description',
      desc: '',
      args: [],
    );
  }

  /// `Refine every result`
  String get ingredient_search_preview_refine_title {
    return Intl.message(
      'Refine every result',
      name: 'ingredient_search_preview_refine_title',
      desc: '',
      args: [],
    );
  }

  /// `Narrow matches by diet, time, effort, categories, and tags.`
  String get ingredient_search_preview_refine_description {
    return Intl.message(
      'Narrow matches by diet, time, effort, categories, and tags.',
      name: 'ingredient_search_preview_refine_description',
      desc: '',
      args: [],
    );
  }

  /// `Sort, open, and bookmark`
  String get ingredient_search_preview_save_title {
    return Intl.message(
      'Sort, open, and bookmark',
      name: 'ingredient_search_preview_save_title',
      desc: '',
      args: [],
    );
  }

  /// `Order results by best match, time, effort, or name, then open or bookmark a recipe.`
  String get ingredient_search_preview_save_description {
    return Intl.message(
      'Order results by best match, time, effort, or name, then open or bookmark a recipe.',
      name: 'ingredient_search_preview_save_description',
      desc: '',
      args: [],
    );
  }

  /// `Also included with Pro`
  String get ingredient_search_preview_pro_title {
    return Intl.message(
      'Also included with Pro',
      name: 'ingredient_search_preview_pro_title',
      desc: '',
      args: [],
    );
  }

  /// `A one-time purchase also removes in-app ads and supports future development.`
  String get ingredient_search_preview_pro_description {
    return Intl.message(
      'A one-time purchase also removes in-app ads and supports future development.',
      name: 'ingredient_search_preview_pro_description',
      desc: '',
      args: [],
    );
  }

  /// `Unlock ingredient search`
  String get ingredient_search_preview_unlock {
    return Intl.message(
      'Unlock ingredient search',
      name: 'ingredient_search_preview_unlock',
      desc: '',
      args: [],
    );
  }

  /// `One-time Pro purchase · Removes ads · Supports future development`
  String get ingredient_search_preview_unlock_description {
    return Intl.message(
      'One-time Pro purchase · Removes ads · Supports future development',
      name: 'ingredient_search_preview_unlock_description',
      desc: '',
      args: [],
    );
  }

  /// `Add an ingredient…`
  String get ingredient_search_input_hint {
    return Intl.message(
      'Add an ingredient…',
      name: 'ingredient_search_input_hint',
      desc: '',
      args: [],
    );
  }

  /// `Add ingredient`
  String get ingredient_search_add {
    return Intl.message(
      'Add ingredient',
      name: 'ingredient_search_add',
      desc: '',
      args: [],
    );
  }

  /// `You can search with up to {count} ingredients.`
  String ingredient_search_limit(int count) {
    return Intl.message(
      'You can search with up to $count ingredients.',
      name: 'ingredient_search_limit',
      desc: '',
      args: [count],
    );
  }

  /// `{count, plural, =0{YOUR BASKET} =1{YOUR BASKET · 1 INGREDIENT} other{YOUR BASKET · {count} INGREDIENTS}}`
  String ingredient_search_basket_count(int count) {
    return Intl.plural(
      count,
      zero: 'YOUR BASKET',
      one: 'YOUR BASKET · 1 INGREDIENT',
      other: 'YOUR BASKET · $count INGREDIENTS',
      name: 'ingredient_search_basket_count',
      desc: '',
      args: [count],
    );
  }

  /// `Clear all`
  String get ingredient_search_clear_all {
    return Intl.message(
      'Clear all',
      name: 'ingredient_search_clear_all',
      desc: '',
      args: [],
    );
  }

  /// `Add one or more ingredients to start matching your cookbook.`
  String get ingredient_search_basket_empty {
    return Intl.message(
      'Add one or more ingredients to start matching your cookbook.',
      name: 'ingredient_search_basket_empty',
      desc: '',
      args: [],
    );
  }

  /// `Remove {ingredient}`
  String ingredient_search_remove(String ingredient) {
    return Intl.message(
      'Remove $ingredient',
      name: 'ingredient_search_remove',
      desc: '',
      args: [ingredient],
    );
  }

  /// `MAX TIME`
  String get ingredient_search_max_time {
    return Intl.message(
      'MAX TIME',
      name: 'ingredient_search_max_time',
      desc: '',
      args: [],
    );
  }

  /// `EFFORT CAP`
  String get ingredient_search_effort_cap {
    return Intl.message(
      'EFFORT CAP',
      name: 'ingredient_search_effort_cap',
      desc: '',
      args: [],
    );
  }

  /// `No limit`
  String get ingredient_search_no_limit {
    return Intl.message(
      'No limit',
      name: 'ingredient_search_no_limit',
      desc: '',
      args: [],
    );
  }

  /// `≤ {count} min`
  String ingredient_search_minutes(int count) {
    return Intl.message(
      '≤ $count min',
      name: 'ingredient_search_minutes',
      desc: '',
      args: [count],
    );
  }

  /// `Effort {effort}/10`
  String ingredient_search_effort_value(int effort) {
    return Intl.message(
      'Effort $effort/10',
      name: 'ingredient_search_effort_value',
      desc: '',
      args: [effort],
    );
  }

  /// `Any time`
  String get ingredient_search_any_time {
    return Intl.message(
      'Any time',
      name: 'ingredient_search_any_time',
      desc: '',
      args: [],
    );
  }

  /// `Any effort`
  String get ingredient_search_any_effort {
    return Intl.message(
      'Any effort',
      name: 'ingredient_search_any_effort',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get ingredient_search_all {
    return Intl.message(
      'All',
      name: 'ingredient_search_all',
      desc: '',
      args: [],
    );
  }

  /// `Vegetarian`
  String get ingredient_search_vegetarian {
    return Intl.message(
      'Vegetarian',
      name: 'ingredient_search_vegetarian',
      desc: '',
      args: [],
    );
  }

  /// `Vegan`
  String get ingredient_search_vegan {
    return Intl.message(
      'Vegan',
      name: 'ingredient_search_vegan',
      desc: '',
      args: [],
    );
  }

  /// `Meat`
  String get ingredient_search_meat {
    return Intl.message(
      'Meat',
      name: 'ingredient_search_meat',
      desc: '',
      args: [],
    );
  }

  /// `More filters`
  String get ingredient_search_more_filters {
    return Intl.message(
      'More filters',
      name: 'ingredient_search_more_filters',
      desc: '',
      args: [],
    );
  }

  /// `Filters ({count})`
  String ingredient_search_active_filters(int count) {
    return Intl.message(
      'Filters ($count)',
      name: 'ingredient_search_active_filters',
      desc: '',
      args: [count],
    );
  }

  /// `Refine your matches`
  String get ingredient_search_filters_title {
    return Intl.message(
      'Refine your matches',
      name: 'ingredient_search_filters_title',
      desc: '',
      args: [],
    );
  }

  /// `Reset`
  String get ingredient_search_reset {
    return Intl.message(
      'Reset',
      name: 'ingredient_search_reset',
      desc: '',
      args: [],
    );
  }

  /// `Matched recipes`
  String get ingredient_search_results {
    return Intl.message(
      'Matched recipes',
      name: 'ingredient_search_results',
      desc: '',
      args: [],
    );
  }

  /// `{count, plural, =0{(none found)} =1{(1 found)} other{({count} found)}}`
  String ingredient_search_found(int count) {
    return Intl.plural(
      count,
      zero: '(none found)',
      one: '(1 found)',
      other: '($count found)',
      name: 'ingredient_search_found',
      desc: '',
      args: [count],
    );
  }

  /// `Build your pantry basket`
  String get ingredient_search_empty_title {
    return Intl.message(
      'Build your pantry basket',
      name: 'ingredient_search_empty_title',
      desc: '',
      args: [],
    );
  }

  /// `Add an ingredient or choose a filter to see recipes from your collection.`
  String get ingredient_search_empty_description {
    return Intl.message(
      'Add an ingredient or choose a filter to see recipes from your collection.',
      name: 'ingredient_search_empty_description',
      desc: '',
      args: [],
    );
  }

  /// `Recipes couldn’t be searched`
  String get ingredient_search_failed {
    return Intl.message(
      'Recipes couldn’t be searched',
      name: 'ingredient_search_failed',
      desc: '',
      args: [],
    );
  }

  /// `Check your storage and try the search again.`
  String get ingredient_search_failed_description {
    return Intl.message(
      'Check your storage and try the search again.',
      name: 'ingredient_search_failed_description',
      desc: '',
      args: [],
    );
  }

  /// `No recipes match yet`
  String get ingredient_search_no_matches {
    return Intl.message(
      'No recipes match yet',
      name: 'ingredient_search_no_matches',
      desc: '',
      args: [],
    );
  }

  /// `Try removing an ingredient or widening your time and effort limits.`
  String get ingredient_search_no_matches_description {
    return Intl.message(
      'Try removing an ingredient or widening your time and effort limits.',
      name: 'ingredient_search_no_matches_description',
      desc: '',
      args: [],
    );
  }

  /// `Adjust filters`
  String get ingredient_search_adjust_filters {
    return Intl.message(
      'Adjust filters',
      name: 'ingredient_search_adjust_filters',
      desc: '',
      args: [],
    );
  }

  /// `Best match`
  String get ingredient_search_sort_best {
    return Intl.message(
      'Best match',
      name: 'ingredient_search_sort_best',
      desc: '',
      args: [],
    );
  }

  /// `Shortest time`
  String get ingredient_search_sort_time {
    return Intl.message(
      'Shortest time',
      name: 'ingredient_search_sort_time',
      desc: '',
      args: [],
    );
  }

  /// `Lowest effort`
  String get ingredient_search_sort_effort {
    return Intl.message(
      'Lowest effort',
      name: 'ingredient_search_sort_effort',
      desc: '',
      args: [],
    );
  }

  /// `Name A–Z`
  String get ingredient_search_sort_name {
    return Intl.message(
      'Name A–Z',
      name: 'ingredient_search_sort_name',
      desc: '',
      args: [],
    );
  }

  /// `Time not set`
  String get ingredient_search_time_unknown {
    return Intl.message(
      'Time not set',
      name: 'ingredient_search_time_unknown',
      desc: '',
      args: [],
    );
  }

  /// `Effort —`
  String get ingredient_search_effort_unknown {
    return Intl.message(
      'Effort —',
      name: 'ingredient_search_effort_unknown',
      desc: '',
      args: [],
    );
  }

  /// `{matched} of {total} selected ingredients matched`
  String ingredient_search_match_summary(int matched, int total) {
    return Intl.message(
      '$matched of $total selected ingredients matched',
      name: 'ingredient_search_match_summary',
      desc: '',
      args: [matched, total],
    );
  }

  /// `{matched}/{total} ingredients`
  String ingredient_search_match_badge(int matched, int total) {
    return Intl.message(
      '$matched/$total ingredients',
      name: 'ingredient_search_match_badge',
      desc: '',
      args: [matched, total],
    );
  }

  /// `Plan recipe`
  String get calendar_plan_recipe {
    return Intl.message(
      'Plan recipe',
      name: 'calendar_plan_recipe',
      desc: '',
      args: [],
    );
  }

  /// `This week`
  String get calendar_this_week {
    return Intl.message(
      'This week',
      name: 'calendar_this_week',
      desc: '',
      args: [],
    );
  }

  /// `Previous week`
  String get calendar_previous_week {
    return Intl.message(
      'Previous week',
      name: 'calendar_previous_week',
      desc: '',
      args: [],
    );
  }

  /// `Next week`
  String get calendar_next_week {
    return Intl.message(
      'Next week',
      name: 'calendar_next_week',
      desc: '',
      args: [],
    );
  }

  /// `{count, plural, =0{No meals} =1{1 meal} other{{count} meals}}`
  String calendar_meal_count(int count) {
    return Intl.plural(
      count,
      zero: 'No meals',
      one: '1 meal',
      other: '$count meals',
      name: 'calendar_meal_count',
      desc: '',
      args: [count],
    );
  }

  /// `Nothing planned yet`
  String get calendar_empty_day {
    return Intl.message(
      'Nothing planned yet',
      name: 'calendar_empty_day',
      desc: '',
      args: [],
    );
  }

  /// `Add a recipe for {day}`
  String calendar_add_for_day(String day) {
    return Intl.message(
      'Add a recipe for $day',
      name: 'calendar_add_for_day',
      desc: '',
      args: [day],
    );
  }

  /// `More actions for {recipe}`
  String calendar_more_actions(String recipe) {
    return Intl.message(
      'More actions for $recipe',
      name: 'calendar_more_actions',
      desc: '',
      args: [recipe],
    );
  }

  /// `Remove from plan`
  String get calendar_remove_from_plan {
    return Intl.message(
      'Remove from plan',
      name: 'calendar_remove_from_plan',
      desc: '',
      args: [],
    );
  }

  /// `{recipe} removed from the plan`
  String calendar_removed(String recipe) {
    return Intl.message(
      '$recipe removed from the plan',
      name: 'calendar_removed',
      desc: '',
      args: [recipe],
    );
  }

  /// `Your meal plan could not be loaded`
  String get calendar_load_failed {
    return Intl.message(
      'Your meal plan could not be loaded',
      name: 'calendar_load_failed',
      desc: '',
      args: [],
    );
  }

  /// `Check your storage and try again.`
  String get calendar_load_failed_description {
    return Intl.message(
      'Check your storage and try again.',
      name: 'calendar_load_failed_description',
      desc: '',
      args: [],
    );
  }

  /// `{recipes, plural, =1{1 recipe} other{{recipes} recipes}} · {ingredients, plural, =1{1 ingredient line} other{{ingredients} ingredient lines}}`
  String calendar_export_summary(int recipes, int ingredients) {
    return Intl.message(
      '${Intl.plural(recipes, one: '1 recipe', other: '$recipes recipes')} · ${Intl.plural(ingredients, one: '1 ingredient line', other: '$ingredients ingredient lines')}',
      name: 'calendar_export_summary',
      desc: '',
      args: [recipes, ingredients],
    );
  }

  /// `Review & export`
  String get calendar_review_export {
    return Intl.message(
      'Review & export',
      name: 'calendar_review_export',
      desc: '',
      args: [],
    );
  }

  /// `Review shopping list`
  String get calendar_review_title {
    return Intl.message(
      'Review shopping list',
      name: 'calendar_review_title',
      desc: '',
      args: [],
    );
  }

  /// `Adjust servings and unselect anything you already have.`
  String get calendar_review_description {
    return Intl.message(
      'Adjust servings and unselect anything you already have.',
      name: 'calendar_review_description',
      desc: '',
      args: [],
    );
  }

  /// `{count, plural, =1{Planned once} other{Planned {count} times}}`
  String calendar_planned_count(int count) {
    return Intl.plural(
      count,
      one: 'Planned once',
      other: 'Planned $count times',
      name: 'calendar_planned_count',
      desc: '',
      args: [count],
    );
  }

  /// `Servings not specified`
  String get calendar_servings_not_set {
    return Intl.message(
      'Servings not specified',
      name: 'calendar_servings_not_set',
      desc: '',
      args: [],
    );
  }

  /// `{count, plural, =0{No ingredients selected} =1{1 ingredient selected} other{{count} ingredients selected}}`
  String calendar_selected_count(int count) {
    return Intl.plural(
      count,
      zero: 'No ingredients selected',
      one: '1 ingredient selected',
      other: '$count ingredients selected',
      name: 'calendar_selected_count',
      desc: '',
      args: [count],
    );
  }

  /// `Add selected`
  String get calendar_add_selected {
    return Intl.message(
      'Add selected',
      name: 'calendar_add_selected',
      desc: '',
      args: [],
    );
  }

  /// `{count, plural, =1{1 ingredient line added} other{{count} ingredient lines added}}`
  String calendar_export_success(int count) {
    return Intl.plural(
      count,
      one: '1 ingredient line added',
      other: '$count ingredient lines added',
      name: 'calendar_export_success',
      desc: '',
      args: [count],
    );
  }

  /// `This week has no ingredients to export`
  String get calendar_no_exportable {
    return Intl.message(
      'This week has no ingredients to export',
      name: 'calendar_no_exportable',
      desc: '',
      args: [],
    );
  }

  /// `Select ingredients for {recipe}`
  String calendar_select_recipe_ingredients(String recipe) {
    return Intl.message(
      'Select ingredients for $recipe',
      name: 'calendar_select_recipe_ingredients',
      desc: '',
      args: [recipe],
    );
  }

  /// `Settings & Preferences`
  String get settings_title {
    return Intl.message(
      'Settings & Preferences',
      name: 'settings_title',
      desc: '',
      args: [],
    );
  }

  /// `Kitchen configuration`
  String get settings_configuration {
    return Intl.message(
      'Kitchen configuration',
      name: 'settings_configuration',
      desc: '',
      args: [],
    );
  }

  /// `Account & ads`
  String get settings_account_ads {
    return Intl.message(
      'Account & ads',
      name: 'settings_account_ads',
      desc: '',
      args: [],
    );
  }

  /// `Data & sync`
  String get settings_data_sync {
    return Intl.message(
      'Data & sync',
      name: 'settings_data_sync',
      desc: '',
      args: [],
    );
  }

  /// `Appearance & display`
  String get settings_appearance_display {
    return Intl.message(
      'Appearance & display',
      name: 'settings_appearance_display',
      desc: '',
      args: [],
    );
  }

  /// `Recipe catalog`
  String get settings_recipe_catalog {
    return Intl.message(
      'Recipe catalog',
      name: 'settings_recipe_catalog',
      desc: '',
      args: [],
    );
  }

  /// `Help & about`
  String get settings_help_about {
    return Intl.message(
      'Help & about',
      name: 'settings_help_about',
      desc: '',
      args: [],
    );
  }

  /// `Google Drive`
  String get settings_drive_title {
    return Intl.message(
      'Google Drive',
      name: 'settings_drive_title',
      desc: '',
      args: [],
    );
  }

  /// `Sign in to sync recipes manually across devices.`
  String get settings_drive_signed_out_desc {
    return Intl.message(
      'Sign in to sync recipes manually across devices.',
      name: 'settings_drive_signed_out_desc',
      desc: '',
      args: [],
    );
  }

  /// `Sign in`
  String get settings_drive_sign_in {
    return Intl.message(
      'Sign in',
      name: 'settings_drive_sign_in',
      desc: '',
      args: [],
    );
  }

  /// `Sign out`
  String get settings_drive_sign_out {
    return Intl.message(
      'Sign out',
      name: 'settings_drive_sign_out',
      desc: '',
      args: [],
    );
  }

  /// `Signing in to Google Drive…`
  String get settings_drive_signing_in {
    return Intl.message(
      'Signing in to Google Drive…',
      name: 'settings_drive_signing_in',
      desc: '',
      args: [],
    );
  }

  /// `Signing out of Google Drive…`
  String get settings_drive_signing_out {
    return Intl.message(
      'Signing out of Google Drive…',
      name: 'settings_drive_signing_out',
      desc: '',
      args: [],
    );
  }

  /// `Couldn’t sign in. Check your connection and try again.`
  String get settings_drive_offline_desc {
    return Intl.message(
      'Couldn’t sign in. Check your connection and try again.',
      name: 'settings_drive_offline_desc',
      desc: '',
      args: [],
    );
  }

  /// `Sync recipes with Google Drive`
  String get settings_drive_sync_title {
    return Intl.message(
      'Sync recipes with Google Drive',
      name: 'settings_drive_sync_title',
      desc: '',
      args: [],
    );
  }

  /// `Manually reconcile local recipes with Google Drive.`
  String get settings_drive_sync_desc {
    return Intl.message(
      'Manually reconcile local recipes with Google Drive.',
      name: 'settings_drive_sync_desc',
      desc: '',
      args: [],
    );
  }

  /// `Comparing local and Google Drive recipes…`
  String get settings_drive_syncing_desc {
    return Intl.message(
      'Comparing local and Google Drive recipes…',
      name: 'settings_drive_syncing_desc',
      desc: '',
      args: [],
    );
  }

  /// `Retry sync`
  String get settings_drive_retry {
    return Intl.message(
      'Retry sync',
      name: 'settings_drive_retry',
      desc: '',
      args: [],
    );
  }

  /// `Cancel sync`
  String get settings_drive_cancel {
    return Intl.message(
      'Cancel sync',
      name: 'settings_drive_cancel',
      desc: '',
      args: [],
    );
  }

  /// `{count, plural, =0{No recipes} =1{1 recipe} other{{count} recipes}}`
  String settings_recipe_count(int count) {
    return Intl.plural(
      count,
      zero: 'No recipes',
      one: '1 recipe',
      other: '$count recipes',
      name: 'settings_recipe_count',
      desc: '',
      args: [count],
    );
  }

  /// `Remove all in-app ads with a one-time purchase.`
  String get settings_pro_desc {
    return Intl.message(
      'Remove all in-app ads with a one-time purchase.',
      name: 'settings_pro_desc',
      desc: '',
      args: [],
    );
  }

  /// `Pro active`
  String get settings_pro_active {
    return Intl.message(
      'Pro active',
      name: 'settings_pro_active',
      desc: '',
      args: [],
    );
  }

  /// `Ads are disabled on this device.`
  String get settings_pro_active_desc {
    return Intl.message(
      'Ads are disabled on this device.',
      name: 'settings_pro_active_desc',
      desc: '',
      args: [],
    );
  }

  /// `Upgrade`
  String get settings_upgrade {
    return Intl.message(
      'Upgrade',
      name: 'settings_upgrade',
      desc: '',
      args: [],
    );
  }

  /// `Watch a video for 30 ad-free minutes`
  String get settings_reward_title {
    return Intl.message(
      'Watch a video for 30 ad-free minutes',
      name: 'settings_reward_title',
      desc: '',
      args: [],
    );
  }

  /// `Each completed video adds 30 minutes without banner ads.`
  String get settings_reward_desc {
    return Intl.message(
      'Each completed video adds 30 minutes without banner ads.',
      name: 'settings_reward_desc',
      desc: '',
      args: [],
    );
  }

  /// `Watch`
  String get settings_watch {
    return Intl.message('Watch', name: 'settings_watch', desc: '', args: []);
  }

  /// `Reload ads without personalization`
  String get settings_ad_preferences_title {
    return Intl.message(
      'Reload ads without personalization',
      name: 'settings_ad_preferences_title',
      desc: '',
      args: [],
    );
  }

  /// `Reloads ads without personalized targeting.`
  String get settings_ad_preferences_desc {
    return Intl.message(
      'Reloads ads without personalized targeting.',
      name: 'settings_ad_preferences_desc',
      desc: '',
      args: [],
    );
  }

  /// `Non-personalized ads enabled`
  String get settings_non_personalized_enabled {
    return Intl.message(
      'Non-personalized ads enabled',
      name: 'settings_non_personalized_enabled',
      desc: '',
      args: [],
    );
  }

  /// `Back up & share recipes`
  String get settings_backup_title {
    return Intl.message(
      'Back up & share recipes',
      name: 'settings_backup_title',
      desc: '',
      args: [],
    );
  }

  /// `Select recipes and share them as a ZIP archive.`
  String get settings_backup_desc {
    return Intl.message(
      'Select recipes and share them as a ZIP archive.',
      name: 'settings_backup_desc',
      desc: '',
      args: [],
    );
  }

  /// `Import local recipe files`
  String get settings_import_local_title {
    return Intl.message(
      'Import local recipe files',
      name: 'settings_import_local_title',
      desc: '',
      args: [],
    );
  }

  /// `Import .zip, .mcb, or .json recipe files.`
  String get settings_import_local_desc {
    return Intl.message(
      'Import .zip, .mcb, or .json recipe files.',
      name: 'settings_import_local_desc',
      desc: '',
      args: [],
    );
  }

  /// `Import recipes from a website`
  String get settings_import_website_title {
    return Intl.message(
      'Import recipes from a website',
      name: 'settings_import_website_title',
      desc: '',
      args: [],
    );
  }

  /// `Paste a recipe URL to extract and save its recipe data.`
  String get settings_import_website_desc {
    return Intl.message(
      'Paste a recipe URL to extract and save its recipe data.',
      name: 'settings_import_website_desc',
      desc: '',
      args: [],
    );
  }

  /// `Create recipes on a computer`
  String get settings_import_pc_title {
    return Intl.message(
      'Create recipes on a computer',
      name: 'settings_import_pc_title',
      desc: '',
      args: [],
    );
  }

  /// `Open the web editor, then transfer its JSON file to this device.`
  String get settings_import_pc_desc {
    return Intl.message(
      'Open the web editor, then transfer its JSON file to this device.',
      name: 'settings_import_pc_desc',
      desc: '',
      args: [],
    );
  }

  /// `Application theme`
  String get settings_theme_title {
    return Intl.message(
      'Application theme',
      name: 'settings_theme_title',
      desc: '',
      args: [],
    );
  }

  /// `Auto`
  String get settings_theme_auto {
    return Intl.message(
      'Auto',
      name: 'settings_theme_auto',
      desc: '',
      args: [],
    );
  }

  /// `Light`
  String get settings_theme_light {
    return Intl.message(
      'Light',
      name: 'settings_theme_light',
      desc: '',
      args: [],
    );
  }

  /// `Dark`
  String get settings_theme_dark {
    return Intl.message(
      'Dark',
      name: 'settings_theme_dark',
      desc: '',
      args: [],
    );
  }

  /// `OLED`
  String get settings_theme_oled {
    return Intl.message(
      'OLED',
      name: 'settings_theme_oled',
      desc: '',
      args: [],
    );
  }

  /// `Keep screen awake`
  String get settings_awake_title {
    return Intl.message(
      'Keep screen awake',
      name: 'settings_awake_title',
      desc: '',
      args: [],
    );
  }

  /// `Keep the display awake while using recipe-related screens.`
  String get settings_awake_desc {
    return Intl.message(
      'Keep the display awake while using recipe-related screens.',
      name: 'settings_awake_desc',
      desc: '',
      args: [],
    );
  }

  /// `Quantity formatting`
  String get settings_quantity_title {
    return Intl.message(
      'Quantity formatting',
      name: 'settings_quantity_title',
      desc: '',
      args: [],
    );
  }

  /// `Choose how ingredient amounts are displayed.`
  String get settings_quantity_desc {
    return Intl.message(
      'Choose how ingredient amounts are displayed.',
      name: 'settings_quantity_desc',
      desc: '',
      args: [],
    );
  }

  /// `Fractions`
  String get settings_fractions {
    return Intl.message(
      'Fractions',
      name: 'settings_fractions',
      desc: '',
      args: [],
    );
  }

  /// `Decimals`
  String get settings_decimals {
    return Intl.message(
      'Decimals',
      name: 'settings_decimals',
      desc: '',
      args: [],
    );
  }

  /// `Complex animations`
  String get settings_animations_title {
    return Intl.message(
      'Complex animations',
      name: 'settings_animations_title',
      desc: '',
      args: [],
    );
  }

  /// `Use animated transitions and interactive motion throughout the app.`
  String get settings_animations_desc {
    return Intl.message(
      'Use animated transitions and interactive motion throughout the app.',
      name: 'settings_animations_desc',
      desc: '',
      args: [],
    );
  }

  /// `Nutrition fields`
  String get settings_nutrition_title {
    return Intl.message(
      'Nutrition fields',
      name: 'settings_nutrition_title',
      desc: '',
      args: [],
    );
  }

  /// `Manage suggestions used while editing recipes. Existing recipes are not changed.`
  String get settings_nutrition_desc {
    return Intl.message(
      'Manage suggestions used while editing recipes. Existing recipes are not changed.',
      name: 'settings_nutrition_desc',
      desc: '',
      args: [],
    );
  }

  /// `Ingredient suggestions`
  String get settings_ingredients_title {
    return Intl.message(
      'Ingredient suggestions',
      name: 'settings_ingredients_title',
      desc: '',
      args: [],
    );
  }

  /// `Manage names suggested while editing and searching. Existing recipes are not changed.`
  String get settings_ingredients_desc {
    return Intl.message(
      'Manage names suggested while editing and searching. Existing recipes are not changed.',
      name: 'settings_ingredients_desc',
      desc: '',
      args: [],
    );
  }

  /// `Recipe tags`
  String get settings_tags_title {
    return Intl.message(
      'Recipe tags',
      name: 'settings_tags_title',
      desc: '',
      args: [],
    );
  }

  /// `Add, rename, recolor, or remove reusable recipe tags.`
  String get settings_tags_desc {
    return Intl.message(
      'Add, rename, recolor, or remove reusable recipe tags.',
      name: 'settings_tags_desc',
      desc: '',
      args: [],
    );
  }

  /// `Recipe categories`
  String get settings_categories_title {
    return Intl.message(
      'Recipe categories',
      name: 'settings_categories_title',
      desc: '',
      args: [],
    );
  }

  /// `Add, rename, reorder, or remove recipe categories.`
  String get settings_categories_desc {
    return Intl.message(
      'Add, rename, reorder, or remove recipe categories.',
      name: 'settings_categories_desc',
      desc: '',
      args: [],
    );
  }

  /// `{count, plural, =0{None} =1{1 item} other{{count} items}}`
  String settings_item_count(int count) {
    return Intl.plural(
      count,
      zero: 'None',
      one: '1 item',
      other: '$count items',
      name: 'settings_item_count',
      desc: '',
      args: [count],
    );
  }

  /// `Replay introduction`
  String get settings_intro_title {
    return Intl.message(
      'Replay introduction',
      name: 'settings_intro_title',
      desc: '',
      args: [],
    );
  }

  /// `Review effort ratings, Cook Mode, ingredient search, shopping lists, and Explore.`
  String get settings_intro_desc {
    return Intl.message(
      'Review effort ratings, Cook Mode, ingredient search, shopping lists, and Explore.',
      name: 'settings_intro_desc',
      desc: '',
      args: [],
    );
  }

  /// `Rate My RecipeBible`
  String get settings_rate_title {
    return Intl.message(
      'Rate My RecipeBible',
      name: 'settings_rate_title',
      desc: '',
      args: [],
    );
  }

  /// `Open the Google Play listing to leave a rating.`
  String get settings_rate_desc {
    return Intl.message(
      'Open the Google Play listing to leave a rating.',
      name: 'settings_rate_desc',
      desc: '',
      args: [],
    );
  }

  /// `About My RecipeBible`
  String get settings_about_title {
    return Intl.message(
      'About My RecipeBible',
      name: 'settings_about_title',
      desc: '',
      args: [],
    );
  }

  /// `Open app details, disclaimer, sharing, and contact options.`
  String get settings_about_desc {
    return Intl.message(
      'Open app details, disclaimer, sharing, and contact options.',
      name: 'settings_about_desc',
      desc: '',
      args: [],
    );
  }

  /// `Designed with patience for mindful kitchens · v{version}`
  String settings_footer(String version) {
    return Intl.message(
      'Designed with patience for mindful kitchens · v$version',
      name: 'settings_footer',
      desc: '',
      args: [version],
    );
  }

  /// `Some legacy recipe data still needs attention`
  String get settings_migration_title {
    return Intl.message(
      'Some legacy recipe data still needs attention',
      name: 'settings_migration_title',
      desc: '',
      args: [],
    );
  }

  /// `{count, plural, =1{1 item could not be read. The legacy backup will be kept until this is resolved.} other{{count} items could not be read. The legacy backup will be kept until this is resolved.}}`
  String settings_migration_desc(int count) {
    return Intl.plural(
      count,
      one: '1 item could not be read. The legacy backup will be kept until this is resolved.',
      other:
          '$count items could not be read. The legacy backup will be kept until this is resolved.',
      name: 'settings_migration_desc',
      desc: '',
      args: [count],
    );
  }

  /// `Retry`
  String get settings_migration_retry {
    return Intl.message(
      'Retry',
      name: 'settings_migration_retry',
      desc: '',
      args: [],
    );
  }

  /// `Share report`
  String get settings_migration_share {
    return Intl.message(
      'Share report',
      name: 'settings_migration_share',
      desc: '',
      args: [],
    );
  }

  /// `Swipe & discover`
  String get explore_discover {
    return Intl.message(
      'Swipe & discover',
      name: 'explore_discover',
      desc: '',
      args: [],
    );
  }

  /// `Card {current} of {total}`
  String explore_card_counter(int current, int total) {
    return Intl.message(
      'Card $current of $total',
      name: 'explore_card_counter',
      desc: '',
      args: [current, total],
    );
  }

  /// `Filters`
  String get explore_filters {
    return Intl.message('Filters', name: 'explore_filters', desc: '', args: []);
  }

  /// `Choose what to explore`
  String get explore_filter_title {
    return Intl.message(
      'Choose what to explore',
      name: 'explore_filter_title',
      desc: '',
      args: [],
    );
  }

  /// `All recipes`
  String get explore_all_recipes {
    return Intl.message(
      'All recipes',
      name: 'explore_all_recipes',
      desc: '',
      args: [],
    );
  }

  /// `Pass`
  String get explore_pass {
    return Intl.message('Pass', name: 'explore_pass', desc: '', args: []);
  }

  /// `Cook tonight`
  String get explore_cook_tonight {
    return Intl.message(
      'Cook tonight',
      name: 'explore_cook_tonight',
      desc: '',
      args: [],
    );
  }

  /// `Saved for later`
  String get explore_saved {
    return Intl.message(
      'Saved for later',
      name: 'explore_saved',
      desc: '',
      args: [],
    );
  }

  /// `Show previous recipe`
  String get explore_rewind {
    return Intl.message(
      'Show previous recipe',
      name: 'explore_rewind',
      desc: '',
      args: [],
    );
  }

  /// `Save for later`
  String get explore_save {
    return Intl.message(
      'Save for later',
      name: 'explore_save',
      desc: '',
      args: [],
    );
  }

  /// `Start cooking`
  String get explore_cook {
    return Intl.message(
      'Start cooking',
      name: 'explore_cook',
      desc: '',
      args: [],
    );
  }

  /// `Open recipe`
  String get explore_open_recipe {
    return Intl.message(
      'Open recipe',
      name: 'explore_open_recipe',
      desc: '',
      args: [],
    );
  }

  /// `Ingredients snapshot`
  String get explore_ingredients_snapshot {
    return Intl.message(
      'Ingredients snapshot',
      name: 'explore_ingredients_snapshot',
      desc: '',
      args: [],
    );
  }

  /// `Nothing to explore here yet`
  String get explore_empty_title {
    return Intl.message(
      'Nothing to explore here yet',
      name: 'explore_empty_title',
      desc: '',
      args: [],
    );
  }

  /// `Choose another filter or add recipes to this collection.`
  String get explore_empty_message {
    return Intl.message(
      'Choose another filter or add recipes to this collection.',
      name: 'explore_empty_message',
      desc: '',
      args: [],
    );
  }

  /// `Change filter`
  String get explore_change_filter {
    return Intl.message(
      'Change filter',
      name: 'explore_change_filter',
      desc: '',
      args: [],
    );
  }

  /// `You’ve explored the whole deck`
  String get explore_complete_title {
    return Intl.message(
      'You’ve explored the whole deck',
      name: 'explore_complete_title',
      desc: '',
      args: [],
    );
  }

  /// `Shuffle the deck to discover these recipes in a fresh order.`
  String get explore_complete_message {
    return Intl.message(
      'Shuffle the deck to discover these recipes in a fresh order.',
      name: 'explore_complete_message',
      desc: '',
      args: [],
    );
  }

  /// `Shuffle & restart`
  String get explore_restart {
    return Intl.message(
      'Shuffle & restart',
      name: 'explore_restart',
      desc: '',
      args: [],
    );
  }

  /// `The recipe deck could not be loaded`
  String get explore_error_title {
    return Intl.message(
      'The recipe deck could not be loaded',
      name: 'explore_error_title',
      desc: '',
      args: [],
    );
  }

  /// `Try loading your recipes again.`
  String get explore_error_message {
    return Intl.message(
      'Try loading your recipes again.',
      name: 'explore_error_message',
      desc: '',
      args: [],
    );
  }

  /// `Try again`
  String get explore_retry {
    return Intl.message('Try again', name: 'explore_retry', desc: '', args: []);
  }

  /// `Effort {effort}/10`
  String explore_effort(int effort) {
    return Intl.message(
      'Effort $effort/10',
      name: 'explore_effort',
      desc: '',
      args: [effort],
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
