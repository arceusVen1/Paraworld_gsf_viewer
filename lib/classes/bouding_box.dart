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
}
