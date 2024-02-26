import 'dart:convert';
import 'dart:typed_data';

abstract class GsfPart {
  GsfPart({required this.offset});

  final int offset;
  late final GsfData<String> name;

  // the offset at the end of the part
  int getEndOffset();

  // the end position
  int get length => getEndOffset() - offset;

  @override
  bool operator ==(Object other) =>
      other is GsfPart &&
      other.offset == offset &&
      other.name == name &&
      other.length == length;

  @override
  int get hashCode => offset.hashCode ^ name.hashCode;
}

typedef UnknowData = Uint8List;

class GsfData<T> {
  GsfData();

  _init({required int relativePos, required int length, required int offset}) {
    this.relativePos = relativePos;
    this.length = length;
    this.offset = offset;
  }

  late final int relativePos;
  late final int length;
  late final T value;
  late final int offset;

  GsfData.fromPosition({
    required this.relativePos,
    required this.length,
    required Uint8List bytes,
    required this.offset,
  }) {
    parseValue(bytes);
  }

  GsfData.fromValue(
      {required this.value,
      required this.offset,
      required this.relativePos,
      int? length}) {
    if (T is String) {
      length = (value as String).length + 1; // +1 for trailing 0
    } else if (length != null) {
      this.length = length;
    } else {
      throw Exception('Length must be provided for non-string values');
    }
  }

  int get relativeEnd => relativePos + length;
  int get offsettedPos => relativePos + offset;
  int get offsettedLength => offsettedPos + length;

  parseValue(Uint8List bytes) {
    switch (T) {
      case int:
        value = getAsUint(bytes) as T;
      case double:
        value = getAsFloat(bytes) as T;
      case String:
        value = getAsAsciiString(bytes) as T;
      case bool:
        value = getAsBool(bytes) as T;
      case UnknowData:
        value = bytes.sublist(offsettedPos, offsettedLength) as T;
      default:
        throw Exception('Invalid type');
    }
  }

  String getAsAsciiString(Uint8List bytes) {
    final stringBytes = bytes.sublist(offsettedPos, offsettedLength);
    assert(stringBytes.last == 0); // all names should have a 0 name terminator
    return const AsciiDecoder()
        .convert(stringBytes.sublist(0, stringBytes.length - 1));
  }

  ByteData getBytesData(Uint8List bytes) {
    return ByteData.sublistView(bytes, offsettedPos, offsettedLength);
  }

  int getAsUint(Uint8List bytes) {
    final data = getBytesData(bytes);
    int value;
    switch (length) {
      case >= 8:
        value = data.getUint64(0, Endian.little);
      case >= 4:
        value = data.getUint32(0, Endian.little);
      case >= 2:
        value = data.getUint16(0, Endian.little);
      default:
        value = data.getUint8(0);
    }
    return value;
  }

  double getAsFloat(Uint8List bytes) {
    final data = getBytesData(bytes);
    switch (length) {
      case >= 8:
        return data.getFloat64(0, Endian.little);
      case >= 4:
        return data.getFloat32(0, Endian.little);
      default:
        throw Exception('Invalid length');
    }
  }

  bool getAsBool(Uint8List bytes) {
    final intValue = getAsUint(bytes);
    assert(intValue == 0 || intValue == 1, 'Invalid value for bool $intValue');
    return intValue > 0;
  }

  @override
  String toString() {
    return value.toString();
  }

  @override
  bool operator ==(Object other) =>
      other is GsfData &&
      other.offset == offset &&
      other.relativePos == relativePos &&
      other.length == length &&
      other.value == value;

  @override
  int get hashCode => offset.hashCode ^ relativePos.hashCode ^ length.hashCode;
}

/// A [GsfData] that is 4 bytes long.
class Standard4BytesData<T> extends GsfData<T> {
  Standard4BytesData(
      {required int position, required Uint8List bytes, required int offset})
      : super() {
    super._init(relativePos: position, length: 4, offset: offset);
    super.parseValue(bytes);
  }

  @override
  int getAsUint(Uint8List bytes) {
    return super.getBytesData(bytes).getUint32(0, Endian.little);
  }

  @override
  double getAsFloat(Uint8List bytes) {
    return super.getBytesData(bytes).getFloat32(0, Endian.little);
  }

  @override
  String getAsAsciiString(Uint8List bytes) {
    final stringBytes = bytes.sublist(offsettedPos, offsettedLength);
    return const AsciiDecoder().convert(stringBytes);
  }
}

class DoubleByteData<T> extends GsfData<T> {
  DoubleByteData(
      {required int relativePos, required Uint8List bytes, required int offset}) {
    super._init(relativePos: relativePos, length: 2, offset: offset);
    super.parseValue(bytes);
  }

  @override
  int getAsUint(Uint8List bytes) {
    return super.getBytesData(bytes).getUint16(0, Endian.little);
  }

  @override
  double getAsFloat(Uint8List bytes) {
    throw Exception('Double byte data cannot be converted to float');
  }

  @override
  String getAsAsciiString(Uint8List bytes) {
    return const AsciiDecoder()
        .convert(bytes.sublist(offsettedPos, offsettedLength));
  }
}

class VariableTwoBytesData<T> extends GsfData<T> {
  VariableTwoBytesData(
      {required int relativePosition,
      required Uint8List bytes,
      required int offset}) {
    this.offset = offset;
    relativePos = relativePosition;
    if (T != int) {
      throw Exception('Invalid type, variable two bytes data can only be int');
    }

    if (bytes[offset + relativePos] & 0x80 > 0) {
      length = 2;
    } else {
      length = 1;
    }
    value = (getAsUint(bytes) & 0x7FFF) as T;
  }

  @override
  int getAsUint(Uint8List bytes) {
    final bytesData = super.getBytesData(bytes);
    switch (length) {
      case 2:
        return bytesData.getUint16(
            0, Endian.big); // special case for the variables values
      default:
        return bytesData.getUint8(0);
    }
  }
}

/// A [GsfData] that is 1 byte long.
class SingleByteData<T> extends GsfData {
  SingleByteData(
      {required int pos, required Uint8List bytes, required int offset}) {
    if (T != int) {
      throw Exception('Invalid type, single byte data can only be int');
    }
    super._init(relativePos: pos, length: 1, offset: offset);
    value = getAsUint(bytes);
  }

  @override
  int getAsUint(Uint8List bytes) {
    return super.getBytesData(bytes).getUint8(0);
  }

  @override
  double getAsFloat(Uint8List bytes) {
    throw Exception('Single byte data cannot be converted to float');
  }

  @override
  String getAsAsciiString(Uint8List bytes) {
    throw Exception('Single byte data cannot be converted to string');
  }
}
