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
      GsfDataTile(label: 'Unknown data', data: soundInfo.unknownData1),
      GsfDataTile(label: 'Min fade distance', data: soundInfo.minFadeDistance),
      GsfDataTile(label: 'Max fade distance', data: soundInfo.maxFadeDistance),
      GsfDataTile(label: 'Max hearing distance', data: soundInfo.maxHearingDistance),
      GsfDataTile(label: 'Sound group name', data: soundInfo.soundGroupName),
    ]);
  }
}
