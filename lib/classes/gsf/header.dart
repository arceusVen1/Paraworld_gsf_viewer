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

  late final GsfData<int> _magic;
  late final Standard4BytesData<int> _version;

  late final Standard4BytesData<int> contentTableOffset;
  late final Standard4BytesData<int> nameLength;
  late final GsfData<String> name;
  late final Standard4BytesData<int> modelCount;
  late final List<ModelInfo> modelInfos;
  late final SoundTable soundTable;
  late final DustTrailTable dustTrailTable;
  late final WalkTransitionTable walkTransitionTable1;
  late final WalkTransitionTable
      walkTransitionTable2; // there seems to be 2 transitions tables

  Header.fromBytes(Uint8List bytes) : super(offset: 0) {
    _magic = GsfData.fromPosition(
        relativePos: 0, length: 4, bytes: bytes, offset: offset);
    print("magic: $_magic");
    _version = Standard4BytesData(
        position: _magic.relativeEnd, bytes: bytes, offset: offset);
    print("version: $_version");
    contentTableOffset = Standard4BytesData<int>(
        position: _version.relativeEnd, bytes: bytes, offset: offset);
    nameLength = Standard4BytesData<int>(
        position: contentTableOffset.relativeEnd, bytes: bytes, offset: offset);

    name = GsfData<String>.fromPosition(
      relativePos: nameLength.relativeEnd,
      length: nameLength.value,
      bytes: bytes,
      offset: offset,
    );

    modelCount = Standard4BytesData<int>(
        position: name.relativeEnd, bytes: bytes, offset: offset);
    print("modelCount: $modelCount");
    modelInfos = [];
    for (var i = 0; i < modelCount.value; i++) {
      modelInfos.add(
        ModelInfo.fromBytes(
          bytes,
          modelInfos.isNotEmpty
              ? modelInfos.last.getEndOffset()
              : modelCount.offsettedLength(offset),
        ),
      );
    }
    soundTable = SoundTable.fromBytes(
      bytes,
      modelInfos.isNotEmpty
          ? modelInfos.last.getEndOffset()
          : modelCount.offsettedLength(offset),
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
