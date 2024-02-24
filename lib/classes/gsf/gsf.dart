import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/gsf/header/header.dart';

class GSF {
  const GSF({
    required this.header,
  });

  final Header header;

  GSF.fromBytes(Uint8List bytes) : header = Header.fromBytes(bytes);

  @override
  String toString() {
    // TODO: implement toString
    return header.toString();
  }
}
