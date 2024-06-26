import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/gsf.dart';
import 'package:paraworld_gsf_viewer/providers/gsf.dart';
import 'package:paraworld_gsf_viewer/providers/texture.dart';

typedef TextureBuilder = Widget Function(ui.Image? texture);

class ImageTextureLoader extends ConsumerWidget {
  const ImageTextureLoader({super.key, required this.textureBuilder});

  final TextureBuilder textureBuilder;

  @override
  Widget build(BuildContext context, ref) {
    final textureState = ref.watch(textureFutureProvider);
    return textureState.map(
      data: (data) => textureBuilder(data.value),
      loading: (loading) => const CircularProgressIndicator(),
      error: (_) => textureBuilder(null),
    );
  }
}

typedef GSFBuilder = Widget Function(GSF? gsf);

class GSFLoader extends ConsumerWidget {
  const GSFLoader({super.key, required this.builder});

  final GSFBuilder builder;
  @override
  Widget build(BuildContext context, ref) {
    final gsfState = ref.watch(gsfProvider);
    return gsfState.map(
      data: (data) {
        return builder(data.value);
      },
      loading: (loading) => const CircularProgressIndicator(),
      error: (err) {
        print(err.error);
        return builder(null);
      },
    );
  }
}
