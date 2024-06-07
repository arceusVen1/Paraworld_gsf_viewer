import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';

class SoundInfo extends GsfPart {
  late final Standard4BytesData<int> nameLength;
  late final GsfData<String> name;
  late final Standard4BytesData<int> startFrame;
  late final Standard4BytesData<int> volume;
  late final Standard4BytesData<double> speed;
  late final Standard4BytesData<double> unknownData1; // 4 unknown bytes
  late final Standard4BytesData<double> minFadeDistance;
  late final Standard4BytesData<double> maxFadeDistance;
  late final Standard4BytesData<double> maxHearingDistance;
  late final Standard4BytesData<int> soundGroupNameLength;
  late final GsfData<String> soundGroupName;

  @override
  String get label => name.value;

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
    unknownData1 = Standard4BytesData(
        position: speed.relativeEnd, bytes: bytes, offset: offset);
    minFadeDistance = Standard4BytesData(
        position: unknownData1.relativeEnd, bytes: bytes, offset: offset);
    maxFadeDistance = Standard4BytesData(
        position: minFadeDistance.relativeEnd, bytes: bytes, offset: offset);
    maxHearingDistance = Standard4BytesData(
        position: maxFadeDistance.relativeEnd, bytes: bytes, offset: offset);

    soundGroupNameLength = Standard4BytesData(
        position: maxHearingDistance.relativeEnd, bytes: bytes, offset: offset);

    soundGroupName = GsfData.fromPosition(
      relativePos: soundGroupNameLength.relativeEnd,
      length: soundGroupNameLength.value,
      bytes: bytes,
      offset: offset,
    );
  }

  @override
  int getEndOffset() {
    return soundGroupName.offsettedLength;
  }

  @override
  String toString() {
    return 'SoundInfo: $name $startFrame $volume $speed $soundGroupName';
  }
}
