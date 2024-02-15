import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/gsf/walk_set.dart';
import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';

class WalkSetTable extends GsfPart {
  // 4 unused zero bytes

  late final Standard4BytesData<int> count;
  final List<WalkSet> walkSets = [];

  WalkSetTable.fromBytes(Uint8List bytes, int offset) : super(offset: offset) {
    count = Standard4BytesData(position: 0, bytes: bytes, offset: offset);
    print("walk set table count: $count");
    for (var i = 0; i < count.value; i++) {
      walkSets.add(WalkSet.fromBytes(
        bytes,
        walkSets.isNotEmpty
            ? walkSets.last.getEndOffset()
            : count.offsettedLength(offset),
      ));
    }
  }

  @override
  int getEndOffset() => walkSets.isNotEmpty
      ? walkSets.last.getEndOffset()
      : count.offsettedLength(offset);

  @override
  String toString() {
    return 'WalkSetTable: $count';
  }
}
