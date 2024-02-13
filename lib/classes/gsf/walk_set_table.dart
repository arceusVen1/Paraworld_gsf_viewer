import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/gsf/walk_set.dart';
import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';

class WalkSetTable extends GsfPart {
  // 4 unused zero bytes
  static const GsfData countData = Standard4BytesData(pos: 4);

  late final int count;
  final List<WalkSet> walkSets = [];

  WalkSetTable.fromBytes(Uint8List bytes, int offset) : super(offset: offset) {
    count = countData.getAsUint(bytes, offset);
    print("walk set table count: $count");
    for (var i = 0; i < count; i++) {
      walkSets.add(WalkSet.fromBytes(
        bytes,
        walkSets.isNotEmpty
            ? walkSets.last.getEndOffset()
            : countData.offsettedLength(offset),
      ));
    }
  }

  @override
  int getEndOffset() => walkSets.isNotEmpty
      ? walkSets.last.getEndOffset()
      : countData.offsettedLength(offset);

  @override
  String toString() {
    return 'WalkSetTable: $count';
  }
}
