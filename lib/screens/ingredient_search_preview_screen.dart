import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:my_recipe_book/blocs/ad_manager/ad_manager_bloc.dart';
import 'package:my_recipe_book/generated/i18n.dart';
import 'package:video_player/video_player.dart';

class IngredinetSearchPreviewScreen extends StatelessWidget {
  const IngredinetSearchPreviewScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.7 * 1.155 >
            MediaQuery.of(context).size.height - kToolbarHeight - 60
        ? MediaQuery.of(context).size.width * 0.7 * 1.155
        : MediaQuery.of(context).size.width * 0.7 * 1.155;
    width > 250 ? width = 250 : width = width;
    double height = width * 1.9;
    print(MediaQuery.of(context).size.width);

    if (MediaQuery.of(context).size.width > 700) {
      width = MediaQuery.of(context).size.width * 0.7;
      height = width * 0.8;
    }

    return Scaffold(
      appBar: GradientAppBar(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomCenter,
          colors: [Color(0xffAF1E1E), Color(0xff641414)],
        ),
        title: Text(I18n.of(context).professional_search),
      ),
      body: Stack(
        children: <Widget>[
          Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height - 145,
              child: Image.asset(
                'images/tableVegetable.jpg',
                fit: BoxFit.cover,
              )),
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black38,
          ),
          Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height -
                                  kToolbarHeight -
                                  70 >
                              height + 60
                          ? MediaQuery.of(context).size.height -
                              kToolbarHeight -
                              70
                          : height + 60,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(
                          child: Container(
                              height: height,
                              width: width,
                              decoration: BoxDecoration(
                                color: Color(0xff161616),
                                borderRadius: BorderRadius.all(Radius.circular(
                                    MediaQuery.of(context).size.width > 700
                                        ? 30
                                        : 40)),
                              ),
                              child: Center(
                                child: Container(
                                    height:
                                        MediaQuery.of(context).size.width > 700
                                            ? height - 20
                                            : height - 80,
                                    width: width - 20,
                                    child: width > 300
                                        ? Image.asset(
                                            "images/tabletIngredientSearch.png")
                                        : VideoPlayerAd()
                                    // Image.asset(
                                    //     "images/ingredient_search_preview.gif"),
                                    ),
                              )),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.green[800],
                    border: Border.all(color: Colors.green[900], width: 2)),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      BlocProvider.of<AdManagerBloc>(context)
                          .add(PurchaseProVersion());
                    },
                    child: Container(
                      child: Center(
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 22.0, right: 22),
                              child: Icon(Icons.shopping_cart,
                                  color: Colors.white),
                            ),
                            Spacer(),
                            Container(
                              width: MediaQuery.of(context).size.width - 107,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(I18n.of(context).buy_pro_version,
                                        style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        )),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Text(
                                      I18n.of(context).pro_version_desc,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Spacer(),
                            Container(
                              width: 35,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class VideoPlayerAd extends StatefulWidget {
  VideoPlayerAd({Key key}) : super(key: key);

  @override
  _VideoPlayerAdState createState() => _VideoPlayerAdState();
}

class _VideoPlayerAdState extends State<VideoPlayerAd> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('images/ingredient_search.mp4')
      ..initialize().then((_) {
        setState(() {
          _controller.setLooping(true);
          _controller.play();
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _controller.value.initialized
          ? AspectRatio(
              aspectRatio: 16 / 9,
              child: VideoPlayer(_controller),
            )
          : Container(),
    );
  }
}
