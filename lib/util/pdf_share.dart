import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_recipe_book/constants/global_constants.dart' as Constants;
import 'package:my_recipe_book/models/enums.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../generated/i18n.dart';
import 'helper.dart';
import '../models/recipe.dart';
import '../models/string_int_tuple.dart';

Future<Uint8List> getRecipePdf(Recipe recipe, BuildContext bContext) async {
  final pw.Document doc = pw.Document();

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

  String tagsString = "";
  for (StringIntTuple tag in recipe.tags) {
    if (recipe.tags.first == tag) {
      tagsString += tag.text;
    } else {
      tagsString += ", ${tag.text}";
    }
  }

  String source = "";
  int sourceCutIndex = recipe.imagePath != Constants.noRecipeImage ? 33 : 65;
  for (int i = 0; i < recipe.source.length / sourceCutIndex; i++) {
    source += recipe.source.substring(
        i * sourceCutIndex,
        (i + 1) * sourceCutIndex > recipe.source.length
            ? recipe.source.length
            : (i + 1) * sourceCutIndex);
    source += "\n";
  }

  List<pw.Widget> stepWidgets = [
    recipe.steps.isNotEmpty
        ? pw.Padding(
            padding: pw.EdgeInsets.only(top: 8),
            child: pw.Row(children: [
              pw.Text(
                I18n.of(bContext).directions,
                style: pw.TextStyle(
                  font: quandoTtf,
                  color: PdfColors.red900,
                  fontSize: 16,
                ),
              ),
            ]),
          )
        : null,
  ]
    ..addAll(List.generate(
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
    ))
    ..removeWhere((item) => item == null);

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
        return pw.Stack(children: [
          pw.Align(
            alignment: pw.Alignment.center,
            child: pw.Text(
              "- for personal use only -\n~ shared with the My RecipeBook App for Android ~",
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                fontSize: 9,
                fontStyle: pw.FontStyle.italic,
                color: PdfColors.grey700,
              ),
            ),
          ),
          pw.Align(
            alignment: pw.Alignment.bottomRight,
            child: pw.Text(
              'Page ${context.pageNumber} of ${context.pagesCount}',
              style: pw.Theme.of(context)
                  .defaultTextStyle
                  .copyWith(color: PdfColors.grey),
            ),
          ),
        ]);
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
                recipe.imagePath != Constants.noRecipeImage
                    ? pw.Container(
                        height: 190,
                        width: 190,
                        child: pw.Image(
                          PdfImage.file(
                            doc.document,
                            bytes: File(recipe.imagePath).readAsBytesSync(),
                          ),
                          fit: pw.BoxFit.cover,
                        ),
                      )
                    : null,
                pw.Padding(
                  padding: pw.EdgeInsets.only(
                    left: recipe.imagePath != Constants.noRecipeImage ? 15 : 0,
                    top: recipe.imagePath != Constants.noRecipeImage ? 0 : 10,
                    bottom:
                        recipe.imagePath != Constants.noRecipeImage ? 0 : 10,
                  ),
                  child: pw.Container(
                    width: 270,
                    child: pw.Column(
                        mainAxisSize: pw.MainAxisSize.min,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            I18n.of(bContext).general_infos,
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
                                          text: I18n.of(bContext).categories +
                                              ": ",
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
                                          text: I18n.of(bContext).tags + ": ",
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
                                          text: I18n.of(bContext)
                                                  .preperation_time +
                                              ": ",
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
                                          text: I18n.of(bContext).cook_time +
                                              ": ",
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
                                          text: I18n.of(bContext).total_time +
                                              ": ",
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
                                          text:
                                              I18n.of(bContext).for_word + " ",
                                          style: pw.TextStyle(
                                              font: latoTtf,
                                              color: PdfColors.grey700,
                                              fontSize: 11),
                                        ),
                                        pw.TextSpan(
                                          text: recipe.servings.toString() +
                                              " " +
                                              I18n.of(bContext).persons,
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
                                    text: I18n.of(bContext).effort + ": ",
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
                          recipe.source != "" && recipe.source != null
                              ? pw.Padding(
                                  // TODO: Wrap in Container for avoiding overflow
                                  padding: pw.EdgeInsets.only(top: 8),
                                  child: pw.Row(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Text(
                                        I18n.of(bContext).source + ": ",
                                        style: pw.TextStyle(
                                            font: latoTtf,
                                            color: PdfColors.grey700,
                                            fontSize: 11),
                                      ),
                                      pw.Text(
                                        source,
                                        style: pw.TextStyle(
                                          font: latoTtf,
                                          fontSize: 11,
                                          color: PdfColors.blue,
                                        ),
                                      )
                                    ],
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
                              ? pw.RichText(
                                  text: pw.TextSpan(
                                    children: [
                                      pw.TextSpan(
                                        text:
                                            I18n.of(bContext).ingredients + " ",
                                        style: pw.TextStyle(
                                          font: quandoTtf,
                                          color: PdfColors.red900,
                                          fontSize: 16,
                                        ),
                                      ),
                                      pw.TextSpan(
                                        text: "(" +
                                            (recipe.vegetable ==
                                                    Vegetable.NON_VEGETARIAN
                                                ? I18n.of(bContext).with_meat
                                                : recipe.vegetable ==
                                                        Vegetable.VEGETARIAN
                                                    ? I18n.of(bContext)
                                                        .vegetarian
                                                    : I18n.of(bContext).vegan) +
                                            ")",
                                        style: pw.TextStyle(
                                          font: latoTtf,
                                          fontSize: 8,
                                          color: recipe.vegetable ==
                                                  Vegetable.NON_VEGETARIAN
                                              ? PdfColors.red800
                                              : recipe.vegetable ==
                                                      Vegetable.VEGETARIAN
                                                  ? PdfColors.yellow900
                                                  : PdfColors.green700,
                                        ),
                                      )
                                    ],
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
                              I18n.of(bContext).nutritions,
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
                      ? pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                              pw.Container(
                                width: 200,
                                child: pw.Padding(
                                  padding: pw.EdgeInsets.only(top: 8),
                                  child: pw.Text(
                                    I18n.of(bContext).notes,
                                    style: pw.TextStyle(
                                      font: quandoTtf,
                                      color: PdfColors.red900,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              pw.Padding(
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
                            ])
                      : null,
                ]..removeWhere((item) => item == null))
                ..removeWhere((item) => item == null),
            ),
          ]));

  return doc.save();
}
