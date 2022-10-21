import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:my_recipe_book/ad_related/ad.dart';

import '../../../blocs/category_manager/category_manager_bloc.dart';
import '../../../blocs/recipe_manager/recipe_manager_bloc.dart';
import '../../../constants/routes.dart';
import '../../../generated/i18n.dart';
import '../../../widgets/dialogs/textfield_dialog.dart';
import '../../category_manager.dart';

class Consts {
  Consts._();

  static const double padding = 16.0;
}

class CategorySection extends StatefulWidget {
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
                padding: const EdgeInsets.only(left: 50, right: 6, top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      I18n.of(context).select_subcategories,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.add_circle_outline),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => TextFieldDialog(
                            validation: (String name) {
                              if (state.categories.contains(name)) {
                                return I18n.of(context).category_already_exists;
                              } else if (name == "") {
                                return I18n.of(context).field_must_not_be_empty;
                              } else {
                                return null;
                              }
                            },
                            save: (String name) {
                              BlocProvider.of<CategoryManagerBloc>(context)
                                  .recipeManagerBloc
                                  .add(RMAddCategories([name]));
                            },
                            hintText: I18n.of(context).categoryname,
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(MdiIcons.arrowExpand),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          RouteNames.manageCategories,
                          arguments: CategoryManagerArguments(
                            categoryManagerBloc:
                                BlocProvider.of<CategoryManagerBloc>(context),
                          ),
                        ).then((_) => Ads.hideBottomBannerAd());
                      },
                    )
                  ],
                )),
            // category chips
            Container(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Wrap(
                  spacing: 5.0,
                  runSpacing: 3.0,
                  children: state.categories.map((category) {
                    return MyCategoryFilterChip(
                      chipName: category,
                      isSelected: BlocProvider.of<CategoryManagerBloc>(context)
                          .selectedCategories
                          .contains(category),
                      onSelect: (_) =>
                          BlocProvider.of<CategoryManagerBloc>(context)
                              .add(SelectCategory(category)),
                      onDeselect: (_) =>
                          BlocProvider.of<CategoryManagerBloc>(context)
                              .add(UnselectCategory(category)),
                    );
                  }).toList()
                    ..removeLast(),
                ))
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
  final String/*!*/ chipName;
  final isSelected;
  final Function(String/*!*/ name) onSelect;
  final Function(String/*!*/ name) onDeselect;

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
  bool/*!*/ _isSelected = false;

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
