import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';

class ObjectName extends GsfPart {
  late final Standard4BytesData<int> stringCount;
  late final Standard4BytesData<int> maxCharactersCount;
  late final Standard4BytesData<int> nameLength;
  late final GsfData<StringNoZero> name;
  late final GsfData<UnknowData> unknownData;

  @override
  String get label => name.value.value;

  ObjectName.fromBytes(Uint8List bytes, int offset) : super(offset: offset) {
    stringCount = Standard4BytesData(
      position: 0,
      bytes: bytes,
      offset: offset,
    );
    maxCharactersCount = Standard4BytesData(
      position: stringCount.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    nameLength = Standard4BytesData(
      position: maxCharactersCount.relativeEnd,
      bytes: bytes,
      offset: offset,
    );

    name = GsfData.fromPosition(
      relativePos: nameLength.relativeEnd,
      length: nameLength.value,
      bytes: bytes,
      offset: offset,
    );

    unknownData = GsfData.fromPosition(
      relativePos: name.relativeEnd,
      length: maxCharactersCount.value - nameLength.value,
      bytes: bytes,
      offset: offset,
    );
  }

  @override
  int getEndOffset() {
    return unknownData.offsettedLength;
  }
}
