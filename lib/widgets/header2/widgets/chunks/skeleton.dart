import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/bind_pose.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/bone.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/skeleton.dart';
import 'package:paraworld_gsf_viewer/widgets/header2/providers.dart';
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
      GsfDataTile(label: "attributes", data: skeleton.attributes),
      GsfDataTile(label: "guid", data: skeleton.guid),
      GsfDataTile(label: "index", data: skeleton.index),
      GsfDataTile(label: "repeated id", data: skeleton.id),
      GsfDataTile(label: "Position X", data: skeleton.positionX),
      GsfDataTile(label: "Position Y", data: skeleton.positionY),
      GsfDataTile(label: "Position Z", data: skeleton.positionZ),
      GsfDataTile(label: "Scale X", data: skeleton.scaleX),
      GsfDataTile(label: "Scale Y", data: skeleton.scaleY),
      GsfDataTile(label: "Scale Z", data: skeleton.scaleZ),
      GsfDataTile(label: "Quaternion L", data: skeleton.quaternionL),
      GsfDataTile(label: "Quaternion I", data: skeleton.quaternionI),
      GsfDataTile(label: "Quaternion J", data: skeleton.quaternionJ),
      GsfDataTile(label: "Quaternion K", data: skeleton.quaternionK),
      GsfDataTile(label: "Bones count", data: skeleton.bonesCount),
      GsfDataTile(label: "Bones offset", data: skeleton.bonesOffset),
      GsfDataTile(label: "Bones count 2", data: skeleton.bonesCount2),
      GsfDataTile(label: "Bind pose offset", data: skeleton.bindPoseOffset),
      GsfDataTile(label: "All bones count", data: skeleton.allBonesCount),
      GsfDataTile(label: "All bones 2", data: skeleton.allBones2),
      GsfDataTile(label: "unknown data", data: skeleton.unknownData),
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
      GsfDataTile(label: "guid", data: bone.guid),
      GsfDataTile(label: "flags", data: bone.flags),
      GsfDataTile(label: "anim position X", data: bone.animPositionX),
      GsfDataTile(label: "anim position Y", data: bone.animPositionY),
      GsfDataTile(label: "anim position Z", data: bone.animPositionZ),
      GsfDataTile(label: "scale X", data: bone.scaleX),
      GsfDataTile(label: "scale Y", data: bone.scaleY),
      GsfDataTile(label: "scale Z", data: bone.scaleZ),
      GsfDataTile(label: "quaternion L", data: bone.quaternionL),
      GsfDataTile(label: "quaternion I", data: bone.quaternionI),
      GsfDataTile(label: "quaternion J", data: bone.quaternionJ),
      GsfDataTile(label: "quaternion K", data: bone.quaternionK),
      GsfDataTile(label: "bones count", data: bone.bonesCount),
      GsfDataTile(label: "next bone offset ?", data: bone.nextBoneOffset),
      GsfDataTile(label: "bones count 2", data: bone.bonesCount2),
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
        GsfDataTile(label: "float 1 to 1", data: bindPose.float1To1),
        GsfDataTile(label: "float 1 to 2", data: bindPose.float1To2),
        GsfDataTile(label: "float 1 to 3", data: bindPose.float1To3),
        GsfDataTile(label: "float 1 to 4", data: bindPose.float1To4),
        GsfDataTile(label: "float 2 to 1", data: bindPose.float2To1),
        GsfDataTile(label: "float 2 to 2", data: bindPose.float2To2),
        GsfDataTile(label: "float 2 to 3", data: bindPose.float2To3),
        GsfDataTile(label: "float 2 to 4", data: bindPose.float2To4),
        GsfDataTile(label: "float 3 to 1", data: bindPose.float3To1),
        GsfDataTile(label: "float 3 to 2", data: bindPose.float3To2),
        GsfDataTile(label: "float 3 to 3", data: bindPose.float3To3),
        GsfDataTile(label: "float 3 to 4", data: bindPose.float3To4),
        GsfDataTile(label: "float 4 to 1", data: bindPose.float4To1),
        GsfDataTile(label: "float 4 to 2", data: bindPose.float4To2),
        GsfDataTile(label: "float 4 to 3", data: bindPose.float4To3),
        GsfDataTile(label: "float 4 to 4", data: bindPose.float4To4),
      ],
    );
  }
}
