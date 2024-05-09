import 'dart:isolate';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:paraworld_gsf_viewer/classes/bouding_box.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/chunk_attributes.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/link.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/skeleton.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/collision_struct.dart';
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
    required this.links,
    required this.collisions,
  });

  final ModelType type;
  final String name;
  final List<ModelMesh> meshes;
  final List<ModelMesh> cloth;
  final BoundingBoxModel boundingBox;
  final List<SkeletonModel> skeletons;
  final List<LinkModel> links;
  final List<CollisionModel> collisions;
  // todo skeleton
  // todo position links

  final Color collisionColor = const Color(0xff0aa208);

  final Paint _uncoloredPainter = Paint()
    ..color = Colors.black
    ..strokeWidth = 1
    ..strokeCap = StrokeCap.round;

  final skeletonPaint = Paint()
    ..strokeWidth = 2
    ..strokeCap = StrokeCap.round;

  final positionLinkPaint = Paint()
    ..color = Colors.blue
    ..strokeWidth = 8
    ..strokeCap = StrokeCap.round;

  final Map<ModelTexture, (int, img.Image)> _texturesOffsets = {};
  ui.Image? _composedModelImage;

  TextStyle _getTextStyle(double scaleFactor, Color color) {
    return TextStyle(
      color: color,
      fontSize: 12 + scaleFactor,
      fontWeight: FontWeight.bold,
    );
  }

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
            !_texturesOffsets.containsKey(submesh.texture!)) {
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
    // useful for debugging
    //await File("test_texture.png").writeAsBytes(img.encodePng(fullTexture)!);
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
      canvas.drawLine(p1, p2, customPaint ?? _uncoloredPainter);
      canvas.drawLine(p2, p3, customPaint ?? _uncoloredPainter);
      canvas.drawLine(p3, p1, customPaint ?? _uncoloredPainter);
    }
  }

  void drawPositionLinks(
    Transformation transformation,
    ui.Size size,
    ui.Canvas canvas,
  ) {
    final projectionData = getProjectionData(size);
    final pos = <double>[];
    final textStyle = _getTextStyle(transformation.scaleFactor, Colors.blue);
    for (final link in links) {
      final coords = link.vertex.project(
        widthOffset: projectionData.widthOffset,
        heightOffset: projectionData.heightOffset,
        maxWidth: projectionData.maxFactor,
        maxHeight: projectionData.maxFactor,
        transformation: transformation,
      );
      pos.addAll([coords.pointProjection.x, coords.pointProjection.y]);
      final namePainter = TextPainter(
        text: TextSpan(
          text: link.fourCC.toString(),
          style: textStyle,
        ),
        textDirection: TextDirection.ltr,
      )..layout(
          minWidth: 0,
          maxWidth: size.width,
        );
      namePainter.paint(
        canvas,
        Offset(
          coords.pointProjection.x,
          coords.pointProjection.y,
        ),
      );
    }
    canvas.drawRawPoints(
      ui.PointMode.points,
      Float32List.fromList(pos),
      positionLinkPaint,
    );
  }

  void drawSkeleton(
    Transformation transformation,
    ui.Size size,
    ui.Canvas canvas,
    Color meshColor,
  ) {
    final projectionData = getProjectionData(size);
    skeletonPaint.color = meshColor;
    final textStyle = _getTextStyle(transformation.scaleFactor, Colors.pink);
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
          points.addAll([coords.pointProjection.x, coords.pointProjection.y]);

          if (joint.$1 == null) {
            continue;
          }
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

  Float32List _getVerticesProjectedPositions(
    Transformation transformation,
    ProjectionData projectionData,
    List<ModelVertex> vertices,
  ) {
    final verticesPositions = <double>[];
    for (final vertex in vertices) {
      final coords = vertex.project(
        widthOffset: projectionData.widthOffset,
        heightOffset: projectionData.heightOffset,
        maxWidth: projectionData.maxFactor,
        maxHeight: projectionData.maxFactor,
        transformation: transformation,
      );
      verticesPositions
          .addAll([coords.pointProjection.x, coords.pointProjection.y]);
    }

    final verticesTypedPositions = Float32List.fromList(verticesPositions);
    return verticesTypedPositions;
  }

  void drawCollisions(
    Transformation transformation,
    ui.Size size,
    ui.Canvas canvas,
  ) {
    final projectionData = getProjectionData(size);
    for (final collision in collisions) {
      final verticesPositions = _getVerticesProjectedPositions(
        transformation,
        projectionData,
        collision.vertices,
      );
      canvas.drawVertices(
        ui.Vertices.raw(
          ui.VertexMode.triangles,
          verticesPositions,
          indices: collision.triangles,
        ),
        BlendMode.srcOver,
        _uncoloredPainter..color = collisionColor.withOpacity(0.3),
      );
      if (collision.markers != null) {
        final markersPositions = _getVerticesProjectedPositions(
          transformation,
          projectionData,
          collision.markers!,
        );
        canvas.drawRawPoints(
          ui.PointMode.lines,
          markersPositions,
          _uncoloredPainter..color = collisionColor,
        );
      }
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
            _uncoloredPainter..color = Colors.red,
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
          verticesTypedPositions, _uncoloredPainter..color = meshColor);
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
          : (_uncoloredPainter..color = meshColor.withOpacity(0.3)),
    );
  }
}
