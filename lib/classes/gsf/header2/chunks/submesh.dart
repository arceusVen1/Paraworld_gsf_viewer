import 'package:flutter/foundation.dart';
import 'package:paraworld_gsf_viewer/classes/bouding_box.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/bounding_box.dart';
import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';
import 'package:paraworld_gsf_viewer/classes/triangle.dart';
import 'package:paraworld_gsf_viewer/classes/vertex.dart';

class Submesh extends GsfPart {
  late final BoundingBox boundingBox;
  late final Standard4BytesData<int> vertexCount;
  late final Standard4BytesData<int> triangleCount;
  late final Standard4BytesData<int> vertexOffset;
  late final Standard4BytesData<int> triangleOffset;
  late final Standard4BytesData<int> triangleCount2;
  late final Standard4BytesData<int> vertexType;
  late final Standard4BytesData<int> lightDataOffset;
  late final Standard4BytesData<int> lightDataCount;
  late final List<Vertex> vertices;
  late final List<Triangle> triangles;

  @override
  String get label => "Submesh with ${triangleCount.value} triangles";

  Submesh.fromBytes(Uint8List bytes, int offset) : super(offset: offset) {
    boundingBox = BoundingBox.fromBytes(
      bytes,
      offset,
    );
    vertexCount = Standard4BytesData(
      position: boundingBox.length,
      bytes: bytes,
      offset: offset,
    );
    triangleCount = Standard4BytesData(
      position: vertexCount.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    vertexOffset = Standard4BytesData(
      position: triangleCount.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    triangleOffset = Standard4BytesData(
      position: vertexOffset.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    triangleCount2 = Standard4BytesData(
      position: triangleOffset.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    vertexType = Standard4BytesData(
      position: triangleCount2.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    lightDataOffset = Standard4BytesData(
      position: vertexType.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    lightDataCount = Standard4BytesData(
      position: lightDataOffset.relativeEnd,
      bytes: bytes,
      offset: offset,
    );

    vertices = [];
    for (int i = 0; i < vertexCount.value; i++) {
      final vertex = Vertex.fromBytes(
        bytes,
        offset +
            vertexOffset.relativePos +
            vertexOffset.value +
            i * vertexType.value,
        vertexType.value,
      );
      vertices.add(vertex);
    }

    triangles = [];
    for (int i = 0; i < triangleCount.value; i++) {
      final triangle = Triangle.fromBytes(
        bytes,
        triangles.isEmpty
            ? offset + triangleOffset.relativePos + triangleOffset.value
            : triangles.last.getEndOffset(),
      );
      triangles.add(triangle);
    }
  }

  /// Returns the model submesh data that can be offsetted to be used in a global model
  ({
    List<ModelVertex> vertices,
    List<ModelTriangle> triangles,
    BoundingBoxModel box
  }) getMeshModelData(int indicesOffset, BoundingBoxModel? globalBB) {
    final box = globalBB ?? boundingBox.toModelBox();
    final vertices = this.vertices.map((e) => e.toModelVertex(box)).toList();
    final triangles = this
        .triangles
        .map((e) => e.toModelTriangle(vertices, indicesOffset))
        .toList();
    return (
      vertices: vertices,
      triangles: triangles,
      box: box,
    );
  }

  @override
  int getEndOffset() {
    return lightDataCount.offsettedLength;
  }
}

class Vertex extends GsfPart {
  late final GsfData<Uint8List> vertexData;

  @override
  String get label => "Vertex of size ${vertexData.length}";

  Vertex.fromBytes(Uint8List bytes, int offset, int size)
      : super(offset: offset) {
    vertexData = GsfData.fromPosition(
      relativePos: 0,
      bytes: bytes,
      offset: offset,
      length: size,
    );
  }

  ModelVertex toModelVertex(BoundingBoxModel box) {
    // necessary hack because web doesn't handle getUint64
    BigInt positionData = BigInt.from(0);
    if (kIsWeb) {
      positionData = BigInt.from(int.parse(
          vertexData.value
              .sublist(0, 6)
              .reversed
              .map((e) => e.toRadixString(16).length >= 2
                  ? e.toRadixString(16)
                  : "0${e.toRadixString(16)}")
              .join(),
          radix: 16));
    } else {
      positionData = BigInt.from(
        ByteData.sublistView(vertexData.value.sublist(0, 8)).getUint64(
          0,
          Endian.little,
        ),
      );
    }

    final textureData = ByteData.sublistView(vertexData.value.sublist(6, 8))
        .getUint16(0, Endian.little);
    return ModelVertex.fromModelBytes(positionData, textureData, box);
  }
}

class Triangle extends GsfPart {
  late final DoubleByteData<int> vertex1;
  late final DoubleByteData<int> vertex2;
  late final DoubleByteData<int> vertex3;

  @override
  String get label => "Triangle p1. $vertex1  p2. $vertex2 p3. $vertex3";

  Triangle.fromBytes(Uint8List bytes, int offset) : super(offset: offset) {
    vertex1 = DoubleByteData(
      relativePos: 0,
      bytes: bytes,
      offset: offset,
    );
    vertex2 = DoubleByteData(
      relativePos: vertex1.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    vertex3 = DoubleByteData(
      relativePos: vertex2.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
  }

  ModelTriangle toModelTriangle(List<ModelVertex> vertices, int indicesOffset) {
    assert(
      vertices.length > vertex1.value &&
          vertices.length > vertex2.value &&
          vertices.length > vertex3.value,
      "invalid vertex index or list provided",
    );
    return ModelTriangle(
      indices: [
        vertex1.value + indicesOffset,
        vertex2.value + indicesOffset,
        vertex3.value + indicesOffset
      ],
      points: [
        vertices[vertex1.value],
        vertices[vertex2.value],
        vertices[vertex3.value],
      ],
    );
  }

  @override
  int getEndOffset() {
    return vertex3.offsettedLength;
  }
}
