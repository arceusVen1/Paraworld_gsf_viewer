import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';

class WalkSet extends GsfPart {
  WalkSet({
    required offset,
  }) : super(offset: offset);
  static const GsfData walk1PosData = SingleByteData(pos: 0);
  static const GsfData walk2PosData = SingleByteData(pos: 1);
  static const GsfData walk3PosData = SingleByteData(pos: 2);
  static const GsfData walk4PosData = SingleByteData(pos: 3);
  static const GsfData walk1endSData = SingleByteData(pos: 4);
  static const GsfData walk1endMData = SingleByteData(pos: 5);
  static const GsfData walk1endLData = SingleByteData(pos: 6);
  static const GsfData walk2endSData = SingleByteData(pos: 7);
  static const GsfData walk2endMData = SingleByteData(pos: 8);
  static const GsfData walk2endLData = SingleByteData(pos: 9);
  static const GsfData walk3endSData = SingleByteData(pos: 10);
  static const GsfData walk3endMData = SingleByteData(pos: 11);
  static const GsfData walk3endLData = SingleByteData(pos: 12);
  static const GsfData walk4endSData = SingleByteData(pos: 13);
  static const GsfData walk4endMData = SingleByteData(pos: 14);
  static const GsfData walk4endLData = SingleByteData(pos: 15);
  static const GsfData standingTurnRightData = SingleByteData(pos: 16);
  static const GsfData standingTurnLeftData = SingleByteData(pos: 17);
  // one unused byte
  static const GsfData accel1To2Data = SingleByteData(pos: 19);
  static const GsfData accel2To3Data = SingleByteData(pos: 20);
  static const GsfData accel3To4Data = SingleByteData(pos: 21);
  static const GsfData brake4To3Data = SingleByteData(pos: 22);
  static const GsfData brake3To2Data = SingleByteData(pos: 23);
  static const GsfData brake2To1Data = SingleByteData(pos: 24);
  static const GsfData walkLeftData = SingleByteData(pos: 25);
  static const GsfData walkRightData = SingleByteData(pos: 26);
  // one unused byte
  static const GsfData walkTransitionIndexData = SingleByteData(pos: 28);
  static const GsfData growUpData = SingleByteData(pos: 29);
  static const GsfData sailUpData = SingleByteData(pos: 30);
  static const GsfData sailDownData = SingleByteData(pos: 31);
  static const GsfData standAnimData = SingleByteData(pos: 32);
  static const GsfData walkToSwimData = SingleByteData(pos: 33);
  // 8 unused bytes
  static const GsfData nameData = Standard4BytesData(pos: 42);

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

  WalkSet.fromBytes(Uint8List bytes, int offset) : super(offset: offset) {
    walk1Pos = walk1PosData.getAsUint(bytes, offset);
    walk2Pos = walk2PosData.getAsUint(bytes, offset);
    walk3Pos = walk3PosData.getAsUint(bytes, offset);
    walk4Pos = walk4PosData.getAsUint(bytes, offset);
    walk1endS = walk1endSData.getAsUint(bytes, offset);
    walk1endM = walk1endMData.getAsUint(bytes, offset);
    walk1endL = walk1endLData.getAsUint(bytes, offset);
    walk2endS = walk2endSData.getAsUint(bytes, offset);
    walk2endM = walk2endMData.getAsUint(bytes, offset);
    walk2endL = walk2endLData.getAsUint(bytes, offset);
    walk3endS = walk3endSData.getAsUint(bytes, offset);
    walk3endM = walk3endMData.getAsUint(bytes, offset);
    walk3endL = walk3endLData.getAsUint(bytes, offset);
    walk4endS = walk4endSData.getAsUint(bytes, offset);
    walk4endM = walk4endMData.getAsUint(bytes, offset);
    walk4endL = walk4endLData.getAsUint(bytes, offset);
    standingTurnRight = standingTurnRightData.getAsUint(bytes, offset);
    standingTurnLeft = standingTurnLeftData.getAsUint(bytes, offset);
    accel1To2 = accel1To2Data.getAsUint(bytes, offset);
    accel2To3 = accel2To3Data.getAsUint(bytes, offset);
    accel3To4 = accel3To4Data.getAsUint(bytes, offset);
    brake4To3 = brake4To3Data.getAsUint(bytes, offset);
    brake3To2 = brake3To2Data.getAsUint(bytes, offset);
    brake2To1 = brake2To1Data.getAsUint(bytes, offset);
    walkLeft = walkLeftData.getAsUint(bytes, offset);
    walkRight = walkRightData.getAsUint(bytes, offset);
    walkTransitionIndex = walkTransitionIndexData.getAsUint(bytes, offset);
    growUp = growUpData.getAsUint(bytes, offset);
    sailUp = sailUpData.getAsUint(bytes, offset);
    sailDown = sailDownData.getAsUint(bytes, offset);
    standAnim = standAnimData.getAsUint(bytes, offset);
    walkToSwim = walkToSwimData.getAsUint(bytes, offset);
    name = nameData.getAsAsciiString(bytes, offset);
    print("walk set name: $name");
  }

  @override
  String toString() {
    return 'WalkSet: $name';
  }

  @override
  int getEndOffset() {
    return nameData.offsettedLength(offset);
  }
}
