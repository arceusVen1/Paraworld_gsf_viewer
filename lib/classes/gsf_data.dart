import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';

abstract class GsfPartInterface {
  int get offset;
  String get label;
  //GsfData<String>? get name;
  int get length;
  int getEndOffset();
}

class GsfPart extends GsfPartInterface {
  GsfPart({required this.offset});

  @override
  final int offset;

  @override
  String get label => throw UnimplementedError();

  @override
  String toString() => label;

  @override
  int getEndOffset() {
    throw UnimplementedError();
  }

  // the end position
  @override
  int get length => getEndOffset() - offset;

  @override
  bool operator ==(Object other) =>
      other is GsfPart &&
      other.offset == offset &&
      other.label == other.label &&
      other.length == length;

  @override
  int get hashCode => offset.hashCode ^ label.hashCode;
}

typedef UnknowData = Uint8List;

/// a Class to represent a string that does not end with a 0 in the model
class StringNoZero {
  const StringNoZero(this.value);

  final String value;

  @override
  String toString() => value;

  @override
  bool operator ==(Object other) =>
      (other is StringNoZero || other is String) &&
      other.toString() == toString();

  @override
  int get hashCode => value.hashCode;
}

/// a Class to represent a string that does not end with a 0 in the model
class SignedInt {
  const SignedInt(this.value);

  final int value;

  @override
  String toString() => value.toString();

  @override
  bool operator ==(Object other) => ((other is int && other == value) ||
      (other is SignedInt && other.value == value));

  @override
  int get hashCode => value.hashCode;
}

typedef NegativeOffset = SignedInt;

class GsfData<T> {
  GsfData();

  double _roundAtDecimal(double val, int decimal) {
    num mod = pow(10.0, decimal);
    return ((val * mod).round().toDouble() / mod);
  }

  _init({required int relativePos, required int length, required int offset}) {
    this.relativePos = relativePos;
    this.length = length;
    this.offset = offset;
  }

  late final int relativePos;
  late final int length;
  late final T value;
  late final int offset;
  Uint8List? bytesData;

  GsfData.fromPosition({
    required this.relativePos,
    required this.length,
    required Uint8List bytes,
    required this.offset,
  }) {
    parseValue(bytes);
  }

  GsfData.fromValue({
    required this.value,
    required this.offset,
    required this.relativePos,
    int? length,
  }) {
    if (T is String && length == null) {
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
      case SignedInt:
        value = SignedInt(getAsSignedInt(bytes)) as T;
      case double:
        value = _roundAtDecimal(getAsFloat(bytes), 3) as T;
      case String:
        value = getAsAsciiString(bytes, true) as T;
      case StringNoZero:
        value = StringNoZero(getAsAsciiString(bytes, false)) as T;
      case bool:
        value = getAsBool(bytes) as T;
      case UnknowData:
        value = bytes.sublist(offsettedPos, offsettedLength) as T;
        bytesData = value as Uint8List;
      default:
        throw Exception('Invalid type');
    }
  }

  String getAsAsciiString(Uint8List bytes, bool trailingZero) {
    bytesData = bytes.sublist(offsettedPos, offsettedLength);
    int strLength = bytesData!.length;
    if (trailingZero) {
      assert(bytesData!.last == 0); // all names should have a 0 name terminator
      strLength -= 1;
    }
    return const AsciiDecoder().convert(bytesData!.sublist(0, strLength));
  }

  ByteData getBytesData(Uint8List bytes) {
    bytesData = bytes.sublist(offsettedPos, offsettedLength);
    return ByteData.sublistView(bytesData!);
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

  int getAsSignedInt(Uint8List bytes) {
    final data = getBytesData(bytes);
    int value;
    switch (length) {
      case >= 8:
        value = data.getInt64(0, Endian.little);
      case >= 4:
        value = data.getInt32(0, Endian.little);
      case >= 2:
        value = data.getInt16(0, Endian.little);
      default:
        value = data.getInt8(0);
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
    switch (T) {
      case int:
        return '$value (0x${(value as int).toRadixString(16)})';
      default:
        return value.toString();
    }
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

  bool get isUnused => T == int && value == 0x80000000;

  @override
  int getAsUint(Uint8List bytes) {
    return super.getBytesData(bytes).getUint32(0, Endian.little);
  }

  @override
  int getAsSignedInt(Uint8List bytes) {
    return super.getBytesData(bytes).getInt32(0, Endian.little);
  }

  @override
  double getAsFloat(Uint8List bytes) {
    return super.getBytesData(bytes).getFloat32(0, Endian.little);
  }

  @override
  String getAsAsciiString(Uint8List bytes, bool trailingZero) {
    bytesData = bytes.sublist(offsettedPos, offsettedLength);
    return const AsciiDecoder().convert(bytesData!);
  }
}

class DoubleByteData<T> extends GsfData<T> {
  DoubleByteData(
      {required int relativePos,
      required Uint8List bytes,
      required int offset}) {
    super._init(relativePos: relativePos, length: 2, offset: offset);
    super.parseValue(bytes);
  }

  @override
  int getAsUint(Uint8List bytes) {
    return super.getBytesData(bytes).getUint16(0, Endian.little);
  }

  @override
  int getAsSignedInt(Uint8List bytes) {
    return super.getBytesData(bytes).getInt16(0, Endian.little);
  }

  @override
  double getAsFloat(Uint8List bytes) {
    throw Exception('Double byte data cannot be converted to float');
  }

  @override
  String getAsAsciiString(Uint8List bytes, bool trailingZero) {
    bytesData = bytes.sublist(offsettedPos, offsettedLength);
    return const AsciiDecoder().convert(bytesData!);
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
      {required int relativePos,
      required Uint8List bytes,
      required int offset}) {
    if (T != int && T != bool) {
      throw Exception('Invalid type, single byte data can only be int or bool');
    }
    super._init(relativePos: relativePos, length: 1, offset: offset);
    value = getAsUint(bytes);
  }

  @override
  int getAsUint(Uint8List bytes) {
    return super.getBytesData(bytes).getUint8(0);
  }

  @override
  int getAsSignedInt(Uint8List bytes) {
    return super.getBytesData(bytes).getInt8(0);
  }

  @override
  double getAsFloat(Uint8List bytes) {
    throw Exception('Single byte data cannot be converted to float');
  }

  @override
  String getAsAsciiString(Uint8List bytes, bool trailingZero) {
    throw Exception('Single byte data cannot be converted to string');
  }
}
