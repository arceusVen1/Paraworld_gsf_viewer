import 'package:paraworld_gsf_viewer/classes/gsf/header2/model_settings.dart';

class ChunkAttributes {
  ChunkAttributes({
    required this.value,
    required this.typeOfModel,
  });

  final ModelType typeOfModel;
  final int value;

  final List<bool> bits = List<bool>.filled(32, false);

  bool get isLOD4 => bits[3]; // level of details
  bool get isLOD3 => bits[4];
  bool get isLOD2 => bits[5];
  bool get isLOD1 => bits[6];
  bool get isLOD0 => bits[7];

  List<int> get usedIndices {
    return <int>[3, 4, 5, 6, 7];
  }

  List<int> get unknownBits {
    final used = usedIndices;
    return bits.indexed
        .where((bit) => bit.$2 && !used.contains(bit.$1))
        .expand((element) => [element.$1])
        .toList();
  }

  ChunkAttributes.fromValue(this.value, this.typeOfModel) {
    for (var i = 0; i < 32; i++) {
      bits[i] = (value & (1 << 8 * ((i / 8).floor() + 1) - i % 8 - 1)) != 0;
    }
  }

  static ChunkAttributes fromModelType(ModelType type, int value) {
    switch (type) {
      case ModelType.char:
        return CharAttributes(value);
      case ModelType.ress:
        return RessAttributes(value);
      case ModelType.bldg:
        return BldgAttributes(value, null);
      case ModelType.deko:
        return DekoAttributes(value);
      case ModelType.vehi:
        return VehiAttributes(value);
      case ModelType.fiel:
        return FielAttributes(value);
      case ModelType.misc:
        return MiscAttributes(value);
      case ModelType.towe:
        return ToweAttributes(value);
      case ModelType.anim:
        return AnimAttributes(value);
      case ModelType.ship:
        return ShipAttributes(value);
      case ModelType.vgtn:
        return VgtnAttributes(value);
      case ModelType.rivr:
        return RivrAttributes(value);
      case ModelType.wall:
        return WallAttributes(value);
      case ModelType.unknown:
        return ChunkAttributes(value: value, typeOfModel: ModelType.unknown);
    }
  }
}

class CharAttributes extends ChunkAttributes {
  CharAttributes(int value) : super.fromValue(value, ModelType.char);

  bool get isLegs => bits[0];
  bool get isBody => bits[1];
  bool get isHead => bits[2];

  bool get isSelectionVolume => bits[21];

  @override
  List<int> get usedIndices => super.usedIndices..addAll([0, 1, 2, 21]);
}

class RessAttributes extends ChunkAttributes {
  RessAttributes(int value) : super.fromValue(value, ModelType.ress);

  // res is for ressource (such as trees, stone, etc.)
  // If they are full then res6 model is used (biggest model)
  // If they are low then res0 is used with smallest model
  bool get isRes3 => bits[0];
  bool get isRes2 => bits[1];
  bool get isRes1 => bits[2];

  bool get isRes6 => bits[13];
  bool get isRes5 => bits[14];
  bool get isRes4 => bits[15];
  bool get isSelectionVolume => bits[21];

  @override
  List<int> get usedIndices =>
      super.usedIndices..addAll([0, 1, 2, 13, 14, 15, 21]);
}

class BldgAttributes extends ChunkAttributes {
  BldgAttributes(int value, ModelType? modelType)
      : super.fromValue(value, modelType ?? ModelType.bldg);

  bool get animateConEnd => bits[1];
  bool get animateConStart => bits[2];

  // con is for construction level of buildings
  // con 0 is start of construction, con 4 is finished
  bool get isCon2 => bits[16];
  bool get isCon1 => bits[17];
  bool get isCon0 => bits[18];

  bool get isForNight => bits[19];

  bool get unknown => bits[20];
  bool get isSelectionVolume => bits[21];

  // dest is destruction damage level
  // dest 1 is for 50% damage, dest 2 is for 75% damage
  bool get isDest2 => bits[27];
  bool get isDest1 => bits[28];
  bool get useConFlags => bits[29];

  bool get isCon4 => bits[30];
  bool get isCon3 => bits[31];

