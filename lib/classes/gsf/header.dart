import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/gsf/dust_trail_table.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/model_info.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/sound_table.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/walk_transition_table.dart';
import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';

class Header extends GsfPart {
  Header({
    required this.name,
    required this.modelCount,
    required this.soundTable,
    required this.modelInfos,
    required this.dustTrailTable,
    required this.walkTransitionTable1,
    required this.walkTransitionTable2,
  }) : super(offset: 0);

  late final String name;
  late final int modelCount;
  late final List<ModelInfo> modelInfos;
  late final SoundTable soundTable;
  late final DustTrailTable dustTrailTable;
  late final WalkTransitionTable walkTransitionTable1;
  late final WalkTransitionTable
      walkTransitionTable2; // there seems to be 2 transitions tables

  static const Standard4BytesData contentTableOffsetData =
      Standard4BytesData(pos: 8);
  static const Standard4BytesData nameLengthData = Standard4BytesData(pos: 12);
  static const int namePos = 16;

  Header.fromBytes(Uint8List bytes) : super(offset: 0) {
    //assert(contentTableOffsetData.getAsUint(bytes, offset) == 0x10000);

    final nameLength = nameLengthData.getAsUint(bytes, offset);

    name = GsfData(pos: namePos, length: nameLength)
        .getAsAsciiString(bytes, offset);
    print("name: $name");

    final modelCountData = Standard4BytesData(pos: namePos + nameLength);
    modelCount = modelCountData.getAsUint(bytes, offset);
    print("modelCount: $modelCount");
    modelInfos = [];
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
    soundTable = SoundTable.fromBytes(
      bytes,
      modelInfos.isNotEmpty
          ? modelInfos.last.getEndOffset()
          : modelCountData.offsettedLength(offset),
    );

    dustTrailTable = DustTrailTable.fromBytes(
      bytes,
      soundTable.getEndOffset(),
    );

    walkTransitionTable1 = WalkTransitionTable.fromBytes(
      bytes,
      dustTrailTable.getEndOffset(),
    );

    walkTransitionTable2 = WalkTransitionTable.fromBytes(
      bytes,
      walkTransitionTable1.getEndOffset(),
    );
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
    return walkTransitionTable2.getEndOffset();
  }
}
