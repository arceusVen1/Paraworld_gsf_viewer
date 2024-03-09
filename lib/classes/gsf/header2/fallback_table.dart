
import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';

class FallbackTable extends GsfPart {
  late final Standard4BytesData<NegativeOffset> header2Offset;
  late final Standard4BytesData<NegativeOffset> modelSettingsOffset;
  late final Standard4BytesData<int> unknownInt;
  late final Standard4BytesData<int> usedMaterialsCount;
  late final Standard4BytesData<int> unknownInt2;
  late final List<Standard4BytesData<int>> usedMaterialIndexes;
  

  FallbackTable.fromBytes(Uint8List bytes, int offset) : super(offset: offset) {
    header2Offset = Standard4BytesData(
      position: 0,
      bytes: bytes,
      offset: offset,
    );
    modelSettingsOffset = Standard4BytesData(
      position: header2Offset.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    unknownInt = Standard4BytesData(
      position: modelSettingsOffset.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    usedMaterialsCount = Standard4BytesData(
      position: unknownInt.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    unknownInt2 = Standard4BytesData(
      position: usedMaterialsCount.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    usedMaterialIndexes = [];
    for (var i = 0; i < usedMaterialsCount.value; i++) {
      usedMaterialIndexes.add(Standard4BytesData(
        position: usedMaterialIndexes.isEmpty ? unknownInt2.relativeEnd : usedMaterialIndexes.last.relativeEnd,
        bytes: bytes,
        offset: offset,
      ));
    }
  }
  @override
  String get label => 'Fallback Table with ${usedMaterialsCount.value} materials';

  @override
  int getEndOffset() => usedMaterialIndexes.isEmpty ? unknownInt2.offsettedLength : usedMaterialIndexes.last.offsettedLength;
}