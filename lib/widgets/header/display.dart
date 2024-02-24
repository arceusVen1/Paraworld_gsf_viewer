import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header/dust_trail_info.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/gsf.dart';
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
      loading: (_) => const _Loading(),
      error: (error) => Label.large('Error: $error',
          color: Colors.red, fontWeight: FontWeight.bold),
      data: (state) {
        if (state.value == null) {
          return const _Empty();
        }
        final gsf = state.value!;
        return _Data(gsf: gsf);
      },
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Label.large('Please select a .gsf file.'));
  }
}

class _Loading extends StatelessWidget {
  const _Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
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
      withModelInfo: (data) => withModelInfo(data),
      withSound: (data) => withSoundInfo(data),
      withDustTrail: (data) => withDustTrail(data),
    );
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          DataDecorator(
            children: [
              const Label.large('Header', fontWeight: FontWeight.bold),
              GsfDataTile(
                  label: 'Content Table Offset',
                  data: header.contentTableOffset),
              GsfDataTile(label: 'Name Length', data: header.nameLength),
              GsfDataTile(label: 'Name', data: header.name),
              GsfDataTile(
                label: 'Model Count',
                data: header.modelCount,
                bold: true,
              ),
              ValueSelector(
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
                label: 'Sound Count',
                data: header.soundTable.soundCount,
                bold: true,
              ),
              if (header.soundTable.soundInfos.isNotEmpty)
                ValueSelector(
                  value: state.mapOrNull(
                    withSound: (data) => data.sound,
                  ),
                  label: 'select Sounds',
                  parts: header.soundTable.soundInfos,
                  onSelected: (part) => ref
                      .read(headerStateNotifierProvider.notifier)
                      .setSoundInfo(part as SoundInfo),
                ),
              GsfDataTile(
                label: 'Dust Trail Count',
                data: header.dustTrailTable.dustTrailCount,
                bold: true,
              ),
              if (header.dustTrailTable.dustTrailInfos.isNotEmpty)
                ValueSelector(
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
                label: 'Walk Transition Count',
                data: header.walkTransitionTable1.transitionCount,
                bold: true,
              ),
              ...header.walkTransitionTable1.transitionInfos
                  .map((part) => Label.regular(
                        'Walk Transition: ${part.name} (0x${part.offset.toRadixString(16)})',
                      ))
                  .toList(),
              GsfDataTile(
                label: 'Walk Transition 2 Count',
                data: header.walkTransitionTable2.transitionCount,
                bold: true,
              ),
              ...header.walkTransitionTable2.transitionInfos
                  .map((part) => Label.regular(
                        'Walk Transition: ${part.name} (0x${part.offset.toRadixString(16)})',
                      ))
                  .toList(),
            ],
          ),
          Flexible(flex: 3, child: Row(children: variablePart)),
        ],
      ),
    );
  }
}

List<Widget> withModelInfo(HeaderStateWithModelInfo state) {
  return [
    ModelInfoDisplay(
        modelInfo: state.modelInfo,
        modelAnim: state.modelAnim,
        walkSet: state.walkSet),
    state.modelAnim != null
        ? ModelAnimDisplay(modelAnim: state.modelAnim!)
        : const DataDecorator(children: []),
    state.walkSet != null
        ? WalkSetDisplay(walkSet: state.walkSet!)
        : const DataDecorator(children: []),
  ];
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
