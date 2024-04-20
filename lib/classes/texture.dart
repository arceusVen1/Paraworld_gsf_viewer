import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:image/image.dart' as img;
import 'package:paraworld_gsf_viewer/classes/gsf/header2/material_attribute.dart';
import 'package:paraworld_gsf_viewer/providers/texture.dart';

class ModelTexture {
  ModelTexture({
    required this.attribute,
    required this.path,
  }) {
    _textureFile = File(path);
  }

  final MaterialAttribute attribute;
  late final String path;

  img.Image? imageData;
  File? _textureFile;


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

  img.Image applyAttributesToTexture(
      img.Image imageToProcess, Color fillingColor, Color? partyColor) {
    for (final frame in imageToProcess.frames) {
      for (final p in frame) {
        //p.setRgba(p.r, p.g, p.b, 0);
        if (attribute.useHardAlpha) {
          p.a = p.a < 127 ? 0 : 255;
          p.r = p.r * p.a / 255;
          p.g = p.g * p.a / 255;
          p.b = p.b * p.a / 255;
        }
        if (!attribute.useSoftAlpha && !attribute.useHardAlpha) {
          p.a = 255;
        }
        if (attribute.usePlayerColor && partyColor != null) {
          if (p.r != 0 || p.g != 0 || p.b != 0) {
            p.r = partyColor.red;
            p.g = partyColor.green;
            p.b = partyColor.blue;
          }
        }
      }
    }
    return imageToProcess;
  }

  Future<img.Image?> loadImage(Color fillingColor, Color? partyColor) async {
    if (imageData != null) {
      return imageData;
    }
    if (_textureFile == null) {
      return null;
    }
    final bytes = await _textureFile!.readAsBytes();
    if (_textureFile!.path.endsWith(".tag")) {
      imageData = img.decodeTga(bytes);
    } else {
      final completer = Completer<Image>();
      decodeImageFromList(bytes, completer.complete);
      final test = await completer.future;
      final uiBytes = await test.toByteData();

      if (uiBytes == null) {
        return null;
      }

      imageData = img.Image.fromBytes(
        width: test.width,
        height: test.height,
        bytes: uiBytes.buffer,
        numChannels: 4,
        order: img.ChannelOrder.rgba,
      );
    }
    if (imageData != null) {
      applyAttributesToTexture(imageData!, fillingColor, partyColor);
    }
    return imageData;
  }

  Future<Image?> convertToUiImage() async {
    if (imageData == null) {
      return null;
    }
    ImmutableBuffer buffer =
        await ImmutableBuffer.fromUint8List(imageData!.toUint8List());

    ImageDescriptor id = ImageDescriptor.raw(
      buffer,
      height: imageData!.height,
      width: imageData!.width,
      pixelFormat: PixelFormat.rgba8888,
    );

    Codec codec = await id.instantiateCodec(
      targetHeight: imageData!.height,
      targetWidth: imageData!.width,
    );

    FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }

  @override
  String toString() {
    return 'ModelTexture $path';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ModelTexture &&
        other.path == path &&
        other.attribute == attribute;
  }

  @override
  int get hashCode => path.hashCode ^ attribute.hashCode;
}
