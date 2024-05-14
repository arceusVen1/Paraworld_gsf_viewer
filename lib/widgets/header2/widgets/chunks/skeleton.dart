import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/bone.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/skeleton.dart';
import 'package:paraworld_gsf_viewer/widgets/header2/providers.dart';
import 'package:paraworld_gsf_viewer/widgets/header2/widgets/bind_pose.dart';
import 'package:paraworld_gsf_viewer/widgets/header2/widgets/chunks/attributes/chunk_attributes.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/data_display.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/label.dart';

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
      BindPoseDisplay(bindPose: bone.bindPose!),
    ]);
  }
}

class BoneTreeDisplay extends ConsumerStatefulWidget {
  const BoneTreeDisplay({
    super.key,
    required this.boneTree,
    required this.bones,
  });

  final BoneTree boneTree;
  final List<Bone> bones;

  @override
  ConsumerState<BoneTreeDisplay> createState() => _BoneTreeDisplayState();
}

class _BoneTreeDisplayState extends ConsumerState<BoneTreeDisplay> {
  late TreeNode<Bone> _computedBoneTree = TreeNode.root(
    data: widget.bones.first,
  );
  TreeViewController? _controller;

  createBranchFromBone(Bone bone, TreeNode<Bone> node) {
    final children = widget.boneTree[bone.index]!.children;
    for (final child in children) {
      final chilBone = widget.boneTree[child]!.bone;
      final childNode = TreeNode<Bone>(
        key: child.toString(),
        data: widget.boneTree[child]!.bone,
      );
      node.add(childNode);
      createBranchFromBone(chilBone, childNode);
    }
  }

  @override
  void initState() {
    createBranchFromBone(widget.bones.first, _computedBoneTree);
    super.initState();
  }

  @override
  void didUpdateWidget(BoneTreeDisplay oldWidget) {
    if (oldWidget.bones != widget.bones) {
      _computedBoneTree = TreeNode.root(
        data: widget.bones.first,
      );
      createBranchFromBone(widget.bones.first, _computedBoneTree);
    }
    if (_controller != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller!.expandAllChildren(_computedBoneTree);
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedBone = ref.watch(header2StateNotifierProvider).mapOrNull(
          withModelSettings: (state) => state.selectedChunkState?.mapOrNull(
            withSkeleton: (skeleton) => skeleton.bone,
          ),
        );
    return Flexible(
      child: ListViewWrapper(
        rightPadding: 0,
        maxHeight: double.infinity,
        child: TreeView.simpleTyped<Bone, TreeNode<Bone>>(
          shrinkWrap: true,
          onTreeReady: (controller) {
            _controller = controller;
            _controller!.expandAllChildren(_computedBoneTree);
          },
          builder: (context, node) {
            return ListTile(
              dense: true,
              visualDensity: const VisualDensity(
                horizontal: 0,
                vertical: VisualDensity.minimumDensity,
              ),
              shape: Border(
                top: BorderSide(color: theme.colorScheme.onBackground),
                left: BorderSide(color: theme.colorScheme.onBackground),
              ),
              selected: selectedBone != null &&
                  selectedBone.guid.value == node.data?.guid.value,
              selectedTileColor: theme.colorScheme.secondary,
              title: Label.regular(node.data?.label ?? ""),
              onTap: () {
                if (node.data != null) {
                  ref
                      .read(header2StateNotifierProvider.notifier)
                      .setBone(node.data!);
                }
              },
            );
          },
          tree: _computedBoneTree,
        ),
      ),
    );
  }
}
