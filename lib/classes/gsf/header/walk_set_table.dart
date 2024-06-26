import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/gsf/header/walk_set.dart';
import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';

class WalkSetTable extends GsfPart {
  // 4 unused zero bytes

  late final Standard4BytesData<int> count;
  final List<WalkSet> walkSets = [];

  @override
  String get label => 'WalkSetTable: $count';

  WalkSetTable.fromBytes(Uint8List bytes, int offset) : super(offset: offset) {
    count = Standard4BytesData(position: 0, bytes: bytes, offset: offset);
    for (var i = 0; i < count.value; i++) {
      walkSets.add(WalkSet.fromBytes(
        bytes,
        walkSets.isNotEmpty
            ? walkSets.last.getEndOffset()
            : count.offsettedLength,
      ));
    }
  }

  @override
  int getEndOffset() => walkSets.isNotEmpty
      ? walkSets.last.getEndOffset()
      : count.offsettedLength;
}
