import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/bind_pose.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/bone.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/skeleton.dart';
import 'package:paraworld_gsf_viewer/widgets/header2/providers.dart';
import 'package:paraworld_gsf_viewer/widgets/header2/widgets/chunks/attributes/chunk_attributes.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/data_display.dart';

class SkeletonDisplay extends ConsumerWidget {
  const SkeletonDisplay({super.key, required this.skeleton});

  final SkeletonChunk skeleton;

  @override
  Widget build(BuildContext context, ref) {
    final selectedBone = ref.watch(header2StateNotifierProvider).mapOrNull(
          withModelSettings: (state) => state.selectedChunkState?.mapOrNull(
            withSkeleton: (skeleton) => skeleton.bone,
          ),
        );
    return DataDecorator(children: [
      GsfDataTile(label: "Attributes", data: skeleton.attributes),
      ChunkAttributesDisplay(attributes: skeleton.attributes.value),
      GsfDataTile(label: "Guid", data: skeleton.guid),
      GsfDataTile(label: "Index", data: skeleton.index),
      GsfDataTile(label: "Guid 2", data: skeleton.id),
      GsfDataTile(label: "Pos X", data: skeleton.positionX),
      GsfDataTile(label: "Pos Y", data: skeleton.positionY),
      GsfDataTile(label: "Pos Z", data: skeleton.positionZ),
      GsfDataTile(label: "Scale X", data: skeleton.scaleX),
      GsfDataTile(label: "Scale Y", data: skeleton.scaleY),
      GsfDataTile(label: "Scale Z", data: skeleton.scaleZ),
      GsfDataTile(label: "Quat X", data: skeleton.quaternionL),
      GsfDataTile(label: "Quat Y", data: skeleton.quaternionI),
      GsfDataTile(label: "Quat Z", data: skeleton.quaternionJ),
      GsfDataTile(label: "Quat W", data: skeleton.quaternionK),
      GsfDataTile(label: "Child bones count", data: skeleton.childBonesCount),
      GsfDataTile(label: "Bones offset", data: skeleton.bonesOffset),
      GsfDataTile(
          label: "Child bones count 2", data: skeleton.childBonesCount2),
      GsfDataTile(label: "Bind pose offset", data: skeleton.bindPoseOffset),
      GsfDataTile(label: "All bones count", data: skeleton.allBonesCount),
      GsfDataTile(label: "All bones count 2", data: skeleton.allBones2),
      GsfDataTile(label: "Unknown data", data: skeleton.unknownData),
      PartSelector(
        label: "Bones",
        value: selectedBone,
        parts: skeleton.bones,
        onSelected: (bone) {
          ref.read(header2StateNotifierProvider.notifier).setBone(bone as Bone);
        },
      ),
      _BindPoseDisplay(bindPose: skeleton.bindPose),
    ]);
  }
}

class BoneDisplay extends StatelessWidget {
  const BoneDisplay({
    super.key,
    required this.bone,
  });

  final Bone bone;

  @override
  Widget build(BuildContext context) {
    return DataDecorator(children: [
      GsfDataTile(label: "Guid", data: bone.guid),
      GsfDataTile(label: "Flags", data: bone.flags),
      GsfDataTile(label: "Anim pos X", data: bone.animPositionX),
      GsfDataTile(label: "Anim pos Y", data: bone.animPositionY),
      GsfDataTile(label: "Anim pos Z", data: bone.animPositionZ),
      GsfDataTile(label: "Scale X", data: bone.scaleX),
      GsfDataTile(label: "Scale Y", data: bone.scaleY),
      GsfDataTile(label: "Scale Z", data: bone.scaleZ),
      GsfDataTile(label: "Quat X", data: bone.quaternionL),
      GsfDataTile(label: "Quat Y", data: bone.quaternionI),
      GsfDataTile(label: "Quat Z", data: bone.quaternionJ),
      GsfDataTile(label: "Quat W", data: bone.quaternionK),
      GsfDataTile(label: "Child bones count", data: bone.bonesCount),
      GsfDataTile(label: "Child bone offset", data: bone.nextBoneOffset),
      GsfDataTile(label: "Child bones count 2", data: bone.bonesCount2),
    ]);
  }
}

class _BindPoseDisplay extends StatelessWidget {
  const _BindPoseDisplay({
    super.key,
    required this.bindPose,
  });

  final BindPose bindPose;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GsfDataTile(label: "a1_1", data: bindPose.float1To1),
        GsfDataTile(label: "a1_2", data: bindPose.float1To2),
        GsfDataTile(label: "a1_3", data: bindPose.float1To3),
        GsfDataTile(label: "a1_4", data: bindPose.float1To4),
        GsfDataTile(label: "a2_1", data: bindPose.float2To1),
        GsfDataTile(label: "a2_2", data: bindPose.float2To2),
        GsfDataTile(label: "a2_3", data: bindPose.float2To3),
        GsfDataTile(label: "a2_4", data: bindPose.float2To4),
        GsfDataTile(label: "a3_1", data: bindPose.float3To1),
        GsfDataTile(label: "a3_2", data: bindPose.float3To2),
        GsfDataTile(label: "a3_3", data: bindPose.float3To3),
        GsfDataTile(label: "a3_4", data: bindPose.float3To4),
        GsfDataTile(label: "a4_1", data: bindPose.float4To1),
        GsfDataTile(label: "a4_2", data: bindPose.float4To2),
        GsfDataTile(label: "a4_3", data: bindPose.float4To3),
        GsfDataTile(label: "a4_4", data: bindPose.float4To4),
      ],
    );
  }
}
