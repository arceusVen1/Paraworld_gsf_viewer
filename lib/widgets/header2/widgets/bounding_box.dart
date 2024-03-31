import 'package:flutter/material.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/bounding_box.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/data_display.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/label.dart';

class BoundingBoxDisplay extends StatelessWidget {
  const BoundingBoxDisplay({
    super.key,
    required this.boundingBox,
    this.bbName,
  });

  final BoundingBox boundingBox;
  final String? bbName;

  @override
  Widget build(BuildContext context) {
    return SectionWrapper(
      label: bbName ?? "Model bounding box",
      children: [
        Wrap(
          direction: Axis.horizontal,
          spacing: 20,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Label.regular(
                  'MIN',
                  isBold: true,
                ),
                GsfDataTile(label: 'X', data: boundingBox.minX),
                GsfDataTile(label: 'Y', data: boundingBox.minY),
                GsfDataTile(label: 'Z', data: boundingBox.minZ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Label.regular(
                  'MAX',
                  isBold: true,
                ),
                GsfDataTile(label: 'X', data: boundingBox.maxX),
                GsfDataTile(label: 'Y', data: boundingBox.maxY),
                GsfDataTile(label: 'Z', data: boundingBox.maxZ),
              ],
            )
          ],
        ),
      ],
    );
  }
}
