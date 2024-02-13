import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';

class SoundIndices extends GsfPart {
  SoundIndices({required super.offset});
  static const GsfData countData = Standard4BytesData(pos: 0);

  final List<int> indices = [];

  SoundIndices.fromBytes(Uint8List bytes, int offset) : super(offset: offset) {
    final count = countData.getAsUint(bytes, offset);
    for (var i = 0; i < count; i++) {
      indices.add(Standard4BytesData(
        pos: countData.offsettedLength(offset) + i * 4,
      ).getAsUint(bytes, offset));
    }
  }

  @override
  String toString() {
    return 'SoundIndices: $indices';
  }

  @override
  int getEndOffset() {
    return countData.offsettedLength(offset) + indices.length * 4;
  }
}
