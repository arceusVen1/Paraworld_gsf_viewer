import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';

class Bone extends GsfPart {
  late final Standard4BytesData<int> guid;
  late final Standard4BytesData<int> flags;
  late final Standard4BytesData<double> animPositionX;
  late final Standard4BytesData<double> animPositionY;
  late final Standard4BytesData<double> animPositionZ;
  late final Standard4BytesData<double> scaleX;
  late final Standard4BytesData<double> scaleY;
  late final Standard4BytesData<double> scaleZ;
  late final Standard4BytesData<double> quaternionL;
  late final Standard4BytesData<double> quaternionI;
  late final Standard4BytesData<double> quaternionJ;
  late final Standard4BytesData<double> quaternionK;
  late final Standard4BytesData<int> bonesCount;
  late final Standard4BytesData<int> nextBoneOffset;
  late final Standard4BytesData<int> bonesCount2;

  @override
  String get label => 'Bone $guid';
  
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
    animPositionX = Standard4BytesData(
      position: flags.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    animPositionY = Standard4BytesData(
      position: animPositionX.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    animPositionZ = Standard4BytesData(
      position: animPositionY.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    scaleX = Standard4BytesData(
      position: animPositionZ.relativeEnd,
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
    quaternionL = Standard4BytesData(
      position: scaleZ.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    quaternionI = Standard4BytesData(
      position: quaternionL.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    quaternionJ = Standard4BytesData(
      position: quaternionI.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    quaternionK = Standard4BytesData(
      position: quaternionJ.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    bonesCount = Standard4BytesData(
      position: quaternionK.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    nextBoneOffset = Standard4BytesData(
      position: bonesCount.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    bonesCount2 = Standard4BytesData(
      position: nextBoneOffset.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
  }

  @override 
  int getEndOffset() {
    return bonesCount2.offsettedLength;    
  }
}