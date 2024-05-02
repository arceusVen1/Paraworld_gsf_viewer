import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/bouding_box.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/affine_matrix.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/bone.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/chunk.dart';
import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';
import 'package:paraworld_gsf_viewer/classes/vertex.dart';
import 'package:vector_math/vector_math.dart';

typedef BoneTree = Map<int, ({Bone bone, List<int> children})>;
typedef JointModel = (int?, ModelVertex);
typedef BoneModel = List<JointModel>;
typedef SkeletonModel = List<BoneModel>;

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
      0,
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
        i + 1,
        bytes,
        bones.length > 1
            ? bones.last.getEndOffset()
            : unknownData.offsettedLength,
      );
      bones.add(
        nextBone,
      );
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
    }

    // fill bone tree
    while (boneTree.length < allBonesCount.value) {
      final nextBone = _getNextBoneInTree(boneTree, bones, 0);
      if (nextBone == null) {
        break;
      }
      _getChildOfBone(boneTree, bones, nextBone);
    }
  }

  Bone? _getNextBoneInTree(
    BoneTree boneTree,
    List<Bone> bones,
    int currentIndex,
  ) {
    if (currentIndex >= bones.length) {
      return null;
    }
    final next = bones[currentIndex];
    if (!boneTree.containsKey(currentIndex)) {
      return next;
    }
    return _getNextBoneInTree(
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
    boneTree[bone.index] = (bone: bone, children: []);
    if (bone.childrenCount.value == 0) {
      return;
    }
    final firstChildIndex =
        bone.index + (bone.nextChildOffset.value / Bone.size).ceil();
    while (boneTree[bone.index]!.children.length < bone.childrenCount.value) {
      final nextBone = _getNextBoneInTree(
        boneTree,
        bones,
        firstChildIndex,
      );
      if (nextBone == null) {
        throw ("Missing ${bone.childrenCount.value - boneTree[bone.index]!.children.length} children for bone $bone");
      }
      boneTree[bone.index]!.children.add(nextBone.index);
      _getChildOfBone(
        boneTree,
        bones,
        nextBone,
      );
    }
  }

  @override
  int getEndOffset() {
    return bones.isNotEmpty
        ? bones.last.getEndOffset()
        : unknownData.offsettedLength;
  }

  (SkeletonModel, int) _createJointsBranch(
    Bone parentBone,
    Matrix4 parentMatrix,
    ModelVertex parentVert,
    List<int> childIds,
    int bindPosePointer,
  ) {
    final SkeletonModel branches = [];
    if (childIds.isEmpty) {
      Vector3 endPos = parentVert.positions.clone();
      endPos.applyMatrix4((parentBone.bindPose!.matrix..invert()) *
          parentBone.localTransform *
          parentBone.bindPose!.matrix);
      return (
        [
          [
            (parentBone.index, parentVert),
            (
              null,
              ModelVertex(endPos,
                  box: BoundingBoxModel.zero(), positionOffset: Vector3.zero())
            )
          ]
        ],
        bindPosePointer
      );
    }
    for (final boneId in List.from(childIds)) {
      final BoneModel boneLine = [(parentBone.index, parentVert)];
      final data = boneTree[boneId]!;
      final bone = data.bone;
      bone.bindPose = bindPoses[bindPosePointer];
      bindPosePointer++;
      final boneVert = ModelVertex(
        (bone.bindPose!.matrix..invert()).getTranslation(),
        box: BoundingBoxModel.zero(),
        positionOffset: Vector3.zero(),
      );
      boneLine.add((boneId, boneVert));
      branches.add(boneLine);
      final childBranches = _createJointsBranch(
        bone,
        parentMatrix * bone.localTransform,
        boneVert,
        data.children,
        bindPosePointer,
      );
      branches.addAll(childBranches.$1);
      bindPosePointer = childBranches.$2;
    }
    return (branches, bindPosePointer);
  }

  SkeletonModel toModel() {
    // unfortunately bind poses are linked to bones recursively so we need to
    // fill the bone tree to link them using a sort of stack pointer on the bind poses
    final rootBone = bones.first;
    rootBone.bindPose = bindPoses.first;
    final rootVert = ModelVertex(
      (rootBone.bindPose!.matrix..invert()).getTranslation(),
      box: BoundingBoxModel.zero(),
      positionOffset: Vector3.zero(),
    );
    final vertices = _createJointsBranch(
      rootBone,
      rootBone.localTransform,
      rootVert,
      boneTree[0]!.children,
      1,
    );
    assert(vertices.$2 == allBonesCount.value);
    return vertices.$1;
  }
}
