import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/gsf/header/dust_trail_info.dart';
import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';

class DustTrailTable extends GsfPart {
  DustTrailTable({
    required offset,
    required this.dustTrailCount,
  }) : super(offset: offset);

  late final Standard4BytesData<int> dustTrailCount;
  late final List<DustTrailInfo> dustTrailInfos;

  DustTrailTable.fromBytes(Uint8List bytes, int offset)
      : super(offset: offset) {
    dustTrailCount =
        Standard4BytesData(position: 0, bytes: bytes, offset: offset);
    dustTrailInfos = [];
    for (var i = 0; i < dustTrailCount.value; i++) {
      dustTrailInfos.add(
        DustTrailInfo.fromBytes(
          bytes,
          dustTrailInfos.isNotEmpty
              ? dustTrailInfos.last.getEndOffset()
              : dustTrailCount.offsettedLength(offset),
        ),
      );
    }
  }

  @override
  int getEndOffset() {
    return dustTrailInfos.isNotEmpty
        ? dustTrailInfos.last.getEndOffset()
        : dustTrailCount.offsettedLength(offset);
  }

  @override
  String toString() {
    return 'DustTrailTable: $dustTrailCount dust trails.';
  }

  @override
  bool operator ==(Object other) =>
      other is DustTrailTable &&
      other.dustTrailCount == dustTrailCount &&
      other.dustTrailInfos == dustTrailInfos;

  @override
  int get hashCode => dustTrailCount.hashCode ^ dustTrailInfos.hashCode;
}
