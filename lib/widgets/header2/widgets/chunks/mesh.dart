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
import 'package:paraworld_gsf_viewer/widgets/header2/widgets/chunks/attributes/chunk_attributes.dart';
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
          withModelSettings: (data) => data.selectedChunkState?.mapOrNull(
            withCloth: (cloth) => cloth.submesh,
            withMesh: (mesh) => mesh.submesh,
          ),
        );
    return DataDecorator(children: [
      GsfDataTile(label: 'Attributes', data: mesh.attributes),
      ChunkAttributesDisplay(attributes: mesh.attributes.value),
      GsfDataTile(label: 'Guid', data: mesh.guid),
      AffineTransformationDisplay(transformation: mesh.transformation),
      GsfDataTile(label: 'Unknown data', data: mesh.unknownData),
      if (mesh.skeletonIndex != null) ...[
        GsfDataTile(label: "Skeleton index", data: mesh.skeletonIndex!),
      ],
      if (mesh.boneIds != null) ...[
        GsfDataTile(label: "Bone ids", data: mesh.boneIds!),
      ],
      if (mesh.boneWeights != null) ...[
        GsfDataTile(label: "Bone weights", data: mesh.boneWeights!),
      ],
      GsfDataTile(
          label: 'Mesh bounding box offset',
          data: mesh.globalBoundingBoxOffset),
      GsfDataTile(label: 'Unknown data', data: mesh.unknownId),
      BoundingBoxDisplay(
        boundingBox: mesh.boundingBox,
        bbName: "Mesh bounding box",
      ),
      GsfDataTile(label: 'Submesh count', data: mesh.submeshInfoCount),
      GsfDataTile(label: 'Submesh table offset', data: mesh.submeshInfoOffset),
      GsfDataTile(label: 'Submesh count 2', data: mesh.submeshInfo2Count),
      const Label.medium(
        "Submeshes",
        isBold: true,
      ),
      PartSelector(
        value: selectedSubMesh,
        label: "Submesh info",
        parts: mesh.submeshes,
        onSelected: (submesh) {
          ref
              .read(header2StateNotifierProvider.notifier)
              .setSubmesh(submesh as Submesh);
        },
      ),
      GsfDataTile(
          label: 'Submesh materials offset', data: mesh.submeshMaterialsOffset),
      GsfDataTile(
          label: 'Submesh materials count', data: mesh.submeshMaterialsCount),
      const Label.medium(
        "Materials",
        isBold: true,
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
          withModelSettings: (data) => data.selectedChunkState?.mapOrNull(
            withCloth: (cloth) => cloth.submesh,
            withMesh: (mesh) => mesh.submesh,
          ),
        );
    return DataDecorator(children: [
      GsfDataTile(label: 'Attributes', data: cloth.attributes),
      ChunkAttributesDisplay(attributes: cloth.attributes.value),
      GsfDataTile(label: 'Guid', data: cloth.guid),
      AffineTransformationDisplay(transformation: cloth.affineTransformation),
      GsfDataTile(label: 'Unknown data', data: cloth.unknownData),
      if (cloth.skeletonIndex != null) ...[
        GsfDataTile(label: "Skeleton index", data: cloth.skeletonIndex!),
      ],
      if (cloth.boneIds != null) ...[
        GsfDataTile(label: "Bone ids", data: cloth.boneIds!),
      ],
      if (cloth.boneWeights != null) ...[
        GsfDataTile(label: "Bone weights", data: cloth.boneWeights!),
      ],
      GsfDataTile(
          label: 'Mesh bounding box offset', data: cloth.boundingBoxOffset),
      GsfDataTile(label: 'Unknown offset', data: cloth.unknownOffset),
      GsfDataTile(label: 'Unknown value', data: cloth.unknownValue),
      GsfDataTile(label: 'Unknown offset 1', data: cloth.unknownOffset1),
      GsfDataTile(label: 'Unknown value 2', data: cloth.unknownValue2),
      GsfDataTile(label: 'Unknown offset 2', data: cloth.unknownOffset2),
      GsfDataTile(label: 'Unknown value 3', data: cloth.unknownValue3),
      GsfDataTile(label: 'Unknown offset 3', data: cloth.unknownOffset3),
      BoundingBoxDisplay(
        boundingBox: cloth.boundingBox,
        bbName: "Mesh bounding box",
      ),
      GsfDataTile(label: 'Submesh count', data: cloth.submeshCount),
      GsfDataTile(label: 'Submesh table offset', data: cloth.submeshOffset),
      GsfDataTile(label: 'Submesh count 2', data: cloth.submeshCount2),
      const Label.medium(
        "Submeshes",
        isBold: true,
      ),
      PartSelector(
        value: selectedSubMesh,
        label: "Submesh info",
        parts: cloth.submeshes,
        onSelected: (submesh) {
          ref
              .read(header2StateNotifierProvider.notifier)
              .setSubmesh(submesh as Submesh);
        },
      ),
      GsfDataTile(
          label: 'Submesh materials offset',
          data: cloth.submeshMaterialsOffset),
      GsfDataTile(
          label: 'Submesh materials count', data: cloth.submeshMaterialsCount),
      const Label.medium(
        "Materials",
        isBold: true,
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
