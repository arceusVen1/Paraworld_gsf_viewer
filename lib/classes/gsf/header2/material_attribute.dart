class MaterialAttribute {
  MaterialAttribute({
    this.useHardAlpha = false,
    this.useSoftAlpha = false,
    this.useNm = false,
    this.useShininessShader = false,
    this.usePlayerColor = false,
    this.useWaterShader = false,
  });

  late final bool useHardAlpha;
  late final bool useSoftAlpha;
  late final bool useNm;
  late final bool useShininessShader;
  late final bool usePlayerColor;
  late final bool useWaterShader;

  MaterialAttribute.zero() : this(useSoftAlpha: true);

  MaterialAttribute.fromValues(int bitset1, int bitset2) {
    useHardAlpha = bitset1 & 0x00000001 >= 0x00000001;
    useSoftAlpha = bitset1 & 0x00000002 >= 0x00000002;
    useNm = bitset1 & 0x00000010 >= 0x00000010;
    usePlayerColor = bitset1 & 0x00001000 >= 0x00001000;
    useShininessShader = bitset1 & 0x00004000 >= 0x00004000;
    useWaterShader = bitset2 & 0x00000020 == 0x00000020;
  }

  @override
  String toString() {
    return "useHardAlpha: $useHardAlpha, useSoftAlpha: $useSoftAlpha, useNm: $useNm, useShininessShader: $useShininessShader, usePlayerColor: $usePlayerColor, useWaterShader: $useWaterShader";
  }

  @override
  bool operator ==(Object other) {
    if (other is MaterialAttribute) {
      return useHardAlpha == other.useHardAlpha &&
          useSoftAlpha == other.useSoftAlpha &&
          useNm == other.useNm &&
          useShininessShader == other.useShininessShader &&
          usePlayerColor == other.usePlayerColor &&
          useWaterShader == other.useWaterShader;
    }
    return false;
  }

  @override
  int get hashCode {
    return useHardAlpha.hashCode ^
        useSoftAlpha.hashCode ^
        useNm.hashCode ^
        useShininessShader.hashCode ^
        usePlayerColor.hashCode ^
        useWaterShader.hashCode;
  }
}
