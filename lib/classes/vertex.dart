import 'package:paraworld_gsf_viewer/classes/bouding_box.dart';
import 'package:paraworld_gsf_viewer/test.dart';
import 'package:vector_math/vector_math.dart';

const _k13BytesRatioValue = 1 / 8191;

class Vertex {
  Vertex(
    this.positions, {
    required this.box,
    this.normal,
    this.textureCoordinates,
  }) {
    positions.x = positions.x * (box.x.max - box.x.min) + box.x.min;
    positions.y = positions.y * (box.y.max - box.y.min) + box.y.min;
    positions.z = positions.z * (box.z.max - box.z.min) + box.z.min;
  }

  late Vector3 positions;
  late BoundingBox box;
  Vector2? textureCoordinates;
  Vertex? normal;
  int? _normalSphereIndice;

  // Because web compiles int as int32 we need to force big int for 64bit integers even in web
  Vertex.fromModelBytes(BigInt sequence, int textureSequence, BoundingBox bb) {
    box = bb;
    positions = Vector3(
      ((_k13BytesRatioValue * (sequence.toInt() & 0x1FFF)) *
              (box.x.max - box.x.min) +
          box.x.min),
      (_k13BytesRatioValue * ((sequence >> 13).toInt() & 0x1FFF)) *
              (box.y.max - box.y.min) +
          box.y.min,
      (_k13BytesRatioValue * ((sequence >> 26).toInt() & 0x1FFF)) *
              (box.z.max - box.z.min) +
          box.z.min,
    );

    _normalSphereIndice = (sequence >> 40).toInt() & 0xFF;
    final sphereCoef = (sequence >> 39).toInt() & 0x1;

    normal = Vertex(
      readFromSphere(256 * sphereCoef + _normalSphereIndice!),
      box: BoundingBox.zero(),
    );

    normal!.positions += positions;

    textureCoordinates = Vector2(
        ((textureSequence >> 0) & 0xFF).toDouble() / 256,
        ((textureSequence >> 8) & 0xFF).toDouble() / 256);
  }

  Vector3 transform({
    double xRotation = 0,
    double yRotation = 0,
    double zRotation = 0,
  }) {
    final copy = Vector3.copy(positions);
    copy.applyMatrix3(
      Matrix3.rotationZ(xRotation) *
          Matrix3.rotationY(yRotation) *
          Matrix3.rotationZ(zRotation),
    );
    return copy;
  }

  // flutter projection is going top down so we need to invert y axis to match direct3D
  ({Vector2 pointProjection, Vector2? normalProjection}) project({
    required double widthOffset,
    required double heightOffset,
    required double maxWidth,
    required double maxHeight,
    double xRotation = 0,
    double yRotation = 0,
    double zRotation = 0,
  }) {
    final transformedPoint = transform(
      xRotation: xRotation,
      yRotation: yRotation,
      zRotation: zRotation,
    );
    double perpectiveFactor = 1.0;

    return (
      pointProjection: Vector2(
        transformedPoint.x * maxWidth * perpectiveFactor + widthOffset,
        -transformedPoint.y * maxHeight * perpectiveFactor + heightOffset,
      ),
      normalProjection: normal != null
          ? normal!
              .project(
                widthOffset: widthOffset,
                heightOffset: heightOffset,
                maxWidth: maxWidth,
                maxHeight: maxHeight,
                xRotation: xRotation,
                yRotation: yRotation,
                zRotation: zRotation,
              )
              .pointProjection
          : null,
    );
  }

  (String, String, String) toObj() {
    return (
      "v ${-positions.x} ${positions.y} ${-positions.z} 1.0",
      "vn ${(-(normal?.positions.x ?? 0)).toStringAsFixed(3)} ${(normal?.positions.y ?? 0).toStringAsFixed(3)} ${(-(normal?.positions.z ?? 0)).toStringAsFixed(3)}",
      "vt ${textureCoordinates?.x ?? 0} ${(textureCoordinates?.y ?? 0)}"
    );
  }

  @override
  String toString() {
    String string = "Pos: ${positions.toString()}";
    if (_normalSphereIndice != null) {
      string += ", normal: $_normalSphereIndice";
    }
    return string;
  }

  @override
  bool operator ==(Object other) =>
      other is Vertex &&
      (positions == other.positions && other.normal == normal);

  @override
  int get hashCode => positions.hashCode; // todo
}
