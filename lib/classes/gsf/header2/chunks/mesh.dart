import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/bounding_box.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/chunk.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/submesh.dart';
import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';
import 'package:paraworld_gsf_viewer/classes/model.dart';
import 'package:paraworld_gsf_viewer/classes/triangle.dart';
import 'package:paraworld_gsf_viewer/classes/vertex.dart';

class AffineTransformation extends GsfPart {
  late final Standard4BytesData<double> scaleX;
  late final Standard4BytesData<double> stretchY;
  late final Standard4BytesData<double> stretchZX;
  late final Standard4BytesData<double> unknownFloat1;
  late final Standard4BytesData<double> stretchX;
  late final Standard4BytesData<double> scaleY;
  late final Standard4BytesData<double> stretchZY;
  late final Standard4BytesData<double> unknownFloat2;
  late final Standard4BytesData<double> shearX;
  late final Standard4BytesData<double> shearY;
  late final Standard4BytesData<double> scaleZ;
  late final Standard4BytesData<double> unknownFloat3;
  late final Standard4BytesData<double> positionX;
  late final Standard4BytesData<double> positionY;
  late final Standard4BytesData<double> positionZ;
  late final Standard4BytesData<double> unknownFloat4;

  @override
  String get label => 'affine transformation';

  AffineTransformation.fromBytes(Uint8List bytes, int offset)
      : super(offset: offset) {
    scaleX = Standard4BytesData(
      position: 0,
      bytes: bytes,
      offset: offset,
    );
    stretchY = Standard4BytesData(
      position: scaleX.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    stretchZX = Standard4BytesData(
      position: stretchY.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    unknownFloat1 = Standard4BytesData(
      position: stretchZX.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    stretchX = Standard4BytesData(
      position: unknownFloat1.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    scaleY = Standard4BytesData(
      position: stretchX.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    stretchZY = Standard4BytesData(
      position: scaleY.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    unknownFloat2 = Standard4BytesData(
      position: stretchZY.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    shearX = Standard4BytesData(
      position: unknownFloat2.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    shearY = Standard4BytesData(
      position: shearX.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    scaleZ = Standard4BytesData(
      position: shearY.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    unknownFloat3 = Standard4BytesData(
      position: scaleZ.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    positionX = Standard4BytesData(
      position: unknownFloat3.relativeEnd,
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
    unknownFloat4 = Standard4BytesData(
      position: positionZ.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
  }

  @override
  int getEndOffset() {
    return unknownFloat4.offsettedLength;
  }
}

mixin MeshToModelInterface on Chunk {
  BoundingBox get boundingBox;
  List<Submesh> get submeshes;
  Model toModel() {
    final globalBB = boundingBox.toModelBox();
    final List<ModelVertex> vertices = [];
    final List<ModelTriangle> triangles = [];
    for (var submesh in submeshes) {
      final data = submesh.getMeshModelData(vertices.length, globalBB);
      vertices.addAll(data.vertices);
      triangles.addAll(data.triangles);
    }
    return Model(
      vertices: vertices,
      triangles: triangles,
      boundingBox: globalBB,
    );
  }
}

class MeshChunk extends Chunk with MeshToModelInterface {
  late final Standard4BytesData<int> attributes;
  late final Standard4BytesData<int> guid;
  late final AffineTransformation transformation;
  late final Standard4BytesData<UnknowData> unknownData;
  late final Standard4BytesData<int>? skeletonIndex; // only for skinned mesh
  late final Standard4BytesData<UnknowData>?
      boneIds; // only for simple skinned mesh
  late final Standard4BytesData<UnknowData>?
      boneWeights; // only for simple skinned mesh
  late final Standard4BytesData<int> globalBoundingBoxOffset;
  late final Standard4BytesData<int> unknownId;
  @override
  late final BoundingBox boundingBox;
  late final Standard4BytesData<int> submeshInfoCount;
  late final Standard4BytesData<int> submeshInfoOffset;
  late final Standard4BytesData<int> submeshInfo2Count;
  late final Standard4BytesData<int> submeshMaterialsOffset;
  late final Standard4BytesData<int> submeshMaterialsCount;

  @override
  late final List<Submesh> submeshes;
  late final List<DoubleByteData<int>> materialIndices;

  @override
  String get label => '${type.name} 0x${guid.value.toRadixString(16)}';

  MeshChunk.fromBytes(Uint8List bytes, int offset, ChunkType type)
      : super(offset: offset, type: type) {
    assert(type.isMeshLike(), "mesh can only of mesh like type");
    attributes = Standard4BytesData(
      position: 0,
      bytes: bytes,
      offset: offset,
    );
    guid = Standard4BytesData(
      position: attributes.relativeEnd,
      bytes: bytes,
      offset: offset,
    );

    transformation = AffineTransformation.fromBytes(
      bytes,
      guid.offsettedLength,
    );

    unknownData = Standard4BytesData(
      position: guid.relativeEnd + transformation.length,
      bytes: bytes,
      offset: offset,
    );
    int nextRelativePos = unknownData.relativeEnd;
    if (type.isSkinned()) {
      skeletonIndex = Standard4BytesData(
        position: unknownData.relativeEnd,
        bytes: bytes,
        offset: offset,
      );
      nextRelativePos = skeletonIndex!.relativeEnd;
    } else {
      skeletonIndex = null;
    }
    if (type == ChunkType.meshSkinnedSimple) {
      boneIds = Standard4BytesData(
        position: skeletonIndex!.relativeEnd,
        bytes: bytes,
        offset: offset,
      );
      boneWeights = Standard4BytesData(
        position: boneIds!.relativeEnd,
        bytes: bytes,
        offset: offset,
      );
      nextRelativePos = boneWeights!.relativeEnd;
    } else {
      boneIds = null;
      boneWeights = null;
    }

    globalBoundingBoxOffset = Standard4BytesData(
      position: nextRelativePos,
      bytes: bytes,
      offset: offset,
    );
    unknownId = Standard4BytesData(
      position: globalBoundingBoxOffset.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    boundingBox = BoundingBox.fromBytes(
      bytes,
      globalBoundingBoxOffset.offsettedPos + globalBoundingBoxOffset.value,
    );
    submeshInfoCount = Standard4BytesData(
      position: boundingBox.getEndOffset() - offset,
      bytes: bytes,
      offset: offset,
    );
    submeshInfoOffset = Standard4BytesData(
      position: submeshInfoCount.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    submeshInfo2Count = Standard4BytesData(
      position: submeshInfoOffset.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    submeshMaterialsOffset = Standard4BytesData(
      position: submeshInfo2Count.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    submeshMaterialsCount = Standard4BytesData(
      position: submeshMaterialsOffset.relativeEnd,
      bytes: bytes,
      offset: offset,
    );

    materialIndices = [];
    for (var i = 0; i < submeshMaterialsCount.value; i++) {
      final materialIndex = DoubleByteData<int>(
        relativePos: i * 2,
        bytes: bytes,
        offset:
            submeshMaterialsOffset.offsettedPos + submeshMaterialsOffset.value,
      );
      materialIndices.add(materialIndex);
    }

    submeshes = [];
    for (var i = 0; i < submeshInfoCount.value; i++) {
      final submesh = Submesh.fromBytes(
        bytes,
        submeshes.isNotEmpty
            ? submeshes.last.getEndOffset()
            : submeshInfoOffset.offsettedPos + submeshInfoOffset.value,
        false,
      );
      submeshes.add(submesh);
    }
  }

  @override
  int getEndOffset() {
    return submeshes.isNotEmpty
        ? submeshes.last.getEndOffset()
        : submeshMaterialsCount.offsettedLength;
  }
}
