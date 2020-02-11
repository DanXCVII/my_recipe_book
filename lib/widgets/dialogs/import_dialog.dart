import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../blocs/import_recipe/import_recipe_bloc.dart';
import '../../models/recipe.dart';

enum ImportStatus { Loading, Selection, Finished }

class ImportDialog extends StatefulWidget {
  ImportDialog({Key key}) : super(key: key);

  @override
  _ImportDialogState createState() => _ImportDialogState();
}

class _ImportDialogState extends State<ImportDialog>
    with SingleTickerProviderStateMixin {
  ImportStatus importStatus = ImportStatus.Loading;
  int totalListItems = 0;
  List<Recipe> selectedRecipes = [];

  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(12),
      title: Text(importStatus == ImportStatus.Finished
          ? "finished"
          : importStatus == ImportStatus.Loading
              ? "importing recipe/s"
              : "select recipes to import"),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: BlocListener<ImportRecipeBloc, ImportRecipeState>(
        listener: (context, state) {
          if (state is ImportingRecipes) {
            setState(() {
              importStatus = ImportStatus.Loading;
              _controller.forward();
            });
          }
          if (state is ImportedRecipes) {
            setState(() {
              _controller.forward();
              importStatus = ImportStatus.Finished;
              totalListItems = state.importedRecipes.length +
                  state.alreadyExistingRecipes.length +
                  state.failedRecipes.length;
            });
          } else if (state is MultipleRecipes) {
            setState(() {
              importStatus = ImportStatus.Selection;
              totalListItems = state.readyToImportRecipes.length +
                  state.alreadyExistingRecipes.length +
                  state.failedZips.length;
              _controller.forward();
            });
          }
        },
        child: SizeTransition(
          sizeFactor: _controller,
          child: BlocBuilder<ImportRecipeBloc, ImportRecipeState>(
              builder: (context, state) {
            double percentageDone;
            if (state is InitialImportRecipeState ||
                state is ImportingRecipes) {
              if (state is InitialImportRecipeState) {
                percentageDone = 0;
              } else if (state is ImportingRecipes) {
                percentageDone = state.percentageDone;
              }
              return Container(
                height: 20,
                child: LinearPercentIndicator(
                  animation: true,
                  lineHeight: 20.0,
                  animationDuration: 500,
                  percent: percentageDone,
                  center: Text("${percentageDone * 100}%"),
                  linearStrokeCap: LinearStrokeCap.roundAll,
                  progressColor: Colors.green,
                ),
              );
            } else if (state is MultipleRecipes) {
              return Container(
                height: totalListItems > 4
                    ? 242
                    : totalListItems.toDouble() * 60 + 62,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        height: totalListItems == 1
                            ? 60
                            : totalListItems == 2 ? 120 : 180,
                        width: 250,
                        child: ListView(
                          children: List.generate(
                            state.readyToImportRecipes.length * 2 - 1,
                            (index) => (index + 1) % 2 == 0
                                ? Divider()
                                : ListTile(
                                    title: Text(
                                      state
                                          .readyToImportRecipes[
                                              (index == 0 ? 0 : index / 2)
                                                  .round()]
                                          .name,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    trailing: Checkbox(
                                      value: selectedRecipes.contains(
                                          state.readyToImportRecipes[
                                              (index == 0 ? 0 : index / 2)
                                                  .round()]),
                                      onChanged: (status) {
                                        setState(() {
                                          if (status) {
                                            selectedRecipes.add(
                                                state.readyToImportRecipes[
                                                    (index == 0 ? 0 : index / 2)
                                                        .round()]);
                                          } else {
                                            selectedRecipes.remove(
                                                state.readyToImportRecipes[
                                                    (index == 0 ? 0 : index / 2)
                                                        .round()]);
                                          }
                                        });
                                      },
                                    )),
                          )
                            ..addAll(
                              List.generate(
                                state.alreadyExistingRecipes.length,
                                (index) => ListTile(
                                  title: Text(
                                    state.alreadyExistingRecipes[index].name,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  trailing: Icon(
                                    Icons.offline_bolt,
                                    color: Colors.yellow,
                                  ),
                                ),
                              ),
                            )
                            ..addAll(
                              List.generate(
                                state.failedZips.length,
                                (index) => ListTile(
                                  title: Text(
                                    state.failedZips[index],
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  trailing: Icon(
                                    MdiIcons.alertCircle,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                        ),
                      ),
                    ),
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            Icons.check_box,
                            color: Colors.green,
                            size: 14,
                          ),
                          Text(
                            ' ready ',
                            style: TextStyle(fontSize: 12),
                          ),
                          Icon(
                            Icons.offline_bolt,
                            color: Colors.yellow,
                            size: 14,
                          ),
                          Text(
                            ' duplicate ',
                            style: TextStyle(fontSize: 12),
                          ),
                          Icon(
                            MdiIcons.alertCircle,
                            color: Colors.red,
                            size: 14,
                          ),
                          Text(
                            ' failed',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 75,
                          child: FlatButton(
                            child: Text("cancel"),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Container(
                          width: 75,
                          child: FlatButton(
                            child: Text("import"),
                            onPressed: () => selectedRecipes.isNotEmpty
                                ? BlocProvider.of<ImportRecipeBloc>(context)
                                    .add(FinishImportRecipes(selectedRecipes))
                                : {},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            } else if (state is ImportedRecipes) {
              return Container(
                height: totalListItems > 4
                    ? 242
                    : totalListItems.toDouble() * 60 + 74,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        height: totalListItems == 1
                            ? 60
                            : totalListItems == 2 ? 120 : 180,
                        width: 250,
                        child: ListView(
                          children: List.generate(
                            state.importedRecipes.length,
                            (index) => ListTile(
                              title: Text(state.importedRecipes[index].name),
                              trailing: Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),
                            ),
                          )
                            ..addAll(
                              List.generate(
                                state.alreadyExistingRecipes.length,
                                (index) => ListTile(
                                  title: Text(
                                      state.alreadyExistingRecipes[index].name),
                                  trailing: Icon(
                                    Icons.offline_bolt,
                                    color: Colors.yellow,
                                  ),
                                ),
                              ),
                            )
                            ..addAll(
                              List.generate(
                                state.failedRecipes.length,
                                (index) => ListTile(
                                  title: Text(state.failedRecipes[index].name),
                                  trailing: Icon(
                                    MdiIcons.alertCircle,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 14,
                          ),
                          Text(
                            ' successful ',
                            style: TextStyle(fontSize: 12),
                          ),
                          Icon(
                            Icons.offline_bolt,
                            color: Colors.yellow,
                            size: 14,
                          ),
                          Text(
                            ' duplicate ',
                            style: TextStyle(fontSize: 12),
                          ),
                          Icon(
                            MdiIcons.alertCircle,
                            color: Colors.red,
                            size: 14,
                          ),
                          Text(
                            ' failed',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 60,
                      child: FlatButton(
                        child: Text("ok"),
                        onPressed: () => Navigator.pop(context),
                      ),
                    )
                  ],
                ),
              );
            } else {
              return Text(state.toString());
            }
          }),
        ),
      ),
    );
  }
}
