import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';
import 'package:paraworld_gsf_viewer/classes/vertex.dart';
import 'package:vector_math/vector_math.dart';
import 'package:vector_math/vector_math_geometry.dart';
import 'package:vector_math/vector_math_lists.dart';

enum CollisionStructType {
  hit,
  blocker,
}

extension CollisionStructTypeExtension on CollisionStructType {
  static CollisionStructType fromValue(int value) {
    switch (value) {
      case 0:
        return CollisionStructType.hit;
      case 1:
        return CollisionStructType.blocker;
      default:
        throw Exception("Unknown CollisionStructType value: $value");
    }
  }

  int get value {
    switch (this) {
      case CollisionStructType.hit:
        return 0;
      case CollisionStructType.blocker:
        return 1;
    }
  }
}

class PathFinderTable extends GsfPart {
  PathFinderTable({
    required this.count,
    required super.offset,
  });

  final int count;
  final List<CollisionStruct> collisionStructs = [];

  PathFinderTable.fromBytes(Uint8List bytes, int offset, this.count)
      : super(offset: offset) {
    for (var i = 0; i < count; i++) {
      final typeData = Standard4BytesData<int>(
        position: 0,
        bytes: bytes,
        offset: collisionStructs.isNotEmpty
            ? collisionStructs.last.getEndOffset()
            : offset,
      );
      final type = CollisionStructTypeExtension.fromValue(
        typeData.value,
      );
      switch (type) {
        case CollisionStructType.hit:
          collisionStructs.add(HitCollisionStruct.fromBytes(
            bytes,
            typeData.offsettedLength,
          ));
          break;
        case CollisionStructType.blocker:
          collisionStructs.add(BlockerCollisionStruct.fromBytes(
            bytes,
            typeData.offsettedLength,
          ));
          break;
      }
    }
  }
}

typedef CollisionModel = ({
  List<ModelVertex> vertices,
  Uint16List triangles,
  List<ModelVertex>? markers
});

class CollisionStruct extends GsfPart {
  CollisionStruct({
    required this.type,
    required super.offset,
  });

  final CollisionStructType type;

  CollisionModel toModel() {
    throw UnimplementedError();
  }
}

class HitCollisionStruct extends CollisionStruct {
  HitCollisionStruct({
    required super.offset,
  }) : super(type: CollisionStructType.hit);

  late final Standard4BytesData<double> positionX;
  late final Standard4BytesData<double> positionY;
  late final Standard4BytesData<double> positionZ;
  late final Standard4BytesData<double> radius;
  late final Standard4BytesData<int> guid;
  // 4zero bytes
  late final Standard4BytesData<UnknowData> unknownData;

  @override
  String get label =>
      'Hit of radius $radius at $positionX, $positionY, $positionZ, unknownData: $unknownData';

  HitCollisionStruct.fromBytes(Uint8List bytes, int offset)
      : super(offset: offset, type: CollisionStructType.hit) {
    positionX = Standard4BytesData(
      position: 0,
      bytes: bytes,
      offset: offset,
    );
    positionY = Standard4BytesData(
      position: positionX.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    positionZ = Standard4BytesData(
      position: positionY.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    radius = Standard4BytesData(
      position: positionZ.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    guid = Standard4BytesData(
      position: radius.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    unknownData = Standard4BytesData(
      position: guid.relativeEnd + 4, // 4 zero bytes to ignore
      bytes: bytes,
      offset: offset,
    );
  }

  @override
  int getEndOffset() {
    return unknownData.offsettedLength;
  }

  @override
  CollisionModel toModel() {
    final center = Vector3(positionX.value, positionY.value, positionZ.value);
    // defining
    final sphere = SphereGenerator()
      ..createSphere(radius.value, latSegments: 16, lonSegments: 16);
    Uint16List indices = Uint16List(sphere.indexCount);
    Vector3List sphereVertices = Vector3List(sphere.vertexCount);
    sphere.generateIndices(indices);
    sphere.generateVertexPositions(sphereVertices, indices);
    final List<ModelVertex> vertices = [];
    for (var i = 0; i < sphereVertices.length; i++) {
      vertices.add(ModelVertex(sphereVertices[i] + center));
    }
    final markers = <ModelVertex>[
      ModelVertex(center + Vector3(radius.value, 0, 0)),
      ModelVertex(center + Vector3(-radius.value, 0, 0)),
      ModelVertex(center + Vector3(0, radius.value, 0)),
      ModelVertex(center + Vector3(0, -radius.value, 0)),
      ModelVertex(center + Vector3(0, 0, radius.value)),
      ModelVertex(center + Vector3(0, 0, -radius.value)),
    ];
    return (
      vertices: vertices,
      triangles: Uint16List.fromList(indices),
      markers: markers
    );
  }
}

class BlockerCollisionStruct extends CollisionStruct {
  BlockerCollisionStruct({
    required super.offset,
  }) : super(type: CollisionStructType.blocker);

  late final Standard4BytesData<double> positionX;
  late final Standard4BytesData<double> positionY;
  late final Standard4BytesData<double> positionZ;

  late final Standard4BytesData<double> sizeX;
  late final Standard4BytesData<double> sizeY;
  late final Standard4BytesData<double> sizeZ;
  late final Standard4BytesData<UnknowData> unknownData;

  @override
  String get label =>
      'Blocker at $positionX, $positionY, $positionZ with size $sizeX, $sizeY, $sizeZ, unknownData: $unknownData';

  BlockerCollisionStruct.fromBytes(Uint8List bytes, int offset)
      : super(offset: offset, type: CollisionStructType.blocker) {
    positionX = Standard4BytesData(
      position: 0,
      bytes: bytes,
      offset: offset,
    );
    positionY = Standard4BytesData(
      position: positionX.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    positionZ = Standard4BytesData(
      position: positionY.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    sizeX = Standard4BytesData(
      position: positionZ.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    sizeY = Standard4BytesData(
      position: sizeX.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    sizeZ = Standard4BytesData(
      position: sizeY.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    unknownData = Standard4BytesData(
      position: sizeZ.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
  }

  @override
  int getEndOffset() {
    return unknownData.offsettedLength;
  }

  @override
  CollisionModel toModel() {
    final basePoint = Vector3(
        positionX.value, positionY.value, positionZ.value); // back bottom left
    final distX = sizeX.value;
    final distY = sizeY.value;
    final distZ = sizeZ.value;
    final List<ModelVertex> vertices = [
      ModelVertex(basePoint + Vector3(distX, distY, distZ)), // front top right
      ModelVertex(basePoint + Vector3(distX, distY, 0)), // front bottom right
      ModelVertex(basePoint + Vector3(distX, 0, distZ)), // back top right
      ModelVertex(basePoint + Vector3(distX, 0, 0)), // back bottom right
      ModelVertex(basePoint + Vector3(0, distY, distZ)), // front top left
      ModelVertex(basePoint + Vector3(0, distY, 0)), // front bottom left
      ModelVertex(basePoint + Vector3(0, 0, distZ)), // back top left
      ModelVertex(basePoint), // back bottom left
    ];
    final Uint16List triangles = Uint16List.fromList([
      0,
      1,
      2,
      1,
      2,
      3,
      0,
      1,
      4,
      1,
      4,
      5,
      0,
      2,
      4,
      2,
      4,
      6,
      2,
      3,
      6,
      3,
      6,
      7,
      1,
      3,
      5,
      3,
      5,
      7,
      4,
      5,
      6,
      5,
      6,
      7,
    ]);
    return (vertices: vertices, triangles: triangles, markers: null);
  }
}
