import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:paraworld_gsf_viewer/classes/bouding_box.dart';
import 'package:paraworld_gsf_viewer/classes/rotation.dart';
import 'package:paraworld_gsf_viewer/classes/texture.dart';
import 'package:paraworld_gsf_viewer/classes/triangle.dart';
import 'package:paraworld_gsf_viewer/classes/vertex.dart';
import 'dart:math' as math;

typedef ModelMesh = ({
  List<ModelVertex> vertices,
  List<ModelTriangle> triangles
});

class Model {
  Model({
    required this.meshes,
    required this.boundingBox,
  });

  final List<ModelMesh> meshes;
  final BoundingBoxModel boundingBox;
  //final Vector3 scale;

  ({double widthOffset, double heightOffset, double maxFactor})
      getProjectionData(Size size) {
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

  ({
    Float32List positions,
    Float32List textureCoordinates,
    Uint16List triangleIndices,
    Float32List normals,
  }) getDrawingData(
    Rotation rotation,
    Size size, {
    ModelTexture? texture,
    bool showNormals = false,
  }) {
    final projectionData = getProjectionData(size);
    final verticesLength = meshes.fold<int>(
        0, (previousValue, element) => previousValue + element.vertices.length);

    final Float32List positions =
        Float32List.fromList(List<double>.filled(verticesLength * 2, 0));
    final Float32List textureCoordinates =
        Float32List.fromList(List<double>.filled(verticesLength * 2, 0));
    final List<double> normals = [];
    final List<int> indices = [];
    int indicesOffset = 0;
    for (final mesh in meshes) {
      for (final triangle in mesh.triangles) {
        final shouldShow = triangle.shouldShowTriangle(rotation);

        for (int j = 0; j < triangle.points.length; j++) {
          final vertexIndice = indicesOffset + triangle.indices[j];
          if (shouldShow) indices.add(vertexIndice);

          if (positions[vertexIndice * 2] != 0) continue;

          if (shouldShow) {
            if (texture != null) {
              textureCoordinates[vertexIndice * 2] =
                  (triangle.points[j].textureCoordinates!.x) *
                      texture.image.width;
              textureCoordinates[vertexIndice * 2 + 1] =
                  (1 - triangle.points[j].textureCoordinates!.y) *
                      texture.image.height;
            }

            final projected = triangle.points[j].project(
              widthOffset: projectionData.widthOffset,
              heightOffset: projectionData.heightOffset,
              maxWidth: projectionData.maxFactor,
              maxHeight: projectionData.maxFactor,
              rotation: rotation,
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
      indicesOffset += mesh.vertices.length;
      //canvas.drawRawPoints(PointMode.points, positions.lenght, _paint);
    }
    return (
      positions: positions,
      textureCoordinates: textureCoordinates,
      triangleIndices: Uint16List.fromList(indices),
      normals: Float32List.fromList(normals),
    );
  }
}
