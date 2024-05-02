import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/chunk_attributes.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/materials_table.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/model_settings.dart';
import 'package:paraworld_gsf_viewer/providers/gsf.dart';
import 'package:paraworld_gsf_viewer/widgets/viewer/state.dart';

class ModelSelectionStateNotifier extends Notifier<ModelViewerSelectionState> {
  @override
  ModelViewerSelectionState build() {
    final gsfFile =
        ref.watch(gsfProvider).mapOrNull(data: (data) => data.value);
    models = gsfFile?.header2.modelSettings ?? [];
    if (gsfFile != null) {
      materialsTable = gsfFile.header2.materialsTable;
    }

    return ModelViewerSelectionState.empty(
      models: models,
      materialsTable: materialsTable,
    );
  }

  List<ModelSettings> models = [];
  late MaterialsTable materialsTable;

  void reset() {
    state = ModelViewerSelectionState.empty(
      models: models,
      materialsTable: materialsTable,
    );
  }

  void setModel(ModelSettings model) {
    state = state.map(
      empty: (_) => ModelViewerSelectionState.withModel(
        models: models,
        materialsTable: materialsTable,
        model: model,
        filter: ChunkAttributes.defaultValue(
          model.type,
        ),
        showCloth: true,
      ),
      withModel: (withModel) => withModel.copyWith(
        model: model,
        filter: withModel.model.type != model.type
            ? ChunkAttributes.defaultValue(model.type)
            : ChunkAttributes.fromBits(
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

  void updateShowTexture(bool showTexture) {
    state.maybeMap(
        withModel: (withModel) {
          state = withModel.copyWith(showTexture: showTexture);
        },
        orElse: () => null);
  }

  void updateShowNormal(bool showNormal) {
    state.maybeMap(
        withModel: (withModel) {
          state = withModel.copyWith(showNormals: showNormal);
        },
        orElse: () => null);
  }

  void updateShowPartyColor(bool showPartyColor) {
    state.maybeMap(
        withModel: (withModel) {
          state = withModel.copyWith(showPartyColor: showPartyColor);
        },
        orElse: () => null);
  }

  void updateShowSkeleton(bool showSkeleton) {
    state.maybeMap(
        withModel: (withModel) {
          state = withModel.copyWith(showSkeleton: showSkeleton);
        },
        orElse: () => null);
  }

  void updateShowLinks(bool showLinks) {
    state.maybeMap(
        withModel: (withModel) {
          state = withModel.copyWith(showLinks: showLinks);
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
