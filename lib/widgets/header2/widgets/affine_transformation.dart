import 'package:flutter/material.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/mesh.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/data_display.dart';

class AffineTransformationDisplay extends StatelessWidget {
  const AffineTransformationDisplay({super.key, required this.transformation});

  final AffineTransformation transformation;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      GsfDataTile(label: 'scale X', data: transformation.scaleX),
      GsfDataTile(label: 'stretch Y', data: transformation.stretchY),
      GsfDataTile(label: 'stretch Z_X', data: transformation.stretchZX),
      GsfDataTile(label: 'unknown float', data: transformation.unknownFloat1),
      GsfDataTile(label: 'stretch X', data: transformation.stretchX),
      GsfDataTile(label: 'scale Y', data: transformation.scaleY),
      GsfDataTile(label: 'stretch Z_Y', data: transformation.stretchZY),
      GsfDataTile(label: 'unknown float 2', data: transformation.unknownFloat2),
      GsfDataTile(label: 'shear X', data: transformation.shearX),
      GsfDataTile(label: 'shear Y', data: transformation.shearY),
      GsfDataTile(label: 'scale Z', data: transformation.scaleZ),
      GsfDataTile(label: 'unknow float 3', data: transformation.unknownFloat3),
      GsfDataTile(label: 'position X', data: transformation.positionX),
      GsfDataTile(label: 'position Y', data: transformation.positionY),
      GsfDataTile(label: 'position Z', data: transformation.positionZ),
      GsfDataTile(label: 'unknown float 4', data: transformation.unknownFloat4),
      ],
    );
  }
}
