import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/fallback_table.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/material.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/materials_table.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/model_settings.dart';
import 'package:paraworld_gsf_viewer/providers/gsf.dart';
import 'package:paraworld_gsf_viewer/widgets/header2/providers.dart';
import 'package:paraworld_gsf_viewer/widgets/header2/state.dart';
import 'package:paraworld_gsf_viewer/widgets/header2/widgets/chunks/link.dart';
import 'package:paraworld_gsf_viewer/widgets/header2/widgets/chunks/mesh.dart';
import 'package:paraworld_gsf_viewer/widgets/header2/widgets/chunks/skeleton.dart';
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
      error: (error) => Label.large(
        'Error: $error',
        color: Color(0xffd73d33),
        isBold: true,
      ),
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
          isBold: true,
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
    final selectedMaterial = ref.watch(header2StateNotifierProvider).maybeMap(
          withMaterial: (data) => data.material,
          withModelSettings: (data) => data.selectedChunkState?.mapOrNull(
            withMesh: (mesh) => mesh.material,
            withCloth: (cloth) => cloth.material,
          ),
          orElse: () => null,
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GsfDataTile(label: 'Used materials count', data: materialsTable.materialCount),
        GsfDataTile(
            label: 'Materials offset', data: materialsTable.materialOffset),
        GsfDataTile(
            label: 'Max materials count', data: materialsTable.maxEntriesCount),
        PartSelector(
            value: selectedMaterial,
            label: "Materials",
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
    if (state.selectedChunkState != null)
      ...getChunkWidgetByType(
        state.selectedChunkState!,
        state.modelSettings.fallbackTable,
        state.header2.materialsTable.materials,
      ),
  ];
}

List<Widget> withMaterial(Header2StateWithMaterial state) {
  return [
    MaterialDisplay(material: state.material),
  ];
}

List<Widget> getChunkWidgetByType(SelectedChunkState chunkState,
    FallbackTable? fallbackTable, List<MaterialData> materials) {
  final List<Widget> widgets = () {
    return chunkState.maybeMap(
      withMesh: (data) => [
        MeshChunkDisplay(
          mesh: data.mesh,
          fallbackTable: fallbackTable,
          materials: materials,
        ),
        data.submesh != null
            ? SubmeshDisplay(
                submesh: data.submesh!,
                boundingBox: data.mesh.boundingBox,
              )
            : Flexible(
                child: Viewer(
                  model: data.mesh.toModel(),
                ),
              ),
        if (data.material != null) MaterialDisplay(material: data.material!),
      ],
      withCloth: (data) => [
        ClothChunkDisplay(
          cloth: data.cloth,
          fallbackTable: fallbackTable,
          materials: materials,
        ),
        data.submesh != null
            ? SubmeshDisplay(
                submesh: data.submesh!,
                boundingBox: data.cloth.boundingBox,
              )
            : Flexible(
                child: Viewer(
                  model: data.cloth.toModel(),
                ),
              ),
        if (data.material != null) MaterialDisplay(material: data.material!),
      ],
      withSkeleton: (data) => [
        SkeletonDisplay(skeleton: data.skeleton),
        if (data.bone != null) BoneDisplay(bone: data.bone!),
      ],
      withLink: (data) => [LinkDisplay(link: data.linkChunk)],
      orElse: () => [const SizedBox.shrink()],
    );
  }();
  return widgets;
}
