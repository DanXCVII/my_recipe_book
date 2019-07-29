import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

import './add_recipe.dart';
import '../../recipe.dart';
import '../../database.dart';
import '../../my_wrapper.dart';
import './image_selector.dart' as IS;

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}

class CategorySection extends StatefulWidget {
  final MyImageWrapper addCategoryImage;
  final List<String> recipeCategories;
  final GlobalKey<FormState> formKey;

  CategorySection(this.addCategoryImage, this.recipeCategories, this.formKey);

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

    print(categoryNames.length);
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
    widget.addCategoryImage.selectedImage = null;
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
                        builder: (_) => CustomDialog(
                            widget.addCategoryImage, widget.formKey));
                  },
                )
              ],
            )),
        // category chips
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Container(
            child: FutureBuilder<List<RecipeCategory>>(
                future: DBProvider.db.getCategories(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<String> categoryNames = [];
                    for (final category in snapshot.data)
                      categoryNames.add(category.name);
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

class CustomDialog extends StatefulWidget {
  final MyImageWrapper addCategoryImage;
  final GlobalKey<FormState> formKey;

  CustomDialog(this.addCategoryImage, this.formKey);

  @override
  State<StatefulWidget> createState() {
    return CustomDialogState();
  }
}

class CustomDialogState extends State<CustomDialog> {
  TextEditingController categoryNameController;

  @override
  initState() {
    categoryNameController = new TextEditingController();
    super.initState();
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
          padding: EdgeInsets.only(
            top: Consts.avatarRadius + Consts.padding,
            bottom: Consts.padding,
            left: Consts.padding,
            right: Consts.padding,
          ),
          margin: EdgeInsets.only(top: Consts.avatarRadius),
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
              Text(
                "new Category",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
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
                  hintText: "new category name",
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
                            widget.addCategoryImage.selectedImage = null;
                            setState(() {});
                          });
                        }
                      })
                ],
              )
            ],
          ),
        ),
        Positioned(
          left: Consts.padding,
          right: Consts.padding,
          child: IS.ImageSelector(
            widget.addCategoryImage,
            120,
            Color(0xFF790604),
          ),
        )
      ],
    );
  }

  Future<void> _saveCategory() async {
    String categoryName = categoryNameController.text;
    String imagePath = '';
    if (widget.addCategoryImage.selectedImage != null) {
      imagePath = await PathProvider.pP.getCategoryPath(categoryName);
      compute(saveImage,
          [File(widget.addCategoryImage.selectedImage), imagePath, 2000]);
    }
    await DBProvider.db.newCategory(categoryName, imagePath);
  }
}
