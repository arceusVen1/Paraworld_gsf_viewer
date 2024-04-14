import 'dart:ui';

import 'package:vector_math/vector_math_64.dart';

class ModelTexture {
  ModelTexture(
    this.image,
  ) {
    painter.shader = ImageShader(
      image,
      TileMode.decal,
      TileMode.decal,
      Matrix4.identity().storage,
    );
  }

  final Image image;
  final Paint painter = Paint()
    ..blendMode = BlendMode.srcOver
    ..color = Color(0xFFFFFFFF).withOpacity(0.8);
}
