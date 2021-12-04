import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) => PageView(
        scrollDirection: Axis.vertical,
        children: [HomePage(), KissSelectionScreen()],
      );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
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
                child: Image(image: AssetImage('assets/request.png')),
              ),
            ),
            KissRequest(),
          ],
        ));
  }
}
