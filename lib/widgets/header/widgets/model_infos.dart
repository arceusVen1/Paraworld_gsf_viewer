import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header/model_anim.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header/model_info.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header/sound_info.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header/sound_table.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header/walk_set.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header/walk_transition_table.dart';
import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';
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

class ModelAnimDisplay extends ConsumerWidget {
  const ModelAnimDisplay({
    super.key,
    required this.selectedModelAnim,
    required this.soundTable,
  });

  final ModelAnim selectedModelAnim;
  final SoundTable soundTable;

  @override
  Widget build(BuildContext context, ref) {
    return DataDecorator(
      children: [
        const Label.large('Model Anim', fontWeight: FontWeight.bold),
        GsfDataTile(label: 'Name', data: selectedModelAnim.name),
        GsfDataTile(label: 'index', data: selectedModelAnim.index),
        GsfDataTile(
            label: 'Sound count', data: selectedModelAnim.soundIndices.count),
        ...selectedModelAnim.soundIndices.indices.map(
          (e) => GsfDataTile(
            label: 'sound index',
            data: e,
            relatedPart: soundTable.soundInfos[e.value],
            onSelected: (info) => ref
                .read(headerStateNotifierProvider.notifier)
                .setSoundInfo(info as SoundInfo),
          ),
        ),
        GsfDataTile(label: "unknown", data: selectedModelAnim.unknownData),
      ],
    );
  }
}

class WalkSetDisplay extends ConsumerWidget {
  const WalkSetDisplay({
    super.key,
    required this.selectedWalkSet,
    required this.modelAnims,
    required this.walkTransitions,
  });

  final WalkSet selectedWalkSet;
  final List<ModelAnim> modelAnims;
  final List<WalkTransitionTable> walkTransitions;

