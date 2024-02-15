import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/gsf/walk_transition_info.dart';
import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';

class WalkTransitionTable extends GsfPart {
  WalkTransitionTable({
    required offset,
    required this.transitionCount,
  }) : super(offset: offset);

  late final Standard4BytesData<int> transitionCount;
  late final List<WalkTransitionInfo> transitionInfos;

  WalkTransitionTable.fromBytes(Uint8List bytes, int offset)
      : super(offset: offset) {
    transitionCount =
        Standard4BytesData(position: 0, bytes: bytes, offset: offset);
    print("walk transition table count: $transitionCount");
    transitionInfos = [];
    for (var i = 0; i < transitionCount.value; i++) {
      transitionInfos.add(
        WalkTransitionInfo.fromBytes(
          bytes,
          transitionInfos.isNotEmpty
              ? transitionInfos.last.getEndOffset()
              : transitionCount.offsettedLength(offset),
        ),
      );
      print(transitionInfos.last);
    }
  }

  @override
  int getEndOffset() {
    return transitionInfos.isNotEmpty
        ? transitionInfos.last.getEndOffset()
        : transitionCount.offsettedLength(offset);
  }

  @override
  String toString() {
    return 'WalkTransitionTable: $transitionCount transitions.';
  }

  @override
  bool operator ==(Object other) =>
      other is WalkTransitionTable &&
      other.transitionCount == transitionCount &&
      other.transitionInfos == transitionInfos;

  @override
  int get hashCode => transitionCount.hashCode ^ transitionInfos.hashCode;
}
