import 'package:flutter/material.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/submesh.dart';
import 'package:paraworld_gsf_viewer/classes/model.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/data_display.dart';
import 'package:paraworld_gsf_viewer/widgets/viewer/viewer.dart';

class SubmeshDisplay extends StatelessWidget {
  const SubmeshDisplay({
    super.key,
    required this.submesh,
  });

  final Submesh submesh;

  @override
  Widget build(BuildContext context) {
    final modelData = submesh.getMeshModelData();
    final Model model = Model(
      name: "submesh",
      vertices: modelData.vertices,
      triangles: modelData.triangles,
      boundingBox: modelData.box,
    );
    return Flexible(
      child: Column(
        children: [
          DataDecorator(children: [
            GsfDataTile(label: "bbox min X", data: submesh.boundingBoxMinX),
            GsfDataTile(label: "bbox min Y", data: submesh.boundingBoxMinY),
            GsfDataTile(label: "bbox min Z", data: submesh.boundingBoxMinZ),
            GsfDataTile(label: "bbox max X", data: submesh.boundingBoxMaxX),
            GsfDataTile(label: "bbox max Y", data: submesh.boundingBoxMaxY),
            GsfDataTile(label: "bbox max Z", data: submesh.boundingBoxMaxZ),
            GsfDataTile(label: "vertex count", data: submesh.vertexCount),
            GsfDataTile(label: "triangle count", data: submesh.triangleCount),
            GsfDataTile(label: "vertex offset", data: submesh.vertexOffset),
            GsfDataTile(label: "triangle offset", data: submesh.triangleOffset),
            GsfDataTile(
                label: "triangle count 2", data: submesh.triangleCount2),
            GsfDataTile(label: "vertex type", data: submesh.vertexType),
            GsfDataTile(
                label: "light data offset", data: submesh.lightDataOffset),
            GsfDataTile(
                label: "light data count", data: submesh.lightDataCount),
          ]),
          Flexible(
              child: Viewer(
            model: model,
          )),
        ],
      ),
    );
  }
}
