import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/gsf.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/bone.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/link.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/chunk.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/cloth.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/mesh.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/skeleton.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/submesh.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/material.dart';
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
        selectedChunkState: null,
      ),
      orElse: () => state,
    );
  }

  void setChunk(Chunk chunk) {
    state = state.maybeMap(
      withModelSettings: (s) {
        switch(chunk.runtimeType) {
          case LinkChunk:
            return s.copyWith(
              selectedChunkState: SelectedChunkState.withLink(linkChunk: chunk as LinkChunk),
            );
          case SkeletonChunk:
            return s.copyWith(
              selectedChunkState: SelectedChunkState.withSkeleton(skeleton: chunk as SkeletonChunk),
            );
          case MeshChunk:
            return s.copyWith(
              selectedChunkState: SelectedChunkState.withMesh(mesh: chunk as MeshChunk),
            );
          case ClothChunk:
            return s.copyWith(
              selectedChunkState: SelectedChunkState.withCloth(cloth: chunk as ClothChunk),
            );
          default:
            return s;
        }
      },
      orElse: () => state,
    );
  }

  void setSubmesh(Submesh submesh) {
    state = state.maybeMap(
      withModelSettings: (s) => s.copyWith(
        selectedChunkState: s.selectedChunkState?.maybeMap(
          withMesh: (data) => data.copyWith(submesh: submesh),
          withCloth: (data) => data.copyWith(submesh: submesh),
          orElse: () => s.selectedChunkState,
        ),
      ),
      orElse: () => state,
    );
  }

  void setBone(Bone bone) {
    state = state.maybeMap(
      withModelSettings: (s) => s.copyWith(
        selectedChunkState: s.selectedChunkState?.maybeMap(
          withSkeleton: (data) => data.copyWith(bone: bone),
          orElse: () => s.selectedChunkState,
        ),
      ),
      orElse: () => state,
    );
  }

  void setMaterial(MaterialData material) {
    state = state.maybeMap(
       withModelSettings: (s) => s.copyWith(
        selectedChunkState: s.selectedChunkState?.maybeMap(
          withMesh: (data) => data.copyWith(material: material),
          withCloth: (data) => data.copyWith(material: material),
          orElse: () => s.selectedChunkState,
        ),
      ),
      orElse: () => Header2State.withMaterial(
        header2: gsfFile!.header2,
        material: material,
      ),
    );
  }
}
