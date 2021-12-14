import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

import 'helpers/animation_helpers.dart';


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
          // Positioned.fill(
          //     child: MirrorAnimation<Color?>(
          //       tween: ColorTween(begin: Colors.purple, end: Colors.lightBlue.shade500),
          //       duration: const Duration(seconds: 3),
          //       curve: Curves.easeInOut,
          //       builder: (context, child, value) {
          //         return Container(
          //             color: value
          //         );
          //       },
          //     )
          // ),
          Positioned.fill(
              child: MirrorAnimation(
                tween: MultiTrackTween([
                  Track("color1").add(const Duration(seconds: 3),
                      ColorTween(begin: Colors.red.shade600, end: Colors.green.shade900)),
                  Track("color2").add(const Duration(seconds: 3),
                      ColorTween(begin: Colors.lightBlue.shade900, end: Colors.blue.shade600))
                ]),
                duration: const Duration(seconds: 3),
                curve: Curves.easeInOut,
                builder: (context, child, value) {
                  Map<String, dynamic> g = value as Map<String, dynamic>;
                  return Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [value["color1"], value["color2"]])
                    )
                  );
                },
              )
          ),
        ],
      ),
    );
  }
}

