import 'package:flutter/material.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header/dust_trail_info.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/label.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/data_display.dart';

class DustTrailDisplay extends StatelessWidget {
  const DustTrailDisplay({Key? key, required this.dustTrailInfo})
      : super(key: key);

  final DustTrailInfo dustTrailInfo;

  @override
  Widget build(BuildContext context) {
    return DataDecorator(children: [
      const Label.large('Dust Trail', isBold: true),
      GsfDataTile(label: 'Unknown data', data: dustTrailInfo.unknownData),
      GsfDataTile(label: 'Name', data: dustTrailInfo.name),
      GsfDataTile(label: 'Bone index?', data: dustTrailInfo.boneIndex),
      GsfDataTile(label: 'Entries count', data: dustTrailInfo.entryCount),
      if (dustTrailInfo.entries.isNotEmpty)
        for (var entry in dustTrailInfo.entries) ...[
          const Label.medium('Entry', isBold: true),
          GsfDataTile(label: 'Name', data: entry.name),
          GsfDataTile(label: 'Length', data: entry.valueCharsLength),
          GsfDataTile(label: 'Value', data: entry.valueChars),
        ],
    ]);
  }
}
