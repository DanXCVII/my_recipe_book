import 'dart:async';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:flutter/material.dart';
import 'package:my_recipe_book/database.dart';
import 'package:my_recipe_book/io/io_operations.dart' as IO;
import 'package:my_recipe_book/recipe.dart';
import 'package:share_extend/share_extend.dart';
import 'package:my_recipe_book/generated/i18n.dart';

class ExportRecipes extends StatefulWidget {
  ExportRecipes({Key key}) : super(key: key);

  _ExportRecipesState createState() => _ExportRecipesState();
}

class _ExportRecipesState extends State<ExportRecipes> {
  Future<List<String>> recipeNames;
  List<String> exportRecipeNames = [];

  @override
  void initState() {
    super.initState();
    recipeNames = DBProvider.db.getRecipeNames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('select recipes'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => SaveExportRecipes(
                    exportRecipes: exportRecipeNames,
                  ),
                );
              },
            )
          ],
        ),
        body: FutureBuilder<List<String>>(
          future: recipeNames,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    value: exportRecipeNames.contains(snapshot.data[index]),
                    onChanged: (value) {
                      setState(() {
                        if (value) {
                          exportRecipeNames.add(snapshot.data[index]);
                        } else {
                          exportRecipeNames.remove(snapshot.data[index]);
                        }
                      });
                    },
                    title: Text(
                      snapshot.data[index],
                    ),
                  );
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}

class SaveExportRecipes extends StatefulWidget {
  final List<String> exportRecipes;

  SaveExportRecipes({
    this.exportRecipes,
    Key key,
  }) : super(key: key);

  _SaveExportRecipesState createState() => _SaveExportRecipesState();
}

class _SaveExportRecipesState extends State<SaveExportRecipes> {
  int _exportRecipe = 1;
  bool finished = false;
  Future<String> exportZipFile;

  @override
  void initState() {
    super.initState();
    exportZipFile = exportRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0.0,
      backgroundColor: Theme.of(context).cardColor,
      child: Container(
        height: 90,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(width: 20),
            FutureBuilder<String>(
              future: exportZipFile,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  ShareExtend.share(snapshot.data, "file");
                  myCallback(() {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  });
                }
                return Icon(Icons.receipt);
              },
            ),
            Container(width: 20),
            Text(finished
                ? 'Almost done ☺'
                : 'exporting recipe $_exportRecipe out of ${widget.exportRecipes.length}'),
            Container(width: 20),
          ],
        ),
      ),
    );
  }

  void myCallback(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  Future<String> exportRecipes() async {
    String exportMultiDir = await PathProvider.pP.getShareMultiDir();

    await Directory(exportMultiDir).delete(recursive: true);
    exportMultiDir = await PathProvider.pP.getShareMultiDir();
    for (String r in widget.exportRecipes) {
      await IO.saveRecipeZip(exportMultiDir, r);
      if (widget.exportRecipes.last != r) {
        setState(() {
          _exportRecipe++;
        });
      }
    }
    setState(() {
      finished = true;
    });

    var exportFiles = Directory(exportMultiDir).listSync();
    var encoder = ZipFileEncoder();
    String finalZipFilePath =
        PathProvider.pP.getShareZipFile('multi', exportMultiDir);
    encoder.create(finalZipFilePath);
    for (FileSystemEntity f in exportFiles) {
      encoder.addFile(f);
      f.deleteSync();
    }
    encoder.close();

    return finalZipFilePath;
  }
}
