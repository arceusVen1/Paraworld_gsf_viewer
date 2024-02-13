import 'package:paraworld_gsf_viewer/classes/vertex.dart';
import 'package:vector_math/vector_math.dart';

class ModelTriangle {
  ModelTriangle({
    required this.points,
    required this.indices,
  }) {
    assert(points.length == indices.length && points.length == 3);
  }

  final List<Vertex> points;
  final List<int> indices;

  bool shouldShowTriangle({
    double xRotation = 0,
    double yRotation = 0,
    double zRotation = 0,
  }) {
    final p0 = points[0].transform(
        xRotation: xRotation, yRotation: yRotation, zRotation: zRotation);
    final p1 = points[1].transform(
        xRotation: xRotation, yRotation: yRotation, zRotation: zRotation);
    final p2 = points[2].transform(
        xRotation: xRotation, yRotation: yRotation, zRotation: zRotation);
    final normal = (p1 - p0).cross(p2 - p0);

    // we place our eye at center far from camera, hence -100 in z
    return normal.dot(p0 - Vector3(0, 0, -100)) <= 0;
  }

  String toObj() {
    return "f ${indices[0] + 1}/${indices[0] + 1}/${indices[0] + 1} ${indices[1] + 1}/${indices[1] + 1}/${indices[1] + 1} ${indices[2] + 1}/${indices[2] + 1}/${indices[2] + 1}\n";
  }

  @override
  String toString() {
    return indices.toString();
  }

  @override
  bool operator ==(Object other) =>
      other is ModelTriangle &&
      other.indices[0] == indices[0] &&
      other.indices[1] == indices[1] &&
      other.indices[2] == indices[2];

  @override
  int get hashCode => indices.hashCode;
}
