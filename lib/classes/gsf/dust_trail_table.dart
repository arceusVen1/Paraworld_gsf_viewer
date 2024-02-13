import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/gsf/dust_trail_info.dart';
import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';

class DustTrailTable extends GsfPart {
  DustTrailTable({
    required offset,
    required this.dustTrailCount,
  }) : super(offset: offset);

  late final int dustTrailCount;
  late final List<DustTrailInfo> dustTrailInfos;

  static const GsfData dustTrailCountData = Standard4BytesData(pos: 0);

  DustTrailTable.fromBytes(Uint8List bytes, int offset)
      : super(offset: offset) {
    dustTrailCount = dustTrailCountData.getAsUint(bytes, offset);
    print("dust trail table count: $dustTrailCount");
    dustTrailInfos = [];
    for (var i = 0; i < dustTrailCount; i++) {
      dustTrailInfos.add(
        DustTrailInfo.fromBytes(
          bytes,
          dustTrailInfos.isNotEmpty
              ? dustTrailInfos.last.getEndOffset()
              : dustTrailCountData.offsettedLength(offset),
        ),
      );
      print(dustTrailInfos.last);
    }
  }

  @override
  int getEndOffset() {
    return dustTrailInfos.isNotEmpty
        ? dustTrailInfos.last.getEndOffset()
        : dustTrailCountData.offsettedLength(offset);
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
