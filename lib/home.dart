import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned.fill(
              child: MirrorAnimation<Color?>(
                tween: ColorTween(begin: Colors.lightBlueAccent.shade200, end: Colors.lightBlue.shade500),
                duration: const Duration(seconds: 3),
                curve: Curves.easeInOut,
                builder: (context, child, value) {
                  return Container(
                    color: value
                  );
                },
              )
          ),

        ],
      ),
    );
  }
}

