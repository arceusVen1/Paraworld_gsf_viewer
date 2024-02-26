import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/gsf/header/header.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/header2.dart';

class GSF {
  GSF({
    required this.header,
    required this.header2,
  });

  late final Header header;
  late final Header2 header2;

  GSF.fromBytes(Uint8List bytes) {
    header = Header.fromBytes(bytes);
    header2 = Header2.fromBytes(bytes, header.header2Offset.value);
  }

  @override
  String toString() {
    // TODO: implement toString
    return header.toString();
  }
}
