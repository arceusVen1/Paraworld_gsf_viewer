import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/chunk.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/submesh.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/header2.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/material.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/model_settings.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/object_name.dart';

part 'state.freezed.dart';

@freezed
class Header2State with _$Header2State {
  const factory Header2State.empty({
    Header2? header2,
  }) = _Empty;

  const factory Header2State.withModelSettings(
      {required Header2 header2,
      required ModelSettings modelSettings,
      ObjectName? objectName,
      Chunk? chunk,
      Submesh? submesh,
      MaterialData? material}) = Header2StateWithModelSettings;

  const factory Header2State.withMaterial({
    required Header2 header2,
    required MaterialData material,
  }) = Header2StateWithMaterial;
}
