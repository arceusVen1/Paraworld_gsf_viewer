import 'package:vector_math/vector_math.dart';

class Rotation {
  Rotation(): matrix = Matrix3.zero();

  Matrix3 matrix;

  void setMatrix(
    double xRotation,
    double yRotation,
    double zRotation,
  ) {
    matrix = Matrix3.rotationZ(xRotation) *
        Matrix3.rotationY(yRotation) *
        Matrix3.rotationZ(zRotation);
  }

  @override
  String toString() {
    return matrix.toString();
  }

  @override
  bool operator ==(Object other) =>
      other is Rotation && other.matrix == matrix;
  
  @override
  int get hashCode => matrix.hashCode;
}
