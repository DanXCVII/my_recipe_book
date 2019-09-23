import 'dart:io';

import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:flutter/material.dart';

class GalleryPhotoView extends StatefulWidget {
  final List<String> heroTags;
  final int initialIndex;
  final PageController pageController;
  final List<String> galleryItems;
  final List<String> descriptions;

  GalleryPhotoView({
    this.heroTags,
    this.initialIndex,
    @required this.galleryItems,
    this.descriptions,
  }) : pageController = PageController(initialPage: initialIndex);

  @override
  State<StatefulWidget> createState() {
    return _GalleryPhotoViewWrapperState();
  }
}

class _GalleryPhotoViewWrapperState extends State<GalleryPhotoView> {
  int currentIndex;
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
      appBar: AppBar(
        // TODO: Make AppBar somehow transparent
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.black),
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: <Widget>[
            PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: _buildItem,
              itemCount: widget.galleryItems.length,
              loadingChild: Center(child: CircularProgressIndicator()),
              backgroundDecoration: BoxDecoration(color: Colors.black),
              pageController: widget.pageController,
              onPageChanged: onPageChanged,
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                color: Color.fromRGBO(0, 0, 0, 0.3),
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  widget.descriptions[currentIndex],
                  style: const TextStyle(
                      color: Colors.white, fontSize: 17.0, decoration: null),
                ))
          ],
        ),
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    return PhotoViewGalleryPageOptions(
      imageProvider: FileImage(File(widget.galleryItems[index])),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * (1.0),
      maxScale: PhotoViewComputedScale.covered * 1.5,
      heroTag: widget.heroTags[index],
    );
  }
}
