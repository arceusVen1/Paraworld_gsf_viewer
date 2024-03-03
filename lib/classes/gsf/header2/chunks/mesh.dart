import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/chunk.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/submesh.dart';
import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';

class MeshChunk extends Chunk {
  late final Standard4BytesData<int> attributes;
  late final Standard4BytesData<int> guid;
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
  late final Standard4BytesData<UnknowData> unknownData;
  late final Standard4BytesData<int> globalBoundingBoxOffset;
  late final Standard4BytesData<int> unknownId;
  late final Standard4BytesData<double> globalBBoxMinX;
  late final Standard4BytesData<double> globalBBoxMinY;
  late final Standard4BytesData<double> globalBBoxMinZ;
  late final Standard4BytesData<double> globalBBoxMaxX;
  late final Standard4BytesData<double> globalBBoxMaxY;
  late final Standard4BytesData<double> globalBBoxMaxZ;
  late final Standard4BytesData<int> submeshInfoCount;
  late final Standard4BytesData<int> submeshInfoOffset;
  late final Standard4BytesData<int> submeshInfo2Count;
  late final Standard4BytesData<int> submeshMaterialsOffset;
  late final Standard4BytesData<int> submeshMaterialsCount;
  late final List<Submesh> submeshes;

  @override
  String get label => 'mesh 0x${guid.value.toRadixString(16)}';

  MeshChunk.fromBytes(Uint8List bytes, int offset)
      : super(offset: offset, type: ChunkType.mesh) {
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
    scaleX = Standard4BytesData(
      position: guid.relativeEnd,
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
    unknownData = Standard4BytesData(
      position: unknownFloat4.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    globalBoundingBoxOffset = Standard4BytesData(
      position: unknownData.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    unknownId = Standard4BytesData(
      position: globalBoundingBoxOffset.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    globalBBoxMinX = Standard4BytesData(
      position: unknownId.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    globalBBoxMinY = Standard4BytesData(
      position: globalBBoxMinX.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    globalBBoxMinZ = Standard4BytesData(
      position: globalBBoxMinY.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    globalBBoxMaxX = Standard4BytesData(
      position: globalBBoxMinZ.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    globalBBoxMaxY = Standard4BytesData(
      position: globalBBoxMaxX.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    globalBBoxMaxZ = Standard4BytesData(
      position: globalBBoxMaxY.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    submeshInfoCount = Standard4BytesData(
      position: globalBBoxMaxZ.relativeEnd,
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
