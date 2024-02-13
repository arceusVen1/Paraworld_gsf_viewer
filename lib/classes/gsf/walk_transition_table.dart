import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/gsf/walk_transition_info.dart';
import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';

class WalkTransitionTable extends GsfPart {
  WalkTransitionTable({
    required offset,
    required this.transitionCount,
  }) : super(offset: offset);

  late final int transitionCount;
  late final List<WalkTransitionInfo> transitionInfos;

  static const GsfData transitionCountData = Standard4BytesData(pos: 0);

  WalkTransitionTable.fromBytes(Uint8List bytes, int offset)
      : super(offset: offset) {
    transitionCount = transitionCountData.getAsUint(bytes, offset);
    print("walk transition table count: $transitionCount");
    transitionInfos = [];
    for (var i = 0; i < transitionCount; i++) {
      transitionInfos.add(
        WalkTransitionInfo.fromBytes(
          bytes,
          transitionInfos.isNotEmpty
              ? transitionInfos.last.getEndOffset()
              : transitionCountData.offsettedLength(offset),
        ),
      );
      print(transitionInfos.last);
    }
  }

  @override
  int getEndOffset() {
    return transitionInfos.isNotEmpty
        ? transitionInfos.last.getEndOffset()
        : transitionCountData.offsettedLength(offset);
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