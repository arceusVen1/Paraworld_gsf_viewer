import 'package:flutter/material.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/chunk_attributes.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/model_settings.dart';
import 'package:paraworld_gsf_viewer/widgets/header2/widgets/chunks/attributes/chunk_attributes.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/data_display.dart';

class VisibilityFlagsDisplay extends StatelessWidget {
  const VisibilityFlagsDisplay({
    super.key,
    required this.chunkAttributes,
  });

  final ChunkAttributes chunkAttributes;
  @override
  Widget build(BuildContext context) {
    final List<FlagBox> visibilityFlags = () {
      switch (chunkAttributes.typeOfModel) {
        case ModelType.char:
          final attributes = chunkAttributes as CharAttributes;
          return [
            FlagBox(label: "Is legs (Legs)", isOn: attributes.isLegs),
            FlagBox(label: "Is body (Body)", isOn: attributes.isBody),
            FlagBox(label: "Is head (Head)", isOn: attributes.isHead),
            FlagBox(
              label: "Is selection volume",
              isOn: attributes.isSelectionVolume,
            ),
          ];
        case ModelType.ress:
          final attributes = chunkAttributes as RessAttributes;
          return [
            FlagBox(
                label: "Is selection volume",
                isOn: attributes.isSelectionVolume),
          ];
        case ModelType.wall:
        case ModelType.bldg:
          final attributes = chunkAttributes as BldgAttributes;
          return [
            FlagBox(label: "Is for night (Night)", isOn: attributes.isForNight),
            FlagBox(
              label: "Is selection volume",
              isOn: attributes.isSelectionVolume,
            ),
          ];
        case ModelType.anim:
          final attributes = chunkAttributes as AnimAttributes;
          return [
            FlagBox(label: "Is helmet (Helmet)", isOn: attributes.isHelmet),
            FlagBox(label: "Is saddle (Saddle)", isOn: attributes.isSaddle),
            FlagBox(label: "Is party color", isOn: attributes.isPartyColor),
            FlagBox(label: "Is armor saddle (Armorsaddle)", isOn: attributes.isArmorSaddle),
            FlagBox(label: "Is standarte (Standarte)", isOn: attributes.isStandard),
            FlagBox(label: "Is armor (Armor)", isOn: attributes.isArmor),
            FlagBox(label: "Is right leg (leg_re)", isOn: attributes.isRightLeg),
            FlagBox(label: "Is left leg (leg_li)", isOn: attributes.isLeftLeg),
            FlagBox(label: "Is right arm (arm_re)", isOn: attributes.isRightArm),
            FlagBox(label: "Is left arm (arm_li)", isOn: attributes.isLeftArm),
            FlagBox(label: "Is tail (tail)", isOn: attributes.isTail),
            FlagBox(label: "Is head (head)", isOn: attributes.isHead),
            FlagBox(label: "Is right belly (bauch_re)", isOn: attributes.isRightBelly),
            FlagBox(label: "Is left belly (bauch_li)", isOn: attributes.isLeftBelly),
          ];
        case ModelType.deko:
          final attributes = chunkAttributes as DekoAttributes;
          return [
            FlagBox(label: "Is sequence (Sequence)", isOn: attributes.isSequence),
            FlagBox(label: "Is for night (Night)", isOn: attributes.isForNight),
          ];
        case ModelType.vgtn:
          final attributes = chunkAttributes as VgtnAttributes;
          return [
            FlagBox(label: "Tree billboard", isOn: attributes.isTreeBillboard),
            FlagBox(
              label: "Is selection volume",
              isOn: attributes.isSelectionVolume,
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
