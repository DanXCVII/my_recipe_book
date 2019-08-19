import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../../recipe.dart';
import '../../database.dart';

class Consts {
  Consts._();

  static const double padding = 16.0;
}

class CategorySection extends StatefulWidget {
  final List<String> recipeCategories;
  final GlobalKey<FormState> formKey;

  CategorySection(this.recipeCategories, this.formKey);

  @override
  State<StatefulWidget> createState() {
    return _CategorySectionState();
  }
}

class _CategorySectionState extends State<CategorySection> {
  TextEditingController categoryNameController;

  @override
  initState() {
    categoryNameController = new TextEditingController();
    super.initState();
  }

  List<Widget> _getCategoryChips(List<String> categoryNames) {
    List<Widget> output = new List<Widget>();

    for (int i = 0; i < categoryNames.length; i++) {
      output.add(MyCategoryFilterChip(
        chipName: "${categoryNames[i]}",
        recipeCategories: widget.recipeCategories,
      ));
    }
    return output;
  }

  @override
  void dispose() {
    categoryNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // heading for the subcategory selector section
        Padding(
            padding: const EdgeInsets.only(left: 56, right: 6, top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "select subcategories:",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.grey[700]),
                ),
                IconButton(
                  icon: Icon(Icons.add_circle_outline),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) => CategoryAddDialog(widget.formKey));
                  },
                )
              ],
            )),
        // category chips
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Container(
            child: FutureBuilder<List<String>>(
                future: DBProvider.db.getCategories(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<String> categoryNames = [];
                    for (final category in snapshot.data)
                      categoryNames.add(category);
                    return Wrap(
                      spacing: 5.0,
                      runSpacing: 3.0,
                      children: _getCategoryChips(categoryNames),
                    );
                  }
                  if (snapshot.hasError) {
                    return Text("Error occured");
                  }
                  return LinearProgressIndicator();
                }),
          ),
        ),
      ],
    );
  }
}

enum AnswersCategory { SAVE, DISMISS }

// creates a filterClip with the given name
class MyCategoryFilterChip extends StatefulWidget {
  final String chipName;
  final List<String> recipeCategories;

  MyCategoryFilterChip({Key key, this.chipName, this.recipeCategories});

  @override
  State<StatefulWidget> createState() {
    return _MyCategoryFilterChipState();
  }
}

class _MyCategoryFilterChipState extends State<MyCategoryFilterChip> {
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();

    widget.recipeCategories.contains(widget.chipName)
        ? _isSelected = true
        : _isSelected = false;
  }

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(widget.chipName),
      selected: _isSelected,
      onSelected: (isSelected) {
        setState(() {
          _isSelected = isSelected;
          if (isSelected == true) {
            widget.recipeCategories.add(widget.chipName);
          } else {
            widget.recipeCategories.remove(widget.chipName);
          }
        });
      },
    );
  }
}

class CategoryAddDialog extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  CategoryAddDialog(this.formKey);

  @override
  State<StatefulWidget> createState() {
    return CategoryAddDialogState();
  }
}

class CategoryAddDialogState extends State<CategoryAddDialog> {
  TextEditingController categoryNameController;

  @override
  initState() {
    super.initState();
    categoryNameController = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  Widget dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(
            Consts.padding,
          ),
          margin: EdgeInsets.only(top: Consts.padding),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(Consts.padding),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              SizedBox(height: 16.0),
              TextFormField(
                controller: categoryNameController,
                autovalidate: true,
                validator: (value) {
                  // TODO: Validate if category already exists
                  //if (Categories.getCategories().contains(value))
                  //  return "category already exists";
                  return null;
                },
                decoration: InputDecoration(
                  filled: true,
                  hintText: "category name",
                ),
              ),
              SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                      child: Text("Cancel"),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  FlatButton(
                      child: Text("Save"),
                      onPressed: () {
                        if (widget.formKey.currentState.validate()) {
                          // TODO Prio1: Not validating the category!
                          _saveCategory().then((_) {
                            Navigator.pop(context);
                            setState(() {});
                          });
                        }
                      })
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _saveCategory() async {
    String categoryName = categoryNameController.text;
    await DBProvider.db.newCategory(categoryName);
  }
}
