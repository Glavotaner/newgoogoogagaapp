import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:googoogagaapp/ui/components/home/kiss_request_page.dart';
import 'package:googoogagaapp/ui/components/home/swipe_hint.dart';
import 'package:googoogagaapp/ui/components/kiss_selection/kiss_selection.dart';

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
  Widget build(BuildContext context) => Stack(
        children: [
          SwipeHint(page: selectedPage, opacity: opacity),
          PageView(
            controller: pageCtrl,
            scrollDirection: Axis.vertical,
            children: [KissRequestPage(opacity), KissSelectionScreen(opacity)],
          )
        ],
      );

  decreaseOpacity(double page) => setState(() => opacity = (page - 0.5) * 2);

  @override
  void dispose() {
    super.dispose();
    pageCtrl.dispose();
  }

  increaseOpacity(double page) => setState(() => opacity = 1 - (page * 2));

  @override
  void initState() {
    super.initState();
    pageCtrl.addListener(transition);
  }

  transition() {
    switch (pageCtrl.position.userScrollDirection) {
      case ScrollDirection.forward:
        transitionForward(pageCtrl.page!);
        break;
      case ScrollDirection.reverse:
        transitionReverse(pageCtrl.page!);
        break;
      case ScrollDirection.idle:
        break;
    }
  }

  transitionForward(double page) {
    if (page > 0.5) {
      return decreaseOpacity(page);
    }
    selectedPage = 0;
    increaseOpacity(page);
  }

  transitionReverse(double page) {
    if (page < 0.5) {
      return increaseOpacity(page);
    }
    selectedPage = 1;
    decreaseOpacity(page);
  }
}
