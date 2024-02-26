import 'package:flutter/material.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/model_settings.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/data_display.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/label.dart';

class ModelSettingsDisplay extends StatelessWidget {
  const ModelSettingsDisplay({super.key, required this.modelSettings});

  final ModelSettings modelSettings;

  @override
  Widget build(BuildContext context) {
    return DataDecorator(children: [
      GsfDataTile(
          label: 'object name offset',
          data: modelSettings.objectNameRelativeOffset),
      GsfDataTile(
          label: 'Chunks table offset',
          data: modelSettings.chunksTableRelativeOffset),
      GsfDataTile(label: 'Chunks table count', data: modelSettings.chunksCount),
      GsfDataTile(
          label: 'Fallback table offset',
          data: modelSettings.fallbackTableRelativeOffset),
      GsfDataTile(label: 'Read data', data: modelSettings.readData),
      GsfDataTile(label: 'Unknown count', data: modelSettings.unknownCount),
      GsfDataTile(
          label: 'Additional effects count',
          data: modelSettings.additionalEffectsCount),
      GsfDataTile(
          label: 'Chunks count before links',
          data: modelSettings.chunksCountBeforeLinks),
      GsfDataTile(
        label: 'links count',
        data: modelSettings.linksCount,
      ),
      GsfDataTile(label: 'Unknown data', data: modelSettings.unknownData),
      GsfDataTile(label: 'Unknown data 2', data: modelSettings.unknownData2),
      GsfDataTile(label: 'Unused offset', data: modelSettings.unusedOffset),
      GsfDataTile(
          label: 'Path finder table offset',
          data: modelSettings.pathFinderTableOffset),
      Label.medium(
        'Bounding box',
        fontWeight: FontWeight.bold,
      ),
      Label.regular('x: ${modelSettings.boundingBox.x.toString()}'),
      Label.regular('y: ${modelSettings.boundingBox.y.toString()}'),
      Label.regular('z: ${modelSettings.boundingBox.z.toString()}'),
      GsfDataTile(
        label: 'Anim chunks table header offset',
        data: modelSettings.animChunksTableHeaderOffset,
      ),
      GsfDataTile(
        label: 'Anim object count',
        data: modelSettings.animObjectCount,
      ),
    ]);
  }
}
