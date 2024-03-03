import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/gsf/header2/material.dart';
import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';

class MaterialsTable extends GsfPart {
  late final Standard4BytesData<int> materialCount;
  late final Standard4BytesData<int> materialOffset;
  late final Standard4BytesData<int> maxEntriesCount;
  late final List<MaterialData> materials;

  @override
  String get label => "Materials Table with ${maxEntriesCount.value} materials";

  MaterialsTable.fromBytes(Uint8List bytes, int offset)
      : super(offset: offset) {
    materialCount = Standard4BytesData(
      position: 0,
      bytes: bytes,
      offset: offset,
    );

    materialOffset = Standard4BytesData(
      position: materialCount.relativeEnd,
      bytes: bytes,
      offset: offset,
    );

    maxEntriesCount = Standard4BytesData(
      position: materialOffset.relativeEnd,
      bytes: bytes,
      offset: offset,
    );

    materials = [];
    for (var i = 0; i < maxEntriesCount.value; i++) {
      materials.add(
        MaterialData.fromBytes(
          bytes,
          materials.isEmpty
              ? materialOffset.offsettedPos + materialOffset.value
              : materials.last.getEndOffset(),
        ),
      );
    }
  }

  @override
  int getEndOffset() {
    return maxEntriesCount.offsettedLength;
  }

  @override
  String toString() {
    return 'MaterialsHeader: $materialCount, $materialOffset';
  }
}
