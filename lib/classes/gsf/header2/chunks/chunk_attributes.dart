import 'package:paraworld_gsf_viewer/classes/gsf/header2/model_settings.dart';

class ChunkAttributes {
  ChunkAttributes({
    required int value,
    required this.typeOfModel,
    List<bool> bits = const [],
  }) {
    if (bits.isNotEmpty) {
      assert(bits.length == 32);
      this.bits.setAll(0, bits);
    } else {
      _getBitsFromValue(value);
    }
  }

  final ModelType typeOfModel;
  final List<bool> bits = List<bool>.filled(32, false);
  void _getBitsFromValue(int value) {
    for (var i = 0; i < 32; i++) {
      bits[i] = (value & (1 << 8 * ((i / 8).floor() + 1) - i % 8 - 1)) != 0;
    }
  }

  ChunkAttributes.simple()
      : this(value: defaultLoD, typeOfModel: ModelType.unknown);
  static const int defaultLoD = 1;

  bool isLodCompatible(ChunkAttributes filter) {
    return (isLOD4 && filter.isLOD4) ||
        (isLOD3 && filter.isLOD3) ||
        (isLOD2 && filter.isLOD2) ||
        (isLOD1 && filter.isLOD1) ||
        (isLOD0 && filter.isLOD0);
  }

  bool isFlagOn(int indice) {
    return bits[indice];
  }

  bool isFlagCompatible(ChunkAttributes filter) {
    final indicesToCompare =
        usedIndices.where((indice) => !levelIndices.contains(indice));

    return indicesToCompare.isEmpty ||
        indicesToCompare
                .where((indice) =>
                    !bits[indice] || bits[indice] == filter.bits[indice])
                .length ==
            indicesToCompare.length;
  }

  bool isCompatible(ChunkAttributes filter) {
    return isLodCompatible(filter) && isFlagCompatible(filter);
  }

  int get lod4Indice => 3;
  int get lod3Indice => 4;
  int get lod2Indice => 5;
  int get lod1Indice => 6;
  int get lod0Indice => 7;

  bool get isLOD4 => bits[lod4Indice]; // level of details
  bool get isLOD3 => bits[lod3Indice];
  bool get isLOD2 => bits[lod2Indice];
  bool get isLOD1 => bits[lod1Indice];
  bool get isLOD0 => bits[lod0Indice];

  List<int> get levelIndices {
    return <int>[
      lod4Indice,
      lod3Indice,
      lod2Indice,
      lod1Indice,
      lod0Indice,
    ];
  }

  List<int> get usedIndices {
    return levelIndices;
  }

  List<int> get unknownBits {
    final used = usedIndices;
    return bits.indexed
        .where((bit) => bit.$2 && !used.contains(bit.$1))
        .expand((element) => [element.$1])
        .toList();
  }

  ChunkAttributes.zero() : this(value: 0, typeOfModel: ModelType.none);

  static ChunkAttributes fromBits(ModelType type, List<bool> bits) {
    switch (type) {
      case ModelType.char:
        return CharAttributes(0, bits);
      case ModelType.ress:
        return RessAttributes(0, bits);
      case ModelType.bldg:
        return BldgAttributes(0, bits);
      case ModelType.deko:
        return DekoAttributes(0, bits);
      case ModelType.vehi:
        return VehiAttributes(0, bits);
      case ModelType.fiel:
        return FielAttributes(0, bits);
      case ModelType.misc:
        return MiscAttributes(0, bits);
      case ModelType.towe:
        return ToweAttributes(0, bits);
      case ModelType.anim:
        return AnimAttributes(0, bits);
      case ModelType.ship:
        return ShipAttributes(0, bits);
      case ModelType.vgtn:
        return VgtnAttributes(0, bits);
      case ModelType.rivr:
        return RivrAttributes(0, bits);
      case ModelType.wall:
        return WallAttributes(0, bits);
      case ModelType.unknown:
        return ChunkAttributes(
          value: 0,
          typeOfModel: ModelType.unknown,
          bits: bits,
        );
      case ModelType.none:
        return ChunkAttributes(
          value: 0,
          typeOfModel: ModelType.none,
          bits: bits,
        );
    }
  }

