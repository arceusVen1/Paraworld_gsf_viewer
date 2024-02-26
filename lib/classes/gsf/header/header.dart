import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/gsf/header/anim_flags_table.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header/dust_trail_table.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header/model_info.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header/sound_table.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header/walk_transition_table.dart';
import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';

class Header extends GsfPart {
  Header({
    required this.modelCount,
    required this.soundTable,
    required this.modelInfos,
    required this.dustTrailTable,
  }) : super(offset: 0);

  late final GsfData<int> _magic;
  late final Standard4BytesData<int> _version;

  late final Standard4BytesData<int> header2Offset;
  late final Standard4BytesData<int> nameLength;
  late final Standard4BytesData<int> modelCount;
  late final List<ModelInfo> modelInfos;
  late final SoundTable soundTable;
  late final DustTrailTable dustTrailTable;
  late final Standard4BytesData<int> animFlagsCount;
  late final List<AnimFlagTable> animFlagsTables = [];
  late final Standard4BytesData<int> walkTransitionsCount;
  late final List<WalkTransitionTable> walkTransitionTables = [];

  Header.fromBytes(Uint8List bytes) : super(offset: 0) {
    _magic = GsfData.fromPosition(
        relativePos: 0, length: 4, bytes: bytes, offset: offset);
    print("magic: $_magic");
    _version = Standard4BytesData(
        position: _magic.relativeEnd, bytes: bytes, offset: offset);
    print("version: $_version");
    header2Offset = Standard4BytesData<int>(
        position: _version.relativeEnd, bytes: bytes, offset: offset);
    nameLength = Standard4BytesData<int>(
        position: header2Offset.relativeEnd, bytes: bytes, offset: offset);

    name = GsfData<String>.fromPosition(
      relativePos: nameLength.relativeEnd,
      length: nameLength.value,
      bytes: bytes,
      offset: offset,
    );

    modelCount = Standard4BytesData<int>(
      position: name.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    print("modelCount: $modelCount");
    modelInfos = [];
    for (var i = 0; i < modelCount.value; i++) {
      modelInfos.add(
        ModelInfo.fromBytes(
          bytes,
          modelInfos.isNotEmpty
              ? modelInfos.last.getEndOffset()
              : modelCount.offsettedLength,
        ),
      );
    }
    soundTable = SoundTable.fromBytes(
      bytes,
      modelInfos.isNotEmpty
          ? modelInfos.last.getEndOffset()
          : modelCount.offsettedLength,
    );

    dustTrailTable = DustTrailTable.fromBytes(
      bytes,
      soundTable.getEndOffset(),
    );

    animFlagsCount = Standard4BytesData(
      position: dustTrailTable.getEndOffset() - offset,
      bytes: bytes,
      offset: offset,
    );

    for (var i = 0; i < animFlagsCount.value; i++) {
      animFlagsTables.add(
        AnimFlagTable.fromBytes(
          bytes,
          animFlagsTables.isNotEmpty
              ? animFlagsTables.last.getEndOffset()
              : animFlagsCount.offsettedLength,
        ),
      );
    }

    walkTransitionsCount = Standard4BytesData(
      position: animFlagsTables.isNotEmpty
          ? animFlagsTables.last.getEndOffset() - offset
          : animFlagsCount.offsettedLength,
      bytes: bytes,
      offset: offset,
    );

    for (var i = 0; i < walkTransitionsCount.value; i++) {
      walkTransitionTables.add(
        WalkTransitionTable.fromBytes(
          bytes,
          walkTransitionTables.isNotEmpty
              ? walkTransitionTables.last.getEndOffset()
              : walkTransitionsCount.offsettedLength,
        ),
      );
    }
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
    return walkTransitionTables.isNotEmpty
        ? walkTransitionTables.last.getEndOffset()
        : walkTransitionsCount.offsettedLength;
  }
}
