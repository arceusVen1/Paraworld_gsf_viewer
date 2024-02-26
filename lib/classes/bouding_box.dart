import 'dart:math' as math;

import 'package:vector_math/vector_math.dart';

typedef BoxCoordinate = ({double min, double max});

class BoundingBox {
  BoundingBox({
    required this.x,
    required this.y,
    required this.z,
  });

  late BoxCoordinate x;
  late BoxCoordinate y;
  late BoxCoordinate z;

  BoundingBox.zero() {
    x = (min: 0, max: 1);
    y = (min: 0, max: 1);
    z = (min: 0, max: 1);
  }

  double get maxOfCoordinates {
    final xMax = math.max(x.max.abs(), x.min.abs());
    final yMax = math.max(y.max.abs(), y.min.abs());
    final zMax = math.max(z.max.abs(), z.min.abs());
    return math.max(xMax, math.max(yMax, zMax));
  }

  Vector3 get center {
    return Vector3(
      (x.max + x.min) / 2,
      (y.max + y.min) / 2,
      (z.max + z.min) / 2,
    );
  }

  @override
  String toString() {
    return "BoundingBox: x: $x, y: $y, z: $z";
  }

  @override
  bool operator ==(Object other) =>
      other is BoundingBox && other.x == x && other.y == y && other.z == z;

  @override
  int get hashCode => x.hashCode ^ y.hashCode ^ z.hashCode;
}
