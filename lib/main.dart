import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:paraworld_gsf_viewer/classes/bouding_box.dart';
import 'package:paraworld_gsf_viewer/classes/vertex.dart';
import 'package:paraworld_gsf_viewer/test.dart';
import 'package:paraworld_gsf_viewer/widgets/mouse_movement_notifier.dart';
import 'dart:math' as math;

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
        BoundingBox(
          x: (min: -0.565, max: 1.130),
          y: (min: -0.993, max: 1.982),
          z: (min: -0.179, max: 0.441),
        ),
      );
      vertices.add(vert);
      //print("vert ${i / 16} ${vert.toString()}");
    }

    final List<int> indices = [];
    final triangleByteArray = convertToByteArray(trianglesTest);
    //print("triangles $triangleByteArray");
    for (int i = 0; i < triangleByteArray.length; i += 6) {
      indices.add(int.parse(triangleByteArray[i + 1] + triangleByteArray[i],
          radix: 16));
      indices.add(int.parse(triangleByteArray[i + 3] + triangleByteArray[i + 2],
          radix: 16));
      indices.add(int.parse(triangleByteArray[i + 5] + triangleByteArray[i + 4],
          radix: 16));
    }
    final mousePosNotifier = ValueNotifier<MousePositionDrag>(
        (pos: const Offset(0, 0), lastX: 0, lastY: 0, zoom: 1));
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(50),
        child: MouseMovementNotifier(
          mousePosNotifier: mousePosNotifier,
          child: CustomPaint(
            painter: Drawer(
              mousePosition: mousePosNotifier,
              vertices: vertices,
              indices: indices,
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
    required this.vertices,
    required this.indices,
  }) : super(repaint: mousePosition);

  final ValueNotifier<MousePositionDrag> mousePosition;
  final List<Vertex> vertices;
  final List<int> indices;

  final Paint _paint = Paint()
    ..color = const Color.fromRGBO(0, 0, 0, 1)
    ..strokeWidth = 2
    ..strokeCap = StrokeCap.round;

  final Paint _paintTest = Paint()
    ..color = Color.fromARGB(255, 255, 0, 0)
    ..strokeWidth = 3
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

  ({
    Vertex centerPoint,
    Float32List testPosition,
  }) getTestPoints({
    required int testIndice,
    required Float32List verticesPositions,
  }) {
    final testPoint = Float32List.sublistView(
        verticesPositions, testIndice * 2, testIndice * 2 + 2);
    return (
      centerPoint: vertices[testIndice],
      testPosition: testPoint,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final widthOffset = size.width / 2;
    final heightOffset = size.height / 2;
    final yRotationAngle =
        (mousePosition.value.pos.dx + mousePosition.value.lastX) *
            math.pi /
            size.width;

    final zRotationAngle =
        (mousePosition.value.pos.dy + mousePosition.value.lastY) *
            math.pi /
            size.height;

    final positions = pointsToCanvasPosition(
      vertices,
      widthOffset,
      heightOffset,
      math.min(size.width, size.height) / 6,
      math.min(size.width, size.height) / 6,
      yRotationAngle,
      zRotationAngle,
    );

    final colors = Int32List.fromList(List.filled(
        (positions.$1.length / 2).round(),
        const Color.fromRGBO(0, 0, 0, 0.3).value));

    final triangleIndices = Uint16List.fromList(indices);

    canvas.drawRawPoints(PointMode.points, positions.$1, _paint);
    for (int i = 0; i < vertices.length; i++) {
      final List<double> normal = [
        ...positions.$1.sublist(i * 2, (i + 1) * 2),
        ...positions.$2.sublist(i * 2, (i + 1) * 2)
      ];
      canvas.drawRawPoints(
          PointMode.lines, Float32List.fromList(normal), _paintTest);
    }
    drawTrianglesOutside(canvas, triangleIndices, positions.$1);
    canvas.drawVertices(
        Vertices.raw(
          VertexMode.triangles,
          positions.$1,
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
