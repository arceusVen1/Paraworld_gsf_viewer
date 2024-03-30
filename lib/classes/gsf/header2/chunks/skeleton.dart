import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/bind_pose.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/bone.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/chunk.dart';
import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';

/// WARNING: This class the first bone is included in skeleton chunk
class SkeletonChunk extends Chunk {
  late final Standard4BytesData<int> guid;
  late final Standard4BytesData<int> index;
  late final Standard4BytesData<int> id;
  late final Standard4BytesData<int> flags;
  late final Standard4BytesData<double> positionX;
  late final Standard4BytesData<double> positionY;
  late final Standard4BytesData<double> positionZ;
  late final Standard4BytesData<double> scaleX;
  late final Standard4BytesData<double> scaleY;
  late final Standard4BytesData<double> scaleZ;
  late final Standard4BytesData<double> quaternionL;
  late final Standard4BytesData<double> quaternionI;
  late final Standard4BytesData<double> quaternionJ;
  late final Standard4BytesData<double> quaternionK;
  late final Standard4BytesData<int> childBonesCount;
  late final Standard4BytesData<int> bonesOffset;
  late final Standard4BytesData<int> childBonesCount2;
  late final Standard4BytesData<int> bindPoseOffset;
  late final Standard4BytesData<int> allBonesCount;
  late final Standard4BytesData<int> allBones2;
  late final Standard4BytesData<UnknowData> unknownData;

  late final List<Bone> bones;
  late final BindPose bindPose;

  @override
  String get label => 'Skeleton 0x${guid.value.toRadixString(16)}';

  SkeletonChunk.fromBytes(Uint8List bytes, int offset)
      : super(offset: offset, type: ChunkType.skeleton) {
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
    index = Standard4BytesData(
      position: guid.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    id = Standard4BytesData(
      position: index.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    flags = Standard4BytesData(
      position: id.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    positionX = Standard4BytesData(
      position: flags.relativeEnd,
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
    scaleX = Standard4BytesData(
      position: positionZ.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    scaleY = Standard4BytesData(
      position: scaleX.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    scaleZ = Standard4BytesData(
      position: scaleY.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    quaternionL = Standard4BytesData(
      position: scaleZ.relativeEnd,
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
    childBonesCount = Standard4BytesData(
      position: quaternionK.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    bonesOffset = Standard4BytesData(
      position: childBonesCount.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    childBonesCount2 = Standard4BytesData(
      position: bonesOffset.relativeEnd,
      bytes: bytes,
      offset: offset,
    );

    bindPoseOffset = Standard4BytesData(
      position: childBonesCount2.relativeEnd,
      bytes: bytes,
      offset: offset,
    );

    allBonesCount = Standard4BytesData(
      position: bindPoseOffset.relativeEnd,
      bytes: bytes,
      offset: offset,
    );

    allBones2 = Standard4BytesData(
      position: allBonesCount.relativeEnd,
      bytes: bytes,
      offset: offset,
    );

    unknownData = Standard4BytesData(
      position: allBones2.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    bones = []; // see warning where first nbone is inclueded in skeleton chunk
    for (var i = 0; i < allBonesCount.value - 1; i++) {
      bones.add(
        Bone.fromBytes(
          bytes,
          bones.isNotEmpty
              ? bones.last.getEndOffset()
              : bonesOffset.offsettedPos + bonesOffset.value,
        ),
      );
    }

    bindPose = BindPose.fromBytes(
      bytes,
      bindPoseOffset.offsettedPos + bindPoseOffset.value,
    );
  }

  @override
  int getEndOffset() {
    return bones.isNotEmpty
        ? bones.last.getEndOffset()
        : unknownData.offsettedLength;
  }
}
