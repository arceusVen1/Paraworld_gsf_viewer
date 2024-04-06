import 'package:flutter/material.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/chunk_attributes.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/model_settings.dart';
import 'package:paraworld_gsf_viewer/widgets/header2/widgets/chunks/attributes/chunk_attributes.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/data_display.dart';

class MiscFlagsDisplay extends StatelessWidget {
  const MiscFlagsDisplay({
    super.key,
    required this.chunkAttributes,
    required this.onPress,
  });

  final ChunkAttributes chunkAttributes;
  final OnAttributePress? onPress;

  @override
  Widget build(BuildContext context) {
    final List<FlagBox> miscFlags = () {
      switch (chunkAttributes.typeOfModel) {
        case ModelType.wall:
        case ModelType.fiel:
        case ModelType.bldg:
          return [
            if (chunkAttributes.typeOfModel == ModelType.bldg) ...[
              FlagBox(
                label: "Unknown (resin_field_fire?)",
                attributes: chunkAttributes,
                indice: BldgAttributes.resinFieldFireIndice,
                onPress: onPress,
              )
            ],
            if (chunkAttributes.typeOfModel == ModelType.fiel) ...[
              FlagBox(
                label: "Unknown (resin_field_fire?)",
                attributes: chunkAttributes,
                indice: FielAttributes.resinFieldFireIndice,
                onPress: onPress,
              ),
            ],
            FlagBox(
              label: "Animate construction end",
              attributes: chunkAttributes,
              indice: BuildingAttributes.animateConEndIndice,
              onPress: onPress,
            ),
            FlagBox(
              label: "Animate construction start",
              attributes: chunkAttributes,
              indice: BuildingAttributes.animateConStartIndice,
              onPress: onPress,
            ),
            FlagBox(
              label: "Unknown (light collision?)",
              attributes: chunkAttributes,
              indice: BuildingAttributes.unknownIndice,
              onPress: onPress,
            ),
            FlagBox(
              label: "Use construction flags (useConFlags)",
              attributes: chunkAttributes,
              indice: BuildingAttributes.useConFlagsIndice,
              onPress: onPress,
            ),
            if (chunkAttributes.typeOfModel == ModelType.wall) ...[
              FlagBox(
                label: "Unknown bit 22",
                attributes: chunkAttributes,
                indice: WallAttributes.unknown2Indice,
                onPress: onPress,
              ),
            ],
          ];
        case ModelType.deko:
          return [
            FlagBox(
              label: "Unknown",
              attributes: chunkAttributes,
              indice: DekoAttributes.unknownIndice,
              onPress: onPress,
            ),
          ];
        case ModelType.vehi:
          return [
            FlagBox(
              label: "ram_high",
              attributes: chunkAttributes,
              indice: VehiAttributes.ramHighIndice,
              onPress: onPress,
            ),
            FlagBox(
              label: "ram_low",
              attributes: chunkAttributes,
              indice: VehiAttributes.ramLowIndice,
              onPress: onPress,
            ),
            FlagBox(
              label: "Unknown (light collision?)",
              attributes: chunkAttributes,
              indice: VehiAttributes.unknownIndice,
              onPress: onPress,
            ),
          ];
        case ModelType.misc:
          return [
            FlagBox(
              label: "Unknown (light collision?)",
              attributes: chunkAttributes,
              indice: MiscAttributes.unknownIndice,
              onPress: onPress,
            ),
          ];
        case ModelType.ship:
          return [
            FlagBox(
              label: "ram_high",
              attributes: chunkAttributes,
              indice: ShipAttributes.ramHighIndice,
              onPress: onPress,
            ),
            FlagBox(
              label: "ram_low",
              attributes: chunkAttributes,
              indice: ShipAttributes.ramLowIndice,
              onPress: onPress,
            ),
            FlagBox(
              label: "Use construction flags",
              attributes: chunkAttributes,
              indice: ShipAttributes.useConFlagsIndice,
              onPress: onPress,
            ),
            FlagBox(
              label: "Unknown (light collision?)",
              attributes: chunkAttributes,
              indice: ShipAttributes.unknownIndice,
              onPress: onPress,
            ),
          ];
        case ModelType.rivr:
          return [
            FlagBox(
              label: "Use water shader",
              attributes: chunkAttributes,
              indice: RivrAttributes.useWaterShaderIndice,
              onPress: onPress,
            ),
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
