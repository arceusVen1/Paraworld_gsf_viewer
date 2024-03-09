import 'package:flutter/material.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/submesh.dart';
import 'package:paraworld_gsf_viewer/classes/model.dart';
import 'package:paraworld_gsf_viewer/widgets/header2/widgets/bounding_box.dart';
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
    final modelData = submesh.getMeshModelData(0, null);
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
            BoundingBoxDisplay(
                boundingBox: submesh.boundingBox,
                bbName: "Submesh bounding box"),
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
