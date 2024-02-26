import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/model_settings.dart';
import 'package:paraworld_gsf_viewer/providers/gsf.dart';
import 'package:paraworld_gsf_viewer/widgets/header2/providers.dart';
import 'package:paraworld_gsf_viewer/widgets/header2/state.dart';
import 'package:paraworld_gsf_viewer/widgets/header2/widgets/model_settings.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/data_display.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/label.dart';

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
      ]),
    );
  }
}

List<Widget> withModelSettings(Header2StateWithModelSettings state) {
  return [
    ModelSettingsDisplay(modelSettings: state.modelSettings),
  ];
}
