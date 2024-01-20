import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paraworld_gsf_viewer/classes/triangle.dart';
import 'package:paraworld_gsf_viewer/classes/vertex.dart';
import 'package:path_provider/path_provider.dart';

class ConvertToObjCta extends StatelessWidget {
  const ConvertToObjCta({
    super.key,
    required this.vertices,
    required this.triangles,
  });

  final List<Vertex> vertices;
  final List<ModelTriangle> triangles;

  Future<String> writeAsObj() async {
    final directory = await getApplicationDocumentsDirectory();
    final objFile = File('${directory.path}/model.obj');
    String vertexPart = "", normalPart = "", texturePart = "";
    for (final vertex in vertices) {
      final newContent = vertex.toObj();
      vertexPart += "${newContent.$1}\n";
      normalPart += "${newContent.$2}\n";
      texturePart += "${newContent.$3}\n";
    }
    String fileContent = "$vertexPart\n$normalPart\n$texturePart\n";

    for (final triangle in triangles) {
      fileContent += triangle.toObj();
    }
    objFile.writeAsString(fileContent);
    return objFile.path;
  }

  @override
  Widget build(BuildContext context) {
    final messenger = ScaffoldMessenger.of(context);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 252, 0, 92),
        elevation: 0,
      ),
      onPressed: () async {
        final filePath = await writeAsObj();
        Clipboard.setData(ClipboardData(text: filePath));
        messenger.showSnackBar(SnackBar(content: Text(filePath)));
      },
      child: const Text(
        "Convert to obj",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
