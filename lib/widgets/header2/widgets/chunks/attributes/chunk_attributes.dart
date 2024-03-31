import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/chunk_attributes.dart';
import 'package:paraworld_gsf_viewer/widgets/header2/providers.dart';
import 'package:paraworld_gsf_viewer/widgets/header2/widgets/chunks/attributes/levels.dart';
import 'package:paraworld_gsf_viewer/widgets/header2/widgets/chunks/attributes/misc.dart';
import 'package:paraworld_gsf_viewer/widgets/header2/widgets/chunks/attributes/visibility..dart';
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
            LevelOfDetailsDisplay(
              chunkAttributes: chunkAttributes,
            ),
            Gap(10),
            LevelFlagsDisplay(chunkAttributes: chunkAttributes),
            VisibilityFlagsDisplay(
              chunkAttributes: chunkAttributes,
            ),
            MiscFlagsDisplay(
              chunkAttributes: chunkAttributes,
            ),
          ],
        ));
  }
}

class FlagBox extends StatelessWidget {
  const FlagBox({
    super.key,
    required this.label,
    required this.isOn,
  });

  final String label;
  final bool isOn;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      decoration: BoxDecoration(
        color: isOn
            ? theme.colorScheme.secondaryContainer
            : theme.colorScheme.surfaceVariant,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Label.small(
        label,
        color: isOn
            ? theme.colorScheme.onSecondaryContainer
            : theme.colorScheme.onSurfaceVariant,
      ),
    );
  }
}