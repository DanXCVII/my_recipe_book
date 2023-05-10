import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../constants/global_constants.dart' as Constants;

class GalleryPhotoView extends StatefulWidget {
  final List<String> heroTags;
  final int initialIndex;
  final PageController pageController;
  final List<String> galleryImagePaths;
  final List<String> descriptions;

  GalleryPhotoView({
    required this.heroTags,
    required this.initialIndex,
    required this.galleryImagePaths,
    required this.descriptions,
  }) : pageController = PageController(initialPage: initialIndex);

  @override
  State<StatefulWidget> createState() {
    return _GalleryPhotoViewWrapperState();
  }
}

class _GalleryPhotoViewWrapperState extends State<GalleryPhotoView> {
  late int currentIndex;
  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(color: Colors.black),
          constraints: BoxConstraints.expand(
            height: MediaQuery.of(context).size.height,
          ),
          child: Stack(alignment: Alignment.bottomLeft, children: <Widget>[
            PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: _buildItem,
              itemCount: widget.galleryImagePaths.length,
              loadingBuilder: (context, event) =>
                  Center(child: CircularProgressIndicator()),
              backgroundDecoration: BoxDecoration(color: Colors.black),
              pageController: widget.pageController,
              onPageChanged: onPageChanged,
            ),
            widget.descriptions[currentIndex] == ''
                ? Container()
                : Container(
                    width: MediaQuery.of(context).size.width,
                    color: Color.fromRGBO(0, 0, 0, 0.3),
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      widget.descriptions[currentIndex],
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17.0,
                          decoration: null),
                    )),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Opacity(
                opacity: 0.5,
                child: AppBar(
                  backgroundColor: Colors.black..withOpacity(0.3),
                ),
              ),
            )
          ])),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    return PhotoViewGalleryPageOptions(
      imageProvider: (widget.galleryImagePaths[index] == Constants.noRecipeImage
              ? AssetImage(widget.galleryImagePaths[index])
              : FileImage(File(widget.galleryImagePaths[index])))
          as ImageProvider<Object>?,
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * (1.0),
      maxScale: PhotoViewComputedScale.covered * 1.5,
      heroAttributes: PhotoViewHeroAttributes(tag: widget.heroTags[index]),
    );
  }
}