  @override
  Widget build(BuildContext context, ref) {
    void setModelAnim(GsfPart? anim) {
      if (anim != null) {
        ref
            .read(headerStateNotifierProvider.notifier)
            .setModelAnim(anim as ModelAnim);
      }
    }

    return DataDecorator(
      children: [
        const Label.large('Walk Set', fontWeight: FontWeight.bold),
        GsfDataTile(label: 'Name', data: selectedWalkSet.name),
        GsfDataTile(
          label: 'walk_1',
          data: selectedWalkSet.walk1PosData,
          relatedPart: selectedWalkSet.walk1PosData.value > 0
              ? modelAnims[selectedWalkSet.walk1PosData.value - 1]
              : null,
          onSelected:
              selectedWalkSet.walk1PosData.value > 0 ? setModelAnim : null,
        ),
        GsfDataTile(
          label: 'walk_2',
          data: selectedWalkSet.walk2PosData,
          relatedPart: selectedWalkSet.walk2PosData.value > 0
              ? modelAnims[selectedWalkSet.walk2PosData.value - 1]
              : null,
          onSelected:
              selectedWalkSet.walk2PosData.value > 0 ? setModelAnim : null,
        ),
        GsfDataTile(
          label: 'walk_3',
          data: selectedWalkSet.walk3PosData,
          relatedPart: selectedWalkSet.walk3PosData.value > 0
              ? modelAnims[selectedWalkSet.walk3PosData.value - 1]
              : null,
          onSelected:
              selectedWalkSet.walk3PosData.value > 0 ? setModelAnim : null,
        ),
        GsfDataTile(
          label: 'walk_4',
          data: selectedWalkSet.walk4PosData,
          relatedPart: selectedWalkSet.walk4PosData.value > 0
              ? modelAnims[selectedWalkSet.walk4PosData.value - 1]
              : null,
          onSelected:
              selectedWalkSet.walk4PosData.value > 0 ? setModelAnim : null,
        ),
        GsfDataTile(
          label: 'walk_1_end_s',
          data: selectedWalkSet.walk1endSData,
          relatedPart: selectedWalkSet.walk1endSData.value > 0
              ? modelAnims[selectedWalkSet.walk1endSData.value - 1]
              : null,
          onSelected:
              selectedWalkSet.walk1endSData.value > 0 ? setModelAnim : null,
        ),
        GsfDataTile(
          label: 'walk_1_end_m',
          data: selectedWalkSet.walk1endMData,
          relatedPart: selectedWalkSet.walk1endMData.value > 0
              ? modelAnims[selectedWalkSet.walk1endMData.value - 1]
              : null,
          onSelected:
              selectedWalkSet.walk1endMData.value > 0 ? setModelAnim : null,
        ),
        GsfDataTile(
          label: 'walk_1_end_L',
          data: selectedWalkSet.walk1endLData,
          relatedPart: selectedWalkSet.walk1endLData.value > 0
              ? modelAnims[selectedWalkSet.walk1endLData.value - 1]
              : null,
          onSelected:
              selectedWalkSet.walk1endLData.value > 0 ? setModelAnim : null,
        ),
        GsfDataTile(
          label: 'walk_2_end_s',
          data: selectedWalkSet.walk2endSData,
          relatedPart: selectedWalkSet.walk2endSData.value > 0
              ? modelAnims[selectedWalkSet.walk2endSData.value - 1]
              : null,
          onSelected:
              selectedWalkSet.walk2endSData.value > 0 ? setModelAnim : null,
        ),
        GsfDataTile(
          label: 'walk_2_end_m',
          data: selectedWalkSet.walk2endMData,
          relatedPart: selectedWalkSet.walk2endMData.value > 0
              ? modelAnims[selectedWalkSet.walk2endMData.value - 1]
              : null,
          onSelected:
              selectedWalkSet.walk2endMData.value > 0 ? setModelAnim : null,
        ),
        GsfDataTile(
          label: 'walk_2_end_L',
          data: selectedWalkSet.walk2endLData,
          relatedPart: selectedWalkSet.walk2endLData.value > 0
              ? modelAnims[selectedWalkSet.walk2endLData.value - 1]
              : null,
          onSelected:
              selectedWalkSet.walk2endLData.value > 0 ? setModelAnim : null,
        ),
        GsfDataTile(
          label: 'walk_3_end_s',
          data: selectedWalkSet.walk3endSData,
          relatedPart: selectedWalkSet.walk3endSData.value > 0
              ? modelAnims[selectedWalkSet.walk3endSData.value - 1]
              : null,
          onSelected:
              selectedWalkSet.walk3endSData.value > 0 ? setModelAnim : null,
        ),
        GsfDataTile(
          label: 'walk_3_end_m',
          data: selectedWalkSet.walk3endMData,
          relatedPart: selectedWalkSet.walk3endMData.value > 0
              ? modelAnims[selectedWalkSet.walk3endMData.value - 1]
              : null,
          onSelected:
              selectedWalkSet.walk3endMData.value > 0 ? setModelAnim : null,
        ),
        GsfDataTile(
          label: 'walk_3_end_L',
          data: selectedWalkSet.walk3endLData,
          relatedPart: selectedWalkSet.walk3endLData.value > 0
              ? modelAnims[selectedWalkSet.walk3endLData.value - 1]
              : null,
          onSelected:
              selectedWalkSet.walk3endLData.value > 0 ? setModelAnim : null,
        ),
        GsfDataTile(
          label: 'walk_4_end_s',
          data: selectedWalkSet.walk4endSData,
          relatedPart: selectedWalkSet.walk4endSData.value > 0
              ? modelAnims[selectedWalkSet.walk4endSData.value - 1]
              : null,
          onSelected:
              selectedWalkSet.walk4endSData.value > 0 ? setModelAnim : null,
        ),
        GsfDataTile(
          label: 'walk_4_end_m',
          data: selectedWalkSet.walk4endMData,
          relatedPart: selectedWalkSet.walk4endMData.value > 0
              ? modelAnims[selectedWalkSet.walk4endMData.value - 1]
              : null,
          onSelected:
              selectedWalkSet.walk4endMData.value > 0 ? setModelAnim : null,
        ),
        GsfDataTile(
          label: 'walk_4_end_L',
          data: selectedWalkSet.walk4endLData,
          relatedPart: selectedWalkSet.walk4endLData.value > 0
              ? modelAnims[selectedWalkSet.walk4endLData.value - 1]
              : null,
          onSelected:
              selectedWalkSet.walk4endLData.value > 0 ? setModelAnim : null,
        ),
        GsfDataTile(
          label: 'standing turn right',
          data: selectedWalkSet.standingTurnRightData,
          relatedPart: selectedWalkSet.standingTurnRightData.value > 0
              ? modelAnims[selectedWalkSet.standingTurnRightData.value - 1]
              : null,
          onSelected: selectedWalkSet.standingTurnRightData.value > 0
              ? setModelAnim
              : null,
        ),
        GsfDataTile(
          label: 'standing turn left',
          data: selectedWalkSet.standingTurnLeftData,
          relatedPart: selectedWalkSet.standingTurnLeftData.value > 0
              ? modelAnims[selectedWalkSet.standingTurnLeftData.value - 1]
              : null,
          onSelected: selectedWalkSet.standingTurnLeftData.value > 0
              ? setModelAnim
              : null,
        ),
        GsfDataTile(
          label: 'unknown anim index 1',
          data: selectedWalkSet.unknownData,
          relatedPart: selectedWalkSet.unknownData.value > 0
              ? modelAnims[selectedWalkSet.unknownData.value - 1]
              : null,
          onSelected:
              selectedWalkSet.unknownData.value > 0 ? setModelAnim : null,
        ),
        GsfDataTile(
          label: 'accel_1_2',
          data: selectedWalkSet.accel1To2Data,
          relatedPart: selectedWalkSet.accel1To2Data.value > 0
              ? modelAnims[selectedWalkSet.accel1To2Data.value - 1]
              : null,
          onSelected:
              selectedWalkSet.accel1To2Data.value > 0 ? setModelAnim : null,
        ),
        GsfDataTile(
          label: 'accel_2_3',
          data: selectedWalkSet.accel2To3Data,
          relatedPart: selectedWalkSet.accel2To3Data.value > 0
              ? modelAnims[selectedWalkSet.accel2To3Data.value - 1]
              : null,
          onSelected:
              selectedWalkSet.accel2To3Data.value > 0 ? setModelAnim : null,
        ),
        GsfDataTile(
          label: 'accel_3_4',
          data: selectedWalkSet.accel3To4Data,
          relatedPart: selectedWalkSet.accel3To4Data.value > 0
              ? modelAnims[selectedWalkSet.accel3To4Data.value - 1]
              : null,
          onSelected:
              selectedWalkSet.accel3To4Data.value > 0 ? setModelAnim : null,
        ),
        GsfDataTile(
          label: 'brake_4_3',
          data: selectedWalkSet.brake4To3Data,
          relatedPart: selectedWalkSet.brake4To3Data.value > 0
              ? modelAnims[selectedWalkSet.brake4To3Data.value - 1]
              : null,
          onSelected:
              selectedWalkSet.brake4To3Data.value > 0 ? setModelAnim : null,
        ),
        GsfDataTile(
          label: 'brake_3_2',
          data: selectedWalkSet.brake3To2Data,
          relatedPart: selectedWalkSet.brake3To2Data.value > 0
              ? modelAnims[selectedWalkSet.brake3To2Data.value - 1]
              : null,
          onSelected:
              selectedWalkSet.brake3To2Data.value > 0 ? setModelAnim : null,
        ),
        GsfDataTile(
          label: 'brake_2_1',
          data: selectedWalkSet.brake2To1Data,
          relatedPart: selectedWalkSet.brake2To1Data.value > 0
              ? modelAnims[selectedWalkSet.brake2To1Data.value - 1]
              : null,
          onSelected:
              selectedWalkSet.brake2To1Data.value > 0 ? setModelAnim : null,
        ),
        GsfDataTile(
          label: 'walk left',
          data: selectedWalkSet.walkLeftData,
          relatedPart: selectedWalkSet.walkLeftData.value > 0
              ? modelAnims[selectedWalkSet.walkLeftData.value - 1]
              : null,
          onSelected:
              selectedWalkSet.walkLeftData.value > 0 ? setModelAnim : null,
        ),
        GsfDataTile(
          label: 'walk right',
          data: selectedWalkSet.walkRightData,
          relatedPart: selectedWalkSet.walkRightData.value > 0
              ? modelAnims[selectedWalkSet.walkRightData.value - 1]
              : null,
          onSelected:
              selectedWalkSet.walkRightData.value > 0 ? setModelAnim : null,
        ),
        GsfDataTile(
          label: 'unknown anim index 2',
          data: selectedWalkSet.unknownData2,
          relatedPart: selectedWalkSet.unknownData2.value > 0
              ? modelAnims[selectedWalkSet.unknownData2.value - 1]
              : null,
          onSelected:
              selectedWalkSet.unknownData2.value > 0 ? setModelAnim : null,
        ),
        GsfDataTile(
          label: 'walk_transition_index',
          data: selectedWalkSet.walkTransitionIndexData,
          relatedPart: selectedWalkSet.walkTransitionIndexData.value > 0
              ? walkTransitions[
                  selectedWalkSet.walkTransitionIndexData.value - 1]
              : null,
        ),
        GsfDataTile(
          label: 'growup',
          data: selectedWalkSet.growUpData,
          relatedPart: selectedWalkSet.growUpData.value > 0
              ? modelAnims[selectedWalkSet.growUpData.value - 1]
              : null,
          onSelected:
              selectedWalkSet.growUpData.value > 0 ? setModelAnim : null,
        ),
        GsfDataTile(
          label: 'sail up',
          data: selectedWalkSet.sailUpData,
          relatedPart: selectedWalkSet.sailUpData.value > 0
              ? modelAnims[selectedWalkSet.sailUpData.value - 1]
              : null,
          onSelected:
              selectedWalkSet.sailUpData.value > 0 ? setModelAnim : null,
        ),
        GsfDataTile(
          label: 'sail down',
          data: selectedWalkSet.sailDownData,
          relatedPart: selectedWalkSet.sailDownData.value > 0
              ? modelAnims[selectedWalkSet.sailDownData.value - 1]
              : null,
          onSelected:
              selectedWalkSet.sailDownData.value > 0 ? setModelAnim : null,
        ),
        GsfDataTile(
          label: 'standanim',
          data: selectedWalkSet.standAnimData,
          relatedPart: selectedWalkSet.standAnimData.value > 0
              ? modelAnims[selectedWalkSet.standAnimData.value - 1]
              : null,
          onSelected:
              selectedWalkSet.standAnimData.value > 0 ? setModelAnim : null,
        ),
        GsfDataTile(
          label: 'walk to swim',
          data: selectedWalkSet.walkToSwimData,
          relatedPart: selectedWalkSet.walkToSwimData.value > 0
              ? modelAnims[selectedWalkSet.walkToSwimData.value - 1]
              : null,
          onSelected:
              selectedWalkSet.walkToSwimData.value > 0 ? setModelAnim : null,
        ),
        GsfDataTile(
          label: 'unknown anim index 3',
          data: selectedWalkSet.unknownData3,
          relatedPart: selectedWalkSet.unknownData3.value > 0
              ? modelAnims[selectedWalkSet.unknownData3.value - 1]
              : null,
          onSelected:
              selectedWalkSet.unknownData3.value > 0 ? setModelAnim : null,
        ),
        GsfDataTile(
          label: 'unknown anim index 4',
          data: selectedWalkSet.unknownData4,
          relatedPart: selectedWalkSet.unknownData4.value > 0
              ? modelAnims[selectedWalkSet.unknownData4.value - 1]
              : null,
          onSelected:
              selectedWalkSet.unknownData4.value > 0 ? setModelAnim : null,
        ),
        GsfDataTile(
          label: 'unknown anim index 5',
          data: selectedWalkSet.unknownData5,
          relatedPart: selectedWalkSet.unknownData5.value > 0
              ? modelAnims[selectedWalkSet.unknownData5.value - 1]
              : null,
          onSelected:
              selectedWalkSet.unknownData5.value > 0 ? setModelAnim : null,
        ),
        GsfDataTile(
          label: 'unknown anim index 6',
          data: selectedWalkSet.unknownData6,
          relatedPart: selectedWalkSet.unknownData6.value > 0
              ? modelAnims[selectedWalkSet.unknownData6.value - 1]
              : null,
          onSelected:
              selectedWalkSet.unknownData6.value > 0 ? setModelAnim : null,
        ),
        GsfDataTile(
          label: 'unknown anim index 7',
          data: selectedWalkSet.unknownData7,
          relatedPart: selectedWalkSet.unknownData7.value > 0
              ? modelAnims[selectedWalkSet.unknownData7.value - 1]
              : null,
          onSelected:
              selectedWalkSet.unknownData7.value > 0 ? setModelAnim : null,
        ),
        GsfDataTile(
          label: 'unknown anim index 8',
          data: selectedWalkSet.unknownData8,
          relatedPart: selectedWalkSet.unknownData8.value > 0
              ? modelAnims[selectedWalkSet.unknownData8.value - 1]
              : null,
          onSelected:
              selectedWalkSet.unknownData8.value > 0 ? setModelAnim : null,
        ),
        GsfDataTile(
          label: 'unknown anim index 9',
          data: selectedWalkSet.unknownData9,
          relatedPart: selectedWalkSet.unknownData9.value > 0
              ? modelAnims[selectedWalkSet.unknownData9.value - 1]
              : null,
          onSelected:
              selectedWalkSet.unknownData9.value > 0 ? setModelAnim : null,
        ),
        GsfDataTile(
          label: 'unknown anim index 10',
          data: selectedWalkSet.unknownData10,
          relatedPart: selectedWalkSet.unknownData10.value > 0
              ? modelAnims[selectedWalkSet.unknownData10.value - 1]
              : null,
          onSelected:
              selectedWalkSet.unknownData10.value > 0 ? setModelAnim : null,
        ),
      ],
    );
  }
}
