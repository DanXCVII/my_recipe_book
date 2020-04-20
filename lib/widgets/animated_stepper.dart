import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_recipe_book/constants/global_settings.dart';
import 'package:transparent_image/transparent_image.dart';

import '../blocs/animated_stepper/animated_stepper_bloc.dart';
import 'gallery_view.dart';

class AnimatedStepper extends StatelessWidget {
  final List<String> steps;
  final String fontFamily;
  // if losResStepImages are provided, also stepImages must be provided
  final List<List<String>> lowResStepImages;
  final List<List<String>> stepImages;
  final List<Color> stepsColors = [
    Color(0xff28B404),
    Color(0xff009BDE),
    Color(0xffE3B614),
    Color(0xff8600C5),
  ];

  AnimatedStepper(this.steps,
      {this.stepImages, this.fontFamily, this.lowResStepImages, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List<Widget>.generate(
          steps.length,
          (index) => BlocBuilder<AnimatedStepperBloc, AnimatedStepperState>(
                  builder: (context, state) {
                if (state is SelectedStep) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: InkWell(
                      onTap: () {
                        BlocProvider.of<AnimatedStepperBloc>(context)
                            .add(ChangeStep(index));
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        color: Color.fromRGBO(
                            0, 0, 0, state.selectedStep == index ? 0.5 : 0),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12, right: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 5, 12, 12),
                                child: Stack(children: <Widget>[
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 0, top: 20),
                                      child: AnimatedContainer(
                                        duration: Duration(milliseconds: 200),
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              offset: Offset(2, 2),
                                              blurRadius: 3,
                                              spreadRadius: 1,
                                              color: Colors.black26,
                                            ),
                                          ],

                                          gradient: RadialGradient(
                                            center: const Alignment(
                                                0, 0), // near the top right
                                            radius: state.selectedStep == index
                                                ? 0.5
                                                : 0.6,
                                            colors: [
                                              stepsColors[index %
                                                  (stepsColors
                                                      .length)], // yellow sun
                                              state.selectedStep == index
                                                  ? Colors.transparent
                                                  : stepsColors[index %
                                                          (stepsColors.length)]
                                                      .withOpacity(
                                                          0.5), // blue sky
                                            ],
                                            stops: [0.6, 1.0],
                                          ),
                                          // color: stepsColors[i % (stepsColors.length)],
                                        ),
                                      )),
                                  Text("${index + 1}.",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 54))
                                ]),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        BlocProvider.of<AnimatedStepperBloc>(
                                                context)
                                            .add(ChangeStep(index));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.only(top: 15),
                                        child: Text(
                                          steps[index],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontFamily: fontFamily,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 12.0),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                90,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8.0),
                                          child: Wrap(
                                            runSpacing: 10,
                                            spacing: 10,
                                            children: List<Widget>.generate(
                                              lowResStepImages == null
                                                  ? stepImages[index].length
                                                  : lowResStepImages[index]
                                                      .length,
                                              (wrapIndex) => GestureDetector(
                                                onTap: () {
                                                  _showStepFullView(
                                                      stepImages,
                                                      steps,
                                                      index,
                                                      wrapIndex,
                                                      context);
                                                },
                                                child: Hero(
                                                  tag: GlobalSettings()
                                                          .animationsEnabled()
                                                      ? "Schritt$index:$wrapIndex"
                                                      : "Schritt$index:${wrapIndex}3",
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                    child: Container(
                                                      width: 100,
                                                      height: 80,
                                                      child: FadeInImage(
                                                        fadeInDuration:
                                                            Duration(
                                                                milliseconds:
                                                                    100),
                                                        placeholder: MemoryImage(
                                                            kTransparentImage),
                                                        image: FileImage(
                                                          File(lowResStepImages ==
                                                                  null
                                                              ? stepImages[
                                                                      index]
                                                                  [wrapIndex]
                                                              : lowResStepImages[
                                                                      index]
                                                                  [wrapIndex]),
                                                        ),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Text(state.toString());
                }
              })),
    );
  }

  void _showStepFullView(
    List<List<String>> stepImages,
    List<String> description,
    int stepNumber,
    int imageNumber,
    BuildContext context,
  ) {
    List<String> flatStepImages = [];
    List<String> imageDescription = [];
    List<String> heroTags = [];
    int imageIndex = 0;
    for (int i = 0; i < stepImages.length; i++) {
      if (i < stepNumber) imageIndex += stepImages[i].length;
      for (int j = 0; j < stepImages[i].length; j++) {
        imageDescription.add(description[i]);
        flatStepImages.add(stepImages[i][j]);
        heroTags.add("Schritt$i:$j");
      }
    }
    imageIndex += imageNumber;

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GalleryPhotoView(
            initialIndex: imageIndex,
            galleryImagePaths: flatStepImages,
            descriptions: imageDescription,
            heroTags: heroTags,
          ),
        ));
  }
}
