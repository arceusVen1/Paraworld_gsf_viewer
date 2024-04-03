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
          final attributes = chunkAttributes as RessAttributes;
          return [
            _LevelRow(
              title: "res:",
              attributes: chunkAttributes,
              levels: [
                _Level(label: "1", indice: attributes.res1Indice),
                _Level(label: "2", indice: attributes.res2Indice),
                _Level(label: "3", indice: attributes.res3Indice),
                _Level(label: "4", indice: attributes.res4Indice),
                _Level(label: "5", indice: attributes.res5Indice),
                _Level(label: "6", indice: attributes.res6Indice),
              ],
              onPress: onPress,
            )
          ];
        case ModelType.wall:
        case ModelType.fiel:
        case ModelType.bldg:
          final attributes = chunkAttributes as BuildingAttributes;
          return [
            _LevelRow(
              title: "Con:",
              attributes: chunkAttributes,
              levels: [
                _Level(label: "0", indice: attributes.con0Indice),
                _Level(label: "1", indice: attributes.con1Indice),
                _Level(label: "2", indice: attributes.con2Indice),
                _Level(label: "3", indice: attributes.con3Indice),
                _Level(label: "4", indice: attributes.con4Indice),
              ],
              onPress: onPress,
            ),
            _LevelRow(
              title: "Dest:",
              attributes: chunkAttributes,
              levels: [
                _Level(label: "1", indice: attributes.dest1Indice),
                _Level(label: "2", indice: attributes.dest2Indice),
              ],
              onPress: onPress,
            ),
            if (chunkAttributes.typeOfModel == ModelType.bldg)
              _LevelRow(
                title: "Age:",
                attributes: chunkAttributes,
                levels: [
                  _Level(
                    label: "1",
                    indice: (chunkAttributes as BldgAttributes).isAge1Indice,
                  ),
                  _Level(
                    label: "2",
                    indice: (chunkAttributes as BldgAttributes).isAge2Indice,
                  ),
                  _Level(
                    label: "3",
                    indice: (chunkAttributes as BldgAttributes).isAge3Indice,
                  ),
                  _Level(
                    label: "4",
                    indice: (chunkAttributes as BldgAttributes).isAge4Indice,
                  ),
                  _Level(
                    label: "5",
                    indice: (chunkAttributes as BldgAttributes).isAge5Indice,
                  ),
                ],
                onPress: onPress,
              ),
          ];
        case ModelType.misc:
          final attributes = chunkAttributes as MiscAttributes;
          return [
            _LevelRow(
              title: "Misc_Step:",
              attributes: chunkAttributes,
              levels: [
                _Level(label: "0", indice: attributes.isStep0Indice),
                _Level(label: "1", indice: attributes.isStep1Indice),
                _Level(label: "2", indice: attributes.isStep2Indice),
              ],
              onPress: onPress,
            )
          ];
        case ModelType.towe:
          final attributes = chunkAttributes as ToweAttributes;
          return [
            _LevelRow(
              title: "Zinnen:",
              attributes: chunkAttributes,
              levels: [
                _Level(label: "1", indice: attributes.zinnen1Indice),
                _Level(label: "2", indice: attributes.zinnen2Indice),
                _Level(label: "3", indice: attributes.zinnen3Indice),
                _Level(label: "4", indice: attributes.zinnen4Indice),
                _Level(label: "5", indice: attributes.zinnen5Indice),
                _Level(label: "6", indice: attributes.zinnen6Indice),
                _Level(label: "7", indice: attributes.zinnen7Indice),
                _Level(label: "8", indice: attributes.zinnen8Indice),
                _Level(label: "9", indice: attributes.zinnen9Indice),
              ],
              onPress: onPress,
            )
          ];
        case ModelType.ship:
          final attributes = chunkAttributes as ShipAttributes;
          return [
            _LevelRow(
              title: "Dest:",
              attributes: chunkAttributes,
              levels: [
                _Level(label: "1", indice: attributes.isDest1Indice),
                _Level(label: "2", indice: attributes.isDest2Indice),
              ],
              onPress: onPress,
            ),
            _LevelRow(
              title: "Con:",
              attributes: chunkAttributes,
              levels: [
                _Level(label: "4", indice: attributes.isCon4Indice),
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
    final levels = <_Level>[
      _Level(label: "0", indice: chunkAttributes.lod0Indice),
      _Level(label: "1", indice: chunkAttributes.lod1Indice),
      _Level(label: "2", indice: chunkAttributes.lod2Indice),
      _Level(label: "3", indice: chunkAttributes.lod3Indice),
      _Level(label: "4", indice: chunkAttributes.lod4Indice),
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
          color: isOn
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.background,
          border: Border.all(color: theme.colorScheme.outline),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Label.small(
          level.label,
          color: isOn
              ? theme.colorScheme.onPrimaryContainer
              : theme.colorScheme.onBackground,
        ),
      ),
    );
  }
}
