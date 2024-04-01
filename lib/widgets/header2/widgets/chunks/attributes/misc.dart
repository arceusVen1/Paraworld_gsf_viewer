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
        case ModelType.fiel:
        case ModelType.bldg:
          final attributes = chunkAttributes as BuildingAttributes;
          return [
            if (chunkAttributes.typeOfModel == ModelType.bldg) ...[
              FlagBox(
                  label: "Unknown (resin_field_fire?)",
                  isOn: (chunkAttributes as BldgAttributes).resinFieldFire),
            ],
            if (chunkAttributes.typeOfModel == ModelType.fiel) ...[
              FlagBox(
                  label: "Unknown (resin_field_fire?)",
                  isOn: (chunkAttributes as FielAttributes).resinFieldFire),
            ],
            FlagBox(
                label: "Animate construction end",
                isOn: attributes.animateConEnd),
            FlagBox(
                label: "Animate construction start",
                isOn: attributes.animateConStart),
            FlagBox(
                label: "Unknown (light collision?)", isOn: attributes.unknown),
            FlagBox(
                label: "Use construction flags (useConFlags)",
                isOn: attributes.useConFlags),
            if (chunkAttributes.typeOfModel == ModelType.wall) ...[
              FlagBox(
                  label: "Unknown bit 22",
                  isOn: (chunkAttributes as WallAttributes).unknown2),
            ],
          ];
        case ModelType.deko:
          final attributes = chunkAttributes as DekoAttributes;
          return [
            FlagBox(label: "Unknown", isOn: attributes.unknown),
          ];
        case ModelType.vehi:
          final attributes = chunkAttributes as VehiAttributes;
          return [
            FlagBox(label: "ram_high", isOn: attributes.ramHigh),
            FlagBox(label: "ram_low", isOn: attributes.ramLow),
            FlagBox(
                label: "Unknown (light collision?)", isOn: attributes.unknown),
          ];
        case ModelType.misc:
          final attributes = chunkAttributes as MiscAttributes;
          return [
            FlagBox(
                label: "Unknown (light collision?)", isOn: attributes.unknown),
          ];
        case ModelType.anim:
          final attributes = chunkAttributes as AnimAttributes;
          return [
            FlagBox(label: "Misc", isOn: attributes.misc),
          ];
        case ModelType.ship:
          final attributes = chunkAttributes as ShipAttributes;
          return [
            FlagBox(label: "ram_high", isOn: attributes.ramHigh),
            FlagBox(label: "ram_low", isOn: attributes.ramLow),
            FlagBox(
                label: "Use construction flags", isOn: attributes.useConFlags),
            FlagBox(
                label: "Unknown (light collision?)", isOn: attributes.unknown),
          ];
        case ModelType.rivr:
          final attributes = chunkAttributes as RivrAttributes;
          return [
            FlagBox(label: "Use water shader", isOn: attributes.useWaterShader),
          ];
        default:
          return <FlagBox>[];
      }
    }();

    return SectionWrapper(
      label: "Misc flags",
      children: miscFlags,
    );
  }
}
