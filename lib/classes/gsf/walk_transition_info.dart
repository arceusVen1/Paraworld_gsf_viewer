import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';

class WalkTransitionInfo extends GsfPart {
  late final Standard4BytesData<int> transitionNameLength;
  late final GsfData<String> transitionName;

  WalkTransitionInfo.fromBytes(Uint8List bytes, int offset)
      : super(offset: offset) {
    transitionNameLength = Standard4BytesData(
      position: 0,
      bytes: bytes,
      offset: offset,
    );

    transitionName = GsfData.fromPosition(
      pos: transitionNameLength.relativeEnd,
      length: transitionNameLength.value,
      bytes: bytes,
      offset: offset,
    );
  }

  @override
  int getEndOffset() {
    return transitionName.offsettedLength(offset);
  }

  @override
  String toString() {
    return 'WalkTransitionInfo: $transitionName';
  }
}
