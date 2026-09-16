import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../blocs/new_recipe/clear_recipe/clear_recipe_bloc.dart';
import '../constants/global_constants.dart' as constants;
import '../generated/l10n.dart';
import 'culinary_editorial_theme.dart';
import 'recipe_editor/editorial_image_remove_button.dart';

class ImageSelector extends StatefulWidget {
  const ImageSelector({
    required this.prefilledImage,
    required this.onNewImage,
    required this.circleSize,
    required this.color,
    required this.onCancel,
    super.key,
  });

  final String prefilledImage;
  final double circleSize;
  final void Function(File imageFile) onNewImage;
  final Color color;
  final VoidCallback onCancel;

  @override
  State<ImageSelector> createState() => _ImageSelectorState();
}

class _ImageSelectorState extends State<ImageSelector> {
  File? selectedImageFile;

  @override
  void initState() {
    super.initState();
    if (widget.prefilledImage != constants.noRecipeImage) {
      selectedImageFile = File(widget.prefilledImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = CulinaryEditorialPalette.of(context);
    return BlocListener<ClearRecipeBloc, ClearRecipeState>(
      listener: (context, state) {
        if (state is ClearedRecipe || state is RemovedRecipeImage) {
          setState(() => selectedImageFile = null);
        }
      },
      child: SizedBox(
        width: double.infinity,
        height: 190,
        child: Material(
          color: palette.surfaceContainer,
          borderRadius: BorderRadius.circular(14),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: _askUser,
            child: selectedImageFile == null
                ? DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: palette.outline),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_a_photo_outlined,
                          size: 38,
                          color: palette.primary,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          S.of(context).add_cover_photo,
                          style: CulinaryEditorialType.body(
                            palette,
                            size: 14,
                            weight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  )
                : Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.file(
                        selectedImageFile!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Image.asset(
                          constants.noRecipeImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Color(0x99000000)],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.photo_camera_outlined,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                S.of(context).change_cover_photo,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: EditorialImageRemoveButton(
                          tooltip: MaterialLocalizations.of(context)
                              .deleteButtonTooltip,
                          onPressed: () {
                            widget.onCancel();
                            setState(() => selectedImageFile = null);
                          },
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> _askUser() async {
    final picture = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picture == null || !mounted) return;
    final file = File(picture.path);
    widget.onNewImage(file);
    setState(() => selectedImageFile = file);
  }
}

enum Answers { GALLERY, PHOTO }
