
import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';

class Header2 extends GsfPart {

  late final Standard4BytesData<int> modelsCount;
  late final Standard4BytesData<int> animCount;
  late final Standard4BytesData<int> zeroData;
  late final Standard4BytesData<int> modelSettingsOffset;
  late final Standard4BytesData<int> modelsSettingCount;
  late final Standard4BytesData<int> animSettingsOffset;
  late final Standard4BytesData<int> animSettingsCount;
  // todo: material Header
  

  Header2.fromBytes(Uint8List bytes, int offset) : super(offset: offset) {
    modelsCount = Standard4BytesData(position: 0, bytes: bytes, offset: offset);
    animCount = Standard4BytesData(position: modelsCount.relativeEnd, bytes: bytes, offset: offset);
    zeroData = Standard4BytesData(position: animCount.relativeEnd, bytes: bytes, offset: offset);
    modelSettingsOffset = Standard4BytesData(position: zeroData.relativeEnd, bytes: bytes, offset: offset);
    modelsSettingCount = Standard4BytesData(position: modelSettingsOffset.relativeEnd, bytes: bytes, offset: offset);
    animSettingsOffset = Standard4BytesData(position: modelsSettingCount.relativeEnd, bytes: bytes, offset: offset);
    animSettingsCount = Standard4BytesData(position: animSettingsOffset.relativeEnd, bytes: bytes, offset: offset);
  }
  
  @override
  int getEndOffset() {
    return animSettingsCount.offsettedLength;
  }
}