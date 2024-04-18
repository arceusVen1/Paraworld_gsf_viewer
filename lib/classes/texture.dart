import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:image/image.dart' as img;
import 'package:paraworld_gsf_viewer/classes/gsf/header2/material_attribute.dart';
import 'package:paraworld_gsf_viewer/providers/texture.dart';

import 'package:vector_math/vector_math_64.dart';

class ModelTexture {
  ModelTexture({
    required this.attribute,
    required this.path,
  }) {
    _textureFile = File(path);
  }

  final MaterialAttribute attribute;
  late final String path;
  final Paint painter = Paint()..blendMode = BlendMode.srcOver;
  Image? _uiImage;
  File? _textureFile;

  Image? get image => _uiImage;

  ModelTexture.fromMaterialAttribute(
    this.attribute,
    String name,
    String pwFolder,
    DetailTable detailTable,
  ) {
    _textureFile = _getImageFile(name, pwFolder, detailTable);
    if (_textureFile == null) {
      path = "";
    } else {
      path = _textureFile!.path;
    }
  }

  File? _getImageFile(String name, String pwFolder, DetailTable detailTable) {
    String textureNameWithoutExtension = name.split("/").last.split(".").first;
    String pathToTexture =
        "$pwFolder/Data/Base/Texture/${name.replaceAll("/$textureNameWithoutExtension.tga", "")}";
    if (detailTable[textureNameWithoutExtension] == null) {
      return null;
    }
    File? texture;
    final int maxResolution =
        detailTable[textureNameWithoutExtension]!.availableResolutions.last;
    texture = File(
        '$pathToTexture/${"${textureNameWithoutExtension}_(${maxResolution > 1000 ? maxResolution : "0${maxResolution < 100 ? "0$maxResolution" : maxResolution}"}).dds"}');

    if (!texture.existsSync()) {
      texture = File('$pathToTexture/$textureNameWithoutExtension.tga');
    }

    return texture;
  }

  void applyAttributesToTexture(
      img.Image imageToProcess, Color fillingColor, Color? partyColor) {

    for (final frame in imageToProcess.frames) {
      for (final p in frame) {
        if (attribute.useHardAlpha) {
           p.a = p.a <= 126 ? 0 : 255;
        }
        if (!attribute.useSoftAlpha && !attribute.useHardAlpha) {
           p.a = 255;
        }
		
        if (attribute.usePlayerColor && partyColor != null) {
          p.r = partyColor.red;
          p.g = partyColor.green;
          p.b = partyColor.blue;
        }
      }
    }
  }

  Future<Image?> loadImage(Color fillingColor, Color? partyColor) async {
    if (_uiImage != null) {
      return _uiImage!;
    }
    if (_textureFile == null) {
      return null;
    }
    final completer = Completer<Image>();
    final bytes = await _textureFile!.readAsBytes();
    decodeImageFromList(bytes, completer.complete);
    _uiImage = await completer.future;
    if (_uiImage == null) {
      return null;
    }
    final uiBytes = await _uiImage!.toByteData();

    final imageData = img.Image.fromBytes(
      width: _uiImage!.width,
      height: _uiImage!.height,
      bytes: uiBytes!.buffer,
      numChannels: 4,
    );

    applyAttributesToTexture(imageData, fillingColor, partyColor);

    ImmutableBuffer buffer =
        await ImmutableBuffer.fromUint8List(imageData.toUint8List());

    ImageDescriptor id = ImageDescriptor.raw(buffer,
        height: imageData.height,
        width: imageData.width,
        pixelFormat: PixelFormat.rgba8888);

    Codec codec = await id.instantiateCodec(
        targetHeight: imageData.height, targetWidth: imageData.width);

    FrameInfo fi = await codec.getNextFrame();
    _uiImage = fi.image;

    painter.shader = ImageShader(
      _uiImage!,
      TileMode.decal,
      TileMode.decal,
      Matrix4.identity().storage,
    );
    return _uiImage!;
  }
}
