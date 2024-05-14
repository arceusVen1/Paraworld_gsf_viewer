import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';
import 'package:vector_math/vector_math.dart';

class BindPose extends GsfPart {
  late final Standard4BytesData<double> a1_1;
  late final Standard4BytesData<double> a1_2;
  late final Standard4BytesData<double> a1_3;
  late final Standard4BytesData<double> a1_4;
  late final Standard4BytesData<double> a2_1;
  late final Standard4BytesData<double> a2_2;
  late final Standard4BytesData<double> a2_3;
  late final Standard4BytesData<double> a2_4;
  late final Standard4BytesData<double> a3_1;
  late final Standard4BytesData<double> a3_2;
  late final Standard4BytesData<double> a3_3;
  late final Standard4BytesData<double> a3_4;
  late final Standard4BytesData<double> a4_1;
  late final Standard4BytesData<double> a4_2;
  late final Standard4BytesData<double> a4_3;
  late final Standard4BytesData<double> a4_4;

  @override
  String get label => 'bind pose matrix';

  BindPose.fromBytes(Uint8List bytes, int offset)
      : super(offset: offset) {
    a1_1 = Standard4BytesData(
      position: 0,
      bytes: bytes,
      offset: offset,
    );
    a1_2 = Standard4BytesData(
      position: a1_1.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    a1_3 = Standard4BytesData(
      position: a1_2.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    a1_4 = Standard4BytesData(
      position: a1_3.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    a2_1 = Standard4BytesData(
      position: a1_4.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    a2_2 = Standard4BytesData(
      position: a2_1.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    a2_3 = Standard4BytesData(
      position: a2_2.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    a2_4 = Standard4BytesData(
      position: a2_3.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    a3_1 = Standard4BytesData(
      position: a2_4.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    a3_2 = Standard4BytesData(
      position: a3_1.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    a3_3 = Standard4BytesData(
      position: a3_2.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    a3_4 = Standard4BytesData(
      position: a3_3.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    a4_1 = Standard4BytesData(
      position: a3_4.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    a4_2 = Standard4BytesData(
      position: a4_1.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    a4_3 = Standard4BytesData(
      position: a4_2.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    a4_4 = Standard4BytesData(
      position: a4_3.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
  }

  Matrix4 get matrix {
    return Matrix4(
      a1_1.value, a1_2.value, a1_3.value, a1_4.value,
      a2_1.value, a2_2.value, a2_3.value, a2_4.value,
      a3_1.value, a3_2.value, a3_3.value, a3_4.value,
      a4_1.value, a4_2.value, a4_3.value, a4_4.value,
    );
  }

  @override
  int getEndOffset() {
    return a4_4.offsettedLength;
  }
}
