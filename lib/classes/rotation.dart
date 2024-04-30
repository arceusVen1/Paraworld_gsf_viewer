import 'package:vector_math/vector_math.dart';

class Transformation {
  Transformation();

  Quaternion quaternion = Quaternion.identity();
  double scaleFactor = 1;
  Matrix4 matrix = Matrix4.identity();

  void setQuaternion(
    double xRotation,
    double yRotation,
    double zRotation,
  ) {
    //weird case if we use quaternion.rotate we don't need to invert angles,
    //but when using matrix apply it's necessary
    quaternion = Quaternion.euler(-zRotation, -xRotation, yRotation);
  }

  void composeMatrix() {
    matrix = Matrix4.compose(Vector3.zero(), quaternion, Vector3.all(scaleFactor));
  }

  @override
  String toString() {
    return quaternion.toString();
  }

  @override
  bool operator ==(Object other) =>
      other is Transformation && other.quaternion == quaternion && other.scaleFactor == scaleFactor;

  @override
  int get hashCode => quaternion.hashCode;
}
