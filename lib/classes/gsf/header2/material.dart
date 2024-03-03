import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';

class MaterialData extends GsfPart {
  late final Standard4BytesData<UnknowData> bitsetAttribute1;
  late final Standard4BytesData<UnknowData> bitsetAttribute2;
  late final Standard4BytesData<int> textureNameOffset;
  late final Standard4BytesData<int> nmNameOffset;
  late final Standard4BytesData<int> envNameOffset;
  late final Standard4BytesData<Uint8List> zeroPadding;

  NameStruct? textureName;
  NameStruct? nmName;
  NameStruct? envName;

  @override
  String get label {
    if (textureName == null && nmName == null && envName == null) {
      return "empty material";
    }
    String label = "";
    if (textureName != null) {
      label += "texture $textureName\n";
    }
    if (nmName != null) {
      label += "nm $nmName\n";
    }
    if (envName != null) {
      label += "env $envName";
    }
    return label;
  }

  MaterialData.fromBytes(Uint8List bytes, int offset) : super(offset: offset) {
    bitsetAttribute1 = Standard4BytesData(
      position: 0,
      bytes: bytes,
      offset: offset,
    );

    bitsetAttribute2 = Standard4BytesData(
      position: bitsetAttribute1.relativeEnd,
      bytes: bytes,
      offset: offset,
    );

    textureNameOffset = Standard4BytesData(
      position: bitsetAttribute2.relativeEnd,
      bytes: bytes,
      offset: offset,
    );

    nmNameOffset = Standard4BytesData(
      position: textureNameOffset.relativeEnd,
      bytes: bytes,
      offset: offset,
    );

    envNameOffset = Standard4BytesData(
      position: nmNameOffset.relativeEnd,
      bytes: bytes,
      offset: offset,
    );

    zeroPadding = Standard4BytesData(
      position: envNameOffset.relativeEnd,
      bytes: bytes,
      offset: offset,
    );

    if (textureNameOffset.value & 0x80000000 == 0) {
      textureName = NameStruct.fromBytes(
        bytes,
        textureNameOffset.offsettedPos + textureNameOffset.value,
        NameStructType.texture,
      );
    }

    if (nmNameOffset.value & 0x80000000 == 0) {
      nmName = NameStruct.fromBytes(
        bytes,
        nmNameOffset.offsettedPos + nmNameOffset.value,
        NameStructType.nm,
      );
    }

    if (envNameOffset.value & 0x80000000 == 0) {
      envName = NameStruct.fromBytes(
        bytes,
        envNameOffset.offsettedPos + envNameOffset.value,
        NameStructType.env,
      );
    }
  }

  @override
  int getEndOffset() {
    return zeroPadding.offsettedLength;
  }
}

enum NameStructType {
  texture,
  nm,
  env,
}

class NameStruct extends GsfPart {
  final NameStructType type;
  late final Standard4BytesData<int> stringsCount;
  late final Standard4BytesData<int> maxCharactersCount;
  late final Standard4BytesData<int> charactersCount;
  late final GsfData<StringNoZero> trueName;
  late final GsfData<Uint8List> padding;

  @override
  String get label => "${type.name} ${trueName.value}";

  @override
  String toString() => trueName.value.value;

  NameStruct.fromBytes(
    Uint8List bytes,
    int offset,
    this.type,
  ) : super(offset: offset) {
    stringsCount = Standard4BytesData(
      position: 0,
      bytes: bytes,
      offset: offset,
    );

    maxCharactersCount = Standard4BytesData(
      position: stringsCount.relativeEnd,
      bytes: bytes,
      offset: offset,
    );

    charactersCount = Standard4BytesData(
      position: maxCharactersCount.relativeEnd,
      bytes: bytes,
      offset: offset,
    );

    trueName = GsfData.fromPosition(
      relativePos: charactersCount.relativeEnd,
      length: charactersCount.value,
      bytes: bytes,
      offset: offset,
    );

    padding = GsfData.fromPosition(
      relativePos: trueName.relativeEnd,
      length: maxCharactersCount.value - charactersCount.value,
      bytes: bytes,
      offset: offset,
    );
  }

  @override
  int getEndOffset() {
    return padding.offsettedLength;
  }
}
