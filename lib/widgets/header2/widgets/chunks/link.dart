import 'package:flutter/material.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/link.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/data_display.dart';

class LinkDisplay extends StatelessWidget {
  const LinkDisplay({super.key, required this.link});

  final LinkChunk link;

  @override
  Widget build(BuildContext context) {
    return DataDecorator(children: [
      GsfDataTile(label: "attributes", data: link.attributes),
      GsfDataTile(label: "guid", data: link.guid),
      GsfDataTile(label: "Position X", data: link.positionX),
      GsfDataTile(label: "Position Y", data: link.positionY),
      GsfDataTile(label: "Position Z", data: link.positionZ),
      GsfDataTile(label: "Quaternion L", data: link.quaternionL),
      GsfDataTile(label: "Quaternion I", data: link.quaternionI),
      GsfDataTile(label: "Quaternion J", data: link.quaternionJ),
      GsfDataTile(label: "Quaternion K", data: link.quaternionK),
      GsfDataTile(label: "FourCC link", data: link.fourccLink),
      if (link.skeletonIndex != null)
        GsfDataTile(label: "Skeleton index", data: link.skeletonIndex!),
      if (link.boneIds != null)
        GsfDataTile(label: "Bone ids", data: link.boneIds!),
      if (link.boneWeights != null)
        GsfDataTile(label: "Bone weights", data: link.boneWeights!),
    ]);
  }
}
