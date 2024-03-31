import 'package:flutter/material.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/affine_matrix.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/data_display.dart';

class AffineTransformationDisplay extends StatelessWidget {
  const AffineTransformationDisplay({super.key, required this.transformation});

  final AffineTransformation transformation;

  @override
  Widget build(BuildContext context) {
    return SectionWrapper(
      label: "Affine matrix",
        children: [
			Wrap(
			  direction: Axis.horizontal,
			  spacing: 20,
			  children: [
				  Column(
					mainAxisSize: MainAxisSize.min,
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
					  GsfDataTile(label: 'a1_1', data: transformation.scaleX),
					  GsfDataTile(label: 'a2_1', data: transformation.stretchY),
					  GsfDataTile(label: 'a3_1', data: transformation.stretchZX),
					  GsfDataTile(label: 'a4_1', data: transformation.unknownFloat1),
					],
				  ),
				  Column(
					mainAxisSize: MainAxisSize.min,
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
					  GsfDataTile(label: 'a1_2', data: transformation.stretchX),
					  GsfDataTile(label: 'a2_2', data: transformation.scaleY),
					  GsfDataTile(label: 'a3_2', data: transformation.stretchZY),
					  GsfDataTile(label: 'a4_2', data: transformation.unknownFloat2),
					],
				  ),
				  Column(
					mainAxisSize: MainAxisSize.min,
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
					  GsfDataTile(label: 'a1_3', data: transformation.shearX),
					  GsfDataTile(label: 'a2_3', data: transformation.shearY),
					  GsfDataTile(label: 'a3_3', data: transformation.scaleZ),
					  GsfDataTile(label: 'a4_3', data: transformation.unknownFloat3),
					],
				  ),
				  Column(
					mainAxisSize: MainAxisSize.min,
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
					  GsfDataTile(label: 'a1_4', data: transformation.positionX),
					  GsfDataTile(label: 'a2_4', data: transformation.positionY),
					  GsfDataTile(label: 'a3_4', data: transformation.positionZ),
					  GsfDataTile(label: 'a4_4', data: transformation.unknownFloat4),
					],
				  ),
			  ],
			),
        ],
    );
  }
}
