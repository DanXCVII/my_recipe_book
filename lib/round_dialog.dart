import 'package:flutter/material.dart';

class RoundDialog extends StatefulWidget {
  final Widget childWidget;
  final double size;

  RoundDialog(this.childWidget, this.size);

  @override
  State<StatefulWidget> createState() => RoundDialogState();
}

class RoundDialogState extends State<RoundDialog>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Stack(children: <Widget>[
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF790604),
                  shape: BoxShape.circle,
                ),
                width: widget.size,
                height: widget.size,
              ),
            ),
            Center(
              child: widget.childWidget
            ),
          ]),
        ),
      ),
    );
  }
}
