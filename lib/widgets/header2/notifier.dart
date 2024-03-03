import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/gsf.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/chunk.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/submesh.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/model_settings.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/object_name.dart';
import 'package:paraworld_gsf_viewer/providers/gsf.dart';
import 'package:paraworld_gsf_viewer/widgets/header2/state.dart';

class Header2StateNotifier extends Notifier<Header2State> {
  @override
  Header2State build() {
    gsfFile = ref.watch(gsfProvider).mapOrNull(data: (data) => data.value);
    return Header2State.empty(header2: gsfFile?.header2);
  }

  GSF? gsfFile;

  void reset() {
    state = Header2State.empty(header2: gsfFile?.header2);
  }

  void setModelSettings(ModelSettings modelSettings) {
    state = Header2State.withModelSettings(
      header2: gsfFile!.header2,
      modelSettings: modelSettings,
    );
  }

  void setObjectName(ObjectName objectName) {
    state = state.maybeMap(
      withModelSettings: (s) => s.copyWith(
        objectName: objectName,
        chunk: null,
        submesh: null,
      ),
      orElse: () => state,
    );
  }

  void setChunk(Chunk chunk) {
    state = state.maybeMap(
      withModelSettings: (s) => s.copyWith(
        chunk: chunk,
        submesh: null,
      ),
      orElse: () => state,
    );
  }

  void setSubmesh(Submesh mesh) {
    state = state.maybeMap(
      withModelSettings: (s) => s.copyWith(submesh: mesh),
      orElse: () => state,
    );
  }
}
