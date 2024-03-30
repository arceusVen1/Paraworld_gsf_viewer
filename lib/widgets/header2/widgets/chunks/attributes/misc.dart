import 'package:flutter/material.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/chunk_attributes.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/model_settings.dart';
import 'package:paraworld_gsf_viewer/widgets/header2/widgets/chunks/attributes/chunk_attributes.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/data_display.dart';

class MiscFlagsDisplay extends StatelessWidget {
  const MiscFlagsDisplay({
    super.key,
    required this.chunkAttributes,
  });

  final ChunkAttributes chunkAttributes;
  @override
  Widget build(BuildContext context) {
    final List<FlagBox> miscFlags = () {
      switch (chunkAttributes.typeOfModel) {
        case ModelType.wall:
        case ModelType.bldg:
          final attributes = chunkAttributes as BldgAttributes;
          return [
            FlagBox(label: "animate con end", isOn: attributes.animateConEnd),
            FlagBox(
                label: "animate con start", isOn: attributes.animateConStart),
            FlagBox(label: "unknown", isOn: attributes.unknown),
          ];

        case ModelType.vehi:
          final attributes = chunkAttributes as VehiAttributes;
          return [
            FlagBox(label: "ram high", isOn: attributes.ramHigh),
            FlagBox(label: "ram low", isOn: attributes.ramLow),
            FlagBox(label: "unknown", isOn: attributes.unknown),
          ];
        case ModelType.misc:
          final attributes = chunkAttributes as MiscAttributes;
          return [
            FlagBox(label: "unknown", isOn: attributes.unknown),
          ];
        case ModelType.anim:
          final attributes = chunkAttributes as AnimAttributes;
          return [
            FlagBox(label: "misc", isOn: attributes.misc),
          ];
        case ModelType.ship:
          final attributes = chunkAttributes as ShipAttributes;
          return [
            FlagBox(label: "ram high", isOn: attributes.ramHigh),
            FlagBox(label: "ram low", isOn: attributes.ramLow),
            FlagBox(label: "use con flags", isOn: attributes.useConFlags),
            FlagBox(label: "unknown", isOn: attributes.unknown),
          ];
        case ModelType.rivr:
          final attributes = chunkAttributes as RivrAttributes;
          return [
            FlagBox(label: "use water shader", isOn: attributes.useWaterShader),
          ];
        default:
          return <FlagBox>[];
      }
    }();

    return SectionWrapper(
      label: "Misc Flags",
      children: miscFlags,
    );
  }
}
