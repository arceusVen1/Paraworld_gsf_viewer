import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/bouding_box.dart';
import 'package:paraworld_gsf_viewer/classes/vertex.dart';
import 'package:paraworld_gsf_viewer/sphere.dart';
import 'package:vector_math/vector_math.dart';

const String cubeTest = '''
00 E0 FF 03 00 DF FE 00
00 E0 FF 03 00 5E 00 00
00 E0 FF 03 00 DC FE 00
FF FF FF 03 00 DF 00 00
FF FF FF 03 00 5E FE 00
FF FF FF 03 00 9E 00 00
00 00 00 00 00 DF FE FE
00 00 00 00 00 7F FE 00
00 00 00 00 00 DC 00 00
FF 1F 00 00 00 DF 00 FE
FF 1F 00 00 00 9E FE 00
FF 1F 00 00 00 7F 00 00
00 E0 FF FF 7F BD 00 00
00 E0 FF FF 7F 5E 00 FE
00 E0 FF FF 7F DC FE FE
FF FF FF FF 7F BD FE 00
FF FF FF FF 7F 5E FE FE
FF FF FF FF 7F 9E 00 FE
00 00 00 FC 7F BD 00 FE
00 00 00 FC 7F 7F FE FE
00 00 00 FC 7F DC 00 FE
FF 1F 00 FC 7F BD FE FE
FF 1F 00 FC 7F 9E FE FE
FF 1F 00 FC 7F 7F 00 FE
''';

const String cubeTriangles = '''
06 00 00 00 09 00
00 00 03 00 09 00
04 00 01 00 10 00
01 00 0D 00 10 00
02 00 08 00 0E 00
0A 00 05 00 16 00
05 00 11 00 16 00
07 00 0B 00 13 00
0E 00 08 00 14 00
13 00 0B 00 17 00
0F 00 0C 00 15 00
0C 00 12 00 15 00
''';

