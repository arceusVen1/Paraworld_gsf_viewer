import 'dart:math' as math;

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

  getMaxOfCoordinates() {
    final xMax = math.max(x.max.abs(), x.min.abs());
    final yMax = math.max(y.max.abs(), y.min.abs());
    final zMax = math.max(z.max.abs(), z.min.abs());
    return math.max(xMax, math.max(yMax, zMax));
  }
}
