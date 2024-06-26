import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:paraworld_gsf_viewer/classes/bouding_box.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/chunk_attributes.dart';
import 'package:paraworld_gsf_viewer/classes/model.dart';
import 'package:paraworld_gsf_viewer/classes/rotation.dart';
import 'package:paraworld_gsf_viewer/classes/vertex.dart';
import 'package:paraworld_gsf_viewer/theme.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/mouse_movement_notifier.dart';
import 'dart:math' as math;

import 'package:vector_math/vector_math.dart';

class ModelDrawer extends CustomPainter {
  ModelDrawer({
    required this.mousePosition,
    required this.model,
    required this.overridingTexture,
    required this.showNormals,
    required this.showTexture,
    required this.meshColor,
    required this.attributesFilter,
    required this.showCloth,
    required this.showSkeleton,
    required this.showLinks,
    required this.showCollisionVolumes,
  }) : super(repaint: mousePosition);

  final ValueNotifier<MouseEventData> mousePosition;
  final Model model;
  final ui.Image? overridingTexture;
  final bool showNormals;
  final bool showTexture;
  final Color meshColor;
  final ChunkAttributes attributesFilter;
  final bool showCloth;
  final bool showSkeleton;
  final bool showLinks;
  final bool showCollisionVolumes;

  final Transformation transformation = Transformation();

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
          transformation: transformation,
        )
        .pointProjection;

    final xPointData = xPoint
        .project(
          widthOffset: projectionData.widthOffset,
          heightOffset: projectionData.heightOffset,
          maxWidth: projectionData.maxFactor,
          maxHeight: projectionData.maxFactor,
          transformation: transformation,
        )
        .pointProjection;

    final yPointData = yPoint
        .project(
          widthOffset: projectionData.widthOffset,
          heightOffset: projectionData.heightOffset,
          maxWidth: projectionData.maxFactor,
          maxHeight: projectionData.maxFactor,
          transformation: transformation,
        )
        .pointProjection;

    final zPointData = zPoint
        .project(
          widthOffset: projectionData.widthOffset,
          heightOffset: projectionData.heightOffset,
          maxWidth: projectionData.maxFactor,
          maxHeight: projectionData.maxFactor,
          transformation: transformation,
        )
        .pointProjection;

    canvas.drawRawPoints(
      ui.PointMode.lines,
      Float32List.fromList([
        originData.x,
        originData.y,
        xPointData.x,
        xPointData.y,
      ]),
      _paintSecondary,
    );

    canvas.drawRawPoints(
      ui.PointMode.lines,
      Float32List.fromList([
        originData.x,
        originData.y,
        yPointData.x,
        yPointData.y,
      ]),
      _paintHighlight,
    );

    canvas.drawRawPoints(
      ui.PointMode.lines,
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
    final rotationMouseData = mousePosition.value.mousePositionPrimary;
    final zRotationAngle =
        (rotationMouseData.pos.dx + rotationMouseData.lastX) *
            2 *
            math.pi /
            size.width;

    final xRotationAngle =
        (rotationMouseData.pos.dy + rotationMouseData.lastY) *
            2 *
            math.pi /
            size.height;
    final boxMax = model.boundingBox.maxOfCoordinates;
    final translationMouseData = mousePosition.value.mousePositionSecondary;
    final xTranslation =
        (translationMouseData.pos.dx + translationMouseData.lastX) /
            size.width *
            boxMax;
    final zTranslation =
        -(translationMouseData.pos.dy + translationMouseData.lastY) /
            size.height *
            boxMax;
    transformation.setTranslation(xTranslation, zTranslation);
    transformation.setQuaternion(xRotationAngle, 0, zRotationAngle);
    transformation.scaleFactor = mousePosition.value.zoom;
    transformation.composeMatrix();

    model.draw(
      transformation,
      size,
      canvas,
      meshColor,
      attributesFilter,
      overrideTexture: overridingTexture,
      showNormals: showNormals,
      showCloths: showCloth,
      showTexture: showTexture,
    );
    if (showCollisionVolumes) {
      model.drawCollisions(transformation, size, canvas);
    }
    if (showSkeleton) {
      model.drawSkeleton(
        transformation,
        size,
        canvas,
        meshColor,
      );
    }
    if (showLinks) {
      model.drawPositionLinks(
        transformation,
        size,
        canvas,
      );
    }
    drawAxis(size, canvas);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
