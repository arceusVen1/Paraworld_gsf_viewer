import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/chunk_attributes.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/materials_table.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/model_settings.dart';

part 'state.freezed.dart';

@freezed
class ModelViewerSelectionState with _$ModelViewerSelectionState {
  const factory ModelViewerSelectionState.empty({
    required MaterialsTable materialsTable,
    required List<ModelSettings> models,
  }) = _Empty;

  const factory ModelViewerSelectionState.withModel({
    required List<ModelSettings> models,
    required ModelSettings model,
    required ChunkAttributes filter,
    required MaterialsTable materialsTable,
    @Default(true) showCloth,
    @Default(false) showNormals,
    @Default(true) showTexture,
    @Default(true) showPartyColor,
    @Default(false) showSkeleton,
    @Default(true) showLinks,
    @Default(false) showCollisionVolumes,
  }) = ModelViewerSelectionStateWithModel;
}
