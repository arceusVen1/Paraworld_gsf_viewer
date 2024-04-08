import 'package:flutter/foundation.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/model_settings.dart';

class ChunkAttributes {
  ChunkAttributes({
    required this.typeOfModel,
    List<bool> bits = const [],
    int value = 0,
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

  static const int defaultLoD = 1;

  static ChunkAttributes defaultValue(ModelType typeOfModel) {
    switch (typeOfModel) {
      case ModelType.ress:
        return RessAttributes.defaultValue();
      case ModelType.bldg:
        return BldgAttributes.defaultValue();
      case ModelType.wall:
        return WallAttributes.defaultValue();
      case ModelType.fiel:
        return FielAttributes.defaultValue();
      case ModelType.towe:
        return ToweAttributes.defaultValue();
      case ModelType.anim:
        return AnimAttributes.defaultValue();
      default:
        return ChunkAttributes(value: defaultLoD, typeOfModel: typeOfModel);
    }
  }

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
    return visibilityFlags.isEmpty ||
        visibilityFlags
                .where((indice) =>
                    !bits[indice] || bits[indice] == filter.bits[indice])
                .length ==
            visibilityFlags.length;
  }

  bool isCompatible(ChunkAttributes filter) {
    return this == filter ||
        (isLodCompatible(filter) && isFlagCompatible(filter));
  }

  static const int lod4Indice = 3;
  static const int lod3Indice = 4;
  static const int lod2Indice = 5;
  static const int lod1Indice = 6;
  static const int lod0Indice = 7;

  bool get isLOD4 => bits[lod4Indice]; // level of details
  bool get isLOD3 => bits[lod3Indice];
  bool get isLOD2 => bits[lod2Indice];
  bool get isLOD1 => bits[lod1Indice];
  bool get isLOD0 => bits[lod0Indice];

  List<int> get visibilityFlags =>
      usedIndices.where((indice) => !levelIndices.contains(indice)).toList();

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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChunkAttributes &&
        other.typeOfModel == typeOfModel &&
        listEquals(other.bits, bits);
  }

  @override
  int get hashCode => Object.hash(typeOfModel, bits);
}

class CharAttributes extends ChunkAttributes {
  CharAttributes(int value, List<bool> bits)
      : super(
          value: value,
          typeOfModel: ModelType.char,
          bits: bits,
        );

  static const int legIndice = 0;
  static const int bodyIndice = 1;
  static const int headIndice = 2;
  static const int selectionVolumeIndice = 21;

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
  static const int res3Indice = 0;
  static const int res2Indice = 1;
  static const int res1Indice = 2;

  static const int res6Indice = 13;
  static const int res5Indice = 14;
  static const int res4Indice = 15;
  static const int selectionVolumeIndice = 21;

  bool get isRes3 => bits[res3Indice];
  bool get isRes2 => bits[res2Indice];
  bool get isRes1 => bits[res1Indice];

  bool get isRes6 => bits[res6Indice];
  bool get isRes5 => bits[res5Indice];
  bool get isRes4 => bits[res4Indice];

  bool get isSelectionVolume => bits[selectionVolumeIndice];

  RessAttributes.defaultValue()
      : super(
          bits: List<bool>.filled(32, false)
            ..[ChunkAttributes.lod0Indice] = true
            ..[res6Indice] = true
            ..[res5Indice] = true
            ..[res4Indice] = true
            ..[res3Indice] = true
            ..[res2Indice] = true
            ..[res1Indice] = true,
          typeOfModel: ModelType.ress,
        );

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
    final isResCompatible = (isRes1 && filter.bits[res1Indice]) ||
        (isRes2 && filter.bits[res2Indice]) ||
        (isRes3 && filter.bits[res3Indice]) ||
        (isRes4 && filter.bits[res4Indice]) ||
        (isRes5 && filter.bits[res5Indice]) ||
        (isRes6 && filter.bits[res6Indice]);
    return this == filter ||
        (isLodCompatible(filter) &&
            isResCompatible &&
            isFlagCompatible(filter));
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
  static const int animateConEndIndice = 1;
  static const int animateConStartIndice = 2;

  static const int con2Indice = 16;
  static const int con1Indice = 17;
  static const int con0Indice = 18;

  static const int unknownIndice = 20;

  static const int dest2Indice = 27;
  static const int dest1Indice = 28;
  static const int useConFlagsIndice = 29;

