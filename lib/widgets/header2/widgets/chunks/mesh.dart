import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/chunk.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/mesh.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/submesh.dart';
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
    required this.materials,
  });

  final MeshChunk mesh;
  final List<MaterialData> materials;

  @override
  Widget build(BuildContext context, ref) {
    return DataDecorator(children: [
      GsfDataTile(label: 'attributes', data: mesh.attributes),
      GsfDataTile(label: 'guid', data: mesh.guid),
      AffineTransformationDisplay(transformation: mesh.transformation),
      GsfDataTile(label: 'unknown data', data: mesh.unknownData),
      if (mesh.type == ChunkType.meshSkinned && mesh.skeletonIndex != null) ...[
        GsfDataTile(label: "skeleton index", data: mesh.skeletonIndex!),
      ],
      GsfDataTile(
          label: 'global bounding box offset',
          data: mesh.globalBoundingBoxOffset),
      GsfDataTile(label: 'unknown id', data: mesh.unknownId),
      const Label.medium(
        "Global bounding box",
        fontWeight: FontWeight.bold,
      ),
      BoundingBoxDisplay(boundingBox: mesh.globalBoundingBox),
      GsfDataTile(label: 'submesh info count', data: mesh.submeshInfoCount),
      GsfDataTile(label: 'submesh info offset', data: mesh.submeshInfoOffset),
      GsfDataTile(label: 'submesh info 2 count', data: mesh.submeshInfo2Count),
      const Label.medium(
        "Submeshes",
        fontWeight: FontWeight.bold,
      ),
      PartSelector(
        value: ref.watch(header2StateNotifierProvider).mapOrNull(
              withModelSettings: (data) => data.submesh,
            ),
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
        onSelected: (_, material) {
          ref
              .read(header2StateNotifierProvider.notifier)
              .setMaterial(material as MaterialData);
        },
      ),
    ]);
  }
}