const String verticesTest = '''
ff4f 0036 66d1 b823 01ff ffff ff00 0000
ffef ff03 2ba9 7e80 00ff ffff ff00 0000
ffef ff03 2ba9 a87d 00ff ffff ff00 0000
ff6f 31e3 6e07 7e4c 0100 ffff 7f80 0000
a112 c68f 41ba 886f 00ff ffff ff00 0000
4934 bdae 4d41 9032 0100 ffff 7f80 0000
2c91 97d8 ac9d f420 02ff ffff ff00 0000
ffcf d217 4920 7e70 00ff ffff ff00 0000
3b55 7b8f aa77 9f5d 00ff ffff ff00 0000
3b55 7b8f aa77 bb63 00ff ffff ff00 0000
bb73 8d06 35e6 9822 01ff ffff ff00 0000
bb73 8d06 35e6 b535 01ff ffff ff00 0000
bb73 8d06 35e6 e881 01ff ffff ff00 0000
ff0f 5885 3f07 f946 0102 ffff 7f80 0000
391b 2cc3 3421 9d04 00ff ffff ff00 0000
530e 5861 ad16 ef45 0102 ffff 7f80 0000
ff0f 5899 9cd7 e543 0102 ffff 7f80 0000
07eb a2c6 376b 9d27 0100 ffff 906f 0000
07eb a2c6 376b ba39 0100 ffff 906f 0000
ea05 88ca 3c21 821e 00ff ffff ff00 0000
d769 e66d 3537 e905 01ff ffff ff00 0000
ab11 5861 ad9d ef45 0102 ffff 7f80 0000
7bda 1d92 3537 e917 01ff ffff ff00 0000
8df3 cb93 a572 9176 00ff ffff ff00 0000
8df3 cb93 a572 b573 00ff ffff ff00 0000
ff8f 97f4 a3d7 ee1f 02ff ffff ff00 0000
1b94 4a47 5e36 8f51 00ff ffff ff00 0000
9a8f 7cd2 3537 c504 01ff ffff ff00 0000
b894 b346 3737 c517 0100 ffff 8679 0000
ffdf bc56 3a21 7d03 00ff ffff ff00 0000
ffaf e7e9 4907 f962 01ff ffff ff00 0000
2776 e66d 3537 e905 01ff ffff ff00 0000
ff2f 3301 00d1 e01f 02ff ffff ff00 0000
468b b346 3737 c517 0100 ffff 8679 0000
ffaf 74c2 55d1 a11d 01ff ffff ff00 0000
ff2f 9724 54d1 c641 02ff ffff ff00 0000
8af6 f36a b190 a43f 0100 ffff 9569 0000
8af6 f36a b190 c049 0100 ffff 9569 0000
ffaf e7b1 99d7 df5e 01ff ffff ff00 0000
71ec cb93 a540 9176 00ff ffff ff00 0000
71ec cb93 a540 b573 00ff ffff ff00 0000
ff2f f761 4ad1 ba1a 01ff ffff ff00 0000
ff4f 88fd 7fd1 c36f 01ff ffff ff00 0000
e38b 4a47 5e11 8f51 00ff ffff ff00 0000
ffef 8282 5f07 7e25 01ff ffff ff00 0000
ff8f df79 48d1 c256 01ff ffff ff00 0000
4a95 5e7f 3207 b510 00ff ffff ff00 0000
4a95 5e7f 3207 bf03 00ff ffff ff00 0000
ff0f 2b69 70d1 d477 01ff ffff ff00 0000
ffef 5f4a 6fd1 a526 01ff ffff ff00 0000
ff6f d3cb 9fd9 a874 00ff ffff ff00 0000
c2b4 7ab7 392d bb0e 00ff ffff ff00 0000
efb1 e7bd b09d ec60 01ff ffff ff00 0000
ffef 133c ac9e f706 02ff ffff ff00 0000
ff6f 32d9 53d1 c61f 02ff ffff ff00 0000
b48a 5e7f 3237 b510 00ff ffff ff00 0000
b48a 5e7f 3237 bf03 00ff ffff ff00 0000
83c5 1d92 3537 e917 01ff ffff ff00 0000
0fae e7bd b016 ec60 01ff ffff ff00 0000
c34a 7b8f aa3b 9f5d 00ff ffff ff00 0000
c34a 7b8f aa3b bb63 00ff ffff ff00 0000
74e9 f36a b123 a43f 0100 ffff 956a 0000
74e9 f36a b123 c049 0100 ffff 956a 0000
c504 2cc3 3421 9d04 00ff ffff ff00 0000
1474 815f 4ebf 8f5e 00ff ffff ff00 0000
2bf5 76eb aae2 bd09 00ff ffff ff00 0000
141a 88ca 3c21 821e 00ff ffff ff00 0000
ff8f 86ab 5622 7e5f 00ff ffff ff00 0000
ea6b 815f 4e90 8f5e 00ff ffff ff00 0000
5d0d c68f 419d 886f 00ff ffff ff00 0000
ff6f 72e2 5806 7e22 01ff ffff ff00 0000
ff6f 72e2 5806 fa7d 01ff ffff ff00 0000
ff6f 6c0a 99bc a82e 01ff ffff ff00 0000
ff6f 6c0a 99bc da77 01ff ffff ff00 0000
f7f4 a2c6 b794 9d27 0100 ffff 906f 0000
f7f4 a2c6 b794 ba39 0100 ffff 906f 0000
d169 5def ab32 a257 00ff ffff ff00 0000
d169 5def ab32 bf5d 00ff ffff ff00 0000
ff0f 0070 2bd1 d356 02ff ffff ff00 0000
d28e 97d8 ac15 f420 02ff ffff ff00 0000
ff0f 6229 3ed1 d763 01ff ffff ff00 0000
2d76 5def ab80 a257 00ff ffff ff00 0000
2d76 5def ab80 bf5d 00ff ffff ff00 0000
6490 7cd2 3537 c504 01ff ffff ff00 0000
ff4f 6d7f 6322 7e58 00ff ffff ff00 0000
b52b bdae 4d09 9032 0100 ffff 7f80 0000
436c 8d06 3567 9822 01ff ffff ff00 0000
436c 8d06 3567 b535 01ff ffff ff00 0000
436c 8d06 3567 e881 01ff ffff ff00 0000
d3ea 76eb aace bd09 00ff ffff ff00 0000
ff6f 97f0 3537 f921 02ff ffff ff00 0000
00c0 bc56 3a21 7d03 00ff ffff ff00 0000
3cab 7ab7 391a bb0e 00ff ffff ff00 0000
ffaf 97f0 0ad1 dd41 02ff ffff ff00 0000
ff8f 66e3 99d7 a860 00ff ffff ff00 0000
''';

