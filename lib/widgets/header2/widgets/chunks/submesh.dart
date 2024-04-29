import 'package:flutter/material.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/bounding_box.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/chunk_attributes.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/submesh.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/model_settings.dart';
import 'package:paraworld_gsf_viewer/classes/mesh.dart';
import 'package:paraworld_gsf_viewer/classes/model.dart';
import 'package:paraworld_gsf_viewer/widgets/header2/widgets/bounding_box.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/data_display.dart';
import 'package:paraworld_gsf_viewer/widgets/viewer/viewer.dart';

class SubmeshDisplay extends StatelessWidget {
  const SubmeshDisplay({
    super.key,
    required this.submesh,
    required this.boundingBox,
  });

  final Submesh submesh;
  final BoundingBox boundingBox;

  @override
  Widget build(BuildContext context) {
    final modelData = submesh.getMeshModelData(
      0,
      boundingBox.toModelBox(),
      null,
    );
    final Model model = Model(
      name: submesh.label,
      type: ModelType.none,
      meshes: [
        ModelMesh(
          submeshes: [
            ModelSubMesh(
              vertices: modelData.vertices,
              triangles: modelData.triangles,
              texture: null,
            ),
          ],
          attributes: ChunkAttributes.defaultValue(ModelType.unknown),
        )
      ],
      cloth: [],
      boundingBox: modelData.box,
      skeletons: [],
    );
    return Flexible(
      child: Column(
        children: [
          DataDecorator(children: [
            BoundingBoxDisplay(
                boundingBox: submesh.boundingBox,
                bbName: "Submesh bounding box"),
            GsfDataTile(label: "Vertex count", data: submesh.vertexCount),
            GsfDataTile(label: "Triangle count", data: submesh.triangleCount),
            GsfDataTile(label: "Vertex offset", data: submesh.vertexOffset),
            GsfDataTile(label: "Triangle offset", data: submesh.triangleOffset),
            GsfDataTile(
                label: "Triangle count 2", data: submesh.triangleCount2),
            GsfDataTile(label: "Vertex type", data: submesh.vertexType),
            GsfDataTile(
                label: "Light data offset", data: submesh.lightDataOffset),
            GsfDataTile(
                label: "Light data count", data: submesh.lightDataCount),
          ]),
          Flexible(
              child: Viewer(
            model: model,
            attributesFilter: model.meshes.first.attributes,
          )),
        ],
      ),
    );
  }
}
