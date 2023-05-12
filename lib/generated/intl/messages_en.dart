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

  static String m0(newLine) => "add ${newLine}ingredient";

  static String m1(newLine) => "add ${newLine}section";

  static String m2(newLine) => "add ${newLine}step";

  static String m3(datatype) =>
      "the datatype of the selected file \"${datatype}\" is not supported\nsupported formats: \".zip\", \".mcb\"";

  static String m4(recipeName) => "deleting recipe in cloud: ${recipeName}";

  static String m5(recipeName) => "deleting local recipe: ${recipeName}";

  static String m6(fileName) => "the file is not supported ${fileName}.";

  static String m15(number) => "for \"${number}\" persons";

  static String m7(recipeName) => "importing recipe: ${recipeName}";

  static String m8(name) => "recipe with name \"${name}\" already exists";

  static String m9(newLine) => "remove ${newLine}ingredient";

  static String m10(newLine) => "remove ${newLine}section";

  static String m11(newLine) => "remove ${newLine}step";

  static String m12(link) =>
      "I now manage my recipes with the App My RecipeBible ${link}";

  static String m13(recipeName, year, month, day) =>
      "You added ${recipeName} to your the recipe planner for the following date:\n ${year}-${month}-${day}";

  static String m14(recipeName) => "uploading recipe: ${recipeName}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "about_me": MessageLookupByLibrary.simpleMessage("info"),
        "ad_free_until": MessageLookupByLibrary.simpleMessage("ad free until"),
        "add": MessageLookupByLibrary.simpleMessage("add"),
        "add_date": MessageLookupByLibrary.simpleMessage("select date"),
        "add_favorites": MessageLookupByLibrary.simpleMessage("add favorites"),
        "add_general_info":
            MessageLookupByLibrary.simpleMessage("add general info"),
        "add_ingredient": m0,
        "add_ingredients_info":
            MessageLookupByLibrary.simpleMessage("add ingredients info"),
        "add_nutritions":
            MessageLookupByLibrary.simpleMessage("add nutritions"),
        "add_recipe": MessageLookupByLibrary.simpleMessage("add recipe"),
        "add_section": m1,
        "add_step": m2,
        "add_steps": MessageLookupByLibrary.simpleMessage("add steps"),
        "add_title": MessageLookupByLibrary.simpleMessage("add title"),
        "add_title_desc": MessageLookupByLibrary.simpleMessage(
            "To add another section, you need to give the first one a title like e.g. (ingredients for) sauce."),
        "add_to_calendar": MessageLookupByLibrary.simpleMessage("add recipe"),
        "add_to_cart":
            MessageLookupByLibrary.simpleMessage("add to shopping cart"),
        "add_to_shoppingcart":
            MessageLookupByLibrary.simpleMessage("Add to shoppingcart"),
        "all_categories":
            MessageLookupByLibrary.simpleMessage("all categories"),
        "almost_done": MessageLookupByLibrary.simpleMessage("almost done😊"),
        "alright": MessageLookupByLibrary.simpleMessage("alright"),
        "amnt": MessageLookupByLibrary.simpleMessage("amnt"),
        "amount": MessageLookupByLibrary.simpleMessage("amount"),
        "and_many_more": MessageLookupByLibrary.simpleMessage("and many more!"),
        "apr": MessageLookupByLibrary.simpleMessage("Apr."),
        "april": MessageLookupByLibrary.simpleMessage("April"),
        "aug": MessageLookupByLibrary.simpleMessage("Aug."),
        "august": MessageLookupByLibrary.simpleMessage("August"),
        "back": MessageLookupByLibrary.simpleMessage("back"),
        "basket": MessageLookupByLibrary.simpleMessage("shopping"),
        "buy_pro_version":
            MessageLookupByLibrary.simpleMessage("buy pro version"),
        "by_effort": MessageLookupByLibrary.simpleMessage("by effort"),
        "by_ingredientsamount":
            MessageLookupByLibrary.simpleMessage("by ingredientsamount"),
        "by_last_modified":
            MessageLookupByLibrary.simpleMessage("by last modified"),
        "by_name": MessageLookupByLibrary.simpleMessage("by name"),
        "cancel": MessageLookupByLibrary.simpleMessage("cancel"),
        "cancelling_sync":
            MessageLookupByLibrary.simpleMessage("Cancelling Sync..."),
        "categories": MessageLookupByLibrary.simpleMessage("categories"),
        "category": MessageLookupByLibrary.simpleMessage("category"),
        "category_already_exists":
            MessageLookupByLibrary.simpleMessage("category already exists"),
        "categoryname": MessageLookupByLibrary.simpleMessage("category name"),
        "categoy": MessageLookupByLibrary.simpleMessage("category"),
        "change_ad_preferences":
            MessageLookupByLibrary.simpleMessage("change ad preferences"),
        "check_filled_in_information":
            MessageLookupByLibrary.simpleMessage("Check filled in information"),
        "check_filled_in_information_description":
            MessageLookupByLibrary.simpleMessage(
                "Please check for any red marked text fields. For the recipename: it shouldn\'t be empty and the name must not exceed 70 characters."),
        "check_ingredient_section_fields": MessageLookupByLibrary.simpleMessage(
            "check your ingredients section fields."),
        "check_ingredient_section_fields_description":
            MessageLookupByLibrary.simpleMessage(
                "if you have multiple sections, you need to provide a title for each section."),
        "check_ingredients_input": MessageLookupByLibrary.simpleMessage(
            "check your ingredients input"),
        "check_ingredients_input_description": MessageLookupByLibrary.simpleMessage(
            "please complete ingredient info. The format must be: \n- ingredients must have a name\n- ingredients with a unit must also have an amount"),
        "check_red_fields_desc": MessageLookupByLibrary.simpleMessage(
            "Fix the issues with the red marked text fields"),
        "choose_a_theme":
            MessageLookupByLibrary.simpleMessage("Choose a theme"),
        "clean_recipe_info":
            MessageLookupByLibrary.simpleMessage("Delete recipe data?"),
        "clean_recipe_info_desc": MessageLookupByLibrary.simpleMessage(
            "Are you sure, that you want to delete the prefilled recipe data?"),
        "complex_animations":
            MessageLookupByLibrary.simpleMessage("enable complex animations"),
        "complexity": MessageLookupByLibrary.simpleMessage("complexity"),
        "complexity_effort":
            MessageLookupByLibrary.simpleMessage("complexity/effort"),
        "contact_me": MessageLookupByLibrary.simpleMessage("contact me"),
        "cook_time": MessageLookupByLibrary.simpleMessage("cook. time"),
        "data_required": MessageLookupByLibrary.simpleMessage("data_required"),
        "datatype_not_supported": m3,
        "dec": MessageLookupByLibrary.simpleMessage("Dec."),
        "december": MessageLookupByLibrary.simpleMessage("December"),
        "decrease_servings":
            MessageLookupByLibrary.simpleMessage("decrease servings"),
        "delete_category":
            MessageLookupByLibrary.simpleMessage("delete category?"),
        "delete_ingredient":
            MessageLookupByLibrary.simpleMessage("delete ingredient"),
        "delete_nutrition":
            MessageLookupByLibrary.simpleMessage("delete nutrition?"),
        "delete_recipe": MessageLookupByLibrary.simpleMessage("delete recipe"),
        "delete_recipe_tag":
            MessageLookupByLibrary.simpleMessage("delete recipe tag?"),
        "delete_section":
            MessageLookupByLibrary.simpleMessage("Delete section?"),
        "delete_section_desc": MessageLookupByLibrary.simpleMessage(
            "Are you sure, that you want to delete this section with it\'s containing ingredients"),
        "deleting_recipe_drive": m4,
        "deleting_recipe_local": m5,
        "description": MessageLookupByLibrary.simpleMessage("description"),
        "directions": MessageLookupByLibrary.simpleMessage("Directions"),
        "disclaimer_description": MessageLookupByLibrary.simpleMessage(
            "In no event shall the author of My RecipeBible application be liable for any damages directly or indirectly caused by the application. You are acknowledging that you are 100% responsible for whatever you do with My RecipeBible."),
        "dismiss": MessageLookupByLibrary.simpleMessage("verbergen"),
        "done": MessageLookupByLibrary.simpleMessage("done"),
        "duplicate": MessageLookupByLibrary.simpleMessage("duplicate"),
        "edit": MessageLookupByLibrary.simpleMessage("edit"),
        "effort": MessageLookupByLibrary.simpleMessage("effort"),
        "enter_some_information":
            MessageLookupByLibrary.simpleMessage("enter some ingredients"),
        "enter_url": MessageLookupByLibrary.simpleMessage(
            "enter URL of website with recipe:"),
        "explore": MessageLookupByLibrary.simpleMessage("explore"),
        "export_as_text_or_zip":
            MessageLookupByLibrary.simpleMessage("EXPORT as text or zip"),
        "export_pdf": MessageLookupByLibrary.simpleMessage("share as PDF"),
        "export_recipe_s":
            MessageLookupByLibrary.simpleMessage("share/backup recipe/s"),
        "export_text":
            MessageLookupByLibrary.simpleMessage("share in textform"),
        "export_zip":
            MessageLookupByLibrary.simpleMessage("share/save as file"),
        "exporting_recipe":
            MessageLookupByLibrary.simpleMessage("exporting recipe"),
        "failed": MessageLookupByLibrary.simpleMessage("failed"),
        "failed_import": MessageLookupByLibrary.simpleMessage("import failed"),
        "failed_import_desc": MessageLookupByLibrary.simpleMessage(
            "import failed for unknown reasons. Please switch to the settings tab and import the recipes there."),
        "failed_import_not_supported": MessageLookupByLibrary.simpleMessage(
            "Import failed. Page seems not yet supported"),
        "failed_loading_ad":
            MessageLookupByLibrary.simpleMessage("failed loading ad"),
        "failed_loading_ad_desc": MessageLookupByLibrary.simpleMessage(
            "solutions can be: better internet connection, tapping \"watch\" again or restarting the app"),
        "failed_to_connect_to_url": MessageLookupByLibrary.simpleMessage(
            "failed to connect to given url"),
        "failed_to_import_recipe_unknown_reason":
            MessageLookupByLibrary.simpleMessage(
                "Failed to import recipe for an unknown reason"),
        "favorites": MessageLookupByLibrary.simpleMessage("favorites"),
        "feb": MessageLookupByLibrary.simpleMessage("Feb."),
        "february": MessageLookupByLibrary.simpleMessage("February"),
        "field_must_not_be_empty":
            MessageLookupByLibrary.simpleMessage("field must not be empty"),
        "file_not_supported": m6,
        "fill_remove_unit":
            MessageLookupByLibrary.simpleMessage("fill in/ remove unit"),
        "finished": MessageLookupByLibrary.simpleMessage("finished"),
        "first_start_recipes":
            MessageLookupByLibrary.simpleMessage("Start Recipes"),
        "first_start_recipes_desc": MessageLookupByLibrary.simpleMessage(
            "A few example recipes in german are already in this app.\nOf course you can delete them."),
        "for_more_relaxed_shopping_add_to_shoppingcart":
            MessageLookupByLibrary.simpleMessage(
                "you can add the ingredients of your recipe to your shoppingcart for more relaxed shopping."),
        "for_persons": m15,
        "for_word": MessageLookupByLibrary.simpleMessage("for"),
        "fraction_or_decimal":
            MessageLookupByLibrary.simpleMessage("number notation"),
        "fraction_or_decimal_desc": MessageLookupByLibrary.simpleMessage(
            "enabled: decimal, disabled: fraction"),
        "friday": MessageLookupByLibrary.simpleMessage("Friday"),
        "general_info_changes_will_be_saved": MessageLookupByLibrary.simpleMessage(
            "The changes you make, when adding a recipe are saved, when you go back and forth. So don\'t worry if you mistyped an information on one screen."),
        "general_infos": MessageLookupByLibrary.simpleMessage("general infos"),
        "hide": MessageLookupByLibrary.simpleMessage("hide"),
        "if_you_cant_decide_random_recipe_explorer":
            MessageLookupByLibrary.simpleMessage(
                "If you can’t decide what to cook, use random-recipe-explorer."),
        "import": MessageLookupByLibrary.simpleMessage("import"),
        "import_computer_info": MessageLookupByLibrary.simpleMessage(
            "to create your recipes (at the current state pictures can only be imported in the App)\n\n 2. After generating the file with all the recipes, load it onto your mobile phone. You can also upload it to the cloud if you have access to it on your mobile phone.\n\n3. Then you have two options:\n\n3.1. Tap the generated \".json\" file in your file manager and open it with My RecipeBible or\n\n3.2. Open My RecipeBible and go into the settings and tap \"import recipes\" and select the file to import"),
        "import_from_website":
            MessageLookupByLibrary.simpleMessage("import recipes from website"),
        "import_from_website_short":
            MessageLookupByLibrary.simpleMessage("import from website"),
        "import_pc_title_info":
            MessageLookupByLibrary.simpleMessage("import file from PC"),
        "import_recipe_description": MessageLookupByLibrary.simpleMessage(
            "supported formats:\n- .zip (file of this app)\n- .mcp"),
        "import_recipe_s":
            MessageLookupByLibrary.simpleMessage("import recipe/s"),
        "imported": MessageLookupByLibrary.simpleMessage("imported"),
        "importing_recipe_drive": m7,
        "importing_recipes":
            MessageLookupByLibrary.simpleMessage("importing recipe/s"),
        "in_minutes": MessageLookupByLibrary.simpleMessage("in minutes"),
        "increase_servings":
            MessageLookupByLibrary.simpleMessage("increase servings"),
        "info": MessageLookupByLibrary.simpleMessage("Information"),
        "info_export_description": MessageLookupByLibrary.simpleMessage(
            "It\'s recommended to sometimes save your recipes as zip, just i case that your smartphone gets lost or the app breaks for whatever reason."),
        "information": MessageLookupByLibrary.simpleMessage("information"),
        "ingredient": MessageLookupByLibrary.simpleMessage("ingredient"),
        "ingredient_already_exists":
            MessageLookupByLibrary.simpleMessage("ingredient already exists"),
        "ingredient_filter_description": MessageLookupByLibrary.simpleMessage(
            "purchase pro version in settings to get access to ingredient filter"),
        "ingredient_manager_description": MessageLookupByLibrary.simpleMessage(
            "Here you can manage the ingredients, which you are suggested when adding a recipe or searching for them. When you edit or delete them, only the suggestions are updated and not the recipes with the ingredient."),
        "ingredient_matches":
            MessageLookupByLibrary.simpleMessage("matching ingredients"),
        "ingredients": MessageLookupByLibrary.simpleMessage("ingredients"),
        "ingredients_for":
            MessageLookupByLibrary.simpleMessage("ingredients for"),
        "invalid_datatype":
            MessageLookupByLibrary.simpleMessage("invalid datatype"),
        "invalid_file": MessageLookupByLibrary.simpleMessage("invalid file"),
        "invalid_name": MessageLookupByLibrary.simpleMessage("invalid name"),
        "invalid_url": MessageLookupByLibrary.simpleMessage(
            "unsupported url:\ncheck the info about supported websites in the infopanel below"),
        "jan": MessageLookupByLibrary.simpleMessage("Jan."),
        "january": MessageLookupByLibrary.simpleMessage("January"),
        "jul": MessageLookupByLibrary.simpleMessage("Jul."),
        "july": MessageLookupByLibrary.simpleMessage("July"),
        "jun": MessageLookupByLibrary.simpleMessage("Jun."),
        "june": MessageLookupByLibrary.simpleMessage("June"),
        "keep_screen_on":
            MessageLookupByLibrary.simpleMessage("keep screen on"),
        "loading_data": MessageLookupByLibrary.simpleMessage("Loading data..."),
        "locale_full": MessageLookupByLibrary.simpleMessage("en_US"),
        "manage_categories":
            MessageLookupByLibrary.simpleMessage("manage categories"),
        "manage_ingredients":
            MessageLookupByLibrary.simpleMessage("manage ingredients"),
        "manage_nutritions":
            MessageLookupByLibrary.simpleMessage("manage nutritions"),
        "manage_recipe_tags":
            MessageLookupByLibrary.simpleMessage("manage recipe tags"),
        "mar": MessageLookupByLibrary.simpleMessage("Mar."),
        "march": MessageLookupByLibrary.simpleMessage("March"),
        "maximum_recipe_pin_count_exceeded":
            MessageLookupByLibrary.simpleMessage(
                "maximum pin count of 3 exceeded"),
        "may": MessageLookupByLibrary.simpleMessage("May"),
        "may_full": MessageLookupByLibrary.simpleMessage("May"),
        "maybe_later": MessageLookupByLibrary.simpleMessage("MAYBE LATER"),
        "monday": MessageLookupByLibrary.simpleMessage("Monday"),
        "more_coming_soon":
            MessageLookupByLibrary.simpleMessage("more coming soon..."),
        "multiple_devices_use_export_as_zip_etc":
            MessageLookupByLibrary.simpleMessage(
                "Export your recipes as zip file for using them on multiple devices. Alternatively you can also generate a pdf or text with all the information."),
        "name": MessageLookupByLibrary.simpleMessage("name"),
        "need_to_access_storage":
            MessageLookupByLibrary.simpleMessage("need to access storage"),
        "need_to_access_storage_desc": MessageLookupByLibrary.simpleMessage(
            "Access to storage required for reading the file from an external location and import it. By pressing ok, you\'ll get a prompt asking you for that"),
        "next": MessageLookupByLibrary.simpleMessage("next"),
        "no": MessageLookupByLibrary.simpleMessage("no"),
        "no_added_favorites_yet": MessageLookupByLibrary.simpleMessage(
            "You haven\'t added any favorites yet"),
        "no_category": MessageLookupByLibrary.simpleMessage("no category"),
        "no_internet_connection":
            MessageLookupByLibrary.simpleMessage("no internet connection"),
        "no_internet_connection_desc": MessageLookupByLibrary.simpleMessage(
            "could not connect to the internet and therefore not load the video."),
        "no_matching_recipes":
            MessageLookupByLibrary.simpleMessage("no matching recipes"),
        "no_recipe_with_this_name": MessageLookupByLibrary.simpleMessage(
            "you can only add recipes that you have saved in the app."),
        "no_recipes": MessageLookupByLibrary.simpleMessage("no recipes"),
        "no_recipes_fit_your_filter":
            MessageLookupByLibrary.simpleMessage("no recipes fit your filter"),
        "no_recipes_under_this_category": MessageLookupByLibrary.simpleMessage(
            "You have no recipes under this category"),
        "no_recipes_with_this_tag": MessageLookupByLibrary.simpleMessage(
            "You have no recipes with this tag"),
        "no_thanks": MessageLookupByLibrary.simpleMessage("NO THANKS"),
        "no_valid_import_file":
            MessageLookupByLibrary.simpleMessage("no valid importfile"),
        "no_valid_number":
            MessageLookupByLibrary.simpleMessage("no valid number"),
        "none": MessageLookupByLibrary.simpleMessage("none"),
        "not_required_eg_ingredients_of_sauce":
            MessageLookupByLibrary.simpleMessage(
                "not required (e.g. ingredients of sauce)"),
        "notes": MessageLookupByLibrary.simpleMessage("notes"),
        "nothing_to_search_through":
            MessageLookupByLibrary.simpleMessage("nothing to search through"),
        "nov": MessageLookupByLibrary.simpleMessage("Nov."),
        "november": MessageLookupByLibrary.simpleMessage("November"),
        "nutrition": MessageLookupByLibrary.simpleMessage("nutrition"),
        "nutrition_already_exists":
            MessageLookupByLibrary.simpleMessage("nutrition already exists"),
        "nutrition_manager_description": MessageLookupByLibrary.simpleMessage(
            "Here you can manage your nutritions. When you edit or delete them, the recipes with the specific nutrition don\'t change. If you want to edit the nutrition of an existing recipe, you have to edit the recipe itself."),
        "nutritions": MessageLookupByLibrary.simpleMessage("Nutritions"),
        "oct": MessageLookupByLibrary.simpleMessage("Oct."),
        "october": MessageLookupByLibrary.simpleMessage("October"),
        "only_recipe_screen":
            MessageLookupByLibrary.simpleMessage("only on recipe screen"),
        "out_of": MessageLookupByLibrary.simpleMessage("out of"),
        "persons": MessageLookupByLibrary.simpleMessage("persons"),
        "please_enter_a_name":
            MessageLookupByLibrary.simpleMessage("please enter a name"),
        "prep_time": MessageLookupByLibrary.simpleMessage("prep. time"),
        "preperation_time":
            MessageLookupByLibrary.simpleMessage("preperation time"),
        "print_recipe": MessageLookupByLibrary.simpleMessage("print recipe"),
        "pro_version": MessageLookupByLibrary.simpleMessage("pro version"),
        "pro_version_desc": MessageLookupByLibrary.simpleMessage(
            "includes ingredient filter, removal of ads and support of future development"),
        "professional_search":
            MessageLookupByLibrary.simpleMessage("advanced search"),
        "pull_down_to_refresh": MessageLookupByLibrary.simpleMessage(
            "pull down to refresh page and show imported recipes"),
        "purchase_pro":
            MessageLookupByLibrary.simpleMessage("purchase pro version"),
        "rate": MessageLookupByLibrary.simpleMessage("RATE"),
        "rate_app": MessageLookupByLibrary.simpleMessage("rate this app"),
        "rate_this_app": MessageLookupByLibrary.simpleMessage("Rate this app"),
        "rate_this_app_desc": MessageLookupByLibrary.simpleMessage(
            "If you like this app, please take a little bit of your time to review it!\nIt really helps us and it shouldn\'t take you more than one minute."),
        "ready": MessageLookupByLibrary.simpleMessage("ready"),
        "recipe_already_exists": m8,
        "recipe_bible": MessageLookupByLibrary.simpleMessage("My RecipeBible"),
        "recipe_edited_or_deleted": MessageLookupByLibrary.simpleMessage(
            "recipe has been edited or deleted:\ngo back to man view and view it"),
        "recipe_for": MessageLookupByLibrary.simpleMessage("recipe for"),
        "recipe_import_pc_title": MessageLookupByLibrary.simpleMessage(
            "How do I create a recipe on PC and import it in the App?"),
        "recipe_name": MessageLookupByLibrary.simpleMessage("recipe name"),
        "recipe_pinned_to_overview":
            MessageLookupByLibrary.simpleMessage("recipe pinned to overview"),
        "recipe_planer": MessageLookupByLibrary.simpleMessage("mealplaner"),
        "recipe_screen": MessageLookupByLibrary.simpleMessage("recipe screen"),
        "recipe_tag": MessageLookupByLibrary.simpleMessage("recipetag"),
        "recipe_tag_already_exists":
            MessageLookupByLibrary.simpleMessage("recipe tag already exists"),
        "recipe_url": MessageLookupByLibrary.simpleMessage("recipe-url"),
        "recipename_taken":
            MessageLookupByLibrary.simpleMessage("recipename taken"),
        "recipename_taken_description": MessageLookupByLibrary.simpleMessage(
            "change the recipename to something more detailed or maybe you just forgot, that you already saved this recipe :)"),
        "recipes": MessageLookupByLibrary.simpleMessage("recipes"),
        "recipes_not_in_overview": MessageLookupByLibrary.simpleMessage(
            "if recipes don\'t show up in overview, pull down to refresh the page or go to another tab and back."),
        "recipes_not_showing_up":
            MessageLookupByLibrary.simpleMessage("recipes not showing up?"),
        "recipes_not_showing_up_desc": MessageLookupByLibrary.simpleMessage(
            "if recipes are missing, scroll down to refresh."),
        "remaining_time":
            MessageLookupByLibrary.simpleMessage("remaining time"),
        "remove_ads_upgrade_in_settings": MessageLookupByLibrary.simpleMessage(
            "remove ads\nupgrade in settings"),
        "remove_ingredient": m9,
        "remove_section": m10,
        "remove_step": m11,
        "remove_step_desc": MessageLookupByLibrary.simpleMessage(
            "Do you really want to remove this step with its description?"),
        "roll_the_dice": MessageLookupByLibrary.simpleMessage("roll the dice"),
        "saturday": MessageLookupByLibrary.simpleMessage("Saturday"),
        "save": MessageLookupByLibrary.simpleMessage("save"),
        "saving_your_input":
            MessageLookupByLibrary.simpleMessage("saving your input"),
        "section_name": MessageLookupByLibrary.simpleMessage("section name"),
        "select_a_category":
            MessageLookupByLibrary.simpleMessage("select a category"),
        "select_a_date_first":
            MessageLookupByLibrary.simpleMessage("select a date"),
        "select_all": MessageLookupByLibrary.simpleMessage("select all"),
        "select_recipe_tags":
            MessageLookupByLibrary.simpleMessage("select recipe tags:"),
        "select_recipes":
            MessageLookupByLibrary.simpleMessage("select recipes"),
        "select_recipes_to_import":
            MessageLookupByLibrary.simpleMessage("select recipe/s to import"),
        "select_subcategories":
            MessageLookupByLibrary.simpleMessage("select categories:"),
        "sep": MessageLookupByLibrary.simpleMessage("Sep."),
        "september": MessageLookupByLibrary.simpleMessage("September"),
        "servings": MessageLookupByLibrary.simpleMessage("servings"),
        "settings": MessageLookupByLibrary.simpleMessage("settings"),
        "share_recipe": MessageLookupByLibrary.simpleMessage("share recipe"),
        "share_recipes_settings":
            MessageLookupByLibrary.simpleMessage("backup/share your recipes"),
        "share_recipes_settings_desc": MessageLookupByLibrary.simpleMessage(
            "on this screen, you can:\n- select the recipes you want to share to a friend as a single file\n- select the recipes you want to save to import on another device or just to make sure, they don\'t get lost."),
        "share_this_app":
            MessageLookupByLibrary.simpleMessage("share this app"),
        "share_this_app_desc": m12,
        "share_this_app_title":
            MessageLookupByLibrary.simpleMessage("Check out this!"),
        "shopping_cart_help":
            MessageLookupByLibrary.simpleMessage("shoppingcart help"),
        "shopping_cart_help_desc": MessageLookupByLibrary.simpleMessage(
            "To add ingredients to your shopping cart, press the + icon at the bottom right. To remove ingredients from your cart, swype them left or right. You can also delete all ingredients of one recipe by swyping the recipe in one direction."),
        "shopping_cart_is_empty":
            MessageLookupByLibrary.simpleMessage("Your shoppingcart is empty"),
        "shopping_list": MessageLookupByLibrary.simpleMessage("shopping list"),
        "shoppingcart": MessageLookupByLibrary.simpleMessage("shoppingcart"),
        "show_overview": MessageLookupByLibrary.simpleMessage("show overview"),
        "skip": MessageLookupByLibrary.simpleMessage("skip"),
        "snackbar_automatic_theme_applied": MessageLookupByLibrary.simpleMessage(
            "if supported, theme will be applied, when restarting the app :)"),
        "snackbar_bright_theme_applied":
            MessageLookupByLibrary.simpleMessage("bright theme applied"),
        "snackbar_dark_theme_applied":
            MessageLookupByLibrary.simpleMessage("dark theme applied"),
        "snackbar_midnight_theme_applied":
            MessageLookupByLibrary.simpleMessage("midnight theme applied"),
        "source": MessageLookupByLibrary.simpleMessage("source/url"),
        "standardized_format": MessageLookupByLibrary.simpleMessage(
            "All websites are supported which contain a standardized format. Thet\'s why only a part of the supported websites are listed here. In practise most websites shoulb be supported."),
        "steps": MessageLookupByLibrary.simpleMessage("steps"),
        "steps_info_desc": MessageLookupByLibrary.simpleMessage(
            "If you added multiple steps, you can move them by tapping and holding one step. This feature is only available, if no images for the steps are added. The same with removing steps from the middle."),
        "steps_intro": MessageLookupByLibrary.simpleMessage(
            "Tap on a step to select it so that you know, what you have to do next"),
        "successful": MessageLookupByLibrary.simpleMessage("successful"),
        "successfully_synced_drive": MessageLookupByLibrary.simpleMessage(
            "successfully synced recipes with Google Drive"),
        "summary": MessageLookupByLibrary.simpleMessage("summary"),
        "sunday": MessageLookupByLibrary.simpleMessage("Sunday"),
        "supported_websites": MessageLookupByLibrary.simpleMessage(
            "info about supported websites:"),
        "sure_you_want_to_delete_this_category":
            MessageLookupByLibrary.simpleMessage(
                "Are you sure you want to delete this category:"),
        "sure_you_want_to_delete_this_nutrition":
            MessageLookupByLibrary.simpleMessage(
                "Are you sure you want to delete this nutrition:"),
        "sure_you_want_to_delete_this_recipe":
            MessageLookupByLibrary.simpleMessage(
                "Are you sure that you want to delete this recipe:"),
        "sure_you_want_to_delete_this_recipe_tag":
            MessageLookupByLibrary.simpleMessage(
                "Are you sure you want to delete this recipe tag:"),
        "switch_shopping_cart_look":
            MessageLookupByLibrary.simpleMessage("change shopping cart look"),
        "switch_theme": MessageLookupByLibrary.simpleMessage("change theme"),
        "swype_your_recipes":
            MessageLookupByLibrary.simpleMessage("Swype your recipes"),
        "sync_recipes_drive": MessageLookupByLibrary.simpleMessage(
            "sync recipes with Google Drive"),
        "syncing_recipes_drive": MessageLookupByLibrary.simpleMessage(
            "syncing recipes with Google Drive"),
        "tags": MessageLookupByLibrary.simpleMessage("tags"),
        "tap_here_to_add_recipe": MessageLookupByLibrary.simpleMessage(
            "here you can add a new recipe"),
        "tap_here_to_import_recipe_online":
            MessageLookupByLibrary.simpleMessage(
                "tap here to imoprt\n a recipe online"),
        "tap_here_to_manage_categories": MessageLookupByLibrary.simpleMessage(
            "here you can manage\nyour recipe categories"),
        "thursday": MessageLookupByLibrary.simpleMessage("Thursday"),
        "too_many_images_for_the_steps": MessageLookupByLibrary.simpleMessage(
            "Add steps description or remove image/s"),
        "too_many_images_for_the_steps_description":
            MessageLookupByLibrary.simpleMessage(
                "you have added more images for the steps, than steps with a description. So images would get lost. Please fix the issue."),
        "total_time": MessageLookupByLibrary.simpleMessage("total time"),
        "tuesday": MessageLookupByLibrary.simpleMessage("Tuesday"),
        "two_char_locale": MessageLookupByLibrary.simpleMessage("EN"),
        "undo": MessageLookupByLibrary.simpleMessage("undo"),
        "undo_added_to_planner_description": m13,
        "unit": MessageLookupByLibrary.simpleMessage("unit"),
        "uploading_recipe_drive": m14,
        "vegan": MessageLookupByLibrary.simpleMessage("vegan"),
        "vegetarian": MessageLookupByLibrary.simpleMessage("vegetarian"),
        "video_to_remove_ads": MessageLookupByLibrary.simpleMessage(
            "watch video ad to remove banner ads"),
        "video_to_remove_ads_desc": MessageLookupByLibrary.simpleMessage(
            "by pressing \"watch\", you\'ll see an advertisement video and no more banner ads will be displayed for 30 min. You can stack this."),
        "view_intro": MessageLookupByLibrary.simpleMessage("view intro"),
        "visit": MessageLookupByLibrary.simpleMessage("1. Visit "),
        "watch": MessageLookupByLibrary.simpleMessage("watch"),
        "watch_video_remove_ads":
            MessageLookupByLibrary.simpleMessage("watch video → remove ads"),
        "website_import_info": MessageLookupByLibrary.simpleMessage(
            "To import recipes faster from the internet, use the share functionality of your preferred browser and select this app, to instantly import it without having to copy the link."),
        "wednesday": MessageLookupByLibrary.simpleMessage("Wednesday"),
        "with_meat": MessageLookupByLibrary.simpleMessage("with meat"),
        "yes": MessageLookupByLibrary.simpleMessage("yes"),
        "you_already_have":
            MessageLookupByLibrary.simpleMessage("you already have"),
        "you_have_no_categories":
            MessageLookupByLibrary.simpleMessage("you have no categories"),
        "you_have_no_ingredients":
            MessageLookupByLibrary.simpleMessage("you have no ingredients"),
        "you_have_no_nutritions":
            MessageLookupByLibrary.simpleMessage("you have no nutritions"),
        "you_have_no_recipe_tags":
            MessageLookupByLibrary.simpleMessage("you have no recipe tags"),
        "you_made_it_to_the_end":
            MessageLookupByLibrary.simpleMessage("you made it to the end"),
        "your": MessageLookupByLibrary.simpleMessage("your")
      };
}
