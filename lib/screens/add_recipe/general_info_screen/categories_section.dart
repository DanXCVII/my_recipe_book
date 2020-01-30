import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../blocs/category_manager/category_manager_bloc.dart';
import '../../../blocs/category_manager/category_manager_state.dart';
import '../../../blocs/recipe_manager/recipe_manager_event.dart';
import '../../../generated/i18n.dart';
import '../../../widgets/dialogs/textfield_dialog.dart';

class Consts {
  Consts._();

  static const double padding = 16.0;
}

class CategorySection extends StatefulWidget {
  final Function(String) onSelect;
  final Function(String) onDeselect;
  final List<String> selectedCategories;

  CategorySection({
    this.selectedCategories = const [],
    @required this.onSelect,
    @required this.onDeselect,
  });

  @override
  State<StatefulWidget> createState() {
    return _CategorySectionState();
  }
}

class _CategorySectionState extends State<CategorySection> {
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
                          builder: (_) => TextFieldDialog(
                            validation: (String name) {
                              if (state.categories.contains(name)) {
                                return 'category already exists';
                              } else {
                                return null;
                              }
                            },
                            save: (String name) {
                              BlocProvider.of<CategoryManagerBloc>(context)
                                  .recipeManagerBloc
                                  .add(RMAddCategory(name));
                            },
                            hintText: 'category name',
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
                          onSelect: widget.onSelect,
                          onDeselect: widget.onDeselect,
                        );
                      }).toList()
                        ..removeLast(),
                    );
                  }),
            )
          ],
        );
      } else {
        return Text(state.toString());
      }
    });
  }
}

// creates a filterClip with the given name
class MyCategoryFilterChip extends StatefulWidget {
  final String chipName;
  final isSelected;
  final Function(String name) onSelect;
  final Function(String name) onDeselect;

  MyCategoryFilterChip({
    Key key,
    this.chipName,
    this.isSelected,
    @required this.onSelect,
    @required this.onDeselect,
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
            widget.onDeselect(widget.chipName);
          } else {
            widget.onSelect(widget.chipName);
          }
          _isSelected = isSelected;
        });
      },
    );
  }
}