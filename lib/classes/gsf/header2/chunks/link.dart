import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/bouding_box.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/chunk.dart';
import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';
import 'package:paraworld_gsf_viewer/classes/vertex.dart';
import 'package:vector_math/vector_math.dart';

typedef LinkModel = ({String fourCC, ModelVertex vertex});

class LinkChunk extends Chunk {
  late final Standard4BytesData<int> guid;
  late final Standard4BytesData<double> positionX;
  late final Standard4BytesData<double> positionY;
  late final Standard4BytesData<double> positionZ;
  late final Standard4BytesData<double> quaternionX;
  late final Standard4BytesData<double> quaternionY;
  late final Standard4BytesData<double> quaternionZ;
  late final Standard4BytesData<double> quaternionW;
  late final Standard4BytesData<StringNoZero> fourccLink;
  // for bone only
  late final Standard4BytesData<int>? skeletonIndex;
  late final Standard4BytesData<UnknowData>? boneIds;
  late final Standard4BytesData<UnknowData>? boneWeights;

  Vector3 get position =>
      Vector3(positionX.value, positionY.value, positionZ.value);

  Quaternion get quaternion => Quaternion(quaternionY.value, quaternionZ.value,
      quaternionW.value, quaternionX.value);

  @override
  String get label => '${type.name} 0x${guid.value.toRadixString(16)}';

  LinkChunk.fromBytes(Uint8List bytes, int offset, ChunkType type)
      : super(offset: offset, type: type) {
    assert(type.isLinkLike(),
        'LinkChunk can only be created from link-like types');
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
    quaternionX = Standard4BytesData(
      position: positionZ.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    quaternionY = Standard4BytesData(
      position: quaternionX.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    quaternionZ = Standard4BytesData(
      position: quaternionY.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    quaternionW = Standard4BytesData(
      position: quaternionZ.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    fourccLink = Standard4BytesData(
      position: quaternionW.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    if (type == ChunkType.boneLink) {
      skeletonIndex = Standard4BytesData(
        position: fourccLink.relativeEnd,
        bytes: bytes,
        offset: offset,
      );
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
    } else {
      skeletonIndex = null;
      boneIds = null;
      boneWeights = null;
    }
  }

  LinkModel toModelVertex() {
    return (
      fourCC: fourccLink.value.value,
      vertex: ModelVertex(
        position,
        box: BoundingBoxModel.zero(),
        positionOffset: Vector3.zero(),
      ),
    );
  }

  @override
  int getEndOffset() {
    return boneWeights?.offsettedLength ?? fourccLink.offsettedLength;
  }
}
