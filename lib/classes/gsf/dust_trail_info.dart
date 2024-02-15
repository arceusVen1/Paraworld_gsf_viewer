import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';

class DustTrailInfo extends GsfPart {
  static const GsfData nameLengthData = Standard4BytesData(pos: 6);
  late GsfData _nameData;

  // 6 unknown bytes
  late final int nameLength;
  late final String name;
  ComposedDustrail? composedDustrail;
  SimpleDustrail? simpleDustrail;

  DustTrailInfo.fromBytes(Uint8List bytes, int offset) : super(offset: offset) {
    nameLength = nameLengthData.getAsUint(bytes, offset);
    _nameData = GsfData(pos: nameLengthData.relativeEnd(), length: nameLength);
    name = _nameData.getAsAsciiString(bytes, offset);
    print("dust trail info name: $name");
    if (name == ComposedDustrail.name) {
      composedDustrail = ComposedDustrail.fromBytes(
        bytes,
        _nameData.offsettedLength(offset) + 8,
      );
    } else {
      simpleDustrail = SimpleDustrail.fromBytes(
        bytes,
        _nameData.offsettedLength(offset),
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
  static const GsfData settingsCountData = Standard4BytesData(pos: 4);
  late final int settingsCount;

  SimpleDustrail.fromBytes(Uint8List bytes, int offset)
      : super(offset: offset) {
    settingsCount = settingsCountData.getAsUint(bytes, offset);
  }

  @override
  int getEndOffset() {
    return settingsCountData.offsettedLength(offset);
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
  static const GsfData _nameLengthData = Standard4BytesData(pos: 0);
  late final GsfData _nameData;
  late final GsfData unknownData;

  late final String name;
  ComposedDustrailCount.fromBytes(Uint8List bytes, int offset)
      : super(offset: offset) {
    final nameLength = _nameLengthData.getAsUint(bytes, offset);
    _nameData = GsfData(pos: _nameLengthData.length, length: nameLength);
    name = _nameData.getAsAsciiString(bytes, offset);
    print("composed dustrail count name: $name");

    unknownData = GsfData(pos: _nameData.relativeEnd(), length: 7);
  }

  @override
  int getEndOffset() {
    return unknownData.offsettedLength(offset);
  }
}

class ComposedDustrailForce extends GsfPart {
  static const String name = "force";
  static const GsfData _nameLengthData = Standard4BytesData(pos: 0);
  late final GsfData _nameData;
  late final GsfData unknownData;

  ComposedDustrailForce.fromBytes(Uint8List bytes, int offset)
      : super(offset: offset) {
    final nameLength = _nameLengthData.getAsUint(bytes, offset);
    _nameData = GsfData(pos: _nameLengthData.length, length: nameLength);
    assert(name == _nameData.getAsAsciiString(bytes, offset));

    unknownData = GsfData(pos: _nameData.relativeEnd(), length: 8);
  }

  @override
  int getEndOffset() {
    return unknownData.offsettedLength(offset);
  }
}

class ComposedDustrailOffsetZ extends GsfPart {
  static const String name = "offset_z";
  static const GsfData _nameLengthData = Standard4BytesData(pos: 0);
  late final GsfData _nameData;
  late final GsfData unknownData;

  ComposedDustrailOffsetZ.fromBytes(Uint8List bytes, int offset)
      : super(offset: offset) {
    final nameLength = _nameLengthData.getAsUint(bytes, offset);
    _nameData = GsfData(pos: _nameLengthData.length, length: nameLength);
    assert(name == _nameData.getAsAsciiString(bytes, offset));

    unknownData = GsfData(pos: _nameData.relativeEnd(), length: 8);
  }

  @override
  int getEndOffset() {
    return unknownData.offsettedLength(offset);
  }
}

class ComposedDustrailOffsety extends GsfPart {
  static const String name = "offset_y";
  static const GsfData _nameLengthData = Standard4BytesData(pos: 0);
  late final GsfData _nameData;
  late final GsfData unknownData;

  ComposedDustrailOffsety.fromBytes(Uint8List bytes, int offset)
      : super(offset: offset) {
    final nameLength = _nameLengthData.getAsUint(bytes, offset);
    _nameData = GsfData(pos: _nameLengthData.length, length: nameLength);
    assert(name == _nameData.getAsAsciiString(bytes, offset));

    unknownData = GsfData(pos: _nameData.relativeEnd(), length: 8);
  }

  @override
  int getEndOffset() {
    return unknownData.offsettedLength(offset);
  }
}
