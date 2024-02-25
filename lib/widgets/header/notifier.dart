import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/gsf.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header/dust_trail_info.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header/model_anim.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header/model_info.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header/sound_info.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header/walk_set.dart';
import 'package:paraworld_gsf_viewer/providers/gsf.dart';
import 'package:paraworld_gsf_viewer/widgets/header/state.dart';

class HeaderStateNotifier extends Notifier<HeaderState> {
  @override
  HeaderState build() {
    gsfFile = ref.watch(gsfProvider).mapOrNull(data: (data) => data.value);
    return const HeaderState.empty();
  }

  GSF? gsfFile;

  void reset() {
    state = const HeaderState.empty();
  }

  void setGsfFile(GSF gsf) {
    gsfFile = gsf;
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
    state = state.maybeMap(
      withModelInfo: (value) => value.copyWith(selectedSoundInfo: soundInfo),
      orElse: () => HeaderState.withSound(sound: soundInfo),
    );
  }

  void setDustTrailInfo(DustTrailInfo dustTrailInfo) {
    state = HeaderState.withDustTrail(dustTrailInfo: dustTrailInfo);
  }
}
