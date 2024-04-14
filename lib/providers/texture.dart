import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final textureFutureProvider = FutureProvider<ui.Image?>(
  (ref) async {
    final file = ref.watch(texturePathStateProvider);
    if (file == null) {
      return null;
    }
    final completer = Completer<ui.Image>();
    if (file.bytes != null) {
      ui.decodeImageFromList(file.bytes!, completer.complete);
    } else if (file.path != null) {
      final data = File(file.path!);
      final bytes = await data.readAsBytes();
      ui.decodeImageFromList(bytes, completer.complete);
    }
    return completer.future;
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