  static const int con4Indice = 30;
  static const int con3Indice = 31;

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

  static List<bool> defaultValue = List<bool>.filled(32, false)
    ..[ChunkAttributes.lod0Indice] = true
    ..[con4Indice] = true;

  @override
  bool isCompatible(ChunkAttributes filter) {
    final isConCompatible =
        (!isCon0 && !isCon1 && isCon2 && !isCon3 && !isCon4) ||
            (isCon0 && filter.bits[con0Indice]) ||
            (isCon1 && filter.bits[con1Indice]) ||
            (isCon2 && filter.bits[con2Indice]) ||
            (isCon3 && filter.bits[con3Indice]) ||
            (isCon4 && filter.bits[con4Indice]);

    final isDestCompatible = (!isDest1 && !isDest2) ||
        (isDest1 && filter.bits[dest1Indice]) ||
        (isDest2 && filter.bits[dest2Indice]);
    return this == filter ||
        (isLodCompatible(filter) &&
            isConCompatible &&
            isDestCompatible &&
            isFlagCompatible(filter));
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

  BldgAttributes.defaultValue()
      : super(0, ModelType.bldg,
            BuildingAttributes.defaultValue..[isAge5Indice] = true);

  static const int resinFieldFireIndice = 0;
  static const int isAge5Indice = 10;
  static const int isAge4Indice = 11;
  static const int isAge3Indice = 12;
  static const int isAge2Indice = 13;
  static const int isAge1Indice = 14;
  static const int isForNightIndice = 19;
  static const int isSelectionVolumeIndice = 21;

  bool get resinFieldFire => bits[resinFieldFireIndice];
  bool get isAge5 => bits[isAge5Indice];
  bool get isAge4 => bits[isAge4Indice];
  bool get isAge3 => bits[isAge3Indice];
  bool get isAge2 => bits[isAge2Indice];
  bool get isAge1 => bits[isAge1Indice];
  bool get isForNight => bits[isForNightIndice];
  bool get isSelectionVolume => bits[isSelectionVolumeIndice];

  @override
  List<int> get visibilityFlags => [
        isForNightIndice,
        isSelectionVolumeIndice,
      ];

  @override
  bool isCompatible(ChunkAttributes filter) {
    final isAgeCompatible =
        (!isAge1 && !isAge2 && !isAge3 && !isAge4 && !isAge5) ||
            (isAge1 && filter.bits[isAge1Indice]) ||
            (isAge2 && filter.bits[isAge2Indice]) ||
            (isAge3 && filter.bits[isAge3Indice]) ||
            (isAge4 && filter.bits[isAge4Indice]) ||
            (isAge5 && filter.bits[isAge5Indice]);
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

  WallAttributes.defaultValue()
      : super(
          0,
          ModelType.bldg,
          BuildingAttributes.defaultValue,
        );

  static const int unknown2Indice = 21;

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

  FielAttributes.defaultValue()
      : super(
          0,
          ModelType.bldg,
          BuildingAttributes.defaultValue,
        );

  static const int resinFieldFireIndice = 0;
  static const int huCornFieldIndice = 14;
  static const int isSelectionVolumeIndice = 21;

  bool get resinFieldFire => bits[resinFieldFireIndice];
  bool get huCornField => bits[huCornFieldIndice];
  bool get isSelectionVolume => bits[isSelectionVolumeIndice];

  @override
  List<int> get visibilityFlags => [
        isSelectionVolumeIndice,
      ];

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

  static const int isSequenceIndice = 2;
  static const int isForNightIndice = 19;
  static const int unknownIndice = 20;

  bool get isSequence => bits[isSequenceIndice];
  bool get isForNight => bits[isForNightIndice];
  bool get unknown => bits[unknownIndice];

  @override
  List<int> get visibilityFlags => [
        isForNightIndice,
        isSequenceIndice,
      ];

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

  static const int ramHighIndice = 1;
  static const int ramLowIndice = 2;
  static const int unknownIndice = 20;

  bool get ramHigh => bits[ramHighIndice];
  bool get ramLow => bits[ramLowIndice];
  bool get unknown => bits[unknownIndice];

  @override
  List<int> get visibilityFlags => [];

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

  static const int isStep2Indice = 0;
  static const int isStep1Indice = 1;
  static const int isStep0Indice = 2;
  static const int unknownIndice = 20;
  static const int isSelectionVolumeIndice = 21;

  bool get isStep2 => bits[isStep2Indice];
  bool get isStep1 => bits[isStep1Indice];
  bool get isStep0 => bits[isStep0Indice];
  bool get unknown => bits[unknownIndice];
  bool get isSelectionVolume => bits[isSelectionVolumeIndice];

  @override
  List<int> get visibilityFlags => [
        isSelectionVolumeIndice,
      ];

  @override
  bool isCompatible(ChunkAttributes filter) {
    final isStepCompatible = (!isStep0 && !isStep1 && !isStep2) ||
        (isStep0 && filter.bits[isStep0Indice]) ||
        (isStep1 && filter.bits[isStep1Indice]) ||
        (isStep2 && filter.bits[isStep2Indice]);
    return this == filter ||
        (isLodCompatible(filter) &&
            isStepCompatible &&
            isFlagCompatible(filter));
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

  ToweAttributes.defaultValue()
      : super(
          bits: List<bool>.filled(32, false)
            ..[ChunkAttributes.lod0Indice] = true
            ..[zinnen9Indice] = true
            ..[zinnen8Indice] = true
            ..[zinnen7Indice] = true
            ..[zinnen6Indice] = true
            ..[zinnen5Indice] = true
            ..[zinnen4Indice] = true
            ..[zinnen3Indice] = true
            ..[zinnen2Indice] = true
            ..[zinnen1Indice] = true,
          typeOfModel: ModelType.ress,
        );

  // zinnen are unknow and unused attr
  static const int zinnen9Indice = 10;
  static const int zinnen8Indice = 11;
  static const int zinnen7Indice = 12;
  static const int zinnen6Indice = 13;
  static const int zinnen5Indice = 14;
  static const int zinnen4Indice = 15;

  static const int zinnen3Indice = 0;
  static const int zinnen2Indice = 1;
  static const int zinnen1Indice = 2;

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

  AnimAttributes.defaultValue()
      : super(
          bits: List<bool>.filled(32, false)
            ..[ChunkAttributes.lod0Indice] = true
            ..[miscIndice] = true,
          typeOfModel: ModelType.anim,
        );

  static const int isHelmetIndice = 0;
  static const int isSaddleIndice = 1;
  static const int isPartyColorIndice = 2;

  static const int miscIndice = 12;
  static const int isArmorSaddleIndice = 13;
  static const int isStandardIndice = 14;
  static const int isArmorIndice = 15;

  static const int isRightLegIndice = 16;
  static const int isLeftLegIndice = 17;
  static const int isRightArmIndice = 18;
  static const int isLeftArmIndice = 19;

  static const int selectionVolumeIndice = 21;

  static const int isTailIndice = 28;
  static const int isHeadIndice = 29;
  static const int isRightBellyIndice = 30;
  static const int isLeftBellyIndice = 31;

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

  static const int ramHighIndice = 1;
  static const int ramLowIndice = 2;
  static const int isDest2Indice = 27;
  static const int isDest1Indice = 28;
  static const int useConFlagsIndice = 29;
  static const int isCon4Indice = 30;
  static const int unknownIndice = 20;

  bool get ramHigh => bits[ramHighIndice];
  bool get ramLow => bits[ramLowIndice];
  bool get isDest2 => bits[isDest2Indice];
  bool get isDest1 => bits[isDest1Indice];
  bool get useConFlags => bits[useConFlagsIndice];
  bool get isCon4 => bits[isCon4Indice];
  bool get unknown => bits[unknownIndice];

  @override
  List<int> get visibilityFlags => [];

  @override
  bool isCompatible(ChunkAttributes filter) {
    final isDestCompatible = (!isDest1 && !isDest2) ||
        (isDest1 && filter.bits[isDest1Indice]) ||
        (isDest2 && filter.bits[isDest2Indice]);
    return this == filter ||
        (isLodCompatible(filter) &&
            isDestCompatible &&
            isFlagCompatible(filter));
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

  static const int isTreeBillboardIndice = 20;
  static const int isSelectionVolumeIndice = 21;

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

  static const int useWaterShaderIndice = 18;
  bool get useWaterShader => bits[useWaterShaderIndice];

  @override
  List<int> get visibilityFlags => [];

  @override
  List<int> get usedIndices =>
      super.usedIndices..addAll([useWaterShaderIndice]);
}
