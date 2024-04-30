import 'dart:isolate';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:paraworld_gsf_viewer/classes/bouding_box.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/chunk_attributes.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/material_attribute.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/model_settings.dart';
import 'package:paraworld_gsf_viewer/classes/mesh.dart';
import 'package:paraworld_gsf_viewer/classes/rotation.dart';
import 'package:paraworld_gsf_viewer/classes/texture.dart';
import 'dart:math' as math;
import 'package:image/image.dart' as img;
import 'package:paraworld_gsf_viewer/classes/triangle.dart';
import 'package:paraworld_gsf_viewer/classes/vertex.dart';

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
    required this.skeletons,
  });

  final ModelType type;
  final String name;
  final List<ModelMesh> meshes;
  final List<ModelMesh> cloth;
  final BoundingBoxModel boundingBox;
  final List<List<List<(int, ModelVertex)>>> skeletons;
  // todo skeleton
  // todo position links

  final Paint _paint = Paint()
    ..color = Colors.black
    ..strokeWidth = 1
    ..strokeCap = StrokeCap.round;

  final skeletonPaint = Paint()
    ..strokeWidth = 2
    ..strokeCap = StrokeCap.round;

  final Map<ModelTexture, (int, img.Image)> _texturesOffsets = {};
  ui.Image? _composedModelImage;

  /// When loading a model, we need to load all the textures and compose them into a single image
  /// so it allow for a single canvas paint call for z buffering with single image shader
  /// Images are being added to the composed image from left to right.
  /// the highest image makes the height of the composed image
  Future<void> loadTextures(Color fillingColor, Color? partyColor) async {
    int widthOffset = 0;
    int height = 0;
    for (final mesh in meshes + cloth) {
      for (final submesh in mesh.submeshes) {
        if (submesh.texture != null &&
            _texturesOffsets[submesh.texture!] == null) {
          final image =
              await submesh.texture!.loadImage(fillingColor, partyColor);
          if (image != null) {
            _texturesOffsets[submesh.texture!] = (widthOffset, image);
            widthOffset += image.width;
            if (image.height > height) {
              height = image.height;
            }
          }
        } else {
          submesh.texture?.imageData = _texturesOffsets[submesh.texture]?.$2;
        }
      }
    }
    if (height == 0) {
      return;
    }
    img.Image fullTexture = img.Image(
      width: widthOffset,
      height: height,
      numChannels: 4,
    );

    img.Image createFullTexture(
        img.Image image, Map<ModelTexture, (int, img.Image)> offsets) {
      for (final p in image) {
        for (var data in offsets.entries) {
          final textureImage = data.key.imageData;
          final textureOffset = data.value.$1;
          if (textureImage!.height > p.y &&
              (p.x - textureOffset) > 0 &&
              textureImage.width > (p.x - textureOffset)) {
            final pixel = textureImage.getPixel(p.x - textureOffset, p.y);
            p.setRgba(pixel.r, pixel.g, pixel.b, pixel.a);
          }
        }
      }
      return image;
    }

    // to avoid blocking UI this is executed in separate isolate
    fullTexture = await Isolate.run(
        () => createFullTexture(fullTexture, _texturesOffsets));
    _composedModelImage =
        await (ModelTexture(attribute: MaterialAttribute.zero(), path: "")
              ..imageData = fullTexture)
            .convertToUiImage();
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
    Transformation transformation,
    ui.Size size,
    ui.Canvas canvas,
    Color meshColor,
    ChunkAttributes attributesFilter, {
    ui.Image? overrideTexture,
    bool showNormals = false,
    bool showCloths = false,
    bool showTexture = false,
    bool showSkeleton = false,
  }) {
    final projectionData = getProjectionData(size);
    final listOfMesh = showCloths ? meshes + cloth : meshes;

    final List<double> verticesPositions = [];
    final List<double> textureCoordinates = [];
    List<ModelTriangle> triangles = [];

    for (final mesh in listOfMesh) {
      if (!mesh.canBeViewed(attributesFilter)) {
        continue;
      }
      // reversing submesh seems to help with rendering order
      for (final submesh in mesh.submeshes.reversed) {
        final data = submesh.getDrawingData(
          transformation,
          projectionData: projectionData,
          overrideTexture: overrideTexture,
          textureWidthOffset: overrideTexture == null
              ? _texturesOffsets[submesh.texture]?.$1 ?? 0
              : 0,
          verticesOffset: verticesPositions.length ~/ 2,
        );
        triangles.addAll(data.triangleToShow);
        verticesPositions.addAll(data.positions);
        textureCoordinates.addAll(data.textureCoordinates);

        if (showNormals) {
          canvas.drawRawPoints(
            ui.PointMode.lines,
            data.normals,
            _paint..color = Colors.red,
          );
        }
      }
    }
    // trying to push deeper triangles to the back
    triangles.sort((a, b) {
      cmpFnct(double previousValue, ModelVertex element) {
        return previousValue + element.transform(transformation).z;
      }

      final double aWeight = a.points.fold(0.0, cmpFnct);
      final double bWeight = b.points.fold(0.0, cmpFnct);
      return bWeight.compareTo(aWeight);
    });
    final List<int> trianglesIndices = [];
    for (final triangle in triangles) {
      trianglesIndices.addAll(triangle.indices);
    }

    final verticesTypedPositions = Float32List.fromList(verticesPositions);
    final trianglesTypedindices = Uint16List.fromList(trianglesIndices);

    if (!showTexture ||
        (overrideTexture == null && _composedModelImage == null)) {
      drawTrianglesOutside(canvas, trianglesTypedindices,
          verticesTypedPositions, _paint..color = meshColor);
    }

    final texturePainter = ui.Paint()
      ..blendMode = BlendMode.srcOver
      ..shader = overrideTexture != null || _composedModelImage != null
          ? ui.ImageShader(
              overrideTexture ?? _composedModelImage!,
              TileMode.decal,
              TileMode.decal,
              Matrix4.identity().storage,
            )
          : null;

    canvas.drawVertices(
      ui.Vertices.raw(
        VertexMode.triangles,
        verticesTypedPositions,
        indices: trianglesTypedindices,
        // colors: Int32List.fromList(List.filled(
        //     (data.positions.length / 2).round(),
        //     meshColor.withOpacity(0.3).value)),
        textureCoordinates: Float32List.fromList(textureCoordinates),
      ),
      BlendMode.srcOver,
      showTexture
          ? texturePainter
          : (_paint..color = meshColor.withOpacity(0.3)),
    );

    if (showSkeleton && skeletons.isNotEmpty) {
      skeletonPaint.color = meshColor;
      final textStyle = TextStyle(
        color: Colors.pink,
        fontSize: 12 + transformation.scaleFactor,
        fontWeight: FontWeight.bold,
      );
      final jointPaint = Paint()
        ..color = Colors.pink
        ..strokeWidth = 3 + transformation.scaleFactor / 2;
      for (final skeleton in skeletons) {
        for (final branch in skeleton) {
          final List<double> points = [];
          for (final joint in branch) {
            final coords = joint.$2.project(
              widthOffset: projectionData.widthOffset,
              heightOffset: projectionData.heightOffset,
              maxWidth: projectionData.maxFactor,
              maxHeight: projectionData.maxFactor,
              transformation: transformation,
            );
            final idPainter = TextPainter(
              text: TextSpan(
                text: joint.$1.toString(),
                style: textStyle,
              ),
              textDirection: TextDirection.ltr,
            )..layout(
                minWidth: 0,
                maxWidth: size.width,
              );
            idPainter.paint(
              canvas,
              Offset(
                coords.pointProjection.x,
                coords.pointProjection.y,
              ),
            );
            points.addAll([coords.pointProjection.x, coords.pointProjection.y]);
          }
          final pos = Float32List.fromList(points);
          canvas.drawRawPoints(ui.PointMode.lines, pos, skeletonPaint);
          canvas.drawRawPoints(
            ui.PointMode.points,
            pos,
            jointPaint,
          );
        }
      }
    }
  }
}
