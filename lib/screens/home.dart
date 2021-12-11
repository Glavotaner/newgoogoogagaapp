import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:googoogagaapp/components/home/request_input.dart';
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
    // TODO: implement initState
    super.initState();
    pageCtrl.addListener(() {
      final direction = pageCtrl.position.userScrollDirection;
      double page = pageCtrl.page!;
      if (direction == ScrollDirection.reverse) {
        if (page > 0.33 && page < 0.70) {
          _setOpacity(0.0);
        } else if (page > 0.75) {
          _setOpacity(1.0);
        }
      } else if (direction == ScrollDirection.forward) {
        if (page == 0.51) {
          _setOpacity(0.0);
        } else if (page < 0.25) {
          _setOpacity(1.0);
        }
      }
    });
  }

  _setOpacity(double value) {
    setState(() {
      opacity = value;
    });
  }

  @override
  Widget build(BuildContext context) => PageView(
        controller: pageCtrl,
        scrollDirection: Axis.vertical,
        children: [HomePage(opacity), KissSelectionScreen(opacity)],
      );
}

class HomePage extends StatelessWidget {
  final double opacity;
  const HomePage(this.opacity, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: AnimatedOpacity(
                    duration: Duration(milliseconds: 300),
                    opacity: opacity,
                    child: Image(image: AssetImage('assets/request.png'))),
              ),
            ),
            KissRequest(),
          ],
        ));
  }
}
