import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:my_recipe_book/models/recipe_keeper.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../database.dart';

class Consts {
  Consts._();

  static const double padding = 16.0;
}

class CategorySection extends StatefulWidget {
  final List<String> recipeCategories;

  CategorySection(this.recipeCategories);

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
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add_circle_outline),
                  onPressed: () {
                    showDialog(
                        context: context, builder: (_) => CategoryAddDialog());
                  },
                )
              ],
            )),
        // category chips
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Container(
            child: ScopedModelDescendant<RecipeKeeper>(
              builder: (context, child, model) => Wrap(
                spacing: 5.0,
                runSpacing: 3.0,
                children: _getCategoryChips(model.rCategories),
              ),
            ),
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

// TODO: Check if it also works as StatelessWidget
class CategoryAddDialog extends StatefulWidget {
  final String modifiedCategory;

  CategoryAddDialog({this.modifiedCategory});

  @override
  State<StatefulWidget> createState() {
    return CategoryAddDialogState();
  }
}

class CategoryAddDialogState extends State<CategoryAddDialog> {
  TextEditingController categoryNameController;
  static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  initState() {
    super.initState();
    categoryNameController = new TextEditingController();
    if (widget.modifiedCategory == null) {
      categoryNameController.text = widget.modifiedCategory;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(
              Consts.padding,
            ),
            margin: EdgeInsets.only(top: Consts.padding),
            decoration: new BoxDecoration(
              color: Theme.of(context).dialogBackgroundColor,
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
            child: Form(
              key: _formKey,
              child: ScopedModelDescendant<RecipeKeeper>(
                builder: (context, child, model) => Column(
                  mainAxisSize: MainAxisSize.min, // To make the card compact
                  children: <Widget>[
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: categoryNameController,
                      validator: (value) {
                        if (model
                            .doesCategoryExist(categoryNameController.text)) {
                          return 'category already exists';
                        } else {
                          return null;
                        }
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
                            validateAddModifyCategory(model);
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void validateAddModifyCategory(RecipeKeeper rKeeper) {
    if (_formKey.currentState.validate()) {
      if (widget.modifiedCategory == null) {
        rKeeper.addCategory(categoryNameController.text).then((_) {
          Navigator.pop(context);
        });
      } else {
        rKeeper.changeCategoryName(
            widget.modifiedCategory, categoryNameController.text);
      }
    }
  }
}
