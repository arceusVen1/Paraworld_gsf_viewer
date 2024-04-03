import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/chunk_attributes.dart';
import 'package:paraworld_gsf_viewer/classes/model.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/buttons.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/label.dart';

class ConvertToObjCta extends StatelessWidget {
  const ConvertToObjCta({
    super.key,
    required this.model,
    required this.attributesFilter,
  });

  final Model model;
  final ChunkAttributes attributesFilter;

  Future<String?> writeAsObj(bool asSingleMesh) async {
    String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Please select an output file:',
      fileName: '${model.name.isNotEmpty ? model.name : "model"}.obj',
    );

    if (outputFile == null) {
      return null;
      // User canceled the picker
    }
    final objFile = File(outputFile);
    String fileContent = "";
    int offset = 0;
    if (asSingleMesh) {
      fileContent += "o ${model.name}\n\n";
    } else {
      fileContent += "# Model: ${model.name}\n\n";
    }
    for (final mesh in model.meshes) {
      if (!mesh.canBeViewed(attributesFilter)) {
        continue;
      }
      for (var submesh in mesh.submeshes) {
        fileContent += "\n\n${asSingleMesh ? "o" : "g"} ${mesh.hashCode}\n\n";
        fileContent += "# offset of group for triangles indices $offset\n\n";
        String vertexPart = "", normalPart = "", texturePart = "";
        for (final vertex in submesh.vertices) {
          final newContent = vertex.toObj();
          vertexPart += "${newContent.$1}\n";
          normalPart += "${newContent.$2}\n";
          texturePart += "${newContent.$3}\n";
        }
        fileContent += "$vertexPart\n$normalPart\n$texturePart\n";

        for (final triangle in submesh.triangles) {
          fileContent += triangle.toObj(offset);
        }
        offset += submesh.vertices.length;
      }
    }
    await objFile.writeAsString(fileContent);
    return objFile.path;
  }

  _onPressed(bool asSingleMesh, ScaffoldMessengerState messenger) async {
    final filePath = await writeAsObj(asSingleMesh);
    if (filePath != null) {
      Clipboard.setData(ClipboardData(text: filePath));
      messenger.showSnackBar(SnackBar(content: Text(filePath)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final messenger = ScaffoldMessenger.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.center,
          spacing: 10,
          children: [
            Button.primary(
              onPressed: () {
                _onPressed(true, messenger);
              },
              child: const Label.medium(
                "To .obj as single Mesh",
                color: Colors.white,
              ),
            ),
            if (model.meshes.length > 1)
              Button.primary(
                onPressed: () {
                  _onPressed(false, messenger);
                },
                child: const Label.medium(
                  "To .obj with multiple meshes",
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