  @override
  List<int> get usedIndices => super.usedIndices
    ..addAll(
      [1, 2, 16, 17, 18, 19, 20, 21, 27, 28, 29, 30, 31],
    );
}

class WallAttributes extends BldgAttributes {
  WallAttributes(int value) : super(value, ModelType.wall);
}

class DekoAttributes extends ChunkAttributes {
  DekoAttributes(int value) : super.fromValue(value, ModelType.deko);

  bool get isSequence => bits[2];
  bool get isForNight => bits[19];

  @override
  List<int> get usedIndices => super.usedIndices..addAll([2, 19]);
}

class VehiAttributes extends ChunkAttributes {
  VehiAttributes(int value) : super.fromValue(value, ModelType.vehi);

  bool get ramHigh => bits[1];
  bool get ramLow => bits[2];
  bool get unknown => bits[20];

  @override
  List<int> get usedIndices => super.usedIndices..addAll([1, 2, 20]);
}

class FielAttributes extends ChunkAttributes {
  FielAttributes(int value) : super.fromValue(value, ModelType.fiel);
}

class MiscAttributes extends ChunkAttributes {
  MiscAttributes(int value) : super.fromValue(value, ModelType.misc);

  bool get isStep2 => bits[0];
  bool get isStep1 => bits[1];
  bool get isStep0 => bits[2];
  bool get unknown => bits[20];

  @override
  List<int> get usedIndices => super.usedIndices..addAll([0, 1, 2, 20]);
}

class ToweAttributes extends ChunkAttributes {
  ToweAttributes(int value) : super.fromValue(value, ModelType.towe);

  // zinnen are unknow and unused attr

  bool get isZinnen3 => bits[0];
  bool get isZinnen2 => bits[1];
  bool get isZinnen1 => bits[2];

  bool get isZinnen9 => bits[10];
  bool get isZinnen8 => bits[11];
  bool get isZinnen7 => bits[12];
  bool get isZinnen6 => bits[13];
  bool get isZinnen5 => bits[14];
  bool get isZinnen4 => bits[15];

  @override
  List<int> get usedIndices =>
      super.usedIndices..addAll([0, 1, 2, 10, 11, 12, 13, 14, 15]);
}

class AnimAttributes extends ChunkAttributes {
  AnimAttributes(int value) : super.fromValue(value, ModelType.anim);

  bool get isHelmet => bits[0];
  bool get isSaddle => bits[1];
  bool get isPartyColor => bits[2];

  bool get misc => bits[12];
  bool get isArmorSaddle => bits[13];
  bool get isStandard => bits[14];
  bool get isArmor => bits[15];

  bool get isRightLeg => bits[16];
  bool get isLeftLeg => bits[17];
  bool get isRightArm => bits[18];
  bool get isLeftArm => bits[19];
  bool get isTail => bits[28];
  bool get isHead => bits[29];
  bool get isRightBelly => bits[30];
  bool get isLeftBelly => bits[31];

  @override
  List<int> get usedIndices => super.usedIndices
    ..addAll([0, 1, 2, 12, 13, 14, 15, 16, 17, 18, 19, 28, 29, 30, 31]);
}

class ShipAttributes extends ChunkAttributes {
  ShipAttributes(int value) : super.fromValue(value, ModelType.ship);

  bool get ramHigh => bits[1];
  bool get ramLow => bits[2];
  bool get isDest2 => bits[27];
  bool get isDest1 => bits[28];
  bool get useConFlags => bits[29];
  bool get isCon4 => bits[30];
  bool get unknown => bits[20];

  @override
  List<int> get usedIndices =>
      super.usedIndices..addAll([1, 2, 20, 27, 28, 29, 30]);
}

class VgtnAttributes extends ChunkAttributes {
  VgtnAttributes(int value) : super.fromValue(value, ModelType.vgtn);

  bool get isTreeBillboard => bits[20];
  bool get isSelectionVolume => bits[21];

  @override
  List<int> get usedIndices => super.usedIndices..addAll([20, 21]);
}

class RivrAttributes extends ChunkAttributes {
  RivrAttributes(int value) : super.fromValue(value, ModelType.rivr);

  bool get useWaterShader => bits[18];

  @override
  List<int> get usedIndices => super.usedIndices..addAll([18]);
}
