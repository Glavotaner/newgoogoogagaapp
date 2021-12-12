import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:googoogagaapp/components/home/request_input.dart';
import 'package:googoogagaapp/components/home/swipe_hint.dart';
import 'package:googoogagaapp/components/kiss_selection/kiss_selection.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedPage = 0;
  double opacity = 1.0;
  PageController pageCtrl = PageController();

  @override
  void initState() {
    super.initState();
    pageCtrl.addListener(() {
      ScrollDirection direction = pageCtrl.position.userScrollDirection;
      if (direction == ScrollDirection.forward) {
        _handleForward(pageCtrl.page!);
      } else if (direction == ScrollDirection.reverse) {
        _handleReverse(pageCtrl.page!);
      }
    });
  }

  _handleForward(double page) {
    if (page < 0.1 && opacity == 0.0) {
      selectedPage = 0;
      return _setOpacity(1.0);
    } else if (page < 0.9 && page > 0.1 && opacity == 1.0) {
      _setOpacity(0.0);
    }
  }

  _handleReverse(double page) {
    if (opacity == 1.0 && page > 0.1 && page < 0.9) {
      return _setOpacity(0.0);
    } else if (opacity == 0.0 && page > 0.9) {
      selectedPage = 1;
      _setOpacity(1.0);
    }
  }

  _setOpacity(double value) => setState(() => opacity = value);

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          AnimatedAlign(
            alignment: selectedPage == 0
                ? Alignment.bottomCenter
                : Alignment.topCenter,
            duration: Duration(milliseconds: 50),
            child: AnimatedOpacity(
                opacity: opacity,
                duration: Duration(milliseconds: 250),
                child: SwipeHint(page: selectedPage)),
          ),
          PageView(
            controller: pageCtrl,
            scrollDirection: Axis.vertical,
            children: [HomePage(opacity), KissSelectionScreen(opacity)],
          )
        ],
      );
}

class HomePage extends StatelessWidget {
  final double opacity;
  const HomePage(this.opacity, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: opacity,
      duration: Duration(milliseconds: 500),
      child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Image(image: AssetImage('assets/request.png')),
                ),
              ),
              KissRequest(),
            ],
          )),
    );
  }
}
