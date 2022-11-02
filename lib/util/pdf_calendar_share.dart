import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_recipe_book/constants/global_constants.dart' as Constants;
import 'package:my_recipe_book/models/enums.dart';
import 'package:my_recipe_book/models/tuple.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../generated/i18n.dart';
import 'helper.dart';
import '../models/recipe.dart';
import '../models/string_int_tuple.dart';

const double weekDayWidth = 177;
const double weekDayHeight = 182;

Future<Uint8List> getRecipeCalendarPdf(
    Map<DateTime, List<String>> calendarEntries, BuildContext bContext) async {
  final pw.Document doc = pw.Document();

  ByteData righteousData = await rootBundle.load("fonts/Righteous-Regular.ttf");
  final righteousBuffer = righteousData.buffer;
  Uint8List righteousFont = righteousBuffer.asUint8List(
      righteousData.offsetInBytes, righteousData.lengthInBytes);
  final righteousTtf = pw.Font.ttf(righteousFont.buffer.asByteData());

  ByteData quicksandData = await rootBundle.load("fonts/Quicksand-Regular.ttf");
  final quicksandBuffer = quicksandData.buffer;
  Uint8List quicksandFont = quicksandBuffer.asUint8List(
      quicksandData.offsetInBytes, quicksandData.lengthInBytes);
  final quicksandTtf = pw.Font.ttf(quicksandFont.buffer.asByteData());

  const imageProvider = const AssetImage('images/iconIosStyle.png');
  final pdfIconImage = await flutterImageProvider(imageProvider);

  doc.addPage(
    pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        orientation: pw.PageOrientation.landscape,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        header: (context) => pw.Column(children: [
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
              pw.Text("shhheessh 1. April - 8. April 1989"),
            ]),
        build: (pw.Context context) => <pw.Widget>[
              pw.Wrap(
                spacing: 5,
                runSpacing: 5,
                children: List<pw.Widget>.generate(8, (index) {
                  List<Tuple2<DateTime, String>> weekDayRecipes = [];

                  for (DateTime key in calendarEntries.keys.toList()) {
                    if (key.weekday == index + 1) {
                      for (String recipeName
                          in calendarEntries[key]!.toList()) {
                        weekDayRecipes.add(
                          Tuple2<DateTime, String>(key, recipeName),
                        );
                      }
                    }
                  }
                  if (index < 7) {
                    return pw.Container(
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(
                          width: 2.0,
                        ),
                      ),
                      width: weekDayWidth,
                      height: weekDayHeight,
                      child: pw.Column(
                        mainAxisSize: pw.MainAxisSize.min,
                        children: [
                          pw.Container(
                            width: weekDayWidth,
                            height: 20,
                            decoration: pw.BoxDecoration(
                                border: pw.Border(
                              bottom: pw.BorderSide(width: 2),
                            )),
                            child: pw.Padding(
                              padding: pw.EdgeInsets.all(4),
                              child: pw.Text(
                                getWeekdayString(index + 1, bContext),
                              ),
                            ),
                          ),
                        ]..addAll(
                            List.generate(weekDayRecipes.length * 2, (i) {
                              if (i % 2 == 0) {
                                int recipeIndex = (i / 2).round();
                                return pw.Container(
                                  width: weekDayWidth,
                                  child: pw.Padding(
                                    padding: pw.EdgeInsets.all(8),
                                    child: pw.Column(
                                      mainAxisSize: pw.MainAxisSize.min,
                                      children: [
                                        weekDayRecipes[recipeIndex]
                                                        .item1
                                                        .hour ==
                                                    0 &&
                                                weekDayRecipes[recipeIndex]
                                                        .item1
                                                        .minute ==
                                                    0
                                            ? null
                                            : pw.Text(
                                                "${weekDayRecipes[recipeIndex].item1.hour < 10 ? "0" : ""}${weekDayRecipes[i].item1.hour.toString()}:${weekDayRecipes[recipeIndex].item1.minute < 10 ? "0" : ""}${weekDayRecipes[recipeIndex].item1.minute.toString()}",
                                                style: pw.TextStyle(
                                                    // color: PdfColor.fromRYB(
                                                    //     50, 50, 5),
                                                    ),
                                              ),
                                        pw.Text(
                                            weekDayRecipes[recipeIndex].item2),
                                      ].whereType<pw.Widget>().toList(),
                                    ),
                                  ),
                                );
                              } else {
                                return pw.Row(
                                  children: List.generate(10, (i) {
                                    if (i % 2 == 0) {
                                      return pw.Container(width: 10);
                                    } else {
                                      return pw.Container(
                                        width: 10,
                                        decoration: pw.BoxDecoration(
                                          borderRadius: pw.BorderRadius.all(
                                            pw.Radius.circular(3),
                                          ),
                                          // color: PdfColor.fromRYB(50, 50, 50),
                                        ),
                                      );
                                    }
                                  }),
                                );
                              }
                            })
                              ..removeWhere((e) => e == null),
                          ),
                      ),
                    );
                  } else {
                    return pw.Container(
                      width: weekDayWidth,
                      height: weekDayHeight,
                      child: pw.Column(
                        mainAxisSize: pw.MainAxisSize.min,
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Text(I18n.of(bContext)!.notes),
                        ]..addAll(
                            List.generate(
                              10,
                              (i) => pw.Container(
                                width: weekDayWidth - 20,
                                height: 2,
                                // color: PdfColor.fromRYB(50, 50, 50),
                              ),
                            ),
                          ),
                      ),
                    );
                  }
                }),
              )
            ]),
  );

  return doc.save();
}
