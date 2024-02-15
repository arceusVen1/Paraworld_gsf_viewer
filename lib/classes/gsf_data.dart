import 'dart:convert';
import 'dart:typed_data';

abstract class GsfPart {
  GsfPart({required this.offset});

  final int offset;

  // the offset at the end of the part
  int getEndOffset();
}

typedef UnknowData = Uint8List;

class GsfData<T> {
  GsfData();

  _init({required int pos, required int length}) {
    this.pos = pos;
    this.length = length;
  }

  late final int pos;
  late final int length;
  late final T value;

  GsfData.fromPosition(
      {required this.pos,
      required this.length,
      required Uint8List bytes,
      required int offset}) {
    parseValue(bytes, offset);
  }

  GsfData.fromValue({required this.value, required this.pos, int? length}) {
    if (T is String) {
      length = (value as String).length + 1; // +1 for trailing 0
    } else if (length != null) {
      this.length = length;
    } else {
      throw Exception('Length must be provided for non-string values');
    }
  }

  int get relativeEnd => pos + length;
  int offsettedPos(int offset) => pos + offset;
  int offsettedLength(int offset) => offsettedPos(offset) + length;

  parseValue(Uint8List bytes, int offset) {
    switch (T) {
      case int:
        value = getAsUint(bytes, offset) as T;
      case double:
        value = getAsFloat(bytes, offset) as T;
      case String:
        value = getAsAsciiString(bytes, offset) as T;
      case UnknowData:
        value =
            bytes.sublist(offsettedPos(offset), offsettedLength(offset)) as T;
      default:
        throw Exception('Invalid type');
    }
  }

  String getAsAsciiString(Uint8List bytes, int offset) {
    final stringBytes =
        bytes.sublist(offsettedPos(offset), offsettedLength(offset));
    assert(stringBytes.last == 0); // all names should have a 0 name terminator
    return const AsciiDecoder()
        .convert(stringBytes.sublist(0, stringBytes.length - 1));
  }

  ByteData getBytesData(Uint8List bytes, int offset) {
    return ByteData.sublistView(
        bytes, offsettedPos(offset), offsettedLength(offset));
  }

  int getAsUint(Uint8List bytes, int offset) {
    final data = getBytesData(bytes, offset);
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

  double getAsFloat(Uint8List bytes, int offset) {
    final data = getBytesData(bytes, offset);
    switch (length) {
      case >= 8:
        return data.getFloat64(0, Endian.little);
      case >= 4:
        return data.getFloat32(0, Endian.little);
      default:
        throw Exception('Invalid length');
    }
  }

  @override
  String toString() {
    return value.toString();
  }
}

/// A [GsfData] that is 4 bytes long.
class Standard4BytesData<T> extends GsfData<T> {
  Standard4BytesData(
      {required int position, required Uint8List bytes, required int offset})
      : super() {
    super._init(pos: position, length: 4);
    super.parseValue(bytes, offset);
  }

  @override
  int getAsUint(Uint8List bytes, int offset) {
    return super.getBytesData(bytes, offset).getUint32(0, Endian.little);
  }

  @override
  double getAsFloat(Uint8List bytes, int offset) {
    return super.getBytesData(bytes, offset).getFloat32(0, Endian.little);
  }

  @override
  String getAsAsciiString(Uint8List bytes, int offset) {
    final stringBytes =
        bytes.sublist(offsettedPos(offset), offsettedLength(offset));
    return const AsciiDecoder().convert(stringBytes);
  }
}

class DoubleByteData<T> extends GsfData<T> {
  DoubleByteData(
      {required int pos, required Uint8List bytes, required int offset}) {
    super._init(pos: pos, length: 2);
    super.parseValue(bytes, offset);
  }

  @override
  int getAsUint(Uint8List bytes, int offset) {
    return super.getBytesData(bytes, offset).getUint16(0, Endian.little);
  }

  @override
  double getAsFloat(Uint8List bytes, int offset) {
    throw Exception('Double byte data cannot be converted to float');
  }

  @override
  String getAsAsciiString(Uint8List bytes, int offset) {
    return const AsciiDecoder()
        .convert(bytes.sublist(offsettedPos(offset), offsettedLength(offset)));
  }
}

class VariableTwoBytesData<T> extends GsfData<T> {
  VariableTwoBytesData(
      {required int relativePosition,
      required Uint8List bytes,
      required int offset}) {
    pos = relativePosition;
    if (T != int) {
      throw Exception('Invalid type, variable two bytes data can only be int');
    }

    if (bytes[offset + pos] & 0x80 > 0) {
      length = 2;
    } else {
      length = 1;
    }
    //super._init(pos: pos, length: length);
    value = (getAsUint(bytes, offset) & 0x7FFF) as T;
  }
}

/// A [GsfData] that is 1 byte long.
class SingleByteData<T> extends GsfData {
  SingleByteData(
      {required int pos, required Uint8List bytes, required int offset}) {
    if (T != int) {
      throw Exception('Invalid type, single byte data can only be int');
    }
    super._init(pos: pos, length: 1);
    value = getAsUint(bytes, offset);
  }

  @override
  int getAsUint(Uint8List bytes, int offset) {
    return super.getBytesData(bytes, offset).getUint8(0);
  }

  @override
  double getAsFloat(Uint8List bytes, int offset) {
    throw Exception('Single byte data cannot be converted to float');
  }

  @override
  String getAsAsciiString(Uint8List bytes, int offset) {
    throw Exception('Single byte data cannot be converted to string');
  }
}
