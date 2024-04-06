import 'package:flutter/material.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/chunk_attributes.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/model_settings.dart';
import 'package:paraworld_gsf_viewer/widgets/header2/widgets/chunks/attributes/chunk_attributes.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/data_display.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/label.dart';
import 'package:equatable/equatable.dart';
import 'package:gap/gap.dart';

class LevelFlagsDisplay extends StatelessWidget {
  const LevelFlagsDisplay({
    super.key,
    required this.chunkAttributes,
    required this.onPress,
  });

  final ChunkAttributes chunkAttributes;
  final OnAttributePress? onPress;

  @override
  Widget build(BuildContext context) {
    final List<_LevelRow> miscFlags = () {
      switch (chunkAttributes.typeOfModel) {
        case ModelType.ress:
          return [
            _LevelRow(
              title: "res:",
              attributes: chunkAttributes,
              levels: const [
                _Level(label: "1", indice: RessAttributes.res1Indice),
                _Level(label: "2", indice: RessAttributes.res2Indice),
                _Level(label: "3", indice: RessAttributes.res3Indice),
                _Level(label: "4", indice: RessAttributes.res4Indice),
                _Level(label: "5", indice: RessAttributes.res5Indice),
                _Level(label: "6", indice: RessAttributes.res6Indice),
              ],
              onPress: onPress,
            )
          ];
        case ModelType.wall:
        case ModelType.fiel:
        case ModelType.bldg:
          return [
            _LevelRow(
              title: "Con:",
              attributes: chunkAttributes,
              levels: const [
                _Level(label: "0", indice: BuildingAttributes.con0Indice),
                _Level(label: "1", indice: BuildingAttributes.con1Indice),
                _Level(label: "2", indice: BuildingAttributes.con2Indice),
                _Level(label: "3", indice: BuildingAttributes.con3Indice),
                _Level(label: "4", indice: BuildingAttributes.con4Indice),
              ],
              onPress: onPress,
            ),
            _LevelRow(
              title: "Dest:",
              attributes: chunkAttributes,
              levels: const [
                _Level(label: "1", indice: BuildingAttributes.dest1Indice),
                _Level(label: "2", indice: BuildingAttributes.dest2Indice),
              ],
              onPress: onPress,
            ),
            if (chunkAttributes.typeOfModel == ModelType.bldg)
              _LevelRow(
                title: "Age:",
                attributes: chunkAttributes,
                levels: const [
                  _Level(
                    label: "1",
                    indice: BldgAttributes.isAge1Indice,
                  ),
                  _Level(
                    label: "2",
                    indice: BldgAttributes.isAge2Indice,
                  ),
                  _Level(
                    label: "3",
                    indice: BldgAttributes.isAge3Indice,
                  ),
                  _Level(
                    label: "4",
                    indice: BldgAttributes.isAge4Indice,
                  ),
                  _Level(
                    label: "5",
                    indice: BldgAttributes.isAge5Indice,
                  ),
                ],
                onPress: onPress,
              ),
          ];
        case ModelType.misc:
          return [
            _LevelRow(
              title: "Misc_Step:",
              attributes: chunkAttributes,
              levels: const [
                _Level(label: "0", indice: MiscAttributes.isStep0Indice),
                _Level(label: "1", indice: MiscAttributes.isStep1Indice),
                _Level(label: "2", indice: MiscAttributes.isStep2Indice),
              ],
              onPress: onPress,
            )
          ];
        case ModelType.towe:
          return [
            _LevelRow(
              title: "Zinnen:",
              attributes: chunkAttributes,
              levels: const [
                _Level(label: "1", indice: ToweAttributes.zinnen1Indice),
                _Level(label: "2", indice: ToweAttributes.zinnen2Indice),
                _Level(label: "3", indice: ToweAttributes.zinnen3Indice),
                _Level(label: "4", indice: ToweAttributes.zinnen4Indice),
                _Level(label: "5", indice: ToweAttributes.zinnen5Indice),
                _Level(label: "6", indice: ToweAttributes.zinnen6Indice),
                _Level(label: "7", indice: ToweAttributes.zinnen7Indice),
                _Level(label: "8", indice: ToweAttributes.zinnen8Indice),
                _Level(label: "9", indice: ToweAttributes.zinnen9Indice),
              ],
              onPress: onPress,
            )
          ];
        case ModelType.ship:
          return [
            _LevelRow(
              title: "Dest:",
              attributes: chunkAttributes,
              levels: const [
                _Level(label: "1", indice: ShipAttributes.isDest1Indice),
                _Level(label: "2", indice: ShipAttributes.isDest2Indice),
              ],
              onPress: onPress,
            ),
            _LevelRow(
              title: "Con:",
              attributes: chunkAttributes,
              levels: const [
                _Level(label: "4", indice: ShipAttributes.isCon4Indice),
              ],
              onPress: onPress,
            )
          ];
        default:
          return <_LevelRow>[];
      }
    }();

    return SectionWrapper(
      label: "Flags",
      children: miscFlags,
    );
  }
}

class LevelOfDetailsDisplay extends StatelessWidget {
  const LevelOfDetailsDisplay({
    super.key,
    required this.chunkAttributes,
    required this.onPress,
  });

  final ChunkAttributes chunkAttributes;
  final OnAttributePress? onPress;

  @override
  Widget build(BuildContext context) {
    const levels = <_Level>[
      _Level(label: "0", indice: ChunkAttributes.lod0Indice),
      _Level(label: "1", indice: ChunkAttributes.lod1Indice),
      _Level(label: "2", indice: ChunkAttributes.lod2Indice),
      _Level(label: "3", indice: ChunkAttributes.lod3Indice),
      _Level(label: "4", indice: ChunkAttributes.lod4Indice),
    ];
    return _LevelRow(
      title: "LoD:",
      attributes: chunkAttributes,
      levels: levels,
      onPress: onPress,
    );
  }
}

class _Level extends Equatable {
  final String label;
  final int indice;

  const _Level({required this.label, required this.indice});

  @override
  List<Object?> get props => [label, indice];
}

class _LevelRow extends StatelessWidget {
  const _LevelRow({
    required this.title,
    required this.attributes,
    required this.levels,
    required this.onPress,
  });

  final String title;
  final ChunkAttributes attributes;
  final List<_Level> levels;
  final OnAttributePress? onPress;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Label.small(title),
        const Gap(8),
        ...levels
            .map((level) => _LevelWrapper(
                  level: level,
                  attributes: attributes,
                  onPress: onPress,
                ))
            .toList(),
      ],
    );
  }
}

class _LevelWrapper extends StatelessWidget {
  const _LevelWrapper({
    required this.level,
    required this.attributes,
    required this.onPress,
  });

  final _Level level;
  final ChunkAttributes attributes;
  final OnAttributePress? onPress;

  @override
  Widget build(BuildContext context) {
    final isOn = attributes.isFlagOn(level.indice);
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => onPress?.call(level.indice),
      child: Container(
        clipBehavior: Clip.hardEdge,
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
        decoration: BoxDecoration(
          color:
              isOn ? theme.colorScheme.secondary : theme.colorScheme.background,
          border: Border.all(color: theme.colorScheme.onBackground),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Label.small(
          level.label,
          color: theme.colorScheme.onBackground,
        ),
      ),
    );
  }
}
