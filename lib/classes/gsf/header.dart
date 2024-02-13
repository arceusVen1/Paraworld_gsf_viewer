import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/gsf/model_info.dart';
import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';

class Header extends GsfPart {
  Header({
    required this.name,
    required this.modelCount,
  }) : super(offset: 0);

  late final String name;
  late final int modelCount;
  final List<ModelInfo> modelInfos = [];

  static const Standard4BytesData contentTableOffsetData =
      Standard4BytesData(pos: 8);
  static const Standard4BytesData nameLengthData = Standard4BytesData(pos: 12);
  static const int namePos = 16;

  Header.fromBytes(Uint8List bytes) : super(offset: 0) {
    assert(contentTableOffsetData.getAsUint(bytes, offset) == 0x10000);

    final nameLength = nameLengthData.getAsUint(bytes, offset);

    name = GsfData(pos: namePos, length: nameLength)
        .getAsAsciiString(bytes, offset);
    print("name: $name");

    final modelCountData = Standard4BytesData(pos: namePos + nameLength);
    modelCount = modelCountData.getAsUint(bytes, offset);
    print("modelCount: $modelCount");

    for (var i = 0; i < modelCount; i++) {
      modelInfos.add(
        ModelInfo.fromBytes(
          bytes,
          modelInfos.isNotEmpty
              ? modelInfos.last.getEndOffset()
              : modelCountData.offsettedLength(offset),
        ),
      );
      print(modelInfos.last);
    }
  }

  @override
  String toString() {
    return 'Header: $name $modelCount models.';
  }

  @override
  bool operator ==(Object other) =>
      other is Header && other.name == name && other.modelCount == modelCount;

  @override
  int get hashCode => name.hashCode ^ modelCount.hashCode;

  @override
  int getEndOffset() {
    return modelInfos.isNotEmpty
        ? modelInfos.last.getEndOffset()
        : namePos + nameLengthData.getAsUint(Uint8List(4), 0) + 4;
  }
}
