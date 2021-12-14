import 'package:flutter/material.dart';
import 'package:snowflakes/model/flakes.dart';


class SnowFlakePainter extends CustomPainter {
  List<SnowFlakes> snowflakes;
  Duration time;

  SnowFlakePainter(this.snowflakes, this.time);

  @override
  void paint(Canvas canvas, Size size) {

    final Paint p = Paint()
      ..color = Colors.white.withAlpha(125)
      ..style = PaintingStyle.fill;

    for (var snowflake in snowflakes) {

      var progress = snowflake.animationProgress!.progress(time);
      final animation = snowflake.tween?.transform(progress);
      final position = Offset(animation["horizontalOffset"] * size.width, animation["verticalOffset"] * size.height);
      canvas.drawPath(snowflake.path.shift(position), p);

    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}