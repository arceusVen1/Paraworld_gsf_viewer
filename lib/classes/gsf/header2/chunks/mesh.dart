import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/bounding_box.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/chunk.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/submesh.dart';
import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';

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

class MeshChunk extends Chunk {
  late final Standard4BytesData<int> attributes;
  late final Standard4BytesData<int> guid;
  late final AffineTransformation transformation;
  late final Standard4BytesData<UnknowData> unknownData;
  late final Standard4BytesData<int>? skeletonIndex; // only for skinned mesh
  late final Standard4BytesData<int> globalBoundingBoxOffset;
  late final Standard4BytesData<int> unknownId;
  late final BoundingBox globalBoundingBox;
  late final Standard4BytesData<int> submeshInfoCount;
  late final Standard4BytesData<int> submeshInfoOffset;
  late final Standard4BytesData<int> submeshInfo2Count;
  late final Standard4BytesData<int> submeshMaterialsOffset;
  late final Standard4BytesData<int> submeshMaterialsCount;
  late final List<Submesh> submeshes;
  late final List<DoubleByteData<int>> materialIndices;

  @override
  String get label => 'mesh 0x${guid.value.toRadixString(16)}';

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
    if (type == ChunkType.meshSkinned) {
      skeletonIndex = Standard4BytesData(
        position: unknownData.relativeEnd,
        bytes: bytes,
        offset: offset,
      );
    }
    globalBoundingBoxOffset = Standard4BytesData(
      position: type == ChunkType.meshSkinned
          ? skeletonIndex!.relativeEnd
          : unknownData.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    unknownId = Standard4BytesData(
      position: globalBoundingBoxOffset.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    globalBoundingBox = BoundingBox.fromBytes(
      bytes,
      globalBoundingBoxOffset.offsettedPos + globalBoundingBoxOffset.value,
    );
    submeshInfoCount = Standard4BytesData(
      position: globalBoundingBox.getEndOffset() - offset,
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
            : submeshMaterialsCount.offsettedLength,
      );
      submeshes.add(submesh);
    }
  }

  @override
  int getEndOffset() {
    return submeshMaterialsCount.relativeEnd;
  }
}
