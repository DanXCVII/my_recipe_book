import 'dart:io';

import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../constants/global_constants.dart' as Constants;
import '../generated/l10n.dart';
import '../models/enums.dart';
import '../models/recipe.dart';
import '../models/string_int_tuple.dart';
import 'helper.dart';

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
  final pdfIconImage = await flutterImageProvider(imageProvider);

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
  for (int i = 0;
      i <
          (recipe.source != null
              ? (recipe.source!.length / sourceCutIndex)
              : 0);
      i++) {
    source += recipe.source!.substring(
        i * sourceCutIndex,
        (i + 1) * sourceCutIndex > recipe.source!.length
            ? recipe.source!.length
            : (i + 1) * sourceCutIndex);
    source += "\n";
  }

  List<pw.Widget> stepWidgets = [
    recipe.steps.isNotEmpty
        ? pw.Padding(
            padding: pw.EdgeInsets.only(top: 8),
            child: pw.Row(children: [
              pw.Text(
                S.of(bContext)!.directions,
                style: pw.TextStyle(
                  font: quandoTtf,
                  color: PdfColors.red900,
                  fontSize: 16,
                ),
              ),
            ]),
          )
        : null,
  ].whereType<pw.Widget>().toList();

  if (recipe.stepTitles == null) {
    stepWidgets.addAll(_getSteps(
        recipe.steps, recipe.stepImages, bContext, quandoTtf, latoTtf, doc));
  } else {
    for (int i = 0; i < recipe.stepTitles!.length; i++) {
      if (i == 0 || recipe.stepTitles![i] != "") {
        int nextTitleIndex = recipe.stepTitles!.length;
        if (i + 1 < recipe.stepTitles!.length) {
          String? nextTitle = recipe.stepTitles!
              .sublist(i + 1)
              .firstWhereOrNull((e) => e != "");
          if (nextTitle == null) {
            nextTitleIndex = recipe.stepTitles!.length;
          } else {
            nextTitleIndex =
                recipe.stepTitles!.sublist(i + 1).indexOf(nextTitle) + i + 1;
          }
        }
        if (recipe.stepTitles![i] != "") {
          stepWidgets.add(
            pw.Padding(
              padding: pw.EdgeInsets.only(top: 8),
              child: pw.Text(
                recipe.stepTitles![i],
                style: pw.TextStyle(
                  font: quandoTtf,
                  color: PdfColors.orange700,
                  fontSize: 12,
                ),
              ),
            ),
          );
        }
        stepWidgets.addAll(
          _getSteps(
              recipe.steps.sublist(i, nextTitleIndex),
              recipe.stepImages.sublist(i, nextTitleIndex),
              bContext,
              quandoTtf,
              latoTtf,
              doc),
        );
      }
    }
  }

  doc.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      header: (pw.Context context) {
        if (context.pageNumber == 1) {
          return pw.Container();
        }
        return pw.Container();
      },
      footer: (pw.Context context) {
        return pw.Stack(children: [
          pw.Align(
            alignment: pw.Alignment.center,
            child: pw.Text(
              "- for personal use only -",
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
                  "My RecipeBible",
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
                          pw.MemoryImage(
                            File(recipe.imagePath).readAsBytesSync(),
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
                            S.of(bContext)!.general_infos,
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
                                          text:
                                              S.of(bContext)!.categories + ": ",
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
                                          text: S.of(bContext)!.tags + ": ",
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
                                          text:
                                              S.of(bContext)!.preperation_time +
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
                                          text:
                                              S.of(bContext)!.cook_time + ": ",
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
                                          text:
                                              S.of(bContext)!.total_time + ": ",
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
                                          text: S.of(bContext)!.for_word + " ",
                                          style: pw.TextStyle(
                                              font: latoTtf,
                                              color: PdfColors.grey700,
                                              fontSize: 11),
                                        ),
                                        pw.TextSpan(
                                          text: recipe.servings.toString() +
                                              " " +
                                              (recipe.servingName ??
                                                  S.of(bContext)!.persons),
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
                                    text: S.of(bContext)!.effort + ": ",
                                    style: pw.TextStyle(
                                        font: latoTtf,
                                        color: PdfColors.grey700,
                                        fontSize: 11),
                                  ),
                                  pw.TextSpan(
                                    text: "${recipe.effort}/10",
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
                                  padding: pw.EdgeInsets.only(top: 8),
                                  child: pw.Row(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Text(
                                        S.of(bContext)!.source + ": ",
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
                        ].whereType<pw.Widget>().toList()),
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
                                        text: S.of(bContext)!.ingredients + " ",
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
                                                ? S.of(bContext)!.with_meat
                                                : recipe.vegetable ==
                                                        Vegetable.VEGETARIAN
                                                    ? S.of(bContext)!.vegetarian
                                                    : S.of(bContext)!.vegan) +
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
                                          ].whereType<pw.Widget>().toList()),
                                    ),
                                  ),
                                )
                              : null,
                        ].whereType<pw.Widget>().toList()),
                    recipe.nutritions.isNotEmpty
                        ? pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            mainAxisSize: pw.MainAxisSize.min,
                            children: [
                              pw.Padding(
                                padding: pw.EdgeInsets.only(top: 8, bottom: 8),
                                child: pw.Text(
                                  S.of(bContext)!.nutritions,
                                  style: pw.TextStyle(
                                    font: quandoTtf,
                                    color: PdfColors.red900,
                                    fontSize: 16,
                                  ),
                                ),
                              )
                            ]..addAll(
                                recipe.nutritions
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
                                                    text:
                                                        "${nutrition.amountUnit} ",
                                                    style: pw.TextStyle(
                                                        font: latoTtf,
                                                        fontSize: 11),
                                                  ),
                                                  pw.TextSpan(
                                                    text: "${nutrition.name}",
                                                    style: pw.TextStyle(
                                                        font: latoTtf,
                                                        fontSize: 11,
                                                        color:
                                                            PdfColors.grey800,
                                                        fontWeight:
                                                            pw.FontWeight.bold),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ))
                        : null,
                  ].whereType<pw.Widget>().toList()),
                ),
              ].whereType<pw.Widget>().toList()
                ..addAll(stepWidgets)
                ..addAll(
                  [
                    recipe.notes != ""
                        ? pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                                pw.Container(
                                  width: 200,
                                  child: pw.Padding(
                                    padding: pw.EdgeInsets.only(top: 8),
                                    child: pw.Text(
                                      S.of(bContext)!.notes,
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
                  ].whereType<pw.Widget>().toList(),
                ),
            ),
          ].whereType<pw.Widget>().toList()));

  return doc.save();
}

