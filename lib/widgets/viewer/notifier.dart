import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/chunk_attributes.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/model_settings.dart';
import 'package:paraworld_gsf_viewer/providers/gsf.dart';
import 'package:paraworld_gsf_viewer/widgets/viewer/state.dart';

class ModelSelectionStateNotifier extends Notifier<ModelViewerSelectionState> {
  @override
  ModelViewerSelectionState build() {
    final gsfFile =
        ref.watch(gsfProvider).mapOrNull(data: (data) => data.value);
    models = gsfFile?.header2.modelSettings ?? [];
    return ModelViewerSelectionState.empty(models);
  }

  List<ModelSettings> models = [];

  void reset() {
    state = ModelViewerSelectionState.empty(models);
  }

  void setModel(ModelSettings model) {
    state = state.map(
      empty: (_) => ModelViewerSelectionState.withModel(
          models: models,
          model: model,
          filter: ChunkAttributes.fromValue(
            model.type,
            ChunkAttributes.defaultLoD,
          )),
      withModel: (withModel) => withModel.copyWith(
        model: model,
        filter: ChunkAttributes.fromBits(
          model.type,
          withModel.filter.bits,
        ),
      ),
    );
  }

  void updateShowCloth(bool showCloth) {
    state.maybeMap(
        withModel: (withModel) {
          state = withModel.copyWith(showCloth: showCloth);
        },
        orElse: () => null);
  }

  void updateFilterAttribute(int indice) {
    state.maybeMap(
        withModel: (withModel) {
          state = withModel.copyWith(
            filter: ChunkAttributes.fromBits(
              withModel.model.type,
              withModel.filter.bits..[indice] = !withModel.filter.bits[indice],
            ),
          );
        },
        orElse: () => null);
  }
}
