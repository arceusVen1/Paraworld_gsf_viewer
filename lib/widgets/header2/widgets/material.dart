import 'package:flutter/material.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/material.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/data_display.dart';

class MaterialDisplay extends StatelessWidget {
  const MaterialDisplay({
    super.key,
    required this.material,
  });

  final MaterialData material;

  @override
  Widget build(BuildContext context) {
    return DataDecorator(children: [
      GsfDataTile(label: "bitset attribute 1", data: material.bitsetAttribute1),
      GsfDataTile(label: "bitset attribute 2", data: material.bitsetAttribute2),
      GsfDataTile(
        label: "texture",
        data: material.textureNameOffset,
        relatedPart: material.textureName,
      ),
      GsfDataTile(
        label: "nm",
        data: material.nmNameOffset,
        relatedPart: material.nmName,
      ),
      GsfDataTile(
        label: "env",
        data: material.envNameOffset,
        relatedPart: material.envName,
      ),
    ]);
  }
}
