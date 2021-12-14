import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:snowflakes/helpers/animation_helpers/flake_painter.dart';
import 'package:snowflakes/helpers/animation_helpers/flakes_renderer.dart';
import 'package:snowflakes/helpers/animation_helpers/tween.dart';
import 'package:snowflakes/model/flakes.dart';



class SnowStorm extends StatefulWidget {
  const SnowStorm({Key? key}) : super(key: key);

  @override
  _SnowStormState createState() => _SnowStormState();
}

class _SnowStormState extends State<SnowStorm> {
  final List<SnowFlakes> flakes = [];

  @override
  void initState() {
    flakes.addAll(SnowFlakes.getFlakesToDisplay(flakesAmount: 10));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[

          Positioned.fill(
              child: MirrorAnimation(
                tween: MultiTrackTween([
                  Track("primaryColor").add(const Duration(seconds: 3),
                      ColorTween(begin: Colors.red.shade600, end: Colors.green.shade900)),
                  Track("secondaryColor").add(const Duration(seconds: 3),
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
                            colors: [value["primaryColor"], value["secondaryColor"]])
                    )
                  );
                },
              )
          ),

          Positioned.fill(
              child: SnowFlakeRenderer(
                startTime: const Duration(seconds: 30),
                builder: (context, time) {
                  render(time);
                  return CustomPaint(
                    painter: SnowFlakePainter(flakes, time),
                  );
                },
              )
          ),
        ],
      ),
    );
  }

  render(Duration duration){
    for (var flake in flakes) {
      flake.maintainRestart(duration);
    }
  }
}

