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
      GsfDataTile(label: "Bitset attributes 1", data: material.bitsetAttribute1),
      GsfDataTile(label: "Bitset attributes 2", data: material.bitsetAttribute2),
      GsfDataTile(
        label: "Texture name offset",
        data: material.textureNameOffset,
        relatedPart: material.textureName,
      ),
      GsfDataTile(
        label: "NM name offset",
        data: material.nmNameOffset,
        relatedPart: material.nmName,
      ),
      GsfDataTile(
        label: "Env name offset",
        data: material.envNameOffset,
        relatedPart: material.envName,
      ),
    ]);
  }
}
