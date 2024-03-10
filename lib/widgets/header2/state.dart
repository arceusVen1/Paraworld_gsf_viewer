import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/bone.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/link.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/cloth.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/mesh.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/skeleton.dart';
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
      SelectedChunkState? selectedChunkState}) = Header2StateWithModelSettings;

  const factory Header2State.withMaterial({
    required Header2 header2,
    required MaterialData material,
  }) = Header2StateWithMaterial;
}

@freezed
class SelectedChunkState with _$SelectedChunkState {
  const factory SelectedChunkState.withSkeleton({
    required SkeletonChunk skeleton,
    Bone? bone,
  }) = SelectedChunkStateWithSkeleton;

  const factory SelectedChunkState.withLink({
    required LinkChunk linkChunk,
  }) = SelectedChunkStateWithLink;

  const factory SelectedChunkState.withMesh({
    required MeshChunk mesh,
    MaterialData? material,
    Submesh? submesh,
  }) = SelectedChunkStateWithMesh;

  const factory SelectedChunkState.withCloth({
    required ClothChunk cloth,
    MaterialData? material,
    Submesh? submesh,
  }) = SelectedChunkStateWithCloth;
}
