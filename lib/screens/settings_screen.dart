import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:my_recipe_book/local_storage/hive.dart';
import 'package:my_recipe_book/models/nutrition.dart';
import 'package:my_recipe_book/models/recipe.dart';
import 'package:my_recipe_book/models/string_int_tuple.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../blocs/import_recipe/import_recipe_bloc.dart';
import '../blocs/shopping_cart/shopping_cart_bloc.dart';
import '../constants/global_constants.dart' as Constants;
import '../constants/global_settings.dart';
import '../constants/routes.dart';
import '../generated/i18n.dart';
import '../helper.dart';
import '../theming.dart';
import '../widgets/dialogs/import_dialog.dart';
import '../widgets/dialogs/info_dialog.dart';
import 'export_recipes_screen.dart';
import 'import_from_website.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          Divider(),
          ListTile(
            title: Text("export pdf"),
            onTap: () {
              _export(Recipe(name: "Lasagne")).then((_) => print("lol"));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(MdiIcons.export),
            trailing: IconButton(
              icon: Icon(Icons.help_outline),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => InfoDialog(
                    title: I18n.of(context).information,
                    body: I18n.of(context).info_export_description,
                  ),
                );
              },
            ),
            title: Text(I18n.of(context).export_recipe_s),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ExportRecipes()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(MdiIcons.import),
            onTap: () {
              _importSingleRecipe(context).then((_) {});
            },
            title: Text(I18n.of(context).import_recipe_s),
          ),
          Divider(),
          ListTile(
            leading: Icon(MdiIcons.cloudDownload),
            title: Text(I18n.of(context).import_from_website),
            onTap: () {
              Navigator.pushNamed(context, RouteNames.importFromWebsite,
                  arguments: ImportFromWebsiteArguments(
                      BlocProvider.of<ShoppingCartBloc>(context)));
            },
          ),
          Divider(),
          ListTile(
              leading: Icon(MdiIcons.nutrition),
              title: Text(I18n.of(context).manage_nutritions),
              onTap: () {
                Navigator.pushNamed(context, RouteNames.manageNutritions);
              }),
          Divider(),
          ListTile(
              leading: Icon(MdiIcons.fruitPineapple),
              title: Text(I18n.of(context).manage_ingredients),
              onTap: () {
                Navigator.pushNamed(context, RouteNames.manageIngredients);
              }),
          Divider(),
          ListTile(
            leading: Icon(MdiIcons.tag),
            title: Text(I18n.of(context).manage_recipe_tags),
            onTap: () {
              Navigator.pushNamed(context, RouteNames.manageRecipeTags);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(MdiIcons.apps),
            title: Text(I18n.of(context).manage_categories),
            onTap: () {
              Navigator.pushNamed(
                context,
                RouteNames.manageCategories,
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(MdiIcons.powerStandby),
            trailing: DisableStandbyCheckbox(),
            title: Text(I18n.of(context).keep_screen_on),
            subtitle: Text(I18n.of(context).only_recipe_screen),
          ),
          Divider(),
          ListTile(
            leading: Icon(MdiIcons.animation),
            trailing: AnimationCheckbox(),
            title: Text(I18n.of(context).complex_animations),
          ),
          Divider(),
          ListTile(
            leading: Icon(MdiIcons.themeLightDark),
            title: Text(I18n.of(context).switch_theme),
            trailing: Container(
              width: 130,
              height: 25,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      _changeTheme(context, MyThemeKeys.AUTOMATIC);
                    },
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                width: 1,
                                color: Theme.of(context).textTheme.body1.color),
                            color: Colors.grey[100],
                          ),
                        ),
                        ClipPath(
                          clipper: CustomRightHalfClipper(),
                          child: Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  width: 1,
                                  color:
                                      Theme.of(context).textTheme.body1.color),
                              color: Color(0xff454545),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(width: 10),
                  GestureDetector(
                    onTap: () {
                      _changeTheme(context, MyThemeKeys.LIGHT);
                    },
                    child: Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            width: 1,
                            color: Theme.of(context).textTheme.body1.color),
                        color: Colors.grey[100],
                      ),
                    ),
                  ),
                  Container(width: 10),
                  GestureDetector(
                    onTap: () {
                      _changeTheme(context, MyThemeKeys.DARK);
                    },
                    child: Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            width: 1,
                            color: Theme.of(context).textTheme.body1.color),
                        color: Color(0xff454545),
                      ),
                    ),
                  ),
                  Container(width: 10),
                  GestureDetector(
                    onTap: () {
                      _changeTheme(context, MyThemeKeys.OLEDBLACK);
                    },
                    child: Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            width: 1,
                            color: Theme.of(context).textTheme.body1.color),
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(MdiIcons.compass),
            title: Text(I18n.of(context).view_intro),
            onTap: () {
              Navigator.of(context).pushNamed(RouteNames.intro);
            },
          ),
          Divider(),
          ListTile(
              leading: Icon(Icons.info),
              onTap: () {
                Navigator.pushNamed(context, RouteNames.aboutMe);
              },
              title: Text(I18n.of(context).about_me)),
          Divider(),
          ListTile(
              leading: Icon(Icons.star),
              title: Text(I18n.of(context).rate_app)),
          Divider(),
        ],
      ),
    );
  }

  void _changeTheme(BuildContext context, MyThemeKeys key) {
    CustomTheme.instanceOf(context).changeTheme(key);
    final scaffold = Scaffold.of(context);
    scaffold.hideCurrentSnackBar();
    SharedPreferences.getInstance().then((prefs) {
      switch (key) {
        case MyThemeKeys.AUTOMATIC:
          prefs.setInt('theme', 0);
          scaffold.showSnackBar(
            SnackBar(
              content: Text(I18n.of(context).snackbar_automatic_theme_applied),
              action: SnackBarAction(
                label: I18n.of(context).dismiss,
                onPressed: scaffold.hideCurrentSnackBar,
              ),
            ),
          );
          return;
        case MyThemeKeys.LIGHT:
          prefs.setInt('theme', 1);
          scaffold.showSnackBar(
            SnackBar(
              content: Text(I18n.of(context).snackbar_bright_theme_applied),
              action: SnackBarAction(
                label: I18n.of(context).dismiss,
                onPressed: scaffold.hideCurrentSnackBar,
              ),
            ),
          );
          return;
        case MyThemeKeys.DARK:
          prefs.setInt('theme', 2);
          scaffold.showSnackBar(
            SnackBar(
              content: Text(I18n.of(context).snackbar_dark_theme_applied),
              action: SnackBarAction(
                label: I18n.of(context).dismiss,
                onPressed: scaffold.hideCurrentSnackBar,
              ),
            ),
          );
          return;
        case MyThemeKeys.OLEDBLACK:
          prefs.setInt('theme', 3);
          scaffold.showSnackBar(
            SnackBar(
              content: Text(I18n.of(context).snackbar_midnight_theme_applied),
              action: SnackBarAction(
                label: I18n.of(context).dismiss,
                onPressed: scaffold.hideCurrentSnackBar,
              ),
            ),
          );
          return;
        default:
      }
    });
  }

  Future<void> _importSingleRecipe(BuildContext ctxt) async {
    // Let the user select the .zip file
    String _path = await FilePicker.getFilePath(
        type: FileType.CUSTOM, fileExtension: 'zip');

    if (_path == null) return;

    showDialog(
      context: ctxt,
      builder: (context) => BlocProvider<ImportRecipeBloc>.value(
          value: BlocProvider.of<ImportRecipeBloc>(ctxt)
            ..add(StartImportRecipes(File(_path),
                delay: Duration(milliseconds: 300))),
          child: ImportDialog()),
    );
  }
}

class CustomRightHalfClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = new Path()
      ..lineTo(size.width / 2, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class DisableStandbyCheckbox extends StatefulWidget {
  DisableStandbyCheckbox({Key key}) : super(key: key);

  @override
  _DisableStandbyCheckboxState createState() => _DisableStandbyCheckboxState();
}

class _DisableStandbyCheckboxState extends State<DisableStandbyCheckbox> {
  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: GlobalSettings().standbyDisabled(),
      onChanged: (value) {
        SharedPreferences.getInstance().then((prefs) {
          setState(() {
            prefs.setBool(Constants.disableStandby, value);
            GlobalSettings().disableStandby(value);
          });
        });
      },
    );
  }
}

class AnimationCheckbox extends StatefulWidget {
  AnimationCheckbox({Key key}) : super(key: key);

  @override
  _AnimationCheckboxState createState() => _AnimationCheckboxState();
}

class _AnimationCheckboxState extends State<AnimationCheckbox> {
  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: GlobalSettings().animationsEnabled(),
      onChanged: (value) {
        SharedPreferences.getInstance().then((prefs) {
          setState(() {
            prefs.setBool(Constants.enableAnimations, value);
            GlobalSettings().enableAnimations(value);
          });
        });
      },
    );
  }
}

Future<File> _export(Recipe recipe) async {
  final pw.Document doc = pw.Document();

  recipe = await HiveProvider().getRecipeByName("Kartoffelpuffer");

  ByteData righteousData = await rootBundle.load("fonts/Righteous-Regular.ttf");
  final righteousBuffer = righteousData.buffer;
  Uint8List righteousFont = righteousBuffer.asUint8List(
      righteousData.offsetInBytes, righteousData.lengthInBytes);
  final righteousTtf = pw.Font.ttf(righteousFont.buffer.asByteData());

  ByteData quandoData = await rootBundle.load("fonts/Quando-Regular.ttf");
  final quandoBuffer = quandoData.buffer;
  Uint8List quandoFont = quandoBuffer.asUint8List(
      quandoData.offsetInBytes, quandoData.lengthInBytes);
  final quandoTtf = pw.Font.ttf(quandoFont.buffer.asByteData());

  ByteData latoData = await rootBundle.load("fonts/Lato-Regular.ttf");
  final latoBuffer = latoData.buffer;
  Uint8List latoFont =
      latoBuffer.asUint8List(latoData.offsetInBytes, latoData.lengthInBytes);
  final latoTtf = pw.Font.ttf(latoFont.buffer.asByteData());

  ByteData latoBData = await rootBundle.load("fonts/Lato-Bold.ttf");
  final latoBBuffer = latoBData.buffer;
  Uint8List latoBFont =
      latoBBuffer.asUint8List(latoBData.offsetInBytes, latoBData.lengthInBytes);
  final latoBTtf = pw.Font.ttf(latoBFont.buffer.asByteData());

  const imageProvider = const AssetImage('images/iconIosStyle.png');
  final PdfImage pdfIconImage =
      await pdfImageFromImageProvider(pdf: doc.document, image: imageProvider);

  String categoriesString = "";
  for (String category in recipe.categories) {
    if (recipe.categories.first == category) {
      categoriesString += category;
    } else {
      categoriesString += ", $category";
    }
  }

  String recipeSource;
  if (recipe.source != null) {
    if (recipe.source.contains("chefkoch")) {
      recipeSource = "https://www.chefkoch.de/";
    } else if (recipe.source.contains("elavegan")) {
      recipeSource = "https://elavegan.com/de/";
    } else if (recipe.source.contains("kochbar")) {
      recipeSource = "https://www.kochbar.de/";
    } else if (recipe.source.contains("allrecipes")) {
      recipeSource = "https://www.allrecipes.com/";
    } else {
      recipeSource = recipe.source;
    }
  }

  String tagsString = "";
  for (StringIntTuple tag in recipe.tags) {
    if (recipe.tags.first == tag) {
      tagsString += tag.text;
    } else {
      tagsString += ", ${tag.text}";
    }
  }

  List<pw.Widget> stepWidgets = [
    pw.Padding(
      padding: pw.EdgeInsets.only(top: 8),
      child: pw.Row(children: [
        pw.Text(
          "Zubereitung",
          style: pw.TextStyle(
            font: quandoTtf,
            color: PdfColors.red900,
            fontSize: 16,
          ),
        ),
      ]),
    ),
  ]..addAll(List.generate(
      recipe.steps.length,
      (index) => pw.Padding(
        padding: pw.EdgeInsets.only(top: 8),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text("${index + 1}.",
                style: pw.TextStyle(
                    font: latoTtf, fontSize: 11, color: PdfColors.grey500)),
            pw.SizedBox(width: 10),
            pw.Container(
              width: 420,
              child: pw.Text(
                "${recipe.steps[index]}",
                style: pw.TextStyle(font: latoTtf, fontSize: 11),
              ),
            ),
          ]..removeWhere((item) => item == null),
        ),
      ),
    ));

  doc.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      header: (pw.Context context) {
        if (context.pageNumber == 1) {
          return null;
        }
        return null;
      },
      footer: (pw.Context context) {
        return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
            child: pw.Text(
                'Page ${context.pageNumber} of ${context.pagesCount}',
                style: pw.Theme.of(context)
                    .defaultTextStyle
                    .copyWith(color: PdfColors.grey)));
      },
      build: (pw.Context context) => <pw.Widget>[
            pw.Row(
              children: [
                pw.Container(
                  height: 40,
                  width: 40,
                  child: pw.Image(pdfIconImage),
                ),
                pw.SizedBox(width: 20),
                pw.Text(
                  "My RecipeBook",
                  style: pw.TextStyle(font: righteousTtf, fontSize: 28),
                ),
              ],
              mainAxisAlignment: pw.MainAxisAlignment.center,
            ),
            pw.Center(
              child: pw.Padding(
                padding: pw.EdgeInsets.all(8),
                child: pw.Container(
                    width: 500, height: 0.2, color: PdfColors.grey),
              ),
            ),
            pw.Padding(
              padding: pw.EdgeInsets.symmetric(vertical: 5),
              child: pw.Text(
                recipe.name,
                style: pw.TextStyle(
                  font: quandoTtf,
                  fontSize: 24,
                  color: PdfColors.red900,
                ),
              ),
            ),
            pw.Wrap(
              direction: pw.Axis.horizontal,
              children: [
                pw.Container(
                  height: 190,
                  width: 190,
                  child: pw.Image(
                    PdfImage.file(
                      doc.document,
                      bytes: File(recipe.imagePath).readAsBytesSync(),
                    ),
                    fit: pw.BoxFit.cover,
                  ),
                ),
                pw.Padding(
                  padding: pw.EdgeInsets.only(left: 15),
                  child: pw.Container(
                    width: 220,
                    child: pw.Column(
                        mainAxisSize: pw.MainAxisSize.min,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            "Allgemeine Infos",
                            style: pw.TextStyle(
                              font: quandoTtf,
                              color: PdfColors.red900,
                              fontSize: 16,
                            ),
                          ),
                          pw.SizedBox(height: 12),
                          categoriesString != ""
                              ? pw.Padding(
                                  padding: pw.EdgeInsets.only(top: 2),
                                  child: pw.RichText(
                                    text: pw.TextSpan(
                                      children: [
                                        pw.TextSpan(
                                          text: "Kategorien: ",
                                          style: pw.TextStyle(
                                              color: PdfColors.grey700,
                                              font: latoTtf,
                                              fontSize: 11),
                                        ),
                                        pw.TextSpan(
                                          text: categoriesString,
                                          style: pw.TextStyle(
                                              font: latoBTtf,
                                              fontSize: 11,
                                              fontWeight: pw.FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : null,
                          tagsString != ""
                              ? pw.Padding(
                                  padding: pw.EdgeInsets.only(top: 5),
                                  child: pw.RichText(
                                    text: pw.TextSpan(
                                      children: [
                                        pw.TextSpan(
                                          text: "Tags: ",
                                          style: pw.TextStyle(
                                              font: latoTtf,
                                              color: PdfColors.grey700,
                                              fontSize: 11),
                                        ),
                                        pw.TextSpan(
                                          text: tagsString,
                                          style: pw.TextStyle(
                                              font: latoBTtf,
                                              fontSize: 11,
                                              fontWeight: pw.FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : null,
                          recipe.preperationTime != 0
                              ? pw.Padding(
                                  padding: pw.EdgeInsets.only(top: 8),
                                  child: pw.RichText(
                                    text: pw.TextSpan(
                                      children: [
                                        pw.TextSpan(
                                          text: "Vorbereitungszeit: ",
                                          style: pw.TextStyle(
                                              font: latoTtf,
                                              color: PdfColors.grey700,
                                              fontSize: 11),
                                        ),
                                        pw.TextSpan(
                                          text: getTimeHoursMinutes(
                                              recipe.preperationTime),
                                          style: pw.TextStyle(
                                              font: latoBTtf,
                                              fontSize: 11,
                                              fontWeight: pw.FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : null,
                          recipe.cookingTime != 0
                              ? pw.Padding(
                                  padding: pw.EdgeInsets.only(top: 5),
                                  child: pw.RichText(
                                    text: pw.TextSpan(
                                      children: [
                                        pw.TextSpan(
                                          text: "Koch-/Backzeit: ",
                                          style: pw.TextStyle(
                                              font: latoTtf,
                                              color: PdfColors.grey700,
                                              fontSize: 11),
                                        ),
                                        pw.TextSpan(
                                          text: getTimeHoursMinutes(
                                              recipe.cookingTime),
                                          style: pw.TextStyle(
                                              font: latoBTtf,
                                              fontSize: 11,
                                              fontWeight: pw.FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : null,
                          recipe.totalTime != 0
                              ? pw.Padding(
                                  padding: pw.EdgeInsets.only(top: 5),
                                  child: pw.RichText(
                                    text: pw.TextSpan(
                                      children: [
                                        pw.TextSpan(
                                          text: "Gesamtzeit: ",
                                          style: pw.TextStyle(
                                              font: latoTtf,
                                              color: PdfColors.grey700,
                                              fontSize: 11),
                                        ),
                                        pw.TextSpan(
                                          text: getTimeHoursMinutes(
                                              recipe.totalTime),
                                          style: pw.TextStyle(
                                              font: latoBTtf,
                                              fontSize: 11,
                                              fontWeight: pw.FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : null,
                          recipe.servings != null
                              ? pw.Padding(
                                  padding: pw.EdgeInsets.only(top: 8),
                                  child: pw.RichText(
                                    text: pw.TextSpan(
                                      children: [
                                        pw.TextSpan(
                                          text: "Für ",
                                          style: pw.TextStyle(
                                              font: latoTtf,
                                              color: PdfColors.grey700,
                                              fontSize: 11),
                                        ),
                                        pw.TextSpan(
                                          text: "${recipe.servings} Personen",
                                          style: pw.TextStyle(
                                              font: latoBTtf,
                                              fontSize: 11,
                                              fontWeight: pw.FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : null,
                          pw.Padding(
                            padding: pw.EdgeInsets.only(top: 5),
                            child: pw.RichText(
                              text: pw.TextSpan(
                                children: [
                                  pw.TextSpan(
                                    text: "Aufwand: ",
                                    style: pw.TextStyle(
                                        font: latoTtf,
                                        color: PdfColors.grey700,
                                        fontSize: 11),
                                  ),
                                  pw.TextSpan(
                                    text: "${recipe.effort}",
                                    style: pw.TextStyle(
                                        font: latoBTtf,
                                        fontSize: 11,
                                        fontWeight: pw.FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ),
                          recipeSource != null
                              ? pw.Padding(
                                  padding: pw.EdgeInsets.only(top: 8),
                                  child: pw.RichText(
                                    text: pw.TextSpan(
                                      children: [
                                        pw.TextSpan(
                                          text: "Quelle: ",
                                          style: pw.TextStyle(
                                              font: latoTtf,
                                              color: PdfColors.grey700,
                                              fontSize: 11),
                                        ),
                                        pw.TextSpan(
                                          text: recipeSource,
                                          style: pw.TextStyle(
                                              font: latoBTtf,
                                              fontSize: 11,
                                              fontWeight: pw.FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : null,
                        ]..removeWhere((item) => item == null)),
                  ),
                ),
                pw.Padding(
                  padding: pw.EdgeInsets.only(top: 8),
                  child: pw.Wrap(
                      children: [
                    pw.Column(
                        mainAxisSize: pw.MainAxisSize.min,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          recipe.ingredients.isNotEmpty
                              ? pw.Text(
                                  "Zutaten",
                                  style: pw.TextStyle(
                                    font: quandoTtf,
                                    color: PdfColors.red900,
                                    fontSize: 16,
                                  ),
                                )
                              : null,
                          recipe.ingredientsGlossary.isEmpty &&
                                  recipe.ingredients.isNotEmpty
                              ? pw.Container(
                                  width: 500,
                                  child: pw.Wrap(
                                    children: List.generate(
                                      recipe.ingredients.first.length,
                                      (index2) => pw.Padding(
                                        padding: pw.EdgeInsets.only(top: 5),
                                        child: pw.Row(
                                            mainAxisSize: pw.MainAxisSize.min,
                                            children: [
                                              pw.Container(
                                                height: 5,
                                                width: 5,
                                                decoration: pw.BoxDecoration(
                                                  shape: pw.BoxShape.circle,
                                                  color: PdfColors.grey300,
                                                ),
                                              ),
                                              pw.SizedBox(width: 10),
                                              pw.Container(
                                                width: 140,
                                                child: pw.RichText(
                                                  text: pw.TextSpan(
                                                    children: [
                                                      pw.TextSpan(
                                                        text:
                                                            "${recipe.ingredients.first[index2].amount != null ? "${recipe.ingredients.first[index2].amount} " : ""}${recipe.ingredients.first[index2].unit != null ? "${recipe.ingredients.first[index2].unit} " : ""}",
                                                        style: pw.TextStyle(
                                                            font: latoTtf,
                                                            fontSize: 11),
                                                      ),
                                                      pw.TextSpan(
                                                        text:
                                                            "${recipe.ingredients.first[index2].name}",
                                                        style: pw.TextStyle(
                                                            font: latoTtf,
                                                            fontSize: 11,
                                                            color: PdfColors
                                                                .grey800,
                                                            fontWeight: pw
                                                                .FontWeight
                                                                .bold),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ]),
                                      ),
                                    ).toList(),
                                  ),
                                )
                              : null,
                          recipe.ingredientsGlossary.isNotEmpty &&
                                  recipe.ingredients.isNotEmpty
                              ? pw.Wrap(
                                  children: List.generate(
                                    recipe.ingredients.length,
                                    (index) => pw.Container(
                                      width: 150,
                                      child: pw.Column(
                                          mainAxisSize: pw.MainAxisSize.min,
                                          crossAxisAlignment:
                                              pw.CrossAxisAlignment.start,
                                          children: [
                                            recipe.ingredientsGlossary
                                                    .isNotEmpty
                                                ? pw.Padding(
                                                    padding: pw.EdgeInsets.only(
                                                        left: 25, top: 6),
                                                    child: pw.Text(
                                                      recipe.ingredientsGlossary[
                                                          index],
                                                      style: pw.TextStyle(
                                                        font: latoBTtf,
                                                        fontSize: 11,
                                                        color:
                                                            PdfColors.grey900,
                                                        fontStyle:
                                                            pw.FontStyle.italic,
                                                      ),
                                                    ),
                                                  )
                                                : null,
                                            pw.Column(
                                              mainAxisSize: pw.MainAxisSize.min,
                                              crossAxisAlignment:
                                                  pw.CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  pw.MainAxisAlignment.center,
                                              children: List.generate(
                                                recipe
                                                    .ingredients[index].length,
                                                (index2) => pw.Padding(
                                                  padding: pw.EdgeInsets.only(
                                                      top: 5),
                                                  child: pw.Row(
                                                      mainAxisSize:
                                                          pw.MainAxisSize.min,
                                                      children: [
                                                        pw.Container(
                                                          height: 5,
                                                          width: 5,
                                                          decoration:
                                                              pw.BoxDecoration(
                                                            shape: pw.BoxShape
                                                                .circle,
                                                            color: PdfColors
                                                                .grey300,
                                                          ),
                                                        ),
                                                        pw.SizedBox(width: 10),
                                                        pw.Container(
                                                          width: 130,
                                                          child: pw.RichText(
                                                            text: pw.TextSpan(
                                                              children: [
                                                                pw.TextSpan(
                                                                  text:
                                                                      "${recipe.ingredients[index][index2].amount != null ? "${recipe.ingredients[index][index2].amount} " : ""}${recipe.ingredients[index][index2].unit != null ? "${recipe.ingredients[index][index2].unit} " : ""}",
                                                                  style: pw.TextStyle(
                                                                      font:
                                                                          latoTtf,
                                                                      fontSize:
                                                                          11),
                                                                ),
                                                                pw.TextSpan(
                                                                  text:
                                                                      "${recipe.ingredients[index][index2].name}",
                                                                  style: pw.TextStyle(
                                                                      font:
                                                                          latoTtf,
                                                                      fontSize:
                                                                          11,
                                                                      color: PdfColors
                                                                          .grey800,
                                                                      fontWeight: pw
                                                                          .FontWeight
                                                                          .bold),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ]),
                                                ),
                                              ).toList(),
                                            ),
                                          ]..removeWhere(
                                              (item) => item == null)),
                                    ),
                                  ),
                                )
                              : null,
                        ]..removeWhere((item) => item == null)),
                    recipe.nutritions.isNotEmpty
                        ? pw.Padding(
                            padding: pw.EdgeInsets.only(top: 8, bottom: 8),
                            child: pw.Text(
                              "Nährwerte",
                              style: pw.TextStyle(
                                font: quandoTtf,
                                color: PdfColors.red900,
                                fontSize: 16,
                              ),
                            ),
                          )
                        : null,
                  ]..removeWhere((item) => item == null)),
                ),
                recipe.nutritions.isNotEmpty ? pw.Container() : null,
                recipe.nutritions.isNotEmpty
                    ? pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        mainAxisSize: pw.MainAxisSize.min,
                        children: recipe.nutritions
                            .map(
                              (nutrition) => pw.Padding(
                                padding: pw.EdgeInsets.only(top: 4),
                                child: pw.Row(
                                  mainAxisSize: pw.MainAxisSize.min,
                                  children: [
                                    pw.Container(
                                      height: 5,
                                      width: 5,
                                      decoration: pw.BoxDecoration(
                                        shape: pw.BoxShape.circle,
                                        color: PdfColors.grey300,
                                      ),
                                    ),
                                    pw.SizedBox(width: 7),
                                    pw.RichText(
                                      text: pw.TextSpan(
                                        children: [
                                          pw.TextSpan(
                                            text: "${nutrition.amountUnit} ",
                                            style: pw.TextStyle(
                                                font: latoTtf, fontSize: 11),
                                          ),
                                          pw.TextSpan(
                                            text: "${nutrition.name}",
                                            style: pw.TextStyle(
                                                font: latoTtf,
                                                fontSize: 11,
                                                color: PdfColors.grey800,
                                                fontWeight: pw.FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      )
                    : null,
              ]
                ..addAll(stepWidgets)
                ..addAll([
                  recipe.notes != ""
                      ? pw.Container(
                          width: 200,
                          child: pw.Padding(
                            padding: pw.EdgeInsets.only(top: 8),
                            child: pw.Text(
                              "Notizen",
                              style: pw.TextStyle(
                                font: quandoTtf,
                                color: PdfColors.red900,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        )
                      : null,
                  recipe.notes != ""
                      ? pw.Padding(
                          padding: pw.EdgeInsets.only(top: 6),
                          child: pw.Container(
                            width: 450,
                            child: pw.Text(
                              "${recipe.notes}",
                              style: pw.TextStyle(
                                  font: latoTtf,
                                  fontSize: 11,
                                  color: PdfColors.grey900),
                            ),
                          ),
                        )
                      : null,
                ]..removeWhere((item) => item == null))
                ..removeWhere((item) => item == null),
            ),
          ]));
  final File file =
      File((await getTemporaryDirectory()).path + "/sharedRecipe.pdf");
  await file.writeAsBytesSync(doc.save());
  return file;
}
