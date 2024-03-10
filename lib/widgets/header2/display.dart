import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/chunk.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/cloth.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/mesh.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/fallback_table.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/material.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/materials_table.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/model_settings.dart';
import 'package:paraworld_gsf_viewer/providers/gsf.dart';
import 'package:paraworld_gsf_viewer/widgets/header2/providers.dart';
import 'package:paraworld_gsf_viewer/widgets/header2/state.dart';
import 'package:paraworld_gsf_viewer/widgets/header2/widgets/chunks/mesh.dart';
import 'package:paraworld_gsf_viewer/widgets/header2/widgets/chunks/submesh.dart';
import 'package:paraworld_gsf_viewer/widgets/header2/widgets/material.dart';
import 'package:paraworld_gsf_viewer/widgets/header2/widgets/model_settings.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/data_display.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/label.dart';
import 'package:paraworld_gsf_viewer/widgets/viewer/viewer.dart';

class Header2Display extends ConsumerWidget {
  const Header2Display({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final gsfState = ref.watch(gsfProvider);
    return gsfState.map(
      loading: (_) => const Loading(),
      error: (error) => Label.large('Error: $error',
          color: Colors.red, fontWeight: FontWeight.bold),
      data: (state) {
        if (state.value == null) {
          return const Empty();
        }
        return const _Data();
      },
    );
  }
}

class _Data extends ConsumerWidget {
  const _Data({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final state = ref.watch(header2StateNotifierProvider);
    if (state.header2 == null) {
      return const Empty();
    }
    final header2 = state.header2!;
    final List<Widget> variablePart = state.map(
      empty: (_) => [],
      withModelSettings: (data) => withModelSettings(data),
      withMaterial: (data) => withMaterial(data),
    );
    return DisplayWrapper(
      sideArea: variablePart,
      flexFactorSideArea: 3,
      mainArea: DataDecorator(children: [
        GsfDataTile(label: 'Models count', data: header2.modelsCount),
        GsfDataTile(label: 'Anim count', data: header2.animCount),
        GsfDataTile(
            label: 'Model settings offset', data: header2.modelSettingsOffset),
        GsfDataTile(
            label: 'Model settings count', data: header2.modelsSettingCount),
        PartSelector(
            value: state.mapOrNull(
              withModelSettings: (data) => data.modelSettings,
            ),
            label: 'Model settings',
            parts: header2.modelSettings,
            onSelected: (part) {
              ref
                  .read(header2StateNotifierProvider.notifier)
                  .setModelSettings(part as ModelSettings);
            }),
        GsfDataTile(
            label: 'Anim settings offset', data: header2.animSettingsOffset),
        GsfDataTile(
            label: 'Anim settings count', data: header2.animSettingsCount),
        const Label.large(
          "Material table",
          fontWeight: FontWeight.bold,
        ),
        _MaterialsTable(materialsTable: header2.materialsTable),
      ]),
    );
  }
}

class _MaterialsTable extends ConsumerWidget {
  const _MaterialsTable({
    super.key,
    required this.materialsTable,
  });

  final MaterialsTable materialsTable;

  @override
  Widget build(BuildContext context, ref) {
    final selected = ref.watch(header2StateNotifierProvider).maybeMap(
          withMaterial: (data) => data.material,
          withModelSettings: (data) => data.material,
          orElse: () => null,
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GsfDataTile(
          label: 'Useable materials count',
          data: materialsTable.materialCount,
          bold: true,
        ),
        GsfDataTile(
            label: 'Materials offset', data: materialsTable.materialOffset),
        GsfDataTile(
            label: 'Materials length', data: materialsTable.maxEntriesCount),
        PartSelector(
            value: selected,
            label: "materials",
            parts: materialsTable.materials
                .sublist(0, materialsTable.materialCount.value),
            onSelected: (material) {
              ref
                  .read(header2StateNotifierProvider.notifier)
                  .setMaterial(material as MaterialData);
            })
      ],
    );
  }
}

List<Widget> withModelSettings(Header2StateWithModelSettings state) {
  return [
    ModelSettingsDisplay(
        modelSettings: state.modelSettings,
        materialsTable: state.header2.materialsTable),
    if (state.objectName != null)
      ObjectNameDisplay(objectName: state.objectName!),
    if (state.chunk != null) ...[
      getChunkWidgetByType(state.chunk!, state.modelSettings.fallbackTable,
          state.header2.materialsTable.materials),
      if (state.chunk is MeshToModelInterface && state.submesh == null) ...[
        Flexible(
            child: Viewer(
          model: (state.chunk as MeshToModelInterface).toModel(),
        )),
      ],
      if (state.submesh != null) SubmeshDisplay(submesh: state.submesh!),
      if (state.material != null) MaterialDisplay(material: state.material!),
    ]
  ];
}

List<Widget> withMaterial(Header2StateWithMaterial state) {
  return [
    MaterialDisplay(material: state.material),
  ];
}

Widget getChunkWidgetByType(
    Chunk chunk, FallbackTable? fallbackTable, List<MaterialData> materials) {
  final Widget widget = () {
    switch (chunk.type) {
      case ChunkType.meshSkinnedSimple:
      case ChunkType.meshSkinned:
      case ChunkType.mesh:
        return MeshChunkDisplay(
          mesh: chunk as MeshChunk,
          fallbackTable: fallbackTable,
          materials: materials,
        );
      case ChunkType.clothSkinnedSimple:
      case ChunkType.clothSkinned:
      case ChunkType.cloth:
        return ClothChunkDisplay(
          cloth: chunk as ClothChunk,
          fallbackTable: fallbackTable,
          materials: materials,
        );
      default:
        return const SizedBox.shrink();
    }
  }();
  return widget;
}
