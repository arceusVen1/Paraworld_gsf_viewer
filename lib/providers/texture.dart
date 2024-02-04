import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final textureFutureProvider = FutureProvider<ui.Image?>(
  (ref) async {
    final path = ref.watch(texturePathProvider);
    if (path == null) {
      return null;
    }
    final data = File(path);
    final bytes = await data.readAsBytes();
    final completer = Completer<ui.Image>();
    ui.decodeImageFromList(bytes, completer.complete);
    return completer.future;
  },
);

final texturePathProvider = StateProvider<String?>((ref) => null);
