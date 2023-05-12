import 'package:flutter/material.dart';

class GradientAppBarRun extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // returning MaterialApp
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home:
          // scaffold
          Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            // sliverappbar for gradient widget
            SliverAppBar(
              pinned: true,
              expandedHeight: 50,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  // LinearGradient
                  gradient: LinearGradient(
                    // colors for gradient
                    colors: [
                      Colors.deepPurpleAccent,
                      Colors.yellowAccent,
                    ],
                  ),
                ),
              ),
              // title of appbar
              title: Text("Gradient AppBar!"),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  // Body Element
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
