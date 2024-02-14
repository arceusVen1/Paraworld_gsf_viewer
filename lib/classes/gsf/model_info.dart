import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/gsf/model_anim.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/walk_set_table.dart';
import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';

class ModelInfo extends GsfPart {
  ModelInfo({
    required offset,
    required this.name,
    required this.index,
    required this.animCount,
    required this.modelAnims,
    this.walkSetTable,
  }) : super(offset: offset);

  late final String name;
  late final int index;
  late final int animCount;
  late final List<ModelAnim>
      modelAnims; // watch out for 4 zero bytes between each anim
  WalkSetTable? walkSetTable;

  static const GsfData nameLengthData = Standard4BytesData(pos: 0);
  late GsfData _nameData;
  late Standard4BytesData _indexData;
  late Standard4BytesData _animCountData;

  ModelInfo.fromBytes(Uint8List bytes, int offset) : super(offset: offset) {
    final nameLength = nameLengthData.getAsUint(bytes, offset);

    _nameData = GsfData(pos: nameLengthData.length, length: nameLength);
    name = _nameData.getAsAsciiString(bytes, offset);
    print("model info name: $name");

    _indexData =
        Standard4BytesData(pos: nameLengthData.length + _nameData.length);
    index = _indexData.getAsUint(bytes, offset);

    _animCountData = Standard4BytesData(pos: _indexData.relativeEnd());
    animCount = _animCountData.getAsUint(bytes, offset);

    print("model info anim count: $animCount");

    modelAnims = [];
    if (animCount > 0) {
      modelAnims.add(ModelAnim.fromBytes(
        bytes,
        _animCountData.offsettedLength(offset),
      ));
      for (var i = 1; i < animCount; i++) {
        modelAnims.add(ModelAnim.fromBytes(
          bytes,
          modelAnims.last.getEndOffset() + 4, // 4 zero bytes between each anim
        ));
      }
      walkSetTable = WalkSetTable.fromBytes(
        bytes,
        modelAnims.last.getEndOffset(), // walkset zero bytes
      );
    }
  }

  @override
  int getEndOffset() {
    return walkSetTable != null
        ? walkSetTable!.getEndOffset()
        : _animCountData.offsettedLength(offset) +
            4; // 4 walkset zero bytes at the end
  }

  @override
  String toString() {
    return 'ModelInfo: $name, $index, $animCount, $modelAnims, $walkSetTable';
  }
}
