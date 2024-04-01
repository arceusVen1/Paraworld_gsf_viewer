import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paraworld_gsf_viewer/classes/model.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/buttons.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/label.dart';

class ConvertToObjCta extends StatelessWidget {
  const ConvertToObjCta({
    super.key,
    required this.model,
  });

  final Model model;

  Future<String?> writeAsObj() async {
    String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Please select an output file:',
      fileName: 'model.obj',
    );

    if (outputFile == null) {
      return null;
      // User canceled the picker
    }
    final objFile = File(outputFile);
    String fileContent = "";
    int offset = 0;
    for (final mesh in model.meshes) {
      fileContent += "\n\no ${mesh.hashCode}\n\n";
      fileContent += "# offset of group for triangles indices $offset\n\n";
      String vertexPart = "", normalPart = "", texturePart = "";
      for (final vertex in mesh.vertices) {
        final newContent = vertex.toObj();
        vertexPart += "${newContent.$1}\n";
        normalPart += "${newContent.$2}\n";
        texturePart += "${newContent.$3}\n";
      }
      fileContent += "$vertexPart\n$normalPart\n$texturePart\n";

      for (final triangle in mesh.triangles) {
        fileContent += triangle.toObj(offset);
      }
      offset += mesh.vertices.length;
    }
    await objFile.writeAsString(fileContent);
    return objFile.path;
  }

  @override
  Widget build(BuildContext context) {
    final messenger = ScaffoldMessenger.of(context);
    return Button.primary(
      onPressed: () async {
        final filePath = await writeAsObj();
        if (filePath != null) {
          Clipboard.setData(ClipboardData(text: filePath));
          messenger.showSnackBar(SnackBar(content: Text(filePath)));
        }
      },
      child: const Label.medium(
        "Convert to .obj",
        color: Colors.white,
      ),
    );
  }
}
