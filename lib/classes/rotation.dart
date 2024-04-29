import 'package:vector_math/vector_math.dart';

class Rotation {
  Rotation() : quaternion = Quaternion.identity();

  Quaternion quaternion;

  void setQuaternion(
    double xRotation,
    double yRotation,
    double zRotation,
  ) {
    quaternion = Quaternion.euler(zRotation, xRotation, yRotation);
  }

  @override
  String toString() {
    return quaternion.toString();
  }

  @override
  bool operator ==(Object other) =>
      other is Rotation && other.quaternion == quaternion;

  @override
  int get hashCode => quaternion.hashCode;
}
