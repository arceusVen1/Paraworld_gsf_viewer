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
            FlagBox(label: "is legs", isOn: attributes.isLegs),
            FlagBox(label: "is body", isOn: attributes.isBody),
            FlagBox(label: "is is head", isOn: attributes.isHead),
            FlagBox(
              label: "is selection volume",
              isOn: attributes.isSelectionVolume,
            ),
          ];
        case ModelType.ress:
          final attributes = chunkAttributes as RessAttributes;
          return [
            FlagBox(
                label: "is selection volume",
                isOn: attributes.isSelectionVolume),
          ];
        case ModelType.wall:
        case ModelType.bldg:
          final attributes = chunkAttributes as BldgAttributes;
          return [
            FlagBox(label: "is for night", isOn: attributes.isForNight),
            FlagBox(
              label: "is selection volume",
              isOn: attributes.isSelectionVolume,
            ),
          ];
        case ModelType.anim:
          final attributes = chunkAttributes as AnimAttributes;
          return [
            FlagBox(label: "is helmet", isOn: attributes.isHelmet),
            FlagBox(label: "is saddle", isOn: attributes.isSaddle),
            FlagBox(label: "is isPartyColor", isOn: attributes.isPartyColor),
            FlagBox(label: "is Armor Saddle", isOn: attributes.isArmorSaddle),
            FlagBox(label: "is Standard", isOn: attributes.isStandard),
            FlagBox(label: "is Armor", isOn: attributes.isArmor),
            FlagBox(label: "is right leg", isOn: attributes.isRightLeg),
            FlagBox(label: "is left leg", isOn: attributes.isLeftLeg),
            FlagBox(label: "is right arm", isOn: attributes.isRightArm),
            FlagBox(label: "is left arm", isOn: attributes.isLeftArm),
            FlagBox(label: "is tail", isOn: attributes.isTail),
            FlagBox(label: "is head", isOn: attributes.isHead),
            FlagBox(label: "is right belly", isOn: attributes.isRightBelly),
            FlagBox(label: "is left belly", isOn: attributes.isLeftBelly),
          ];
        case ModelType.deko:
          final attributes = chunkAttributes as DekoAttributes;
          return [
            FlagBox(label: "is sequence", isOn: attributes.isSequence),
            FlagBox(label: "is for night", isOn: attributes.isForNight),
          ];
        case ModelType.vgtn:
          final attributes = chunkAttributes as VgtnAttributes;
          return [
            FlagBox(label: "treebillboard", isOn: attributes.isTreeBillboard),
            FlagBox(
              label: "is selection volume",
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
