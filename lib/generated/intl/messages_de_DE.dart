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

  static String m0(count) => "Alle (${count}) zur Einkaufsliste hinzufügen";

  static String m1(newLine) => "Zutat ${newLine}hinzufügen";

  static String m2(count) => "Übrige (${count}) zur Einkaufsliste hinzufügen";

  static String m3(newLine) => "Bereich ${newLine}hinzufügen";

  static String m4(newLine) => "Schritt ${newLine}hinzufügen";

  static String m5(count) =>
      "${Intl.plural(count, zero: 'keine Sammlungen', one: '1 Sammlung', other: '${count} Sammlungen')}";

  static String m6(count) =>
      "${Intl.plural(count, zero: 'Keine gespeicherten Rezepte', one: '1 gespeichertes Rezept', other: '${count} gespeicherte Rezepte')}";

  static String m7(day) => "Rezept für ${day} hinzufügen";

  static String m8(count) =>
      "${Intl.plural(count, one: '1 Zutatenzeile hinzugefügt', other: '${count} Zutatenzeilen hinzugefügt')}";

  static String m9(recipes, ingredients) =>
      "${Intl.plural(recipes, one: '1 Rezept', other: '${recipes} Rezepte')} · ${Intl.plural(ingredients, one: '1 Zutatenzeile', other: '${ingredients} Zutatenzeilen')}";

  static String m10(count) =>
      "${Intl.plural(count, zero: 'Keine Gerichte', one: '1 Gericht', other: '${count} Gerichte')}";

  static String m11(recipe) => "Weitere Aktionen für ${recipe}";

  static String m12(count) =>
      "${Intl.plural(count, one: 'Einmal eingeplant', other: '${count}-mal eingeplant')}";

  static String m13(recipe) => "${recipe} wurde aus dem Plan entfernt";

  static String m14(recipe) => "Zutaten für ${recipe} auswählen";

  static String m15(count) =>
      "${Intl.plural(count, zero: 'Keine Zutaten ausgewählt', one: '1 Zutat ausgewählt', other: '${count} Zutaten ausgewählt')}";

  static String m16(position) => "Position ${position}";

  static String m17(name, hex) => "${name}, ${hex}";

  static String m18(name) => "„${name}“ löschen?";

  static String m19(name) => "„${name}“ löschen?";

  static String m20(name) => "„${name}“ löschen?";

  static String m21(name) => "Weitere Aktionen für ${name}";

  static String m22(position) => "Position ${position}";

  static String m23(name) => "${name} neu anordnen";

  static String m24(name) => "${name} neu anordnen";

  static String m25(time) => "Garen ${time}";

  static String m26(effort) => "Aufwand: ${effort}/10";

  static String m27(time) => "Vorb. ${time}";

  static String m28(count) => "Alle ansehen (${count})";

  static String m29(time) => "Gesamt: ${time}";

  static String m30(recipe) => "Aktive Phase · ${recipe}";

  static String m31(percent) => "${percent} % abgeschlossen";

  static String m32(count) => "Für diesen Schritt benötigt (${count})";

  static String m33(number) => "Schritt ${number}";

  static String m34(step, total) => "Schritt ${step} von ${total}";

  static String m35(query) => "Keine Ergebnisse für „${query}“";

  static String m36(datatype) =>
      "Der ausgewählte Datentyp \"${datatype}\" wird nicht unterstützt.\nUnterstützte Formate: \".zip\", \".mcb\"";

  static String m37(recipeName) => "Rezept online gelöscht: ${recipeName}";

  static String m38(recipeName) => "Rezept lokal gelöscht: ${recipeName}";

  static String m39(step, total) => "Schritt ${step} von ${total}";

  static String m40(current, total) => "Karte ${current} von ${total}";

  static String m41(effort) => "Aufwand ${effort}/10";

  static String m42(fileName) =>
      "Die ausgewählte Datei wird nicht unterstützt.";

  static String m43(recipeName) => "Rezept importiert: ${recipeName}";

  static String m44(count) =>
      "${Intl.plural(count, zero: 'Keine Zutaten', one: '1 Zutat', other: '${count} Zutaten')}";

  static String m45(count) => "Filter (${count})";

  static String m46(count) =>
      "${Intl.plural(count, zero: 'DEIN KORB', one: 'DEIN KORB · 1 ZUTAT', other: 'DEIN KORB · ${count} ZUTATEN')}";

  static String m47(effort) => "Aufwand ${effort}/10";

  static String m48(count) =>
      "${Intl.plural(count, zero: '(keine gefunden)', one: '(1 gefunden)', other: '(${count} gefunden)')}";

  static String m49(count) => "Du kannst mit bis zu ${count} Zutaten suchen.";

  static String m50(matched, total) => "${matched}/${total} Zutaten";

  static String m51(matched, total) =>
      "${matched} von ${total} ausgewählten Zutaten passen";

  static String m52(count) => "≤ ${count} Min.";

  static String m53(ingredient) => "${ingredient} entfernen";

  static String m54(count) =>
      "${Intl.plural(count, zero: 'Keine Schritte', one: '1 Zubereitungsschritt', other: '${count} Zubereitungsschritte')}";

  static String m55(number) => "Zubereitungsschritt ${number}";

  static String m56(effort) => "Aufwand ${effort}/10";

  static String m57(effort) => "Aufwandsstufe ${effort} wählen";

  static String m58(effort) => "STUFE ${effort} / 10";

  static String m59(current, total) => "Karte ${current} von ${total}";

  static String m60(matched, total) => "${matched}/${total} ZUTATEN PASSEN";

  static String m61(current, total) => "Schritt ${current} von ${total}";

  static String m62(name) =>
      "Rezept mit demselben Namen \"${name}\" bereits vorhanden";

  static String m63(time) => "${time} Kochen";

  static String m64(effort) => "${effort}/10 Aufwand";

  static String m65(time) => "${time} Vorbereitung";

  static String m66(time) => "${time} gesamt";

  static String m67(count) =>
      "${Intl.plural(count, zero: 'Keine Rezepte', one: '1 Rezept', other: '${count} Rezepte')}";

  static String m68(count) => "Filter (${count})";

  static String m69(effort) => "Bis zu ${effort}/10";

  static String m70(count) => "Bis zu ${count} Min.";

  static String m71(count, effort) =>
      "${Intl.plural(count, zero: 'Keine Rezepte', one: '1 Rezept', other: '${count} Rezepte')} • Ø Aufwand ${effort}";

  static String m72(newLine) => "Zutat ${newLine}entfernen";

  static String m73(newLine) => "Bereich ${newLine}entfernen";

  static String m74(newLine) => "Schritt ${newLine}entfernen";

  static String m75(version) =>
      "Mit Geduld für achtsame Küchen gestaltet · v${version}";

  static String m76(count) =>
      "${Intl.plural(count, zero: 'Keine', one: '1 Eintrag', other: '${count} Einträge')}";

  static String m77(count) =>
      "${Intl.plural(count, one: '1 Eintrag konnte nicht gelesen werden. Die alte Sicherung bleibt erhalten, bis das Problem behoben ist.', other: '${count} Einträge konnten nicht gelesen werden. Die alte Sicherung bleibt erhalten, bis das Problem behoben ist.')}";

  static String m78(count) =>
      "${Intl.plural(count, zero: 'Keine Rezepte', one: '1 Rezept', other: '${count} Rezepte')}";

  static String m79(link) =>
      "Mit My RecipeBible habe ich meine Rezepte übersichtlich und immer griffbereit: ${link}";

  static String m80(count) =>
      "${Intl.plural(count, one: 'Einkauf für 1 Rezept', other: 'Einkauf für ${count} Rezepte')}";

  static String m81(count) =>
      "${Intl.plural(count, zero: 'Keine Einträge', one: '1 Eintrag', other: '${count} Einträge')}";

  static String m82(percent) => "${percent}% erledigt";

  static String m83(checked, total) =>
      "${checked} von ${total} Einträgen erledigt";

  static String m84(count) =>
      "${Intl.plural(count, one: 'Damit wird 1 erledigter Eintrag aus der Liste entfernt.', other: 'Damit werden ${count} erledigte Einträge aus der Liste entfernt.')}";

  static String m85(item) => "${item} entfernen";

  static String m86(count) =>
      "${Intl.plural(count, one: '1 Eintrag entfernt', other: '${count} Einträge entfernt')}";

  static String m87(value) => "${value} Portionen";

  static String m88(sort) => "Sortierung: ${sort}";

  static String m89(recipeName, year, month, day) =>
      "${recipeName} zum Rezepteplaner hinzugefügt: \n${day}.${month}.${year}";

  static String m90(recipeName) => "Rezept hochgeladen: ${recipeName}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about_contact_description": MessageLookupByLibrary.simpleMessage(
      "Sende Feedback, Fragen oder Ideen direkt per E-Mail.",
    ),
    "about_contact_failed": MessageLookupByLibrary.simpleMessage(
      "Deine E-Mail-App konnte nicht geöffnet werden. Versuche es erneut.",
    ),
    "about_contact_title": MessageLookupByLibrary.simpleMessage(
      "Entwickler kontaktieren",
    ),
    "about_description": MessageLookupByLibrary.simpleMessage(
      "Speichere, organisiere und koche mit den Rezepten, die dir wichtig sind.",
    ),
    "about_details_section": MessageLookupByLibrary.simpleMessage(
      "App-Details",
    ),
    "about_disclaimer_summary": MessageLookupByLibrary.simpleMessage(
      "Hinweise zu Verantwortung und Nutzung lesen.",
    ),
    "about_disclaimer_title": MessageLookupByLibrary.simpleMessage(
      "Haftungsausschluss",
    ),
    "about_licenses_description": MessageLookupByLibrary.simpleMessage(
      "Lizenzen der in dieser App verwendeten Software ansehen.",
    ),
    "about_licenses_title": MessageLookupByLibrary.simpleMessage(
      "Open-Source-Lizenzen",
    ),
    "about_made_in_muenster": MessageLookupByLibrary.simpleMessage(
      "Mit Sorgfalt in Münster entwickelt.",
    ),
    "about_me": MessageLookupByLibrary.simpleMessage("Info"),
    "about_rate_description": MessageLookupByLibrary.simpleMessage(
      "Hinterlasse eine Bewertung und hilf anderen, die App zu entdecken.",
    ),
    "about_rate_failed": MessageLookupByLibrary.simpleMessage(
      "Google Play konnte nicht geöffnet werden. Prüfe deine Verbindung und versuche es erneut.",
    ),
    "about_rate_title": MessageLookupByLibrary.simpleMessage(
      "Im Google Play Store bewerten",
    ),
    "about_share_description": MessageLookupByLibrary.simpleMessage(
      "Empfiehl My RecipeBible Freunden und Familie.",
    ),
    "about_share_failed": MessageLookupByLibrary.simpleMessage(
      "Das Teilen-Menü konnte nicht geöffnet werden. Versuche es erneut.",
    ),
    "about_share_title": MessageLookupByLibrary.simpleMessage("App teilen"),
    "about_support_section": MessageLookupByLibrary.simpleMessage(
      "Support & Kontakt",
    ),
    "about_tagline": MessageLookupByLibrary.simpleMessage(
      "Dein persönliches Kochbuch – offline, übersichtlich und ganz deins.",
    ),
    "about_title": MessageLookupByLibrary.simpleMessage("Info & Support"),
    "about_version_title": MessageLookupByLibrary.simpleMessage("Version"),
    "about_version_unavailable": MessageLookupByLibrary.simpleMessage(
      "Nicht verfügbar",
    ),
    "ad_free_until": MessageLookupByLibrary.simpleMessage("werbefrei bis"),
    "add": MessageLookupByLibrary.simpleMessage("Hinzufügen"),
    "add_all_to_shopping_list": m0,
    "add_cover_photo": MessageLookupByLibrary.simpleMessage(
      "Titelbild hinzufügen",
    ),
    "add_date": MessageLookupByLibrary.simpleMessage("Datum wählen"),
    "add_favorites": MessageLookupByLibrary.simpleMessage(
      "Lesezeichen hinzufügen",
    ),
    "add_general_info": MessageLookupByLibrary.simpleMessage(
      "Allgemeine Infos",
    ),
    "add_ingredient": m1,
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
    "add_remaining_to_shopping_list": m2,
    "add_section": m3,
    "add_section_to_cart": MessageLookupByLibrary.simpleMessage(
      "Bereich hinzufügen",
    ),
    "add_step": m4,
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
      "Lesezeichen hinzufügen",
    ),
    "all_categories": MessageLookupByLibrary.simpleMessage("alle Kategorien"),
    "all_recipes_filter": MessageLookupByLibrary.simpleMessage("Alle"),
    "almost_done": MessageLookupByLibrary.simpleMessage("Fast fertig😊"),
    "alright": MessageLookupByLibrary.simpleMessage("Alles klar!"),
    "amnt": MessageLookupByLibrary.simpleMessage("Menge"),
    "amount": MessageLookupByLibrary.simpleMessage("Menge"),
    "and_many_more": MessageLookupByLibrary.simpleMessage(
      "Und viele weitere Rezeptseiten.",
    ),
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
    "bookmark_collection_count": m5,
    "bookmark_recipe_count": m6,
    "bookmarked_recipes": MessageLookupByLibrary.simpleMessage(
      "Gespeicherte Rezepte",
    ),
    "bookmarks_empty_description": MessageLookupByLibrary.simpleMessage(
      "Speichere ein Rezept, damit du es schnell wiederfindest.",
    ),
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
    "calendar_add_for_day": m7,
    "calendar_add_selected": MessageLookupByLibrary.simpleMessage(
      "Auswahl hinzufügen",
    ),
    "calendar_empty_day": MessageLookupByLibrary.simpleMessage(
      "Noch nichts geplant",
    ),
    "calendar_export_success": m8,
    "calendar_export_summary": m9,
    "calendar_load_failed": MessageLookupByLibrary.simpleMessage(
      "Dein Essensplan konnte nicht geladen werden",
    ),
    "calendar_load_failed_description": MessageLookupByLibrary.simpleMessage(
      "Überprüfe deinen Speicher und versuche es erneut.",
    ),
    "calendar_meal_count": m10,
    "calendar_more_actions": m11,
    "calendar_next_week": MessageLookupByLibrary.simpleMessage("Nächste Woche"),
    "calendar_no_exportable": MessageLookupByLibrary.simpleMessage(
      "Diese Woche enthält keine exportierbaren Zutaten",
    ),
    "calendar_plan_recipe": MessageLookupByLibrary.simpleMessage(
      "Rezept einplanen",
    ),
    "calendar_planned_count": m12,
    "calendar_previous_week": MessageLookupByLibrary.simpleMessage(
      "Vorherige Woche",
    ),
    "calendar_remove_from_plan": MessageLookupByLibrary.simpleMessage(
      "Aus dem Plan entfernen",
    ),
    "calendar_removed": m13,
    "calendar_review_description": MessageLookupByLibrary.simpleMessage(
      "Passe die Portionen an und wähle ab, was du bereits zu Hause hast.",
    ),
    "calendar_review_export": MessageLookupByLibrary.simpleMessage(
      "Prüfen & exportieren",
    ),
    "calendar_review_title": MessageLookupByLibrary.simpleMessage(
      "Einkaufsliste prüfen",
    ),
    "calendar_select_recipe_ingredients": m14,
    "calendar_selected_count": m15,
    "calendar_servings_not_set": MessageLookupByLibrary.simpleMessage(
      "Portionen nicht angegeben",
    ),
    "calendar_this_week": MessageLookupByLibrary.simpleMessage("Diese Woche"),
    "cancel": MessageLookupByLibrary.simpleMessage("Abbrechen"),
    "cancelling_sync": MessageLookupByLibrary.simpleMessage(
      "Synchronisierung abbrechen...",
    ),
    "catalog_add_category": MessageLookupByLibrary.simpleMessage(
      "Kategorie hinzufügen",
    ),
    "catalog_add_nutrition": MessageLookupByLibrary.simpleMessage(
      "Nährwertangabe hinzufügen",
    ),
    "catalog_add_tag": MessageLookupByLibrary.simpleMessage("Tag hinzufügen"),
    "catalog_categories_description": MessageLookupByLibrary.simpleMessage(
      "Lege fest, in welcher Reihenfolge Kategorien in deinem Kochbuch erscheinen. Ziehe am Griff, um sie neu zu ordnen.",
    ),
    "catalog_categories_empty_description":
        MessageLookupByLibrary.simpleMessage(
          "Erstelle eine Kategorie, um Rezepte nach Mahlzeit, Anlass, Küche oder deinem eigenen System zu gruppieren.",
        ),
    "catalog_categories_empty_title": MessageLookupByLibrary.simpleMessage(
      "Noch keine Kategorien",
    ),
    "catalog_category_order": m16,
    "catalog_choose_tag_color": MessageLookupByLibrary.simpleMessage(
      "Tag-Farbe auswählen",
    ),
    "catalog_color_blue": MessageLookupByLibrary.simpleMessage("Blau"),
    "catalog_color_blue_grey": MessageLookupByLibrary.simpleMessage("Blaugrau"),
    "catalog_color_brown": MessageLookupByLibrary.simpleMessage("Braun"),
    "catalog_color_green": MessageLookupByLibrary.simpleMessage("Grün"),
    "catalog_color_indigo": MessageLookupByLibrary.simpleMessage("Indigo"),
    "catalog_color_olive": MessageLookupByLibrary.simpleMessage("Olivgrün"),
    "catalog_color_orange": MessageLookupByLibrary.simpleMessage("Orange"),
    "catalog_color_paprika": MessageLookupByLibrary.simpleMessage("Paprika"),
    "catalog_color_pink": MessageLookupByLibrary.simpleMessage("Pink"),
    "catalog_color_purple": MessageLookupByLibrary.simpleMessage("Violett"),
    "catalog_color_red": MessageLookupByLibrary.simpleMessage("Rot"),
    "catalog_color_swatch": m17,
    "catalog_color_teal": MessageLookupByLibrary.simpleMessage("Petrol"),
    "catalog_custom_tag_color": MessageLookupByLibrary.simpleMessage(
      "Weitere Farben",
    ),
    "catalog_delete_category_description": MessageLookupByLibrary.simpleMessage(
      "Die Rezepte bleiben in deinem Kochbuch. Diese Kategorie wird aus allen zugeordneten Rezepten entfernt.",
    ),
    "catalog_delete_category_title": m18,
    "catalog_delete_nutrition_description":
        MessageLookupByLibrary.simpleMessage(
          "Bestehende Rezepte behalten ihre gespeicherten Nährwerte. Diese Angabe wird nur aus der Auswahl beim Bearbeiten von Rezepten entfernt.",
        ),
    "catalog_delete_nutrition_title": m19,
    "catalog_delete_tag_description": MessageLookupByLibrary.simpleMessage(
      "Die Rezepte bleiben in deinem Kochbuch. Dieser Tag wird aus allen zugeordneten Rezepten entfernt.",
    ),
    "catalog_delete_tag_title": m20,
    "catalog_edit_category": MessageLookupByLibrary.simpleMessage(
      "Kategorie bearbeiten",
    ),
    "catalog_edit_nutrition": MessageLookupByLibrary.simpleMessage(
      "Nährwertangabe bearbeiten",
    ),
    "catalog_edit_tag": MessageLookupByLibrary.simpleMessage("Tag bearbeiten"),
    "catalog_more_actions": m21,
    "catalog_nutrition_order": m22,
    "catalog_nutritions_description": MessageLookupByLibrary.simpleMessage(
      "Lege fest, welche Nährwertangaben beim Bearbeiten von Rezepten verfügbar sind und in welcher Reihenfolge. Änderungen hier verändern keine bereits gespeicherten Rezeptwerte.",
    ),
    "catalog_nutritions_empty_description":
        MessageLookupByLibrary.simpleMessage(
          "Füge Angaben wie Energie, Protein, Ballaststoffe oder Salz hinzu, damit sie beim Bearbeiten eines Rezepts bereitstehen.",
        ),
    "catalog_nutritions_empty_title": MessageLookupByLibrary.simpleMessage(
      "Noch keine Nährwertangaben",
    ),
    "catalog_reorder_category": m23,
    "catalog_reorder_nutrition": m24,
    "catalog_tag_preview": MessageLookupByLibrary.simpleMessage("Tag-Vorschau"),
    "catalog_tag_row_description": MessageLookupByLibrary.simpleMessage(
      "Farbiger Rezept-Tag",
    ),
    "catalog_tags_description": MessageLookupByLibrary.simpleMessage(
      "Mit farbigen Tags kannst du Rezepte schneller erkennen, gruppieren und filtern.",
    ),
    "catalog_tags_empty_description": MessageLookupByLibrary.simpleMessage(
      "Erstelle einen farbigen Tag für Themen wie schnell, saisonal, Familienliebling oder Meal Prep.",
    ),
    "catalog_tags_empty_title": MessageLookupByLibrary.simpleMessage(
      "Noch keine Rezept-Tags",
    ),
    "categories": MessageLookupByLibrary.simpleMessage("Kategorien"),
    "category": MessageLookupByLibrary.simpleMessage("Kategorie"),
    "category_already_exists": MessageLookupByLibrary.simpleMessage(
      "Kategorie schon vorhanden",
    ),
    "category_cook_short": MessageLookupByLibrary.simpleMessage("Kochen"),
    "category_cook_value": m25,
    "category_effort_not_set": MessageLookupByLibrary.simpleMessage(
      "Aufwand nicht angegeben",
    ),
    "category_effort_value": m26,
    "category_open": MessageLookupByLibrary.simpleMessage("Öffnen"),
    "category_overview_empty_description": MessageLookupByLibrary.simpleMessage(
      "Füge dein erstes Rezept über die + Taste hinzu. Es erscheint dann hier.",
    ),
    "category_overview_empty_title": MessageLookupByLibrary.simpleMessage(
      "Dein Kochbuch ist bereit",
    ),
    "category_prep_short": MessageLookupByLibrary.simpleMessage("Vorbereitung"),
    "category_prep_value": m27,
    "category_section_empty": MessageLookupByLibrary.simpleMessage(
      "Noch keine Rezepte in dieser Kategorie.",
    ),
    "category_see_all": m28,
    "category_start": MessageLookupByLibrary.simpleMessage("Starten"),
    "category_total_short": MessageLookupByLibrary.simpleMessage("Gesamt"),
    "category_total_value": m29,
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
    "clean_recipe_info": MessageLookupByLibrary.simpleMessage("Infos löschen?"),
    "clean_recipe_info_desc": MessageLookupByLibrary.simpleMessage(
      "Willst du wirklich die ausgefüllten Daten des aktuell bearbeiteten/neuen Rezeptes löschen",
    ),
    "clear_filters": MessageLookupByLibrary.simpleMessage("Filter löschen"),
    "clear_search": MessageLookupByLibrary.simpleMessage("Suche löschen"),
    "close_recipe_actions": MessageLookupByLibrary.simpleMessage(
      "Rezeptaktionen schließen",
    ),
    "collapse": MessageLookupByLibrary.simpleMessage("Einklappen"),
    "collapse_dish_of_the_day": MessageLookupByLibrary.simpleMessage(
      "Gericht des Tages einklappen",
    ),
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
    "cook_mode_active_phase": m30,
    "cook_mode_add_minute": MessageLookupByLibrary.simpleMessage(
      "Eine Minute hinzufügen",
    ),
    "cook_mode_add_minute_compact": MessageLookupByLibrary.simpleMessage(
      "+1 Min.",
    ),
    "cook_mode_allow_sleep": MessageLookupByLibrary.simpleMessage(
      "Bildschirm ausschalten lassen",
    ),
    "cook_mode_assistant": MessageLookupByLibrary.simpleMessage(
      "Kochassistent",
    ),
    "cook_mode_cancel_timer": MessageLookupByLibrary.simpleMessage(
      "Timer löschen",
    ),
    "cook_mode_collapse_timer": MessageLookupByLibrary.simpleMessage(
      "Timer einklappen",
    ),
    "cook_mode_end_session": MessageLookupByLibrary.simpleMessage(
      "Sitzung beenden",
    ),
    "cook_mode_exit_message": MessageLookupByLibrary.simpleMessage(
      "Beim Verlassen wird der aktive Timer gestoppt und diese Kochsitzung verworfen.",
    ),
    "cook_mode_exit_title": MessageLookupByLibrary.simpleMessage(
      "Kochmodus beenden?",
    ),
    "cook_mode_expand_timer": MessageLookupByLibrary.simpleMessage(
      "Timer ausklappen",
    ),
    "cook_mode_finish": MessageLookupByLibrary.simpleMessage("Fertig"),
    "cook_mode_finish_and_stop": MessageLookupByLibrary.simpleMessage(
      "Fertig und Timer stoppen",
    ),
    "cook_mode_finish_message": MessageLookupByLibrary.simpleMessage(
      "Du hast den letzten Zubereitungsschritt erreicht.",
    ),
    "cook_mode_finish_timer_message": MessageLookupByLibrary.simpleMessage(
      "Du hast den letzten Zubereitungsschritt erreicht. Beim Beenden wird auch der aktive Timer gestoppt.",
    ),
    "cook_mode_finish_title": MessageLookupByLibrary.simpleMessage(
      "Fertig gekocht",
    ),
    "cook_mode_keep_awake": MessageLookupByLibrary.simpleMessage(
      "Bildschirm aktiv halten",
    ),
    "cook_mode_next": MessageLookupByLibrary.simpleMessage("Weiter"),
    "cook_mode_no_assigned_ingredients": MessageLookupByLibrary.simpleMessage(
      "Diesem Schritt sind keine Zutaten zugewiesen.",
    ),
    "cook_mode_pause_timer": MessageLookupByLibrary.simpleMessage(
      "Timer pausieren",
    ),
    "cook_mode_percent_complete": m31,
    "cook_mode_prepared": MessageLookupByLibrary.simpleMessage("Vorbereitet"),
    "cook_mode_previous": MessageLookupByLibrary.simpleMessage("Zurück"),
    "cook_mode_required_ingredients": m32,
    "cook_mode_reset_timer": MessageLookupByLibrary.simpleMessage(
      "Timer zurücksetzen",
    ),
    "cook_mode_restart_timer": MessageLookupByLibrary.simpleMessage(
      "Neu starten",
    ),
    "cook_mode_resume_timer": MessageLookupByLibrary.simpleMessage(
      "Timer fortsetzen",
    ),
    "cook_mode_set_timer": MessageLookupByLibrary.simpleMessage(
      "Zeit einstellen",
    ),
    "cook_mode_start_timer": MessageLookupByLibrary.simpleMessage(
      "Timer starten",
    ),
    "cook_mode_stay": MessageLookupByLibrary.simpleMessage("Weiterkochen"),
    "cook_mode_step_fallback": m33,
    "cook_mode_step_instructions": MessageLookupByLibrary.simpleMessage(
      "Zubereitungsschritt",
    ),
    "cook_mode_step_progress": m34,
    "cook_mode_timer": MessageLookupByLibrary.simpleMessage("Timer"),
    "cook_mode_timer_complete": MessageLookupByLibrary.simpleMessage(
      "Timer beendet",
    ),
    "cook_mode_timer_complete_message": MessageLookupByLibrary.simpleMessage(
      "Die Zeit für diesen Zubereitungsschritt ist abgelaufen.",
    ),
    "cook_mode_timer_hours": MessageLookupByLibrary.simpleMessage("Stunden"),
    "cook_mode_timer_invalid": MessageLookupByLibrary.simpleMessage(
      "Gib eine Dauer größer als null ein.",
    ),
    "cook_mode_timer_minutes": MessageLookupByLibrary.simpleMessage("Minuten"),
    "cook_mode_timer_save": MessageLookupByLibrary.simpleMessage(
      "Timer einstellen",
    ),
    "cook_mode_timer_seconds": MessageLookupByLibrary.simpleMessage("Sekunden"),
    "cook_mode_timer_sheet_title": MessageLookupByLibrary.simpleMessage(
      "Küchentimer einstellen",
    ),
    "cook_mode_title": MessageLookupByLibrary.simpleMessage("Kochmodus"),
    "cook_time": MessageLookupByLibrary.simpleMessage("Koch-/Backzeit"),
    "cookbook_search_empty_description": MessageLookupByLibrary.simpleMessage(
      "Füge ein Rezept, eine Kategorie oder einen Tag hinzu, um hier danach zu suchen.",
    ),
    "cookbook_search_hint": MessageLookupByLibrary.simpleMessage(
      "Rezepte, Kategorien oder Tags durchsuchen",
    ),
    "cookbook_search_no_results_description":
        MessageLookupByLibrary.simpleMessage(
          "Versuche es mit einem anderen Rezeptnamen, einer Kategorie oder einem Tag.",
        ),
    "cookbook_search_no_results_title": m35,
    "cookbook_search_prompt_description": MessageLookupByLibrary.simpleMessage(
      "Suche in deinem Kochbuch nach Rezeptname, Kategorie oder Tag.",
    ),
    "cookbook_search_prompt_title": MessageLookupByLibrary.simpleMessage(
      "Was möchtest du kochen?",
    ),
    "cookbook_search_recipe_missing": MessageLookupByLibrary.simpleMessage(
      "Dieses Rezept ist nicht mehr verfügbar.",
    ),
    "create_manually": MessageLookupByLibrary.simpleMessage(
      "Manuell erstellen",
    ),
    "data_required": MessageLookupByLibrary.simpleMessage("bitte ausfüllen"),
    "datatype_not_supported": m36,
    "dec": MessageLookupByLibrary.simpleMessage("Dez."),
    "december": MessageLookupByLibrary.simpleMessage("Dezember"),
    "decrease_servings": MessageLookupByLibrary.simpleMessage(
      "Portionen verringern",
    ),
    "delete": MessageLookupByLibrary.simpleMessage("Löschen"),
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
    "deleting_recipe_drive": m37,
    "deleting_recipe_local": m38,
    "descending": MessageLookupByLibrary.simpleMessage("Absteigend"),
    "description": MessageLookupByLibrary.simpleMessage("Beschreibung"),
    "diet_meat": MessageLookupByLibrary.simpleMessage("Fleisch"),
    "diet_vegan": MessageLookupByLibrary.simpleMessage("Vegan"),
    "diet_vegetarian": MessageLookupByLibrary.simpleMessage("Vegetarisch"),
    "dietary_preference": MessageLookupByLibrary.simpleMessage(
      "Ernährungsweise",
    ),
    "directions": MessageLookupByLibrary.simpleMessage("Zubereitung"),
    "disclaimer_description": MessageLookupByLibrary.simpleMessage(
      "Der Autor von My RecipeBible haftet in keinem Fall für Schäden, die direkt oder indirekt durch die Anwendung entstehen. Mit der Nutzung bestätigst du, dass du die volle Verantwortung dafür trägst, was du mit My RecipeBible tust.",
    ),
    "dish_basics_timing": MessageLookupByLibrary.simpleMessage(
      "Gericht & Zeitplanung",
    ),
    "dish_of_the_day": MessageLookupByLibrary.simpleMessage(
      "Gericht des Tages",
    ),
    "dismiss": MessageLookupByLibrary.simpleMessage("verbergen"),
    "done": MessageLookupByLibrary.simpleMessage("fertig"),
    "duplicate": MessageLookupByLibrary.simpleMessage("Duplikat"),
    "edit": MessageLookupByLibrary.simpleMessage("editieren"),
    "editor_general": MessageLookupByLibrary.simpleMessage("Allgemein"),
    "editor_ingredients": MessageLookupByLibrary.simpleMessage("Zutaten"),
    "editor_instructions": MessageLookupByLibrary.simpleMessage("Zubereitung"),
    "editor_nutrition": MessageLookupByLibrary.simpleMessage("Nährwerte"),
    "editor_progress": m39,
    "effort": MessageLookupByLibrary.simpleMessage("Aufwand"),
    "effort_calibration": MessageLookupByLibrary.simpleMessage("Aufwand"),
    "enter_some_information": MessageLookupByLibrary.simpleMessage(
      "Informationen angeben",
    ),
    "enter_url": MessageLookupByLibrary.simpleMessage("Link zum Rezept"),
    "expand_dish_of_the_day": MessageLookupByLibrary.simpleMessage(
      "Gericht des Tages ausklappen",
    ),
    "explore": MessageLookupByLibrary.simpleMessage("Zufällig"),
    "explore_all_recipes": MessageLookupByLibrary.simpleMessage("Alle Rezepte"),
    "explore_card_counter": m40,
    "explore_change_filter": MessageLookupByLibrary.simpleMessage(
      "Filter ändern",
    ),
    "explore_complete_message": MessageLookupByLibrary.simpleMessage(
      "Mische den Stapel, um diese Rezepte in neuer Reihenfolge zu entdecken.",
    ),
    "explore_complete_title": MessageLookupByLibrary.simpleMessage(
      "Du hast den ganzen Stapel entdeckt",
    ),
    "explore_cook": MessageLookupByLibrary.simpleMessage("Kochen starten"),
    "explore_cook_tonight": MessageLookupByLibrary.simpleMessage(
      "Heute kochen",
    ),
    "explore_discover": MessageLookupByLibrary.simpleMessage(
      "Wischen & entdecken",
    ),
    "explore_effort": m41,
    "explore_empty_message": MessageLookupByLibrary.simpleMessage(
      "Wähle einen anderen Filter oder füge dieser Auswahl Rezepte hinzu.",
    ),
    "explore_empty_title": MessageLookupByLibrary.simpleMessage(
      "Hier gibt es noch nichts zu entdecken",
    ),
    "explore_error_message": MessageLookupByLibrary.simpleMessage(
      "Versuche, deine Rezepte erneut zu laden.",
    ),
    "explore_error_title": MessageLookupByLibrary.simpleMessage(
      "Der Rezeptstapel konnte nicht geladen werden",
    ),
    "explore_filter_title": MessageLookupByLibrary.simpleMessage(
      "Wähle deine Entdeckung",
    ),
    "explore_filters": MessageLookupByLibrary.simpleMessage("Filter"),
    "explore_ingredients_snapshot": MessageLookupByLibrary.simpleMessage(
      "Zutatenübersicht",
    ),
    "explore_open_recipe": MessageLookupByLibrary.simpleMessage(
      "Rezept öffnen",
    ),
    "explore_pass": MessageLookupByLibrary.simpleMessage("Weiter"),
    "explore_restart": MessageLookupByLibrary.simpleMessage(
      "Mischen & neu starten",
    ),
    "explore_retry": MessageLookupByLibrary.simpleMessage("Erneut versuchen"),
    "explore_rewind": MessageLookupByLibrary.simpleMessage(
      "Vorheriges Rezept anzeigen",
    ),
    "explore_save": MessageLookupByLibrary.simpleMessage(
      "Für später speichern",
    ),
    "explore_saved": MessageLookupByLibrary.simpleMessage(
      "Für später gespeichert",
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
      "Die Rezeptseite konnte nicht erreicht werden",
    ),
    "failed_to_import_recipe_unknown_reason":
        MessageLookupByLibrary.simpleMessage(
          "Das Rezept konnte nicht importiert werden",
        ),
    "favorites": MessageLookupByLibrary.simpleMessage("Lesezeichen"),
    "feb": MessageLookupByLibrary.simpleMessage("Feb."),
    "february": MessageLookupByLibrary.simpleMessage("Februar"),
    "field_must_not_be_empty": MessageLookupByLibrary.simpleMessage(
      "Textfeld darf nicht leer sein",
    ),
    "file_not_supported": m42,
    "filter_recipes": MessageLookupByLibrary.simpleMessage(
      "Rezepte filtern...",
    ),
    "finished": MessageLookupByLibrary.simpleMessage("fertig"),
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
    "importing_recipe_drive": m43,
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
    "ingredient_count": m44,
    "ingredient_filter_description": MessageLookupByLibrary.simpleMessage(
      "Kaufe die Vollversion in den Einstellungen um Zugriff zum Zutatenfilter zu bekommen",
    ),
    "ingredient_manager_description": MessageLookupByLibrary.simpleMessage(
      "Hier kannst du die Namen der Zutaten, die dir vorgeschlagen werden, ändern oder hinzufügen. Die Zutaten der bereits hinzugefügten Rezepte bleiben unverändert. Es dient lediglich der Zeitersparnis beim Eintippen der Zutaten.",
    ),
    "ingredient_matches": MessageLookupByLibrary.simpleMessage(
      "Zutatentreffer",
    ),
    "ingredient_search_active_filters": m45,
    "ingredient_search_add": MessageLookupByLibrary.simpleMessage(
      "Zutat hinzufügen",
    ),
    "ingredient_search_adjust_filters": MessageLookupByLibrary.simpleMessage(
      "Filter anpassen",
    ),
    "ingredient_search_all": MessageLookupByLibrary.simpleMessage("Alle"),
    "ingredient_search_any_effort": MessageLookupByLibrary.simpleMessage(
      "Beliebiger Aufwand",
    ),
    "ingredient_search_any_time": MessageLookupByLibrary.simpleMessage(
      "Beliebige Zeit",
    ),
    "ingredient_search_basket_count": m46,
    "ingredient_search_basket_empty": MessageLookupByLibrary.simpleMessage(
      "Füge eine oder mehrere Zutaten hinzu, um dein Kochbuch zu durchsuchen.",
    ),
    "ingredient_search_clear_all": MessageLookupByLibrary.simpleMessage(
      "Alle entfernen",
    ),
    "ingredient_search_description": MessageLookupByLibrary.simpleMessage(
      "Füge Zutaten aus deiner Küche hinzu, verfeinere die Filter und finde passende Rezepte.",
    ),
    "ingredient_search_effort_cap": MessageLookupByLibrary.simpleMessage(
      "MAX. AUFWAND",
    ),
    "ingredient_search_effort_unknown": MessageLookupByLibrary.simpleMessage(
      "Aufwand —",
    ),
    "ingredient_search_effort_value": m47,
    "ingredient_search_empty_description": MessageLookupByLibrary.simpleMessage(
      "Füge eine Zutat hinzu oder wähle einen Filter, um Rezepte aus deiner Sammlung zu sehen.",
    ),
    "ingredient_search_empty_title": MessageLookupByLibrary.simpleMessage(
      "Fülle deinen Zutatenkorb",
    ),
    "ingredient_search_failed": MessageLookupByLibrary.simpleMessage(
      "Rezepte konnten nicht durchsucht werden",
    ),
    "ingredient_search_failed_description":
        MessageLookupByLibrary.simpleMessage(
          "Prüfe deinen Speicher und versuche die Suche erneut.",
        ),
    "ingredient_search_filters_title": MessageLookupByLibrary.simpleMessage(
      "Treffer verfeinern",
    ),
    "ingredient_search_found": m48,
    "ingredient_search_heading": MessageLookupByLibrary.simpleMessage(
      "Koche mit dem, was da ist",
    ),
    "ingredient_search_input_hint": MessageLookupByLibrary.simpleMessage(
      "Zutat hinzufügen…",
    ),
    "ingredient_search_limit": m49,
    "ingredient_search_match_badge": m50,
    "ingredient_search_match_summary": m51,
    "ingredient_search_max_time": MessageLookupByLibrary.simpleMessage(
      "MAX. ZEIT",
    ),
    "ingredient_search_meat": MessageLookupByLibrary.simpleMessage("Fleisch"),
    "ingredient_search_minutes": m52,
    "ingredient_search_more_filters": MessageLookupByLibrary.simpleMessage(
      "Weitere Filter",
    ),
    "ingredient_search_no_limit": MessageLookupByLibrary.simpleMessage(
      "Kein Limit",
    ),
    "ingredient_search_no_matches": MessageLookupByLibrary.simpleMessage(
      "Noch keine passenden Rezepte",
    ),
    "ingredient_search_no_matches_description":
        MessageLookupByLibrary.simpleMessage(
          "Entferne eine Zutat oder erweitere die Zeit- und Aufwandsgrenzen.",
        ),
    "ingredient_search_preview_description":
        MessageLookupByLibrary.simpleMessage(
          "Wähle Zutaten aus deiner Küche und finde passende Rezepte in deiner eigenen Sammlung. Verfeinere die Treffer nach Ernährungsform, Zeit, Aufwand, Kategorien oder Tags.",
        ),
    "ingredient_search_preview_effort_cap":
        MessageLookupByLibrary.simpleMessage("Aufwand ≤5"),
    "ingredient_search_preview_example": MessageLookupByLibrary.simpleMessage(
      "BEISPIELTREFFER",
    ),
    "ingredient_search_preview_example_recipe":
        MessageLookupByLibrary.simpleMessage("Cremige Spinatpasta"),
    "ingredient_search_preview_filtered_by":
        MessageLookupByLibrary.simpleMessage("GEFILTERT NACH"),
    "ingredient_search_preview_own_description":
        MessageLookupByLibrary.simpleMessage(
          "Gleiche Zutaten mit den Rezepten ab, die auf diesem Gerät gespeichert sind.",
        ),
    "ingredient_search_preview_own_title": MessageLookupByLibrary.simpleMessage(
      "Durchsuche dein Kochbuch",
    ),
    "ingredient_search_preview_pasta": MessageLookupByLibrary.simpleMessage(
      "Pasta",
    ),
    "ingredient_search_preview_pro_badge": MessageLookupByLibrary.simpleMessage(
      "PRO-FUNKTION",
    ),
    "ingredient_search_preview_pro_description":
        MessageLookupByLibrary.simpleMessage(
          "Der einmalige Kauf entfernt außerdem Werbung in der App und unterstützt die Weiterentwicklung.",
        ),
    "ingredient_search_preview_pro_title": MessageLookupByLibrary.simpleMessage(
      "Außerdem in Pro enthalten",
    ),
    "ingredient_search_preview_recipe_time":
        MessageLookupByLibrary.simpleMessage("25 Min."),
    "ingredient_search_preview_refine_description":
        MessageLookupByLibrary.simpleMessage(
          "Grenze Treffer nach Ernährungsform, Zeit, Aufwand, Kategorien und Tags ein.",
        ),
    "ingredient_search_preview_refine_title":
        MessageLookupByLibrary.simpleMessage("Verfeinere jeden Treffer"),
    "ingredient_search_preview_save_description":
        MessageLookupByLibrary.simpleMessage(
          "Sortiere nach bester Übereinstimmung, Zeit, Aufwand oder Name und öffne oder merke ein Rezept.",
        ),
    "ingredient_search_preview_save_title":
        MessageLookupByLibrary.simpleMessage("Sortieren, öffnen und merken"),
    "ingredient_search_preview_semantics": MessageLookupByLibrary.simpleMessage(
      "Schreibgeschütztes Beispiel einer Zutatensuche mit Spinat, Pasta und Tomaten, verfeinert auf ein vegetarisches Rezept unter 30 Minuten und mit Aufwand bis Stufe 5.",
    ),
    "ingredient_search_preview_spinach": MessageLookupByLibrary.simpleMessage(
      "Spinat",
    ),
    "ingredient_search_preview_tomatoes": MessageLookupByLibrary.simpleMessage(
      "Tomaten",
    ),
    "ingredient_search_preview_unlock": MessageLookupByLibrary.simpleMessage(
      "Zutatensuche freischalten",
    ),
    "ingredient_search_preview_unlock_description":
        MessageLookupByLibrary.simpleMessage(
          "Einmaliger Pro-Kauf · Entfernt Werbung · Unterstützt die Weiterentwicklung",
        ),
    "ingredient_search_remove": m53,
    "ingredient_search_reset": MessageLookupByLibrary.simpleMessage(
      "Zurücksetzen",
    ),
    "ingredient_search_results": MessageLookupByLibrary.simpleMessage(
      "Passende Rezepte",
    ),
    "ingredient_search_sort_best": MessageLookupByLibrary.simpleMessage(
      "Beste Treffer",
    ),
    "ingredient_search_sort_effort": MessageLookupByLibrary.simpleMessage(
      "Geringster Aufwand",
    ),
    "ingredient_search_sort_name": MessageLookupByLibrary.simpleMessage(
      "Name A–Z",
    ),
    "ingredient_search_sort_time": MessageLookupByLibrary.simpleMessage(
      "Kürzeste Zeit",
    ),
    "ingredient_search_time_unknown": MessageLookupByLibrary.simpleMessage(
      "Zeit nicht angegeben",
    ),
    "ingredient_search_title": MessageLookupByLibrary.simpleMessage(
      "Zutatensuche",
    ),
    "ingredient_search_vegan": MessageLookupByLibrary.simpleMessage("Vegan"),
    "ingredient_search_vegetarian": MessageLookupByLibrary.simpleMessage(
      "Vegetarisch",
    ),
    "ingredient_section_empty": MessageLookupByLibrary.simpleMessage(
      "Dieser Bereich enthält noch keine Zutaten.",
    ),
    "ingredients": MessageLookupByLibrary.simpleMessage("Zutaten"),
    "ingredients_for": MessageLookupByLibrary.simpleMessage("Zutaten für:"),
    "ingredients_for_step": MessageLookupByLibrary.simpleMessage(
      "Zutaten für diesen Schritt",
    ),
    "instruction_count": m54,
    "instruction_number": m55,
    "instructions_empty": MessageLookupByLibrary.simpleMessage(
      "Beginne mit dem ersten Zubereitungsschritt.",
    ),
    "invalid_datatype": MessageLookupByLibrary.simpleMessage(
      "Ungültiger Datentyp",
    ),
    "invalid_file": MessageLookupByLibrary.simpleMessage("Ungültige Datei"),
    "invalid_name": MessageLookupByLibrary.simpleMessage("ungültiger name"),
    "invalid_url": MessageLookupByLibrary.simpleMessage(
      "Diese Rezeptseite wird noch nicht unterstützt",
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
    "manage_bookmark_collections": MessageLookupByLibrary.simpleMessage(
      "Sammlungen verwalten",
    ),
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
    "name": MessageLookupByLibrary.simpleMessage("Name"),
    "need_to_access_storage": MessageLookupByLibrary.simpleMessage(
      "Zugriff auf Speicher benötigt",
    ),
    "need_to_access_storage_desc": MessageLookupByLibrary.simpleMessage(
      "Speicherzugriff benötigt, um Datein aus externer Quelle zu lesen und importieren. Beim Tippen auf ok, wird eine Benachrichtigung aufpoppen, welche nach Vergabe der Berechtigung fragt.",
    ),
    "new_collection": MessageLookupByLibrary.simpleMessage("Neu"),
    "next": MessageLookupByLibrary.simpleMessage("weiter"),
    "no": MessageLookupByLibrary.simpleMessage("nein"),
    "no_added_favorites_yet": MessageLookupByLibrary.simpleMessage(
      "Du hast noch keine Lesezeichen hinzugefügt",
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
    "onboarding_continue": MessageLookupByLibrary.simpleMessage("Weiter"),
    "onboarding_cook_awake_description": MessageLookupByLibrary.simpleMessage(
      "Aktiviere es für die aktuelle Kochsession.",
    ),
    "onboarding_cook_awake_title": MessageLookupByLibrary.simpleMessage(
      "Display wach halten",
    ),
    "onboarding_cook_description": MessageLookupByLibrary.simpleMessage(
      "Arbeite dich Schritt für Schritt durch ein Rezept, sieh die zugeordneten Zutaten und behalte den Timer in Reichweite.",
    ),
    "onboarding_cook_glanceable_description":
        MessageLookupByLibrary.simpleMessage("Immer nur eine klare Anweisung."),
    "onboarding_cook_glanceable_title": MessageLookupByLibrary.simpleMessage(
      "Schritte auf einen Blick",
    ),
    "onboarding_cook_sample_ingredient": MessageLookupByLibrary.simpleMessage(
      "1 Tasse trockener Rotwein",
    ),
    "onboarding_cook_sample_instruction": MessageLookupByLibrary.simpleMessage(
      "Gib den Wein hinzu, löse den Bratensatz vom Pfannenboden und lasse alles auf die Hälfte einkochen.",
    ),
    "onboarding_cook_sample_recipe": MessageLookupByLibrary.simpleMessage(
      "GERÖSTETE TOMATENPASTA",
    ),
    "onboarding_cook_sample_step": MessageLookupByLibrary.simpleMessage(
      "Ablöschen und reduzieren",
    ),
    "onboarding_cook_step_count": MessageLookupByLibrary.simpleMessage(
      "3 von 7",
    ),
    "onboarding_cook_title": MessageLookupByLibrary.simpleMessage(
      "Verliere am Herd nie den Faden.",
    ),
    "onboarding_effort_ambitious": MessageLookupByLibrary.simpleMessage(
      "Anspruchsvoll",
    ),
    "onboarding_effort_badge": m56,
    "onboarding_effort_balanced": MessageLookupByLibrary.simpleMessage(
      "Ausgewogen",
    ),
    "onboarding_effort_choose": m57,
    "onboarding_effort_description": MessageLookupByLibrary.simpleMessage(
      "Bewerte Rezepte von 1 bis 10 und sortiere deine Sammlung nach Aufwand, wenn du auswählst, was du kochen möchtest.",
    ),
    "onboarding_effort_easy_detail": MessageLookupByLibrary.simpleMessage(
      "Ein leichtes Rezept für einen vollen Abend.",
    ),
    "onboarding_effort_easy_recipe": MessageLookupByLibrary.simpleMessage(
      "Knackiger Gartensalat",
    ),
    "onboarding_effort_five": MessageLookupByLibrary.simpleMessage(
      "5 Ausgewogen",
    ),
    "onboarding_effort_gentle": MessageLookupByLibrary.simpleMessage(
      "Entspannt",
    ),
    "onboarding_effort_level": m58,
    "onboarding_effort_one": MessageLookupByLibrary.simpleMessage(
      "1 Entspannt",
    ),
    "onboarding_effort_project_detail": MessageLookupByLibrary.simpleMessage(
      "Mehr Zeit und Aufmerksamkeit für einen ruhigen Tag.",
    ),
    "onboarding_effort_project_recipe": MessageLookupByLibrary.simpleMessage(
      "Langsam geröstete Gemüsepasta",
    ),
    "onboarding_effort_scale": MessageLookupByLibrary.simpleMessage(
      "Deine Aufwandsskala",
    ),
    "onboarding_effort_ten": MessageLookupByLibrary.simpleMessage(
      "10 Anspruchsvoll",
    ),
    "onboarding_effort_title": MessageLookupByLibrary.simpleMessage(
      "Wähle ein Rezept, das zu deiner Energie passt.",
    ),
    "onboarding_explore_card": m59,
    "onboarding_explore_description": MessageLookupByLibrary.simpleMessage(
      "Blättere als Kartenstapel durch deine eigenen Rezepte: nach links weiter, nach oben speichern und nach rechts kochen.",
    ),
    "onboarding_explore_fallback": MessageLookupByLibrary.simpleMessage(
      "Rezepte ohne Schritte öffnen sich stattdessen in der Detailansicht.",
    ),
    "onboarding_explore_recipe_one": MessageLookupByLibrary.simpleMessage(
      "Geröstete Gemüsepasta",
    ),
    "onboarding_explore_recipe_one_detail":
        MessageLookupByLibrary.simpleMessage(
          "Ein farbenfrohes Vorratsgericht mit Kräutern und Tomaten.",
        ),
    "onboarding_explore_recipe_three": MessageLookupByLibrary.simpleMessage(
      "Tomaten-Basilikum-Spaghetti",
    ),
    "onboarding_explore_recipe_three_detail":
        MessageLookupByLibrary.simpleMessage(
          "Ein vertrautes Feierabendgericht aus deiner eigenen Sammlung.",
        ),
    "onboarding_explore_recipe_two": MessageLookupByLibrary.simpleMessage(
      "Sommerlicher Gartensalat",
    ),
    "onboarding_explore_recipe_two_detail":
        MessageLookupByLibrary.simpleMessage(
          "Frisches Obst, Blattsalat, Avocado und geröstete Nüsse.",
        ),
    "onboarding_explore_title": MessageLookupByLibrary.simpleMessage(
      "Wische, bis das Abendessen feststeht.",
    ),
    "onboarding_open_cookbook": MessageLookupByLibrary.simpleMessage(
      "Mein Kochbuch öffnen",
    ),
    "onboarding_pantry_description": MessageLookupByLibrary.simpleMessage(
      "Die Pro-Zutatensuche gleicht deine Küche mit Rezepten auf diesem Gerät ab. Zutaten aus jedem Rezept kannst du einer abhakbaren Einkaufsliste hinzufügen.",
    ),
    "onboarding_pantry_match": m60,
    "onboarding_pantry_pasta": MessageLookupByLibrary.simpleMessage("Nudeln"),
    "onboarding_pantry_pro": MessageLookupByLibrary.simpleMessage(
      "PRO-FUNKTION",
    ),
    "onboarding_pantry_sample_detail": MessageLookupByLibrary.simpleMessage(
      "25 Min. · Aufwand 4/10",
    ),
    "onboarding_pantry_sample_recipe": MessageLookupByLibrary.simpleMessage(
      "Cremige Spinatpasta",
    ),
    "onboarding_pantry_search_title": MessageLookupByLibrary.simpleMessage(
      "Zutatensuche",
    ),
    "onboarding_pantry_spinach": MessageLookupByLibrary.simpleMessage("Spinat"),
    "onboarding_pantry_title": MessageLookupByLibrary.simpleMessage(
      "Koche mit dem, was du hast. Kaufe ein, was dir fehlt.",
    ),
    "onboarding_pantry_tomatoes": MessageLookupByLibrary.simpleMessage(
      "Tomaten",
    ),
    "onboarding_progress": m61,
    "onboarding_shopping_cream": MessageLookupByLibrary.simpleMessage(
      "Kochsahne",
    ),
    "onboarding_shopping_garlic": MessageLookupByLibrary.simpleMessage(
      "Knoblauch",
    ),
    "onboarding_shopping_parmesan": MessageLookupByLibrary.simpleMessage(
      "Parmesan",
    ),
    "onboarding_shopping_servings": MessageLookupByLibrary.simpleMessage(
      "4 Portionen",
    ),
    "onboarding_shopping_title": MessageLookupByLibrary.simpleMessage(
      "Einkaufsliste aus Rezepten",
    ),
    "only_recipe_screen": MessageLookupByLibrary.simpleMessage(
      "nur auf Rezeptbildschirm",
    ),
    "open_recipe": MessageLookupByLibrary.simpleMessage("Rezept öffnen"),
    "out_of": MessageLookupByLibrary.simpleMessage("von"),
    "pantry_checklist": MessageLookupByLibrary.simpleMessage("Zutatenliste"),
    "pantry_checklist_help": MessageLookupByLibrary.simpleMessage(
      "Tippe auf Zutaten, um sie zur Einkaufsliste hinzuzufügen oder daraus zu entfernen.",
    ),
    "persons": MessageLookupByLibrary.simpleMessage("Personen"),
    "pin_recipe": MessageLookupByLibrary.simpleMessage("Rezept anpinnen"),
    "please_enter_a_name": MessageLookupByLibrary.simpleMessage(
      "bitte gebe einen Namen ein",
    ),
    "prep_time": MessageLookupByLibrary.simpleMessage("Vorb..zeit"),
    "preparation_timeline": MessageLookupByLibrary.simpleMessage(
      "Zubereitungsablauf",
    ),
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
    "recipe_actions": MessageLookupByLibrary.simpleMessage("Rezeptaktionen"),
    "recipe_actions_collapsed": MessageLookupByLibrary.simpleMessage(
      "Geschlossen",
    ),
    "recipe_actions_expanded": MessageLookupByLibrary.simpleMessage("Geöffnet"),
    "recipe_actions_hint": MessageLookupByLibrary.simpleMessage(
      "Zeigt Möglichkeiten, ein Rezept hinzuzufügen",
    ),
    "recipe_already_exists": m62,
    "recipe_bible": MessageLookupByLibrary.simpleMessage("My RecipeBible"),
    "recipe_card_cook_time": m63,
    "recipe_card_effort_value": m64,
    "recipe_card_prep_time": m65,
    "recipe_card_time_unknown": MessageLookupByLibrary.simpleMessage(
      "Zeit nicht angegeben",
    ),
    "recipe_card_total_time": m66,
    "recipe_count": m67,
    "recipe_detail": MessageLookupByLibrary.simpleMessage("Rezeptdetails"),
    "recipe_details": MessageLookupByLibrary.simpleMessage(
      "Weitere Rezeptdetails",
    ),
    "recipe_edited_or_deleted": MessageLookupByLibrary.simpleMessage(
      "Rezept wurde bearbeitet oder gelöscht:\nGehe zurück zur Übersicht um es anzusehen",
    ),
    "recipe_editor": MessageLookupByLibrary.simpleMessage("Rezepteditor"),
    "recipe_filters_active": m68,
    "recipe_filters_any_diet": MessageLookupByLibrary.simpleMessage(
      "Alle Ernährungsformen",
    ),
    "recipe_filters_diet": MessageLookupByLibrary.simpleMessage(
      "Ernährungsform",
    ),
    "recipe_filters_effort_value": m69,
    "recipe_filters_max_effort": MessageLookupByLibrary.simpleMessage(
      "Maximaler Aufwand",
    ),
    "recipe_filters_max_time": MessageLookupByLibrary.simpleMessage(
      "Maximale Gesamtzeit",
    ),
    "recipe_filters_minutes": m70,
    "recipe_filters_no_limit": MessageLookupByLibrary.simpleMessage(
      "Kein Limit",
    ),
    "recipe_filters_reset": MessageLookupByLibrary.simpleMessage(
      "Zurücksetzen",
    ),
    "recipe_filters_title": MessageLookupByLibrary.simpleMessage(
      "Rezepte verfeinern",
    ),
    "recipe_for": MessageLookupByLibrary.simpleMessage("Rezept für"),
    "recipe_import_pc_title": MessageLookupByLibrary.simpleMessage(
      "Wie erstelle ich ein Rezept am PC, um es in der App zu importieren?",
    ),
    "recipe_ingredients_empty": MessageLookupByLibrary.simpleMessage(
      "Dieses Rezept enthält noch keine Zutaten.",
    ),
    "recipe_instructions_empty": MessageLookupByLibrary.simpleMessage(
      "Dieses Rezept enthält noch keine Zubereitungsschritte.",
    ),
    "recipe_more_actions": MessageLookupByLibrary.simpleMessage(
      "Weitere Rezeptaktionen",
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
    "recipe_summary_with_effort": m71,
    "recipe_tag": MessageLookupByLibrary.simpleMessage("Schlüsselwort"),
    "recipe_tag_already_exists": MessageLookupByLibrary.simpleMessage(
      "Tag bereits vorhanden",
    ),
    "recipe_url": MessageLookupByLibrary.simpleMessage("Link zum Rezept"),
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
    "remove_all_from_shopping_list": MessageLookupByLibrary.simpleMessage(
      "Alle aus der Einkaufsliste entfernen",
    ),
    "remove_from_favorites": MessageLookupByLibrary.simpleMessage(
      "Lesezeichen entfernen",
    ),
    "remove_ingredient": m72,
    "remove_section": m73,
    "remove_section_from_cart": MessageLookupByLibrary.simpleMessage(
      "Bereich entfernen",
    ),
    "remove_step": m74,
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
    "search_bookmarks": MessageLookupByLibrary.simpleMessage(
      "Gespeicherte Rezepte, Zutaten und Tags durchsuchen…",
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
    "serving_adjuster": MessageLookupByLibrary.simpleMessage(
      "Portionen anpassen",
    ),
    "servings": MessageLookupByLibrary.simpleMessage("Portionen"),
    "settings": MessageLookupByLibrary.simpleMessage("Allgemein"),
    "settings_about_desc": MessageLookupByLibrary.simpleMessage(
      "Öffnet App-Details, Teilen, Kontakt und rechtliche Hinweise.",
    ),
    "settings_about_title": MessageLookupByLibrary.simpleMessage(
      "Info & Support",
    ),
    "settings_account_ads": MessageLookupByLibrary.simpleMessage(
      "Konto & Werbung",
    ),
    "settings_ad_preferences_desc": MessageLookupByLibrary.simpleMessage(
      "Lädt Werbung ohne personalisierte Ausrichtung neu.",
    ),
    "settings_ad_preferences_title": MessageLookupByLibrary.simpleMessage(
      "Werbung ohne Personalisierung neu laden",
    ),
    "settings_animations_desc": MessageLookupByLibrary.simpleMessage(
      "Verwendet animierte Übergänge und interaktive Bewegungen in der App.",
    ),
    "settings_animations_title": MessageLookupByLibrary.simpleMessage(
      "Aufwendige Animationen",
    ),
    "settings_appearance_display": MessageLookupByLibrary.simpleMessage(
      "Darstellung & Anzeige",
    ),
    "settings_awake_desc": MessageLookupByLibrary.simpleMessage(
      "Hält den Bildschirm bei der Nutzung rezeptbezogener Ansichten aktiv.",
    ),
    "settings_awake_title": MessageLookupByLibrary.simpleMessage(
      "Bildschirm aktiv halten",
    ),
    "settings_backup_desc": MessageLookupByLibrary.simpleMessage(
      "Wähle Rezepte aus und teile sie als ZIP-Archiv.",
    ),
    "settings_backup_title": MessageLookupByLibrary.simpleMessage(
      "Rezepte sichern & teilen",
    ),
    "settings_categories_desc": MessageLookupByLibrary.simpleMessage(
      "Füge Kategorien hinzu, benenne, sortiere oder entferne sie.",
    ),
    "settings_categories_title": MessageLookupByLibrary.simpleMessage(
      "Rezeptkategorien",
    ),
    "settings_configuration": MessageLookupByLibrary.simpleMessage(
      "Küchenkonfiguration",
    ),
    "settings_data_sync": MessageLookupByLibrary.simpleMessage(
      "Daten & Synchronisierung",
    ),
    "settings_decimals": MessageLookupByLibrary.simpleMessage("Dezimal"),
    "settings_drive_cancel": MessageLookupByLibrary.simpleMessage(
      "Synchronisierung abbrechen",
    ),
    "settings_drive_offline_desc": MessageLookupByLibrary.simpleMessage(
      "Anmeldung fehlgeschlagen. Prüfe deine Verbindung und versuche es erneut.",
    ),
    "settings_drive_retry": MessageLookupByLibrary.simpleMessage(
      "Erneut synchronisieren",
    ),
    "settings_drive_sign_in": MessageLookupByLibrary.simpleMessage("Anmelden"),
    "settings_drive_sign_out": MessageLookupByLibrary.simpleMessage("Abmelden"),
    "settings_drive_signed_out_desc": MessageLookupByLibrary.simpleMessage(
      "Melde dich an, um Rezepte manuell zwischen Geräten zu synchronisieren.",
    ),
    "settings_drive_signing_in": MessageLookupByLibrary.simpleMessage(
      "Anmeldung bei Google Drive…",
    ),
    "settings_drive_signing_out": MessageLookupByLibrary.simpleMessage(
      "Abmeldung von Google Drive…",
    ),
    "settings_drive_sync_desc": MessageLookupByLibrary.simpleMessage(
      "Gleiche lokale Rezepte manuell mit Google Drive ab.",
    ),
    "settings_drive_sync_title": MessageLookupByLibrary.simpleMessage(
      "Rezepte mit Google Drive synchronisieren",
    ),
    "settings_drive_syncing_desc": MessageLookupByLibrary.simpleMessage(
      "Lokale Rezepte werden mit Google Drive verglichen…",
    ),
    "settings_drive_title": MessageLookupByLibrary.simpleMessage(
      "Google Drive",
    ),
    "settings_footer": m75,
    "settings_fractions": MessageLookupByLibrary.simpleMessage("Brüche"),
    "settings_help_about": MessageLookupByLibrary.simpleMessage("Hilfe & Info"),
    "settings_import_local_desc": MessageLookupByLibrary.simpleMessage(
      "Importiere Rezeptdateien im Format .zip, .mcb oder .json.",
    ),
    "settings_import_local_title": MessageLookupByLibrary.simpleMessage(
      "Lokale Rezeptdateien importieren",
    ),
    "settings_import_pc_desc": MessageLookupByLibrary.simpleMessage(
      "Öffne den Web-Editor und übertrage danach seine JSON-Datei auf dieses Gerät.",
    ),
    "settings_import_pc_title": MessageLookupByLibrary.simpleMessage(
      "Rezepte am Computer erstellen",
    ),
    "settings_import_website_desc": MessageLookupByLibrary.simpleMessage(
      "Füge eine Rezept-URL ein, um die Rezeptdaten zu extrahieren und zu speichern.",
    ),
    "settings_import_website_title": MessageLookupByLibrary.simpleMessage(
      "Rezepte von einer Webseite importieren",
    ),
    "settings_ingredients_desc": MessageLookupByLibrary.simpleMessage(
      "Verwalte Vorschläge beim Bearbeiten und Suchen. Bestehende Rezepte werden nicht geändert.",
    ),
    "settings_ingredients_title": MessageLookupByLibrary.simpleMessage(
      "Zutatenvorschläge",
    ),
    "settings_intro_desc": MessageLookupByLibrary.simpleMessage(
      "Sieh dir Aufwand, Kochmodus, Zutatensuche, Einkaufslisten und Entdecken noch einmal an.",
    ),
    "settings_intro_title": MessageLookupByLibrary.simpleMessage(
      "Einführung erneut ansehen",
    ),
    "settings_item_count": m76,
    "settings_migration_desc": m77,
    "settings_migration_retry": MessageLookupByLibrary.simpleMessage(
      "Erneut versuchen",
    ),
    "settings_migration_share": MessageLookupByLibrary.simpleMessage(
      "Bericht teilen",
    ),
    "settings_migration_title": MessageLookupByLibrary.simpleMessage(
      "Einige ältere Rezeptdaten benötigen noch Aufmerksamkeit",
    ),
    "settings_non_personalized_enabled": MessageLookupByLibrary.simpleMessage(
      "Nicht personalisierte Werbung aktiviert",
    ),
    "settings_nutrition_desc": MessageLookupByLibrary.simpleMessage(
      "Verwalte Vorschläge beim Bearbeiten. Bestehende Rezepte werden nicht geändert.",
    ),
    "settings_nutrition_title": MessageLookupByLibrary.simpleMessage(
      "Nährwertfelder",
    ),
    "settings_pro_active": MessageLookupByLibrary.simpleMessage("Pro aktiv"),
    "settings_pro_active_desc": MessageLookupByLibrary.simpleMessage(
      "Werbung ist auf diesem Gerät deaktiviert.",
    ),
    "settings_pro_desc": MessageLookupByLibrary.simpleMessage(
      "Entferne alle Anzeigen in der App mit einem einmaligen Kauf.",
    ),
    "settings_quantity_desc": MessageLookupByLibrary.simpleMessage(
      "Wähle, wie Zutatenmengen angezeigt werden.",
    ),
    "settings_quantity_title": MessageLookupByLibrary.simpleMessage(
      "Mengenformat",
    ),
    "settings_rate_desc": MessageLookupByLibrary.simpleMessage(
      "Öffnet den Google-Play-Eintrag, um eine Bewertung abzugeben.",
    ),
    "settings_rate_title": MessageLookupByLibrary.simpleMessage(
      "My RecipeBible bewerten",
    ),
    "settings_recipe_catalog": MessageLookupByLibrary.simpleMessage(
      "Rezeptkatalog",
    ),
    "settings_recipe_count": m78,
    "settings_reward_desc": MessageLookupByLibrary.simpleMessage(
      "Jedes vollständig angesehene Video bringt 30 Minuten ohne Bannerwerbung.",
    ),
    "settings_reward_title": MessageLookupByLibrary.simpleMessage(
      "Video ansehen und 30 Minuten werbefrei nutzen",
    ),
    "settings_tags_desc": MessageLookupByLibrary.simpleMessage(
      "Füge wiederverwendbare Tags hinzu, benenne oder färbe sie um oder entferne sie.",
    ),
    "settings_tags_title": MessageLookupByLibrary.simpleMessage("Rezept-Tags"),
    "settings_theme_auto": MessageLookupByLibrary.simpleMessage("Auto"),
    "settings_theme_dark": MessageLookupByLibrary.simpleMessage("Dunkel"),
    "settings_theme_light": MessageLookupByLibrary.simpleMessage("Hell"),
    "settings_theme_oled": MessageLookupByLibrary.simpleMessage("OLED"),
    "settings_theme_title": MessageLookupByLibrary.simpleMessage("App-Design"),
    "settings_title": MessageLookupByLibrary.simpleMessage(
      "Einstellungen & Präferenzen",
    ),
    "settings_upgrade": MessageLookupByLibrary.simpleMessage("Upgrade"),
    "settings_watch": MessageLookupByLibrary.simpleMessage("Ansehen"),
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
    "share_this_app_desc": m79,
    "share_this_app_title": MessageLookupByLibrary.simpleMessage(
      "My RecipeBible empfehlen",
    ),
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
    "shopping_for_recipes": m80,
    "shopping_invalid_servings": MessageLookupByLibrary.simpleMessage(
      "Gib eine Zahl größer als null ein",
    ),
    "shopping_item_count": m81,
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
    "shopping_percent_gathered": m82,
    "shopping_plain_list": MessageLookupByLibrary.simpleMessage(
      "Einfache Liste",
    ),
    "shopping_progress": m83,
    "shopping_quick_add_hint": MessageLookupByLibrary.simpleMessage(
      "Zutat hinzufügen…",
    ),
    "shopping_remove_checked": MessageLookupByLibrary.simpleMessage(
      "Erledigte Einträge entfernen",
    ),
    "shopping_remove_checked_description": m84,
    "shopping_remove_checked_title": MessageLookupByLibrary.simpleMessage(
      "Erledigte Einträge entfernen?",
    ),
    "shopping_remove_item": m85,
    "shopping_removed_items": m86,
    "shopping_search_recipes": MessageLookupByLibrary.simpleMessage(
      "Rezepte durchsuchen",
    ),
    "shopping_serving_value": m87,
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
    "sort_by": m88,
    "source": MessageLookupByLibrary.simpleMessage("Quelle/URL"),
    "source_could_not_open": MessageLookupByLibrary.simpleMessage(
      "Die Rezeptquelle konnte nicht geöffnet werden.",
    ),
    "standardized_format": MessageLookupByLibrary.simpleMessage(
      "Viele Rezeptseiten funktionieren, wenn sie strukturierte Rezeptdaten veröffentlichen. Zum Beispiel:",
    ),
    "start_cooking": MessageLookupByLibrary.simpleMessage("Kochen starten"),
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
      "Welche Seiten funktionieren?",
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
    "sync_recipes_drive": MessageLookupByLibrary.simpleMessage(
      "Synchronisiere Rezepte mit Google Drive",
    ),
    "syncing_recipes_drive": MessageLookupByLibrary.simpleMessage(
      "Synchronisiere Rezepte mit Google Drive",
    ),
    "tags": MessageLookupByLibrary.simpleMessage("Tags"),
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
    "undo_added_to_planner_description": m89,
    "unit": MessageLookupByLibrary.simpleMessage("Einheit"),
    "unpin_recipe": MessageLookupByLibrary.simpleMessage("Rezept lösen"),
    "untitled_recipe": MessageLookupByLibrary.simpleMessage(
      "Rezept ohne Titel",
    ),
    "uploading_recipe_drive": m90,
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
    "website_import_action": MessageLookupByLibrary.simpleMessage(
      "Rezept importieren",
    ),
    "website_import_collapse_sites": MessageLookupByLibrary.simpleMessage(
      "Unterstützte Seiten ausblenden",
    ),
    "website_import_connection_body": MessageLookupByLibrary.simpleMessage(
      "Prüfe deine Internetverbindung und versuche es erneut.",
    ),
    "website_import_connection_title": MessageLookupByLibrary.simpleMessage(
      "Keine Verbindung",
    ),
    "website_import_duplicate_title": MessageLookupByLibrary.simpleMessage(
      "Bereits in deinem Kochbuch",
    ),
    "website_import_expand_sites": MessageLookupByLibrary.simpleMessage(
      "Unterstützte Seiten anzeigen",
    ),
    "website_import_failed_body": MessageLookupByLibrary.simpleMessage(
      "Auf dieser Seite wurden keine vollständigen Rezeptdaten gefunden. Prüfe den Link oder versuche es erneut.",
    ),
    "website_import_failed_title": MessageLookupByLibrary.simpleMessage(
      "Rezept konnte nicht importiert werden",
    ),
    "website_import_field_hint": MessageLookupByLibrary.simpleMessage(
      "https://beispiel.de/rezept",
    ),
    "website_import_field_label": MessageLookupByLibrary.simpleMessage(
      "Link zum Rezept",
    ),
    "website_import_info": MessageLookupByLibrary.simpleMessage(
      "Nutze im Browser die Teilen-Funktion und wähle My RecipeBible, um ein Rezept ohne Kopieren des Links zu importieren.",
    ),
    "website_import_intro_body": MessageLookupByLibrary.simpleMessage(
      "Füge den Link zu einer Rezeptseite ein. Wir übernehmen die Details, damit du sie vor dem Speichern prüfen kannst.",
    ),
    "website_import_intro_title": MessageLookupByLibrary.simpleMessage(
      "Ein Rezept aus dem Web holen",
    ),
    "website_import_invalid_url_input": MessageLookupByLibrary.simpleMessage(
      "Gib einen vollständigen Rezeptlink mit http:// oder https:// ein.",
    ),
    "website_import_link_failed": MessageLookupByLibrary.simpleMessage(
      "Diese Webseite konnte nicht geöffnet werden.",
    ),
    "website_import_loading": MessageLookupByLibrary.simpleMessage(
      "Rezept wird gelesen…",
    ),
    "website_import_loading_body": MessageLookupByLibrary.simpleMessage(
      "Wir suchen Zutaten, Zubereitung und weitere Rezeptangaben.",
    ),
    "website_import_share_tip_title": MessageLookupByLibrary.simpleMessage(
      "Schneller über deinen Browser",
    ),
    "website_import_try_again": MessageLookupByLibrary.simpleMessage(
      "Erneut versuchen",
    ),
    "website_import_unsupported_body": MessageLookupByLibrary.simpleMessage(
      "Versuche eine andere Rezeptseite oder sieh unten nach, welche Seiten unterstützt werden.",
    ),
    "website_import_unsupported_title": MessageLookupByLibrary.simpleMessage(
      "Diese Seite lässt sich noch nicht lesen",
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
