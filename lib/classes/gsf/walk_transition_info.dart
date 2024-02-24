import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';

class WalkTransitionInfo extends GsfPart {
  late final Standard4BytesData<int> nameLength;

  WalkTransitionInfo.fromBytes(Uint8List bytes, int offset)
      : super(offset: offset) {
    nameLength = Standard4BytesData(
      position: 0,
      bytes: bytes,
      offset: offset,
    );

    name = GsfData.fromPosition(
      relativePos: nameLength.relativeEnd,
      length: nameLength.value,
      bytes: bytes,
      offset: offset,
    );
  }

  @override
  int getEndOffset() {
    return name.offsettedLength(offset);
  }

  @override
  String toString() {
    return 'WalkTransitionInfo: $name';
  }
}
