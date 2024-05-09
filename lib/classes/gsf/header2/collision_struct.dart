import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';
import 'package:paraworld_gsf_viewer/classes/triangle.dart';
import 'package:paraworld_gsf_viewer/classes/vertex.dart';
import 'package:vector_math/vector_math.dart';

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
  List<ModelTriangle> triangles
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
      'Hit of radius $radius at $positionX, $positionY, $positionZ';

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
    return (triangles: [], vertices: []);
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
    final center = Vector3(positionX.value, positionY.value, positionZ.value);
    final distX = sizeX.value / 2;
    final distY = sizeY.value / 2;
    final distZ = sizeZ.value / 2;
    final List<ModelVertex> vertices = [
      ModelVertex(center + Vector3(distX, distY, distZ)), // front top right
      ModelVertex(center + Vector3(distX, distY, -distZ)), // front bottom right
      ModelVertex(center + Vector3(distX, -distY, distZ)), // back top right
      ModelVertex(center + Vector3(distX, -distY, -distZ)), // back bottom right
      ModelVertex(center + Vector3(-distX, distY, distZ)), // front top left
      ModelVertex(center + Vector3(-distX, distY, -distZ)), // front bottom left
      ModelVertex(center + Vector3(-distX, -distY, distZ)), // back top left
      ModelVertex(center + Vector3(-distX, -distY, -distZ)), // back bottom left
    ];
    final List<ModelTriangle> triangles = [
      ModelTriangle(
          points: [vertices[0], vertices[1], vertices[2]], indices: [0, 1, 2]),
      ModelTriangle(
          points: [vertices[1], vertices[2], vertices[3]], indices: [1, 2, 3]),
      ModelTriangle(
          points: [vertices[0], vertices[1], vertices[4]], indices: [0, 1, 4]),
      ModelTriangle(
          points: [vertices[1], vertices[4], vertices[5]], indices: [1, 4, 5]),
      ModelTriangle(
          points: [vertices[0], vertices[2], vertices[4]], indices: [0, 2, 4]),
      ModelTriangle(
          points: [vertices[2], vertices[4], vertices[6]], indices: [2, 4, 6]),
      ModelTriangle(
          points: [vertices[2], vertices[3], vertices[6]], indices: [2, 3, 6]),
      ModelTriangle(
          points: [vertices[3], vertices[6], vertices[7]], indices: [3, 6, 7]),
      ModelTriangle(
          points: [vertices[1], vertices[3], vertices[5]], indices: [1, 3, 5]),
      ModelTriangle(
          points: [vertices[3], vertices[5], vertices[7]], indices: [3, 5, 7]),
      ModelTriangle(
          points: [vertices[4], vertices[5], vertices[6]], indices: [4, 5, 6]),
      ModelTriangle(
          points: [vertices[5], vertices[6], vertices[7]], indices: [5, 6, 7]),
    ];
    return (vertices: vertices, triangles: triangles);
  }
}
