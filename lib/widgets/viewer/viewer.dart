import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/chunk.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/chunk_attributes.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/cloth.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/mesh.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/materials_table.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/model_settings.dart';
import 'package:paraworld_gsf_viewer/classes/model.dart';
import 'package:paraworld_gsf_viewer/providers/gsf.dart';
import 'package:paraworld_gsf_viewer/providers/notifiers.dart';
import 'package:paraworld_gsf_viewer/providers/state.dart';
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
    final materialTable = ref.watch(modelSelectionStateNotifierProvider
        .select((state) => state.materialsTable));
    final currentModel = ref
        .watch(modelSelectionStateNotifierProvider.select((state) => state.map(
              empty: (_) => null,
              withModel: (withModel) => withModel.model,
            )));

    final showPartyColor = ref
        .watch(modelSelectionStateNotifierProvider.select((state) => state.map(
              empty: (_) => false,
              withModel: (withModel) => withModel.showPartyColor,
            )));

    return Row(
      children: [
        const _ViewerControls(),
        Flexible(
          flex: 3,
          child: ModelViewerLoader(
            selectedModelData: currentModel,
            materialsTable: materialTable,
            showPartyColor: showPartyColor,
            //attributesFilter: currentFilter,
            //showCloth: showCloth,
          ),
        ),
      ],
    );
  }
}

