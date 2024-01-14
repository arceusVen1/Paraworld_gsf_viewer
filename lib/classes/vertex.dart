import 'package:equatable/equatable.dart';
import 'package:vector_math/vector_math_64.dart';

class Vertex extends Equatable {
  const Vertex({
    required this.positions,
  });

  final Vector3 positions;

  // flutter projection is going top down so we need to invert y axis to match direct3D
  Vector2 project({
    required double widthOffset,
    required double heightOffset,
    required double maxWidth,
    required double maxHeight,
    double xRotation = 0,
    double yRotation = 0,
    double zRotation = 0,
  }) {
    final T = Matrix4.rotationX(xRotation)
      ..rotateY(yRotation)
      ..rotateZ(zRotation);
    final rotated = T.transform3(Vector3.copy(positions));
    return Vector2(
      rotated.x * maxWidth + widthOffset,
      -rotated.y * maxHeight + heightOffset,
    );
  }

  @override
  List<Object> get props => [positions.x, positions.y, positions.z];
}
