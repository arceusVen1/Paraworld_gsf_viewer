import 'package:flutter/material.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/bounding_box.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/data_display.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/label.dart';

class BoundingBoxDisplay extends StatelessWidget {
  const BoundingBoxDisplay({super.key, required this.boundingBox});

  final BoundingBox boundingBox;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Label.regular(
          'MIN',
          fontWeight: FontWeight.bold,
        ),
        GsfDataTile(label: 'X', data: boundingBox.minX),
        GsfDataTile(label: 'Y', data: boundingBox.minY),
        GsfDataTile(label: 'Z', data: boundingBox.minZ),
        const Label.regular(
          'MAX',
          fontWeight: FontWeight.bold,
        ),
        GsfDataTile(label: 'X', data: boundingBox.maxX),
        GsfDataTile(label: 'Y', data: boundingBox.maxY),
        GsfDataTile(label: 'Z', data: boundingBox.maxZ),
      ],
    );
  }
}