  static ChunkAttributes fromValue(ModelType type, int value) {
    switch (type) {
      case ModelType.char:
        return CharAttributes(value, []);
      case ModelType.ress:
        return RessAttributes(value, []);
      case ModelType.bldg:
        return BldgAttributes(value, []);
      case ModelType.deko:
        return DekoAttributes(value, []);
      case ModelType.vehi:
        return VehiAttributes(value, []);
      case ModelType.fiel:
        return FielAttributes(value, []);
      case ModelType.misc:
        return MiscAttributes(value, []);
      case ModelType.towe:
        return ToweAttributes(value, []);
      case ModelType.anim:
        return AnimAttributes(value, []);
      case ModelType.ship:
        return ShipAttributes(value, []);
      case ModelType.vgtn:
        return VgtnAttributes(value, []);
      case ModelType.rivr:
        return RivrAttributes(value, []);
      case ModelType.wall:
        return WallAttributes(value, []);
      case ModelType.unknown:
        return ChunkAttributes(value: value, typeOfModel: ModelType.unknown);
      case ModelType.none:
        return ChunkAttributes(value: 0, typeOfModel: ModelType.none);
    }
  }
}

class CharAttributes extends ChunkAttributes {
  CharAttributes(int value, List<bool> bits)
      : super(
          value: value,
          typeOfModel: ModelType.char,
          bits: bits,
        );

  int get legIndice => 0;
  int get bodyIndice => 1;
  int get headIndice => 2;
  int get selectionVolumeIndice => 21;

  bool get isLegs => bits[legIndice];
  bool get isBody => bits[bodyIndice];
  bool get isHead => bits[headIndice];

  bool get isSelectionVolume => bits[selectionVolumeIndice];

  @override
  List<int> get usedIndices => super.usedIndices
    ..addAll([
      legIndice,
      bodyIndice,
      headIndice,
      selectionVolumeIndice,
    ]);
}

class RessAttributes extends ChunkAttributes {
  RessAttributes(int value, List<bool> bits)
      : super(
          value: value,
          typeOfModel: ModelType.ress,
          bits: bits,
        );

  // res is for ressource (such as trees, stone, etc.)
  // If they are full then res6 model is used (biggest model)
  // If they are low then res0 is used with smallest model
  int get res3Indice => 0;
  int get res2Indice => 1;
  int get res1Indice => 2;

  int get res6Indice => 13;
  int get res5Indice => 14;
  int get res4Indice => 15;
  int get selectionVolumeIndice => 21;

  bool get isRes3 => bits[res3Indice];
  bool get isRes2 => bits[res2Indice];
  bool get isRes1 => bits[res1Indice];

  bool get isRes6 => bits[res6Indice];
  bool get isRes5 => bits[res5Indice];
  bool get isRes4 => bits[res4Indice];

  bool get isSelectionVolume => bits[selectionVolumeIndice];

  @override
  List<int> get levelIndices => super.levelIndices
    ..addAll([
      res6Indice,
      res5Indice,
      res4Indice,
      res3Indice,
      res2Indice,
      res1Indice,
    ]);

  @override
  List<int> get usedIndices =>
      super.usedIndices..addAll([selectionVolumeIndice]);

  @override
  bool isCompatible(ChunkAttributes filter) {
    final ressFilter = filter as RessAttributes;
    final isResCompatible = (isRes1 && ressFilter.isRes1) ||
        (isRes2 && ressFilter.isRes2) ||
        (isRes3 && ressFilter.isRes3) ||
        (isRes4 && ressFilter.isRes4) ||
        (isRes5 && ressFilter.isRes5) ||
        (isRes6 && ressFilter.isRes6);
    return isLodCompatible(filter) &&
        isResCompatible &&
        isFlagCompatible(filter);
  }
}

class BuildingAttributes extends ChunkAttributes {
  BuildingAttributes(
    int value,
    ModelType modelType,
    List<bool> bits,
  ) : super(
          value: value,
          typeOfModel: modelType,
          bits: bits,
        ) {
    assert(modelType == ModelType.bldg ||
        modelType == ModelType.wall ||
        modelType == ModelType.fiel);
  }
  int get animateConEndIndice => 1;
  int get animateConStartIndice => 2;

  int get con2Indice => 16;
  int get con1Indice => 17;
  int get con0Indice => 18;

  int get unknownIndice => 20;

  int get dest2Indice => 27;
  int get dest1Indice => 28;
  int get useConFlagsIndice => 29;

  int get con4Indice => 30;
  int get con3Indice => 31;

  bool get animateConEnd => bits[animateConEndIndice];
  bool get animateConStart => bits[animateConStartIndice];

  // con is for construction level of buildings
  // con 0 is start of construction, con 4 is finished
  bool get isCon2 => bits[con2Indice];
  bool get isCon1 => bits[con1Indice];
  bool get isCon0 => bits[con0Indice];

  bool get isUnknown => bits[unknownIndice];

