import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/gsf/header/sound_info.dart';
import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';

class SoundTable extends GsfPart {
  SoundTable({
    required offset,
    required this.soundCount,
  }) : super(offset: offset);

  late final Standard4BytesData<int> soundCount;
  late final List<SoundInfo> soundInfos;

  SoundTable.fromBytes(Uint8List bytes, int offset) : super(offset: offset) {
    soundCount = Standard4BytesData(position: 0, bytes: bytes, offset: offset);
    soundInfos = [];
    for (var i = 0; i < soundCount.value; i++) {
      soundInfos.add(
        SoundInfo.fromBytes(
          bytes,
          soundInfos.isNotEmpty
              ? soundInfos.last.getEndOffset()
              : soundCount.offsettedLength(offset),
        ),
      );
    }
  }

  @override
  int getEndOffset() {
    return soundInfos.isNotEmpty
        ? soundInfos.last.getEndOffset()
        : soundCount.offsettedLength(offset);
  }

  @override
  String toString() {
    return 'SoundTable: $soundCount sounds.';
  }

  @override
  bool operator ==(Object other) =>
      other is SoundTable &&
      other.soundCount == soundCount &&
      other.soundInfos == soundInfos;

  @override
  int get hashCode => soundCount.hashCode ^ soundInfos.hashCode;
}
