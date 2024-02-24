import 'package:flutter/material.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/sound_info.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/label.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/data_display.dart';

class SoundDisplay extends StatelessWidget {
  const SoundDisplay({super.key, required this.soundInfo});

  final SoundInfo soundInfo;

  @override
  Widget build(BuildContext context) {
    return DataDecorator(children: [
      const Label.large('Sound Info', fontWeight: FontWeight.bold),
      GsfDataTile(label: 'Name', data: soundInfo.name),
      GsfDataTile(label: 'start frame', data: soundInfo.startFrame),
      GsfDataTile(label: 'volume', data: soundInfo.volume),
      GsfDataTile(label: 'speed', data: soundInfo.speed),
      GsfDataTile(label: 'unknown data', data: soundInfo.unknownData),
      GsfDataTile(label: 'sound group name', data: soundInfo.soundGroupName),
    ]);
  }
}
