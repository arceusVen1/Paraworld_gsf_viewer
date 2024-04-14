import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:paraworld_gsf_viewer/classes/bouding_box.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/chunk_attributes.dart';
import 'package:paraworld_gsf_viewer/classes/model.dart';
import 'package:paraworld_gsf_viewer/classes/rotation.dart';
import 'package:paraworld_gsf_viewer/classes/texture.dart';
import 'package:paraworld_gsf_viewer/classes/vertex.dart';
import 'package:paraworld_gsf_viewer/theme.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/mouse_movement_notifier.dart';
import 'dart:math' as math;

import 'package:vector_math/vector_math.dart';

class ModelDrawer extends CustomPainter {
  ModelDrawer({
    required this.mousePosition,
    required this.model,
    required this.texture,
    required this.showNormals,
    required this.meshColor,
    required this.attributesFilter,
    required this.showCloth,
  }) : super(repaint: mousePosition);

  final ValueNotifier<MousePositionDrag> mousePosition;
  final Model model;
  final ModelTexture? texture;
  final bool showNormals;
  final Color meshColor;
  final ChunkAttributes attributesFilter;
  final bool showCloth;

  final Rotation rotation = Rotation();

  final Paint _paintHighlight = Paint()
    ..color = const Color.fromARGB(255, 30, 255, 0)
    ..strokeWidth = 2
    ..strokeCap = StrokeCap.round;

  final Paint _paintPrimary = Paint()
    ..color = kBlueColor
    ..strokeWidth = 2
    ..strokeCap = StrokeCap.round;

  final Paint _paintSecondary = Paint()
    ..color = kRedColor
    ..strokeWidth = 2
    ..strokeCap = StrokeCap.round;

  final origin = ModelVertex(
    Vector3.zero(),
    box: BoundingBoxModel.zero(),
    positionOffset: Vector3.zero(),
  );

  final xPoint = ModelVertex(
    Vector3(1, 0, 0),
    box: BoundingBoxModel.zero(),
    positionOffset: Vector3.zero(),
  );

  final yPoint = ModelVertex(
    Vector3(0, 1, 0),
    box: BoundingBoxModel.zero(),
    positionOffset: Vector3.zero(),
  );

  final zPoint = ModelVertex(
    Vector3(0, 0, 1),
    box: BoundingBoxModel.zero(),
    positionOffset: Vector3.zero(),
  );

  void drawAxis(Size size, Canvas canvas) {
    final projectionData = model.getProjectionData(size);

    final originData = origin
        .project(
          widthOffset: projectionData.widthOffset,
          heightOffset: projectionData.heightOffset,
          maxWidth: projectionData.maxFactor,
          maxHeight: projectionData.maxFactor,
          rotation: rotation,
        )
        .pointProjection;

    final xPointData = xPoint
        .project(
          widthOffset: projectionData.widthOffset,
          heightOffset: projectionData.heightOffset,
          maxWidth: projectionData.maxFactor,
          maxHeight: projectionData.maxFactor,
          rotation: rotation,
        )
        .pointProjection;

    final yPointData = yPoint
        .project(
          widthOffset: projectionData.widthOffset,
          heightOffset: projectionData.heightOffset,
          maxWidth: projectionData.maxFactor,
          maxHeight: projectionData.maxFactor,
          rotation: rotation,
        )
        .pointProjection;

    final zPointData = zPoint
        .project(
          widthOffset: projectionData.widthOffset,
          heightOffset: projectionData.heightOffset,
          maxWidth: projectionData.maxFactor,
          maxHeight: projectionData.maxFactor,
          rotation: rotation,
        )
        .pointProjection;

    canvas.drawRawPoints(
      PointMode.lines,
      Float32List.fromList([
        originData.x,
        originData.y,
        xPointData.x,
        xPointData.y,
      ]),
      _paintSecondary,
    );

    canvas.drawRawPoints(
      PointMode.lines,
      Float32List.fromList([
        originData.x,
        originData.y,
        yPointData.x,
        yPointData.y,
      ]),
      _paintHighlight,
    );

    canvas.drawRawPoints(
      PointMode.lines,
      Float32List.fromList([
        originData.x,
        originData.y,
        zPointData.x,
        zPointData.y,
      ]),
      _paintPrimary,
    );
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

    model.draw(
      rotation,
      size,
      canvas,
      meshColor,
      attributesFilter,
      overrideTexture: texture,
      showNormals: showNormals,
      showCloths: showCloth,
    );

    drawAxis(size, canvas);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
