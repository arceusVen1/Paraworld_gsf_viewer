import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/chunk.dart';
import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';

class BoneLinkChunk extends Chunk {
  late final Standard4BytesData<int> attributes;
  late final Standard4BytesData<int> guid;
  late final Standard4BytesData<int> positionX;
  late final Standard4BytesData<int> positionY;
  late final Standard4BytesData<int> positionZ;
  late final Standard4BytesData<int> quaternionL;
  late final Standard4BytesData<int> quaternionI;
  late final Standard4BytesData<int> quaternionJ;
  late final Standard4BytesData<int> quaternionK;
  late final Standard4BytesData<StringNoZero> fourccLink;
  late final Standard4BytesData<int> skeletonIndex;
  late final Standard4BytesData<UnknowData> boneIds;
  late final Standard4BytesData<UnknowData> boneWeights;

  @override
  String get label => 'BoneLink 0x${guid.value.toRadixString(16)}';

  BoneLinkChunk.fromBytes(Uint8List bytes, int offset)
      : super(offset: offset, type: ChunkType.boneLink) {
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
    positionX = Standard4BytesData(
      position: guid.relativeEnd,
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
    quaternionL = Standard4BytesData(
      position: positionZ.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    quaternionI = Standard4BytesData(
      position: quaternionL.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    quaternionJ = Standard4BytesData(
      position: quaternionI.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    quaternionK = Standard4BytesData(
      position: quaternionJ.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    fourccLink = Standard4BytesData(
      position: quaternionK.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    skeletonIndex = Standard4BytesData(
      position: fourccLink.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    boneIds = Standard4BytesData(
      position: skeletonIndex.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    boneWeights = Standard4BytesData(
      position: boneIds.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
  }

  @override
  int getEndOffset() {
    return boneWeights.offsettedLength;
  }
}
