import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';

class WalkSet extends GsfPart {
  WalkSet({
    required offset,
  }) : super(offset: offset);

  late final VariableTwoBytesData<int> walk1PosData;
  late final VariableTwoBytesData<int> walk2PosData;
  late final VariableTwoBytesData<int> walk3PosData;
  late final VariableTwoBytesData<int> walk4PosData;
  late final VariableTwoBytesData<int> walk1endSData;
  late final VariableTwoBytesData<int> walk1endMData;
  late final VariableTwoBytesData<int> walk1endLData;
  late final VariableTwoBytesData<int> walk2endSData;
  late final VariableTwoBytesData<int> walk2endMData;
  late final VariableTwoBytesData<int> walk2endLData;
  late final VariableTwoBytesData<int> walk3endSData;
  late final VariableTwoBytesData<int> walk3endMData;
  late final VariableTwoBytesData<int> walk3endLData;
  late final VariableTwoBytesData<int> walk4endSData;
  late final VariableTwoBytesData<int> walk4endMData;
  late final VariableTwoBytesData<int> walk4endLData;
  late final VariableTwoBytesData<int> standingTurnRightData;
  late final VariableTwoBytesData<int> standingTurnLeftData;
  // one unknpw byte
  late final VariableTwoBytesData<int> unknownData;
  late final VariableTwoBytesData<int> accel1To2Data;
  late final VariableTwoBytesData<int> accel2To3Data;
  late final VariableTwoBytesData<int> accel3To4Data;
  late final VariableTwoBytesData<int> brake4To3Data;
  late final VariableTwoBytesData<int> brake3To2Data;
  late final VariableTwoBytesData<int> brake2To1Data;
  late final VariableTwoBytesData<int> walkLeftData;
  late final VariableTwoBytesData<int> walkRightData;

  // one unknown byte
  late final VariableTwoBytesData<int> unknownData2;
  late final VariableTwoBytesData<int> walkTransitionIndexData;
  late final VariableTwoBytesData<int> growUpData;
  late final VariableTwoBytesData<int> sailUpData;
  late final VariableTwoBytesData<int> sailDownData;
  late final VariableTwoBytesData<int> standAnimData;
  late final VariableTwoBytesData<int> walkToSwimData;
  // 8 unused bytes
  late final VariableTwoBytesData<int> hitReactionFront;
  late final VariableTwoBytesData<int> hitReactionLeft;
  late final VariableTwoBytesData<int> hitReactionRight;
  late final VariableTwoBytesData<int> hitReactionBack;

  late final VariableTwoBytesData<int> hitReactionFrontVariant;
  late final VariableTwoBytesData<int> hitReactionLeftVariant;
  late final VariableTwoBytesData<int> hitReactionRightVariant;
  late final VariableTwoBytesData<int> hitReactionBackVariant;
  
  late final GsfData<String> name;

