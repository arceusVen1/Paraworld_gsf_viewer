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
