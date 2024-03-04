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
      const Label.large('Dust Trail', fontWeight: FontWeight.bold),
      GsfDataTile(label: 'unknown data', data: dustTrailInfo.unknownData),
      GsfDataTile(label: 'name', data: dustTrailInfo.name),
      GsfDataTile(label: 'bone index (unsure)', data: dustTrailInfo.boneIndex),
      GsfDataTile(label: 'number of entries', data: dustTrailInfo.entryCount),
      if (dustTrailInfo.entries.isNotEmpty)
        for (var entry in dustTrailInfo.entries) ...[
          const Label.medium('Entry', fontWeight: FontWeight.bold),
          GsfDataTile(label: 'name', data: entry.name),
          GsfDataTile(label: 'length', data: entry.valueCharsLength),
          GsfDataTile(label: 'value', data: entry.valueChars),
        ],
    ]);
  }
}
