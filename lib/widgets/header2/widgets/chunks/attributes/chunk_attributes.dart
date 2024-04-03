import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/chunk_attributes.dart';
import 'package:paraworld_gsf_viewer/widgets/header2/providers.dart';
import 'package:paraworld_gsf_viewer/widgets/header2/widgets/chunks/attributes/levels.dart';
import 'package:paraworld_gsf_viewer/widgets/header2/widgets/chunks/attributes/misc.dart';
import 'package:paraworld_gsf_viewer/widgets/header2/widgets/chunks/attributes/unknown.dart';
import 'package:paraworld_gsf_viewer/widgets/header2/widgets/chunks/attributes/visibility.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/label.dart';

class ChunkAttributesFromHeader2WrapperDisplay extends ConsumerWidget {
  const ChunkAttributesFromHeader2WrapperDisplay({
    super.key,
    required this.attributesValue,
  });
  final int attributesValue;

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
        ChunkAttributes.fromValue(currentModelType, attributesValue);
    return ChunkAttributesDisplay(
      attributes: chunkAttributes,
    );
  }
}

typedef OnAttributePress = void Function(int);

class ChunkAttributesDisplay extends StatelessWidget {
  const ChunkAttributesDisplay({
    super.key,
    required this.attributes,
    this.onAttributePress,
  });

  final ChunkAttributes attributes;
  final OnAttributePress? onAttributePress;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LevelOfDetailsDisplay(
          chunkAttributes: attributes,
          onPress: onAttributePress,
        ),
        const Gap(10),
        LevelFlagsDisplay(
          chunkAttributes: attributes,
          onPress: onAttributePress,
        ),
        VisibilityFlagsDisplay(
          chunkAttributes: attributes,
          onPress: onAttributePress,
        ),
        MiscFlagsDisplay(
          chunkAttributes: attributes,
          onPress: onAttributePress,
        ),
        UnknownFlagsDisplay(chunkAttributes: attributes),
      ],
    );
  }
}

class FlagBox extends StatelessWidget {
  const FlagBox({
    super.key,
    required this.label,
    required this.indice,
    required this.attributes,
    required this.onPress,
  });

  final String label;
  final int indice;
  final ChunkAttributes attributes;
  final OnAttributePress? onPress;

  @override
  Widget build(BuildContext context) {
    final isOn = attributes.isFlagOn(indice);
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {
        onPress?.call(indice);
      },
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        decoration: BoxDecoration(
          color:
              isOn ? theme.colorScheme.secondary : theme.colorScheme.background,
          border: Border.all(color: theme.colorScheme.onBackground),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Label.small(
          label,
          color: theme.colorScheme.onBackground,
        ),
      ),
    );
  }
}
