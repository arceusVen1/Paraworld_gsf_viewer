import 'package:flutter/material.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/chunk_attributes.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/model_settings.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/data_display.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/label.dart';
import 'package:equatable/equatable.dart';
import 'package:gap/gap.dart';

class LevelFlagsDisplay extends StatelessWidget {
  const LevelFlagsDisplay({super.key, required this.chunkAttributes});

  final ChunkAttributes chunkAttributes;

  @override
  Widget build(BuildContext context) {
    final List<_LevelRow> miscFlags = () {
      switch (chunkAttributes.typeOfModel) {
        case ModelType.ress:
          final attributes = chunkAttributes as RessAttributes;
          return [
            _LevelRow(
              title: "res",
              levels: [
                _Level(label: "1", isOn: attributes.isRes1),
                _Level(label: "2", isOn: attributes.isRes2),
                _Level(label: "3", isOn: attributes.isRes3),
                _Level(label: "4", isOn: attributes.isRes4),
                _Level(label: "5", isOn: attributes.isRes5),
                _Level(label: "6", isOn: attributes.isRes6),
              ],
            )
          ];
        case ModelType.wall:
        case ModelType.bldg:
          final attributes = chunkAttributes as BldgAttributes;
          return [
            _LevelRow(
              title: "con",
              levels: [
                _Level(label: "0", isOn: attributes.isCon0),
                _Level(label: "1", isOn: attributes.isCon1),
                _Level(label: "2", isOn: attributes.isCon2),
                _Level(label: "3", isOn: attributes.isCon3),
                _Level(label: "4", isOn: attributes.isCon4),
              ],
            ),
            _LevelRow(
              title: "dest",
              levels: [
                _Level(label: "1", isOn: attributes.isDest1),
                _Level(label: "2", isOn: attributes.isDest2),
              ],
            )
          ];
        case ModelType.misc:
          final attributes = chunkAttributes as MiscAttributes;
          return [
            _LevelRow(
              title: "step",
              levels: [
                _Level(label: "0", isOn: attributes.isStep0),
                _Level(label: "1", isOn: attributes.isStep1),
                _Level(label: "2", isOn: attributes.isStep2),
              ],
            )
          ];
        case ModelType.towe:
          final attributes = chunkAttributes as ToweAttributes;
          return [
            _LevelRow(
              title: "zinnen",
              levels: [
                _Level(label: "1", isOn: attributes.isZinnen1),
                _Level(label: "2", isOn: attributes.isZinnen2),
                _Level(label: "3", isOn: attributes.isZinnen3),
                _Level(label: "4", isOn: attributes.isZinnen4),
                _Level(label: "5", isOn: attributes.isZinnen5),
                _Level(label: "6", isOn: attributes.isZinnen6),
                _Level(label: "7", isOn: attributes.isZinnen7),
                _Level(label: "8", isOn: attributes.isZinnen8),
                _Level(label: "9", isOn: attributes.isZinnen9),
              ],
            )
          ];
        case ModelType.ship:
          final attributes = chunkAttributes as ShipAttributes;
          return [
            _LevelRow(
              title: "dest",
              levels: [
                _Level(label: "1", isOn: attributes.isDest1),
                _Level(label: "2", isOn: attributes.isDest2),
              ],
            ),
            _LevelRow(
              title: "con",
              levels: [
                _Level(label: "4", isOn: attributes.isCon4),
              ],
            )
          ];
        default:
          return <_LevelRow>[];
      }
    }();

    return SectionWrapper(
      label: "Levels",
      children: miscFlags,
    );
  }
}

class LevelOfDetailsDisplay extends StatelessWidget {
  const LevelOfDetailsDisplay({
    super.key,
    required this.chunkAttributes,
  });

  final ChunkAttributes chunkAttributes;

  @override
  Widget build(BuildContext context) {
    final levels = <_Level>[
      _Level(label: "0", isOn: chunkAttributes.isLOD0),
      _Level(label: "1", isOn: chunkAttributes.isLOD1),
      _Level(label: "2", isOn: chunkAttributes.isLOD2),
      _Level(label: "3", isOn: chunkAttributes.isLOD3),
      _Level(label: "4", isOn: chunkAttributes.isLOD4),
    ];
    return _LevelRow(title: "LoD", levels: levels);
  }
}

class _Level extends Equatable {
  final String label;
  final bool isOn;

  const _Level({required this.label, required this.isOn});

  @override
  List<Object?> get props => [label, isOn];
}

class _LevelRow extends StatelessWidget {
  const _LevelRow({
    required this.title,
    required this.levels,
  });

  final String title;
  final List<_Level> levels;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Label.small(title),
        const Gap(8),
        ...levels.map((level) => _LevelWrapper(level: level)).toList(),
      ],
    );
  }
}

class _LevelWrapper extends StatelessWidget {
  const _LevelWrapper({
    required this.level,
  });

  final _Level level;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      clipBehavior: Clip.hardEdge,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: level.isOn
            ? theme.colorScheme.secondaryContainer
            : theme.colorScheme.primaryContainer,
        border: Border.all(color: Colors.black),
      ),
      child: Label.small(
        level.label,
        color: level.isOn
            ? theme.colorScheme.onSecondaryContainer
            : theme.colorScheme.onPrimaryContainer,
      ),
    );
  }
}