import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/dust_trail_info.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/model_anim.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/model_info.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/sound_info.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/walk_set.dart';
part 'state.freezed.dart';

@freezed
class HeaderState with _$HeaderState {
  const factory HeaderState.empty() = _Empty;

  const factory HeaderState.withModelInfo({
    required ModelInfo modelInfo,
    WalkSet? walkSet,
    ModelAnim? modelAnim,
  }) = HeaderStateWithModelInfo;

  const factory HeaderState.withSound({
    required SoundInfo sound,
  }) = HeaderStateWithSound;

  const factory HeaderState.withDustTrail({
    required DustTrailInfo dustTrailInfo,
  }) = HeaderStateWithDustTrail;
}
