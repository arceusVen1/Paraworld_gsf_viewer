
import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';

typedef DetailTable = Map<String, DetailTableEntry>;
typedef DetailTableEntry = ({
  List<int> availableResolutions,
  bool overrideNameWithResolution,
});

typedef ModPath = ({int priority, String override});
typedef ModPrioritiesPerPath = Map<String, List<ModPath>>;

@freezed
class PwLinkState with _$PwLinkState {
  const factory PwLinkState.notLinked() = _PwLinkStateNotLinked;

const factory PwLinkState.loading(
      {required String pwFolderPath,
      }) = _PwLinkStateLoading;

  const factory PwLinkState.success(
      {required String pwFolderPath,
      required ModPrioritiesPerPath modPrioritiesPerPath,
      required DetailTable detailTable,
      required List<String> gsfs,
      String? selectedGsf,
      }) = _PwLinkStateSuccess;

  const factory PwLinkState.failed(
      {
        required String pwFolderPath,
        required Object error,   
      }) = _PwLinkStateFailed;
}

