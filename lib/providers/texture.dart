import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/material_attribute.dart';
import 'package:paraworld_gsf_viewer/classes/texture.dart';
import 'dart:ui' as ui;


final textureFutureProvider = FutureProvider<ui.Image?>(
  (ref) async {
    final file = ref.watch(texturePathStateProvider);
    if (file == null) {
      return null;
    }
    final texture =
        ModelTexture(attribute: MaterialAttribute.zero(), path: file.path!);
    await texture.loadImage(Colors.black, null);
    return await texture.convertToUiImage();
  },
);

final texturePathStateProvider = StateProvider<PlatformFile?>((ref) => null);