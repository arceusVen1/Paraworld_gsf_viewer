import 'package:paraworld_gsf_viewer/classes/rotation.dart';
import 'package:paraworld_gsf_viewer/classes/vertex.dart';
import 'package:vector_math/vector_math.dart';

class ModelTriangle {
  ModelTriangle({
    required this.points,
    required this.indices,
  }) {
    assert(points.length == indices.length && points.length == 3);
  }

  final List<ModelVertex> points;
  final List<int> indices;

  bool shouldShowTriangle(Transformation transformation) {
    final p0 = points[0].transform(transformation);
    final p1 = points[1].transform(transformation);
    final p2 = points[2].transform(transformation);
    final normal = (p1 - p0).cross(p2 - p0);

    // we place our eye at center far from camera, hence -100 in z
    return normal.dot(p0 - Vector3(0, 0, -100)) <= 0;
  }

  String toObj(int offset) {
    return "f ${indices[0] + 1 + offset}/${indices[0] + 1 + offset}/${indices[0] + 1 + offset} ${indices[1] + 1 + offset}/${indices[1] + 1 + offset}/${indices[1] + 1 + offset} ${indices[2] + 1 + offset}/${indices[2] + 1 + offset}/${indices[2] + 1 + offset}\n";
  }

  ModelTriangle copy(int indicesOdffset) {
    return ModelTriangle(
      points: List<ModelVertex>.from(points),
      indices: indices.map((e) => e + indicesOdffset).toList(),
    );
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
