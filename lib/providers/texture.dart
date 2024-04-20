import 'dart:io';
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

final pwFolderPathStateProvider = StateProvider<String?>((ref) => null);

typedef DetailTable = Map<String, DetailTableEntry>;

typedef DetailTableEntry = ({
  List<int> availableResolutions,
  bool overrideNameWithResolution,
});

final detailTableStateProvider = FutureProvider<DetailTable?>((ref) async {
  final pwFolderPath = ref.watch(pwFolderPathStateProvider);
  if (pwFolderPath == null) {
    return null;
  }
  final File detailTable =
      File('$pwFolderPath/Data/Base/Texture/detailtable.txt');
  final lines = await detailTable.readAsLines();
  final DetailTable map = {};
  for (final line in lines) {
    final trimmedLine = line.trim();
    final escapeRegex = RegExp(r'[#]|[-]');
    if (trimmedLine.isEmpty || trimmedLine.startsWith(escapeRegex)) {
      continue;
    }
    final parts = trimmedLine.split(RegExp(r'\s+'));
    final key = parts[0].toLowerCase();
    final List<int> resolutions = [];
    bool overrideWithResolution = true;
    for (final part in parts.sublist(2)) {
      // skip the first two parts (key and some code)
      final trimmed = part.trim();
      if (trimmed == "-dontchange") {
        overrideWithResolution = false;
      }
      if (trimmed.startsWith("#")) {
        break;
      } else if (trimmed.startsWith(escapeRegex)) {
        continue;
      } else {
        resolutions.add(int.parse(trimmed));
      }
    }
    map[key] = (
      availableResolutions: resolutions,
      overrideNameWithResolution: overrideWithResolution
    );
  }
  return map;
});
