import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';

class WalkTransitionInfo extends GsfPart {
  static const GsfData transitionNameLengthData = Standard4BytesData(pos: 0);

  late final int transitionNameLength;
  late final String transitionName;

  WalkTransitionInfo.fromBytes(Uint8List bytes, int offset)
      : super(offset: offset) {
    transitionNameLength = transitionNameLengthData.getAsUint(bytes, offset);
    final transitionNameData = GsfData(
        pos: transitionNameLengthData.relativeEnd(),
        length: transitionNameLength);
    transitionName = transitionNameData.getAsAsciiString(bytes, offset);
  }

  @override
  int getEndOffset() {
    return transitionNameLengthData.offsettedLength(offset) +
        transitionNameLength;
  }

  @override
  String toString() {
    return 'WalkTransitionInfo: $transitionName';
  }
}
