import 'package:flutter/material.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/affine_matrix.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/data_display.dart';

class AffineTransformationDisplay extends StatelessWidget {
  const AffineTransformationDisplay({super.key, required this.transformation});

  final AffineTransformation transformation;

  @override
  Widget build(BuildContext context) {
    return DropdownWrapper(
      label: "Affine Matrix",
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Wrap(
          spacing: 4,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GsfDataTile(label: 'scaleX', data: transformation.scaleX),
                GsfDataTile(label: 'stretchY', data: transformation.stretchY),
                GsfDataTile(
                    label: 'stretchZ_X', data: transformation.stretchZX),
                GsfDataTile(
                    label: 'float1', data: transformation.unknownFloat1),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GsfDataTile(label: 'stretchX', data: transformation.stretchX),
                GsfDataTile(label: 'scaleY', data: transformation.scaleY),
                GsfDataTile(
                    label: 'stretchZ_Y', data: transformation.stretchZY),
                GsfDataTile(
                    label: 'float2', data: transformation.unknownFloat2),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GsfDataTile(label: 'shearX', data: transformation.shearX),
                GsfDataTile(label: 'shearY', data: transformation.shearY),
                GsfDataTile(label: 'scaleZ', data: transformation.scaleZ),
                GsfDataTile(
                    label: 'float3', data: transformation.unknownFloat3),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GsfDataTile(label: 'posX', data: transformation.positionX),
                GsfDataTile(label: 'posY', data: transformation.positionY),
                GsfDataTile(label: 'posZ', data: transformation.positionZ),
                GsfDataTile(
                    label: 'float4', data: transformation.unknownFloat4),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
