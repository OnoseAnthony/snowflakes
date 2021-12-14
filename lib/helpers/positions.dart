import 'dart:math' as math;

class SnowFlakePosition  {

  num x = 0;
  num y = 0;

  SnowFlakePosition([this.x=0, this.y=0]);

  SnowFlakePosition add(SnowFlakePosition p) {
    return SnowFlakePosition(x + p.x, y + p.y);
  }

  SnowFlakePosition clone() {
    return SnowFlakePosition(x, y);
  }

  num degreesTo(SnowFlakePosition p) {
    num dx = x = p.x;
    num dy = y = p.y;
    num angle = math.atan2(dy, dx); // radians
    return angle * (180 / math.pi); // degrees
  }

  num _distance(SnowFlakePosition p) {
    num x = this.x - p.x;
    num y = this.y - p.y;
    return math.sqrt(x * x + y * y);
  }

  bool equals(SnowFlakePosition p) {
    return x == p.x && y == p.y;
  }

  /// find point between points
  SnowFlakePosition _interpolate(SnowFlakePosition p, num f) {
    return SnowFlakePosition( p.x + (x - p.x) * f, p.y + (y - p.y) * f );
  }

  num length() {
    return math.sqrt(x * x + y * y);
  }

  void normalize(num thickness) {
    num l = length();
    x = x / l * thickness;
    y = y / l * thickness;
  }

  void orbit(SnowFlakePosition origin, num arcWidth, num arcHeight, num degrees) {
    num radians = degrees * (math.pi / 180);
    x = origin.x + arcWidth * math.cos(radians);
    y = origin.y + arcHeight * math.sin(radians);
  }

  void offset(num dx, num dy) {
    x += dx;
    y += dy;
  }

  SnowFlakePosition subtract(SnowFlakePosition p) {
    return SnowFlakePosition(x - p.x, y - p.y);
  }

  @override
  String toString() {
    return '(x=$x, y=$y)';
  }

  static SnowFlakePosition pointsInterpolation(SnowFlakePosition p1, SnowFlakePosition p2, num f) {
    return p1._interpolate(p2, f);
  }
  static SnowFlakePosition polar(num l, num r) {
    return SnowFlakePosition(l * math.cos(r), l * math.sin(r));
  }
  static num distance(SnowFlakePosition p1, SnowFlakePosition p2) {
    return p1._distance(p2);
  }

  SnowFlakePosition operator +(SnowFlakePosition p) => SnowFlakePosition(x+p.x, y+p.y);

  @override
  bool operator == (Object other) => hashCode == other.hashCode;

  @override
  int get hashCode => x.hashCode + y.hashCode;

}