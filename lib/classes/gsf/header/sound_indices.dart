import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';

class SoundIndices extends GsfPart {
  SoundIndices({required super.offset});

  late final Standard4BytesData<int> count;
  final List<Standard4BytesData<int>> indices = [];

  @override
  String get label => 'SoundIndices: $indices';

  SoundIndices.fromBytes(Uint8List bytes, int offset) : super(offset: offset) {
    count = Standard4BytesData(position: 0, bytes: bytes, offset: offset);
    for (var i = 0; i < count.value; i++) {
      indices.add(Standard4BytesData<int>(
          position: count.relativeEnd + i * 4, bytes: bytes, offset: offset));
    }
  }
  
  @override
  int getEndOffset() {
    return indices.isNotEmpty
        ? indices.last.offsettedLength
        : count.offsettedLength;
  }
}
