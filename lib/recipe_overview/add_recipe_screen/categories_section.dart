import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_recipe_book/blocs/new_recipe/general_info/general_info_event.dart';

import '../../blocs/category_manager/category_manager_bloc.dart';
import '../../blocs/category_manager/category_manager_state.dart';
import '../../blocs/new_recipe/general_info/general_info_bloc.dart';
import '../../dialogs/add_nut_cat_dialog.dart';
import '../../generated/i18n.dart';

class Consts {
  Consts._();

  static const double padding = 16.0;
}

class CategorySection extends StatefulWidget {
  final List<String> selectedCategories;
  final bool editingRecipe;

  CategorySection({
    this.selectedCategories = const [],
    @required this.editingRecipe,
  });

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

  @override
  void dispose() {
    categoryNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryManagerBloc, CategoryManagerState>(
        builder: (context, state) {
      if (state is LoadingCategoryManager) {
        return CircularProgressIndicator();
      } else if (state is LoadedCategoryManager) {
        return Column(
          children: <Widget>[
            // heading for the subcategory selector section
            Padding(
                padding: const EdgeInsets.only(left: 56, right: 6, top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      S.of(context).select_subcategories,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add_circle_outline),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => AddDialog(
                            false,
                            state.categories,
                            recipeManagerBloc:
                                BlocProvider.of<CategoryManagerBloc>(context)
                                    .recipeManagerBloc,
                            categoryManagerBloc:
                                BlocProvider.of<CategoryManagerBloc>(context),
                          ),
                        );
                      },
                    )
                  ],
                )),
            // category chips
            Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: WatchBoxBuilder(
                  box: Hive.box<List<String>>('order'),
                  builder: (context, boxCategory) {
                    List<String> categories = boxCategory.get('categories');
                    return Wrap(
                      spacing: 5.0,
                      runSpacing: 3.0,
                      children: categories.map((category) {
                        return MyCategoryFilterChip(
                          chipName: category,
                          isSelected:
                              widget.selectedCategories.contains(category),
                          editingRecipe: widget.editingRecipe,
                        );
                      }).toList()
                        ..removeLast(),
                    );
                  }),
            )
          ],
        );
      }
    });
  }
}

enum AnswersCategory { SAVE, DISMISS }

// creates a filterClip with the given name
class MyCategoryFilterChip extends StatefulWidget {
  final String chipName;
  final isSelected;
  final bool editingRecipe;

  MyCategoryFilterChip({
    Key key,
    this.chipName,
    this.isSelected,
    this.editingRecipe,
  });

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

    _isSelected = widget.isSelected;
  }

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(widget.chipName),
      selected: _isSelected,
      onSelected: (isSelected) {
        setState(() {
          if (_isSelected == true) {
            BlocProvider.of<GeneralInfoBloc>(context)
                .add(RemoveCategoryFromRecipe(
              widget.chipName,
              widget.editingRecipe,
            ));
          } else {
            BlocProvider.of<GeneralInfoBloc>(context).add(AddCategoryToRecipe(
              widget.chipName,
              widget.editingRecipe,
            ));
          }
          _isSelected = isSelected;
        });
      },
    );
  }
}
