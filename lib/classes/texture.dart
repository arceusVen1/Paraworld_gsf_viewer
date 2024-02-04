import 'dart:ui';

import 'package:vector_math/vector_math_64.dart';

class ModelTexture {
  ModelTexture(
    this.image,
  );

  final Image image;
  Paint? painter;

  Paint getPainter() {
    if (painter != null) {
      return painter!;
    }
    painter = Paint()..blendMode = BlendMode.srcOver;
    painter!.shader = ImageShader(
      image,
      TileMode.decal,
      TileMode.decal,
      Matrix4.identity().storage,
    );
    return painter!;
  }
}
