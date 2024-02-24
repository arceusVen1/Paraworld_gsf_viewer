import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header/model_anim.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header/model_info.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header/walk_set.dart';
import 'package:paraworld_gsf_viewer/widgets/header/providers.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/label.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/data_display.dart';

class ModelInfoDisplay extends ConsumerWidget {
  const ModelInfoDisplay({
    super.key,
    required this.modelInfo,
    this.modelAnim,
    this.walkSet,
  });

  final ModelInfo modelInfo;
  final ModelAnim? modelAnim;
  final WalkSet? walkSet;

  @override
  Widget build(BuildContext context, ref) {
    final state = ref.watch(headerStateNotifierProvider).mapOrNull(
          withModelInfo: (data) => data,
        );
    if (state == null) {
      return const SizedBox.shrink();
    }
    return DataDecorator(
      children: [
        const Label.large('Model Info', fontWeight: FontWeight.bold),
        GsfDataTile(label: 'Name', data: modelInfo.name),
        GsfDataTile(label: 'Index', data: modelInfo.index),
        GsfDataTile(label: 'Anim Count', data: modelInfo.animCount),
        if (modelInfo.modelAnims.isNotEmpty)
          ValueSelector(
            value: state.modelAnim,
            label: 'select Model Anims',
            parts: modelInfo.modelAnims,
            onSelected: (part) => ref
                .read(headerStateNotifierProvider.notifier)
                .setModelAnim(part as ModelAnim),
          ),
        GsfDataTile(
            label: 'Walk Set count', data: modelInfo.walkSetTable.count),
        if (modelInfo.walkSetTable.walkSets.isNotEmpty)
          ValueSelector(
            value: state.walkSet,
            label: 'select Walk Sets',
            parts: modelInfo.walkSetTable.walkSets,
            onSelected: (part) => ref
                .read(headerStateNotifierProvider.notifier)
                .setWalkSet(part as WalkSet),
          ),
      ],
    );
  }
}

class ModelAnimDisplay extends StatelessWidget {
  const ModelAnimDisplay({
    super.key,
    required this.modelAnim,
  });

  final ModelAnim modelAnim;

  @override
  Widget build(BuildContext context) {
    return DataDecorator(
      children: [
        const Label.large('Model Anim', fontWeight: FontWeight.bold),
        GsfDataTile(label: 'Name', data: modelAnim.name),
        GsfDataTile(label: 'index', data: modelAnim.index),
        GsfDataTile(label: 'Sound count', data: modelAnim.soundIndices.count),
        ...modelAnim.soundIndices.indices.map(
          (e) => GsfDataTile(label: 'sound index', data: e),
        ),
        GsfDataTile(label: "unknown", data: modelAnim.unknownData),
      ],
    );
  }
}

class WalkSetDisplay extends StatelessWidget {
  const WalkSetDisplay({
    super.key,
    required this.walkSet,
  });

  final WalkSet walkSet;

  @override
  Widget build(BuildContext context) {
    return DataDecorator(
      children: [
        const Label.large('Walk Set', fontWeight: FontWeight.bold),
        GsfDataTile(label: 'Name', data: walkSet.name),
        GsfDataTile(label: 'walk_1', data: walkSet.walk1PosData),
        GsfDataTile(label: 'walk_2', data: walkSet.walk2PosData),
        GsfDataTile(label: 'walk_3', data: walkSet.walk3PosData),
        GsfDataTile(label: 'walk_4', data: walkSet.walk4PosData),
        GsfDataTile(label: 'walk_1_end_s', data: walkSet.walk1endSData),
        GsfDataTile(label: 'walk_1_end_m', data: walkSet.walk1endMData),
        GsfDataTile(label: 'walk_1_end_L', data: walkSet.walk1endLData),
        GsfDataTile(label: 'walk_2_end_s', data: walkSet.walk2endSData),
        GsfDataTile(label: 'walk_2_end_m', data: walkSet.walk2endMData),
        GsfDataTile(label: 'walk_2_end_L', data: walkSet.walk2endLData),
        GsfDataTile(label: 'walk_3_end_s', data: walkSet.walk3endSData),
        GsfDataTile(label: 'walk_3_end_m', data: walkSet.walk3endMData),
        GsfDataTile(label: 'walk_3_end_L', data: walkSet.walk3endLData),
        GsfDataTile(label: 'walk_4_end_s', data: walkSet.walk4endSData),
        GsfDataTile(label: 'walk_4_end_m', data: walkSet.walk4endMData),
        GsfDataTile(label: 'walk_4_end_L', data: walkSet.walk4endLData),
        GsfDataTile(
            label: 'standing turn right', data: walkSet.standingTurnRightData),
        GsfDataTile(
            label: 'standing turn left', data: walkSet.standingTurnLeftData),
        GsfDataTile(label: 'unknown data', data: walkSet.unknownData),
        GsfDataTile(label: 'accel_1_2', data: walkSet.accel1To2Data),
        GsfDataTile(label: 'accel_2_3', data: walkSet.accel2To3Data),
        GsfDataTile(label: 'accel_3_4', data: walkSet.accel3To4Data),
        GsfDataTile(label: 'brake_4_3', data: walkSet.brake4To3Data),
        GsfDataTile(label: 'brake_3_2', data: walkSet.brake3To2Data),
        GsfDataTile(label: 'brake_2_1', data: walkSet.brake2To1Data),
        GsfDataTile(label: 'walk left', data: walkSet.walkLeftData),
        GsfDataTile(label: 'walk right', data: walkSet.walkRightData),
        GsfDataTile(label: 'unknown data 2', data: walkSet.unknownData2),
        GsfDataTile(
            label: 'walk_transition_index',
            data: walkSet.walkTransitionIndexData),
        GsfDataTile(label: 'growup', data: walkSet.growUpData),
        GsfDataTile(label: 'sail up', data: walkSet.sailUpData),
        GsfDataTile(label: 'sail down', data: walkSet.sailDownData),
        GsfDataTile(label: 'standanim', data: walkSet.standAnimData),
        GsfDataTile(label: 'walk to swim', data: walkSet.walkToSwimData),
        GsfDataTile(label: 'unknown data 3', data: walkSet.unknownData3),
        GsfDataTile(label: 'unknown data 4', data: walkSet.unknownData4),
      ],
    );
  }
}
