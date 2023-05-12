import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../ad_related/ad.dart';
import '../../../blocs/recipe_manager/recipe_manager_bloc.dart';
import '../../../blocs/recipe_tag_manager/recipe_tag_manager_bloc.dart';
import '../../../constants/routes.dart';
import 'package:my_recipe_book/generated/l10n.dart';
import '../../../models/string_int_tuple.dart';
import '../../../widgets/dialogs/text_color_dialog.dart';
import '../../recipe_tag_manager_screen.dart';

class Consts {
  Consts._();

  static const double padding = 16.0;
}

class RecipeTagSection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RecipeTagSectionState();
  }
}

class _RecipeTagSectionState extends State<RecipeTagSection> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeTagManagerBloc, RecipeTagManagerState>(
        builder: (context, state) {
      if (state is LoadingRecipeTagManager) {
        return CircularProgressIndicator();
      } else if (state is LoadedRecipeTagManager) {
        return Column(
          children: <Widget>[
            // heading for the recipeTag selector section
            Padding(
                padding: const EdgeInsets.only(left: 56, right: 6, top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      S.of(context).select_recipe_tags,
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
                          builder: (_) => TextColorDialog(
                            validation: (String? name) {
                              if (state.recipeTags.firstWhereOrNull(
                                      (element) => element.text == name) !=
                                  null) {
                                return S.of(context).recipe_tag_already_exists;
                              } else if (name == "") {
                                return S.of(context).field_must_not_be_empty;
                              } else {
                                return null;
                              }
                            },
                            save: (String name, int color) {
                              BlocProvider.of<RecipeTagManagerBloc>(context)
                                  .recipeManagerBloc
                                  .add(
                                    RMAddRecipeTag([
                                      StringIntTuple(text: name, number: color)
                                    ]),
                                  );
                            },
                            hintText: S.of(context).recipe_tag,
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(MdiIcons.arrowExpand),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          RouteNames.manageRecipeTags,
                          arguments: RecipeTagManagerArguments(
                            recipeTagManagerBloc:
                                BlocProvider.of<RecipeTagManagerBloc>(context),
                          ),
                        ).then((_) => Ads.hideBottomBannerAd());
                      },
                    )
                  ],
                )),
            // recipe tag chips
            Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Wrap(
                spacing: 5.0,
                runSpacing: 3.0,
                children: state.recipeTags.map((recipeTag) {
                  return MyRecipeTagFilterChip(
                    recipeTag: recipeTag,
                    isSelected: BlocProvider.of<RecipeTagManagerBloc>(context)
                        .selectedTags
                        .contains(recipeTag),
                    onSelect: (_) =>
                        BlocProvider.of<RecipeTagManagerBloc>(context)
                            .add(SelectRecipeTag(recipeTag)),
                    onDeselect: (_) =>
                        BlocProvider.of<RecipeTagManagerBloc>(context)
                            .add(UnselectRecipeTag(recipeTag)),
                  );
                }).toList(),
              ),
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
class MyRecipeTagFilterChip extends StatefulWidget {
  final StringIntTuple? recipeTag;
  final isSelected;
  final Function(StringIntTuple? name) onSelect;
  final Function(StringIntTuple? name) onDeselect;

  MyRecipeTagFilterChip({
    Key? key,
    this.recipeTag,
    this.isSelected,
    required this.onSelect,
    required this.onDeselect,
  });

  @override
  State<StatefulWidget> createState() {
    return _MyRecipeTagFilterChipState();
  }
}

class _MyRecipeTagFilterChipState extends State<MyRecipeTagFilterChip> {
  bool? _isSelected = false;

  @override
  void initState() {
    super.initState();

    _isSelected = widget.isSelected;
  }

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(widget.recipeTag!.text),
      backgroundColor: Color(widget.recipeTag!.number),
      selected: _isSelected!,
      onSelected: (isSelected) {
        setState(() {
          if (_isSelected == true) {
            widget.onDeselect(widget.recipeTag);
          } else {
            widget.onSelect(widget.recipeTag);
          }
          _isSelected = isSelected;
        });
      },
    );
  }
}
