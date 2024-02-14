import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';

class WalkSet extends GsfPart {
  WalkSet({
    required offset,
  }) : super(offset: offset);

  late final GsfData walk1PosData;
  late final GsfData walk2PosData;
  late final GsfData walk3PosData;
  late final GsfData walk4PosData;
  late final GsfData walk1endSData;
  late final GsfData walk1endMData;
  late final GsfData walk1endLData;
  late final GsfData walk2endSData;
  late final GsfData walk2endMData;
  late final GsfData walk2endLData;
  late final GsfData walk3endSData;
  late final GsfData walk3endMData;
  late final GsfData walk3endLData;
  late final GsfData walk4endSData;
  late final GsfData walk4endMData;
  late final GsfData walk4endLData;
  late final GsfData standingTurnRightData;
  late final GsfData standingTurnLeftData;
  // one unknpw byte
  late final GsfData unknownData;
  late final GsfData accel1To2Data;
  late final GsfData accel2To3Data;
  late final GsfData accel3To4Data;
  late final GsfData brake4To3Data;
  late final GsfData brake3To2Data;
  late final GsfData brake2To1Data;
  late final GsfData walkLeftData;
  late final GsfData walkRightData;

  // one unknown byte
  late final GsfData unknownData2;
  late final GsfData walkTransitionIndexData;
  late final GsfData growUpData;
  late final GsfData sailUpData;
  late final GsfData sailDownData;
  late final GsfData standAnimData;
  late final GsfData walkToSwimData;
  // 8 unused bytes
  late final GsfData unknownData3;
  late final GsfData unknownData4;
  late final GsfData unknownData5;
  late final GsfData unknownData6;

  late final GsfData unknownData7;
  late final GsfData unknownData8;
  late final GsfData unknownData9;
  late final GsfData unknownData10;

  late final GsfData _nameData;

  late final int walk1Pos;
  late final int walk2Pos;
  late final int walk3Pos;
  late final int walk4Pos;
  late final int walk1endS;
  late final int walk1endM;
  late final int walk1endL;
  late final int walk2endS;
  late final int walk2endM;
  late final int walk2endL;
  late final int walk3endS;
  late final int walk3endM;
  late final int walk3endL;
  late final int walk4endS;
  late final int walk4endM;
  late final int walk4endL;

  late final int standingTurnRight;
  late final int standingTurnLeft;
  late final int accel1To2;
  late final int accel2To3;
  late final int accel3To4;
  late final int brake4To3;
  late final int brake3To2;
  late final int brake2To1;
  late final int walkLeft;
  late final int walkRight;
  late final int walkTransitionIndex;
  late final int growUp;
  late final int sailUp;
  late final int sailDown;
  late final int standAnim;
  late final int walkToSwim;
  late final String name;

  GsfData getGsfDataFormat(int relativePosition, Uint8List bytes) {
    print(bytes[offset + relativePosition] & 0x80 > 0);
    if (bytes[offset + relativePosition] & 0x80 > 0) {
      return GsfData(pos: relativePosition, length: 2, maskToUse: 0x7FFF);
    } else {
      return SingleByteData(pos: relativePosition);
    }
  }

