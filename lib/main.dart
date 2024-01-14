import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:paraworld_gsf_viewer/classes/vertex.dart';
import 'package:vector_math/vector_math_64.dart';

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
      home: Viewer(),
    );
  }
}

typedef MousePositionDrag = ({
  Offset pos,
  double lastX,
  double lastY,
  double zoom
});

class Viewer extends StatelessWidget {
  const Viewer({super.key});

  @override
  Widget build(BuildContext context) {
    final mousePosNotifier = ValueNotifier<MousePositionDrag>(
        (pos: const Offset(0, 0), lastX: 0, lastY: 0, zoom: 1));
    double lastX = 0;
    double lastY = 0;
    double refX = 0;
    double refY = 0;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(50),
        child: Listener(
          onPointerUp: (event) {
            mousePosNotifier.value = (
              pos: Offset(event.position.dx - refX, event.position.dy - refY),
              lastX: lastX,
              lastY: lastY,
              zoom: mousePosNotifier.value.zoom
            );
            lastX = event.position.dx - refX + lastX;
            lastY = event.position.dy - refY + lastY;
          },
          onPointerDown: (event) {
            if (event.buttons == kPrimaryMouseButton) {
              refX = event.position.dx;
              refY = event.position.dy;
              mousePosNotifier.value = (
                pos: const Offset(0, 0),
                lastX: lastX,
                lastY: lastY,
                zoom: mousePosNotifier.value.zoom
              );
            }
          },
          onPointerMove: (event) {
            if (event.buttons == kPrimaryMouseButton) {
              mousePosNotifier.value = (
                pos: Offset(event.position.dx - refX, event.position.dy - refY),
                lastX: lastX,
                lastY: lastY,
                zoom: mousePosNotifier.value.zoom
              );
            }
          },
          onPointerSignal: (event) {
            if (event is PointerScrollEvent) {
              mousePosNotifier.value = (
                pos: mousePosNotifier.value.pos,
                lastX: mousePosNotifier.value.lastX,
                lastY: mousePosNotifier.value.lastY,
                zoom: event.scrollDelta.dy.abs() /
                    MediaQuery.of(context).size.height,
              );
            }
          },
          child: CustomPaint(
            painter: Drawer(
              mousePosition: mousePosNotifier,
            ),
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );
  }
}

class Drawer extends CustomPainter {
  Drawer({
    required this.mousePosition,
  }) : super(repaint: mousePosition);

  final ValueNotifier<MousePositionDrag> mousePosition;

  final Paint _paint = Paint()
    ..color = const Color.fromRGBO(0, 0, 0, 1)
    ..strokeWidth = 6
    ..strokeCap = StrokeCap.round;

  Float32List pointsToCanvasPosition(
    List<Vertex> points,
    double widthOffset,
    double heightOffset,
    double maxHeight,
    double maxWidth,
    double yRotationAngle,
    double zRotationAngle,
  ) {
    return Float32List.fromList(points
        .map((vertex) {
          final projection = vertex.project(
            widthOffset: widthOffset,
            heightOffset: heightOffset,
            maxHeight: maxHeight,
            maxWidth: maxWidth,
            yRotation: yRotationAngle,
            zRotation: zRotationAngle,
          );
          return [projection.x, projection.y];
        })
        .expand((element) => element)
        .toList());
  }

  final List<Vertex> points = [
    Vertex(positions: Vector3(-1, 1, -1)), // front top left 0
    Vertex(positions: Vector3(-1, -1, -1)), // front bottom left 1
    Vertex(positions: Vector3(1, 1, -1)), // front top right 2
    Vertex(positions: Vector3(1, -1, -1)), // front bottom right 3
    Vertex(positions: Vector3(-1, 1, 1)), // back top left 4
    Vertex(positions: Vector3(-1, -1, 1)), // back bottom left 5
    Vertex(positions: Vector3(1, 1, 1)), // back top right 6
    Vertex(positions: Vector3(1, -1, 1)), // back bottom right 7
  ];

  void drawTrianglesOutside(
      Canvas canvas, Uint16List indices, Float32List positions) {
    for (int i = 0; i < indices.length; i += 3) {
      final p1 =
          Offset(positions[indices[i] * 2], positions[indices[i] * 2 + 1]);
      final p2 = Offset(
          positions[indices[i + 1] * 2], positions[indices[i + 1] * 2 + 1]);
      final p3 = Offset(
          positions[indices[i + 2] * 2], positions[indices[(i + 2)] * 2 + 1]);

      canvas.drawLine(p1, p2, _paint);
      canvas.drawLine(p2, p3, _paint);
      canvas.drawLine(p3, p1, _paint);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final widthOffset = size.width / 2;
    final heightOffset = size.height / 2;
    final yRotationAngle =
        (mousePosition.value.pos.dx + mousePosition.value.lastX) *
            pi /
            size.width;
    final zRotationAngle =
        (mousePosition.value.pos.dy + mousePosition.value.lastY) *
            pi /
            size.height;

    final Float32List positions = pointsToCanvasPosition(
      points,
      widthOffset,
      heightOffset,
      size.height / 3,
      size.width / 3,
      yRotationAngle,
      zRotationAngle,
    );

    final triangleIndices = Uint16List.fromList([
      0, 1, 2, 1, 2, 3, //front face
      4, 5, 6, 5, 6, 7, // back face
      0, 2, 4, 4, 6, 2, // top face
      3, 1, 5, 5, 7, 3, // bottom face
      3, 2, 7, 7, 6, 2, // right face
      0, 1, 5, 5, 4, 0 // left face
    ]);
    final colors = Int32List.fromList(List.filled(
        (positions.length / 2).round(),
        const Color.fromRGBO(0, 0, 0, 0.3).value));

    //canvas.drawRawPoints(PointMode.points, positions, _paint);
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
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    print("shouldRepaint");
    return true;
  }
}
