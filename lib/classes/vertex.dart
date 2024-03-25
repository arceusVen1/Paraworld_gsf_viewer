import 'package:paraworld_gsf_viewer/classes/bouding_box.dart';
import 'package:paraworld_gsf_viewer/classes/rotation.dart';
import 'package:paraworld_gsf_viewer/test.dart';
import 'package:vector_math/vector_math.dart';

const _k13BytesRatioValue = 1 / 8191;

class ModelVertex {
  ModelVertex(
    this.positions, {
    required this.box,
    required this.positionOffset,
    this.normal,
    this.textureCoordinates,
  }) {
    positions.x = positions.x * (box.x.max - box.x.min) + box.x.min;
    positions.y = positions.y * (box.y.max - box.y.min) + box.y.min;
    positions.z = positions.z * (box.z.max - box.z.min) + box.z.min;
  }

  late Vector3 positions;
  late final Vector3 positionOffset;
  (Vector3, Matrix3)? lastTransformation;
  late final BoundingBoxModel box;
  Vector2? textureCoordinates;
  ModelVertex? normal;
  int? _normalSphereIndice;

  // Because web compiles int as int32 we need to force big int for 64bit integers even in web
  ModelVertex.fromModelBytes(BigInt sequence, int textureSequence,
      BoundingBoxModel box, Matrix4? matrix,
      [bool centerInWindow = false]) {
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
    positions.applyMatrix4(matrix ?? Matrix4.identity());
    this.box = box.toParaworldSystem();

    if (centerInWindow) {
      positionOffset = this.box.center;
    } else {
      positionOffset = Vector3.zero();
    }

    _normalSphereIndice = (sequence >> 40).toInt() & 0xFF;
    final sphereCoef = (sequence >> 39).toInt() & 0x1;

    normal = ModelVertex(
      readFromSphere(256 * sphereCoef + _normalSphereIndice!),
      box: BoundingBoxModel.zero(),
      positionOffset: positionOffset,
    );

    normal!.positions += positions;

    textureCoordinates = Vector2(
        ((textureSequence >> 0) & 0xFF).toDouble() / 256,
        ((textureSequence >> 8) & 0xFF).toDouble() / 256);
  }

  Vector3 transform(Rotation rotation) {
    if (lastTransformation != null &&
        lastTransformation!.$2 == rotation.matrix) {
      return lastTransformation!.$1;
    }
    Vector3 copy = Vector3.copy(positions);
    // converting to paraworld coordinate system
    copy.y = copy.z;
    copy.z = -positions.y;
    // centering on window
    copy -= positionOffset;
    copy.applyMatrix3(rotation.matrix);
    return copy;
  }

  // flutter projection is going top down so we need to invert y axis to match direct3D
  ({Vector2 pointProjection, Vector2? normalProjection}) project({
    required double widthOffset,
    required double heightOffset,
    required double maxWidth,
    required double maxHeight,
    required Rotation rotation,
  }) {
    final transformedPoint = transform(rotation);
    lastTransformation = (transformedPoint, rotation.matrix);

    double perpectiveFactor = 1.0;

    return (
      pointProjection: Vector2(
        transformedPoint.x * maxWidth * perpectiveFactor + widthOffset,
        -transformedPoint.y * maxHeight * perpectiveFactor + heightOffset,
      ),
      normalProjection: normal
          ?.project(
            widthOffset: widthOffset,
            heightOffset: heightOffset,
            maxWidth: maxWidth,
            maxHeight: maxHeight,
            rotation: rotation,
          )
          .pointProjection
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
      other is ModelVertex &&
      (positions == other.positions && other.normal == normal);

  @override
  int get hashCode => positions.hashCode; // todo
}
