import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/gsf/header2/affine_matrix.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/bounding_box.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/chunk.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/mesh.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/submesh.dart';
import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';
import 'package:vector_math/vector_math.dart';

class ClothChunk extends Chunk with MeshToModelInterface {
  late final Standard4BytesData<int> guid;
  late final AffineTransformation affineTransformation;
  late final Standard4BytesData<UnknowData> unknownData;
  late final Standard4BytesData<int>? skeletonIndex; // only for skinned mesh
  late final Standard4BytesData<UnknowData>?
      boneIds; // only for simple skinned mesh
  late final Standard4BytesData<UnknowData>?
      boneWeights; // only for simple skinned mesh
  late final Standard4BytesData<int> boundingBoxOffset;
  late final Standard4BytesData<int> indexInChunkTable;
  late final Standard4BytesData<int> unknownOffset;
  late final Standard4BytesData<int> unknownValue;
  late final Standard4BytesData<int> unknownOffset1;
  late final Standard4BytesData<int> unknownValue2;
  late final Standard4BytesData<int> unknownOffset2;
  late final Standard4BytesData<int> unknownValue3;
  late final Standard4BytesData<int> unknownOffset3;
  @override
  late final BoundingBox boundingBox;
  late final Standard4BytesData<int> submeshCount;
  late final Standard4BytesData<int> submeshOffset;
  late final Standard4BytesData<int> submeshCount2;
  late final Standard4BytesData<int> submeshMaterialsOffset;
  late final Standard4BytesData<int> submeshMaterialsCount;
  @override
  late final List<Submesh> submeshes;
  @override
  late final List<DoubleByteData<int>> materialIndices;

  @override
  Matrix4 get matrix => affineTransformation.matrix;

  @override
  String get label => '${type.name} 0x${guid.value.toRadixString(16)}';

  ClothChunk.fromBytes(Uint8List bytes, int offset, ChunkType type)
      : super(offset: offset, type: type) {
    assert(type.isClothLike(), "cloth can only of cloth like type");
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
    affineTransformation = AffineTransformation.fromBytes(
      bytes,
      guid.offsettedLength,
    );
    unknownData = Standard4BytesData(
      position: guid.relativeEnd + affineTransformation.length,
      bytes: bytes,
      offset: offset,
    );

    int nextRelativePos = unknownData.relativeEnd;
    if (type.isSkinned()) {
      skeletonIndex = Standard4BytesData(
        position: nextRelativePos,
        bytes: bytes,
        offset: offset,
      );
      nextRelativePos = skeletonIndex!.relativeEnd;
    } else {
      skeletonIndex = null;
    }
    if (type == ChunkType.clothSkinnedSimple) {
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
    boundingBoxOffset = Standard4BytesData(
      position: nextRelativePos,
      bytes: bytes,
      offset: offset,
    );
    indexInChunkTable = Standard4BytesData(
      position: boundingBoxOffset.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    unknownOffset = Standard4BytesData(
      position: indexInChunkTable.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    unknownValue = Standard4BytesData(
      position: unknownOffset.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    unknownOffset1 = Standard4BytesData(
      position: unknownValue.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    unknownValue2 = Standard4BytesData(
      position: unknownOffset1.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    unknownOffset2 = Standard4BytesData(
      position: unknownValue2.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    unknownValue3 = Standard4BytesData(
      position: unknownOffset2.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    unknownOffset3 = Standard4BytesData(
      position: unknownValue3.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    boundingBox = BoundingBox.fromBytes(
      bytes,
      boundingBoxOffset.offsettedPos + boundingBoxOffset.value,
    );
    submeshCount = Standard4BytesData(
      position: unknownOffset3.relativeEnd + boundingBox.length,
      bytes: bytes,
      offset: offset,
    );
    submeshOffset = Standard4BytesData(
      position: submeshCount.relativeEnd,
      bytes: bytes,
      offset: offset,
    );

    submeshCount2 = Standard4BytesData(
      position: submeshOffset.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    submeshMaterialsOffset = Standard4BytesData(
      position: submeshCount2.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    submeshMaterialsCount = Standard4BytesData(
      position: submeshMaterialsOffset.relativeEnd,
      bytes: bytes,
      offset: offset,
    );

    materialIndices = [];
    if (!submeshMaterialsOffset.isUnused) {
      for (var i = 0; i < submeshMaterialsCount.value; i++) {
        final materialIndex = DoubleByteData<int>(
          relativePos: i * 2,
          bytes: bytes,
          offset: submeshMaterialsOffset.offsettedPos +
              submeshMaterialsOffset.value,
        );
        materialIndices.add(materialIndex);
      }
    }

    submeshes = [];
    for (int i = 0; i < submeshCount.value; i++) {
      final submesh = Submesh.fromBytes(
        bytes,
        submeshes.isNotEmpty
            ? submeshes.last.getEndOffset()
            : submeshOffset.offsettedPos + submeshOffset.value,
        true,
      );
      submeshes.add(submesh);
    }
  }

  @override
  int getEndOffset() {
    return submeshMaterialsCount.relativeEnd;
  }
}
