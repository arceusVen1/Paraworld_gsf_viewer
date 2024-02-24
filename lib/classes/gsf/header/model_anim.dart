import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/gsf/header/sound_indices.dart';
import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';

class ModelAnim extends GsfPart {
  ModelAnim({required super.offset});

  late final Standard4BytesData<int> nameLength;
  late final Standard4BytesData<int> index;
  late final SoundIndices soundIndices;
  late final Standard4BytesData<UnknowData> unknownData;

  ModelAnim.fromBytes(Uint8List bytes, int offset) : super(offset: offset) {
    nameLength = Standard4BytesData(position: 0, bytes: bytes, offset: offset);

    name = GsfData<String>.fromPosition(
      relativePos: nameLength.relativeEnd,
      length: nameLength.value,
      bytes: bytes,
      offset: offset,
    );

    index = Standard4BytesData(
        position: name.relativeEnd, bytes: bytes, offset: offset);

    soundIndices = SoundIndices.fromBytes(bytes, index.offsettedLength);
    unknownData = Standard4BytesData(
      position: index.relativeEnd + soundIndices.length,
      bytes: bytes,
      offset: offset,
    );
  }

  @override
  int getEndOffset() {
    return unknownData.offsettedLength;
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'ModelAnim: $name, $index, $soundIndices';
  }
}
