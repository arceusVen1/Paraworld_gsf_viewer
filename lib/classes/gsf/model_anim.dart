import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/gsf/sound_indices.dart';
import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';

class ModelAnim extends GsfPart {
  ModelAnim({required super.offset});

  late final Standard4BytesData<int> nameLength;
  late final GsfData<String> name;
  late final Standard4BytesData<int> index;
  late final SoundIndices soundIndices;
  late final Standard4BytesData<UnknowData> unknownData;

  ModelAnim.fromBytes(Uint8List bytes, int offset) : super(offset: offset) {
    nameLength = Standard4BytesData(position: 0, bytes: bytes, offset: offset);

    name = GsfData<String>.fromPosition(
      pos: nameLength.relativeEnd,
      length: nameLength.value,
      bytes: bytes,
      offset: offset,
    );
    print("model anim name: $name");

    index = Standard4BytesData(
        position: name.relativeEnd, bytes: bytes, offset: offset);

    soundIndices = SoundIndices.fromBytes(bytes, index.offsettedLength(offset));
    unknownData = Standard4BytesData(
      position: soundIndices.getEndOffset() - offset,
      bytes: bytes,
      offset: offset,
    );
  }

  @override
  int getEndOffset() {
    return unknownData.offsettedLength(offset);
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'ModelAnim: $name, $index, $soundIndices';
  }
}
