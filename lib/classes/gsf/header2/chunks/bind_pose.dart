import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';

class BindPose extends GsfPart {
  late final Standard4BytesData<double> float1To1;
  late final Standard4BytesData<double> float1To2;
  late final Standard4BytesData<double> float1To3;
  late final Standard4BytesData<double> float1To4;
  late final Standard4BytesData<double> float2To1;
  late final Standard4BytesData<double> float2To2;
  late final Standard4BytesData<double> float2To3;
  late final Standard4BytesData<double> float2To4;
  late final Standard4BytesData<double> float3To1;
  late final Standard4BytesData<double> float3To2;
  late final Standard4BytesData<double> float3To3;
  late final Standard4BytesData<double> float3To4;
  late final Standard4BytesData<double> float4To1;
  late final Standard4BytesData<double> float4To2;
  late final Standard4BytesData<double> float4To3;
  late final Standard4BytesData<double> float4To4;


  @override
  String get label => 'Bind Pose';

  BindPose.fromBytes(Uint8List bytes, int offset) : super(offset: offset) {
    float1To1 = Standard4BytesData(
      position: 0,
      bytes: bytes,
      offset: offset,
    );
    float1To2 = Standard4BytesData(
      position: float1To1.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    float1To3 = Standard4BytesData(
      position: float1To2.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    float1To4 = Standard4BytesData(
      position: float1To3.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    float2To1 = Standard4BytesData(
      position: float1To4.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    float2To2 = Standard4BytesData(
      position: float2To1.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    float2To3 = Standard4BytesData(
      position: float2To2.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    float2To4 = Standard4BytesData(
      position: float2To3.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    float3To1 = Standard4BytesData(
      position: float2To4.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    float3To2 = Standard4BytesData(
      position: float3To1.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    float3To3 = Standard4BytesData(
      position: float3To2.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    float3To4 = Standard4BytesData(
      position: float3To3.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    float4To1 = Standard4BytesData(
      position: float3To4.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    float4To2 = Standard4BytesData(
      position: float4To1.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    float4To3 = Standard4BytesData(
      position: float4To2.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    float4To4 = Standard4BytesData(
      position: float4To3.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
  }

  @override
  int getEndOffset() => float4To4.offsettedLength;
}