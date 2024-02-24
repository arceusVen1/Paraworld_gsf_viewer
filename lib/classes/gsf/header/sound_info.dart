import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';

class SoundInfo extends GsfPart {
  late final Standard4BytesData<int> nameLength;
  late final GsfData<String> name;
  late final Standard4BytesData<int> startFrame;
  late final Standard4BytesData<int> volume;
  late final Standard4BytesData<int> speed;
  late final GsfData<UnknowData> unknownData; // 16 unknown bytes
  late final Standard4BytesData<int> soundGroupNameLength;
  late final GsfData<String> soundGroupName;

  SoundInfo.fromBytes(Uint8List bytes, int offset) : super(offset: offset) {
    nameLength = Standard4BytesData(position: 0, bytes: bytes, offset: offset);
    name = GsfData.fromPosition(
      relativePos: nameLength.relativeEnd,
      length: nameLength.value,
      bytes: bytes,
      offset: offset,
    );

    startFrame = Standard4BytesData(
        position: name.relativeEnd, bytes: bytes, offset: offset);

    volume = Standard4BytesData(
        position: startFrame.relativeEnd, bytes: bytes, offset: offset);

    speed = Standard4BytesData(
        position: volume.relativeEnd, bytes: bytes, offset: offset);
    unknownData = GsfData.fromPosition(
      relativePos: speed.relativeEnd,
      length: 16,
      bytes: bytes,
      offset: offset,
    );
    soundGroupNameLength = Standard4BytesData(
        position: unknownData.relativeEnd, bytes: bytes, offset: offset);

    soundGroupName = GsfData.fromPosition(
      relativePos: soundGroupNameLength.relativeEnd,
      length: soundGroupNameLength.value,
      bytes: bytes,
      offset: offset,
    );
  }

  @override
  int getEndOffset() {
    return soundGroupName.offsettedLength(offset);
  }

  @override
  String toString() {
    return 'SoundInfo: $name $startFrame $volume $speed $soundGroupName';
  }
}
