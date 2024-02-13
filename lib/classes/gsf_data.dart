import 'dart:convert';
import 'dart:typed_data';

abstract class GsfPart {
  GsfPart({required this.offset});

  final int offset;

  // the offset at the end of the part
  int getEndOffset();
}

class GsfData {
  const GsfData({required this.pos, required this.length});

  final int pos;
  final int length;

  int relativeEnd() => pos + length;
  int offsettedPos(int offset) => pos + offset;
  int offsettedLength(int offset) => offsettedPos(offset) + length;

  String getAsAsciiString(Uint8List bytes, int offset) {
    return const AsciiDecoder()
        .convert(bytes.sublist(offsettedPos(offset), offsettedLength(offset)));
  }

  ByteData getBytesData(Uint8List bytes, int offset) {
    return ByteData.sublistView(
        bytes, offsettedPos(offset), offsettedLength(offset));
  }

  int getAsUint(Uint8List bytes, int offset) {
    final data = getBytesData(bytes, offset);
    switch (length) {
      case >= 8:
        return data.getUint64(0, Endian.little);
      case >= 4:
        return data.getUint32(0, Endian.little);
      case >= 2:
        return data.getUint16(0, Endian.little);
      default:
        return data.getUint8(0);
    }
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
}

/// A [GsfData] that is 4 bytes long.
class Standard4BytesData extends GsfData {
  const Standard4BytesData({required int pos}) : super(pos: pos, length: 4);

  @override
  int getAsUint(Uint8List bytes, int offset) {
    return super.getBytesData(bytes, offset).getUint32(0, Endian.little);
  }

  @override
  double getAsFloat(Uint8List bytes, int offset) {
    return super.getBytesData(bytes, offset).getFloat32(0, Endian.little);
  }
}

class DoubleByteData extends GsfData {
  const DoubleByteData({required int pos}) : super(pos: pos, length: 2);

  @override
  int getAsUint(Uint8List bytes, int offset) {
    return super.getBytesData(bytes, offset).getUint16(0, Endian.little);
  }

  @override
  double getAsFloat(Uint8List bytes, int offset) {
    throw Exception('Double byte data cannot be converted to float');
  }
}

/// A [GsfData] that is 1 byte long.
class SingleByteData extends GsfData {
  const SingleByteData({required int pos}) : super(pos: pos, length: 1);

  @override
  int getAsUint(Uint8List bytes, int offset) {
    return super.getBytesData(bytes, offset).getUint8(0);
  }

  @override
  double getAsFloat(Uint8List bytes, int offset) {
    throw Exception('Single byte data cannot be converted to float');
  }
}
