import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/mesh.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/submesh.dart';
import 'package:paraworld_gsf_viewer/widgets/header2/providers.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/data_display.dart';

class MeshChunkDisplay extends ConsumerWidget {
  const MeshChunkDisplay({
    super.key,
    required this.mesh,
  });

  final MeshChunk mesh;

  @override
  Widget build(BuildContext context, ref) {
    return DataDecorator(children: [
      GsfDataTile(label: 'attributes', data: mesh.attributes),
      GsfDataTile(label: 'guid', data: mesh.guid),
      GsfDataTile(label: 'scale X', data: mesh.scaleX),
      GsfDataTile(label: 'stretch Y', data: mesh.stretchY),
      GsfDataTile(label: 'stretch Z_X', data: mesh.stretchZX),
      GsfDataTile(label: 'unknown float', data: mesh.unknownFloat1),
      GsfDataTile(label: 'stretch X', data: mesh.stretchX),
      GsfDataTile(label: 'scale Y', data: mesh.scaleY),
      GsfDataTile(label: 'stretch Z_Y', data: mesh.stretchZY),
      GsfDataTile(label: 'unknown float 2', data: mesh.unknownFloat2),
      GsfDataTile(label: 'shear X', data: mesh.shearX),
      GsfDataTile(label: 'shear Y', data: mesh.shearY),
      GsfDataTile(label: 'scale Z', data: mesh.scaleZ),
      GsfDataTile(label: 'unknow float 3', data: mesh.unknownFloat3),
      GsfDataTile(label: 'position X', data: mesh.positionX),
      GsfDataTile(label: 'position Y', data: mesh.positionY),
      GsfDataTile(label: 'position Z', data: mesh.positionZ),
      GsfDataTile(label: 'unknown float 4', data: mesh.unknownFloat4),
      GsfDataTile(label: 'unknown data', data: mesh.unknownData),
      GsfDataTile(
          label: 'global bounding box offset',
          data: mesh.globalBoundingBoxOffset),
      GsfDataTile(label: 'unknown id', data: mesh.unknownId),
      GsfDataTile(
          label: 'global bounding box min X', data: mesh.globalBBoxMinX),
      GsfDataTile(
          label: 'global bounding box min Y', data: mesh.globalBBoxMinY),
      GsfDataTile(
          label: 'global bounding box min Z', data: mesh.globalBBoxMinZ),
      GsfDataTile(
          label: 'global bounding box max X', data: mesh.globalBBoxMaxX),
      GsfDataTile(
          label: 'global bounding box max Y', data: mesh.globalBBoxMaxY),
      GsfDataTile(
          label: 'global bounding box max Z', data: mesh.globalBBoxMaxZ),
      GsfDataTile(label: 'submesh info count', data: mesh.submeshInfoCount),
      GsfDataTile(label: 'submesh info offset', data: mesh.submeshInfoOffset),
      GsfDataTile(label: 'submesh info 2 count', data: mesh.submeshInfo2Count),
      GsfDataTile(
          label: 'submesh materials offset', data: mesh.submeshMaterialsOffset),
      GsfDataTile(
          label: 'submesh materials count', data: mesh.submeshMaterialsCount),
      PartSelector(
        label: "submesh info",
        parts: mesh.submeshes,
        onSelected: (submesh) {
          ref
              .read(header2StateNotifierProvider.notifier)
              .setSubmesh(submesh as Submesh);
        },
      ),
    ]);
  }
}