  WalkSet.fromBytes(Uint8List bytes, int offset) : super(offset: offset) {
    walk1PosData = getGsfDataFormat(0, bytes);
    walk1Pos = walk1PosData.getAsUint(bytes, offset);

    walk2PosData = getGsfDataFormat(walk1PosData.relativeEnd(), bytes);
    walk2Pos = walk2PosData.getAsUint(bytes, offset);

    walk3PosData = getGsfDataFormat(walk2PosData.relativeEnd(), bytes);
    walk3Pos = walk3PosData.getAsUint(bytes, offset);

    walk4PosData = getGsfDataFormat(walk3PosData.relativeEnd(), bytes);
    walk4Pos = walk4PosData.getAsUint(bytes, offset);

    walk1endSData = getGsfDataFormat(walk4PosData.relativeEnd(), bytes);
    walk1endS = walk1endSData.getAsUint(bytes, offset);

    walk1endMData = getGsfDataFormat(walk1endSData.relativeEnd(), bytes);
    walk1endM = walk1endMData.getAsUint(bytes, offset);

    walk1endLData = getGsfDataFormat(walk1endMData.relativeEnd(), bytes);
    walk1endL = walk1endLData.getAsUint(bytes, offset);

    walk2endSData = getGsfDataFormat(walk1endLData.relativeEnd(), bytes);
    walk2endS = walk2endSData.getAsUint(bytes, offset);

    walk2endMData = getGsfDataFormat(walk2endSData.relativeEnd(), bytes);
    walk2endM = walk2endMData.getAsUint(bytes, offset);

    walk2endLData = getGsfDataFormat(walk2endMData.relativeEnd(), bytes);
    walk2endL = walk2endLData.getAsUint(bytes, offset);

    walk3endSData = getGsfDataFormat(walk2endLData.relativeEnd(), bytes);
    walk3endS = walk3endSData.getAsUint(bytes, offset);

    walk3endMData = getGsfDataFormat(walk3endSData.relativeEnd(), bytes);
    walk3endM = walk3endMData.getAsUint(bytes, offset);

    walk3endLData = getGsfDataFormat(walk3endMData.relativeEnd(), bytes);
    walk3endL = walk3endLData.getAsUint(bytes, offset);

    walk4endSData = getGsfDataFormat(walk3endLData.relativeEnd(), bytes);
    walk4endS = walk4endSData.getAsUint(bytes, offset);

    walk4endMData = getGsfDataFormat(walk4endSData.relativeEnd(), bytes);
    walk4endM = walk4endMData.getAsUint(bytes, offset);

    walk4endLData = getGsfDataFormat(walk4endMData.relativeEnd(), bytes);
    walk4endL = walk4endLData.getAsUint(bytes, offset);

    standingTurnRightData =
        getGsfDataFormat(walk4endLData.relativeEnd(), bytes);
    standingTurnRight = standingTurnRightData.getAsUint(bytes, offset);

    standingTurnLeftData =
        getGsfDataFormat(standingTurnRightData.relativeEnd(), bytes);
    standingTurnLeft = standingTurnLeftData.getAsUint(bytes, offset);

    unknownData = getGsfDataFormat(standingTurnLeftData.relativeEnd(), bytes);

    accel1To2Data = getGsfDataFormat(unknownData.relativeEnd(), bytes);
    accel1To2 = accel1To2Data.getAsUint(bytes, offset);

    accel2To3Data = getGsfDataFormat(accel1To2Data.relativeEnd(), bytes);
    accel2To3 = accel2To3Data.getAsUint(bytes, offset);

    accel3To4Data = getGsfDataFormat(accel2To3Data.relativeEnd(), bytes);
    accel3To4 = accel3To4Data.getAsUint(bytes, offset);

    brake4To3Data = getGsfDataFormat(accel3To4Data.relativeEnd(), bytes);
    brake4To3 = brake4To3Data.getAsUint(bytes, offset);

    brake3To2Data = getGsfDataFormat(brake4To3Data.relativeEnd(), bytes);
    brake3To2 = brake3To2Data.getAsUint(bytes, offset);

    brake2To1Data = getGsfDataFormat(brake3To2Data.relativeEnd(), bytes);
    brake2To1 = brake2To1Data.getAsUint(bytes, offset);

    walkLeftData = getGsfDataFormat(brake2To1Data.relativeEnd(), bytes);
    walkLeft = walkLeftData.getAsUint(bytes, offset);

    walkRightData = getGsfDataFormat(walkLeftData.relativeEnd(), bytes);
    walkRight = walkRightData.getAsUint(bytes, offset);

    unknownData2 = getGsfDataFormat(walkRightData.relativeEnd(), bytes);

    walkTransitionIndexData =
        getGsfDataFormat(unknownData2.relativeEnd(), bytes);
    walkTransitionIndex = walkTransitionIndexData.getAsUint(bytes, offset);

    growUpData = getGsfDataFormat(walkTransitionIndexData.relativeEnd(), bytes);
    growUp = growUpData.getAsUint(bytes, offset);

    sailUpData = getGsfDataFormat(growUpData.relativeEnd(), bytes);
    sailUp = sailUpData.getAsUint(bytes, offset);

    sailDownData = getGsfDataFormat(sailUpData.relativeEnd(), bytes);
    sailDown = sailDownData.getAsUint(bytes, offset);

    standAnimData = getGsfDataFormat(sailDownData.relativeEnd(), bytes);
    standAnim = standAnimData.getAsUint(bytes, offset);

    walkToSwimData = getGsfDataFormat(standAnimData.relativeEnd(), bytes);
    walkToSwim = walkToSwimData.getAsUint(bytes, offset);
    // search for 8 bytes zero structure
    unknownData3 = getGsfDataFormat(walkToSwimData.relativeEnd(), bytes);
    unknownData4 = getGsfDataFormat(unknownData3.relativeEnd(), bytes);
    unknownData5 = getGsfDataFormat(unknownData4.relativeEnd(), bytes);
    unknownData6 = getGsfDataFormat(unknownData5.relativeEnd(), bytes);
    unknownData7 = getGsfDataFormat(unknownData6.relativeEnd(), bytes);
    unknownData8 = getGsfDataFormat(unknownData7.relativeEnd(), bytes);
    unknownData9 = getGsfDataFormat(unknownData8.relativeEnd(), bytes);
    unknownData10 = getGsfDataFormat(unknownData9.relativeEnd(), bytes);
    _nameData = Standard4BytesData(pos: unknownData10.relativeEnd());
    name = _nameData.getAsAsciiString(bytes, offset);
    print("walk set name: $name");
  }

  @override
  String toString() {
    return 'WalkSet: $name';
  }

  @override
  int getEndOffset() {
    return _nameData.offsettedLength(offset);
  }
}
