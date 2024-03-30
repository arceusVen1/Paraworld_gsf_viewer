import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/chunk.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks_table.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/fallback_table.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/material.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/materials_table.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/model_settings.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/object_name.dart';
import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';
import 'package:paraworld_gsf_viewer/widgets/header2/providers.dart';
import 'package:paraworld_gsf_viewer/widgets/header2/widgets/bounding_box.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/data_display.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/divider.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/label.dart';

class ModelSettingsDisplay extends ConsumerWidget {
  const ModelSettingsDisplay({
    super.key,
    required this.modelSettings,
    required this.materialsTable,
  });

  final ModelSettings modelSettings;
  final MaterialsTable materialsTable;

  @override
  Widget build(BuildContext context, ref) {
    return DataDecorator(children: [
      GsfDataTile(
        label: 'Object name offset',
        data: modelSettings.objectNameRelativeOffset,
        relatedPart: modelSettings.objectName,
        onSelected: (part) {
          ref
              .read(header2StateNotifierProvider.notifier)
              .setObjectName(part as ObjectName);
        },
      ),
      GsfDataTile(
        label: 'bReadData',
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
        label: 'Links count',
        data: modelSettings.linkChunksCount,
      ),
      GsfDataTile(
        label: 'bMisc chunk exists',
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
          label: 'Chunks table offset',
          data: modelSettings.chunksTableRelativeOffset),
      GsfDataTile(
        label: 'Chunks count',
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
      if (modelSettings.fallbackTable != null)
        _FallbackTableDisplay(
          fallbackTable: modelSettings.fallbackTable!,
          materialsTable: materialsTable,
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
        const Label.medium(
          'Chunks table',
          isBold: true,
        ),
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

class _FallbackTableDisplay extends ConsumerWidget {
  const _FallbackTableDisplay({
    super.key,
    required this.fallbackTable,
    required this.materialsTable,
  });

  final FallbackTable fallbackTable;
  final MaterialsTable materialsTable;

  @override
  Widget build(BuildContext context, ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ThemedDivider(),
        const Label.medium('Fallback table', isBold: true),
        GsfDataTile(
            label: "Header 2 offset", data: fallbackTable.header2Offset),
        GsfDataTile(
            label: "Model settings offset",
            data: fallbackTable.modelSettingsOffset),
        GsfDataTile(label: "Unknown count", data: fallbackTable.unknownInt),
        GsfDataTile(
            label: "Used materials count",
            data: fallbackTable.usedMaterialsCount),
        GsfDataTile(label: "Unknown count 2", data: fallbackTable.unknownInt2),
        DataSelector(
          datas: fallbackTable.usedMaterialIndexes,
          relatedParts: materialsTable.materials,
          partFromDataFnct: (data, index) {
            return materialsTable.materials[data.value];
          },
          onSelected: (index, material) {
            ref
                .read(header2StateNotifierProvider.notifier)
                .setMaterial(material as MaterialData);
          },
        ),
        const ThemedDivider(),
      ],
    );
  }
}
