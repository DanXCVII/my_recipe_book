import 'package:flutter/material.dart';
import '../../my_wrapper.dart';

class ComplexitySection extends StatefulWidget {
  final MyDoubleWrapper complexity;

  ComplexitySection({this.complexity});

  @override
  State createState() => ComplexitySectionState();
}

class ComplexitySectionState extends State<ComplexitySection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(right: 12, top: 12, left: 56, bottom: 12),
          child: Text(
            "complexity/effort:",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 24, right: 24),
          child: Slider(
            label: "${widget.complexity.myDouble.toString()}",
            onChanged: (value) {
              setState(() {
                widget.complexity.myDouble = value;
              });
            },
            value: widget.complexity.myDouble,
            divisions: 9,
            min: 1,
            max: 10,
          ),
        )
      ],
    );
  }
}
