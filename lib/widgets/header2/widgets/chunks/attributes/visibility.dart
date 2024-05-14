import 'package:flutter/material.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/chunk_attributes.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/model_settings.dart';
import 'package:paraworld_gsf_viewer/widgets/header2/widgets/chunks/attributes/chunk_attributes.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/data_display.dart';

class VisibilityFlagsDisplay extends StatelessWidget {
  const VisibilityFlagsDisplay({
    super.key,
    required this.chunkAttributes,
    required this.onPress,
  });

  final ChunkAttributes chunkAttributes;
  final OnAttributePress? onPress;

  @override
  Widget build(BuildContext context) {
    final List<FlagBox> visibilityFlags = () {
      switch (chunkAttributes.typeOfModel) {
        case ModelType.char:
          return [
            FlagBox(
              label: "Legs",
              attributes: chunkAttributes,
              indice: CharAttributes.legIndice,
              onPress: onPress,
            ),
            FlagBox(
              label: "Body",
              attributes: chunkAttributes,
              indice: CharAttributes.bodyIndice,
              onPress: onPress,
            ),
            FlagBox(
              label: "Head",
              attributes: chunkAttributes,
              indice: CharAttributes.headIndice,
              onPress: onPress,
            ),
            FlagBox(
              label: "Selection volume",
              attributes: chunkAttributes,
              indice: CharAttributes.selectionVolumeIndice,
              onPress: onPress,
            ),
          ];
        case ModelType.ress:
          return [
            FlagBox(
              label: "Selection volume",
              attributes: chunkAttributes,
              indice: RessAttributes.selectionVolumeIndice,
              onPress: onPress,
            ),
          ];
        case ModelType.bldg:
          return [
            FlagBox(
              label: "Night",
              attributes: chunkAttributes,
              indice: BldgAttributes.isForNightIndice,
              onPress: onPress,
            ),
            FlagBox(
              label: "Light collision",
              attributes: chunkAttributes,
              indice: ShipAttributes.isShadowModelIndice,
              onPress: onPress,
            ),
            FlagBox(
              label: "Selection volume",
              attributes: chunkAttributes,
              indice: BldgAttributes.isSelectionVolumeIndice,
              onPress: onPress,
            ),
          ];
        case ModelType.fiel:
          return [
            FlagBox(
              label: "Light collision",
              attributes: chunkAttributes,
              indice: ShipAttributes.isShadowModelIndice,
              onPress: onPress,
            ),
            FlagBox(
              label: "Selection volume",
              attributes: chunkAttributes,
              indice: FielAttributes.isSelectionVolumeIndice,
              onPress: onPress,
            ),
          ];
        case ModelType.anim:
          return [
            FlagBox(
              label: "Misc",
              attributes: chunkAttributes,
              indice: AnimAttributes.miscIndice,
              onPress: onPress,
            ),
            FlagBox(
              label: "Helmet",
              attributes: chunkAttributes,
              indice: AnimAttributes.isHelmetIndice,
              onPress: onPress,
            ),
            FlagBox(
              label: "Saddle",
              attributes: chunkAttributes,
              indice: AnimAttributes.isSaddleIndice,
              onPress: onPress,
            ),
            FlagBox(
              label: "PartyСol",
              attributes: chunkAttributes,
              indice: AnimAttributes.isPartyColorIndice,
              onPress: onPress,
            ),
            FlagBox(
              label: "Armorsaddle",
              attributes: chunkAttributes,
              indice: AnimAttributes.isArmorSaddleIndice,
              onPress: onPress,
            ),
            FlagBox(
              label: "Standarte",
              attributes: chunkAttributes,
              indice: AnimAttributes.isStandardIndice,
              onPress: onPress,
            ),
            FlagBox(
              label: "Armor",
              attributes: chunkAttributes,
              indice: AnimAttributes.isArmorIndice,
              onPress: onPress,
            ),
            FlagBox(
              label: "leg_re",
              attributes: chunkAttributes,
              indice: AnimAttributes.isRightLegIndice,
              onPress: onPress,
            ),
            FlagBox(
              label: "leg_li",
              attributes: chunkAttributes,
              indice: AnimAttributes.isLeftLegIndice,
              onPress: onPress,
            ),
            FlagBox(
              label: "arm_re",
              attributes: chunkAttributes,
              indice: AnimAttributes.isRightArmIndice,
              onPress: onPress,
            ),
            FlagBox(
              label: "arm_li",
              attributes: chunkAttributes,
              indice: AnimAttributes.isLeftArmIndice,
              onPress: onPress,
            ),
            FlagBox(
              label: "tail",
              attributes: chunkAttributes,
              indice: AnimAttributes.isTailIndice,
              onPress: onPress,
            ),
            FlagBox(
              label: "head",
              attributes: chunkAttributes,
              indice: AnimAttributes.isHeadIndice,
              onPress: onPress,
            ),
            FlagBox(
              label: "bauch_re",
              attributes: chunkAttributes,
              indice: AnimAttributes.isRightBellyIndice,
              onPress: onPress,
            ),
            FlagBox(
              label: "bauch_li",
              attributes: chunkAttributes,
              indice: AnimAttributes.isLeftBellyIndice,
              onPress: onPress,
            ),
            FlagBox(
              label: "Selection volume",
              attributes: chunkAttributes,
              indice: AnimAttributes.selectionVolumeIndice,
              onPress: onPress,
            ),
          ];
        case ModelType.deko:
          return [
            FlagBox(
              label: "Sequence",
              attributes: chunkAttributes,
              indice: DekoAttributes.isSequenceIndice,
              onPress: onPress,
            ),
            FlagBox(
              label: "Night",
              attributes: chunkAttributes,
              indice: DekoAttributes.isForNightIndice,
              onPress: onPress,
            ),
            FlagBox(
              label: "Light collision",
              attributes: chunkAttributes,
              indice: ShipAttributes.isShadowModelIndice,
              onPress: onPress,
            ),
          ];
        case ModelType.vehi:
          return [
            FlagBox(
              label: "Light collision",
              attributes: chunkAttributes,
              indice: ShipAttributes.isShadowModelIndice,
              onPress: onPress,
            ),
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
          ];
        case ModelType.ship:
          return [
            FlagBox(
              label: "Light collision",
              attributes: chunkAttributes,
              indice: ShipAttributes.isShadowModelIndice,
              onPress: onPress,
            ),
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
          ];
        case ModelType.misc:
          return [
            FlagBox(
              label: "Light collision",
              attributes: chunkAttributes,
              indice: ShipAttributes.isShadowModelIndice,
              onPress: onPress,
            ),
            FlagBox(
              label: "Selection volume",
              attributes: chunkAttributes,
              indice: MiscAttributes.isSelectionVolumeIndice,
              onPress: onPress,
            ),
          ];
        case ModelType.vgtn:
          return [
            FlagBox(
              label: "Tree billboard",
              attributes: chunkAttributes,
              indice: VgtnAttributes.isTreeBillboardIndice,
              onPress: onPress,
            ),
            FlagBox(
              label: "Selection volume",
              attributes: chunkAttributes,
              indice: VgtnAttributes.isSelectionVolumeIndice,
              onPress: onPress,
            ),
          ];
        default:
          return <FlagBox>[];
      }
    }();

    return SectionWrapper(
      label: "Visibility Flags",
      children: visibilityFlags,
    );
  }
}
