import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/collision_struct.dart';
import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';
import 'package:paraworld_gsf_viewer/widgets/header2/providers.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/data_display.dart';

class PathFinderDisplay extends ConsumerWidget {
  const PathFinderDisplay({
    super.key,
    required this.offset,
    required this.count,
    required this.pathFinderTable,
  });

  final Standard4BytesData<int> offset;
  final Standard4BytesData<int> count;
  final PathFinderTable? pathFinderTable;

  @override
  Widget build(BuildContext context, ref) {
    return SectionWrapper(label: "Path Finder Table", children: [
      GsfDataTile(label: 'Offset', data: offset),
      GsfDataTile(
        label: 'Count',
        data: count,
      ),
      if (pathFinderTable != null)
        PartSelector(
          value: ref
              .watch(header2StateNotifierProvider)
              .mapOrNull(withModelSettings: (value) => value.collisionStruct),
          label: "Path finder table",
          parts: pathFinderTable!.collisionStructs,
          onSelected: (collisionStruct) {
            if (collisionStruct != null) {
              ref
                  .read(header2StateNotifierProvider.notifier)
                  .setCollisionStruct(
                    collisionStruct as CollisionStruct,
                  );
            }
          },
        ),
    ]);
  }
}

class HitDisplay extends StatelessWidget {
  const HitDisplay({super.key, required this.hitCollisionStruct});

  final HitCollisionStruct hitCollisionStruct;

  @override
  Widget build(BuildContext context) {
    return DataDecorator(children: [
      GsfDataTile(label: "Position x", data: hitCollisionStruct.positionX),
      GsfDataTile(label: "Position y", data: hitCollisionStruct.positionY),
      GsfDataTile(label: "Position z", data: hitCollisionStruct.positionZ),
      GsfDataTile(label: "Radius", data: hitCollisionStruct.radius),
      GsfDataTile(label: "Guid", data: hitCollisionStruct.guid),
      GsfDataTile(label: "Unknown", data: hitCollisionStruct.unknownData),
    ]);
  }
}

class BlockerDisplay extends StatelessWidget {
  const BlockerDisplay({super.key, required this.blockerCollisionStruct});

  final BlockerCollisionStruct blockerCollisionStruct;

  @override
  Widget build(BuildContext context) {
    return DataDecorator(children: [
      GsfDataTile(label: "Position x", data: blockerCollisionStruct.positionX),
      GsfDataTile(label: "Position y", data: blockerCollisionStruct.positionY),
      GsfDataTile(label: "Position z", data: blockerCollisionStruct.positionZ),
      GsfDataTile(label: "Size X", data: blockerCollisionStruct.sizeX),
      GsfDataTile(label: "Size Y", data: blockerCollisionStruct.sizeY),
      GsfDataTile(label: "Size Z", data: blockerCollisionStruct.sizeZ),
      GsfDataTile(label: "Unknown", data: blockerCollisionStruct.unknownData),
    ]);
  }
}