  // dest is destruction damage level
  // dest 1 is for 50% damage, dest 2 is for 75% damage
  bool get isDest2 => bits[dest2Indice];
  bool get isDest1 => bits[dest1Indice];
  bool get useConFlags => bits[useConFlagsIndice];

  bool get isCon4 => bits[con4Indice];
  bool get isCon3 => bits[con3Indice];

  @override
  bool isCompatible(ChunkAttributes filter) {
    final buildingFilter = filter as BuildingAttributes;
    final isConCompatible =
        (!isCon0 && !isCon1 && isCon2 && !isCon3 && !isCon4) ||
            (isCon0 && buildingFilter.isCon0) ||
            (isCon1 && buildingFilter.isCon1) ||
            (isCon2 && buildingFilter.isCon2) ||
            (isCon3 && buildingFilter.isCon3) ||
            (isCon4 && buildingFilter.isCon4);

    final isDestCompatible = (!isDest1 && !isDest2) ||
        (isDest1 && buildingFilter.isDest1) ||
        (isDest2 && buildingFilter.isDest2);
    return isLodCompatible(filter) &&
        isConCompatible &&
        isDestCompatible &&
        isFlagCompatible(filter);
  }

  @override
  List<int> get levelIndices => super.levelIndices
    ..addAll(
      [
        con2Indice,
        con1Indice,
        con0Indice,
        con4Indice,
        con3Indice,
        dest2Indice,
        dest1Indice,
      ],
    );

  @override
  List<int> get usedIndices => super.usedIndices
    ..addAll(
      [
        animateConEndIndice,
        animateConStartIndice,
        unknownIndice,
        useConFlagsIndice
      ],
    );
}

class BldgAttributes extends BuildingAttributes {
  BldgAttributes(int value, List<bool> bits)
      : super(
          value,
          ModelType.bldg,
          bits,
        );

  int get resinFieldFireIndice => 0;
  int get isAge5Indice => 10;
  int get isAge4Indice => 11;
  int get isAge3Indice => 12;
  int get isAge2Indice => 13;
  int get isAge1Indice => 14;
  int get isForNightIndice => 19;
  int get isSelectionVolumeIndice => 21;

  bool get resinFieldFire => bits[resinFieldFireIndice];
  bool get isAge5 => bits[isAge5Indice];
  bool get isAge4 => bits[isAge4Indice];
  bool get isAge3 => bits[isAge3Indice];
  bool get isAge2 => bits[isAge2Indice];
  bool get isAge1 => bits[isAge1Indice];
  bool get isForNight => bits[isForNightIndice];
  bool get isSelectionVolume => bits[isSelectionVolumeIndice];

  @override
  bool isCompatible(ChunkAttributes filter) {
    final bldgFilter = filter as BldgAttributes;
    final isAgeCompatible =
        (!isAge1 && !isAge2 && !isAge3 && !isAge4 && !isAge5) ||
            (isAge1 && bldgFilter.isAge1) ||
            (isAge2 && bldgFilter.isAge2) ||
            (isAge3 && bldgFilter.isAge3) ||
            (isAge4 && bldgFilter.isAge4) ||
            (isAge5 && bldgFilter.isAge5);
    return isAgeCompatible && super.isCompatible(filter);
  }

  @override
  List<int> get levelIndices => super.levelIndices
    ..addAll([
      isAge5Indice,
      isAge4Indice,
      isAge3Indice,
      isAge2Indice,
      isAge1Indice,
    ]);

  @override
  List<int> get usedIndices => super.usedIndices
    ..addAll([
      resinFieldFireIndice,
      isForNightIndice,
      isSelectionVolumeIndice,
    ]);
}

class WallAttributes extends BuildingAttributes {
  WallAttributes(int value, List<bool> bits)
      : super(
          value,
          ModelType.wall,
          bits,
        );

  int get unknown2Indice => 21;

  bool get unknown2 => bits[unknown2Indice];

  @override
  List<int> get usedIndices => super.usedIndices..addAll([unknown2Indice]);
}

class FielAttributes extends BuildingAttributes {
  FielAttributes(int value, List<bool> bits)
      : super(
          value,
          ModelType.fiel,
          bits,
        );

  int get resinFieldFireIndice => 0;
  int get huCornFieldIndice => 14;
  int get isSelectionVolumeIndice => 21;

  bool get resinFieldFire => bits[resinFieldFireIndice];
  bool get huCornField => bits[huCornFieldIndice];
  bool get isSelectionVolume => bits[isSelectionVolumeIndice];

  @override
  List<int> get usedIndices => super.usedIndices
    ..addAll([
      resinFieldFireIndice,
      huCornFieldIndice,
      isSelectionVolumeIndice,
    ]);
}

