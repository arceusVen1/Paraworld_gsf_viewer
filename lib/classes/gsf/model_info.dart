import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/gsf/model_anim.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/walk_set_table.dart';
import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';

class ModelInfo extends GsfPart {
  ModelInfo({
    required offset,
    required this.name,
  }) : super(offset: offset);

  late final String name;
  late final int index;
  late final int animCount;
  final List<ModelAnim> modelAnims =
      []; // watch out for 4 zero bytes between each anim
  late final WalkSetTable walkSetTable;

  static const GsfData nameLengthData = Standard4BytesData(pos: 0);

  ModelInfo.fromBytes(Uint8List bytes, int offset) : super(offset: offset) {
    final nameLength = nameLengthData.getAsUint(bytes, offset);

    final nameData = GsfData(pos: nameLengthData.length, length: nameLength);
    name = nameData.getAsAsciiString(bytes, offset);
    print("model info name: $name");

    final indexData =
        Standard4BytesData(pos: nameLengthData.length + nameData.length);
    index = indexData.getAsUint(bytes, offset);

    final animCountData = Standard4BytesData(
        pos: nameLengthData.length + nameData.length + indexData.length);
    animCount = animCountData.getAsUint(bytes, offset);
    print("model info anim count: $animCount");

    if (animCount > 0) {
      modelAnims.add(ModelAnim.fromBytes(
        bytes,
        animCountData.offsettedLength(offset),
      ));
      for (var i = 1; i < animCount; i++) {
        modelAnims.add(ModelAnim.fromBytes(
          bytes,
          modelAnims.last.getEndOffset() + 4, // 4 zero bytes between each anim
        ));
      }
    }

    walkSetTable = WalkSetTable.fromBytes(
      bytes,
      modelAnims.isNotEmpty
          ? modelAnims.last.getEndOffset()
          : animCountData.offsettedLength(offset),
    );
  }

  @override
  int getEndOffset() {
    return walkSetTable.getEndOffset();
  }

  @override
  String toString() {
    return 'ModelInfo: $name, $index, $animCount, $modelAnims, $walkSetTable';
  }
}
