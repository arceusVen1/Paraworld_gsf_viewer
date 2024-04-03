import 'package:flutter/material.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/chunk_attributes.dart';
import 'package:paraworld_gsf_viewer/widgets/header2/widgets/chunks/attributes/chunk_attributes.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/data_display.dart';

class UnknownFlagsDisplay extends StatelessWidget {
  const UnknownFlagsDisplay({
    super.key,
    required this.chunkAttributes,
  });

  final ChunkAttributes chunkAttributes;
  @override
  Widget build(BuildContext context) {
    final List<FlagBox> unknownFlags = chunkAttributes.unknownBits
        .map(
          (indice) => FlagBox(
            label: "Unknown bit ${indice + 1}",
            indice: indice,
            attributes: chunkAttributes,
            onPress: null,
          ),
        )
        .toList();

    return SectionWrapper(
      label: "Unknown flags",
      children: unknownFlags,
    );
  }
}
