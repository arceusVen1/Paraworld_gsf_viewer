import 'package:flutter/material.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header/sound_info.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/label.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/data_display.dart';

class SoundDisplay extends StatelessWidget {
  const SoundDisplay({super.key, required this.soundInfo});

  final SoundInfo soundInfo;

  @override
  Widget build(BuildContext context) {
    return DataDecorator(children: [
      const Label.large('Sound Info', isBold: true),
      GsfDataTile(label: 'Name', data: soundInfo.name),
      GsfDataTile(label: 'Start frame', data: soundInfo.startFrame),
      GsfDataTile(label: 'Volume', data: soundInfo.volume),
      GsfDataTile(label: 'Speed', data: soundInfo.speed),
      GsfDataTile(label: 'Unknown data 1', data: soundInfo.unknownData1),
      GsfDataTile(label: 'Unknown data 2', data: soundInfo.unknownData2),
      GsfDataTile(label: 'Unknown data 3', data: soundInfo.unknownData3),
      GsfDataTile(label: 'Unknown data 4', data: soundInfo.unknownData4),
      GsfDataTile(label: 'Sound group name', data: soundInfo.soundGroupName),
    ]);
  }
}
