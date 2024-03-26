import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/bouding_box.dart';
import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';

class BoundingBox extends GsfPart {
  late final Standard4BytesData<double> minX;
  late final Standard4BytesData<double> minY;
  late final Standard4BytesData<double> minZ;
  late final Standard4BytesData<double> maxX;
  late final Standard4BytesData<double> maxY;
  late final Standard4BytesData<double> maxZ;

    @override
  String get label => 'Model bounding Box (min: $minX, $minY, $minZ; max: $maxX, $maxY, $maxZ)';

  BoundingBox.fromBytes(Uint8List bytes, int offset) : super(offset: offset) {
    minX = Standard4BytesData(
      position: 0,
      bytes: bytes,
      offset: offset,
    );
    minY = Standard4BytesData(
      position: minX.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    minZ = Standard4BytesData(
      position: minY.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    maxX = Standard4BytesData(
      position: minZ.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    maxY = Standard4BytesData(
      position: maxX.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    maxZ = Standard4BytesData(
      position: maxY.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
  }

  BoundingBoxModel toModelBox() {
    return BoundingBoxModel(
      x: (min: minX.value, max: maxX.value),
      y: (min: minY.value, max: maxY.value),
      z: (min: minZ.value, max: maxZ.value),
    );
  }

  @override
  int getEndOffset() => maxZ.offsettedLength;
}