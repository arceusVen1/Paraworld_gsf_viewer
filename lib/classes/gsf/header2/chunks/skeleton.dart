import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/bouding_box.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/affine_matrix.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/bone.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/chunk.dart';
import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';
import 'package:paraworld_gsf_viewer/classes/vertex.dart';
import 'package:vector_math/vector_math.dart';

typedef BoneTree = Map<int, ({Bone bone, List<int> children})>;

/// WARNING: This class the first bone is included in skeleton chunk
class SkeletonChunk extends Chunk {
  late final Standard4BytesData<int> guid;
  late final Standard4BytesData<int> index;
  late final Standard4BytesData<int> bindPoseOffset;
  late final Standard4BytesData<int> allBonesCount;
  late final Standard4BytesData<int> allBones2;
  late final Standard4BytesData<UnknowData> unknownData;

  late final List<Bone> bones;
  late final List<AffineTransformation> bindPoses;

  final BoneTree boneTree = {};

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
    final firstBone = Bone.fromBytes(
      bytes,
      index.offsettedLength,
    );

    bindPoseOffset = Standard4BytesData(
      position: firstBone.getEndOffset() - offset,
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

    bones = [
      firstBone
    ]; // see warning where first nbone is inclueded in skeleton chunk

    for (var i = 0; i < allBonesCount.value - 1; i++) {
      final nextBone = Bone.fromBytes(
        bytes,
        bones.length > 1
            ? bones.last.getEndOffset()
            : unknownData.offsettedLength,
      );
      bones.add(
        nextBone,
      );
    }
    // fill bone tree
    while (boneTree.length < allBonesCount.value) {
      final nextBone = _getNextBoneToTreat(boneTree, bones, 0);
      if (nextBone == null) {
        break;
      }
      _getChildOfBone(boneTree, bones, nextBone);
    }
    bindPoses = [];
    for (var i = 0; i < allBonesCount.value; i++) {
      final bindPose = AffineTransformation.fromBytes(
        bytes,
        bindPoses.isEmpty
            ? bindPoseOffset.offsettedPos + bindPoseOffset.value
            : bindPoses.last.getEndOffset(),
      );
      bindPoses.add(bindPose);
      bones[i].bindPose = bindPose;
    }
  }

  Bone? _getNextBoneToTreat(
    BoneTree boneTree,
    List<Bone> bones,
    int currentIndex,
  ) {
    if (currentIndex >= bones.length) {
      return null;
    }
    final next = bones[currentIndex];
    if (!boneTree.containsKey(next.guid.value)) {
      return next;
    }
    return _getNextBoneToTreat(
      boneTree,
      bones,
      currentIndex + 1,
    );
  }

  _getChildOfBone(
    BoneTree boneTree,
    List<Bone> bones,
    Bone bone,
  ) {
    boneTree[bone.guid.value] = (bone: bone, children: []);
    if (bone.childrenCount.value == 0) {
      return;
    }
    final currentIndex =
        bones.indexWhere((element) => element.guid.value == bone.guid.value);
    final firstChild =
        bones[currentIndex + (bone.nextChildOffset.value / Bone.size).ceil()];
    boneTree[bone.guid.value]!.children.add(firstChild.guid.value);

    if (!boneTree.containsKey(firstChild.guid.value)) {
      _getChildOfBone(
        boneTree,
        bones,
        firstChild,
      );
    }
    int treatedCount = 1;
    while (treatedCount < bone.childrenCount.value) {
      final nextBone = _getNextBoneToTreat(
        boneTree,
        bones,
        currentIndex + 1,
      );
      if (nextBone == null) {
        throw ("Missing ${bone.childrenCount.value - boneTree[bone.guid.value]!.children.length} children for bone $bone");
      }
      boneTree[bone.guid.value]!.children.add(nextBone.guid.value);
      _getChildOfBone(
        boneTree,
        bones,
        nextBone,
      );
      treatedCount++;
    }
  }

  @override
  int getEndOffset() {
    return bones.isNotEmpty
        ? bones.last.getEndOffset()
        : unknownData.offsettedLength;
  }

  _createJointsBranch(
    List<ModelVertex> jointVertices,
    List<int> boneIds,
  ) {
    for (final boneId in boneIds) {
      final data = boneTree[boneId]!;
      final bone = data.bone;
      jointVertices.add(
        ModelVertex(
          (bone.bindPose!.matrix..invert()).getTranslation(),
          box: BoundingBoxModel.zero(),
          positionOffset: Vector3.zero(),
          //quat: boneQuat,
        ),
      );

      _createJointsBranch(
        jointVertices,
        data.children,
      );
    }
  }

  List<ModelVertex> toModelVertices() {
    final List<ModelVertex> vertices = [];
    final rootBone = bones.first;

    vertices.add(
      ModelVertex(
        (rootBone.bindPose!.matrix..invert()).getTranslation(),
        box: BoundingBoxModel.zero(),
        positionOffset: Vector3.zero(),
      ),
    );
    _createJointsBranch(
      vertices,
      boneTree[rootBone.guid.value]!.children,
    );
    assert(vertices.length == allBonesCount.value,
        "There is more than one root bone in skeleton");
    return vertices;
  }
}