  WalkSet.fromBytes(Uint8List bytes, int offset) : super(offset: offset) {
    walk1PosData =
        VariableTwoBytesData(relativePosition: 0, bytes: bytes, offset: offset);
    walk2PosData = VariableTwoBytesData(
        relativePosition: walk1PosData.relativeEnd,
        bytes: bytes,
        offset: offset);
    walk3PosData = VariableTwoBytesData(
        relativePosition: walk2PosData.relativeEnd,
        bytes: bytes,
        offset: offset);
    walk4PosData = VariableTwoBytesData(
        relativePosition: walk3PosData.relativeEnd,
        bytes: bytes,
        offset: offset);

    walk1endSData = VariableTwoBytesData(
        relativePosition: walk4PosData.relativeEnd,
        bytes: bytes,
        offset: offset);
    walk1endMData = VariableTwoBytesData(
        relativePosition: walk1endSData.relativeEnd,
        bytes: bytes,
        offset: offset);
    walk1endLData = VariableTwoBytesData(
        relativePosition: walk1endMData.relativeEnd,
        bytes: bytes,
        offset: offset);

    walk2endSData = VariableTwoBytesData(
        relativePosition: walk1endLData.relativeEnd,
        bytes: bytes,
        offset: offset);
    walk2endMData = VariableTwoBytesData(
        relativePosition: walk2endSData.relativeEnd,
        bytes: bytes,
        offset: offset);
    walk2endLData = VariableTwoBytesData(
        relativePosition: walk2endMData.relativeEnd,
        bytes: bytes,
        offset: offset);

    walk3endSData = VariableTwoBytesData(
        relativePosition: walk2endLData.relativeEnd,
        bytes: bytes,
        offset: offset);
    walk3endMData = VariableTwoBytesData(
        relativePosition: walk3endSData.relativeEnd,
        bytes: bytes,
        offset: offset);
    walk3endLData = VariableTwoBytesData(
        relativePosition: walk3endMData.relativeEnd,
        bytes: bytes,
        offset: offset);

    walk4endSData = VariableTwoBytesData(
        relativePosition: walk3endLData.relativeEnd,
        bytes: bytes,
        offset: offset);
    walk4endMData = VariableTwoBytesData(
        relativePosition: walk4endSData.relativeEnd,
        bytes: bytes,
        offset: offset);
    walk4endLData = VariableTwoBytesData(
        relativePosition: walk4endMData.relativeEnd,
        bytes: bytes,
        offset: offset);

    standingTurnRightData = VariableTwoBytesData(
        relativePosition: walk4endLData.relativeEnd,
        bytes: bytes,
        offset: offset);

    standingTurnLeftData = VariableTwoBytesData(
        relativePosition: standingTurnRightData.relativeEnd,
        bytes: bytes,
        offset: offset);

    unknownData = VariableTwoBytesData(
        relativePosition: standingTurnLeftData.relativeEnd,
        bytes: bytes,
        offset: offset);

    accel1To2Data = VariableTwoBytesData(
        relativePosition: unknownData.relativeEnd,
        bytes: bytes,
        offset: offset);

    accel2To3Data = VariableTwoBytesData(
        relativePosition: accel1To2Data.relativeEnd,
        bytes: bytes,
        offset: offset);

    accel3To4Data = VariableTwoBytesData(
        relativePosition: accel2To3Data.relativeEnd,
        bytes: bytes,
        offset: offset);

    brake4To3Data = VariableTwoBytesData(
        relativePosition: accel3To4Data.relativeEnd,
        bytes: bytes,
        offset: offset);

    brake3To2Data = VariableTwoBytesData(
        relativePosition: brake4To3Data.relativeEnd,
        bytes: bytes,
        offset: offset);

    brake2To1Data = VariableTwoBytesData(
        relativePosition: brake3To2Data.relativeEnd,
        bytes: bytes,
        offset: offset);

    walkLeftData = VariableTwoBytesData(
      relativePosition: brake2To1Data.relativeEnd,
      bytes: bytes,
      offset: offset,
    );

    walkRightData = VariableTwoBytesData(
      relativePosition: walkLeftData.relativeEnd,
      bytes: bytes,
      offset: offset,
    );

    unknownData2 = VariableTwoBytesData(
      relativePosition: walkRightData.relativeEnd,
      bytes: bytes,
      offset: offset,
    );

    walkTransitionIndexData = VariableTwoBytesData(
      relativePosition: unknownData2.relativeEnd,
      bytes: bytes,
      offset: offset,
    );

    growUpData = VariableTwoBytesData(
      relativePosition: walkTransitionIndexData.relativeEnd,
      bytes: bytes,
      offset: offset,
    );

    sailUpData = VariableTwoBytesData(
      relativePosition: growUpData.relativeEnd,
      bytes: bytes,
      offset: offset,
    );

    sailDownData = VariableTwoBytesData(
      relativePosition: sailUpData.relativeEnd,
      bytes: bytes,
      offset: offset,
    );

    standAnimData = VariableTwoBytesData(
      relativePosition: sailDownData.relativeEnd,
      bytes: bytes,
      offset: offset,
    );

    walkToSwimData = VariableTwoBytesData(
      relativePosition: standAnimData.relativeEnd,
      bytes: bytes,
      offset: offset,
    );

    hitReactionFront = VariableTwoBytesData(
      relativePosition: walkToSwimData.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    hitReactionLeft = VariableTwoBytesData(
      relativePosition: hitReactionFront.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    hitReactionRight = VariableTwoBytesData(
      relativePosition: hitReactionLeft.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    hitReactionBack = VariableTwoBytesData(
      relativePosition: hitReactionRight.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    hitReactionFrontVariant = VariableTwoBytesData(
      relativePosition: hitReactionBack.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    hitReactionLeftVariant = VariableTwoBytesData(
      relativePosition: hitReactionFrontVariant.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    hitReactionRightVariant = VariableTwoBytesData(
      relativePosition: hitReactionLeftVariant.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    hitReactionBackVariant = VariableTwoBytesData(
      relativePosition: hitReactionRightVariant.relativeEnd,
      bytes: bytes,
      offset: offset,
    );

    name = Standard4BytesData(
      position: hitReactionBackVariant.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
  }

  @override
  String toString() {
    return 'WalkSet: $name';
  }

  @override
  int getEndOffset() {
    return name.offsettedLength;
  }
}
