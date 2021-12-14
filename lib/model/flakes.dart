import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:snowflakes/helpers/animation_helpers/positions.dart';
import 'package:snowflakes/helpers/animation_helpers/progress.dart';
import 'package:snowflakes/helpers/animation_helpers/tween.dart';


class SnowFlakes {

  static Map<int, Path> cachedFlakes = {};

  Animatable? tween;
  double? size;
  AnimationProgress? animationProgress;
  math.Random? random;
  Path? _path;

  SnowFlakes(this.random) {
    loop();
  }

  void loop({Duration time = Duration.zero}) {
    _path = null;
    final startPosition = Offset(-0.2 + 1.4 * random!.nextDouble(), -0.2);
    final endPosition = Offset(-0.2 + 1.4 * random!.nextDouble(), 1.2);
    final duration = Duration(seconds: 5, milliseconds: random!.nextInt(10000));

    tween = MultiTrackTween([
      Track("horizontalOffset").add(
          duration, Tween(begin: startPosition.dx, end: endPosition.dx),
          curve: Curves.easeInOutSine),
      Track("verticalOffset").add(
          duration, Tween(begin: startPosition.dy, end: endPosition.dy),
          curve: Curves.easeIn),
    ]);

    animationProgress = AnimationProgress(duration: duration, startTime: time);
    size = 20 + random!.nextDouble() * 100;
    drawPath();
  }

  void drawPath() {
    if(_path != null) {
      return;
    }
    double sideLength = 100;

    int iterationsTotal = 1;
    // we calculate the total number of iterations
    // based on the snowflake's size
    if(size! > 40) {
      iterationsTotal += (size!) ~/ 25;
    }
    _path = Path();
    if(cachedFlakes[iterationsTotal] == null) {
      double down = (sideLength/2) * math.tan(math.pi/6);
      double up = (sideLength/2) * math.tan(math.pi/3) - down;
      SnowFlakePosition p1 = SnowFlakePosition(-sideLength/2,down);
      SnowFlakePosition p2 = SnowFlakePosition(sideLength/2,down);
      SnowFlakePosition p3 = SnowFlakePosition(0,-up);
      SnowFlakePosition p4 = SnowFlakePosition(0,0);
      SnowFlakePosition p5 = SnowFlakePosition(0,0);
      double rot = random!.nextDouble() * 6.28319;
      List<SnowFlakePosition> lines = <SnowFlakePosition>[p1, p2, p3];
      List<SnowFlakePosition> tmpLines = <SnowFlakePosition>[];

      for(int iterations=0; iterations<iterationsTotal; iterations++){
        sideLength /= 3;
        for(int loop = 0; loop < lines.length; loop++){
          p1 = lines[loop];
          if(loop == lines.length-1) {
            p2 = lines[0];
          } else {
            p2 = lines[loop+1];
          }
          rot = math.atan2(p2.y - p1.y, p2.x - p1.x);
          p3 = p1 + SnowFlakePosition.polar(sideLength,rot);
          rot += math.pi/3;
          p4 = p3 + SnowFlakePosition.polar(sideLength,rot);
          rot -= 2 * math.pi/3;
          p5 = p4 + SnowFlakePosition.polar(sideLength,rot);
          tmpLines.add(p1);
          tmpLines.add(p3);
          tmpLines.add(p4);
          tmpLines.add(p5);
        }
        lines = tmpLines;
        tmpLines = <SnowFlakePosition>[];
      }
      lines.add(p2);
      _path?.moveTo((lines[0].x).toDouble(),(lines[0].y).toDouble());
      for(int a=0; a<lines.length; a++){
        _path?.lineTo((lines[a].x).toDouble(),(lines[a].y).toDouble());
      }
      _path?.lineTo((lines[0].x).toDouble(),(lines[0].y).toDouble());
      cachedFlakes[iterationsTotal] = _path!;
    } else {
      _path = cachedFlakes[iterationsTotal];
    }
    Matrix4 m = Matrix4.identity();
    // the rotation must be in radians
    // and to get a random angle we use the 360 equivalent
    // in radians that is 6.28319
    m.setRotationZ(random!.nextDouble() * 6.28319);
    num scaleTo = size! / sideLength;
    m.scale(scaleTo);
    List<double> list = m.storage.toList();
    _path = _path!.transform(Float64List.fromList(list));
  }

  Path get path {
    if(_path != null) {
      return _path!;
    }
    drawPath();
    return _path!;
  }

  void maintainRestart(Duration time) {
    if (animationProgress!.progress(time) == 1.0) {
      loop(time: time);
    }
  }

  static List<SnowFlakes> getFlakesToDisplay({int flakesAmount = 20}) {
    final math.Random random = math.Random();
    List<SnowFlakes> snowFlakesList = [];
    List.generate(flakesAmount, (index) {
      snowFlakesList.add(SnowFlakes(random));
    });
    return snowFlakesList;
  }


}


