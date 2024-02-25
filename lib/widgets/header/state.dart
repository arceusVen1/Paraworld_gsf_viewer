import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header/dust_trail_info.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header/model_anim.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header/model_info.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header/sound_info.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header/walk_set.dart';
part 'state.freezed.dart';

@freezed
class HeaderState with _$HeaderState {
  const factory HeaderState.empty() = _Empty;

  const factory HeaderState.withModelInfo({
    required ModelInfo modelInfo,
    WalkSet? walkSet,
    ModelAnim? modelAnim,
    SoundInfo? selectedSoundInfo,
  }) = HeaderStateWithModelInfo;

  const factory HeaderState.withSound({
    required SoundInfo sound,
  }) = HeaderStateWithSound;

  const factory HeaderState.withDustTrail({
    required DustTrailInfo dustTrailInfo,
  }) = HeaderStateWithDustTrail;
}