class _ViewerSwitchsControl extends StatelessWidget {
  const _ViewerSwitchsControl({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final bool value;
  final Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Switch.adaptive(
          value: value,
          onChanged: onChanged,
        ),
        Gap(8),
        Label.medium(
          title,
          isBold: true,
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
    return DataDecorator(
      children: [
        _ViewerSwitchsControl(
          title: "Show Texture",
          value: state.map(
            empty: (_) => false,
            withModel: (withModel) => withModel.showTexture,
          ),
          onChanged: (value) {
            ref
                .read(modelSelectionStateNotifierProvider.notifier)
                .updateShowTexture(value);
          },
        ),
        _ViewerSwitchsControl(
          title: "Show Cloth",
          value: state.map(
            empty: (_) => false,
            withModel: (withModel) => withModel.showCloth,
          ),
          onChanged: (value) {
            ref
                .read(modelSelectionStateNotifierProvider.notifier)
                .updateShowCloth(value);
          },
        ),
        _ViewerSwitchsControl(
          title: "Show Skeleton",
          value: state.map(
            empty: (_) => false,
            withModel: (withModel) => withModel.showSkeleton,
          ),
          onChanged: (value) {
            ref
                .read(modelSelectionStateNotifierProvider.notifier)
                .updateShowSkeleton(value);
          },
        ),
        _ViewerSwitchsControl(
          title: "Show Links",
          value: state.map(
            empty: (_) => false,
            withModel: (withModel) => withModel.showLinks,
          ),
          onChanged: (value) {
            ref
                .read(modelSelectionStateNotifierProvider.notifier)
                .updateShowLinks(value);
          },
        ),
        _ViewerSwitchsControl(
          title: "Show Normals",
          value: state.map(
            empty: (_) => false,
            withModel: (withModel) => withModel.showNormals,
          ),
          onChanged: (value) {
            ref
                .read(modelSelectionStateNotifierProvider.notifier)
                .updateShowNormal(value);
          },
        ),
        _ViewerSwitchsControl(
          title: "Show Party Color",
          value: state.map(
            empty: (_) => false,
            withModel: (withModel) => withModel.showPartyColor,
          ),
          onChanged: (value) {
            ref
                .read(modelSelectionStateNotifierProvider.notifier)
                .updateShowPartyColor(value);
          },
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
                showNonFlags: false,
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

class ChunkViewerLoader extends ConsumerWidget {
  const ChunkViewerLoader({
    super.key,
    required this.chunk,
    required this.materialsTable,
  });

  final Chunk chunk;
  final MaterialsTable materialsTable;

  @override
  Widget build(BuildContext context, ref) {
    final detailTable = ref
        .watch(pwLinkStateNotifierProvider)
        .mapOrNull(success: (success) => success.detailTable);
    Model? model;
    if (chunk.type.isClothLike()) {
      model = (chunk as ClothChunk).toModel();
    } else if (chunk.type.isMeshLike()) {
      model = (chunk as MeshChunk).toModel();
    } else {
      return const SizedBox.shrink();
    }

    return FutureBuilder(
      future: model.loadTextures(
        Theme.of(context).colorScheme.onBackground,
        null,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Viewer(
            model: model,
            attributesFilter: ChunkAttributes(
              value: chunk.attributes.value,
              typeOfModel: ModelType.unknown,
            ),
            detailTable: detailTable,
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class ModelViewerLoader extends ConsumerWidget {
  const ModelViewerLoader({
    super.key,
    required this.selectedModelData,
    required this.materialsTable,
    this.attributesFilter,
    this.showPartyColor = false,
  });

  final ModelSettings? selectedModelData;
  final MaterialsTable materialsTable;
  final ChunkAttributes? attributesFilter;
  final bool showPartyColor;

  @override
  Widget build(BuildContext context, ref) {
    if (selectedModelData == null) {
      return const Center(
        child: Label.extraLarge("No model to show"),
      );
    }
    final pwLinkState = ref.watch(pwLinkStateNotifierProvider);
    String? pwFolder;
    DetailTable? detailTable;
    PathGetter? getTexturePathFnct;
    pwLinkState.mapOrNull(
      success: (withLink) {
        pwFolder = withLink.pwFolderPath;
        detailTable = withLink.detailTable;
        getTexturePathFnct =
            ref.read(pwLinkStateNotifierProvider.notifier).getModdedPathForFile;
      },
    );
    final model = selectedModelData!
        .toModel(materialsTable, pwFolder, detailTable, getTexturePathFnct);
    return FutureBuilder(
      future: model.loadTextures(Theme.of(context).colorScheme.onBackground,
          showPartyColor ? Colors.cyan : null),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Viewer(
            model: model,
            attributesFilter: attributesFilter,
            detailTable: detailTable,
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class Viewer extends StatelessWidget {
  const Viewer({
    super.key,
    required this.model,
    required this.attributesFilter,
    this.detailTable,
  });

  final Model? model;
  final ChunkAttributes? attributesFilter;
  final DetailTable? detailTable;

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
                  return ViewerControlWrapper(
                    overridingAttributes: attributesFilter,
                    builder: (
                      showCloth,
                      showNormals,
                      showTexture,
                      showSkeleton,
                      showLinks,
                      controlAttributes,
                    ) =>
                        CustomPaint(
                      painter: ModelDrawer(
                        meshColor: theme.colorScheme.onBackground,
                        mousePosition: mouseNotifier,
                        model: model!,
                        overridingTexture: texture,
                        showNormals: showNormals,
                        attributesFilter: controlAttributes ??
                            attributesFilter ??
                            defaultAttributes,
                        showCloth: showCloth,
                        showTexture: showTexture,
                        showSkeleton: showSkeleton,
                        showLinks: showLinks,
                      ),
                      child: const SizedBox.expand(),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        ViewerControlWrapper(
          overridingAttributes: attributesFilter,
          builder: (showCloth, showNomrals, showTexture, showSkeleton,
                  showLinks, attributes) =>
              ConvertToObjCta(
            model: model!,
            attributesFilter: attributes ?? defaultAttributes,
          ),
        ),
      ],
    );
  }
}

typedef ViewerControlBuilder = Widget Function(bool showCloth, bool showNormals,
    bool showTexture, bool showSkeleton, bool showLinks, ChunkAttributes?);

class ViewerControlWrapper extends ConsumerWidget {
  const ViewerControlWrapper({
    super.key,
    required this.builder,
    required this.overridingAttributes,
  });

  final ViewerControlBuilder builder;
  final ChunkAttributes? overridingAttributes;
  @override
  Widget build(BuildContext context, ref) {
    if (overridingAttributes != null) {
      return builder(false, false, true, false, false, overridingAttributes);
    }
    final state = ref.watch(modelSelectionStateNotifierProvider);
    return builder(
      state.map(
        empty: (_) => false,
        withModel: (withModel) => withModel.showCloth,
      ),
      state.map(
        empty: (_) => false,
        withModel: (withModel) => withModel.showNormals,
      ),
      state.map(
        empty: (_) => false,
        withModel: (withModel) => withModel.showTexture,
      ),
      state.map(
        empty: (_) => false,
        withModel: (withModel) => withModel.showSkeleton,
      ),
      state.map(
        empty: (_) => false,
        withModel: (withModel) => withModel.showLinks,
      ),
      state.map(
        empty: (_) => null,
        withModel: (withModel) => withModel.filter,
      ),
    );
  }
}