const String trianglesTest = '''
2200 0000
2900 0000 2200 3100 0400 0100 0700 0100
0400 1700 0200 1800 3200 0700 0100 4500
0100 2700 4500 2800 0200 3200 0300 1a00
5400 0300 0500 1a00 0500 0300 2c00 2b00
0300 5400 0300 2b00 5500 2c00 0300 5500
1700 0400 4000 0400 0700 4300 4000 0400
4300 0500 2c00 4600 0500 4600 4a00 2400
0500 4a00 1a00 0500 2400 1900 0600 3500
1500 0600 1900 0600 1500 5a00 3500 0600
5a00 4300 0700 4500 0800 1700 4000 0800
4000 5100 1800 0900 5e00 0900 5200 5e00
4600 0a00 4a00 0b00 4800 4b00 0c00 3400
4900 1e00 0c00 4700 0c00 1e00 3400 1500
0d00 5a00 1e00 0d00 3400 0d00 1500 3400
0d00 0f00 5a00 0d00 1e00 3a00 0f00 0d00
3a00 0e00 2e00 4200 1d00 0e00 4200 2e00
0e00 3300 3300 0e00 4100 0e00 2f00 4100
0f00 1900 4f00 0f00 1000 1900 1000 0f00
2600 2600 0f00 3a00 0f00 4f00 5a00 1000
1500 1900 1500 1000 2600 4600 1100 5600
1100 4600 5500 3d00 1100 5500 1200 4800
5700 1200 3e00 4800 1300 3700 3f00 1300
3f00 5b00 1400 2100 3900 1400 1b00 2100
1500 2600 3400 1600 1c00 1f00 3200 1800
5e00 1900 3500 4f00 1a00 4000 5400 4000
1a00 5100 1a00 2400 5100 1f00 1c00 5300
1e00 4700 5800 3a00 1e00 5800 2300 2000
3600 2000 2300 5d00 2300 4e00 5d00 5200
2500 5e00 2500 4800 5e00 4800 2500 4b00
3400 2600 4900 2600 3a00 4900 2700 4400
4500 2700 3b00 4400 3c00 2800 5e00 2800
3200 5e00 2d00 2a00 3000 4400 2b00 5400
2b00 4400 4c00 3d00 2b00 4c00 2b00 3d00
5500 4600 2c00 5500 2d00 3000 5000 4f00
3500 5a00 3f00 3700 5c00 3800 3f00 5900
4900 3a00 5800 4400 3b00 4c00 4d00 3c00
5e00 3e00 4d00 5e00 4800 3e00 5e00 5900
3f00 5c00 4000 4300 5400 4300 4400 5400
4400 4300 4500
''';

List<String> convertToByteArray(String testString, [is8Byte = false]) {
  final List<String> bytes = [];
  final hexString = testString
      .replaceAll("\n", is8Byte ? "0000 0000 0000 0000" : "")
      .split(" ")
      .join();
  for (int i = 0; i < hexString.length; i += 2) {
    String hex = hexString.substring(i, i + 2);
    bytes.add(hex);
  }
  return bytes;
}

//int.parse(hex, radix: 16)

int convertToSignedPosition(int initialByte) {
  if ((initialByte & 0x80) != 0) {
    return (initialByte - 256);
  }
  return initialByte;
}

double normalize(int value) {
  // Assuming your input range is from -128 to 127
  double minRange = -128.0;
  double maxRange = 127.0;

  // Normalize the value between -1 and 1
  return (value - minRange) / (maxRange - minRange) * 2 - 1;
}

List<ModelVertex> readFullSphere() {
  List<ModelVertex> verts = [];
  final bytesList = Uint8List.fromList(spherePositions);
  for (int i = 0; i < bytesList.length; i += 12) {
    final vertData = ByteData.sublistView(bytesList, i, i + 12);
    verts.add(ModelVertex(
      Vector3(
        vertData.getFloat32(0, Endian.little),
        vertData.getFloat32(4, Endian.little),
        vertData.getFloat32(8, Endian.little),
      ),
      box: BoundingBox.zero(),
      positionOffset: Vector3.zero(),
    ));
  }
  assert(verts.length == 511);
  return verts;
}

Vector3 readFromSphere(int vertIndice, [reversed = false]) {
  assert(vertIndice < 511 && vertIndice >= 0);
  final byteList = reversed
      ? ByteData.sublistView(spherePositions, 3 * 4 * (512 - vertIndice - 1),
          3 * 4 * (512 - vertIndice))
      : ByteData.sublistView(
          spherePositions, 3 * 4 * vertIndice, 3 * 4 * (vertIndice + 1));
  final vertData = Vector3(
    byteList.getFloat32(0, Endian.little),
    byteList.getFloat32(4, Endian.little),
    byteList.getFloat32(8, Endian.little),
  );
  return vertData;
}

  // final List<Vertex> points = [
  //   Vertex(positions: Vector3(-1, 1, -1)), // front top left 0
  //   Vertex(positions: Vector3(-1, -1, -1)), // front bottom left 1
  //   Vertex(positions: Vector3(1, 1, -1)), // front top right 2
  //   Vertex(positions: Vector3(1, -1, -1)), // front bottom right 3
  //   Vertex(positions: Vector3(-1, 1, 1)), // back top left 4
  //   Vertex(positions: Vector3(-1, -1, 1)), // back bottom left 5
  //   Vertex(positions: Vector3(1, 1, 1)), // back top right 6
  //   Vertex(positions: Vector3(1, -1, 1)), // back bottom right 7
  // ];

  // final triangleIndices = Uint16List.fromList([
  //   0, 1, 2, 1, 2, 3, //front face
  //   4, 5, 6, 5, 6, 7, // back face
  //   0, 2, 4, 4, 6, 2, // top face
  //   3, 1, 5, 5, 7, 3, // bottom face
  //   3, 2, 7, 7, 6, 2, // right face
  //   0, 1, 5, 5, 4, 0 // left face
  // ]);