import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:paraworld_gsf_viewer/classes/bouding_box.dart';
import 'package:paraworld_gsf_viewer/classes/triangle.dart';
import 'package:paraworld_gsf_viewer/classes/vertex.dart';
import 'package:paraworld_gsf_viewer/test.dart';
import 'package:paraworld_gsf_viewer/widgets/convert_to_obj_cta.dart';
import 'package:paraworld_gsf_viewer/widgets/mouse_movement_notifier.dart';
import 'dart:math' as math;

import 'package:vector_math/vector_math_64.dart' as vector;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const Viewer(),
    );
  }
}

class Viewer extends StatelessWidget {
  const Viewer({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Vertex> vertices = [];
    final byteArray = convertToByteArray(verticesTest);
    for (int i = 0; i < byteArray.length; i += 16) {
      final vertexValue = int.parse(
          byteArray[i + 5] +
              byteArray[i + 4] +
              byteArray[i + 3] +
              byteArray[i + 2] +
              byteArray[i + 1] +
              byteArray[i],
          radix: 16);
      final vert = Vertex.fromModelBytes(
        vertexValue,
        //BoundingBox.zero(),
        BoundingBox(
          x: (min: -0.565, max: 1.130),
          y: (min: -0.993, max: 1.982),
          z: (min: -0.179, max: 0.441),
        ),
      );
      vertices.add(vert);
    }

    final List<ModelTriangle> triangles = [];
    final triangleByteArray = convertToByteArray(trianglesTest);
    for (int i = 0; i < triangleByteArray.length; i += 6) {
      final List<int> indices = [];

      indices.add(int.parse(triangleByteArray[i + 1] + triangleByteArray[i],
          radix: 16));
      indices.add(int.parse(triangleByteArray[i + 3] + triangleByteArray[i + 2],
          radix: 16));
      indices.add(int.parse(triangleByteArray[i + 5] + triangleByteArray[i + 4],
          radix: 16));
      triangles.add(ModelTriangle(indices: indices, points: [
        vertices[indices[0]],
        vertices[indices[1]],
        vertices[indices[2]],
      ]));
    }

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(50),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 5 / 6,
              width: MediaQuery.of(context).size.width,
              child: MouseMovementNotifier(
                mouseListener: (mouseNotifier) => CustomPaint(
                  painter: Drawer(
                    mousePosition: mouseNotifier,
                    vertices: vertices,
                    triangles: triangles,
                  ),
                  child: const SizedBox.expand(),
                ),
              ),
            ),
            ConvertToObjCta(
              vertices: vertices,
              triangles: triangles,
            ),
          ],
        ),
      ),
    );
  }
}

class Drawer extends CustomPainter {
  Drawer({
    required this.mousePosition,
    required this.vertices,
    required this.triangles,
  }) : super(repaint: mousePosition);

  final ValueNotifier<MousePositionDrag> mousePosition;
  final List<Vertex> vertices;
  final List<ModelTriangle> triangles;

  final Paint _paint = Paint()
    ..color = const Color.fromRGBO(0, 0, 0, 1)
    ..strokeWidth = 2
    ..strokeCap = StrokeCap.round;

  final Paint _paintTest = Paint()
    ..color = Color.fromARGB(255, 255, 0, 0)
    ..strokeWidth = 3
    ..strokeCap = StrokeCap.round;

  final Paint _paintHighlight = Paint()
    ..color = Color.fromARGB(255, 30, 255, 0)
    ..strokeWidth = 8
    ..strokeCap = StrokeCap.round;

  final List<Color> colorSet = List.filled(12, Color.fromARGB(0, 0, 0, 0))
      .map((_) => Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
          .withOpacity(1.0))
      .toList();

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
    canvas.drawRawPoints(
      PointMode.lines,
      Float32List.fromList(normals),
      _paintTest,
    );

    drawTrianglesOutside(canvas, triangleIndices, positions);
    canvas.drawVertices(
        Vertices.raw(
          VertexMode.triangles,
          positions,
          colors: colors,
          indices: triangleIndices,
        ),
        BlendMode.dst,
        _paint);
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
    print("shouldRepaint");
    return true;
  }
}
