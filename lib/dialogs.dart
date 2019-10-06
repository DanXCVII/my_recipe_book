import 'package:flutter/material.dart';
import 'package:my_recipe_book/generated/i18n.dart';

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
          child: Center(
            child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF790604),
                  shape: BoxShape.circle,
                ),
                width: widget.size,
                height: widget.size,
                child: widget.childWidget),
          ),
        ),
      ),
    );
  }
}

class RoundEdgeDialog extends StatefulWidget {
  final String title;
  final Widget bottomSection;

  /// if content is specified, the title and bottomSection
  /// will be ignored and only content is shown
  final Widget content;
  final bool showButtonOk;

  RoundEdgeDialog({
    this.title,
    this.bottomSection,
    this.content,
    this.showButtonOk,
  });

  @override
  State<StatefulWidget> createState() {
    return RoundEdgeDialogState();
  }
}

class RoundEdgeDialogState extends State<RoundEdgeDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  Widget dialogContent(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(22, 22, 22, 16),
      margin: EdgeInsets.only(top: 0),
      decoration: new BoxDecoration(
        color: Theme.of(context).dialogBackgroundColor,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: const Offset(0.0, 10.0),
          ),
        ],
      ),
      child: widget.content != null
          ? widget.content
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // To make the card compact
              children: <Widget>[
                Text(
                  widget.title,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 21),
                ),
                SizedBox(height: 16),
                widget.bottomSection,
                widget.showButtonOk == null || widget.showButtonOk == false
                    ? null
                    : SizedBox(height: 8.0),
                widget.showButtonOk == null || widget.showButtonOk == false
                    ? null
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          FlatButton(
                              child: Text(S.of(context).alright),
                              onPressed: () {
                                Navigator.pop(context);
                              })
                        ],
                      )
              ]..removeWhere((widget) {
                  return widget == null ? true : false;
                }),
            ),
    );
  }
}
