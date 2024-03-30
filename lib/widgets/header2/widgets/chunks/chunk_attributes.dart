import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/chunk_attributes.dart';
import 'package:paraworld_gsf_viewer/widgets/header2/providers.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/data_display.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/label.dart';

class ChunkAttributesDisplay extends ConsumerWidget {
  const ChunkAttributesDisplay({
    super.key,
    required this.attributes,
  });
  final int attributes;

  @override
  Widget build(BuildContext context, ref) {
    final currentModelType = ref.watch(header2StateNotifierProvider).maybeMap(
          withModelSettings: (state) => state.modelSettings.type,
          orElse: () => null,
        );
    if (currentModelType == null) {
      return const SizedBox.shrink();
    }
    final chunkAttributes =
        ChunkAttributes.fromModelType(currentModelType, attributes);
    return DropdownWrapper(
        label: "Attributes",
        child: Column(
          children: [
            _LevelOfDetailsDisplay(
              chunkAttributes: chunkAttributes,
            ),
          ],
        ));
  }
}

class _LevelOfDetailsDisplay extends StatelessWidget {
  const _LevelOfDetailsDisplay({
    required this.chunkAttributes,
  });

  final ChunkAttributes chunkAttributes;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _LevelWrapper(
          level: 0,
          isOn: chunkAttributes.isLOD0,
        ),
        _LevelWrapper(
          level: 1,
          isOn: chunkAttributes.isLOD1,
        ),
        _LevelWrapper(
          level: 2,
          isOn: chunkAttributes.isLOD2,
        ),
        _LevelWrapper(
          level: 3,
          isOn: chunkAttributes.isLOD3,
        ),
        _LevelWrapper(
          level: 4,
          isOn: chunkAttributes.isLOD4,
        ),
      ],
    );
  }
}

class _LevelWrapper extends StatelessWidget {
  const _LevelWrapper({
    required this.level,
    required this.isOn,
  });

  final int level;
  final bool isOn;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      clipBehavior: Clip.hardEdge,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        // gradient: isOn
        //     ? RadialGradient(
        //         radius: 1.1,
        //         colors: [
        //           theme.colorScheme.secondaryContainer,
        //           theme.colorScheme.secondary,
        //         ],
        //       )
        //     : null,
        color: isOn
            ? theme.colorScheme.secondaryContainer
            : theme.colorScheme.primaryContainer,
        border: Border.all(color: Colors.black),
      ),
      child: Label.small(
        level.toString(),
        color: isOn
            ? theme.colorScheme.onSecondaryContainer
            : theme.colorScheme.onPrimaryContainer,
      ),
    );
  }
}

class _VisiblityFlag extends StatelessWidget {
  const _VisiblityFlag({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
