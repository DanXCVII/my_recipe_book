// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a de_DE locale. All the
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
  String get localeName => 'de_DE';

  static String m0(newLine) => "Zutat ${newLine}hinzufügen";

  static String m1(newLine) => "Bereich ${newLine}hinzufügen";

  static String m2(newLine) => "Schritt ${newLine}hinzufügen";

  static String m3(day) => "Rezept für ${day} hinzufügen";

  static String m4(count) =>
      "${Intl.plural(count, one: '1 Zutatenzeile hinzugefügt', other: '${count} Zutatenzeilen hinzugefügt')}";

  static String m5(recipes, ingredients) =>
      "${Intl.plural(recipes, one: '1 Rezept', other: '${recipes} Rezepte')} · ${Intl.plural(ingredients, one: '1 Zutatenzeile', other: '${ingredients} Zutatenzeilen')}";

  static String m6(count) =>
      "${Intl.plural(count, zero: 'Keine Gerichte', one: '1 Gericht', other: '${count} Gerichte')}";

  static String m7(recipe) => "Weitere Aktionen für ${recipe}";

  static String m8(count) =>
      "${Intl.plural(count, one: 'Einmal eingeplant', other: '${count}-mal eingeplant')}";

  static String m9(recipe) => "${recipe} wurde aus dem Plan entfernt";

  static String m10(recipe) => "Zutaten für ${recipe} auswählen";

  static String m11(count) =>
      "${Intl.plural(count, zero: 'Keine Zutaten ausgewählt', one: '1 Zutat ausgewählt', other: '${count} Zutaten ausgewählt')}";

  static String m12(datatype) =>
      "Der ausgewählte Datentyp \"${datatype}\" wird nicht unterstützt.\nUnterstützte Formate: \".zip\", \".mcb\"";

  static String m13(recipeName) => "Rezept online gelöscht: ${recipeName}";

  static String m14(recipeName) => "Rezept lokal gelöscht: ${recipeName}";

  static String m15(step, total) => "Schritt ${step} von ${total}";

  static String m16(fileName) =>
      "Die ausgewählte Datei wird nicht unterstützt.";

  static String m17(recipeName) => "Rezept importiert: ${recipeName}";

  static String m18(count) =>
      "${Intl.plural(count, zero: 'Keine Zutaten', one: '1 Zutat', other: '${count} Zutaten')}";

  static String m19(name) =>
      "Rezept mit demselben Namen \"${name}\" bereits vorhanden";

  static String m20(count) =>
      "${Intl.plural(count, zero: 'Keine Rezepte', one: '1 Rezept', other: '${count} Rezepte')}";

  static String m21(count, effort) =>
      "${Intl.plural(count, zero: 'Keine Rezepte', one: '1 Rezept', other: '${count} Rezepte')} • Ø Aufwand ${effort}";

  static String m22(newLine) => "Zutat ${newLine}entfernen";

  static String m23(newLine) => "Bereich ${newLine}entfernen";

  static String m24(newLine) => "Schritt ${newLine}entfernen";

  static String m25(link) =>
      "Ich verwalte meine Rezepte jetzt mit der App My RecipeBible ${link}";

  static String m26(count) =>
      "${Intl.plural(count, one: 'Einkauf für 1 Rezept', other: 'Einkauf für ${count} Rezepte')}";

  static String m27(count) =>
      "${Intl.plural(count, zero: 'Keine Einträge', one: '1 Eintrag', other: '${count} Einträge')}";

  static String m28(percent) => "${percent}% erledigt";

  static String m29(checked, total) =>
      "${checked} von ${total} Einträgen erledigt";

  static String m30(count) =>
      "${Intl.plural(count, one: 'Damit wird 1 erledigter Eintrag aus der Liste entfernt.', other: 'Damit werden ${count} erledigte Einträge aus der Liste entfernt.')}";

  static String m31(item) => "${item} entfernen";

  static String m32(count) =>
      "${Intl.plural(count, one: '1 Eintrag entfernt', other: '${count} Einträge entfernt')}";

  static String m33(value) => "${value} Portionen";

  static String m34(sort) => "Sortierung: ${sort}";

  static String m35(recipeName, year, month, day) =>
      "${recipeName} zum Rezepteplaner hinzugefügt: \n${day}.${month}.${year}";

  static String m36(recipeName) => "Rezept hochgeladen: ${recipeName}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about_me": MessageLookupByLibrary.simpleMessage("Info"),
    "ad_free_until": MessageLookupByLibrary.simpleMessage("werbefrei bis"),
    "add": MessageLookupByLibrary.simpleMessage("Hinzufügen"),
    "add_cover_photo": MessageLookupByLibrary.simpleMessage(
      "Titelbild hinzufügen",
    ),
    "add_date": MessageLookupByLibrary.simpleMessage("Datum wählen"),
    "add_favorites": MessageLookupByLibrary.simpleMessage(
      "Favoriten hinzufügen",
    ),
    "add_general_info": MessageLookupByLibrary.simpleMessage(
      "Allgemeine Infos",
    ),
    "add_ingredient": m0,
    "add_ingredients_info": MessageLookupByLibrary.simpleMessage(
      "Zutateninformationen",
    ),
    "add_nutrition_item": MessageLookupByLibrary.simpleMessage(
      "Nährwert hinzufügen",
    ),
    "add_nutritions": MessageLookupByLibrary.simpleMessage(
      "Nährwerte hinzufügen",
    ),
    "add_recipe": MessageLookupByLibrary.simpleMessage("Rezept hinzufügen"),
    "add_section": m1,
    "add_step": m2,
    "add_steps": MessageLookupByLibrary.simpleMessage("Füge Schritte hinzu"),
    "add_title": MessageLookupByLibrary.simpleMessage("Überschrift hinzufügen"),
    "add_title_desc": MessageLookupByLibrary.simpleMessage(
      "Um einen Bereich hinzufügen zu können, gebe dem ersten einen Titel wie zB. (Zutaten für die) Sauce.",
    ),
    "add_to_calendar": MessageLookupByLibrary.simpleMessage(
      "Rezept hinzufügen",
    ),
    "add_to_cart": MessageLookupByLibrary.simpleMessage(
      "Einkaufsliste hinzufügen",
    ),
    "add_to_favorites": MessageLookupByLibrary.simpleMessage(
      "Zu Favoriten hinzufügen",
    ),
    "add_to_shoppingcart": MessageLookupByLibrary.simpleMessage(
      "Der Einkaufsliste hinzufügen",
    ),
    "all_categories": MessageLookupByLibrary.simpleMessage("alle Kategorien"),
    "all_recipes_filter": MessageLookupByLibrary.simpleMessage("Alle"),
    "almost_done": MessageLookupByLibrary.simpleMessage("Fast fertig😊"),
    "alright": MessageLookupByLibrary.simpleMessage("Alles klar!"),
    "amnt": MessageLookupByLibrary.simpleMessage("Menge"),
    "amount": MessageLookupByLibrary.simpleMessage("Menge"),
    "and_many_more": MessageLookupByLibrary.simpleMessage("und viele weitere!"),
    "apr": MessageLookupByLibrary.simpleMessage("Apr."),
    "april": MessageLookupByLibrary.simpleMessage("April"),
    "ascending": MessageLookupByLibrary.simpleMessage("Aufsteigend"),
    "assign_ingredients": MessageLookupByLibrary.simpleMessage(
      "Zutaten zuordnen",
    ),
    "aug": MessageLookupByLibrary.simpleMessage("Aug."),
    "august": MessageLookupByLibrary.simpleMessage("August"),
    "average_effort": MessageLookupByLibrary.simpleMessage("Ø Aufwand"),
    "back": MessageLookupByLibrary.simpleMessage("zurück"),
    "basket": MessageLookupByLibrary.simpleMessage("Einkaufen"),
    "buy_pro_version": MessageLookupByLibrary.simpleMessage(
      "Pro-Version kaufen",
    ),
    "by_effort": MessageLookupByLibrary.simpleMessage("nach Aufwand"),
    "by_ingredientsamount": MessageLookupByLibrary.simpleMessage(
      "nach Zutatenanzahl",
    ),
    "by_last_modified": MessageLookupByLibrary.simpleMessage(
      "nach Änderungsdatum",
    ),
    "by_name": MessageLookupByLibrary.simpleMessage("nach Name"),
    "calendar_add_for_day": m3,
    "calendar_add_selected": MessageLookupByLibrary.simpleMessage(
      "Auswahl hinzufügen",
    ),
    "calendar_empty_day": MessageLookupByLibrary.simpleMessage(
      "Noch nichts geplant",
    ),
    "calendar_export_success": m4,
    "calendar_export_summary": m5,
    "calendar_load_failed": MessageLookupByLibrary.simpleMessage(
      "Dein Essensplan konnte nicht geladen werden",
    ),
    "calendar_load_failed_description": MessageLookupByLibrary.simpleMessage(
      "Überprüfe deinen Speicher und versuche es erneut.",
    ),
    "calendar_meal_count": m6,
    "calendar_more_actions": m7,
    "calendar_next_week": MessageLookupByLibrary.simpleMessage("Nächste Woche"),
    "calendar_no_exportable": MessageLookupByLibrary.simpleMessage(
      "Diese Woche enthält keine exportierbaren Zutaten",
    ),
    "calendar_plan_recipe": MessageLookupByLibrary.simpleMessage(
      "Rezept einplanen",
    ),
    "calendar_planned_count": m8,
    "calendar_previous_week": MessageLookupByLibrary.simpleMessage(
      "Vorherige Woche",
    ),
    "calendar_remove_from_plan": MessageLookupByLibrary.simpleMessage(
      "Aus dem Plan entfernen",
    ),
    "calendar_removed": m9,
    "calendar_review_description": MessageLookupByLibrary.simpleMessage(
      "Passe die Portionen an und wähle ab, was du bereits zu Hause hast.",
    ),
    "calendar_review_export": MessageLookupByLibrary.simpleMessage(
      "Prüfen & exportieren",
    ),
    "calendar_review_title": MessageLookupByLibrary.simpleMessage(
      "Einkaufsliste prüfen",
    ),
    "calendar_select_recipe_ingredients": m10,
    "calendar_selected_count": m11,
    "calendar_servings_not_set": MessageLookupByLibrary.simpleMessage(
      "Portionen nicht angegeben",
    ),
    "calendar_this_week": MessageLookupByLibrary.simpleMessage("Diese Woche"),
    "cancel": MessageLookupByLibrary.simpleMessage("Abbrechen"),
    "cancelling_sync": MessageLookupByLibrary.simpleMessage(
      "Synchronisierung abbrechen...",
    ),
    "categories": MessageLookupByLibrary.simpleMessage("Kategorien"),
    "category": MessageLookupByLibrary.simpleMessage("Kategorie"),
    "category_already_exists": MessageLookupByLibrary.simpleMessage(
      "Kategorie schon vorhanden",
    ),
    "categoryname": MessageLookupByLibrary.simpleMessage("Kategoriename"),
    "categoy": MessageLookupByLibrary.simpleMessage("Kategorie"),
    "change_ad_preferences": MessageLookupByLibrary.simpleMessage(
      "Werbepräferenz ändern",
    ),
    "change_cover_photo": MessageLookupByLibrary.simpleMessage(
      "Titelbild ändern",
    ),
    "check_filled_in_information": MessageLookupByLibrary.simpleMessage(
      "Prüfe rot markierte Felder",
    ),
    "check_filled_in_information_description":
        MessageLookupByLibrary.simpleMessage(
          "Wenn der Rezeptname betroffen ist:\n- er darf nicht leer sein\n- und 70 Zeichen nicht überschreiten",
        ),
    "check_ingredient_section_fields": MessageLookupByLibrary.simpleMessage(
      "Prüfe die Zutatenliste",
    ),
    "check_ingredient_section_fields_description":
        MessageLookupByLibrary.simpleMessage(
          "Wenn du mehrere Bereiche in der Zutatenliste festgelegt hast, müssen diese eine Überschrift haben wie zB. (Teig).",
        ),
    "check_ingredients_input": MessageLookupByLibrary.simpleMessage(
      "Überprüfe die Zutatenliste",
    ),
    "check_ingredients_input_description": MessageLookupByLibrary.simpleMessage(
      "Die Zutatenliste ist nicht korrekt ausgefüllt. Sie muss foldendermaßen ausgefüllt werden: \n- Jede Zutat muss einen Namen haben \n- Wenn füre eine Zutat die Einheit angegeben ist, muss auch die Menge angegeben sein",
    ),
    "check_red_fields_desc": MessageLookupByLibrary.simpleMessage(
      "Behebe die Fehler der rot markierten Felder",
    ),
    "choose_a_theme": MessageLookupByLibrary.simpleMessage(
      "Unterstützte Themes",
    ),
    "clean_recipe_info": MessageLookupByLibrary.simpleMessage("Infos löschen?"),
    "clean_recipe_info_desc": MessageLookupByLibrary.simpleMessage(
      "Willst du wirklich die ausgefüllten Daten des aktuell bearbeiteten/neuen Rezeptes löschen",
    ),
    "clear_filters": MessageLookupByLibrary.simpleMessage("Filter löschen"),
    "clear_search": MessageLookupByLibrary.simpleMessage("Suche löschen"),
    "complex_animations": MessageLookupByLibrary.simpleMessage(
      "aufwendige Animationen",
    ),
    "complexity": MessageLookupByLibrary.simpleMessage("Aufwand"),
    "complexity_effort": MessageLookupByLibrary.simpleMessage("Aufwand"),
    "contact_me": MessageLookupByLibrary.simpleMessage("kontaktiere mich"),
    "continue_to_ingredients": MessageLookupByLibrary.simpleMessage(
      "Weiter zu den Zutaten",
    ),
    "continue_to_instructions": MessageLookupByLibrary.simpleMessage(
      "Weiter zur Zubereitung",
    ),
    "continue_to_nutrition": MessageLookupByLibrary.simpleMessage(
      "Weiter zu den Nährwerten",
    ),
    "cook_time": MessageLookupByLibrary.simpleMessage("Koch-/Backzeit"),
    "data_required": MessageLookupByLibrary.simpleMessage("bitte ausfüllen"),
    "datatype_not_supported": m12,
    "dec": MessageLookupByLibrary.simpleMessage("Dez."),
    "december": MessageLookupByLibrary.simpleMessage("Dezember"),
    "decrease_servings": MessageLookupByLibrary.simpleMessage(
      "Portionen verringern",
    ),
    "delete_category": MessageLookupByLibrary.simpleMessage(
      "Kategorie löschen?",
    ),
    "delete_ingredient": MessageLookupByLibrary.simpleMessage("Zutat löschen"),
    "delete_nutrition": MessageLookupByLibrary.simpleMessage(
      "Nährwert löschen?",
    ),
    "delete_recipe": MessageLookupByLibrary.simpleMessage("Rezept löschen"),
    "delete_recipe_tag": MessageLookupByLibrary.simpleMessage("Tag löschen?"),
    "delete_section": MessageLookupByLibrary.simpleMessage(
      "Bereich entfernen?",
    ),
    "delete_section_desc": MessageLookupByLibrary.simpleMessage(
      "Bist du dir sicher, dass du diesen Bereich mit all seinen Zutaten entfernen willst?",
    ),
    "deleting_recipe_drive": m13,
    "deleting_recipe_local": m14,
    "descending": MessageLookupByLibrary.simpleMessage("Absteigend"),
    "description": MessageLookupByLibrary.simpleMessage("Beschreibung"),
    "diet_meat": MessageLookupByLibrary.simpleMessage("Fleisch"),
    "diet_vegan": MessageLookupByLibrary.simpleMessage("Vegan"),
    "diet_vegetarian": MessageLookupByLibrary.simpleMessage("Vegetarisch"),
    "dietary_preference": MessageLookupByLibrary.simpleMessage(
      "Ernährungsweise",
    ),
    "directions": MessageLookupByLibrary.simpleMessage("Zubereitung"),
    "dish_basics_timing": MessageLookupByLibrary.simpleMessage(
      "Gericht & Zeitplanung",
    ),
    "dismiss": MessageLookupByLibrary.simpleMessage("verbergen"),
    "done": MessageLookupByLibrary.simpleMessage("fertig"),
    "duplicate": MessageLookupByLibrary.simpleMessage("Duplikat"),
    "edit": MessageLookupByLibrary.simpleMessage("editieren"),
    "editor_general": MessageLookupByLibrary.simpleMessage("Allgemein"),
    "editor_ingredients": MessageLookupByLibrary.simpleMessage("Zutaten"),
    "editor_instructions": MessageLookupByLibrary.simpleMessage("Zubereitung"),
    "editor_nutrition": MessageLookupByLibrary.simpleMessage("Nährwerte"),
    "editor_progress": m15,
    "effort": MessageLookupByLibrary.simpleMessage("Aufwand"),
    "enter_some_information": MessageLookupByLibrary.simpleMessage(
      "Informationen angeben",
    ),
    "enter_url": MessageLookupByLibrary.simpleMessage("URL zum Rezept:"),
    "explore": MessageLookupByLibrary.simpleMessage("Zufällig"),
    "export_as_text_or_zip": MessageLookupByLibrary.simpleMessage(
      "Teile als Text oder Datei",
    ),
    "export_pdf": MessageLookupByLibrary.simpleMessage("als PDF teilen"),
    "export_recipe_s": MessageLookupByLibrary.simpleMessage(
      "Rezepte sichern/teilen",
    ),
    "export_text": MessageLookupByLibrary.simpleMessage("in Textform teilen"),
    "export_zip": MessageLookupByLibrary.simpleMessage(
      "als Datei teilen/sichern",
    ),
    "exporting_recipe": MessageLookupByLibrary.simpleMessage(
      "exportiere Rezept",
    ),
    "failed": MessageLookupByLibrary.simpleMessage("fehlgeschlagen"),
    "failed_import": MessageLookupByLibrary.simpleMessage(
      "Import fehlgeschlagen",
    ),
    "failed_import_desc": MessageLookupByLibrary.simpleMessage(
      "Import aus unbekannten Gründen fehlgeschlagen. Bitte wechsle zum Tab \"Einstellungen\" und importiere die Rezepte dort.",
    ),
    "failed_import_not_supported": MessageLookupByLibrary.simpleMessage(
      "Import fehlgeschlagen. Webseite scheinbar noch nicht unterstützt.",
    ),
    "failed_loading_ad": MessageLookupByLibrary.simpleMessage(
      "Laden fehlgeschlagen",
    ),
    "failed_loading_ad_desc": MessageLookupByLibrary.simpleMessage(
      "Mögliche Lösungen: Bessere Internetverbindung, erneut versuchen zu laden oder ein Neustart der App.",
    ),
    "failed_sign_in": MessageLookupByLibrary.simpleMessage(
      "login fehlgeschlagen evtl. aufgrund von nicht vorhandenem Internet",
    ),
    "failed_syncing": MessageLookupByLibrary.simpleMessage(
      "Fehler bei der Synchronisierung evtl. durch schlechtes Internet",
    ),
    "failed_to_connect_to_url": MessageLookupByLibrary.simpleMessage(
      "Verbindung mit URL fehlgeschlagen",
    ),
    "failed_to_import_recipe_unknown_reason":
        MessageLookupByLibrary.simpleMessage(
          "Import aus unbekannten Gründen fehlgeschlagen",
        ),
    "favorites": MessageLookupByLibrary.simpleMessage("Favoriten"),
    "feb": MessageLookupByLibrary.simpleMessage("Feb."),
    "february": MessageLookupByLibrary.simpleMessage("Februar"),
    "field_must_not_be_empty": MessageLookupByLibrary.simpleMessage(
      "Textfeld darf nicht leer sein",
    ),
    "file_not_supported": m16,
    "filter_recipes": MessageLookupByLibrary.simpleMessage(
      "Rezepte filtern...",
    ),
    "finished": MessageLookupByLibrary.simpleMessage("fertig"),
    "first_start_recipes": MessageLookupByLibrary.simpleMessage(
      "Start-Rezepte",
    ),
    "first_start_recipes_desc": MessageLookupByLibrary.simpleMessage(
      "Es sind ein paar Beispielrezepte eingetragen.\nDiese können natürlich auch gelöscht werden.",
    ),
    "for_more_relaxed_shopping_add_to_shoppingcart":
        MessageLookupByLibrary.simpleMessage(
          "Für ein entspannteres Einkaufserlebnis kannst du die Zutaten der Rezepte deiner Einkaufsliste hinzufügen.",
        ),
    "for_word": MessageLookupByLibrary.simpleMessage("Für"),
    "fraction_or_decimal": MessageLookupByLibrary.simpleMessage(
      "Zahlen als Brüche oder mit Komma",
    ),
    "fraction_or_decimal_desc": MessageLookupByLibrary.simpleMessage(
      "aktiviert: Dezimal, deaktiviert: Bruch",
    ),
    "friday": MessageLookupByLibrary.simpleMessage("Freitag"),
    "general_info_changes_will_be_saved": MessageLookupByLibrary.simpleMessage(
      "Die Änderungen beim Hinzufügen von Rezepten werden gespeichert, wenn man vor oder zurück geht. Mache dir also keine Sorgen, wenn du eine Information falsch eingetippt hast. Beim zurückgehen gehen die Daten nicht verloren.",
    ),
    "general_infos": MessageLookupByLibrary.simpleMessage("Allgemeine Infos"),
    "grid_view": MessageLookupByLibrary.simpleMessage("Raster"),
    "hide": MessageLookupByLibrary.simpleMessage("verbergen"),
    "if_you_cant_decide_random_recipe_explorer":
        MessageLookupByLibrary.simpleMessage(
          "Wenn du nicht weißt, was du kochen sollst, kannst du dir deine Rezepte nach Zufallsprinzip anzeigen lassen.",
        ),
    "import": MessageLookupByLibrary.simpleMessage("importiere"),
    "import_computer_info": MessageLookupByLibrary.simpleMessage(
      " um die gewünschten Rezepte zu erstellen (zur Zeit können nur in der App Rezepten Bilder hinzugefügt werden)\n\n 2. Nachdem die Rezepte erstellt und gespeichert wurden, lade die generierte \".json\" Datei auf den Handy. Sie kann auch in eine Cloud geladen werden, wenn Zugriff auf diese mittels Smartphone besteht.\n\n3. Danach git es zwei Optionen:\n\n3.1. Klicke die generierte \".json\" Datei im Deiteiexplorer an, um sie dann mit der App zu öffnen und die gewünschten Rezepte zu importieren.\n\n3.2. Öffne My RecipeBible, gehe in die Einstellungen und tippe auf \"Rezepte importieren\", um dann die generierte \".json\" Datei auszuwählen und die gewünschten Rezepte zu importieren",
    ),
    "import_from_website": MessageLookupByLibrary.simpleMessage(
      "Rezepte von Webseite importieren",
    ),
    "import_from_website_short": MessageLookupByLibrary.simpleMessage(
      "Rezepte laden",
    ),
    "import_pc_title_info": MessageLookupByLibrary.simpleMessage(
      "Importiere Rezepte vom PC",
    ),
    "import_recipe_description": MessageLookupByLibrary.simpleMessage(
      "Unterstüzte Formate:\n- .zip (Rezeptedatei der App)\n- .mcp",
    ),
    "import_recipe_s": MessageLookupByLibrary.simpleMessage(
      "Rezepte importieren",
    ),
    "imported": MessageLookupByLibrary.simpleMessage("hinzugefügt"),
    "importing_recipe_drive": m17,
    "importing_recipes": MessageLookupByLibrary.simpleMessage(
      "importiere Rezept/e",
    ),
    "in_minutes": MessageLookupByLibrary.simpleMessage("in Minuten"),
    "increase_servings": MessageLookupByLibrary.simpleMessage(
      "Portionen erhöhen",
    ),
    "info": MessageLookupByLibrary.simpleMessage("Hilfe"),
    "info_export_description": MessageLookupByLibrary.simpleMessage(
      "Es ist sinnvoll ab und zu die Rezepte zu sichern, für den Fall, dass das Handy verloren geht oder aus welchen Gründen auch immer die App nicht mehr funktioniert und neuinstalliert werden muss.",
    ),
    "information": MessageLookupByLibrary.simpleMessage("Tipp"),
    "ingredient": MessageLookupByLibrary.simpleMessage("Zutat"),
    "ingredient_already_exists": MessageLookupByLibrary.simpleMessage(
      "Zutat existiert bereits",
    ),
    "ingredient_count": m18,
    "ingredient_filter_description": MessageLookupByLibrary.simpleMessage(
      "Kaufe die Vollversion in den Einstellungen um Zugriff zum Zutatenfilter zu bekommen",
    ),
    "ingredient_manager_description": MessageLookupByLibrary.simpleMessage(
      "Hier kannst du die Namen der Zutaten, die dir vorgeschlagen werden, ändern oder hinzufügen. Die Zutaten der bereits hinzugefügten Rezepte bleiben unverändert. Es dient lediglich der Zeitersparnis beim Eintippen der Zutaten.",
    ),
    "ingredient_matches": MessageLookupByLibrary.simpleMessage(
      "Zutatentreffer",
    ),
    "ingredient_section_empty": MessageLookupByLibrary.simpleMessage(
      "Dieser Bereich enthält noch keine Zutaten.",
    ),
    "ingredients": MessageLookupByLibrary.simpleMessage("Zutaten"),
    "ingredients_for": MessageLookupByLibrary.simpleMessage("Zutaten für:"),
    "ingredients_for_step": MessageLookupByLibrary.simpleMessage(
      "Zutaten für diesen Schritt",
    ),
    "instructions_empty": MessageLookupByLibrary.simpleMessage(
      "Beginne mit dem ersten Zubereitungsschritt.",
    ),
    "invalid_datatype": MessageLookupByLibrary.simpleMessage(
      "Ungültiger Datentyp",
    ),
    "invalid_file": MessageLookupByLibrary.simpleMessage("Ungültige Datei"),
    "invalid_name": MessageLookupByLibrary.simpleMessage("ungültiger name"),
    "invalid_url": MessageLookupByLibrary.simpleMessage(
      "nicht unterstützte URL:\nChecke die Info über unterstützte Webseiten im Infopanel unten",
    ),
    "jan": MessageLookupByLibrary.simpleMessage("Jan."),
    "january": MessageLookupByLibrary.simpleMessage("Januar"),
    "jul": MessageLookupByLibrary.simpleMessage("Jul."),
    "july": MessageLookupByLibrary.simpleMessage("Juli"),
    "jun": MessageLookupByLibrary.simpleMessage("Jun."),
    "june": MessageLookupByLibrary.simpleMessage("Juni"),
    "keep_screen_on": MessageLookupByLibrary.simpleMessage(
      "Bildschirmtimeout deaktivieren",
    ),
    "list_view": MessageLookupByLibrary.simpleMessage("Liste"),
    "loading_data": MessageLookupByLibrary.simpleMessage("Lade Daten..."),
    "locale_full": MessageLookupByLibrary.simpleMessage("de_DE"),
    "manage_categories": MessageLookupByLibrary.simpleMessage(
      "Kategorien verwalten",
    ),
    "manage_ingredients": MessageLookupByLibrary.simpleMessage(
      "Zutaten verwalten",
    ),
    "manage_nutritions": MessageLookupByLibrary.simpleMessage(
      "Nährwerte verwalten",
    ),
    "manage_recipe_tags": MessageLookupByLibrary.simpleMessage(
      "Tags verwalten",
    ),
    "mar": MessageLookupByLibrary.simpleMessage("Mär."),
    "march": MessageLookupByLibrary.simpleMessage("März"),
    "maximum_recipe_pin_count_exceeded": MessageLookupByLibrary.simpleMessage(
      "Du kannst maximal 3 Rezepte anpinnen.",
    ),
    "may": MessageLookupByLibrary.simpleMessage("Mai."),
    "may_full": MessageLookupByLibrary.simpleMessage("Mai"),
    "maybe_later": MessageLookupByLibrary.simpleMessage("SPÄTER"),
    "monday": MessageLookupByLibrary.simpleMessage("Montag"),
    "more_coming_soon": MessageLookupByLibrary.simpleMessage(
      "Mehr in Kürze...",
    ),
    "more_filters": MessageLookupByLibrary.simpleMessage("Filter"),
    "multiple_devices_use_export_as_zip_etc":
        MessageLookupByLibrary.simpleMessage(
          "Teile Rezepte entweder als:\n- Datei, damit du sie auf anderen Geräten in der App hinzufügen kannst\n- in Textform oder\n- als PDF Dokument",
        ),
    "name": MessageLookupByLibrary.simpleMessage("Name"),
    "need_to_access_storage": MessageLookupByLibrary.simpleMessage(
      "Zugriff auf Speicher benötigt",
    ),
    "need_to_access_storage_desc": MessageLookupByLibrary.simpleMessage(
      "Speicherzugriff benötigt, um Datein aus externer Quelle zu lesen und importieren. Beim Tippen auf ok, wird eine Benachrichtigung aufpoppen, welche nach Vergabe der Berechtigung fragt.",
    ),
    "next": MessageLookupByLibrary.simpleMessage("weiter"),
    "no": MessageLookupByLibrary.simpleMessage("nein"),
    "no_added_favorites_yet": MessageLookupByLibrary.simpleMessage(
      "Du hast noch keine Favoriten hinzugefügt",
    ),
    "no_category": MessageLookupByLibrary.simpleMessage("ohne Kategorie"),
    "no_filtered_recipes": MessageLookupByLibrary.simpleMessage(
      "Keine Rezepte passen zu diesen Filtern",
    ),
    "no_internet_connection": MessageLookupByLibrary.simpleMessage(
      "keine Internetverbindung",
    ),
    "no_internet_connection_desc": MessageLookupByLibrary.simpleMessage(
      "es kann kein Werbevideo geladen werden, da keine aktive Internetverbindung vorliegt.",
    ),
    "no_matching_recipes": MessageLookupByLibrary.simpleMessage(
      "Keine passenden Rezpete gefunden",
    ),
    "no_recipe_with_this_name": MessageLookupByLibrary.simpleMessage(
      "Du kannst dem Planer nur Rezepte hinzufügen, die du in der App gespeichert hast.",
    ),
    "no_recipes": MessageLookupByLibrary.simpleMessage("keine Rezepte"),
    "no_recipes_fit_your_filter": MessageLookupByLibrary.simpleMessage(
      "Keine Rezepte passen zum angegebenen Filter",
    ),
    "no_recipes_for_diet": MessageLookupByLibrary.simpleMessage(
      "Du hast keine Rezepte für diese Ernährungsform",
    ),
    "no_recipes_in_collection": MessageLookupByLibrary.simpleMessage(
      "Hier sind noch keine Rezepte",
    ),
    "no_recipes_under_this_category": MessageLookupByLibrary.simpleMessage(
      "Du hast keine Rezepte unter dieser Kategorie",
    ),
    "no_recipes_with_this_tag": MessageLookupByLibrary.simpleMessage(
      "Du hast keine Rezepte mit diesem Tag",
    ),
    "no_thanks": MessageLookupByLibrary.simpleMessage("NEIN DANKE"),
    "no_valid_import_file": MessageLookupByLibrary.simpleMessage(
      "keine gültige import-Datei",
    ),
    "no_valid_number": MessageLookupByLibrary.simpleMessage("invalide Zahl"),
    "none": MessageLookupByLibrary.simpleMessage("keine"),
    "not_required_eg_ingredients_of_sauce":
        MessageLookupByLibrary.simpleMessage(
          "nicht verpflichtend (zB. Zutaten Sauce)",
        ),
    "notes": MessageLookupByLibrary.simpleMessage("Notizen"),
    "nothing_to_search_through": MessageLookupByLibrary.simpleMessage(
      "Nichts zu durchsuchen",
    ),
    "nov": MessageLookupByLibrary.simpleMessage("Nov."),
    "november": MessageLookupByLibrary.simpleMessage("November"),
    "nutrition": MessageLookupByLibrary.simpleMessage("Nährwert"),
    "nutrition_already_exists": MessageLookupByLibrary.simpleMessage(
      "Nährwert existiert bereits",
    ),
    "nutrition_manager_description": MessageLookupByLibrary.simpleMessage(
      "Hier kannst du die Namen der Nährstoffe verwalten. Beim Bearbeiten der exisiterenden bleiben die Nährwerte, der bereits hinzugefügten Rezepte unverändert.",
    ),
    "nutrition_value_hint": MessageLookupByLibrary.simpleMessage("z. B. 18 g"),
    "nutritions": MessageLookupByLibrary.simpleMessage("Nährwerte"),
    "oct": MessageLookupByLibrary.simpleMessage("Okt."),
    "october": MessageLookupByLibrary.simpleMessage("Oktober"),
    "only_recipe_screen": MessageLookupByLibrary.simpleMessage(
      "nur auf Rezeptbildschirm",
    ),
    "out_of": MessageLookupByLibrary.simpleMessage("von"),
    "persons": MessageLookupByLibrary.simpleMessage("Personen"),
    "please_enter_a_name": MessageLookupByLibrary.simpleMessage(
      "bitte gebe einen Namen ein",
    ),
    "prep_time": MessageLookupByLibrary.simpleMessage("Vorb..zeit"),
    "preperation_time": MessageLookupByLibrary.simpleMessage(
      "Vorbereitungszeit",
    ),
    "print_recipe": MessageLookupByLibrary.simpleMessage("Rezept drucken"),
    "pro_version": MessageLookupByLibrary.simpleMessage("Pro-Version"),
    "pro_version_desc": MessageLookupByLibrary.simpleMessage(
      "Zugriff auf Zutatenfilter, Entfernung der Werbung und\nUnterstützung für zukünftige Entwicklung",
    ),
    "professional_search": MessageLookupByLibrary.simpleMessage(
      "Erweiterte Suche",
    ),
    "pull_down_to_refresh": MessageLookupByLibrary.simpleMessage(
      "Scrolle nach unten um die Seite zu aktualisieren und die neuen Rezepte zu sehen",
    ),
    "purchase_pro": MessageLookupByLibrary.simpleMessage("Pro-Version kaufen"),
    "rate": MessageLookupByLibrary.simpleMessage("BEWERTEN"),
    "rate_app": MessageLookupByLibrary.simpleMessage("App bewerten"),
    "rate_this_app": MessageLookupByLibrary.simpleMessage("Diese App bewerten"),
    "rate_this_app_desc": MessageLookupByLibrary.simpleMessage(
      "Entschuldige der Störung. Wenn dir diese App gefällt und du die Entwicklung fördern möchtest, würde ich mich über eine Bewertung im Play Store sehr freuen :)",
    ),
    "ready": MessageLookupByLibrary.simpleMessage("bereit"),
    "recipe_already_exists": m19,
    "recipe_bible": MessageLookupByLibrary.simpleMessage("My RecipeBible"),
    "recipe_count": m20,
    "recipe_edited_or_deleted": MessageLookupByLibrary.simpleMessage(
      "Rezept wurde bearbeitet oder gelöscht:\nGehe zurück zur Übersicht um es anzusehen",
    ),
    "recipe_editor": MessageLookupByLibrary.simpleMessage("Rezepteditor"),
    "recipe_for": MessageLookupByLibrary.simpleMessage("Rezept für"),
    "recipe_import_pc_title": MessageLookupByLibrary.simpleMessage(
      "Wie erstelle ich ein Rezept am PC, um es in der App zu importieren?",
    ),
    "recipe_name": MessageLookupByLibrary.simpleMessage("Rezeptname"),
    "recipe_overview_failed": MessageLookupByLibrary.simpleMessage(
      "Rezepte konnten nicht geladen werden",
    ),
    "recipe_overview_failed_description": MessageLookupByLibrary.simpleMessage(
      "Überprüfe deinen Speicher und versuche es erneut.",
    ),
    "recipe_pinned_to_overview": MessageLookupByLibrary.simpleMessage(
      "Rezept an Hauptansicht angepinnt",
    ),
    "recipe_planer": MessageLookupByLibrary.simpleMessage("Essensplaner"),
    "recipe_screen": MessageLookupByLibrary.simpleMessage("Rezeptansicht"),
    "recipe_studio": MessageLookupByLibrary.simpleMessage("Rezeptstudio"),
    "recipe_summary_with_effort": m21,
    "recipe_tag": MessageLookupByLibrary.simpleMessage("Schlüsselwort"),
    "recipe_tag_already_exists": MessageLookupByLibrary.simpleMessage(
      "Tag bereits vorhanden",
    ),
    "recipe_url": MessageLookupByLibrary.simpleMessage("Rezept-URL"),
    "recipename_taken": MessageLookupByLibrary.simpleMessage(
      "Rezeptname vergeben",
    ),
    "recipename_taken_description": MessageLookupByLibrary.simpleMessage(
      "Hast du vergessen, dass du dieses Rezept schon hinzugefügt hast? Wenn nicht, füge dem Namen etwas hinzu, was das Rezept auszeichnet.",
    ),
    "recipes": MessageLookupByLibrary.simpleMessage("Rezepte"),
    "recipes_not_in_overview": MessageLookupByLibrary.simpleMessage(
      "Wenn die neuen Rezepte nicht in der Hauptansicht angezeigt werden, scrolle auf dieser nach unten um zu aktualisieren oder wechsle die Ansichten.",
    ),
    "recipes_not_showing_up": MessageLookupByLibrary.simpleMessage(
      "Fehlen Rezepte?",
    ),
    "recipes_not_showing_up_desc": MessageLookupByLibrary.simpleMessage(
      "Wenn Rezepte nicht angezeigt werden, scrolle nach unten, um zu aktualisieren.",
    ),
    "remaining_time": MessageLookupByLibrary.simpleMessage("Restzeit"),
    "remove_ads_upgrade_in_settings": MessageLookupByLibrary.simpleMessage(
      "Werbung entfernen\nin den Einstellungen",
    ),
    "remove_from_favorites": MessageLookupByLibrary.simpleMessage(
      "Aus Favoriten entfernen",
    ),
    "remove_ingredient": m22,
    "remove_section": m23,
    "remove_step": m24,
    "remove_step_desc": MessageLookupByLibrary.simpleMessage(
      "Willst du diesen Schritt wirklich entfernen?",
    ),
    "retry": MessageLookupByLibrary.simpleMessage("Erneut versuchen"),
    "roll_the_dice": MessageLookupByLibrary.simpleMessage("Zufällige Rezepte"),
    "saturday": MessageLookupByLibrary.simpleMessage("Samstag"),
    "save": MessageLookupByLibrary.simpleMessage("Speichern"),
    "save_changes": MessageLookupByLibrary.simpleMessage(
      "Änderungen speichern",
    ),
    "save_recipe": MessageLookupByLibrary.simpleMessage("Rezept speichern"),
    "saving_your_input": MessageLookupByLibrary.simpleMessage(
      "speichere Daten",
    ),
    "section_name": MessageLookupByLibrary.simpleMessage("Name"),
    "select_a_category": MessageLookupByLibrary.simpleMessage(
      "Kategorie auswählen",
    ),
    "select_a_date_first": MessageLookupByLibrary.simpleMessage(
      "Wähle ein Datum",
    ),
    "select_all": MessageLookupByLibrary.simpleMessage("alle auswählen"),
    "select_recipe_tags": MessageLookupByLibrary.simpleMessage(
      "Tags auswählen",
    ),
    "select_recipes": MessageLookupByLibrary.simpleMessage("Rezepte auswählen"),
    "select_recipes_to_import": MessageLookupByLibrary.simpleMessage(
      "Wähle Rezepte zum Importieren aus",
    ),
    "select_subcategories": MessageLookupByLibrary.simpleMessage(
      "Kategorien auswählen",
    ),
    "sep": MessageLookupByLibrary.simpleMessage("Sep."),
    "september": MessageLookupByLibrary.simpleMessage("September"),
    "servings": MessageLookupByLibrary.simpleMessage("Portionen"),
    "settings": MessageLookupByLibrary.simpleMessage("Allgemein"),
    "share_recipe": MessageLookupByLibrary.simpleMessage("Rezept teilen"),
    "share_recipes_settings": MessageLookupByLibrary.simpleMessage(
      "teile/sichere deine Rezepte",
    ),
    "share_recipes_settings_desc": MessageLookupByLibrary.simpleMessage(
      "Hier kannst du:\n- Rezepte auswählen, die du als einzelne Datei mit deinen Freuden teilen möchtest, damit sie diese ihrer App hinzufügen können\n- Rezepte auswählen, die du sichern willst, für den Fall der Fälle, dass dein Handy verloren geht und du sich online oder auf anderen Geräten gesichert haben willst.",
    ),
    "share_shopping_list": MessageLookupByLibrary.simpleMessage(
      "Einkaufsliste teilen",
    ),
    "share_this_app": MessageLookupByLibrary.simpleMessage("teile diese App"),
    "share_this_app_desc": m25,
    "share_this_app_title": MessageLookupByLibrary.simpleMessage("Neuigkeiten"),
    "shopping_action_failed": MessageLookupByLibrary.simpleMessage(
      "Die Einkaufsliste konnte nicht aktualisiert werden. Versuche es erneut.",
    ),
    "shopping_add_details": MessageLookupByLibrary.simpleMessage(
      "Zutat mit Menge, Einheit oder Rezept hinzufügen",
    ),
    "shopping_adjust_servings": MessageLookupByLibrary.simpleMessage(
      "Portionen anpassen",
    ),
    "shopping_by_recipe": MessageLookupByLibrary.simpleMessage("Nach Rezept"),
    "shopping_cart_help": MessageLookupByLibrary.simpleMessage(
      "Einkaufsliste Hilfe",
    ),
    "shopping_cart_help_desc": MessageLookupByLibrary.simpleMessage(
      "Um Zutaten zur Einkaufsliste hinzuzufügen, tippe auf das + Icon unten rechts. Um sie wieder von der Liste zu entfernen, die jeweilige Zutat nach links oder rechts wischen. Du kannst auch alle Zutaten eines Rezeptes löschen, indem du das jeweilige Rezept in eine Richtung wischt.",
    ),
    "shopping_cart_is_empty": MessageLookupByLibrary.simpleMessage(
      "Deine Einkaufsliste ist leer",
    ),
    "shopping_empty_description": MessageLookupByLibrary.simpleMessage(
      "Füge hier oder direkt aus einem Rezept Zutaten hinzu.",
    ),
    "shopping_for_recipes": m26,
    "shopping_invalid_servings": MessageLookupByLibrary.simpleMessage(
      "Gib eine Zahl größer als null ein",
    ),
    "shopping_item_count": m27,
    "shopping_list": MessageLookupByLibrary.simpleMessage("Einkaufsliste"),
    "shopping_load_failed": MessageLookupByLibrary.simpleMessage(
      "Deine Einkaufsliste konnte nicht geladen werden",
    ),
    "shopping_load_failed_description": MessageLookupByLibrary.simpleMessage(
      "Überprüfe deinen Speicher und versuche es erneut.",
    ),
    "shopping_market_provisions": MessageLookupByLibrary.simpleMessage(
      "EINKAUFSPLAN",
    ),
    "shopping_mode": MessageLookupByLibrary.simpleMessage("Einkaufsmodus"),
    "shopping_mode_active": MessageLookupByLibrary.simpleMessage(
      "Bildschirm bleibt an",
    ),
    "shopping_more_actions": MessageLookupByLibrary.simpleMessage(
      "Weitere Aktionen für die Einkaufsliste",
    ),
    "shopping_other_items": MessageLookupByLibrary.simpleMessage(
      "Weitere Einträge",
    ),
    "shopping_percent_gathered": m28,
    "shopping_plain_list": MessageLookupByLibrary.simpleMessage(
      "Einfache Liste",
    ),
    "shopping_progress": m29,
    "shopping_quick_add_hint": MessageLookupByLibrary.simpleMessage(
      "Zutat hinzufügen…",
    ),
    "shopping_remove_checked": MessageLookupByLibrary.simpleMessage(
      "Erledigte Einträge entfernen",
    ),
    "shopping_remove_checked_description": m30,
    "shopping_remove_checked_title": MessageLookupByLibrary.simpleMessage(
      "Erledigte Einträge entfernen?",
    ),
    "shopping_remove_item": m31,
    "shopping_removed_items": m32,
    "shopping_search_recipes": MessageLookupByLibrary.simpleMessage(
      "Rezepte durchsuchen",
    ),
    "shopping_serving_value": m33,
    "shoppingcart": MessageLookupByLibrary.simpleMessage("Einkaufsliste"),
    "show_overview": MessageLookupByLibrary.simpleMessage("zur Übersicht"),
    "skip": MessageLookupByLibrary.simpleMessage("überspringen"),
    "snackbar_automatic_theme_applied": MessageLookupByLibrary.simpleMessage(
      "das Theme wird, wenn unterstützt, bei neustart angewendet",
    ),
    "snackbar_bright_theme_applied": MessageLookupByLibrary.simpleMessage(
      "helles Theme angewendet",
    ),
    "snackbar_dark_theme_applied": MessageLookupByLibrary.simpleMessage(
      "dunkles Theme angewendet",
    ),
    "snackbar_midnight_theme_applied": MessageLookupByLibrary.simpleMessage(
      "schwarzes Theme angewendet",
    ),
    "sort_by": m34,
    "source": MessageLookupByLibrary.simpleMessage("Quelle/URL"),
    "standardized_format": MessageLookupByLibrary.simpleMessage(
      "Es werden alle Webseiten unterstützt, die ein standardisiertes Format enthalten. Deshalb ist hier nur ein Teil der unterstützten Webseiten aufgeführt. In der Praxis sollten die meisten Websites unterstützt werden.",
    ),
    "step_description_hint": MessageLookupByLibrary.simpleMessage(
      "Beschreibe, was in diesem Schritt zu tun ist…",
    ),
    "step_title": MessageLookupByLibrary.simpleMessage(
      "Schritttitel (optional)",
    ),
    "steps": MessageLookupByLibrary.simpleMessage("Schritte"),
    "steps_info_desc": MessageLookupByLibrary.simpleMessage(
      "Wenn du mehere Schritte hinzugefügt hast, kannst du sie verschieben, indem du einen Schritt gedrückt hältst. Die Funktion Schritte zu verschieben oder Schritte aus der Mitte zu entfernen ist nur verfügbar, wenn den Schritten keine Bilder hinzgefügt wurden.",
    ),
    "steps_intro": MessageLookupByLibrary.simpleMessage(
      "Tippe auf einen Schritt um ihn auszuwählen, damit du weißt, was du als nächstes machen musst.",
    ),
    "successful": MessageLookupByLibrary.simpleMessage("erfolgreich"),
    "successfully_synced_drive": MessageLookupByLibrary.simpleMessage(
      "Rezepte erfolgreich synchronisiert",
    ),
    "summary": MessageLookupByLibrary.simpleMessage("Zusammenfassung"),
    "sunday": MessageLookupByLibrary.simpleMessage("Sonntag"),
    "supported_websites": MessageLookupByLibrary.simpleMessage(
      "Info über unterstützten Webseiten:",
    ),
    "sure_you_want_to_delete_this_category":
        MessageLookupByLibrary.simpleMessage(
          "Bist du dir sicher, dass du diese Kategorie endgültig löschen willst: ",
        ),
    "sure_you_want_to_delete_this_nutrition":
        MessageLookupByLibrary.simpleMessage(
          "Bist du dir sicher, dass du diesen Nährwert endgültig löschen willst: ",
        ),
    "sure_you_want_to_delete_this_recipe": MessageLookupByLibrary.simpleMessage(
      "Bist du dir sicher, dass du dieses Rezept endgültig:",
    ),
    "sure_you_want_to_delete_this_recipe_tag":
        MessageLookupByLibrary.simpleMessage(
          "Bist du dir sicher, dass du den Tag löschen möchtest:",
        ),
    "switch_shopping_cart_look": MessageLookupByLibrary.simpleMessage(
      "Einkaufwagenansicht ändern",
    ),
    "switch_theme": MessageLookupByLibrary.simpleMessage("Theme"),
    "swype_your_recipes": MessageLookupByLibrary.simpleMessage(
      "Wische durch deine Rezepte",
    ),
    "sync_recipes_drive": MessageLookupByLibrary.simpleMessage(
      "Synchronisiere Rezepte mit Google Drive",
    ),
    "syncing_recipes_drive": MessageLookupByLibrary.simpleMessage(
      "Synchronisiere Rezepte mit Google Drive",
    ),
    "tags": MessageLookupByLibrary.simpleMessage("Tags"),
    "tap_here_to_add_recipe": MessageLookupByLibrary.simpleMessage(
      "Hier kannst du ein neues\nRezept hinzuzufügen",
    ),
    "tap_here_to_import_recipe_online": MessageLookupByLibrary.simpleMessage(
      "Tippe hier um ein Rezept\n online zu importieren",
    ),
    "tap_here_to_manage_categories": MessageLookupByLibrary.simpleMessage(
      "Hier kannst du deine\nKategorien verwalten",
    ),
    "thursday": MessageLookupByLibrary.simpleMessage("Donnerstag"),
    "too_many_images_for_the_steps": MessageLookupByLibrary.simpleMessage(
      "Beschreibung hinzufügen oder Biler entfernen",
    ),
    "too_many_images_for_the_steps_description":
        MessageLookupByLibrary.simpleMessage(
          "Du hast zu mehr Schritten Bilder hinzugefügt, als du eine Beschreibung gegeben hast. Bitte passe es an, sodass keine Daten verloren gehen.",
        ),
    "total_time": MessageLookupByLibrary.simpleMessage("Gesamtzeit"),
    "tuesday": MessageLookupByLibrary.simpleMessage("Dienstag"),
    "two_char_locale": MessageLookupByLibrary.simpleMessage("DE"),
    "undo": MessageLookupByLibrary.simpleMessage("rückgänig"),
    "undo_added_to_planner_description": m35,
    "unit": MessageLookupByLibrary.simpleMessage("Einheit"),
    "untitled_recipe": MessageLookupByLibrary.simpleMessage(
      "Rezept ohne Titel",
    ),
    "uploading_recipe_drive": m36,
    "values_per_serving_optional": MessageLookupByLibrary.simpleMessage(
      "Werte pro Portion · Optional",
    ),
    "vegan": MessageLookupByLibrary.simpleMessage("vegan"),
    "vegetarian": MessageLookupByLibrary.simpleMessage("vegetarisch"),
    "video_to_remove_ads": MessageLookupByLibrary.simpleMessage(
      "Werbevideo zum entfernen der Banner",
    ),
    "video_to_remove_ads_desc": MessageLookupByLibrary.simpleMessage(
      "Wenn du auf \"anzeigen\" tippst, wird dir ein Werbevideo angezeigt und du erhältst für 30 min keine neuen Werbebanner mehr. Bei wiederholtem schauen, erhöht sich die werbebannerfreie Zeit.",
    ),
    "view_intro": MessageLookupByLibrary.simpleMessage("Einführung anschauen"),
    "visit": MessageLookupByLibrary.simpleMessage("1. Besuche "),
    "watch": MessageLookupByLibrary.simpleMessage("anzeigen"),
    "watch_video_remove_ads": MessageLookupByLibrary.simpleMessage(
      "Werbevideo → +30 min werbebannerfrei",
    ),
    "website_import_info": MessageLookupByLibrary.simpleMessage(
      "Um Rezepte schneller aus dem Internet zu importieren und den Link nicht kopieren zu müssen, nutze die \"Teilenfunktion\" des Webbrowsers deiner Wahl und wähle dort die App aus.",
    ),
    "wednesday": MessageLookupByLibrary.simpleMessage("Mittwoch"),
    "with_meat": MessageLookupByLibrary.simpleMessage("mit Fleisch"),
    "yes": MessageLookupByLibrary.simpleMessage("ja"),
    "yield_portions": MessageLookupByLibrary.simpleMessage("Menge & Portionen"),
    "you_already_have": MessageLookupByLibrary.simpleMessage(
      "es gibt schon einen Eintrag",
    ),
    "you_have_no_categories": MessageLookupByLibrary.simpleMessage(
      "du hast noch keine Kategorien hinzugefügt",
    ),
    "you_have_no_ingredients": MessageLookupByLibrary.simpleMessage(
      "Du hast noch keine Zuaten hinzugefügt",
    ),
    "you_have_no_nutritions": MessageLookupByLibrary.simpleMessage(
      "du hast noch keine Nährwerte hinzugefügt",
    ),
    "you_have_no_recipe_tags": MessageLookupByLibrary.simpleMessage(
      "Du hast keine gespeicherten Tags",
    ),
    "you_made_it_to_the_end": MessageLookupByLibrary.simpleMessage(
      "Du bist am Ende angekommen",
    ),
    "your": MessageLookupByLibrary.simpleMessage("Deine"),
  };
}
