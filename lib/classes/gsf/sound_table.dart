import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/gsf/sound_info.dart';
import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';

class SoundTable extends GsfPart {
  SoundTable({
    required offset,
    required this.soundCount,
  }) : super(offset: offset);

  late final int soundCount;
  late final List<SoundInfo> soundInfos;

  static const GsfData soundCountData = Standard4BytesData(pos: 0);

  SoundTable.fromBytes(Uint8List bytes, int offset) : super(offset: offset) {
    soundCount = soundCountData.getAsUint(bytes, offset);
    print("sound table sound count: $soundCount");
    soundInfos = [];
    for (var i = 0; i < soundCount; i++) {
      soundInfos.add(
        SoundInfo.fromBytes(
          bytes,
          soundInfos.isNotEmpty
              ? soundInfos.last.getEndOffset()
              : soundCountData.offsettedLength(offset),
        ),
      );
      print(soundInfos.last);
    }
  }

  @override
  int getEndOffset() {
    return soundInfos.isNotEmpty
        ? soundInfos.last.getEndOffset()
        : soundCountData.offsettedLength(offset);
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
