import 'package:flutter/material.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/bone_link.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/data_display.dart';

class BoneLinkDisplay extends StatelessWidget {
  const BoneLinkDisplay({super.key, required this.boneLink});

  final BoneLinkChunk boneLink;
  
  @override
  Widget build(BuildContext context) {
    return DataDecorator(children: [
      GsfDataTile(label: "attributes", data: boneLink.attributes),
      GsfDataTile(label: "guid", data: boneLink.guid),
       GsfDataTile(label: "Position X", data: boneLink.positionX),
      GsfDataTile(label: "Position Y", data: boneLink.positionY),
      GsfDataTile(label: "Position Z", data: boneLink.positionZ),
      GsfDataTile(label: "Quaternion L", data: boneLink.quaternionL),
      GsfDataTile(label: "Quaternion I", data: boneLink.quaternionI),
      GsfDataTile(label: "Quaternion J", data: boneLink.quaternionJ),
      GsfDataTile(label: "Quaternion K", data: boneLink.quaternionK),
      GsfDataTile(label: "FourCC link", data: boneLink.fourccLink),
      GsfDataTile(label: "Skeleton index", data: boneLink.skeletonIndex),
      GsfDataTile(label: "Bone ids", data: boneLink.boneIds),
      GsfDataTile(label: "Bone weights", data: boneLink.boneWeights),
    ]);
  }
}