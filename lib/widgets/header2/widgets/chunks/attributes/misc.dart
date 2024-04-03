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
          final attributes = chunkAttributes as BuildingAttributes;
          return [
            if (chunkAttributes.typeOfModel == ModelType.bldg) ...[
              FlagBox(
                label: "Unknown (resin_field_fire?)",
                attributes: chunkAttributes,
                indice:
                    (chunkAttributes as BldgAttributes).resinFieldFireIndice,
                onPress: onPress,
              )
            ],
            if (chunkAttributes.typeOfModel == ModelType.fiel) ...[
              FlagBox(
                  label: "Unknown (resin_field_fire?)",
                  attributes: chunkAttributes,
                  indice:
                      (chunkAttributes as FielAttributes).resinFieldFireIndice,
                                      onPress: onPress,
),
            ],
            FlagBox(
              label: "Animate construction end",
              attributes: chunkAttributes,
              indice: attributes.animateConEndIndice,
                              onPress: onPress,

            ),
            FlagBox(
              label: "Animate construction start",
              attributes: chunkAttributes,
              indice: attributes.animateConStartIndice,
                              onPress: onPress,

            ),
            FlagBox(
              label: "Unknown (light collision?)",
              attributes: chunkAttributes,
              indice: attributes.unknownIndice,
                              onPress: onPress,

            ),
            FlagBox(
              label: "Use construction flags (useConFlags)",
              attributes: chunkAttributes,
              indice: attributes.useConFlagsIndice,
                              onPress: onPress,

            ),
            if (chunkAttributes.typeOfModel == ModelType.wall) ...[
              FlagBox(
                label: "Unknown bit 22",
                attributes: chunkAttributes,
                indice: (chunkAttributes as WallAttributes).unknown2Indice,
                                onPress: onPress,

              ),
            ],
          ];
        case ModelType.deko:
          final attributes = chunkAttributes as DekoAttributes;
          return [
            FlagBox(
              label: "Unknown",
              attributes: chunkAttributes,
              indice: attributes.unknownIndice,
                              onPress: onPress,

            ),
          ];
        case ModelType.vehi:
          final attributes = chunkAttributes as VehiAttributes;
          return [
            FlagBox(
              label: "ram_high",
              attributes: chunkAttributes,
              indice: attributes.ramHighIndice,
                              onPress: onPress,

            ),
            FlagBox(
              label: "ram_low",
              attributes: chunkAttributes,
              indice: attributes.ramLowIndice,
                              onPress: onPress,

            ),
            FlagBox(
              label: "Unknown (light collision?)",
              attributes: chunkAttributes,
              indice: attributes.unknownIndice,
                              onPress: onPress,

            ),
          ];
        case ModelType.misc:
          final attributes = chunkAttributes as MiscAttributes;
          return [
            FlagBox(
              label: "Unknown (light collision?)",
              attributes: chunkAttributes,
              indice: attributes.unknownIndice,
                              onPress: onPress,

            ),
          ];
        case ModelType.anim:
          final attributes = chunkAttributes as AnimAttributes;
          return [
            FlagBox(
              label: "Misc",
              attributes: chunkAttributes,
              indice: attributes.miscIndice,
                              onPress: onPress,

            ),
          ];
        case ModelType.ship:
          final attributes = chunkAttributes as ShipAttributes;
          return [
            FlagBox(
              label: "ram_high",
              attributes: chunkAttributes,
              indice: attributes.ramHighIndice,
                              onPress: onPress,

            ),
            FlagBox(
              label: "ram_low",
              attributes: chunkAttributes,
              indice: attributes.ramLowIndice,
                              onPress: onPress,

            ),
            FlagBox(
              label: "Use construction flags",
              attributes: chunkAttributes,
              indice: attributes.useConFlagsIndice,
                              onPress: onPress,

            ),
            FlagBox(
              label: "Unknown (light collision?)",
              attributes: chunkAttributes,
              indice: attributes.unknownIndice,
                              onPress: onPress,

            ),
          ];
        case ModelType.rivr:
          final attributes = chunkAttributes as RivrAttributes;
          return [
            FlagBox(
              label: "Use water shader",
              attributes: chunkAttributes,
              indice: attributes.useWaterShaderIndice,
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
