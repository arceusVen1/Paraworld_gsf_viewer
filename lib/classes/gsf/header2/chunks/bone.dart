import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/gsf/header2/affine_matrix.dart';
import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';

class Bone extends GsfPart {
  late final Standard4BytesData<int> guid;
  late final Standard4BytesData<int> flags;
  late final Standard4BytesData<double> posX;
  late final Standard4BytesData<double> posY;
  late final Standard4BytesData<double> posZ;
  late final Standard4BytesData<double> scaleX;
  late final Standard4BytesData<double> scaleY;
  late final Standard4BytesData<double> scaleZ;
  late final Standard4BytesData<double> quaternionX;
  late final Standard4BytesData<double> quaternionY;
  late final Standard4BytesData<double> quaternionZ;
  late final Standard4BytesData<double> quaternionW;
  late final Standard4BytesData<int> childrenCount;
  late final Standard4BytesData<int> nextChildOffset;
  late final Standard4BytesData<int> childrenCount2;

  AffineTransformation? bindPose;

  @override
  String get label => 'Bone 0x${guid.value.toRadixString(16)}';

  static const int size = 15 * 4; // 15 4-byte values

  Bone.fromBytes(Uint8List bytes, int offset) : super(offset: offset) {
    guid = Standard4BytesData(
      position: 0,
      bytes: bytes,
      offset: offset,
    );
    flags = Standard4BytesData(
      position: guid.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    posX = Standard4BytesData(
      position: flags.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    posY = Standard4BytesData(
      position: posX.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    posZ = Standard4BytesData(
      position: posY.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    scaleX = Standard4BytesData(
      position: posZ.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    scaleY = Standard4BytesData(
      position: scaleX.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    scaleZ = Standard4BytesData(
      position: scaleY.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    quaternionX = Standard4BytesData(
      position: scaleZ.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    quaternionY = Standard4BytesData(
      position: quaternionX.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    quaternionZ = Standard4BytesData(
      position: quaternionY.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    quaternionW = Standard4BytesData(
      position: quaternionZ.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    childrenCount = Standard4BytesData(
      position: quaternionW.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    nextChildOffset = Standard4BytesData(
      position: childrenCount.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    childrenCount2 = Standard4BytesData(
      position: nextChildOffset.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'Bone 0x${guid.value} with child: ${childrenCount.value}';
  }

  @override
  int getEndOffset() {
    return childrenCount2.offsettedLength;
  }
}
