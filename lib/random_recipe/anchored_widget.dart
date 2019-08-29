import 'package:flutter/material.dart';

class AnchoredOverlay extends StatelessWidget {
  final bool showOverlay;
  final Widget Function(BuildContext, Rect anchorBounds, Offset anchor) overlayBuilder;
  final Widget child;

  AnchoredOverlay({
    key,
    this.showOverlay = false,
    this.overlayBuilder,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // This LayoutBuilder gives us the opportunity to measure the above
      // Container to calculate the "anchor" point at its center.
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return OverlayBuilder(
            showOverlay: showOverlay,
            overlayBuilder: (BuildContext overlayContext) {
              // To calculate the "anchor" point we grab the render box of
              // our parent Container and then we find the center of that box.
              RenderBox box = context.findRenderObject() as RenderBox;
              final topLeft = box.size.topLeft(box.localToGlobal(const Offset(0.0, 0.0)));
              final bottomRight = box.size.bottomRight(box.localToGlobal(const Offset(0.0, 0.0)));
              final Rect anchorBounds = Rect.fromLTRB(
                topLeft.dx,
                topLeft.dy,
                bottomRight.dx,
                bottomRight.dy,
              );
              final anchorCenter = box.size.center(topLeft);

              return overlayBuilder(overlayContext, anchorBounds, anchorCenter);
            },
            child: child,
          );
        },
      ),
    );
  }
}

class OverlayBuilder extends StatefulWidget {
  final bool showOverlay;
  final Widget Function(BuildContext) overlayBuilder;
  final Widget child;

  OverlayBuilder({
    key,
    this.showOverlay = false,
    this.overlayBuilder,
    this.child,
  }) : super(key: key);

  @override
  _OverlayBuilderState createState() => new _OverlayBuilderState();
}

class _OverlayBuilderState extends State<OverlayBuilder> {
  OverlayEntry overlayEntry;

  @override
  void initState() {
    super.initState();

    if (widget.showOverlay) {
      WidgetsBinding.instance.addPostFrameCallback((_) => showOverlay());
    }
  }

  @override
  void didUpdateWidget(OverlayBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) => syncWidgetAndOverlay());
  }

  @override
  void reassemble() {
    super.reassemble();
    WidgetsBinding.instance.addPostFrameCallback((_) => syncWidgetAndOverlay());
  }

  @override
  void dispose() {
    if (isShowingOverlay()) {
      hideOverlay();
    }

    super.dispose();
  }

  bool isShowingOverlay() => overlayEntry != null;

  void showOverlay() {
    if (overlayEntry == null) {
      // Create the overlay.
      overlayEntry = new OverlayEntry(
        builder: widget.overlayBuilder,
      );
      addToOverlay(overlayEntry);
    } else {
      // Rebuild overlay.
      WidgetsBinding.instance.addPostFrameCallback((_) => buildOverlay());
    }
  }

  void addToOverlay(OverlayEntry entry) async {
    Overlay.of(context).insert(entry);
  }

  void hideOverlay() {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
    }
  }

  void syncWidgetAndOverlay() {
    if (isShowingOverlay() && !widget.showOverlay) {
      hideOverlay();
    } else if (!isShowingOverlay() && widget.showOverlay) {
      showOverlay();
    }
  }

  void buildOverlay() async {
    overlayEntry?.markNeedsBuild();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => buildOverlay());

    return widget.child;
  }
}

class CenterAbout extends StatelessWidget {

  final Offset position;
  final Widget child;

  CenterAbout({
    key,
    this.position,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Positioned(
      left: position.dx,
      top: position.dy,
      child: new FractionalTranslation(
        translation: const Offset(-0.5, -0.5),
        child: child,
      ),
    );
  }
}