class DekoAttributes extends ChunkAttributes {
  DekoAttributes(int value, List<bool> bits)
      : super(
          value: value,
          typeOfModel: ModelType.deko,
          bits: bits,
        );

  int get isSequenceIndice => 2;
  int get isForNightIndice => 19;
  int get unknownIndice => 20;

  bool get isSequence => bits[isSequenceIndice];
  bool get isForNight => bits[isForNightIndice];
  bool get unknown => bits[unknownIndice];

  @override
  List<int> get usedIndices => super.usedIndices
    ..addAll([
      isSequenceIndice,
      isForNightIndice,
      unknownIndice,
    ]);
}

class VehiAttributes extends ChunkAttributes {
  VehiAttributes(int value, List<bool> bits)
      : super(
          value: value,
          typeOfModel: ModelType.vehi,
          bits: bits,
        );

  int get ramHighIndice => 1;
  int get ramLowIndice => 2;
  int get unknownIndice => 20;

  bool get ramHigh => bits[ramHighIndice];
  bool get ramLow => bits[ramLowIndice];
  bool get unknown => bits[unknownIndice];

  @override
  List<int> get usedIndices => super.usedIndices
    ..addAll([
      ramHighIndice,
      ramLowIndice,
      unknownIndice,
    ]);
}

class MiscAttributes extends ChunkAttributes {
  MiscAttributes(int value, List<bool> bits)
      : super(
          value: value,
          typeOfModel: ModelType.misc,
          bits: bits,
        );

  int get isStep2Indice => 0;
  int get isStep1Indice => 1;
  int get isStep0Indice => 2;
  int get unknownIndice => 20;
  int get isSelectionVolumeIndice => 21;

  bool get isStep2 => bits[isStep2Indice];
  bool get isStep1 => bits[isStep1Indice];
  bool get isStep0 => bits[isStep0Indice];
  bool get unknown => bits[unknownIndice];
  bool get isSelectionVolume => bits[isSelectionVolumeIndice];

  @override
  bool isCompatible(ChunkAttributes filter) {
    final miscFilter = filter as MiscAttributes;
    final isStepCompatible = (!isStep0 && !isStep1 && !isStep2) ||
        (isStep0 && miscFilter.isStep0) ||
        (isStep1 && miscFilter.isStep1) ||
        (isStep2 && miscFilter.isStep2);
    return isLodCompatible(filter) &&
        isStepCompatible &&
        isFlagCompatible(filter);
  }

  @override
  List<int> get levelIndices => super.levelIndices
    ..addAll([
      isStep2Indice,
      isStep1Indice,
      isStep0Indice,
    ]);
  @override
  List<int> get usedIndices => super.usedIndices
    ..addAll([
      unknownIndice,
      isSelectionVolumeIndice,
    ]);
}

class ToweAttributes extends ChunkAttributes {
  ToweAttributes(int value, List<bool> bits)
      : super(
          value: value,
          typeOfModel: ModelType.towe,
          bits: bits,
        );

  // zinnen are unknow and unused attr
  int get zinnen9Indice => 10;
  int get zinnen8Indice => 11;
  int get zinnen7Indice => 12;
  int get zinnen6Indice => 13;
  int get zinnen5Indice => 14;
  int get zinnen4Indice => 15;

  int get zinnen3Indice => 0;
  int get zinnen2Indice => 1;
  int get zinnen1Indice => 2;

  bool get isZinnen3 => bits[zinnen3Indice];
  bool get isZinnen2 => bits[zinnen2Indice];
  bool get isZinnen1 => bits[zinnen1Indice];

  bool get isZinnen4 => bits[zinnen4Indice];
  bool get isZinnen5 => bits[zinnen5Indice];
  bool get isZinnen6 => bits[zinnen6Indice];
  bool get isZinnen7 => bits[zinnen7Indice];
  bool get isZinnen8 => bits[zinnen8Indice];
  bool get isZinnen9 => bits[zinnen9Indice];

  @override
  List<int> get levelIndices => super.levelIndices
    ..addAll([
      zinnen9Indice,
      zinnen8Indice,
      zinnen7Indice,
      zinnen6Indice,
      zinnen5Indice,
      zinnen4Indice,
      zinnen3Indice,
      zinnen2Indice,
      zinnen1Indice,
    ]);
}

class AnimAttributes extends ChunkAttributes {
  AnimAttributes(int value, List<bool> bits)
      : super(
          value: value,
          typeOfModel: ModelType.anim,
          bits: bits,
        );

  int get isHelmetIndice => 0;
  int get isSaddleIndice => 1;
  int get isPartyColorIndice => 2;

