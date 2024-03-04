import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/chunk.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks_table.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/model_settings.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/object_name.dart';
import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';
import 'package:paraworld_gsf_viewer/widgets/header2/providers.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/data_display.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/label.dart';

class ModelSettingsDisplay extends ConsumerWidget {
  const ModelSettingsDisplay({super.key, required this.modelSettings});

  final ModelSettings modelSettings;

  @override
  Widget build(BuildContext context, ref) {
    return DataDecorator(children: [
      GsfDataTile(
        label: 'object name offset',
        data: modelSettings.objectNameRelativeOffset,
        relatedPart: modelSettings.objectName,
        onSelected: (part) {
          ref
              .read(header2StateNotifierProvider.notifier)
              .setObjectName(part as ObjectName);
        },
      ),
      GsfDataTile(
          label: 'Chunks table offset',
          data: modelSettings.chunksTableRelativeOffset),
      GsfDataTile(label: 'Chunks table count', data: modelSettings.chunksCount),
      if (modelSettings.chunksTable != null)
        ChunksTableDisplay(chunksTable: modelSettings.chunksTable!),
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

class ObjectNameDisplay extends StatelessWidget {
  const ObjectNameDisplay({super.key, required this.objectName});

  final ObjectName objectName;

  @override
  Widget build(BuildContext context) {
    return DataDecorator(children: [
      GsfDataTile(label: 'String count', data: objectName.stringCount),
      GsfDataTile(
          label: 'Max characters count', data: objectName.maxCharactersCount),
      GsfDataTile(label: 'Name length', data: objectName.nameLength),
      GsfDataTile(label: 'True name', data: objectName.name),
      GsfDataTile(label: 'Unknown data', data: objectName.unknownData),
    ]);
  }
}

class ChunksTableDisplay extends StatelessWidget {
  const ChunksTableDisplay({
    super.key,
    required this.chunksTable,
  });

  final ChunksTable chunksTable;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Label.medium('Chunks table', fontWeight: FontWeight.bold),
        _ChunkOffsetSelector(
            offsets: chunksTable.chunksOffsets, chunks: chunksTable.chunks),
      ],
    );
  }
}

class _ChunkOffsetSelector extends ConsumerWidget {
  const _ChunkOffsetSelector({
    super.key,
    required this.offsets,
    required this.chunks,
  });

  final List<Standard4BytesData<SignedInt>> offsets;
  final List<Chunk> chunks;

  @override
  Widget build(BuildContext context, ref) {
    return DataSelector(
      datas: offsets,
      relatedParts: chunks,
      onSelected: (_, chunk) {
        ref
            .read(header2StateNotifierProvider.notifier)
            .setChunk(chunk as Chunk);
      },
    );
  }
}
