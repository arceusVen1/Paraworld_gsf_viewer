import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/chunk.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks_table.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/model_settings.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/object_name.dart';
import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';
import 'package:paraworld_gsf_viewer/widgets/header2/providers.dart';
import 'package:paraworld_gsf_viewer/widgets/header2/widgets/bounding_box.dart';
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
      GsfDataTile(
        label: 'Chunks table count',
        data: modelSettings.chunksCount,
      ),
      if (modelSettings.chunksTable != null)
        ChunksTableDisplay(
          chunksTable: modelSettings.chunksTable!,
        ),
      GsfDataTile(
        label: 'Fallback table offset',
        data: modelSettings.fallbackTableRelativeOffset,
      ),
      GsfDataTile(
        label: 'Read data',
        data: modelSettings.readData,
      ),
      GsfDataTile(
          label: 'First particle chunk index',
          data: modelSettings.firstParticleChunkIndex),
      GsfDataTile(
          label: 'Particle chunks count',
          data: modelSettings.particleChunksCount),
      GsfDataTile(
          label: 'First link chunk index',
          data: modelSettings.firstLinkChunkIndex),
      GsfDataTile(
        label: 'links count',
        data: modelSettings.linkChunksCount,
      ),
      GsfDataTile(
        label: 'Misc chunk exists flag',
        data: modelSettings.miscChunkExistsFlag,
      ),
      GsfDataTile(
        label: 'Skeleton chunks count',
        data: modelSettings.skeletonChunksCount,
      ),
      GsfDataTile(
        label: 'Collision physics chunks count',
        data: modelSettings.collysionPhycicsChunksCount,
      ),
      GsfDataTile(
        label: 'Cloth chunks count',
        data: modelSettings.clothChunksCount,
      ),
      GsfDataTile(
        label: 'First selection volume chunk index',
        data: modelSettings.firstSelectionVolumeChunkIndex,
      ),
      GsfDataTile(
        label: 'Selection volume chunks count',
        data: modelSettings.selectionVolumeChunksCount,
      ),
      GsfDataTile(
        label: 'Speedline chunks count',
        data: modelSettings.speedlineChunksCount,
      ),
      GsfDataTile(label: 'Unused offset', data: modelSettings.unusedOffset),
      GsfDataTile(
          label: 'Path finder table offset',
          data: modelSettings.pathFinderTableOffset),
      BoundingBoxDisplay(
        boundingBox: modelSettings.boundingBox,
      ),
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
