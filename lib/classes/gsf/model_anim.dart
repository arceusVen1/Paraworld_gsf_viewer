import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/gsf/sound_indices.dart';
import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';

class ModelAnim extends GsfPart {
  ModelAnim({required super.offset});

  static const GsfData nameLengthData = Standard4BytesData(pos: 0);

  late final String name;
  late final int index;
  late final SoundIndices soundIndices;

  ModelAnim.fromBytes(Uint8List bytes, int offset) : super(offset: offset) {
    final nameLength = nameLengthData.getAsUint(bytes, offset);

    final nameData =
        GsfData(pos: nameLengthData.relativeEnd(), length: nameLength);
    name = nameData.getAsAsciiString(bytes, offset);
    print("model anim name: $name");

    final indexData = Standard4BytesData(pos: nameData.relativeEnd());
    index = indexData.getAsUint(bytes, offset);

    soundIndices =
        SoundIndices.fromBytes(bytes, indexData.offsettedLength(offset));
  }

  @override
  int getEndOffset() {
    return soundIndices.getEndOffset();
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'ModelAnim: $name, $index, $soundIndices';
  }
}