  int get miscIndice => 12;
  int get isArmorSaddleIndice => 13;
  int get isStandardIndice => 14;
  int get isArmorIndice => 15;

  int get isRightLegIndice => 16;
  int get isLeftLegIndice => 17;
  int get isRightArmIndice => 18;
  int get isLeftArmIndice => 19;

  int get selectionVolumeIndice => 21;

  int get isTailIndice => 28;
  int get isHeadIndice => 29;
  int get isRightBellyIndice => 30;
  int get isLeftBellyIndice => 31;

  bool get isHelmet => bits[isHelmetIndice];
  bool get isSaddle => bits[isSaddleIndice];
  bool get isPartyColor => bits[isPartyColorIndice];

  bool get misc => bits[miscIndice];
  bool get isArmorSaddle => bits[isArmorSaddleIndice];
  bool get isStandard => bits[isStandardIndice];
  bool get isArmor => bits[isArmorIndice];

  bool get isRightLeg => bits[isRightLegIndice];
  bool get isLeftLeg => bits[isLeftLegIndice];
  bool get isRightArm => bits[isRightArmIndice];
  bool get isLeftArm => bits[isLeftArmIndice];
  bool get isTail => bits[isTailIndice];
  bool get isHead => bits[isHeadIndice];
  bool get isRightBelly => bits[isRightBellyIndice];
  bool get isLeftBelly => bits[isLeftBellyIndice];

  @override
  List<int> get usedIndices => super.usedIndices
    ..addAll([
      isHelmetIndice,
      isSaddleIndice,
      isPartyColorIndice,
      miscIndice,
      isArmorSaddleIndice,
      isStandardIndice,
      isArmorIndice,
      isRightLegIndice,
      isLeftLegIndice,
      isRightArmIndice,
      isLeftArmIndice,
      isTailIndice,
      isHeadIndice,
      isRightBellyIndice,
      isLeftBellyIndice,
      selectionVolumeIndice,
    ]);
}

class ShipAttributes extends ChunkAttributes {
  ShipAttributes(int value, List<bool> bits)
      : super(
          value: value,
          typeOfModel: ModelType.ship,
          bits: bits,
        );

  int get ramHighIndice => 1;
  int get ramLowIndice => 2;
  int get isDest2Indice => 27;
  int get isDest1Indice => 28;
  int get useConFlagsIndice => 29;
  int get isCon4Indice => 30;
  int get unknownIndice => 20;

  bool get ramHigh => bits[ramHighIndice];
  bool get ramLow => bits[ramLowIndice];
  bool get isDest2 => bits[isDest2Indice];
  bool get isDest1 => bits[isDest1Indice];
  bool get useConFlags => bits[useConFlagsIndice];
  bool get isCon4 => bits[isCon4Indice];
  bool get unknown => bits[unknownIndice];

  @override
  bool isCompatible(ChunkAttributes filter) {
    final shipFilter = filter as ShipAttributes;
    final isDestCompatible = (!isDest1 && !isDest2) ||
        (isDest1 && shipFilter.isDest1) ||
        (isDest2 && shipFilter.isDest2);
    return isLodCompatible(filter) &&
        isDestCompatible &&
        isFlagCompatible(filter);
  }

  @override
  List<int> get levelIndices => super.levelIndices
    ..addAll(
      [isDest2Indice, isDest1Indice, isCon4Indice],
    );

  @override
  List<int> get usedIndices => super.usedIndices
    ..addAll([
      unknownIndice,
      useConFlagsIndice,
      ramHighIndice,
      ramLowIndice,
    ]);
}

class VgtnAttributes extends ChunkAttributes {
  VgtnAttributes(int value, List<bool> bits)
      : super(
          value: value,
          typeOfModel: ModelType.vgtn,
          bits: bits,
        );

  int get isTreeBillboardIndice => 20;
  int get isSelectionVolumeIndice => 21;

  bool get isTreeBillboard => bits[isTreeBillboardIndice];
  bool get isSelectionVolume => bits[isSelectionVolumeIndice];

  @override
  List<int> get usedIndices => super.usedIndices
    ..addAll([
      isTreeBillboardIndice,
      isSelectionVolumeIndice,
    ]);
}

class RivrAttributes extends ChunkAttributes {
  RivrAttributes(int value, List<bool> bits)
      : super(
          value: value,
          typeOfModel: ModelType.rivr,
          bits: bits,
        );

  int get useWaterShaderIndice => 18;
  bool get useWaterShader => bits[useWaterShaderIndice];

  @override
  List<int> get usedIndices =>
      super.usedIndices..addAll([useWaterShaderIndice]);
}
