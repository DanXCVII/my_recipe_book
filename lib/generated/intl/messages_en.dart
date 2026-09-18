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

  static String m16(position) => "Order ${position}";

  static String m17(name, hex) => "${name}, ${hex}";

  static String m18(name) => "Delete “${name}”?";

  static String m19(name) => "Delete “${name}”?";

  static String m20(name) => "Delete “${name}”?";

  static String m21(name) => "More actions for ${name}";

  static String m22(position) => "Order ${position}";

  static String m23(name) => "Reorder ${name}";

  static String m24(name) => "Reorder ${name}";

  static String m25(time) => "Cook ${time}";

  static String m26(effort) => "Effort: ${effort}/10";

  static String m27(time) => "Prep ${time}";

  static String m28(count) => "See all (${count})";

  static String m29(time) => "Total: ${time}";

  static String m30(recipe) => "Active phase · ${recipe}";

  static String m31(percent) => "${percent}% complete";

  static String m32(count) => "Required for this step (${count})";

  static String m33(number) => "Step ${number}";

  static String m34(step, total) => "Step ${step} of ${total}";

  static String m35(query) => "No results for “${query}”";

  static String m36(datatype) =>
      "The datatype of the selected file \"${datatype}\" is not supported\nsupported formats: \".zip\", \".mcb\"";

  static String m37(recipeName) => "Deleted recipe in cloud: ${recipeName}";

  static String m38(recipeName) => "Deleted local recipe: ${recipeName}";

  static String m39(step, total) => "Step ${step} of ${total}";

  static String m40(current, total) => "Card ${current} of ${total}";

  static String m41(effort) => "Effort ${effort}/10";

  static String m42(fileName) => "The file is not supported ${fileName}.";

  static String m88(number) => "For \"${number}\" persons";

  static String m43(recipeName) => "Imported recipe: ${recipeName}";

  static String m44(count) =>
      "${Intl.plural(count, zero: 'No ingredients', one: '1 ingredient', other: '${count} ingredients')}";

  static String m45(count) => "Filters (${count})";

  static String m46(count) =>
      "${Intl.plural(count, zero: 'YOUR BASKET', one: 'YOUR BASKET · 1 INGREDIENT', other: 'YOUR BASKET · ${count} INGREDIENTS')}";

  static String m47(effort) => "Effort ${effort}/10";

  static String m48(count) =>
      "${Intl.plural(count, zero: '(none found)', one: '(1 found)', other: '(${count} found)')}";

  static String m49(count) => "You can search with up to ${count} ingredients.";

  static String m50(matched, total) => "${matched}/${total} ingredients";

  static String m51(matched, total) =>
      "${matched} of ${total} selected ingredients matched";

  static String m52(count) => "≤ ${count} min";

  static String m53(ingredient) => "Remove ${ingredient}";

  static String m54(count) =>
      "${Intl.plural(count, zero: 'No steps', one: '1 sequenced step', other: '${count} sequenced steps')}";

  static String m55(number) => "Instruction ${number}";

  static String m56(effort) => "Effort ${effort}/10";

  static String m57(effort) => "Choose effort level ${effort}";

  static String m58(effort) => "LEVEL ${effort} / 10";

  static String m59(current, total) => "Card ${current} of ${total}";

  static String m60(matched, total) => "${matched}/${total} INGREDIENTS MATCH";

  static String m61(current, total) => "Step ${current} of ${total}";

  static String m62(name) => "Recipe with name \"${name}\" already exists";

  static String m63(time) => "${time} cook";

  static String m64(effort) => "${effort}/10 Effort";

  static String m65(time) => "${time} prep";

  static String m66(time) => "${time} total";

  static String m67(count) =>
      "${Intl.plural(count, zero: 'No recipes', one: '1 recipe', other: '${count} recipes')}";

  static String m68(count, effort) =>
      "${Intl.plural(count, zero: 'No recipes', one: '1 recipe', other: '${count} recipes')} • Avg effort ${effort}";

  static String m69(newLine) => "Remove ${newLine}ingredient";

  static String m70(newLine) => "Remove ${newLine}section";

  static String m71(newLine) => "Remove ${newLine}step";

  static String m72(version) =>
      "Designed with patience for mindful kitchens · v${version}";

  static String m73(count) =>
      "${Intl.plural(count, zero: 'None', one: '1 item', other: '${count} items')}";

  static String m74(count) =>
      "${Intl.plural(count, one: '1 item could not be read. The legacy backup will be kept until this is resolved.', other: '${count} items could not be read. The legacy backup will be kept until this is resolved.')}";

  static String m75(count) =>
      "${Intl.plural(count, zero: 'No recipes', one: '1 recipe', other: '${count} recipes')}";

  static String m76(link) =>
      "I use My RecipeBible to keep my recipes organized and close at hand: ${link}";

  static String m77(count) =>
      "${Intl.plural(count, one: 'Gathering for 1 recipe', other: 'Gathering for ${count} recipes')}";

  static String m78(count) =>
      "${Intl.plural(count, zero: 'No items', one: '1 item', other: '${count} items')}";

  static String m79(percent) => "${percent}% gathered";

  static String m80(checked, total) => "${checked} of ${total} items gathered";

  static String m81(count) =>
      "${Intl.plural(count, one: 'This removes 1 checked item from your list.', other: 'This removes ${count} checked items from your list.')}";

  static String m82(item) => "Remove ${item}";

  static String m83(count) =>
      "${Intl.plural(count, one: '1 item removed', other: '${count} items removed')}";

  static String m84(value) => "${value} servings";

  static String m85(sort) => "Sort: ${sort}";

  static String m86(recipeName, year, month, day) =>
      "You added ${recipeName} to your the recipe planner for the following date:\n ${year}-${month}-${day}";

  static String m87(recipeName) => "Uploaded recipe: ${recipeName}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about_contact_description": MessageLookupByLibrary.simpleMessage(
      "Send feedback, questions, or ideas directly.",
    ),
    "about_contact_failed": MessageLookupByLibrary.simpleMessage(
      "Couldn’t open your email app. Please try again.",
    ),
    "about_contact_title": MessageLookupByLibrary.simpleMessage(
      "Email the developer",
    ),
    "about_description": MessageLookupByLibrary.simpleMessage(
      "Save, organize, and cook from the recipes that matter to you.",
    ),
    "about_details_section": MessageLookupByLibrary.simpleMessage(
      "App details",
    ),
    "about_disclaimer_summary": MessageLookupByLibrary.simpleMessage(
      "Read important information about responsibility and use.",
    ),
    "about_disclaimer_title": MessageLookupByLibrary.simpleMessage(
      "Disclaimer",
    ),
    "about_licenses_description": MessageLookupByLibrary.simpleMessage(
      "Review licenses for the software used by this app.",
    ),
    "about_licenses_title": MessageLookupByLibrary.simpleMessage(
      "Open-source licenses",
    ),
    "about_made_in_muenster": MessageLookupByLibrary.simpleMessage(
      "Made with care in Münster.",
    ),
    "about_me": MessageLookupByLibrary.simpleMessage("Info"),
    "about_rate_description": MessageLookupByLibrary.simpleMessage(
      "Leave a review and help others discover the app.",
    ),
    "about_rate_failed": MessageLookupByLibrary.simpleMessage(
      "Couldn’t open Google Play. Check your connection and try again.",
    ),
    "about_rate_title": MessageLookupByLibrary.simpleMessage(
      "Rate on Google Play",
    ),
    "about_share_description": MessageLookupByLibrary.simpleMessage(
      "Send My RecipeBible to friends and family.",
    ),
    "about_share_failed": MessageLookupByLibrary.simpleMessage(
      "Couldn’t open the share sheet. Please try again.",
    ),
    "about_share_title": MessageLookupByLibrary.simpleMessage("Share this app"),
    "about_support_section": MessageLookupByLibrary.simpleMessage(
      "Support & connect",
    ),
    "about_tagline": MessageLookupByLibrary.simpleMessage(
      "Your personal cookbook—offline, organized, and yours.",
    ),
    "about_title": MessageLookupByLibrary.simpleMessage("About & support"),
    "about_version_title": MessageLookupByLibrary.simpleMessage("Version"),
    "about_version_unavailable": MessageLookupByLibrary.simpleMessage(
      "Unavailable",
    ),
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
    "all_categories": MessageLookupByLibrary.simpleMessage("All categories"),
    "all_recipes_filter": MessageLookupByLibrary.simpleMessage("All"),
    "almost_done": MessageLookupByLibrary.simpleMessage("Almost done😊"),
    "alright": MessageLookupByLibrary.simpleMessage("Alright"),
    "amnt": MessageLookupByLibrary.simpleMessage("Amnt"),
    "amount": MessageLookupByLibrary.simpleMessage("Amount"),
    "and_many_more": MessageLookupByLibrary.simpleMessage(
      "And many more recipe sites.",
    ),
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
    "catalog_add_category": MessageLookupByLibrary.simpleMessage(
      "Add category",
    ),
    "catalog_add_nutrition": MessageLookupByLibrary.simpleMessage(
      "Add nutrition label",
    ),
    "catalog_add_tag": MessageLookupByLibrary.simpleMessage("Add tag"),
    "catalog_categories_description": MessageLookupByLibrary.simpleMessage(
      "Set the order categories use across your cookbook. Drag the handle to reorganize them.",
    ),
    "catalog_categories_empty_description":
        MessageLookupByLibrary.simpleMessage(
          "Create a category to group recipes by meal, occasion, cuisine, or any system that fits your cookbook.",
        ),
    "catalog_categories_empty_title": MessageLookupByLibrary.simpleMessage(
      "No categories yet",
    ),
    "catalog_category_order": m16,
    "catalog_choose_tag_color": MessageLookupByLibrary.simpleMessage(
      "Choose a tag color",
    ),
    "catalog_color_blue": MessageLookupByLibrary.simpleMessage("Blue"),
    "catalog_color_blue_grey": MessageLookupByLibrary.simpleMessage(
      "Blue grey",
    ),
    "catalog_color_brown": MessageLookupByLibrary.simpleMessage("Brown"),
    "catalog_color_green": MessageLookupByLibrary.simpleMessage("Green"),
    "catalog_color_indigo": MessageLookupByLibrary.simpleMessage("Indigo"),
    "catalog_color_olive": MessageLookupByLibrary.simpleMessage("Olive green"),
    "catalog_color_orange": MessageLookupByLibrary.simpleMessage("Orange"),
    "catalog_color_paprika": MessageLookupByLibrary.simpleMessage("Paprika"),
    "catalog_color_pink": MessageLookupByLibrary.simpleMessage("Pink"),
    "catalog_color_purple": MessageLookupByLibrary.simpleMessage("Purple"),
    "catalog_color_red": MessageLookupByLibrary.simpleMessage("Red"),
    "catalog_color_swatch": m17,
    "catalog_color_teal": MessageLookupByLibrary.simpleMessage("Teal"),
    "catalog_custom_tag_color": MessageLookupByLibrary.simpleMessage(
      "More colors",
    ),
    "catalog_delete_category_description": MessageLookupByLibrary.simpleMessage(
      "Recipes will stay in your cookbook. This category will be removed from every recipe that uses it.",
    ),
    "catalog_delete_category_title": m18,
    "catalog_delete_nutrition_description":
        MessageLookupByLibrary.simpleMessage(
          "Existing recipes keep their saved nutrition values. This label will only be removed from the list available when editing recipes.",
        ),
    "catalog_delete_nutrition_title": m19,
    "catalog_delete_tag_description": MessageLookupByLibrary.simpleMessage(
      "Recipes will stay in your cookbook. This tag will be removed from every recipe that uses it.",
    ),
    "catalog_delete_tag_title": m20,
    "catalog_edit_category": MessageLookupByLibrary.simpleMessage(
      "Edit category",
    ),
    "catalog_edit_nutrition": MessageLookupByLibrary.simpleMessage(
      "Edit nutrition label",
    ),
    "catalog_edit_tag": MessageLookupByLibrary.simpleMessage("Edit tag"),
    "catalog_more_actions": m21,
    "catalog_nutrition_order": m22,
    "catalog_nutritions_description": MessageLookupByLibrary.simpleMessage(
      "Choose and order the nutrition labels available while editing recipes. Changes here do not alter values already saved to recipes.",
    ),
    "catalog_nutritions_empty_description":
        MessageLookupByLibrary.simpleMessage(
          "Add labels such as Energy, Protein, Fiber, or Salt so they are ready when you edit a recipe.",
        ),
    "catalog_nutritions_empty_title": MessageLookupByLibrary.simpleMessage(
      "No nutrition labels yet",
    ),
    "catalog_reorder_category": m23,
    "catalog_reorder_nutrition": m24,
    "catalog_tag_preview": MessageLookupByLibrary.simpleMessage("Tag preview"),
    "catalog_tag_row_description": MessageLookupByLibrary.simpleMessage(
      "Color-coded recipe tag",
    ),
    "catalog_tags_description": MessageLookupByLibrary.simpleMessage(
      "Use color-coded tags to make recipes easier to spot, group, and filter.",
    ),
    "catalog_tags_empty_description": MessageLookupByLibrary.simpleMessage(
      "Create a color-coded tag for themes such as quick, seasonal, family favorite, or meal prep.",
    ),
    "catalog_tags_empty_title": MessageLookupByLibrary.simpleMessage(
      "No recipe tags yet",
    ),
    "categories": MessageLookupByLibrary.simpleMessage("Categories"),
    "category": MessageLookupByLibrary.simpleMessage("Category"),
    "category_already_exists": MessageLookupByLibrary.simpleMessage(
      "Category already exists",
    ),
    "category_cook_short": MessageLookupByLibrary.simpleMessage("Cook"),
    "category_cook_value": m25,
    "category_effort_not_set": MessageLookupByLibrary.simpleMessage(
      "Effort not set",
    ),
    "category_effort_value": m26,
    "category_open": MessageLookupByLibrary.simpleMessage("Open"),
    "category_overview_empty_description": MessageLookupByLibrary.simpleMessage(
      "Add your first recipe with the + button and it will appear here.",
    ),
    "category_overview_empty_title": MessageLookupByLibrary.simpleMessage(
      "Your cookbook is ready",
    ),
    "category_prep_short": MessageLookupByLibrary.simpleMessage("Prep"),
    "category_prep_value": m27,
    "category_section_empty": MessageLookupByLibrary.simpleMessage(
      "No recipes in this category yet.",
    ),
    "category_see_all": m28,
    "category_start": MessageLookupByLibrary.simpleMessage("Start"),
    "category_total_short": MessageLookupByLibrary.simpleMessage("Total"),
    "category_total_value": m29,
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
    "clean_recipe_info": MessageLookupByLibrary.simpleMessage(
      "Delete recipe data?",
    ),
    "clean_recipe_info_desc": MessageLookupByLibrary.simpleMessage(
      "Are you sure, that you want to delete the prefilled recipe data?",
    ),
    "clear_filters": MessageLookupByLibrary.simpleMessage("Clear filters"),
    "clear_search": MessageLookupByLibrary.simpleMessage("Clear search"),
    "close_recipe_actions": MessageLookupByLibrary.simpleMessage(
      "Close recipe actions",
    ),
    "collapse": MessageLookupByLibrary.simpleMessage("Collapse"),
    "collapse_dish_of_the_day": MessageLookupByLibrary.simpleMessage(
      "Collapse Dish of the Day",
    ),
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
    "cook_mode_active_phase": m30,
    "cook_mode_add_minute": MessageLookupByLibrary.simpleMessage(
      "Add one minute",
    ),
    "cook_mode_add_minute_compact": MessageLookupByLibrary.simpleMessage(
      "+1 min",
    ),
    "cook_mode_allow_sleep": MessageLookupByLibrary.simpleMessage(
      "Allow screen to sleep",
    ),
    "cook_mode_assistant": MessageLookupByLibrary.simpleMessage(
      "Cooking assistant",
    ),
    "cook_mode_cancel_timer": MessageLookupByLibrary.simpleMessage(
      "Cancel timer",
    ),
    "cook_mode_collapse_timer": MessageLookupByLibrary.simpleMessage(
      "Collapse timer",
    ),
    "cook_mode_end_session": MessageLookupByLibrary.simpleMessage(
      "End session",
    ),
    "cook_mode_exit_message": MessageLookupByLibrary.simpleMessage(
      "Leaving will stop the active timer and discard this cook session.",
    ),
    "cook_mode_exit_title": MessageLookupByLibrary.simpleMessage(
      "End cook mode?",
    ),
    "cook_mode_expand_timer": MessageLookupByLibrary.simpleMessage(
      "Expand timer",
    ),
    "cook_mode_finish": MessageLookupByLibrary.simpleMessage("Finish"),
    "cook_mode_finish_and_stop": MessageLookupByLibrary.simpleMessage(
      "Finish and stop timer",
    ),
    "cook_mode_finish_message": MessageLookupByLibrary.simpleMessage(
      "You have reached the final step.",
    ),
    "cook_mode_finish_timer_message": MessageLookupByLibrary.simpleMessage(
      "You have reached the final step. Finishing will also stop the active timer.",
    ),
    "cook_mode_finish_title": MessageLookupByLibrary.simpleMessage(
      "Cooking complete",
    ),
    "cook_mode_keep_awake": MessageLookupByLibrary.simpleMessage(
      "Keep screen awake",
    ),
    "cook_mode_next": MessageLookupByLibrary.simpleMessage("Next"),
    "cook_mode_no_assigned_ingredients": MessageLookupByLibrary.simpleMessage(
      "No ingredients are assigned to this step.",
    ),
    "cook_mode_pause_timer": MessageLookupByLibrary.simpleMessage(
      "Pause timer",
    ),
    "cook_mode_percent_complete": m31,
    "cook_mode_prepared": MessageLookupByLibrary.simpleMessage("Prepared"),
    "cook_mode_previous": MessageLookupByLibrary.simpleMessage("Previous"),
    "cook_mode_required_ingredients": m32,
    "cook_mode_reset_timer": MessageLookupByLibrary.simpleMessage(
      "Reset timer",
    ),
    "cook_mode_restart_timer": MessageLookupByLibrary.simpleMessage("Restart"),
    "cook_mode_resume_timer": MessageLookupByLibrary.simpleMessage(
      "Resume timer",
    ),
    "cook_mode_set_timer": MessageLookupByLibrary.simpleMessage("Set time"),
    "cook_mode_start_timer": MessageLookupByLibrary.simpleMessage(
      "Start timer",
    ),
    "cook_mode_stay": MessageLookupByLibrary.simpleMessage("Keep cooking"),
    "cook_mode_step_fallback": m33,
    "cook_mode_step_instructions": MessageLookupByLibrary.simpleMessage(
      "Step instructions",
    ),
    "cook_mode_step_progress": m34,
    "cook_mode_timer": MessageLookupByLibrary.simpleMessage("Timer"),
    "cook_mode_timer_complete": MessageLookupByLibrary.simpleMessage(
      "Timer complete",
    ),
    "cook_mode_timer_complete_message": MessageLookupByLibrary.simpleMessage(
      "Time is up for this cooking step.",
    ),
    "cook_mode_timer_hours": MessageLookupByLibrary.simpleMessage("Hours"),
    "cook_mode_timer_invalid": MessageLookupByLibrary.simpleMessage(
      "Enter a duration greater than zero.",
    ),
    "cook_mode_timer_minutes": MessageLookupByLibrary.simpleMessage("Minutes"),
    "cook_mode_timer_save": MessageLookupByLibrary.simpleMessage("Set timer"),
    "cook_mode_timer_seconds": MessageLookupByLibrary.simpleMessage("Seconds"),
    "cook_mode_timer_sheet_title": MessageLookupByLibrary.simpleMessage(
      "Set cooking timer",
    ),
    "cook_mode_title": MessageLookupByLibrary.simpleMessage("Cook mode"),
    "cook_time": MessageLookupByLibrary.simpleMessage("Cook. time"),
    "cookbook_search_empty_description": MessageLookupByLibrary.simpleMessage(
      "Add a recipe, category, or tag and it will become searchable here.",
    ),
    "cookbook_search_hint": MessageLookupByLibrary.simpleMessage(
      "Search recipes, categories, or tags",
    ),
    "cookbook_search_no_results_description":
        MessageLookupByLibrary.simpleMessage(
          "Try another recipe name, category, or tag.",
        ),
    "cookbook_search_no_results_title": m35,
    "cookbook_search_prompt_description": MessageLookupByLibrary.simpleMessage(
      "Search your cookbook by recipe name, category, or tag.",
    ),
    "cookbook_search_prompt_title": MessageLookupByLibrary.simpleMessage(
      "What would you like to cook?",
    ),
    "cookbook_search_recipe_missing": MessageLookupByLibrary.simpleMessage(
      "This recipe is no longer available.",
    ),
    "create_manually": MessageLookupByLibrary.simpleMessage("Create manually"),
    "data_required": MessageLookupByLibrary.simpleMessage("Data_required"),
    "datatype_not_supported": m36,
    "dec": MessageLookupByLibrary.simpleMessage("Dec."),
    "december": MessageLookupByLibrary.simpleMessage("December"),
    "decrease_servings": MessageLookupByLibrary.simpleMessage(
      "Decrease servings",
    ),
    "delete": MessageLookupByLibrary.simpleMessage("Delete"),
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
    "deleting_recipe_drive": m37,
    "deleting_recipe_local": m38,
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
    "editor_progress": m39,
    "effort": MessageLookupByLibrary.simpleMessage("Effort"),
    "effort_calibration": MessageLookupByLibrary.simpleMessage(
      "Effort calibration",
    ),
    "enter_some_information": MessageLookupByLibrary.simpleMessage(
      "Enter some ingredients",
    ),
    "enter_url": MessageLookupByLibrary.simpleMessage("Recipe link"),
    "expand_dish_of_the_day": MessageLookupByLibrary.simpleMessage(
      "Expand Dish of the Day",
    ),
    "explore": MessageLookupByLibrary.simpleMessage("Explore"),
    "explore_all_recipes": MessageLookupByLibrary.simpleMessage("All recipes"),
    "explore_card_counter": m40,
    "explore_change_filter": MessageLookupByLibrary.simpleMessage(
      "Change filter",
    ),
    "explore_complete_message": MessageLookupByLibrary.simpleMessage(
      "Shuffle the deck to discover these recipes in a fresh order.",
    ),
    "explore_complete_title": MessageLookupByLibrary.simpleMessage(
      "You’ve explored the whole deck",
    ),
    "explore_cook": MessageLookupByLibrary.simpleMessage("Start cooking"),
    "explore_cook_tonight": MessageLookupByLibrary.simpleMessage(
      "Cook tonight",
    ),
    "explore_discover": MessageLookupByLibrary.simpleMessage(
      "Swipe & discover",
    ),
    "explore_effort": m41,
    "explore_empty_message": MessageLookupByLibrary.simpleMessage(
      "Choose another filter or add recipes to this collection.",
    ),
    "explore_empty_title": MessageLookupByLibrary.simpleMessage(
      "Nothing to explore here yet",
    ),
    "explore_error_message": MessageLookupByLibrary.simpleMessage(
      "Try loading your recipes again.",
    ),
    "explore_error_title": MessageLookupByLibrary.simpleMessage(
      "The recipe deck could not be loaded",
    ),
    "explore_filter_title": MessageLookupByLibrary.simpleMessage(
      "Choose what to explore",
    ),
    "explore_filters": MessageLookupByLibrary.simpleMessage("Filters"),
    "explore_ingredients_snapshot": MessageLookupByLibrary.simpleMessage(
      "Ingredients snapshot",
    ),
    "explore_open_recipe": MessageLookupByLibrary.simpleMessage("Open recipe"),
    "explore_pass": MessageLookupByLibrary.simpleMessage("Pass"),
    "explore_restart": MessageLookupByLibrary.simpleMessage(
      "Shuffle & restart",
    ),
    "explore_retry": MessageLookupByLibrary.simpleMessage("Try again"),
    "explore_rewind": MessageLookupByLibrary.simpleMessage(
      "Show previous recipe",
    ),
    "explore_save": MessageLookupByLibrary.simpleMessage("Save for later"),
    "explore_saved": MessageLookupByLibrary.simpleMessage("Saved for later"),
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
      "Could not connect to the recipe page",
    ),
    "failed_to_import_recipe_unknown_reason":
        MessageLookupByLibrary.simpleMessage(
          "The recipe could not be imported",
        ),
    "favorites": MessageLookupByLibrary.simpleMessage("Bookmarks"),
    "feb": MessageLookupByLibrary.simpleMessage("Feb."),
    "february": MessageLookupByLibrary.simpleMessage("February"),
    "field_must_not_be_empty": MessageLookupByLibrary.simpleMessage(
      "Field must not be empty",
    ),
    "file_not_supported": m42,
    "fill_remove_unit": MessageLookupByLibrary.simpleMessage(
      "Fill in/ remove unit",
    ),
    "filter_recipes": MessageLookupByLibrary.simpleMessage("Filter recipes..."),
    "finished": MessageLookupByLibrary.simpleMessage("Finished"),
    "for_persons": m88,
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
    "importing_recipe_drive": m43,
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
    "ingredient_count": m44,
    "ingredient_filter_description": MessageLookupByLibrary.simpleMessage(
      "Purchase pro version in settings to get access to ingredient filter",
    ),
    "ingredient_manager_description": MessageLookupByLibrary.simpleMessage(
      "Here you can manage the ingredients, which you are suggested when adding a recipe or searching for them. When you edit or delete them, only the suggestions are updated and not the recipes with the ingredient.",
    ),
    "ingredient_matches": MessageLookupByLibrary.simpleMessage(
      "Matching ingredients",
    ),
    "ingredient_search_active_filters": m45,
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
    "ingredient_search_basket_count": m46,
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
    "ingredient_search_effort_value": m47,
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
    "ingredient_search_found": m48,
    "ingredient_search_heading": MessageLookupByLibrary.simpleMessage(
      "Cook from what you have",
    ),
    "ingredient_search_input_hint": MessageLookupByLibrary.simpleMessage(
      "Add an ingredient…",
    ),
    "ingredient_search_limit": m49,
    "ingredient_search_match_badge": m50,
    "ingredient_search_match_summary": m51,
    "ingredient_search_max_time": MessageLookupByLibrary.simpleMessage(
      "MAX TIME",
    ),
    "ingredient_search_meat": MessageLookupByLibrary.simpleMessage("Meat"),
    "ingredient_search_minutes": m52,
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
    "ingredient_search_preview_description":
        MessageLookupByLibrary.simpleMessage(
          "Choose ingredients from your kitchen and find matching recipes in your own collection. Refine them by diet, time, effort, categories, or tags.",
        ),
    "ingredient_search_preview_effort_cap":
        MessageLookupByLibrary.simpleMessage("Effort ≤5"),
    "ingredient_search_preview_example": MessageLookupByLibrary.simpleMessage(
      "EXAMPLE MATCH",
    ),
    "ingredient_search_preview_example_recipe":
        MessageLookupByLibrary.simpleMessage("Creamy spinach pasta"),
    "ingredient_search_preview_filtered_by":
        MessageLookupByLibrary.simpleMessage("FILTERED BY"),
    "ingredient_search_preview_own_description":
        MessageLookupByLibrary.simpleMessage(
          "Match ingredients against the recipes saved on this device.",
        ),
    "ingredient_search_preview_own_title": MessageLookupByLibrary.simpleMessage(
      "Search your cookbook",
    ),
    "ingredient_search_preview_pasta": MessageLookupByLibrary.simpleMessage(
      "Pasta",
    ),
    "ingredient_search_preview_pro_badge": MessageLookupByLibrary.simpleMessage(
      "PRO FEATURE",
    ),
    "ingredient_search_preview_pro_description":
        MessageLookupByLibrary.simpleMessage(
          "A one-time purchase also removes in-app ads and supports future development.",
        ),
    "ingredient_search_preview_pro_title": MessageLookupByLibrary.simpleMessage(
      "Also included with Pro",
    ),
    "ingredient_search_preview_recipe_time":
        MessageLookupByLibrary.simpleMessage("25 min"),
    "ingredient_search_preview_refine_description":
        MessageLookupByLibrary.simpleMessage(
          "Narrow matches by diet, time, effort, categories, and tags.",
        ),
    "ingredient_search_preview_refine_title":
        MessageLookupByLibrary.simpleMessage("Refine every result"),
    "ingredient_search_preview_save_description":
        MessageLookupByLibrary.simpleMessage(
          "Order results by best match, time, effort, or name, then open or bookmark a recipe.",
        ),
    "ingredient_search_preview_save_title":
        MessageLookupByLibrary.simpleMessage("Sort, open, and bookmark"),
    "ingredient_search_preview_semantics": MessageLookupByLibrary.simpleMessage(
      "Read-only example of an ingredient search with spinach, pasta, and tomatoes, refined to a vegetarian recipe under 30 minutes and effort level 5.",
    ),
    "ingredient_search_preview_spinach": MessageLookupByLibrary.simpleMessage(
      "Spinach",
    ),
    "ingredient_search_preview_tomatoes": MessageLookupByLibrary.simpleMessage(
      "Tomatoes",
    ),
    "ingredient_search_preview_unlock": MessageLookupByLibrary.simpleMessage(
      "Unlock ingredient search",
    ),
    "ingredient_search_preview_unlock_description":
        MessageLookupByLibrary.simpleMessage(
          "One-time Pro purchase · Removes ads · Supports future development",
        ),
    "ingredient_search_remove": m53,
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
    "instruction_count": m54,
    "instruction_number": m55,
    "instructions_empty": MessageLookupByLibrary.simpleMessage(
      "Start with the first instruction for this recipe.",
    ),
    "invalid_datatype": MessageLookupByLibrary.simpleMessage(
      "Invalid datatype",
    ),
    "invalid_file": MessageLookupByLibrary.simpleMessage("Invalid file"),
    "invalid_name": MessageLookupByLibrary.simpleMessage("Invalid name"),
    "invalid_url": MessageLookupByLibrary.simpleMessage(
      "This recipe page is not supported yet",
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
      "Manage nutrition",
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
    "onboarding_continue": MessageLookupByLibrary.simpleMessage("Continue"),
    "onboarding_cook_awake_description": MessageLookupByLibrary.simpleMessage(
      "Enable it for the current cooking session.",
    ),
    "onboarding_cook_awake_title": MessageLookupByLibrary.simpleMessage(
      "Keep the screen awake",
    ),
    "onboarding_cook_description": MessageLookupByLibrary.simpleMessage(
      "Work through one recipe step at a time, see its assigned ingredients, and keep a timer within reach.",
    ),
    "onboarding_cook_glanceable_description":
        MessageLookupByLibrary.simpleMessage(
          "One clear instruction at a time.",
        ),
    "onboarding_cook_glanceable_title": MessageLookupByLibrary.simpleMessage(
      "Glanceable steps",
    ),
    "onboarding_cook_sample_ingredient": MessageLookupByLibrary.simpleMessage(
      "1 cup dry red wine",
    ),
    "onboarding_cook_sample_instruction": MessageLookupByLibrary.simpleMessage(
      "Add the wine, scrape the browned fond from the pan, and simmer until reduced by half.",
    ),
    "onboarding_cook_sample_recipe": MessageLookupByLibrary.simpleMessage(
      "ROASTED TOMATO PASTA",
    ),
    "onboarding_cook_sample_step": MessageLookupByLibrary.simpleMessage(
      "Deglaze and reduce",
    ),
    "onboarding_cook_step_count": MessageLookupByLibrary.simpleMessage(
      "3 of 7",
    ),
    "onboarding_cook_title": MessageLookupByLibrary.simpleMessage(
      "Never lose your place at the stove.",
    ),
    "onboarding_effort_ambitious": MessageLookupByLibrary.simpleMessage(
      "Ambitious",
    ),
    "onboarding_effort_badge": m56,
    "onboarding_effort_balanced": MessageLookupByLibrary.simpleMessage(
      "Balanced",
    ),
    "onboarding_effort_choose": m57,
    "onboarding_effort_description": MessageLookupByLibrary.simpleMessage(
      "Give recipes an effort score from 1 to 10, then sort your collection when choosing what to cook.",
    ),
    "onboarding_effort_easy_detail": MessageLookupByLibrary.simpleMessage(
      "A lighter recipe for a busy evening.",
    ),
    "onboarding_effort_easy_recipe": MessageLookupByLibrary.simpleMessage(
      "Crisp garden salad",
    ),
    "onboarding_effort_five": MessageLookupByLibrary.simpleMessage(
      "5 Balanced",
    ),
    "onboarding_effort_gentle": MessageLookupByLibrary.simpleMessage("Gentle"),
    "onboarding_effort_level": m58,
    "onboarding_effort_one": MessageLookupByLibrary.simpleMessage("1 Gentle"),
    "onboarding_effort_project_detail": MessageLookupByLibrary.simpleMessage(
      "More time and attention for an unhurried day.",
    ),
    "onboarding_effort_project_recipe": MessageLookupByLibrary.simpleMessage(
      "Slow-roasted vegetable pasta",
    ),
    "onboarding_effort_scale": MessageLookupByLibrary.simpleMessage(
      "Your effort scale",
    ),
    "onboarding_effort_ten": MessageLookupByLibrary.simpleMessage(
      "10 Ambitious",
    ),
    "onboarding_effort_title": MessageLookupByLibrary.simpleMessage(
      "Choose a recipe that fits your energy.",
    ),
    "onboarding_explore_card": m59,
    "onboarding_explore_description": MessageLookupByLibrary.simpleMessage(
      "Browse your own recipes as a deck: left to pass, up to save, and right to cook.",
    ),
    "onboarding_explore_fallback": MessageLookupByLibrary.simpleMessage(
      "Recipes without steps open in recipe detail instead.",
    ),
    "onboarding_explore_recipe_one": MessageLookupByLibrary.simpleMessage(
      "Roasted vegetable pasta",
    ),
    "onboarding_explore_recipe_one_detail":
        MessageLookupByLibrary.simpleMessage(
          "A colorful pantry dinner with herbs and tomatoes.",
        ),
    "onboarding_explore_recipe_three": MessageLookupByLibrary.simpleMessage(
      "Tomato basil spaghetti",
    ),
    "onboarding_explore_recipe_three_detail":
        MessageLookupByLibrary.simpleMessage(
          "A familiar weeknight favorite from your own collection.",
        ),
    "onboarding_explore_recipe_two": MessageLookupByLibrary.simpleMessage(
      "Summer garden salad",
    ),
    "onboarding_explore_recipe_two_detail":
        MessageLookupByLibrary.simpleMessage(
          "Fresh fruit, greens, avocado, and toasted nuts.",
        ),
    "onboarding_explore_title": MessageLookupByLibrary.simpleMessage(
      "Swipe until dinner feels obvious.",
    ),
    "onboarding_open_cookbook": MessageLookupByLibrary.simpleMessage(
      "Open my cookbook",
    ),
    "onboarding_pantry_description": MessageLookupByLibrary.simpleMessage(
      "Pro ingredient search matches your kitchen against recipes saved on this device. Any recipe can add ingredients to a checkable shopping list.",
    ),
    "onboarding_pantry_match": m60,
    "onboarding_pantry_pasta": MessageLookupByLibrary.simpleMessage("Pasta"),
    "onboarding_pantry_pro": MessageLookupByLibrary.simpleMessage(
      "PRO FEATURE",
    ),
    "onboarding_pantry_sample_detail": MessageLookupByLibrary.simpleMessage(
      "25 min · Effort 4/10",
    ),
    "onboarding_pantry_sample_recipe": MessageLookupByLibrary.simpleMessage(
      "Creamy spinach pasta",
    ),
    "onboarding_pantry_search_title": MessageLookupByLibrary.simpleMessage(
      "Ingredient search",
    ),
    "onboarding_pantry_spinach": MessageLookupByLibrary.simpleMessage(
      "Spinach",
    ),
    "onboarding_pantry_title": MessageLookupByLibrary.simpleMessage(
      "Cook with what you have. Shop for what you need.",
    ),
    "onboarding_pantry_tomatoes": MessageLookupByLibrary.simpleMessage(
      "Tomatoes",
    ),
    "onboarding_progress": m61,
    "onboarding_shopping_cream": MessageLookupByLibrary.simpleMessage(
      "Cooking cream",
    ),
    "onboarding_shopping_garlic": MessageLookupByLibrary.simpleMessage(
      "Garlic",
    ),
    "onboarding_shopping_parmesan": MessageLookupByLibrary.simpleMessage(
      "Parmesan",
    ),
    "onboarding_shopping_servings": MessageLookupByLibrary.simpleMessage(
      "4 servings",
    ),
    "onboarding_shopping_title": MessageLookupByLibrary.simpleMessage(
      "Recipe shopping list",
    ),
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
    "recipe_actions": MessageLookupByLibrary.simpleMessage("Recipe actions"),
    "recipe_actions_collapsed": MessageLookupByLibrary.simpleMessage(
      "Collapsed",
    ),
    "recipe_actions_expanded": MessageLookupByLibrary.simpleMessage("Expanded"),
    "recipe_actions_hint": MessageLookupByLibrary.simpleMessage(
      "Shows ways to add a recipe",
    ),
    "recipe_already_exists": m62,
    "recipe_bible": MessageLookupByLibrary.simpleMessage("My RecipeBible"),
    "recipe_card_cook_time": m63,
    "recipe_card_effort_value": m64,
    "recipe_card_prep_time": m65,
    "recipe_card_time_unknown": MessageLookupByLibrary.simpleMessage(
      "Time not set",
    ),
    "recipe_card_total_time": m66,
    "recipe_count": m67,
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
    "recipe_summary_with_effort": m68,
    "recipe_tag": MessageLookupByLibrary.simpleMessage("Recipetag"),
    "recipe_tag_already_exists": MessageLookupByLibrary.simpleMessage(
      "Recipe tag already exists",
    ),
    "recipe_url": MessageLookupByLibrary.simpleMessage("Recipe link"),
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
    "remove_ingredient": m69,
    "remove_section": m70,
    "remove_section_from_cart": MessageLookupByLibrary.simpleMessage(
      "Remove section",
    ),
    "remove_step": m71,
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
      "Open app details, sharing, contact, and legal information.",
    ),
    "settings_about_title": MessageLookupByLibrary.simpleMessage(
      "About & support",
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
    "settings_footer": m72,
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
      "Review effort ratings, Cook Mode, ingredient search, shopping lists, and Explore.",
    ),
    "settings_intro_title": MessageLookupByLibrary.simpleMessage(
      "Replay introduction",
    ),
    "settings_item_count": m73,
    "settings_migration_desc": m74,
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
    "settings_recipe_count": m75,
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
    "share_this_app_desc": m76,
    "share_this_app_title": MessageLookupByLibrary.simpleMessage(
      "My RecipeBible",
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
    "shopping_for_recipes": m77,
    "shopping_invalid_servings": MessageLookupByLibrary.simpleMessage(
      "Enter a number greater than zero",
    ),
    "shopping_item_count": m78,
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
    "shopping_percent_gathered": m79,
    "shopping_plain_list": MessageLookupByLibrary.simpleMessage("Plain list"),
    "shopping_progress": m80,
    "shopping_quick_add_hint": MessageLookupByLibrary.simpleMessage(
      "Add an ingredient…",
    ),
    "shopping_remove_checked": MessageLookupByLibrary.simpleMessage(
      "Remove checked items",
    ),
    "shopping_remove_checked_description": m81,
    "shopping_remove_checked_title": MessageLookupByLibrary.simpleMessage(
      "Remove gathered items?",
    ),
    "shopping_remove_item": m82,
    "shopping_removed_items": m83,
    "shopping_search_recipes": MessageLookupByLibrary.simpleMessage(
      "Search recipes",
    ),
    "shopping_serving_value": m84,
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
    "sort_by": m85,
    "source": MessageLookupByLibrary.simpleMessage("Source/url"),
    "source_could_not_open": MessageLookupByLibrary.simpleMessage(
      "The recipe source could not be opened.",
    ),
    "standardized_format": MessageLookupByLibrary.simpleMessage(
      "Many recipe sites work when they publish structured recipe data. For example:",
    ),
    "start_cooking": MessageLookupByLibrary.simpleMessage("Start cooking"),
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
      "Which sites work?",
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
    "sync_recipes_drive": MessageLookupByLibrary.simpleMessage(
      "Sync recipes with Google Drive",
    ),
    "syncing_recipes_drive": MessageLookupByLibrary.simpleMessage(
      "Syncing recipes with Google Drive",
    ),
    "tags": MessageLookupByLibrary.simpleMessage("Tags"),
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
    "undo_added_to_planner_description": m86,
    "unit": MessageLookupByLibrary.simpleMessage("Unit"),
    "unpin_recipe": MessageLookupByLibrary.simpleMessage("Unpin recipe"),
    "untitled_recipe": MessageLookupByLibrary.simpleMessage("Untitled recipe"),
    "uploading_recipe_drive": m87,
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
    "website_import_action": MessageLookupByLibrary.simpleMessage(
      "Import recipe",
    ),
    "website_import_collapse_sites": MessageLookupByLibrary.simpleMessage(
      "Hide supported sites",
    ),
    "website_import_connection_body": MessageLookupByLibrary.simpleMessage(
      "Check your internet connection and try again.",
    ),
    "website_import_connection_title": MessageLookupByLibrary.simpleMessage(
      "Couldn’t connect",
    ),
    "website_import_duplicate_title": MessageLookupByLibrary.simpleMessage(
      "Already in your cookbook",
    ),
    "website_import_expand_sites": MessageLookupByLibrary.simpleMessage(
      "Show supported sites",
    ),
    "website_import_failed_body": MessageLookupByLibrary.simpleMessage(
      "We couldn’t find complete recipe data on this page. Check the link or try again.",
    ),
    "website_import_failed_title": MessageLookupByLibrary.simpleMessage(
      "We couldn’t import this recipe",
    ),
    "website_import_field_hint": MessageLookupByLibrary.simpleMessage(
      "https://example.com/recipe",
    ),
    "website_import_field_label": MessageLookupByLibrary.simpleMessage(
      "Recipe link",
    ),
    "website_import_info": MessageLookupByLibrary.simpleMessage(
      "Use your browser’s Share action and choose My RecipeBible to import a recipe without copying its link.",
    ),
    "website_import_intro_body": MessageLookupByLibrary.simpleMessage(
      "Paste a link to a recipe page. We’ll pull in the details so you can review them before saving.",
    ),
    "website_import_intro_title": MessageLookupByLibrary.simpleMessage(
      "Bring a recipe into your cookbook",
    ),
    "website_import_invalid_url_input": MessageLookupByLibrary.simpleMessage(
      "Enter a complete recipe link beginning with http:// or https://.",
    ),
    "website_import_link_failed": MessageLookupByLibrary.simpleMessage(
      "Couldn’t open this website.",
    ),
    "website_import_loading": MessageLookupByLibrary.simpleMessage(
      "Reading recipe…",
    ),
    "website_import_loading_body": MessageLookupByLibrary.simpleMessage(
      "Looking for ingredients, instructions, and recipe details.",
    ),
    "website_import_share_tip_title": MessageLookupByLibrary.simpleMessage(
      "Faster from your browser",
    ),
    "website_import_try_again": MessageLookupByLibrary.simpleMessage(
      "Try again",
    ),
    "website_import_unsupported_body": MessageLookupByLibrary.simpleMessage(
      "Try another recipe page or check the supported-site guidance below.",
    ),
    "website_import_unsupported_title": MessageLookupByLibrary.simpleMessage(
      "This page isn’t supported yet",
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
