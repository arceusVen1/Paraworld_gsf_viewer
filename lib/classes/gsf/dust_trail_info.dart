import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';

class DustTrailInfo extends GsfPart {
  static const GsfData nameLengthData = Standard4BytesData(pos: 6);
  late GsfData _nameData;
  late Standard4BytesData _settingsCountData;

  // 6 unknown bytes
  late final int nameLength;
  late final String name;
  // 4 unknown bytes
  late final int settingsCount;

  DustTrailInfo.fromBytes(Uint8List bytes, int offset) : super(offset: offset) {
    nameLength = nameLengthData.getAsUint(bytes, offset);
    _nameData = GsfData(pos: nameLengthData.relativeEnd(), length: nameLength);
    name = _nameData.getAsAsciiString(bytes, offset);

    _settingsCountData =
        Standard4BytesData(pos: _nameData.relativeEnd() + 4); // 4 unknown bytes
    settingsCount = _settingsCountData.getAsUint(bytes, offset);
  }

  @override
  int getEndOffset() {
    return _settingsCountData.offsettedLength(offset);
  }

  @override
  String toString() {
    return 'DustTrailInfo: $name, count $settingsCount';
  }
}
