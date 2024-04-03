import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/chunk_attributes.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/model_settings.dart';
import 'package:paraworld_gsf_viewer/classes/model.dart';
import 'package:paraworld_gsf_viewer/providers/normals.dart';
import 'package:paraworld_gsf_viewer/widgets/convert_to_obj_cta.dart';
import 'package:paraworld_gsf_viewer/widgets/header2/widgets/chunks/attributes/chunk_attributes.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/data_display.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/label.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/mouse_movement_notifier.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/file_loaders.dart';
import 'package:paraworld_gsf_viewer/widgets/viewer/model_drawer.dart';
import 'package:paraworld_gsf_viewer/widgets/viewer/providers.dart';

class ModelViewerPageLayout extends ConsumerWidget {
  const ModelViewerPageLayout({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final currentModel = ref
        .watch(modelSelectionStateNotifierProvider.select((state) => state.map(
              empty: (_) => null,
              withModel: (withModel) => withModel.model,
            )));

    return Row(
      children: [
        _ViewerControls(),
        Flexible(
          flex: 3,
          child: Viewer(
            model: currentModel?.toModel(),
            //attributesFilter: currentFilter,
            //showCloth: showCloth,
          ),
        ),
      ],
    );
  }
}

class _ViewerControls extends ConsumerWidget {
  const _ViewerControls();

  @override
  Widget build(BuildContext context, ref) {
    final state = ref.watch(modelSelectionStateNotifierProvider);
    final currentModel = state.map(
      empty: (_) => null,
      withModel: (withModel) => withModel.model,
    );
    final currentFilter = state.map(
      empty: (_) => null,
      withModel: (withModel) => withModel.filter,
    );
    final showCloth = state.map(
      empty: (_) => false,
      withModel: (withModel) => withModel.showCloth,
    );
    return DataDecorator(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Switch.adaptive(
              value: showCloth,
              onChanged: (value) => ref
                  .read(modelSelectionStateNotifierProvider.notifier)
                  .updateShowCloth(value),
            ),
            Gap(8),
            Label.medium(
              "show cloth",
              isBold: true,
            ),
          ],
        ),
        PartSelector(
            value: currentModel,
            label: 'Models',
            parts: state.models,
            onSelected: (part) {
              ref
                  .read(modelSelectionStateNotifierProvider.notifier)
                  .setModel(part as ModelSettings);
            }),
        currentFilter == null
            ? SizedBox.shrink()
            : ChunkAttributesDisplay(
                attributes: currentFilter,
                onAttributePress: (indice) {
                  ref
                      .read(modelSelectionStateNotifierProvider.notifier)
                      .updateFilterAttribute(indice);
                },
              ),
      ],
    );
  }
}

class Viewer extends StatelessWidget {
  const Viewer({
    super.key,
    required this.model,
    this.attributesFilter,
    this.showCloth = false,
  });

  final Model? model;
  final ChunkAttributes? attributesFilter;
  final bool showCloth;

  @override
  Widget build(BuildContext context) {
    if (model == null) {
      return const Center(
        child: Label.extraLarge("No model to show"),
      );
    }
    final theme = Theme.of(context);

    final defaultAttributes = ChunkAttributes.fromValue(
      model!.type,
      ChunkAttributes.defaultLoD,
    );

    return Column(
      children: [
        Expanded(
          child: MouseMovementNotifier(
            mouseListener: (mouseNotifier) => GSFLoader(
              builder: (gsf) => ImageTextureLoader(
                textureBuilder: (texture) {
                  return ShowNormalWrapper(
                    builder: (showNormals) => ViewerControlWrapper(
                      overridingAttributes: attributesFilter,
                      builder: (showCloth, controlAttributes) => CustomPaint(
                        painter: ModelDrawer(
                          meshColor: theme.colorScheme.onBackground,
                          mousePosition: mouseNotifier,
                          model: model!,
                          texture: texture,
                          showNormals: showNormals,
                          attributesFilter: controlAttributes ??
                              attributesFilter ??
                              defaultAttributes,
                          showCloth: showCloth,
                        ),
                        child: const SizedBox.expand(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        ViewerControlWrapper(
          overridingAttributes: attributesFilter,
          builder: (_, attributes) => ConvertToObjCta(
            model: model!,
            attributesFilter: attributes ?? defaultAttributes,
          ),
        ),
      ],
    );
  }
}

typedef viewerControlBuilder = Widget Function(bool, ChunkAttributes?);

class ViewerControlWrapper extends ConsumerWidget {
  const ViewerControlWrapper({
    super.key,
    required this.builder,
    required this.overridingAttributes,
  });

  final viewerControlBuilder builder;
  final ChunkAttributes? overridingAttributes;
  @override
  Widget build(BuildContext context, ref) {
    if (overridingAttributes != null) {
      return builder(false, overridingAttributes);
    }
    return builder(
      ref.watch(modelSelectionStateNotifierProvider).map(
            empty: (_) => false,
            withModel: (withModel) => withModel.showCloth,
          ),
      ref.watch(modelSelectionStateNotifierProvider).map(
            empty: (_) => null,
            withModel: (withModel) => withModel.filter,
          ),
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
