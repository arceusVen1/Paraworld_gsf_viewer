import 'package:flutter/material.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/bind_pose_matrix.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/data_display.dart';

class BindPoseDisplay extends StatelessWidget {
  const BindPoseDisplay({super.key, required this.bindPose});

  final BindPose bindPose;

  @override
  Widget build(BuildContext context) {
    return SectionWrapper(
      label: "Bind pose",
        children: [
			Wrap(
			  direction: Axis.horizontal,
			  spacing: 20,
			  children: [
				  Column(
					mainAxisSize: MainAxisSize.min,
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
					  GsfDataTile(label: 'a1_1', data: bindPose.a1_1),
					  GsfDataTile(label: 'a2_1', data: bindPose.a2_1),
					  GsfDataTile(label: 'a3_1', data: bindPose.a3_1),
					  GsfDataTile(label: 'a4_1', data: bindPose.a4_1),
					],
				  ),
				  Column(
					mainAxisSize: MainAxisSize.min,
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
					  GsfDataTile(label: 'a1_2', data: bindPose.a1_2),
					  GsfDataTile(label: 'a2_2', data: bindPose.a2_2),
					  GsfDataTile(label: 'a3_2', data: bindPose.a3_2),
					  GsfDataTile(label: 'a4_2', data: bindPose.a4_2),
					],
				  ),
				  Column(
					mainAxisSize: MainAxisSize.min,
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
					  GsfDataTile(label: 'a1_3', data: bindPose.a1_3),
					  GsfDataTile(label: 'a2_3', data: bindPose.a2_3),
					  GsfDataTile(label: 'a3_3', data: bindPose.a3_3),
					  GsfDataTile(label: 'a4_3', data: bindPose.a4_3),
					],
				  ),
				  Column(
					mainAxisSize: MainAxisSize.min,
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
					  GsfDataTile(label: 'a1_4', data: bindPose.a1_4),
					  GsfDataTile(label: 'a2_4', data: bindPose.a2_4),
					  GsfDataTile(label: 'a3_4', data: bindPose.a3_4),
					  GsfDataTile(label: 'a4_4', data: bindPose.a4_4),
					],
				  ),
			  ],
			),
        ],
    );
  }
}
