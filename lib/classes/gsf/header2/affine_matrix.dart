import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';

class AffineTransformation extends GsfPart {
  late final Standard4BytesData<double> scaleX;
  late final Standard4BytesData<double> stretchY;
  late final Standard4BytesData<double> stretchZX;
  late final Standard4BytesData<double> unknownFloat1;
  late final Standard4BytesData<double> stretchX;
  late final Standard4BytesData<double> scaleY;
  late final Standard4BytesData<double> stretchZY;
  late final Standard4BytesData<double> unknownFloat2;
  late final Standard4BytesData<double> shearX;
  late final Standard4BytesData<double> shearY;
  late final Standard4BytesData<double> scaleZ;
  late final Standard4BytesData<double> unknownFloat3;
  late final Standard4BytesData<double> positionX;
  late final Standard4BytesData<double> positionY;
  late final Standard4BytesData<double> positionZ;
  late final Standard4BytesData<double> unknownFloat4;

  @override
  String get label => 'affine transformation';

  AffineTransformation.fromBytes(Uint8List bytes, int offset)
      : super(offset: offset) {
    scaleX = Standard4BytesData(
      position: 0,
      bytes: bytes,
      offset: offset,
    );
    stretchY = Standard4BytesData(
      position: scaleX.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    stretchZX = Standard4BytesData(
      position: stretchY.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    unknownFloat1 = Standard4BytesData(
      position: stretchZX.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    stretchX = Standard4BytesData(
      position: unknownFloat1.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    scaleY = Standard4BytesData(
      position: stretchX.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    stretchZY = Standard4BytesData(
      position: scaleY.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    unknownFloat2 = Standard4BytesData(
      position: stretchZY.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    shearX = Standard4BytesData(
      position: unknownFloat2.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    shearY = Standard4BytesData(
      position: shearX.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    scaleZ = Standard4BytesData(
      position: shearY.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    unknownFloat3 = Standard4BytesData(
      position: scaleZ.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    positionX = Standard4BytesData(
      position: unknownFloat3.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    positionY = Standard4BytesData(
      position: positionX.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    positionZ = Standard4BytesData(
      position: positionY.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    unknownFloat4 = Standard4BytesData(
      position: positionZ.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
  }

  @override
  int getEndOffset() {
    return unknownFloat4.offsettedLength;
  }
}
