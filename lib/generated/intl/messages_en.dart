// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(count) => "Add all (${count}) to shopping list";

  static String m1(newLine) => "Add ${newLine}ingredient";

  static String m2(count) => "Add remaining (${count}) to shopping list";

  static String m3(newLine) => "Add ${newLine}section";

  static String m4(newLine) => "Add ${newLine}step";

  static String m5(count) =>
      "${Intl.plural(count, zero: 'no collections', one: '1 collection', other: '${count} collections')}";

  static String m6(count) =>
      "${Intl.plural(count, zero: 'No saved recipes', one: '1 saved recipe', other: '${count} saved recipes')}";

  static String m7(day) => "Add a recipe for ${day}";

  static String m8(count) =>
      "${Intl.plural(count, one: '1 ingredient line added', other: '${count} ingredient lines added')}";

  static String m9(recipes, ingredients) =>
      "${Intl.plural(recipes, one: '1 recipe', other: '${recipes} recipes')} · ${Intl.plural(ingredients, one: '1 ingredient line', other: '${ingredients} ingredient lines')}";

  static String m10(count) =>
      "${Intl.plural(count, zero: 'No meals', one: '1 meal', other: '${count} meals')}";

  static String m11(recipe) => "More actions for ${recipe}";

  static String m12(count) =>
      "${Intl.plural(count, one: 'Planned once', other: 'Planned ${count} times')}";

  static String m13(recipe) => "${recipe} removed from the plan";

  static String m14(recipe) => "Select ingredients for ${recipe}";

  static String m15(count) =>
      "${Intl.plural(count, zero: 'No ingredients selected', one: '1 ingredient selected', other: '${count} ingredients selected')}";

  static String m16(time) => "Cook ${time}";

  static String m17(effort) => "Effort: ${effort}/10";

  static String m18(time) => "Prep ${time}";

  static String m19(count) => "See all (${count})";

  static String m20(time) => "Total: ${time}";

  static String m21(datatype) =>
      "The datatype of the selected file \"${datatype}\" is not supported\nsupported formats: \".zip\", \".mcb\"";

  static String m22(recipeName) => "Deleted recipe in cloud: ${recipeName}";

  static String m23(recipeName) => "Deleted local recipe: ${recipeName}";

  static String m24(step, total) => "Step ${step} of ${total}";

  static String m25(fileName) => "The file is not supported ${fileName}.";

  static String m65(number) => "For \"${number}\" persons";

  static String m26(recipeName) => "Imported recipe: ${recipeName}";

  static String m27(count) =>
      "${Intl.plural(count, zero: 'No ingredients', one: '1 ingredient', other: '${count} ingredients')}";

  static String m28(count) => "Filters (${count})";

  static String m29(count) =>
      "${Intl.plural(count, zero: 'YOUR BASKET', one: 'YOUR BASKET · 1 INGREDIENT', other: 'YOUR BASKET · ${count} INGREDIENTS')}";

  static String m30(effort) => "Effort ${effort}/10";

  static String m31(count) =>
      "${Intl.plural(count, zero: '(none found)', one: '(1 found)', other: '(${count} found)')}";

  static String m32(count) => "You can search with up to ${count} ingredients.";

  static String m33(matched, total) => "${matched}/${total} ingredients";

  static String m34(matched, total) =>
      "${matched} of ${total} selected ingredients matched";

  static String m35(count) => "≤ ${count} min";

  static String m36(ingredient) => "Remove ${ingredient}";

  static String m37(count) =>
      "${Intl.plural(count, zero: 'No steps', one: '1 sequenced step', other: '${count} sequenced steps')}";

  static String m38(number) => "Instruction ${number}";

  static String m39(name) => "Recipe with name \"${name}\" already exists";

  static String m40(time) => "${time} cook";

  static String m41(effort) => "${effort}/10 Effort";

  static String m42(time) => "${time} prep";

  static String m43(time) => "${time} total";

  static String m44(count) =>
      "${Intl.plural(count, zero: 'No recipes', one: '1 recipe', other: '${count} recipes')}";

  static String m45(count, effort) =>
      "${Intl.plural(count, zero: 'No recipes', one: '1 recipe', other: '${count} recipes')} • Avg effort ${effort}";

  static String m46(newLine) => "Remove ${newLine}ingredient";

  static String m47(newLine) => "Remove ${newLine}section";

  static String m48(newLine) => "Remove ${newLine}step";

  static String m49(version) =>
      "Designed with patience for mindful kitchens · v${version}";

  static String m50(count) =>
      "${Intl.plural(count, zero: 'None', one: '1 item', other: '${count} items')}";

  static String m51(count) =>
      "${Intl.plural(count, one: '1 item could not be read. The legacy backup will be kept until this is resolved.', other: '${count} items could not be read. The legacy backup will be kept until this is resolved.')}";

  static String m52(count) =>
      "${Intl.plural(count, zero: 'No recipes', one: '1 recipe', other: '${count} recipes')}";

  static String m53(link) =>
      "I now manage my recipes with the App My RecipeBible ${link}";

  static String m54(count) =>
      "${Intl.plural(count, one: 'Gathering for 1 recipe', other: 'Gathering for ${count} recipes')}";

  static String m55(count) =>
      "${Intl.plural(count, zero: 'No items', one: '1 item', other: '${count} items')}";

  static String m56(percent) => "${percent}% gathered";

  static String m57(checked, total) => "${checked} of ${total} items gathered";

  static String m58(count) =>
      "${Intl.plural(count, one: 'This removes 1 checked item from your list.', other: 'This removes ${count} checked items from your list.')}";

  static String m59(item) => "Remove ${item}";

  static String m60(count) =>
      "${Intl.plural(count, one: '1 item removed', other: '${count} items removed')}";

  static String m61(value) => "${value} servings";

  static String m62(sort) => "Sort: ${sort}";

  static String m63(recipeName, year, month, day) =>
      "You added ${recipeName} to your the recipe planner for the following date:\n ${year}-${month}-${day}";

  static String m64(recipeName) => "Uploaded recipe: ${recipeName}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about_me": MessageLookupByLibrary.simpleMessage("Info"),
    "ad_free_until": MessageLookupByLibrary.simpleMessage("Ad free until"),
    "add": MessageLookupByLibrary.simpleMessage("Add"),
    "add_all_to_shopping_list": m0,
    "add_cover_photo": MessageLookupByLibrary.simpleMessage("Add cover photo"),
    "add_date": MessageLookupByLibrary.simpleMessage("Select date"),
    "add_favorites": MessageLookupByLibrary.simpleMessage("Add bookmarks"),
    "add_general_info": MessageLookupByLibrary.simpleMessage(
      "Add general info",
    ),
    "add_ingredient": m1,
    "add_ingredients_info": MessageLookupByLibrary.simpleMessage(
      "Add ingredients info",
    ),
    "add_nutrition_item": MessageLookupByLibrary.simpleMessage("Add nutrition"),
    "add_nutritions": MessageLookupByLibrary.simpleMessage("Add nutritions"),
    "add_recipe": MessageLookupByLibrary.simpleMessage("Add recipe"),
    "add_remaining_to_shopping_list": m2,
    "add_section": m3,
    "add_section_to_cart": MessageLookupByLibrary.simpleMessage("Add section"),
    "add_step": m4,
    "add_steps": MessageLookupByLibrary.simpleMessage("Add steps"),
    "add_title": MessageLookupByLibrary.simpleMessage("Add title"),
    "add_title_desc": MessageLookupByLibrary.simpleMessage(
      "To add another section, you need to give the first one a title like e.g. (ingredients for) sauce.",
    ),
    "add_to_calendar": MessageLookupByLibrary.simpleMessage("Add recipe"),
    "add_to_cart": MessageLookupByLibrary.simpleMessage("Add to shopping cart"),
    "add_to_favorites": MessageLookupByLibrary.simpleMessage("Add bookmark"),
    "add_to_shoppingcart": MessageLookupByLibrary.simpleMessage(
      "Add to shoppingcart",
    ),
    "all_categories": MessageLookupByLibrary.simpleMessage("All categories"),
    "all_recipes_filter": MessageLookupByLibrary.simpleMessage("All"),
    "almost_done": MessageLookupByLibrary.simpleMessage("Almost done😊"),
    "alright": MessageLookupByLibrary.simpleMessage("Alright"),
    "amnt": MessageLookupByLibrary.simpleMessage("Amnt"),
    "amount": MessageLookupByLibrary.simpleMessage("Amount"),
    "and_many_more": MessageLookupByLibrary.simpleMessage("And many more!"),
    "apr": MessageLookupByLibrary.simpleMessage("Apr."),
    "april": MessageLookupByLibrary.simpleMessage("April"),
    "ascending": MessageLookupByLibrary.simpleMessage("Ascending"),
    "assign_ingredients": MessageLookupByLibrary.simpleMessage(
      "Assign ingredients",
    ),
    "aug": MessageLookupByLibrary.simpleMessage("Aug."),
    "august": MessageLookupByLibrary.simpleMessage("August"),
    "average_effort": MessageLookupByLibrary.simpleMessage("Avg effort"),
    "back": MessageLookupByLibrary.simpleMessage("Back"),
    "basket": MessageLookupByLibrary.simpleMessage("Shopping"),
    "bookmark_collection_count": m5,
    "bookmark_recipe_count": m6,
    "bookmarked_recipes": MessageLookupByLibrary.simpleMessage(
      "Bookmarked Recipes",
    ),
    "bookmarks_empty_description": MessageLookupByLibrary.simpleMessage(
      "Bookmark a recipe to keep it close at hand.",
    ),
    "buy_pro_version": MessageLookupByLibrary.simpleMessage("Buy pro version"),
    "by_effort": MessageLookupByLibrary.simpleMessage("By effort"),
    "by_ingredientsamount": MessageLookupByLibrary.simpleMessage(
      "By ingredient count",
    ),
    "by_last_modified": MessageLookupByLibrary.simpleMessage(
      "By last modified",
    ),
    "by_name": MessageLookupByLibrary.simpleMessage("By name"),
    "calendar_add_for_day": m7,
    "calendar_add_selected": MessageLookupByLibrary.simpleMessage(
      "Add selected",
    ),
    "calendar_empty_day": MessageLookupByLibrary.simpleMessage(
      "Nothing planned yet",
    ),
    "calendar_export_success": m8,
    "calendar_export_summary": m9,
    "calendar_load_failed": MessageLookupByLibrary.simpleMessage(
      "Your meal plan could not be loaded",
    ),
    "calendar_load_failed_description": MessageLookupByLibrary.simpleMessage(
      "Check your storage and try again.",
    ),
    "calendar_meal_count": m10,
    "calendar_more_actions": m11,
    "calendar_next_week": MessageLookupByLibrary.simpleMessage("Next week"),
    "calendar_no_exportable": MessageLookupByLibrary.simpleMessage(
      "This week has no ingredients to export",
    ),
    "calendar_plan_recipe": MessageLookupByLibrary.simpleMessage("Plan recipe"),
    "calendar_planned_count": m12,
    "calendar_previous_week": MessageLookupByLibrary.simpleMessage(
      "Previous week",
    ),
    "calendar_remove_from_plan": MessageLookupByLibrary.simpleMessage(
      "Remove from plan",
    ),
    "calendar_removed": m13,
    "calendar_review_description": MessageLookupByLibrary.simpleMessage(
      "Adjust servings and unselect anything you already have.",
    ),
    "calendar_review_export": MessageLookupByLibrary.simpleMessage(
      "Review & export",
    ),
    "calendar_review_title": MessageLookupByLibrary.simpleMessage(
      "Review shopping list",
    ),
    "calendar_select_recipe_ingredients": m14,
    "calendar_selected_count": m15,
    "calendar_servings_not_set": MessageLookupByLibrary.simpleMessage(
      "Servings not specified",
    ),
    "calendar_this_week": MessageLookupByLibrary.simpleMessage("This week"),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "cancelling_sync": MessageLookupByLibrary.simpleMessage(
      "Cancelling Sync...",
    ),
    "categories": MessageLookupByLibrary.simpleMessage("Categories"),
    "category": MessageLookupByLibrary.simpleMessage("Category"),
    "category_already_exists": MessageLookupByLibrary.simpleMessage(
      "Category already exists",
    ),
    "category_cook_short": MessageLookupByLibrary.simpleMessage("Cook"),
    "category_cook_value": m16,
    "category_effort_not_set": MessageLookupByLibrary.simpleMessage(
      "Effort not set",
    ),
    "category_effort_value": m17,
    "category_open": MessageLookupByLibrary.simpleMessage("Open"),
    "category_overview_empty_description": MessageLookupByLibrary.simpleMessage(
      "Add your first recipe with the + button and it will appear here.",
    ),
    "category_overview_empty_title": MessageLookupByLibrary.simpleMessage(
      "Your cookbook is ready",
    ),
    "category_prep_short": MessageLookupByLibrary.simpleMessage("Prep"),
    "category_prep_value": m18,
    "category_section_empty": MessageLookupByLibrary.simpleMessage(
      "No recipes in this category yet.",
    ),
    "category_see_all": m19,
    "category_total_short": MessageLookupByLibrary.simpleMessage("Total"),
    "category_total_value": m20,
    "categoryname": MessageLookupByLibrary.simpleMessage("Category name"),
    "categoy": MessageLookupByLibrary.simpleMessage("Category"),
    "change_ad_preferences": MessageLookupByLibrary.simpleMessage(
      "Change ad preferences",
    ),
    "change_cover_photo": MessageLookupByLibrary.simpleMessage(
      "Change cover photo",
    ),
    "check_filled_in_information": MessageLookupByLibrary.simpleMessage(
      "Check filled in information",
    ),
    "check_filled_in_information_description":
        MessageLookupByLibrary.simpleMessage(
          "Please check for any red marked text fields. For the recipename: it shouldn\'t be empty and the name must not exceed 70 characters.",
        ),
    "check_ingredient_section_fields": MessageLookupByLibrary.simpleMessage(
      "Check your ingredients section fields.",
    ),
    "check_ingredient_section_fields_description":
        MessageLookupByLibrary.simpleMessage(
          "If you have multiple sections, you need to provide a title for each section.",
        ),
    "check_ingredients_input": MessageLookupByLibrary.simpleMessage(
      "Check your ingredients input",
    ),
    "check_ingredients_input_description": MessageLookupByLibrary.simpleMessage(
      "Please complete ingredient info. The format must be: \n- ingredients must have a name\n- ingredients with a unit must also have an amount",
    ),
    "check_red_fields_desc": MessageLookupByLibrary.simpleMessage(
      "Fix the issues with the red marked text fields",
    ),
    "choose_a_theme": MessageLookupByLibrary.simpleMessage("Choose a theme"),
    "clean_recipe_info": MessageLookupByLibrary.simpleMessage(
      "Delete recipe data?",
    ),
    "clean_recipe_info_desc": MessageLookupByLibrary.simpleMessage(
      "Are you sure, that you want to delete the prefilled recipe data?",
    ),
    "clear_filters": MessageLookupByLibrary.simpleMessage("Clear filters"),
    "clear_search": MessageLookupByLibrary.simpleMessage("Clear search"),
    "complex_animations": MessageLookupByLibrary.simpleMessage(
      "Enable complex animations",
    ),
    "complexity": MessageLookupByLibrary.simpleMessage("Complexity"),
    "complexity_effort": MessageLookupByLibrary.simpleMessage(
      "Complexity/effort",
    ),
    "contact_me": MessageLookupByLibrary.simpleMessage("Contact me"),
    "continue_to_ingredients": MessageLookupByLibrary.simpleMessage(
      "Continue to ingredients",
    ),
    "continue_to_instructions": MessageLookupByLibrary.simpleMessage(
      "Continue to instructions",
    ),
    "continue_to_nutrition": MessageLookupByLibrary.simpleMessage(
      "Continue to nutrition",
    ),
    "cook_time": MessageLookupByLibrary.simpleMessage("Cook. time"),
    "data_required": MessageLookupByLibrary.simpleMessage("Data_required"),
    "datatype_not_supported": m21,
    "dec": MessageLookupByLibrary.simpleMessage("Dec."),
    "december": MessageLookupByLibrary.simpleMessage("December"),
    "decrease_servings": MessageLookupByLibrary.simpleMessage(
      "Decrease servings",
    ),
    "delete_category": MessageLookupByLibrary.simpleMessage("Delete category?"),
    "delete_ingredient": MessageLookupByLibrary.simpleMessage(
      "Delete ingredient",
    ),
    "delete_nutrition": MessageLookupByLibrary.simpleMessage(
      "Delete nutrition?",
    ),
    "delete_recipe": MessageLookupByLibrary.simpleMessage("Delete recipe"),
    "delete_recipe_tag": MessageLookupByLibrary.simpleMessage(
      "Delete recipe tag?",
    ),
    "delete_section": MessageLookupByLibrary.simpleMessage("Delete section?"),
    "delete_section_desc": MessageLookupByLibrary.simpleMessage(
      "Are you sure, that you want to delete this section with it\'s containing ingredients",
    ),
    "deleting_recipe_drive": m22,
    "deleting_recipe_local": m23,
    "descending": MessageLookupByLibrary.simpleMessage("Descending"),
    "description": MessageLookupByLibrary.simpleMessage("Description"),
    "diet_meat": MessageLookupByLibrary.simpleMessage("Meat"),
    "diet_vegan": MessageLookupByLibrary.simpleMessage("Vegan"),
    "diet_vegetarian": MessageLookupByLibrary.simpleMessage("Vegetarian"),
    "dietary_preference": MessageLookupByLibrary.simpleMessage(
      "Dietary preference",
    ),
    "directions": MessageLookupByLibrary.simpleMessage("Directions"),
    "disclaimer_description": MessageLookupByLibrary.simpleMessage(
      "In no event shall the author of My RecipeBible application be liable for any damages directly or indirectly caused by the application. You are acknowledging that you are 100% responsible for whatever you do with My RecipeBible.",
    ),
    "dish_basics_timing": MessageLookupByLibrary.simpleMessage(
      "Dish basics & timing",
    ),
    "dish_of_the_day": MessageLookupByLibrary.simpleMessage("Dish of the day"),
    "dismiss": MessageLookupByLibrary.simpleMessage("Verbergen"),
    "done": MessageLookupByLibrary.simpleMessage("Done"),
    "duplicate": MessageLookupByLibrary.simpleMessage("Duplicate"),
    "edit": MessageLookupByLibrary.simpleMessage("Edit"),
    "editor_general": MessageLookupByLibrary.simpleMessage("General"),
    "editor_ingredients": MessageLookupByLibrary.simpleMessage("Ingredients"),
    "editor_instructions": MessageLookupByLibrary.simpleMessage("Instructions"),
    "editor_nutrition": MessageLookupByLibrary.simpleMessage("Nutrition"),
    "editor_progress": m24,
    "effort": MessageLookupByLibrary.simpleMessage("Effort"),
    "effort_calibration": MessageLookupByLibrary.simpleMessage(
      "Effort calibration",
    ),
    "enter_some_information": MessageLookupByLibrary.simpleMessage(
      "Enter some ingredients",
    ),
    "enter_url": MessageLookupByLibrary.simpleMessage(
      "Enter URL of website with recipe:",
    ),
    "explore": MessageLookupByLibrary.simpleMessage("Explore"),
    "export_as_text_or_zip": MessageLookupByLibrary.simpleMessage(
      "EXPORT as text or zip",
    ),
    "export_pdf": MessageLookupByLibrary.simpleMessage("Share as PDF"),
    "export_recipe_s": MessageLookupByLibrary.simpleMessage(
      "Share/backup recipe/s",
    ),
    "export_text": MessageLookupByLibrary.simpleMessage("Share in textform"),
    "export_zip": MessageLookupByLibrary.simpleMessage("Share/save as file"),
    "exporting_recipe": MessageLookupByLibrary.simpleMessage(
      "Exporting recipe",
    ),
    "failed": MessageLookupByLibrary.simpleMessage("Failed"),
    "failed_import": MessageLookupByLibrary.simpleMessage("Import failed"),
    "failed_import_desc": MessageLookupByLibrary.simpleMessage(
      "Import failed for unknown reasons. Please switch to the settings tab and import the recipes there.",
    ),
    "failed_import_not_supported": MessageLookupByLibrary.simpleMessage(
      "Import failed. Page seems not yet supported",
    ),
    "failed_loading_ad": MessageLookupByLibrary.simpleMessage(
      "Failed loading ad",
    ),
    "failed_loading_ad_desc": MessageLookupByLibrary.simpleMessage(
      "Solutions can be: better internet connection, tapping \"watch\" again or restarting the app",
    ),
    "failed_sign_in": MessageLookupByLibrary.simpleMessage(
      "Failed to sign in maybe due to no internet",
    ),
    "failed_syncing": MessageLookupByLibrary.simpleMessage(
      "Error occured during syncing, maybe due to bad internet",
    ),
    "failed_to_connect_to_url": MessageLookupByLibrary.simpleMessage(
      "Failed to connect to given url",
    ),
    "failed_to_import_recipe_unknown_reason":
        MessageLookupByLibrary.simpleMessage(
          "Failed to import recipe for an unknown reason",
        ),
    "favorites": MessageLookupByLibrary.simpleMessage("Bookmarks"),
    "feb": MessageLookupByLibrary.simpleMessage("Feb."),
    "february": MessageLookupByLibrary.simpleMessage("February"),
    "field_must_not_be_empty": MessageLookupByLibrary.simpleMessage(
      "Field must not be empty",
    ),
    "file_not_supported": m25,
    "fill_remove_unit": MessageLookupByLibrary.simpleMessage(
      "Fill in/ remove unit",
    ),
    "filter_recipes": MessageLookupByLibrary.simpleMessage("Filter recipes..."),
    "finished": MessageLookupByLibrary.simpleMessage("Finished"),
    "first_start_recipes": MessageLookupByLibrary.simpleMessage(
      "Start Recipes",
    ),
    "first_start_recipes_desc": MessageLookupByLibrary.simpleMessage(
      "A few example recipes in german are already in this app.\nOf course you can delete them.",
    ),
    "for_more_relaxed_shopping_add_to_shoppingcart":
        MessageLookupByLibrary.simpleMessage(
          "You can add the ingredients of your recipe to your shoppingcart for more relaxed shopping.",
        ),
    "for_persons": m65,
    "for_word": MessageLookupByLibrary.simpleMessage("for"),
    "fraction_or_decimal": MessageLookupByLibrary.simpleMessage(
      "Number notation",
    ),
    "fraction_or_decimal_desc": MessageLookupByLibrary.simpleMessage(
      "Enabled: decimal, disabled: fraction",
    ),
    "friday": MessageLookupByLibrary.simpleMessage("Friday"),
    "general_info_changes_will_be_saved": MessageLookupByLibrary.simpleMessage(
      "The changes you make, when adding a recipe are saved, when you go back and forth. So don\'t worry if you mistyped an information on one screen.",
    ),
    "general_infos": MessageLookupByLibrary.simpleMessage("General infos"),
    "grid_view": MessageLookupByLibrary.simpleMessage("Grid"),
    "hide": MessageLookupByLibrary.simpleMessage("Hide"),
    "if_you_cant_decide_random_recipe_explorer":
        MessageLookupByLibrary.simpleMessage(
          "If you can’t decide what to cook, use random-recipe-explorer.",
        ),
    "import": MessageLookupByLibrary.simpleMessage("Import"),
    "import_computer_info": MessageLookupByLibrary.simpleMessage(
      "To create your recipes (at the current state pictures can only be imported in the App)\n\n 2. After generating the file with all the recipes, load it onto your mobile phone. You can also upload it to the cloud if you have access to it on your mobile phone.\n\n3. Then you have two options:\n\n3.1. Tap the generated \".json\" file in your file manager and open it with My RecipeBible or\n\n3.2. Open My RecipeBible and go into the settings and tap \"import recipes\" and select the file to import",
    ),
    "import_from_website": MessageLookupByLibrary.simpleMessage(
      "Import recipes from website",
    ),
    "import_from_website_short": MessageLookupByLibrary.simpleMessage(
      "Import from website",
    ),
    "import_pc_title_info": MessageLookupByLibrary.simpleMessage(
      "Import file from PC",
    ),
    "import_recipe_description": MessageLookupByLibrary.simpleMessage(
      "Supported formats:\n- .zip (file of this app)\n- .mcp",
    ),
    "import_recipe_s": MessageLookupByLibrary.simpleMessage("Import recipe/s"),
    "imported": MessageLookupByLibrary.simpleMessage("Imported"),
    "importing_recipe_drive": m26,
    "importing_recipes": MessageLookupByLibrary.simpleMessage(
      "Importing recipe/s",
    ),
    "in_minutes": MessageLookupByLibrary.simpleMessage("In minutes"),
    "increase_servings": MessageLookupByLibrary.simpleMessage(
      "Increase servings",
    ),
    "info": MessageLookupByLibrary.simpleMessage("Information"),
    "info_export_description": MessageLookupByLibrary.simpleMessage(
      "It\'s recommended to sometimes save your recipes as zip, just i case that your smartphone gets lost or the app breaks for whatever reason.",
    ),
    "information": MessageLookupByLibrary.simpleMessage("Information"),
    "ingredient": MessageLookupByLibrary.simpleMessage("Ingredient"),
    "ingredient_already_exists": MessageLookupByLibrary.simpleMessage(
      "Ingredient already exists",
    ),
    "ingredient_count": m27,
    "ingredient_filter_description": MessageLookupByLibrary.simpleMessage(
      "Purchase pro version in settings to get access to ingredient filter",
    ),
    "ingredient_manager_description": MessageLookupByLibrary.simpleMessage(
      "Here you can manage the ingredients, which you are suggested when adding a recipe or searching for them. When you edit or delete them, only the suggestions are updated and not the recipes with the ingredient.",
    ),
    "ingredient_matches": MessageLookupByLibrary.simpleMessage(
      "Matching ingredients",
    ),
    "ingredient_search_active_filters": m28,
    "ingredient_search_add": MessageLookupByLibrary.simpleMessage(
      "Add ingredient",
    ),
    "ingredient_search_adjust_filters": MessageLookupByLibrary.simpleMessage(
      "Adjust filters",
    ),
    "ingredient_search_all": MessageLookupByLibrary.simpleMessage("All"),
    "ingredient_search_any_effort": MessageLookupByLibrary.simpleMessage(
      "Any effort",
    ),
    "ingredient_search_any_time": MessageLookupByLibrary.simpleMessage(
      "Any time",
    ),
    "ingredient_search_basket_count": m29,
    "ingredient_search_basket_empty": MessageLookupByLibrary.simpleMessage(
      "Add one or more ingredients to start matching your cookbook.",
    ),
    "ingredient_search_clear_all": MessageLookupByLibrary.simpleMessage(
      "Clear all",
    ),
    "ingredient_search_description": MessageLookupByLibrary.simpleMessage(
      "Add ingredients from your kitchen, refine the filters, and find recipes that fit.",
    ),
    "ingredient_search_effort_cap": MessageLookupByLibrary.simpleMessage(
      "EFFORT CAP",
    ),
    "ingredient_search_effort_unknown": MessageLookupByLibrary.simpleMessage(
      "Effort —",
    ),
    "ingredient_search_effort_value": m30,
    "ingredient_search_empty_description": MessageLookupByLibrary.simpleMessage(
      "Add an ingredient or choose a filter to see recipes from your collection.",
    ),
    "ingredient_search_empty_title": MessageLookupByLibrary.simpleMessage(
      "Build your pantry basket",
    ),
    "ingredient_search_failed": MessageLookupByLibrary.simpleMessage(
      "Recipes couldn’t be searched",
    ),
    "ingredient_search_failed_description":
        MessageLookupByLibrary.simpleMessage(
          "Check your storage and try the search again.",
        ),
    "ingredient_search_filters_title": MessageLookupByLibrary.simpleMessage(
      "Refine your matches",
    ),
    "ingredient_search_found": m31,
    "ingredient_search_heading": MessageLookupByLibrary.simpleMessage(
      "Cook from what you have",
    ),
    "ingredient_search_input_hint": MessageLookupByLibrary.simpleMessage(
      "Add an ingredient…",
    ),
    "ingredient_search_limit": m32,
    "ingredient_search_match_badge": m33,
    "ingredient_search_match_summary": m34,
    "ingredient_search_max_time": MessageLookupByLibrary.simpleMessage(
      "MAX TIME",
    ),
    "ingredient_search_meat": MessageLookupByLibrary.simpleMessage("Meat"),
    "ingredient_search_minutes": m35,
    "ingredient_search_more_filters": MessageLookupByLibrary.simpleMessage(
      "More filters",
    ),
    "ingredient_search_no_limit": MessageLookupByLibrary.simpleMessage(
      "No limit",
    ),
    "ingredient_search_no_matches": MessageLookupByLibrary.simpleMessage(
      "No recipes match yet",
    ),
    "ingredient_search_no_matches_description":
        MessageLookupByLibrary.simpleMessage(
          "Try removing an ingredient or widening your time and effort limits.",
        ),
    "ingredient_search_remove": m36,
    "ingredient_search_reset": MessageLookupByLibrary.simpleMessage("Reset"),
    "ingredient_search_results": MessageLookupByLibrary.simpleMessage(
      "Matched recipes",
    ),
    "ingredient_search_sort_best": MessageLookupByLibrary.simpleMessage(
      "Best match",
    ),
    "ingredient_search_sort_effort": MessageLookupByLibrary.simpleMessage(
      "Lowest effort",
    ),
    "ingredient_search_sort_name": MessageLookupByLibrary.simpleMessage(
      "Name A–Z",
    ),
    "ingredient_search_sort_time": MessageLookupByLibrary.simpleMessage(
      "Shortest time",
    ),
    "ingredient_search_time_unknown": MessageLookupByLibrary.simpleMessage(
      "Time not set",
    ),
    "ingredient_search_title": MessageLookupByLibrary.simpleMessage(
      "Ingredient search",
    ),
    "ingredient_search_vegan": MessageLookupByLibrary.simpleMessage("Vegan"),
    "ingredient_search_vegetarian": MessageLookupByLibrary.simpleMessage(
      "Vegetarian",
    ),
    "ingredient_section_empty": MessageLookupByLibrary.simpleMessage(
      "No ingredients in this section yet.",
    ),
    "ingredients": MessageLookupByLibrary.simpleMessage("Ingredients"),
    "ingredients_for": MessageLookupByLibrary.simpleMessage("Ingredients for"),
    "ingredients_for_step": MessageLookupByLibrary.simpleMessage(
      "Ingredients for this step",
    ),
    "instruction_count": m37,
    "instruction_number": m38,
    "instructions_empty": MessageLookupByLibrary.simpleMessage(
      "Start with the first instruction for this recipe.",
    ),
    "invalid_datatype": MessageLookupByLibrary.simpleMessage(
      "Invalid datatype",
    ),
    "invalid_file": MessageLookupByLibrary.simpleMessage("Invalid file"),
    "invalid_name": MessageLookupByLibrary.simpleMessage("Invalid name"),
    "invalid_url": MessageLookupByLibrary.simpleMessage(
      "Unsupported url:\ncheck the info about supported websites in the infopanel below",
    ),
    "jan": MessageLookupByLibrary.simpleMessage("Jan."),
    "january": MessageLookupByLibrary.simpleMessage("January"),
    "jul": MessageLookupByLibrary.simpleMessage("Jul."),
    "july": MessageLookupByLibrary.simpleMessage("July"),
    "jun": MessageLookupByLibrary.simpleMessage("Jun."),
    "june": MessageLookupByLibrary.simpleMessage("June"),
    "keep_screen_on": MessageLookupByLibrary.simpleMessage("Keep screen on"),
    "list_view": MessageLookupByLibrary.simpleMessage("List"),
    "loading_data": MessageLookupByLibrary.simpleMessage("Loading data..."),
    "locale_full": MessageLookupByLibrary.simpleMessage("en_US"),
    "manage_bookmark_collections": MessageLookupByLibrary.simpleMessage(
      "Manage collections",
    ),
    "manage_categories": MessageLookupByLibrary.simpleMessage(
      "Manage categories",
    ),
    "manage_ingredients": MessageLookupByLibrary.simpleMessage(
      "Manage ingredients",
    ),
    "manage_nutritions": MessageLookupByLibrary.simpleMessage(
      "Manage nutritions",
    ),
    "manage_recipe_tags": MessageLookupByLibrary.simpleMessage(
      "Manage recipe tags",
    ),
    "mar": MessageLookupByLibrary.simpleMessage("Mar."),
    "march": MessageLookupByLibrary.simpleMessage("March"),
    "maximum_recipe_pin_count_exceeded": MessageLookupByLibrary.simpleMessage(
      "Maximum pin count of 3 exceeded",
    ),
    "may": MessageLookupByLibrary.simpleMessage("May"),
    "may_full": MessageLookupByLibrary.simpleMessage("May"),
    "maybe_later": MessageLookupByLibrary.simpleMessage("MAYBE LATER"),
    "monday": MessageLookupByLibrary.simpleMessage("Monday"),
    "more_coming_soon": MessageLookupByLibrary.simpleMessage(
      "More coming soon...",
    ),
    "more_filters": MessageLookupByLibrary.simpleMessage("Filters"),
    "multiple_devices_use_export_as_zip_etc":
        MessageLookupByLibrary.simpleMessage(
          "Export your recipes as zip file for using them on multiple devices. Alternatively you can also generate a pdf or text with all the information.",
        ),
    "name": MessageLookupByLibrary.simpleMessage("Name"),
    "need_to_access_storage": MessageLookupByLibrary.simpleMessage(
      "Need to access storage",
    ),
    "need_to_access_storage_desc": MessageLookupByLibrary.simpleMessage(
      "Access to storage required for reading the file from an external location and import it. By pressing ok, you\'ll get a prompt asking you for that",
    ),
    "new_collection": MessageLookupByLibrary.simpleMessage("New"),
    "next": MessageLookupByLibrary.simpleMessage("Next"),
    "no": MessageLookupByLibrary.simpleMessage("No"),
    "no_added_favorites_yet": MessageLookupByLibrary.simpleMessage(
      "You haven\'t added any bookmarks yet",
    ),
    "no_category": MessageLookupByLibrary.simpleMessage("No category"),
    "no_filtered_recipes": MessageLookupByLibrary.simpleMessage(
      "No recipes match these filters",
    ),
    "no_internet_connection": MessageLookupByLibrary.simpleMessage(
      "No internet connection",
    ),
    "no_internet_connection_desc": MessageLookupByLibrary.simpleMessage(
      "Could not connect to the internet and therefore not load the video.",
    ),
    "no_matching_recipes": MessageLookupByLibrary.simpleMessage(
      "No matching recipes",
    ),
    "no_recipe_with_this_name": MessageLookupByLibrary.simpleMessage(
      "You can only add recipes that you have saved in the app.",
    ),
    "no_recipes": MessageLookupByLibrary.simpleMessage("No recipes"),
    "no_recipes_fit_your_filter": MessageLookupByLibrary.simpleMessage(
      "No recipes fit your filter",
    ),
    "no_recipes_for_diet": MessageLookupByLibrary.simpleMessage(
      "You have no recipes for this dietary selection",
    ),
    "no_recipes_in_collection": MessageLookupByLibrary.simpleMessage(
      "No recipes here yet",
    ),
    "no_recipes_under_this_category": MessageLookupByLibrary.simpleMessage(
      "You have no recipes under this category",
    ),
    "no_recipes_with_this_tag": MessageLookupByLibrary.simpleMessage(
      "You have no recipes with this tag",
    ),
    "no_thanks": MessageLookupByLibrary.simpleMessage("NO THANKS"),
    "no_valid_import_file": MessageLookupByLibrary.simpleMessage(
      "No valid importfile",
    ),
    "no_valid_number": MessageLookupByLibrary.simpleMessage("No valid number"),
    "none": MessageLookupByLibrary.simpleMessage("None"),
    "not_required_eg_ingredients_of_sauce":
        MessageLookupByLibrary.simpleMessage(
          "Not required (e.g. ingredients of sauce)",
        ),
    "notes": MessageLookupByLibrary.simpleMessage("Notes"),
    "nothing_to_search_through": MessageLookupByLibrary.simpleMessage(
      "Nothing to search through",
    ),
    "nov": MessageLookupByLibrary.simpleMessage("Nov."),
    "november": MessageLookupByLibrary.simpleMessage("November"),
    "nutrition": MessageLookupByLibrary.simpleMessage("Nutrition"),
    "nutrition_already_exists": MessageLookupByLibrary.simpleMessage(
      "Nutrition already exists",
    ),
    "nutrition_manager_description": MessageLookupByLibrary.simpleMessage(
      "Here you can manage your nutritions. When you edit or delete them, the recipes with the specific nutrition don\'t change. If you want to edit the nutrition of an existing recipe, you have to edit the recipe itself.",
    ),
    "nutrition_value_hint": MessageLookupByLibrary.simpleMessage("E.g. 18 g"),
    "nutritions": MessageLookupByLibrary.simpleMessage("Nutritions"),
    "oct": MessageLookupByLibrary.simpleMessage("Oct."),
    "october": MessageLookupByLibrary.simpleMessage("October"),
    "only_recipe_screen": MessageLookupByLibrary.simpleMessage(
      "Only on recipe screen",
    ),
    "open_recipe": MessageLookupByLibrary.simpleMessage("Open recipe"),
    "out_of": MessageLookupByLibrary.simpleMessage("out of"),
    "pantry_checklist": MessageLookupByLibrary.simpleMessage(
      "Pantry checklist",
    ),
    "pantry_checklist_help": MessageLookupByLibrary.simpleMessage(
      "Tap ingredients to add or remove them from your shopping list.",
    ),
    "persons": MessageLookupByLibrary.simpleMessage("Persons"),
    "pin_recipe": MessageLookupByLibrary.simpleMessage("Pin recipe"),
    "please_enter_a_name": MessageLookupByLibrary.simpleMessage(
      "Please enter a name",
    ),
    "prep_time": MessageLookupByLibrary.simpleMessage("Prep. time"),
    "preparation_timeline": MessageLookupByLibrary.simpleMessage(
      "Preparation timeline",
    ),
    "preperation_time": MessageLookupByLibrary.simpleMessage(
      "Preperation time",
    ),
    "print_recipe": MessageLookupByLibrary.simpleMessage("Print recipe"),
    "pro_version": MessageLookupByLibrary.simpleMessage("Pro version"),
    "pro_version_desc": MessageLookupByLibrary.simpleMessage(
      "Includes ingredient filter, removal of ads and support of future development",
    ),
    "professional_search": MessageLookupByLibrary.simpleMessage(
      "Advanced search",
    ),
    "pull_down_to_refresh": MessageLookupByLibrary.simpleMessage(
      "Pull down to refresh page and show imported recipes",
    ),
    "purchase_pro": MessageLookupByLibrary.simpleMessage(
      "Purchase pro version",
    ),
    "rate": MessageLookupByLibrary.simpleMessage("RATE"),
    "rate_app": MessageLookupByLibrary.simpleMessage("Rate this app"),
    "rate_this_app": MessageLookupByLibrary.simpleMessage("Rate this app"),
    "rate_this_app_desc": MessageLookupByLibrary.simpleMessage(
      "If you like this app, please take a little bit of your time to review it!\nIt really helps us and it shouldn\'t take you more than one minute.",
    ),
    "ready": MessageLookupByLibrary.simpleMessage("Ready"),
    "recipe_already_exists": m39,
    "recipe_bible": MessageLookupByLibrary.simpleMessage("My RecipeBible"),
    "recipe_card_cook_time": m40,
    "recipe_card_effort_value": m41,
    "recipe_card_prep_time": m42,
    "recipe_card_time_unknown": MessageLookupByLibrary.simpleMessage(
      "Time not set",
    ),
    "recipe_card_total_time": m43,
    "recipe_count": m44,
    "recipe_detail": MessageLookupByLibrary.simpleMessage("Recipe detail"),
    "recipe_details": MessageLookupByLibrary.simpleMessage("Recipe details"),
    "recipe_edited_or_deleted": MessageLookupByLibrary.simpleMessage(
      "Recipe has been edited or deleted:\ngo back to man view and view it",
    ),
    "recipe_editor": MessageLookupByLibrary.simpleMessage("Recipe editor"),
    "recipe_for": MessageLookupByLibrary.simpleMessage("Recipe for"),
    "recipe_import_pc_title": MessageLookupByLibrary.simpleMessage(
      "How do I create a recipe on PC and import it in the App?",
    ),
    "recipe_ingredients_empty": MessageLookupByLibrary.simpleMessage(
      "This recipe has no ingredients yet.",
    ),
    "recipe_instructions_empty": MessageLookupByLibrary.simpleMessage(
      "This recipe has no instructions yet.",
    ),
    "recipe_more_actions": MessageLookupByLibrary.simpleMessage(
      "More recipe actions",
    ),
    "recipe_name": MessageLookupByLibrary.simpleMessage("Recipe name"),
    "recipe_overview_failed": MessageLookupByLibrary.simpleMessage(
      "Recipes couldn\'t be loaded",
    ),
    "recipe_overview_failed_description": MessageLookupByLibrary.simpleMessage(
      "Check your storage and try again.",
    ),
    "recipe_pinned_to_overview": MessageLookupByLibrary.simpleMessage(
      "Recipe pinned to overview",
    ),
    "recipe_planer": MessageLookupByLibrary.simpleMessage("Meal planner"),
    "recipe_screen": MessageLookupByLibrary.simpleMessage("Recipe screen"),
    "recipe_studio": MessageLookupByLibrary.simpleMessage("Recipe Studio"),
    "recipe_summary_with_effort": m45,
    "recipe_tag": MessageLookupByLibrary.simpleMessage("Recipetag"),
    "recipe_tag_already_exists": MessageLookupByLibrary.simpleMessage(
      "Recipe tag already exists",
    ),
    "recipe_url": MessageLookupByLibrary.simpleMessage("Recipe-url"),
    "recipename_taken": MessageLookupByLibrary.simpleMessage(
      "Recipename taken",
    ),
    "recipename_taken_description": MessageLookupByLibrary.simpleMessage(
      "Change the recipename to something more detailed or maybe you just forgot, that you already saved this recipe :)",
    ),
    "recipes": MessageLookupByLibrary.simpleMessage("Recipes"),
    "recipes_not_in_overview": MessageLookupByLibrary.simpleMessage(
      "If recipes don\'t show up in overview, pull down to refresh the page or go to another tab and back.",
    ),
    "recipes_not_showing_up": MessageLookupByLibrary.simpleMessage(
      "Recipes not showing up?",
    ),
    "recipes_not_showing_up_desc": MessageLookupByLibrary.simpleMessage(
      "If recipes are missing, scroll down to refresh.",
    ),
    "remaining_time": MessageLookupByLibrary.simpleMessage("Remaining time"),
    "remove_ads_upgrade_in_settings": MessageLookupByLibrary.simpleMessage(
      "Remove ads\nupgrade in settings",
    ),
    "remove_all_from_shopping_list": MessageLookupByLibrary.simpleMessage(
      "Remove all from shopping list",
    ),
    "remove_from_favorites": MessageLookupByLibrary.simpleMessage(
      "Remove bookmark",
    ),
    "remove_ingredient": m46,
    "remove_section": m47,
    "remove_section_from_cart": MessageLookupByLibrary.simpleMessage(
      "Remove section",
    ),
    "remove_step": m48,
    "remove_step_desc": MessageLookupByLibrary.simpleMessage(
      "Do you really want to remove this step with its description?",
    ),
    "retry": MessageLookupByLibrary.simpleMessage("Retry"),
    "roll_the_dice": MessageLookupByLibrary.simpleMessage("Roll the dice"),
    "saturday": MessageLookupByLibrary.simpleMessage("Saturday"),
    "save": MessageLookupByLibrary.simpleMessage("Save"),
    "save_changes": MessageLookupByLibrary.simpleMessage("Save changes"),
    "save_recipe": MessageLookupByLibrary.simpleMessage("Save recipe"),
    "saving_your_input": MessageLookupByLibrary.simpleMessage(
      "Saving your input",
    ),
    "search_bookmarks": MessageLookupByLibrary.simpleMessage(
      "Search saved recipes, ingredients, and tags…",
    ),
    "section_name": MessageLookupByLibrary.simpleMessage("Section name"),
    "select_a_category": MessageLookupByLibrary.simpleMessage(
      "Select a category",
    ),
    "select_a_date_first": MessageLookupByLibrary.simpleMessage(
      "Select a date",
    ),
    "select_all": MessageLookupByLibrary.simpleMessage("Select all"),
    "select_recipe_tags": MessageLookupByLibrary.simpleMessage(
      "Select recipe tags:",
    ),
    "select_recipes": MessageLookupByLibrary.simpleMessage("Select recipes"),
    "select_recipes_to_import": MessageLookupByLibrary.simpleMessage(
      "Select recipe/s to import",
    ),
    "select_subcategories": MessageLookupByLibrary.simpleMessage(
      "Select categories:",
    ),
    "sep": MessageLookupByLibrary.simpleMessage("Sep."),
    "september": MessageLookupByLibrary.simpleMessage("September"),
    "serving_adjuster": MessageLookupByLibrary.simpleMessage(
      "Serving adjuster",
    ),
    "servings": MessageLookupByLibrary.simpleMessage("Servings"),
    "settings": MessageLookupByLibrary.simpleMessage("Settings"),
    "settings_about_desc": MessageLookupByLibrary.simpleMessage(
      "Open app details, disclaimer, sharing, and contact options.",
    ),
    "settings_about_title": MessageLookupByLibrary.simpleMessage(
      "About My RecipeBible",
    ),
    "settings_account_ads": MessageLookupByLibrary.simpleMessage(
      "Account & ads",
    ),
    "settings_ad_preferences_desc": MessageLookupByLibrary.simpleMessage(
      "Reloads ads without personalized targeting.",
    ),
    "settings_ad_preferences_title": MessageLookupByLibrary.simpleMessage(
      "Reload ads without personalization",
    ),
    "settings_animations_desc": MessageLookupByLibrary.simpleMessage(
      "Use animated transitions and interactive motion throughout the app.",
    ),
    "settings_animations_title": MessageLookupByLibrary.simpleMessage(
      "Complex animations",
    ),
    "settings_appearance_display": MessageLookupByLibrary.simpleMessage(
      "Appearance & display",
    ),
    "settings_awake_desc": MessageLookupByLibrary.simpleMessage(
      "Keep the display awake while using recipe-related screens.",
    ),
    "settings_awake_title": MessageLookupByLibrary.simpleMessage(
      "Keep screen awake",
    ),
    "settings_backup_desc": MessageLookupByLibrary.simpleMessage(
      "Select recipes and share them as a ZIP archive.",
    ),
    "settings_backup_title": MessageLookupByLibrary.simpleMessage(
      "Back up & share recipes",
    ),
    "settings_categories_desc": MessageLookupByLibrary.simpleMessage(
      "Add, rename, reorder, or remove recipe categories.",
    ),
    "settings_categories_title": MessageLookupByLibrary.simpleMessage(
      "Recipe categories",
    ),
    "settings_configuration": MessageLookupByLibrary.simpleMessage(
      "Kitchen configuration",
    ),
    "settings_data_sync": MessageLookupByLibrary.simpleMessage("Data & sync"),
    "settings_decimals": MessageLookupByLibrary.simpleMessage("Decimals"),
    "settings_drive_cancel": MessageLookupByLibrary.simpleMessage(
      "Cancel sync",
    ),
    "settings_drive_offline_desc": MessageLookupByLibrary.simpleMessage(
      "Couldn’t sign in. Check your connection and try again.",
    ),
    "settings_drive_retry": MessageLookupByLibrary.simpleMessage("Retry sync"),
    "settings_drive_sign_in": MessageLookupByLibrary.simpleMessage("Sign in"),
    "settings_drive_sign_out": MessageLookupByLibrary.simpleMessage("Sign out"),
    "settings_drive_signed_out_desc": MessageLookupByLibrary.simpleMessage(
      "Sign in to sync recipes manually across devices.",
    ),
    "settings_drive_signing_in": MessageLookupByLibrary.simpleMessage(
      "Signing in to Google Drive…",
    ),
    "settings_drive_signing_out": MessageLookupByLibrary.simpleMessage(
      "Signing out of Google Drive…",
    ),
    "settings_drive_sync_desc": MessageLookupByLibrary.simpleMessage(
      "Manually reconcile local recipes with Google Drive.",
    ),
    "settings_drive_sync_title": MessageLookupByLibrary.simpleMessage(
      "Sync recipes with Google Drive",
    ),
    "settings_drive_syncing_desc": MessageLookupByLibrary.simpleMessage(
      "Comparing local and Google Drive recipes…",
    ),
    "settings_drive_title": MessageLookupByLibrary.simpleMessage(
      "Google Drive",
    ),
    "settings_footer": m49,
    "settings_fractions": MessageLookupByLibrary.simpleMessage("Fractions"),
    "settings_help_about": MessageLookupByLibrary.simpleMessage("Help & about"),
    "settings_import_local_desc": MessageLookupByLibrary.simpleMessage(
      "Import .zip, .mcb, or .json recipe files.",
    ),
    "settings_import_local_title": MessageLookupByLibrary.simpleMessage(
      "Import local recipe files",
    ),
    "settings_import_pc_desc": MessageLookupByLibrary.simpleMessage(
      "Open the web editor, then transfer its JSON file to this device.",
    ),
    "settings_import_pc_title": MessageLookupByLibrary.simpleMessage(
      "Create recipes on a computer",
    ),
    "settings_import_website_desc": MessageLookupByLibrary.simpleMessage(
      "Paste a recipe URL to extract and save its recipe data.",
    ),
    "settings_import_website_title": MessageLookupByLibrary.simpleMessage(
      "Import recipes from a website",
    ),
    "settings_ingredients_desc": MessageLookupByLibrary.simpleMessage(
      "Manage names suggested while editing and searching. Existing recipes are not changed.",
    ),
    "settings_ingredients_title": MessageLookupByLibrary.simpleMessage(
      "Ingredient suggestions",
    ),
    "settings_intro_desc": MessageLookupByLibrary.simpleMessage(
      "Review themes, random discovery, backup, and shopping-list basics.",
    ),
    "settings_intro_title": MessageLookupByLibrary.simpleMessage(
      "Replay introduction",
    ),
    "settings_item_count": m50,
    "settings_migration_desc": m51,
    "settings_migration_retry": MessageLookupByLibrary.simpleMessage("Retry"),
    "settings_migration_share": MessageLookupByLibrary.simpleMessage(
      "Share report",
    ),
    "settings_migration_title": MessageLookupByLibrary.simpleMessage(
      "Some legacy recipe data still needs attention",
    ),
    "settings_non_personalized_enabled": MessageLookupByLibrary.simpleMessage(
      "Non-personalized ads enabled",
    ),
    "settings_nutrition_desc": MessageLookupByLibrary.simpleMessage(
      "Manage suggestions used while editing recipes. Existing recipes are not changed.",
    ),
    "settings_nutrition_title": MessageLookupByLibrary.simpleMessage(
      "Nutrition fields",
    ),
    "settings_pro_active": MessageLookupByLibrary.simpleMessage("Pro active"),
    "settings_pro_active_desc": MessageLookupByLibrary.simpleMessage(
      "Ads are disabled on this device.",
    ),
    "settings_pro_desc": MessageLookupByLibrary.simpleMessage(
      "Remove all in-app ads with a one-time purchase.",
    ),
    "settings_quantity_desc": MessageLookupByLibrary.simpleMessage(
      "Choose how ingredient amounts are displayed.",
    ),
    "settings_quantity_title": MessageLookupByLibrary.simpleMessage(
      "Quantity formatting",
    ),
    "settings_rate_desc": MessageLookupByLibrary.simpleMessage(
      "Open the Google Play listing to leave a rating.",
    ),
    "settings_rate_title": MessageLookupByLibrary.simpleMessage(
      "Rate My RecipeBible",
    ),
    "settings_recipe_catalog": MessageLookupByLibrary.simpleMessage(
      "Recipe catalog",
    ),
    "settings_recipe_count": m52,
    "settings_reward_desc": MessageLookupByLibrary.simpleMessage(
      "Each completed video adds 30 minutes without banner ads.",
    ),
    "settings_reward_title": MessageLookupByLibrary.simpleMessage(
      "Watch a video for 30 ad-free minutes",
    ),
    "settings_tags_desc": MessageLookupByLibrary.simpleMessage(
      "Add, rename, recolor, or remove reusable recipe tags.",
    ),
    "settings_tags_title": MessageLookupByLibrary.simpleMessage("Recipe tags"),
    "settings_theme_auto": MessageLookupByLibrary.simpleMessage("Auto"),
    "settings_theme_dark": MessageLookupByLibrary.simpleMessage("Dark"),
    "settings_theme_light": MessageLookupByLibrary.simpleMessage("Light"),
    "settings_theme_oled": MessageLookupByLibrary.simpleMessage("OLED"),
    "settings_theme_title": MessageLookupByLibrary.simpleMessage(
      "Application theme",
    ),
    "settings_title": MessageLookupByLibrary.simpleMessage(
      "Settings & Preferences",
    ),
    "settings_upgrade": MessageLookupByLibrary.simpleMessage("Upgrade"),
    "settings_watch": MessageLookupByLibrary.simpleMessage("Watch"),
    "share_recipe": MessageLookupByLibrary.simpleMessage("Share recipe"),
    "share_recipes_settings": MessageLookupByLibrary.simpleMessage(
      "Backup/share your recipes",
    ),
    "share_recipes_settings_desc": MessageLookupByLibrary.simpleMessage(
      "On this screen, you can:\n- select the recipes you want to share to a friend as a single file\n- select the recipes you want to save to import on another device or just to make sure, they don\'t get lost.",
    ),
    "share_shopping_list": MessageLookupByLibrary.simpleMessage(
      "Share shopping list",
    ),
    "share_this_app": MessageLookupByLibrary.simpleMessage("Share this app"),
    "share_this_app_desc": m53,
    "share_this_app_title": MessageLookupByLibrary.simpleMessage(
      "Check out this!",
    ),
    "shopping_action_failed": MessageLookupByLibrary.simpleMessage(
      "The shopping list could not be updated. Try again.",
    ),
    "shopping_add_details": MessageLookupByLibrary.simpleMessage(
      "Add ingredient with amount, unit, or recipe",
    ),
    "shopping_adjust_servings": MessageLookupByLibrary.simpleMessage(
      "Adjust servings",
    ),
    "shopping_by_recipe": MessageLookupByLibrary.simpleMessage("By recipe"),
    "shopping_cart_help": MessageLookupByLibrary.simpleMessage(
      "Shoppingcart help",
    ),
    "shopping_cart_help_desc": MessageLookupByLibrary.simpleMessage(
      "To add ingredients to your shopping cart, press the + icon at the bottom right. To remove ingredients from your cart, swype them left or right. You can also delete all ingredients of one recipe by swyping the recipe in one direction.",
    ),
    "shopping_cart_is_empty": MessageLookupByLibrary.simpleMessage(
      "Your shoppingcart is empty",
    ),
    "shopping_empty_description": MessageLookupByLibrary.simpleMessage(
      "Add ingredients here or from one of your recipes.",
    ),
    "shopping_for_recipes": m54,
    "shopping_invalid_servings": MessageLookupByLibrary.simpleMessage(
      "Enter a number greater than zero",
    ),
    "shopping_item_count": m55,
    "shopping_list": MessageLookupByLibrary.simpleMessage("Shopping list"),
    "shopping_load_failed": MessageLookupByLibrary.simpleMessage(
      "Your shopping list could not be loaded",
    ),
    "shopping_load_failed_description": MessageLookupByLibrary.simpleMessage(
      "Check your storage and try again.",
    ),
    "shopping_market_provisions": MessageLookupByLibrary.simpleMessage(
      "MARKET PROVISIONS",
    ),
    "shopping_mode": MessageLookupByLibrary.simpleMessage("Shopping mode"),
    "shopping_mode_active": MessageLookupByLibrary.simpleMessage(
      "Screen stays awake",
    ),
    "shopping_more_actions": MessageLookupByLibrary.simpleMessage(
      "More shopping-list actions",
    ),
    "shopping_other_items": MessageLookupByLibrary.simpleMessage("Other items"),
    "shopping_percent_gathered": m56,
    "shopping_plain_list": MessageLookupByLibrary.simpleMessage("Plain list"),
    "shopping_progress": m57,
    "shopping_quick_add_hint": MessageLookupByLibrary.simpleMessage(
      "Add an ingredient…",
    ),
    "shopping_remove_checked": MessageLookupByLibrary.simpleMessage(
      "Remove checked items",
    ),
    "shopping_remove_checked_description": m58,
    "shopping_remove_checked_title": MessageLookupByLibrary.simpleMessage(
      "Remove gathered items?",
    ),
    "shopping_remove_item": m59,
    "shopping_removed_items": m60,
    "shopping_search_recipes": MessageLookupByLibrary.simpleMessage(
      "Search recipes",
    ),
    "shopping_serving_value": m61,
    "shoppingcart": MessageLookupByLibrary.simpleMessage("Shoppingcart"),
    "show_overview": MessageLookupByLibrary.simpleMessage("Show overview"),
    "skip": MessageLookupByLibrary.simpleMessage("Skip"),
    "snackbar_automatic_theme_applied": MessageLookupByLibrary.simpleMessage(
      "If supported, theme will be applied, when restarting the app :)",
    ),
    "snackbar_bright_theme_applied": MessageLookupByLibrary.simpleMessage(
      "Bright theme applied",
    ),
    "snackbar_dark_theme_applied": MessageLookupByLibrary.simpleMessage(
      "Dark theme applied",
    ),
    "snackbar_midnight_theme_applied": MessageLookupByLibrary.simpleMessage(
      "Midnight theme applied",
    ),
    "sort_by": m62,
    "source": MessageLookupByLibrary.simpleMessage("Source/url"),
    "source_could_not_open": MessageLookupByLibrary.simpleMessage(
      "The recipe source could not be opened.",
    ),
    "standardized_format": MessageLookupByLibrary.simpleMessage(
      "All websites are supported which contain a standardized format. Thet\'s why only a part of the supported websites are listed here. In practise most websites shoulb be supported.",
    ),
    "step_description_hint": MessageLookupByLibrary.simpleMessage(
      "Describe what to do in this step…",
    ),
    "step_title": MessageLookupByLibrary.simpleMessage("Step title (optional)"),
    "steps": MessageLookupByLibrary.simpleMessage("Steps"),
    "steps_info_desc": MessageLookupByLibrary.simpleMessage(
      "If you added multiple steps, you can move them by tapping and holding one step. This feature is only available, if no images for the steps are added. The same with removing steps from the middle.",
    ),
    "steps_intro": MessageLookupByLibrary.simpleMessage(
      "Tap on a step to select it so that you know, what you have to do next",
    ),
    "successful": MessageLookupByLibrary.simpleMessage("Successful"),
    "successfully_synced_drive": MessageLookupByLibrary.simpleMessage(
      "Successfully synced recipes with Google Drive",
    ),
    "summary": MessageLookupByLibrary.simpleMessage("Summary"),
    "sunday": MessageLookupByLibrary.simpleMessage("Sunday"),
    "supported_websites": MessageLookupByLibrary.simpleMessage(
      "Info about supported websites:",
    ),
    "sure_you_want_to_delete_this_category":
        MessageLookupByLibrary.simpleMessage(
          "Are you sure you want to delete this category:",
        ),
    "sure_you_want_to_delete_this_nutrition":
        MessageLookupByLibrary.simpleMessage(
          "Are you sure you want to delete this nutrition:",
        ),
    "sure_you_want_to_delete_this_recipe": MessageLookupByLibrary.simpleMessage(
      "Are you sure that you want to delete this recipe:",
    ),
    "sure_you_want_to_delete_this_recipe_tag":
        MessageLookupByLibrary.simpleMessage(
          "Are you sure you want to delete this recipe tag:",
        ),
    "switch_shopping_cart_look": MessageLookupByLibrary.simpleMessage(
      "Change shopping cart look",
    ),
    "switch_theme": MessageLookupByLibrary.simpleMessage("Change theme"),
    "swype_your_recipes": MessageLookupByLibrary.simpleMessage(
      "Swype your recipes",
    ),
    "sync_recipes_drive": MessageLookupByLibrary.simpleMessage(
      "Sync recipes with Google Drive",
    ),
    "syncing_recipes_drive": MessageLookupByLibrary.simpleMessage(
      "Syncing recipes with Google Drive",
    ),
    "tags": MessageLookupByLibrary.simpleMessage("Tags"),
    "tap_here_to_add_recipe": MessageLookupByLibrary.simpleMessage(
      "Here you can add a new recipe",
    ),
    "tap_here_to_import_recipe_online": MessageLookupByLibrary.simpleMessage(
      "Tap here to imoprt\n a recipe online",
    ),
    "tap_here_to_manage_categories": MessageLookupByLibrary.simpleMessage(
      "Here you can manage\nyour recipe categories",
    ),
    "thursday": MessageLookupByLibrary.simpleMessage("Thursday"),
    "too_many_images_for_the_steps": MessageLookupByLibrary.simpleMessage(
      "Add steps description or remove image/s",
    ),
    "too_many_images_for_the_steps_description":
        MessageLookupByLibrary.simpleMessage(
          "You have added more images for the steps, than steps with a description. So images would get lost. Please fix the issue.",
        ),
    "total_time": MessageLookupByLibrary.simpleMessage("Total time"),
    "tuesday": MessageLookupByLibrary.simpleMessage("Tuesday"),
    "two_char_locale": MessageLookupByLibrary.simpleMessage("EN"),
    "undo": MessageLookupByLibrary.simpleMessage("Undo"),
    "undo_added_to_planner_description": m63,
    "unit": MessageLookupByLibrary.simpleMessage("Unit"),
    "unpin_recipe": MessageLookupByLibrary.simpleMessage("Unpin recipe"),
    "untitled_recipe": MessageLookupByLibrary.simpleMessage("Untitled recipe"),
    "uploading_recipe_drive": m64,
    "values_per_serving_optional": MessageLookupByLibrary.simpleMessage(
      "Values per serving · Optional",
    ),
    "vegan": MessageLookupByLibrary.simpleMessage("Vegan"),
    "vegetarian": MessageLookupByLibrary.simpleMessage("Vegetarian"),
    "video_to_remove_ads": MessageLookupByLibrary.simpleMessage(
      "Watch video ad to remove banner ads",
    ),
    "video_to_remove_ads_desc": MessageLookupByLibrary.simpleMessage(
      "By pressing \"watch\", you\'ll see an advertisement video and no more banner ads will be displayed for 30 min. You can stack this.",
    ),
    "view_intro": MessageLookupByLibrary.simpleMessage("View intro"),
    "visit": MessageLookupByLibrary.simpleMessage("1. Visit "),
    "watch": MessageLookupByLibrary.simpleMessage("Watch"),
    "watch_video_remove_ads": MessageLookupByLibrary.simpleMessage(
      "Watch video → remove ads",
    ),
    "website_import_info": MessageLookupByLibrary.simpleMessage(
      "To import recipes faster from the internet, use the share functionality of your preferred browser and select this app, to instantly import it without having to copy the link.",
    ),
    "wednesday": MessageLookupByLibrary.simpleMessage("Wednesday"),
    "with_meat": MessageLookupByLibrary.simpleMessage("With meat"),
    "yes": MessageLookupByLibrary.simpleMessage("Yes"),
    "yield_portions": MessageLookupByLibrary.simpleMessage("Yield & portions"),
    "you_already_have": MessageLookupByLibrary.simpleMessage(
      "You already have",
    ),
    "you_have_no_categories": MessageLookupByLibrary.simpleMessage(
      "You have no categories",
    ),
    "you_have_no_ingredients": MessageLookupByLibrary.simpleMessage(
      "You have no ingredients",
    ),
    "you_have_no_nutritions": MessageLookupByLibrary.simpleMessage(
      "You have no nutritions",
    ),
    "you_have_no_recipe_tags": MessageLookupByLibrary.simpleMessage(
      "You have no recipe tags",
    ),
    "you_made_it_to_the_end": MessageLookupByLibrary.simpleMessage(
      "You made it to the end",
    ),
    "your": MessageLookupByLibrary.simpleMessage("Your"),
  };
}
