import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';

class DustTrailInfo extends GsfPart {
  static const GsfData nameLengthData = Standard4BytesData(pos: 6);

  // 6 unknown bytes
  late final int nameLength;
  late final String name;
  // 4 unknown bytes
  late final int settingsCount;

  DustTrailInfo.fromBytes(Uint8List bytes, int offset) : super(offset: offset) {
    nameLength = nameLengthData.getAsUint(bytes, offset);
    final nameData =
        GsfData(pos: nameLengthData.relativeEnd(), length: nameLength);
    name = nameData.getAsAsciiString(bytes, offset);

    final settingsCountData =
        Standard4BytesData(pos: nameData.relativeEnd() + 4); // 4 unknown bytes
    settingsCount = settingsCountData.getAsUint(bytes, offset);
  }

  @override
  int getEndOffset() {
    return offset +
        6 + // unknown bytes
        nameLengthData.length +
        nameLength +
        4 + // unknown bytes
        settingsCount;
  }

  @override
  String toString() {
    return 'DustTrailInfo: $name, count $settingsCount';
  }
}
