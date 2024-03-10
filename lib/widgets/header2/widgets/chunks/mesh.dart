import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/cloth.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/mesh.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/submesh.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/fallback_table.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/material.dart';
import 'package:paraworld_gsf_viewer/widgets/header2/providers.dart';
import 'package:paraworld_gsf_viewer/widgets/header2/widgets/affine_transformation.dart';
import 'package:paraworld_gsf_viewer/widgets/header2/widgets/bounding_box.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/data_display.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/label.dart';

class MeshChunkDisplay extends ConsumerWidget {
  const MeshChunkDisplay({
    super.key,
    required this.mesh,
    required this.fallbackTable,
    required this.materials,
  });

  final MeshChunk mesh;
  final FallbackTable? fallbackTable;
  final List<MaterialData> materials;

  @override
  Widget build(BuildContext context, ref) {
    final selectedSubMesh = ref.watch(header2StateNotifierProvider).mapOrNull(
          withModelSettings: (data) => data.submesh,
        );
    return DataDecorator(children: [
      GsfDataTile(label: 'attributes', data: mesh.attributes),
      GsfDataTile(label: 'guid', data: mesh.guid),
      AffineTransformationDisplay(transformation: mesh.transformation),
      GsfDataTile(label: 'unknown data', data: mesh.unknownData),
      if (mesh.skeletonIndex != null) ...[
        GsfDataTile(label: "skeleton index", data: mesh.skeletonIndex!),
      ],
      if (mesh.boneIds != null) ...[
        GsfDataTile(label: "bone ids", data: mesh.boneIds!),
      ],
      if (mesh.boneWeights != null) ...[
        GsfDataTile(label: "bone weights", data: mesh.boneWeights!),
      ],
      GsfDataTile(
          label: 'global bounding box offset',
          data: mesh.globalBoundingBoxOffset),
      GsfDataTile(label: 'unknown id', data: mesh.unknownId),
      BoundingBoxDisplay(
        boundingBox: mesh.boundingBox,
        bbName: "Global bounding box",
      ),
      GsfDataTile(label: 'submesh info count', data: mesh.submeshInfoCount),
      GsfDataTile(label: 'submesh info offset', data: mesh.submeshInfoOffset),
      GsfDataTile(label: 'submesh info 2 count', data: mesh.submeshInfo2Count),
      const Label.medium(
        "Submeshes",
        fontWeight: FontWeight.bold,
      ),
      PartSelector(
        value: selectedSubMesh,
        label: "submesh info",
        parts: mesh.submeshes,
        onSelected: (submesh) {
          ref
              .read(header2StateNotifierProvider.notifier)
              .setSubmesh(submesh as Submesh);
        },
      ),
      GsfDataTile(
          label: 'submesh materials offset', data: mesh.submeshMaterialsOffset),
      GsfDataTile(
          label: 'submesh materials count', data: mesh.submeshMaterialsCount),
      const Label.medium(
        "materials",
        fontWeight: FontWeight.bold,
      ),
      DataSelector(
        datas: mesh.materialIndices,
        relatedParts: materials,
        partFromDataFnct: (data, index) {
          // fallbaclTable is not null if we have some material indices
          return materials[
              fallbackTable!.usedMaterialIndexes[data.value].value];
        },
        onSelected: (_, material) {
          ref
              .read(header2StateNotifierProvider.notifier)
              .setMaterial(material as MaterialData);
        },
      ),
    ]);
  }
}

class ClothChunkDisplay extends ConsumerWidget {
  const ClothChunkDisplay({
    super.key,
    required this.cloth,
    required this.fallbackTable,
    required this.materials,
  });

  final ClothChunk cloth;
  final FallbackTable? fallbackTable;
  final List<MaterialData> materials;

  @override
  Widget build(BuildContext context, ref) {
    final selectedSubMesh = ref.watch(header2StateNotifierProvider).mapOrNull(
          withModelSettings: (data) => data.submesh,
        );
    return DataDecorator(children: [
      GsfDataTile(label: 'attributes', data: cloth.attributes),
      GsfDataTile(label: 'guid', data: cloth.guid),
      AffineTransformationDisplay(transformation: cloth.affineTransformation),
      GsfDataTile(label: 'unknown data', data: cloth.unknownData),
      if (cloth.skeletonIndex != null) ...[
        GsfDataTile(label: "skeleton index", data: cloth.skeletonIndex!),
      ],
      if (cloth.boneIds != null) ...[
        GsfDataTile(label: "bone ids", data: cloth.boneIds!),
      ],
      if (cloth.boneWeights != null) ...[
        GsfDataTile(label: "bone weights", data: cloth.boneWeights!),
      ],
      GsfDataTile(
          label: 'global bounding box offset',
          data: cloth.boundingBoxOffset),
      GsfDataTile(label: 'unknown offset', data: cloth.unknownOffset),
      GsfDataTile(label: 'unknown value', data: cloth.unknownValue),
      GsfDataTile(label: 'unknown offset 1', data: cloth.unknownOffset1),
      GsfDataTile(label: 'unknown value 2', data: cloth.unknownValue2),
      GsfDataTile(label: 'unknown offset 2', data: cloth.unknownOffset2),
      GsfDataTile(label: 'unknown value 3', data: cloth.unknownValue3),
      GsfDataTile(label: 'unknown offset 3', data: cloth.unknownOffset3),
      BoundingBoxDisplay(
        boundingBox: cloth.boundingBox,
        bbName: "Global bounding box",
      ),
      GsfDataTile(label: 'submesh info count', data: cloth.submeshCount),
      GsfDataTile(label: 'submesh info offset', data: cloth.submeshOffset),
      GsfDataTile(label: 'submesh info 2 count', data: cloth.submeshCount2),
      const Label.medium(
        "Submeshes",
        fontWeight: FontWeight.bold,
      ),
      PartSelector(
        value: selectedSubMesh,
        label: "submesh info",
        parts: cloth.submeshes,
        onSelected: (submesh) {
          ref
              .read(header2StateNotifierProvider.notifier)
              .setSubmesh(submesh as Submesh);
        },
      ),
      GsfDataTile(
          label: 'submesh materials offset', data: cloth.submeshMaterialsOffset),
      GsfDataTile(
          label: 'submesh materials count', data: cloth.submeshMaterialsCount),
      const Label.medium(
        "materials",
        fontWeight: FontWeight.bold,
      ),
      DataSelector(
        datas: cloth.materialIndices,
        relatedParts: materials,
        partFromDataFnct: (data, index) {
          // fallbaclTable is not null if we have some material indices
          return materials[
              fallbackTable!.usedMaterialIndexes[data.value].value];
        },
        onSelected: (_, material) {
          ref
              .read(header2StateNotifierProvider.notifier)
              .setMaterial(material as MaterialData);
        },
      ),
    ]);
  }
}

