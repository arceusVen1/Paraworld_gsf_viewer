import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paraworld_gsf_viewer/classes/model.dart';
import 'package:paraworld_gsf_viewer/providers/normals.dart';
import 'package:paraworld_gsf_viewer/widgets/convert_to_obj_cta.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/label.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/mouse_movement_notifier.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/file_loaders.dart';
import 'package:paraworld_gsf_viewer/widgets/viewer/model_drawer.dart';

class Viewer extends StatelessWidget {
  const Viewer({super.key, required this.model});

  final Model? model;

  @override
  Widget build(BuildContext context) {
    if (model == null) {
      return const Center(
        child: Label.extraLarge("No model to show"),
      );
    }
    final theme = Theme.of(context);

    return Column(
      children: [
        Expanded(
          child: MouseMovementNotifier(
            mouseListener: (mouseNotifier) => GSFLoader(
              builder: (gsf) => ImageTextureLoader(
                textureBuilder: (texture) {
                  return ShowNormalWrapper(
                    builder: (showNormals) => CustomPaint(
                      painter: ModelDrawer(
                        meshColor: theme.colorScheme.onBackground,
                        mousePosition: mouseNotifier,
                        model: model!,
                        texture: texture,
                        showNormals: showNormals,
                      ),
                      child: const SizedBox.expand(),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        ConvertToObjCta(
          model: model!,
        ),
      ],
    );
  }
}

typedef ShowNormalsBuilder = Widget Function(bool);

class ShowNormalWrapper extends ConsumerWidget {
  const ShowNormalWrapper({super.key, required this.builder});

  final ShowNormalsBuilder builder;

  @override
  Widget build(BuildContext context, ref) {
    return builder(ref.watch(showNormalsProvider));
  }
}
