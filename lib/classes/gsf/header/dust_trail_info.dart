import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';

class DustTrailInfo extends GsfPart {
  // 6 unknown bytes
  late final GsfData<UnknowData> unknownData;
  late final Standard4BytesData<int> nameLength;
  late final GsfData<String> name;
  late final Standard4BytesData<int>
      boneIndex; // we are not sure if this is a bone index
  late final Standard4BytesData<int> entryCount;
  late final List<DustTrailEntry> entries = [];

  @override
  String get label => name.value;

  DustTrailInfo.fromBytes(Uint8List bytes, int offset) : super(offset: offset) {
    unknownData = GsfData.fromPosition(
        relativePos: 0, length: 6, bytes: bytes, offset: offset);
    nameLength = Standard4BytesData(
        position: unknownData.relativeEnd, bytes: bytes, offset: offset);
    name = GsfData.fromPosition(
      relativePos: nameLength.relativeEnd,
      length: nameLength.value,
      bytes: bytes,
      offset: offset,
    );

    boneIndex = Standard4BytesData(
      position: name.relativeEnd,
      bytes: bytes,
      offset: offset,
    );

    entryCount = Standard4BytesData(
      position: boneIndex.relativeEnd,
      bytes: bytes,
      offset: offset,
    );

    if (entryCount.value > 0) {
      for (var i = 0; i < entryCount.value; i++) {
        entries.add(DustTrailEntry.fromBytes(
          bytes,
          entries.isNotEmpty
              ? entries.last.getEndOffset()
              : entryCount.offsettedLength,
        ));
      }
    }
  }

  @override
  int getEndOffset() {
    return entries.isNotEmpty
        ? entries.last.getEndOffset()
        : entryCount.offsettedLength;
  }

  @override
  String toString() {
    return 'DustTrailInfo: $name';
  }
}

class DustTrailEntry extends GsfPart {
  late final Standard4BytesData<int> nameLength;
  late final GsfData<String> name;
  late final Standard4BytesData<int> valueCharsLength;
  late final GsfData<String> valueChars;

  @override
  String get label => name.value;

  DustTrailEntry.fromBytes(Uint8List bytes, int offset)
      : super(offset: offset) {
    nameLength = Standard4BytesData(position: 0, bytes: bytes, offset: offset);
    name = GsfData.fromPosition(
      relativePos: nameLength.relativeEnd,
      length: nameLength.value,
      bytes: bytes,
      offset: offset,
    );

    valueCharsLength = Standard4BytesData(
      position: name.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    valueChars = GsfData.fromPosition(
      relativePos: valueCharsLength.relativeEnd,
      length: valueCharsLength.value,
      bytes: bytes,
      offset: offset,
    );
  }

  @override
  int getEndOffset() {
    return valueChars.offsettedLength;
  }
}
