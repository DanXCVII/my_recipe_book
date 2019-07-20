import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';

class SavingDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SavingDialogState();
}

class SavingDialogState extends State<SavingDialog>
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
                width: 150,
                height: 150,
              ),
            ),
            Center(
              child: FlareActor(
                'animations/writing_pen.flr',
                alignment: Alignment.center,
                fit: BoxFit.fitWidth,
                animation: "Go",
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
