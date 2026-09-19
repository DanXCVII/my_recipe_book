import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../ad_related/ad.dart';
import '../../../blocs/category_manager/category_manager_bloc.dart';
import '../../../blocs/recipe_manager/recipe_manager_bloc.dart';
import '../../../constants/routes.dart';

import 'package:my_recipe_book/generated/l10n.dart';

import '../../../widgets/editorial_catalog_manager.dart';
import '../../category_manager.dart';
import 'editorial_classification_section.dart';

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
          return EditorialClassificationSection(
            title: S.of(context).select_subcategories,
            addTooltip: S.of(context).add,
            manageTooltip: S.of(context).manage_categories,
            onAdd: () {
              showCatalogNameEditorSheet(
                context: context,
                title: S.of(context).catalog_add_category,
                fieldLabel: S.of(context).categoryname,
                saveLabel: S.of(context).save,
                cancelLabel: S.of(context).cancel,
                emptyError: S.of(context).field_must_not_be_empty,
                duplicateError: S.of(context).category_already_exists,
                existingNames: state.categories,
                onSave: (name) {
                  BlocProvider.of<CategoryManagerBloc>(context)
                      .recipeManagerBloc
                      .add(RMAddCategories([name]));
                },
              );
            },
            onManage: () {
              Navigator.pushNamed(
                context,
                RouteNames.manageCategories,
                arguments: CategoryManagerArguments(
                  categoryManagerBloc: BlocProvider.of<CategoryManagerBloc>(
                    context,
                  ),
                ),
              ).then((_) => Ads.hideBottomBannerAd());
            },
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
            }).toList()..removeLast(),
          );
        } else {
          return Text(state.toString());
        }
      },
    );
  }
}

// creates a filterClip with the given name
class MyCategoryFilterChip extends StatefulWidget {
  final String chipName;
  final isSelected;
  final Function(String name) onSelect;
  final Function(String name) onDeselect;

  MyCategoryFilterChip({
    Key? key,
    required this.chipName,
    this.isSelected,
    required this.onSelect,
    required this.onDeselect,
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
