import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';

class SoundInfo extends GsfPart {
  static const GsfData nameLengthData = Standard4BytesData(pos: 0);

  late final int nameLength;
  late final String name;
  late final int startFrame;
  late final int volume;
  late final int speed;
  // 16 unknown bytes
  late final int soundGroupNameLength;
  late final String soundGroupName;

  SoundInfo.fromBytes(Uint8List bytes, int offset) : super(offset: offset) {
    nameLength = nameLengthData.getAsUint(bytes, offset);
    final nameData =
        GsfData(pos: nameLengthData.relativeEnd(), length: nameLength);
    name = nameData.getAsAsciiString(bytes, offset);

    final startFrameData =
        Standard4BytesData(pos: nameData.relativeEnd()); // 4 unknown bytes
    startFrame = startFrameData.getAsUint(bytes, offset);

    final volumeData = Standard4BytesData(pos: startFrameData.relativeEnd());
    volume = volumeData.getAsUint(bytes, offset);

    final speedData = Standard4BytesData(pos: volumeData.relativeEnd());

    speed = speedData.getAsUint(bytes, offset);

    final soundGroupNameLengthData = Standard4BytesData(
        pos: speedData.relativeEnd() + 16); // 16 unknown bytes
    soundGroupNameLength = soundGroupNameLengthData.getAsUint(bytes, offset);

    soundGroupName = GsfData(
            pos: soundGroupNameLengthData.relativeEnd(),
            length: soundGroupNameLength)
        .getAsAsciiString(bytes, offset);
  }

  @override
  int getEndOffset() {
    return offset +
        nameLengthData.length +
        nameLength +
        4 + // startFrame
        4 + // volume
        4 + // speed
        16 + // unknown bytes
        4 + // soundGroupNameLength
        soundGroupNameLength;
  }

  @override
  String toString() {
    return 'SoundInfo: $name $startFrame $volume $speed $soundGroupName';
  }
}
