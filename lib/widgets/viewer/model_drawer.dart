import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:paraworld_gsf_viewer/classes/model.dart';
import 'package:paraworld_gsf_viewer/classes/rotation.dart';
import 'package:paraworld_gsf_viewer/classes/texture.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/mouse_movement_notifier.dart';
import 'dart:math' as math;

class ModelDrawer extends CustomPainter {
  ModelDrawer({
    required this.mousePosition,
    required this.model,
    required this.texture,
    required this.showNormals,
  }) : super(repaint: mousePosition);

  final ValueNotifier<MousePositionDrag> mousePosition;
  final Model model;
  final ModelTexture? texture;
  final bool showNormals;

  final Rotation rotation = Rotation();

  final Paint _paint = Paint()
    ..color = const Color.fromRGBO(0, 0, 0, 1)
    ..strokeWidth = 2
    ..strokeCap = StrokeCap.round;

  final Paint _paintTest = Paint()
    ..color = const Color.fromARGB(255, 255, 0, 0)
    ..strokeWidth = 1
    ..strokeCap = StrokeCap.round;

  // final Paint _paintHighlight = Paint()
  //   ..color = const Color.fromARGB(255, 30, 255, 0)
  //   ..strokeWidth = 8
  //   ..strokeCap = StrokeCap.round;

  void drawTrianglesOutside(
      Canvas canvas, Uint16List indices, Float32List positions,
      [Paint? customPaint]) {
    for (int i = 0; i < indices.length; i += 3) {
      final p1 =
          Offset(positions[indices[i] * 2], positions[indices[i] * 2 + 1]);
      final p2 = Offset(
          positions[indices[i + 1] * 2], positions[indices[i + 1] * 2 + 1]);
      final p3 = Offset(
          positions[indices[i + 2] * 2], positions[indices[(i + 2)] * 2 + 1]);

      canvas.drawLine(p1, p2, customPaint ?? _paint);
      canvas.drawLine(p2, p3, customPaint ?? _paint);
      canvas.drawLine(p3, p1, customPaint ?? _paint);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final yRotationAngle =
        (mousePosition.value.pos.dx + mousePosition.value.lastX) *
            2 *
            math.pi /
            size.width;

    final zRotationAngle =
        (mousePosition.value.pos.dy + mousePosition.value.lastY) *
            2 *
            math.pi /
            size.height;
    rotation.setMatrix(0, yRotationAngle, zRotationAngle);

    final data = model.getDrawingData(
      rotation,
      size,
      texture: texture,
      showNormals: showNormals,
    );

    final colors = Int32List.fromList(List.filled(
        (data.positions.length / 2).round(),
        const Color.fromRGBO(0, 0, 0, 0.3).value));

    //canvas.drawRawPoints(PointMode.points, positions.lenght, _paint);
    if (showNormals) {
      canvas.drawRawPoints(
        PointMode.lines,
        data.normals,
        _paintTest,
      );
    }

    if (texture == null) {
      drawTrianglesOutside(canvas, data.triangleIndices, data.positions);
    }

    canvas.drawVertices(
        Vertices.raw(
          VertexMode.triangles,
          data.positions,
          indices: data.triangleIndices,
          colors: colors,
          textureCoordinates: data.textureCoordinates,
        ),
        BlendMode.srcOver,
        texture?.painter ?? _paint);

    // final viewPoint =
    //     Vertex(vector.Vector3.all(0), box: BoundingBox.zero()).project(
    //   widthOffset: widthOffset,
    //   heightOffset: heightOffset,
    //   maxWidth: maxWidth,
    //   maxHeight: maxHeight,
    //   xRotation: yRotationAngle,
    //   zRotation: zRotationAngle,
    // );

    // a center point for reference
    // canvas.drawRawPoints(
    //     PointMode.points,
    //     Float32List.fromList(
    //         [viewPoint.pointProjection.x, viewPoint.pointProjection.y]),
    //     _paintHighlight);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
