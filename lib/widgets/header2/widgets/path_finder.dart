import 'package:flutter/widgets.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/collision_struct.dart';
import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/data_display.dart';

class PathFinderDisplay extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return SectionWrapper(label: "Path Finder Table", children: [
      GsfDataTile(label: 'Offset', data: offset),
      GsfDataTile(
        label: 'Count',
        data: count,
      ),
      if (pathFinderTable != null)
        PartSelector(
          label: "Path finder table",
          parts: pathFinderTable!.collisionStructs,
          onSelected: (collisionStruct) {},
        ),
    ]);
  }
}
