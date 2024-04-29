import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/bind_pose.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/bone.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/skeleton.dart';
import 'package:paraworld_gsf_viewer/widgets/header2/providers.dart';
import 'package:paraworld_gsf_viewer/widgets/header2/widgets/affine_transformation.dart';
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
      ChunkAttributesFromHeader2WrapperDisplay(
          attributesValue: skeleton.attributes.value),
      GsfDataTile(label: "Guid", data: skeleton.guid),
      GsfDataTile(label: "Index", data: skeleton.index),
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
      GsfDataTile(label: "Anim pos X", data: bone.posX),
      GsfDataTile(label: "Anim pos Y", data: bone.posY),
      GsfDataTile(label: "Anim pos Z", data: bone.posZ),
      GsfDataTile(label: "Scale X", data: bone.scaleX),
      GsfDataTile(label: "Scale Y", data: bone.scaleY),
      GsfDataTile(label: "Scale Z", data: bone.scaleZ),
      GsfDataTile(label: "Quat X", data: bone.quaternionX),
      GsfDataTile(label: "Quat Y", data: bone.quaternionY),
      GsfDataTile(label: "Quat Z", data: bone.quaternionZ),
      GsfDataTile(label: "Quat W", data: bone.quaternionW),
      GsfDataTile(label: "Child bones count", data: bone.childrenCount),
      GsfDataTile(label: "Child bone offset", data: bone.nextChildOffset),
      GsfDataTile(label: "Child bones count 2", data: bone.childrenCount2),
      AffineTransformationDisplay(transformation: bone.bindPose!),
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
