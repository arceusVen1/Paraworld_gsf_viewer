import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:paraworld_gsf_viewer/classes/bouding_box.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/chunk_attributes.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/model_settings.dart';
import 'package:paraworld_gsf_viewer/classes/mesh.dart';
import 'package:paraworld_gsf_viewer/classes/rotation.dart';
import 'package:paraworld_gsf_viewer/classes/texture.dart';
import 'dart:math' as math;

typedef ProjectionData = ({
  double widthOffset,
  double heightOffset,
  double maxFactor
});

class Model {
  Model({
    required this.type,
    required this.name,
    required this.meshes,
    required this.cloth,
    required this.boundingBox,
  });

  final ModelType type;
  final String name;
  final List<ModelMesh> meshes;
  final List<ModelMesh> cloth;
  final BoundingBoxModel boundingBox;
  // todo skeleton
  // todo position links
  //final Vector3 scale;

  final Paint _paint = Paint()
    ..color = Colors.black
    ..strokeWidth = 1
    ..strokeCap = StrokeCap.round;

  Future<void> loadTextures(Color fillingColor, Color? partyColor) async {
    for (final mesh in meshes + cloth) {
      for (final submesh in mesh.submeshes) {
        if (submesh.texture != null) {
          await submesh.texture!.loadImage(fillingColor, partyColor);
        }
      }
    }
  }

  ProjectionData getProjectionData(Size size) {
    final widthOffset = size.width / 2;
    final heightOffset = size.height / 2;
    final maxCoord = boundingBox.maxOfCoordinates;

    final maxFactor =
        math.min(widthOffset * 1 / maxCoord, heightOffset * 1 / maxCoord);

    return (
      widthOffset: widthOffset,
      heightOffset: heightOffset,
      maxFactor: maxFactor,
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
      ;
      canvas.drawLine(p1, p2, customPaint ?? _paint);
      canvas.drawLine(p2, p3, customPaint ?? _paint);
      canvas.drawLine(p3, p1, customPaint ?? _paint);
    }
  }

  void draw(
    Rotation rotation,
    Size size,
    Canvas canvas,
    Color meshColor,
    ChunkAttributes attributesFilter, {
    ModelTexture? overrideTexture,
    bool showNormals = false,
    bool showCloths = false,
    bool showTexture = false,
  }) {
    final projectionData = getProjectionData(size);
    for (final mesh in (showCloths ? meshes + cloth : meshes)) {
      if (!mesh.canBeViewed(attributesFilter)) {
        continue;
      }
      // reversing submesh seems to help with rendering order
      for (final submesh in mesh.submeshes.reversed) {
        final data = submesh.getDrawingData(
          rotation,
          size,
          projectionData: projectionData,
          overrideTexture: overrideTexture,
        );
        if (showNormals) {
          canvas.drawRawPoints(
            PointMode.lines,
            data.normals,
            _paint..color = Colors.red,
          );
        }
        if (!showTexture || (overrideTexture == null && data.texture == null)) {
          drawTrianglesOutside(canvas, data.triangleIndices, data.positions,
              _paint..color = meshColor);
        }

        final texturePainter = showTexture
            ? overrideTexture?.painter ?? data.texture?.painter
            : null;

        canvas.drawVertices(
            Vertices.raw(
              VertexMode.triangles,
              data.positions,
              indices: data.triangleIndices,
              // colors: Int32List.fromList(List.filled(
              //     (data.positions.length / 2).round(),
              //     meshColor.withOpacity(0.3).value)),
              textureCoordinates: data.textureCoordinates,
            ),
            BlendMode.srcOver,
            texturePainter ?? (_paint..color = meshColor.withOpacity(0.3)));
      }
    }
  }
}
