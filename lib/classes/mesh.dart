import 'dart:typed_data';
import 'dart:ui';

import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/chunk_attributes.dart';
import 'package:paraworld_gsf_viewer/classes/model.dart';
import 'package:paraworld_gsf_viewer/classes/rotation.dart';
import 'package:paraworld_gsf_viewer/classes/texture.dart';
import 'package:paraworld_gsf_viewer/classes/triangle.dart';
import 'package:paraworld_gsf_viewer/classes/vertex.dart';

class ModelMesh {
  const ModelMesh({
    required this.submeshes,
    required this.attributes,
  });
  final List<ModelSubMesh> submeshes;
  final ChunkAttributes attributes;

  bool canBeViewed(ChunkAttributes attributesFilter) {
    return attributes.isCompatible(attributesFilter);
  }
}

class ModelSubMesh {
  const ModelSubMesh({
    required this.vertices,
    required this.triangles,
    required this.texture,
  });
  final List<ModelVertex> vertices;
  final List<ModelTriangle> triangles;
  final ModelTexture? texture;

  ({
    Float32List positions,
    Float32List textureCoordinates,
    List<ModelTriangle> triangleToShow,
    Float32List normals,
  }) getDrawingData(
    Transformation transformation, {
    required ProjectionData projectionData,
    Image? overrideTexture,
    required int textureWidthOffset,
    required int verticesOffset,
  }) {
    final verticesLength = vertices.length;
    final Float32List positions =
        Float32List.fromList(List<double>.filled(verticesLength * 2, 0));
    final Float32List textureCoordinates =
        Float32List.fromList(List<double>.filled(verticesLength * 2, 0));
    final List<double> normals = [];

    final List<ModelTriangle> trianglesToShow = [];
    for (final triangle in triangles) {
      final shouldShow = triangle.shouldShowTriangle(transformation);
      if (shouldShow) trianglesToShow.add(triangle.copy(verticesOffset));

      for (int j = 0; j < triangle.points.length; j++) {
        final vertexIndice = triangle.indices[j];
        //if (shouldShow) indices.add(vertexIndice);

        if (positions[vertexIndice * 2] != 0) continue;

        if (shouldShow) {
          if (texture?.imageData != null || overrideTexture != null) {
            final height =
                overrideTexture?.height ?? texture!.imageData!.height;
            final width = overrideTexture?.width ?? texture!.imageData!.width;
            textureCoordinates[vertexIndice * 2] = textureWidthOffset +
                (triangle.points[j].textureCoordinates!.x * width);
            textureCoordinates[vertexIndice * 2 + 1] =
                (1 - triangle.points[j].textureCoordinates!.y) * height;
          }

          final projected = triangle.points[j].project(
            widthOffset: projectionData.widthOffset,
            heightOffset: projectionData.heightOffset,
            maxWidth: projectionData.maxFactor,
            maxHeight: projectionData.maxFactor,
            transformation: transformation,
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

    return (
      positions: positions,
      textureCoordinates: textureCoordinates,
      triangleToShow: trianglesToShow,
      normals: Float32List.fromList(normals),
    );
  }
}
