import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paraworld_gsf_viewer/classes/texture.dart';
import 'package:paraworld_gsf_viewer/providers/texture.dart';

typedef TextureBuilder = Widget Function(ModelTexture? texture);

class ImageTextureLoader extends ConsumerWidget {
  const ImageTextureLoader({super.key, required this.textureBuilder});

  final TextureBuilder textureBuilder;

  @override
  Widget build(BuildContext context, ref) {
    final textureState = ref.watch(textureFutureProvider);
    return textureState.map(
      data: (data) => textureBuilder(data.value != null ? ModelTexture(data.value!) : null),
      loading: (loading) => const CircularProgressIndicator(),
      error: (_) => textureBuilder(null),
    );
  }
}
