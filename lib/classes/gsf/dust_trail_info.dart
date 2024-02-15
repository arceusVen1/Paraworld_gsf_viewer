import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';

class DustTrailInfo extends GsfPart {
  // 6 unknown bytes
  late final GsfData<UnknowData> unknownData;
  late final Standard4BytesData<int> nameLength;
  late final GsfData<String> name;
  ComposedDustrail? composedDustrail;
  SimpleDustrail? simpleDustrail;

  DustTrailInfo.fromBytes(Uint8List bytes, int offset) : super(offset: offset) {
    unknownData =
        GsfData.fromPosition(pos: 0, length: 6, bytes: bytes, offset: offset);
    nameLength = Standard4BytesData(
        position: unknownData.relativeEnd, bytes: bytes, offset: offset);
    name = GsfData.fromPosition(
      pos: nameLength.relativeEnd,
      length: nameLength.value,
      bytes: bytes,
      offset: offset,
    );
    print("dust trail info name: $name");
    if (name.value == ComposedDustrail.name) {
      composedDustrail = ComposedDustrail.fromBytes(
        bytes,
        name.offsettedLength(offset) + 8,
      );
    } else {
      simpleDustrail = SimpleDustrail.fromBytes(
        bytes,
        name.offsettedLength(offset),
      );
    }
  }

  @override
  int getEndOffset() {
    return composedDustrail != null
        ? composedDustrail!.getEndOffset()
        : simpleDustrail!.getEndOffset();
  }

  @override
  String toString() {
    return 'DustTrailInfo: $name';
  }
}

class SimpleDustrail extends GsfPart {
  // 4 unknown bytes
  late final Standard4BytesData<UnknowData> unknownData;
  late final Standard4BytesData<int> settingsCount;

  SimpleDustrail.fromBytes(Uint8List bytes, int offset)
      : super(offset: offset) {
    unknownData = Standard4BytesData(position: 0, bytes: bytes, offset: offset);
    settingsCount = Standard4BytesData(
      position: unknownData.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
  }

  @override
  int getEndOffset() {
    return settingsCount.offsettedLength(offset);
  }
}

class ComposedDustrail extends GsfPart {
  static const String name = "_dusttrail";

  late final ComposedDustrailCount count;
  late final ComposedDustrailForce force;
  late final ComposedDustrailOffsetZ offsetZ;
  late final ComposedDustrailOffsety offsetY;

  ComposedDustrail.fromBytes(Uint8List bytes, int offset)
      : super(offset: offset) {
    count = ComposedDustrailCount.fromBytes(bytes, offset);
    force = ComposedDustrailForce.fromBytes(
      bytes,
      count.getEndOffset(),
    );
    offsetZ = ComposedDustrailOffsetZ.fromBytes(
      bytes,
      force.getEndOffset(),
    );
    offsetY = ComposedDustrailOffsety.fromBytes(
      bytes,
      offsetZ.getEndOffset(),
    );
  }

  @override
  int getEndOffset() {
    return offsetY.getEndOffset();
  }
}

class ComposedDustrailCount extends GsfPart {
  late final Standard4BytesData<int> nameLength;
  late final GsfData<String> name;
  late final GsfData<UnknowData> unknownData;

  ComposedDustrailCount.fromBytes(Uint8List bytes, int offset)
      : super(offset: offset) {
    nameLength = Standard4BytesData(position: 0, bytes: bytes, offset: offset);
    name = GsfData.fromPosition(
      pos: nameLength.relativeEnd,
      length: nameLength.value,
      bytes: bytes,
      offset: offset,
    );
    print("composed dustrail count name: $name");

    unknownData = GsfData.fromPosition(
      pos: name.relativeEnd,
      length: 7,
      bytes: bytes,
      offset: offset,
    );
  }

  @override
  int getEndOffset() {
    return unknownData.offsettedLength(offset);
  }
}

class ComposedDustrailForce extends GsfPart {
  static const String kName = "force";
  late final Standard4BytesData<int> nameLength;
  late final GsfData<String> name;
  late final GsfData<UnknowData> unknownData;

  ComposedDustrailForce.fromBytes(Uint8List bytes, int offset)
      : super(offset: offset) {
    nameLength = Standard4BytesData(position: 0, bytes: bytes, offset: offset);
    name = GsfData.fromPosition(
      pos: nameLength.relativeEnd,
      length: nameLength.value,
      bytes: bytes,
      offset: offset,
    );
    assert(name.value == kName);

    unknownData = GsfData.fromPosition(
      pos: name.relativeEnd,
      length: 8,
      bytes: bytes,
      offset: offset,
    );
  }

  @override
  int getEndOffset() {
    return unknownData.offsettedLength(offset);
  }
}

class ComposedDustrailOffsetZ extends GsfPart {
  static const String kName = "offset_z";
  late final Standard4BytesData<int> nameLength;
  late final GsfData<String> name;
  late final GsfData<UnknowData> unknownData;

  ComposedDustrailOffsetZ.fromBytes(Uint8List bytes, int offset)
      : super(offset: offset) {
    nameLength = Standard4BytesData(position: 0, bytes: bytes, offset: offset);
    name = GsfData.fromPosition(
      pos: nameLength.relativeEnd,
      length: nameLength.value,
      bytes: bytes,
      offset: offset,
    );
    assert(name.value == kName);

    unknownData = GsfData.fromPosition(
      pos: name.relativeEnd,
      length: 8,
      bytes: bytes,
      offset: offset,
    );
  }

  @override
  int getEndOffset() {
    return unknownData.offsettedLength(offset);
  }
}

class ComposedDustrailOffsety extends GsfPart {
  static const String kName = "offset_y";
  late final Standard4BytesData<int> nameLength;
  late final GsfData<String> name;
  late final GsfData<UnknowData> unknownData;

  ComposedDustrailOffsety.fromBytes(Uint8List bytes, int offset)
      : super(offset: offset) {
    nameLength = Standard4BytesData(position: 0, bytes: bytes, offset: offset);
    name = GsfData.fromPosition(
      pos: nameLength.relativeEnd,
      length: nameLength.value,
      bytes: bytes,
      offset: offset,
    );
    assert(name.value == kName);

    unknownData = GsfData.fromPosition(
      pos: name.relativeEnd,
      length: 8,
      bytes: bytes,
      offset: offset,
    );
  }

  @override
  int getEndOffset() {
    return unknownData.offsettedLength(offset);
  }
}