List<pw.Widget> _getSteps(
  List<String> steps,
  List<List<String>> stepImages,
  BuildContext context,
  pw.Font quandoTtf,
  pw.Font latoTtf,
  pw.Document doc,
) {
  List<pw.Widget> stepList = List.generate(
    steps.length,
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
              "${steps[index]}",
              style: pw.TextStyle(font: latoTtf, fontSize: 11),
            ),
          ),
        ],
      ),
    ),
  );

  for (int i = stepImages.length - 1; i >= 0; i--) {
    if (stepImages[i].isNotEmpty) {
      stepList.insert(
        i + 1,
        pw.Padding(
          padding: pw.EdgeInsets.fromLTRB(12, 8, 22, 8),
          child: pw.Container(
            width: 500,
            child: pw.Wrap(
              direction: pw.Axis.horizontal,
              children: List.generate(
                stepImages[i].length,
                (index) => pw.Padding(
                  padding: pw.EdgeInsets.fromLTRB(8, 4, 8, 4),
                  child: pw.ClipRRect(
                    horizontalRadius: 8,
                    verticalRadius: 8,
                    child: pw.Image(
                      pw.MemoryImage(
                          File(stepImages[i][index]).readAsBytesSync()),
                      fit: pw.BoxFit.contain,
                      height: 100,
                      width: 100,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  return stepList;
}
