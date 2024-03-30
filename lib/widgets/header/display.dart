import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header/dust_trail_info.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/gsf.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header/header.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header/model_info.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header/sound_info.dart';
import 'package:paraworld_gsf_viewer/providers/gsf.dart';
import 'package:paraworld_gsf_viewer/widgets/header/widgets/dust_trail.dart';
import 'package:paraworld_gsf_viewer/widgets/header/widgets/model_infos.dart';
import 'package:paraworld_gsf_viewer/widgets/header/providers.dart';
import 'package:paraworld_gsf_viewer/widgets/header/widgets/sound.dart';
import 'package:paraworld_gsf_viewer/widgets/header/state.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/label.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/data_display.dart';

class HeaderDisplay extends ConsumerWidget {
  const HeaderDisplay({super.key});

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
        final gsf = state.value!;
        return _Data(gsf: gsf);
      },
    );
  }
}

class _Data extends ConsumerWidget {
  const _Data({super.key, required this.gsf});

  final GSF gsf;

  @override
  Widget build(BuildContext context, ref) {
    final header = gsf.header;
    final state = ref.watch(headerStateNotifierProvider);
    final List<Widget> variablePart = state.map(
      empty: (_) => [
        const SizedBox.shrink(),
      ],
      withModelInfo: (data) => withModelInfo(data, gsf.header),
      withSound: (data) => withSoundInfo(data),
      withDustTrail: (data) => withDustTrail(data),
    );
    return DisplayWrapper(
      flexFactorSideArea: 3,
      sideArea: variablePart,
      mainArea: DataDecorator(
        children: [
          GsfDataTile(
              label: 'Header offset', data: header.header2Offset),
          GsfDataTile(label: 'GSF name length', data: header.nameLength),
          GsfDataTile(label: 'GSF name', data: header.name),
          GsfDataTile(
            label: 'Model count',
            data: header.modelCount,
            bold: true,
          ),
          PartSelector(
            value: state.mapOrNull(
              withModelInfo: (data) => data.modelInfo,
            ),
            label: 'select Model Infos',
            parts: header.modelInfos,
            onSelected: (part) => ref
                .read(headerStateNotifierProvider.notifier)
                .setModelInfo(part as ModelInfo),
          ),
          GsfDataTile(
            label: 'Sound count',
            data: header.soundTable.soundCount,
            bold: true,
          ),
          if (header.soundTable.soundInfos.isNotEmpty)
            PartSelector(
              value: state.mapOrNull(
                withSound: (data) => data.sound,
                withModelInfo: (value) => value.selectedSoundInfo,
              ),
              label: 'select Sounds',
              parts: header.soundTable.soundInfos,
              onSelected: (part) => ref
                  .read(headerStateNotifierProvider.notifier)
                  .setSoundInfo(part as SoundInfo),
            ),
          GsfDataTile(
            label: 'Dust trail count',
            data: header.dustTrailTable.dustTrailCount,
            bold: true,
          ),
          if (header.dustTrailTable.dustTrailInfos.isNotEmpty)
            PartSelector(
              value: state.mapOrNull(
                withDustTrail: (data) => data.dustTrailInfo,
              ),
              label: 'select Dust Trails',
              parts: header.dustTrailTable.dustTrailInfos,
              onSelected: (part) => ref
                  .read(headerStateNotifierProvider.notifier)
                  .setDustTrailInfo(part as DustTrailInfo),
            ),
          GsfDataTile(
            label: 'Anim flags count ',
            data: header.animFlagsCount,
            bold: true,
          ),
          ...header.animFlagsTables
              .map((part) => Label.regular(
                    'Flag name: ${part.name} (0x${part.offset.toRadixString(16)})',
                  ))
              .toList(),
          GsfDataTile(
            label: 'Walk transitions count',
            data: header.walkTransitionsCount,
            bold: true,
          ),
          ...header.walkTransitionTables
              .map((part) => Label.regular(
                    'Walk transition name: ${part.name} (0x${part.offset.toRadixString(16)})',
                  ))
              .toList(),
        ],
      ),
    );
  }
}

List<Widget> withModelInfo(HeaderStateWithModelInfo state, Header header) {
  return [
    ModelInfoDisplay(
      modelInfo: state.modelInfo,
      modelAnim: state.modelAnim,
      walkSet: state.walkSet,
    ),
    Flexible(
      child: Column(
        children: [
          state.modelAnim != null
              ? ModelAnimDisplay(
                  selectedModelAnim: state.modelAnim!,
                  soundTable: header.soundTable,
                )
              : const DataDecorator(children: []),
          _SelectedData(selectedSounInfo: state.selectedSoundInfo)
        ],
      ),
    ),
    state.walkSet != null
        ? WalkSetDisplay(
            selectedWalkSet: state.walkSet!,
            modelAnims: state.modelInfo.modelAnims,
            walkTransitions: header.walkTransitionTables,
          )
        : const DataDecorator(children: []),
  ];
}

class _SelectedData extends StatelessWidget {
  const _SelectedData({super.key, required this.selectedSounInfo});

  final SoundInfo? selectedSounInfo;

  @override
  Widget build(BuildContext context) {
    return selectedSounInfo != null
        ? SoundDisplay(soundInfo: selectedSounInfo!)
        : const DataDecorator(children: []);
  }
}

List<Widget> withSoundInfo(HeaderStateWithSound state) {
  return [
    SoundDisplay(soundInfo: state.sound),
  ];
}

List<Widget> withDustTrail(HeaderStateWithDustTrail state) {
  return [
    DustTrailDisplay(dustTrailInfo: state.dustTrailInfo),
  ];
}
