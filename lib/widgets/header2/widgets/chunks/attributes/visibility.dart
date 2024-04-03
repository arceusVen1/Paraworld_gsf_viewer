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
          final attributes = chunkAttributes as CharAttributes;
          return [
            FlagBox(
              label: "Is legs (Legs)",
              attributes: attributes,
              indice: attributes.legIndice,
              onPress: onPress,
            ),
            FlagBox(
              label: "Is body (Body)",
              attributes: attributes,
              indice: attributes.bodyIndice,
              onPress: onPress,
            ),
            FlagBox(
              label: "Is head (Head)",
              attributes: attributes,
              indice: attributes.headIndice,
              onPress: onPress,
            ),
            FlagBox(
              label: "Is selection volume",
              attributes: attributes,
              indice: attributes.selectionVolumeIndice,
              onPress: onPress,
            ),
          ];
        case ModelType.ress:
          final attributes = chunkAttributes as RessAttributes;
          return [
            FlagBox(
              label: "Is selection volume",
              attributes: attributes,
              indice: attributes.selectionVolumeIndice,
              onPress: onPress,
            ),
          ];
        case ModelType.bldg:
          final attributes = chunkAttributes as BldgAttributes;
          return [
            FlagBox(
              label: "Is for night (Night)",
              attributes: attributes,
              indice: attributes.isForNightIndice,
              onPress: onPress,
            ),
            FlagBox(
              label: "Is selection volume",
              attributes: attributes,
              indice: attributes.isSelectionVolumeIndice,
              onPress: onPress,
            ),
          ];
        case ModelType.fiel:
          final attributes = chunkAttributes as FielAttributes;
          return [
            FlagBox(
              label: "Is selection volume",
              attributes: attributes,
              indice: attributes.isSelectionVolumeIndice,
              onPress: onPress,
            ),
          ];
        case ModelType.anim:
          final attributes = chunkAttributes as AnimAttributes;
          return [
            FlagBox(
              label: "Is helmet (Helmet)",
              attributes: attributes,
              indice: attributes.isHelmetIndice,
              onPress: onPress,
            ),
            FlagBox(
              label: "Is saddle (Saddle)",
              attributes: attributes,
              indice: attributes.isSaddleIndice,
              onPress: onPress,
            ),
            FlagBox(
              label: "Is party color",
              attributes: attributes,
              indice: attributes.isPartyColorIndice,
              onPress: onPress,
            ),
            FlagBox(
              label: "Is armor saddle (Armorsaddle)",
              attributes: attributes,
              indice: attributes.isArmorSaddleIndice,
              onPress: onPress,
            ),
            FlagBox(
              label: "Is standarte (Standarte)",
              attributes: attributes,
              indice: attributes.isStandardIndice,
              onPress: onPress,
            ),
            FlagBox(
              label: "Is armor (Armor)",
              attributes: attributes,
              indice: attributes.isArmorIndice,
              onPress: onPress,
            ),
            FlagBox(
              label: "Is right leg (leg_re)",
              attributes: attributes,
              indice: attributes.isRightLegIndice,
              onPress: onPress,
            ),
            FlagBox(
              label: "Is left leg (leg_li)",
              attributes: attributes,
              indice: attributes.isLeftLegIndice,
              onPress: onPress,
            ),
            FlagBox(
              label: "Is right arm (arm_re)",
              attributes: attributes,
              indice: attributes.isRightArmIndice,
              onPress: onPress,
            ),
            FlagBox(
              label: "Is left arm (arm_li)",
              attributes: attributes,
              indice: attributes.isLeftArmIndice,
              onPress: onPress,
            ),
            FlagBox(
              label: "Is tail (tail)",
              attributes: attributes,
              indice: attributes.isTailIndice,
              onPress: onPress,
            ),
            FlagBox(
              label: "Is head (head)",
              attributes: attributes,
              indice: attributes.isHeadIndice,
              onPress: onPress,
            ),
            FlagBox(
              label: "Is right belly (bauch_re)",
              attributes: attributes,
              indice: attributes.isRightBellyIndice,
              onPress: onPress,
            ),
            FlagBox(
              label: "Is left belly (bauch_li)",
              attributes: attributes,
              indice: attributes.isLeftBellyIndice,
              onPress: onPress,
            ),
            FlagBox(
              label: "is Selection Volume",
              attributes: attributes,
              indice: attributes.selectionVolumeIndice,
              onPress: onPress,
            ),
          ];
        case ModelType.deko:
          final attributes = chunkAttributes as DekoAttributes;
          return [
            FlagBox(
              label: "Is sequence (Sequence)",
              attributes: attributes,
              indice: attributes.isSequenceIndice,
              onPress: onPress,
            ),
            FlagBox(
              label: "Is for night (Night)",
              attributes: attributes,
              indice: attributes.isForNightIndice,
              onPress: onPress,
            ),
          ];
        case ModelType.misc:
          final attributes = chunkAttributes as MiscAttributes;
          return [
            FlagBox(
              label: "Is selection volume",
              attributes: attributes,
              indice: attributes.isSelectionVolumeIndice,
              onPress: onPress,
            ),
          ];
        case ModelType.vgtn:
          final attributes = chunkAttributes as VgtnAttributes;
          return [
            FlagBox(
              label: "Tree billboard",
              attributes: attributes,
              indice: attributes.isTreeBillboardIndice,
              onPress: onPress,
            ),
            FlagBox(
              label: "Is selection volume",
              attributes: attributes,
              indice: attributes.isSelectionVolumeIndice,
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
