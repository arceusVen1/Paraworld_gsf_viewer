import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/chunk_attributes.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/model_settings.dart';

part 'state.freezed.dart';

@freezed
class ModelViewerSelectionState with _$ModelViewerSelectionState {
  const factory ModelViewerSelectionState.empty(
    List<ModelSettings> models,
  ) = _Empty;

  const factory ModelViewerSelectionState.withModel({
    required List<ModelSettings> models,
    required ModelSettings model,
    required ChunkAttributes filter,
    @Default(true) showCloth, 
  }) = ModelViewerSelectionStateWithModel;
}
