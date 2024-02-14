import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final textureFutureProvider = FutureProvider<ui.Image?>(
  (ref) async {
    final file = ref.watch(texturePathStateProvider);
    if (file == null || file.bytes == null) {
      return null;
    }
    final completer = Completer<ui.Image>();
    ui.decodeImageFromList(file.bytes!, completer.complete);
    return completer.future;
  },
);

final texturePathStateProvider = StateProvider<PlatformFile?>((ref) => null);
