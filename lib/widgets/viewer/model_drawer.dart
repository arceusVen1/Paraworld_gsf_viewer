import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:paraworld_gsf_viewer/classes/bouding_box.dart';
import 'package:paraworld_gsf_viewer/classes/texture.dart';
import 'package:paraworld_gsf_viewer/classes/triangle.dart';
import 'package:paraworld_gsf_viewer/classes/vertex.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/mouse_movement_notifier.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'dart:math' as math;

class ModelDrawer extends CustomPainter {
  ModelDrawer({
    required this.mousePosition,
    required this.vertices,
    required this.triangles,
    required this.texture,
    required this.showNormals,
  }) : super(repaint: mousePosition);

  final ValueNotifier<MousePositionDrag> mousePosition;
  final List<Vertex> vertices;
  final List<ModelTriangle> triangles;
  final ModelTexture? texture;
  final bool showNormals;

  final Paint _paint = Paint()
    ..color = const Color.fromRGBO(0, 0, 0, 1)
    ..strokeWidth = 2
    ..strokeCap = StrokeCap.round;

  final Paint _paintTest = Paint()
    ..color = const Color.fromARGB(255, 255, 0, 0)
    ..strokeWidth = 1
    ..strokeCap = StrokeCap.round;

  final Paint _paintHighlight = Paint()
    ..color = const Color.fromARGB(255, 30, 255, 0)
    ..strokeWidth = 8
    ..strokeCap = StrokeCap.round;

  (Float32List, Float32List) pointsToCanvasPosition(
    List<Vertex> points,
    double widthOffset,
    double heightOffset,
    double maxHeight,
    double maxWidth,
    double yRotationAngle,
    double zRotationAngle,
  ) {
    final List<double> pointsPositions = [];
    final List<double> normalPositions = [];
    for (final point in points) {
      final projection = point.project(
        widthOffset: widthOffset,
        heightOffset: heightOffset,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        yRotation: yRotationAngle,
        zRotation: zRotationAngle,
      );
      pointsPositions
          .addAll([projection.pointProjection.x, projection.pointProjection.y]);
      if (projection.normalProjection != null) {
        normalPositions.addAll(
            [projection.normalProjection!.x, projection.normalProjection!.y]);
      }
    }

    return (
      Float32List.fromList(pointsPositions),
      Float32List.fromList(normalPositions)
    );
  }

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
    final widthOffset = size.width / 2;
    final heightOffset = size.height / 2;
    final maxHeight = math.min(size.width, size.height) / 6,
        maxWidth = math.min(size.width, size.height) / 6;
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

    final Float32List positions =
        Float32List.fromList(List<double>.filled(vertices.length * 2, 0));
    final Float32List textureCoordinates =
        Float32List.fromList(List<double>.filled(vertices.length * 2, 0));
    final List<double> normals = [];
    final List<int> indices = [];
    for (final triangle in triangles) {
      final shouldShow = triangle.shouldShowTriangle(
        yRotation: yRotationAngle,
        zRotation: zRotationAngle,
      );

      for (int j = 0; j < triangle.points.length; j++) {
        final vertexIndice = triangle.indices[j];
        if (shouldShow) indices.add(vertexIndice);

        if (positions[vertexIndice * 2] != 0) continue;

        if (shouldShow) {
          if (texture != null) {
            textureCoordinates[vertexIndice * 2] =
                (triangle.points[j].textureCoordinates!.x) *
                    texture!.image.width;
            textureCoordinates[vertexIndice * 2 + 1] =
                (1 - triangle.points[j].textureCoordinates!.y) *
                    texture!.image.height;
          }

          final projected = triangle.points[j].project(
            widthOffset: widthOffset,
            heightOffset: heightOffset,
            maxWidth: maxWidth,
            maxHeight: maxHeight,
            yRotation: yRotationAngle,
            zRotation: zRotationAngle,
          );
          normals.addAll([
            projected.pointProjection.x,
            projected.pointProjection.y,
            projected.normalProjection!.x,
            projected.normalProjection!.y,
          ]);

          positions[vertexIndice * 2] = projected.pointProjection.x;
          positions[vertexIndice * 2 + 1] = projected.pointProjection.y;
        } else {
          positions[vertexIndice * 2] = 0;
          positions[vertexIndice * 2 + 1] = 0;
        }
      }
    }

    final colors = Int32List.fromList(List.filled(
        (positions.length / 2).round(),
        const Color.fromRGBO(0, 0, 0, 0.3).value));

    final triangleIndices = Uint16List.fromList(indices);

    //canvas.drawRawPoints(PointMode.points, positions.lenght, _paint);
    if (showNormals) {
      canvas.drawRawPoints(
        PointMode.lines,
        Float32List.fromList(normals),
        _paintTest,
      );
    }

    if (texture == null) {
      drawTrianglesOutside(canvas, triangleIndices, positions);
    }

    canvas.drawVertices(
        Vertices.raw(
          VertexMode.triangles,
          positions,
          indices: triangleIndices,
          colors: colors,
          textureCoordinates: textureCoordinates,
        ),
        BlendMode.srcOver,
        texture?.getPainter() ?? _paint);

    final viewPoint =
        Vertex(vector.Vector3.all(0), box: BoundingBox.zero()).project(
      widthOffset: widthOffset,
      heightOffset: heightOffset,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      xRotation: yRotationAngle,
      zRotation: zRotationAngle,
    );

    // a center point for reference
    canvas.drawRawPoints(
        PointMode.points,
        Float32List.fromList(
            [viewPoint.pointProjection.x, viewPoint.pointProjection.y]),
        _paintHighlight);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
