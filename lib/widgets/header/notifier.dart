import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/dust_trail_info.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/model_anim.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/model_info.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/sound_info.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/walk_set.dart';
import 'package:paraworld_gsf_viewer/widgets/header/state.dart';

class HeaderStateNotifier extends Notifier<HeaderState> {
  @override
  HeaderState build() => const HeaderState.empty();

  void reset () {
    state = const HeaderState.empty();
  }

  void setModelInfo(ModelInfo modelInfo) {
    state = HeaderState.withModelInfo(
      modelInfo: modelInfo,
      walkSet: modelInfo.walkSetTable.walkSets.firstOrNull,
      modelAnim: modelInfo.modelAnims.firstOrNull,
    );
  }

  void setModelAnim(ModelAnim anim) {
    state = state.maybeMap(
      withModelInfo: (value) => value.copyWith(modelAnim: anim),
      orElse: () => state,
    );
  }

  void setWalkSet(WalkSet walkset) {
    state = state.maybeMap(
      withModelInfo: (value) => value.copyWith(walkSet: walkset),
      orElse: () => state,
    );
  }

  void setSoundInfo(SoundInfo soundInfo) {
    state = HeaderState.withSound(sound: soundInfo);
  }

  void setDustTrailInfo(DustTrailInfo dustTrailInfo) {
    state = HeaderState.withDustTrail(dustTrailInfo: dustTrailInfo);
  }
}
