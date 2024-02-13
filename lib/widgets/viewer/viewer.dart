import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paraworld_gsf_viewer/classes/bouding_box.dart';
import 'package:paraworld_gsf_viewer/classes/model.dart';
import 'package:paraworld_gsf_viewer/classes/triangle.dart';
import 'package:paraworld_gsf_viewer/classes/vertex.dart';
import 'package:paraworld_gsf_viewer/providers/normals.dart';
import 'package:paraworld_gsf_viewer/test.dart';
import 'package:paraworld_gsf_viewer/widgets/convert_to_obj_cta.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/mouse_movement_notifier.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/file_loaders.dart';
import 'package:paraworld_gsf_viewer/widgets/viewer/model_drawer.dart';

class Viewer extends StatelessWidget {
  const Viewer({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Vertex> vertices = [];
    final byteArray = convertToByteArray(verticesTest);
    for (int i = 0; i < byteArray.length; i += 16) {
      final vertexValue = int.parse(
          byteArray[i + 5] +
              byteArray[i + 4] +
              byteArray[i + 3] +
              byteArray[i + 2] +
              byteArray[i + 1] +
              byteArray[i],
          radix: 16);
      final vert = Vertex.fromModelBytes(
        vertexValue,
        int.parse(byteArray[i + 7] + byteArray[i + 6], radix: 16),
        //BoundingBox.zero(),
        BoundingBox(
          x: (min: -0.565, max: 1.130),
          y: (min: -0.993, max: 1.982),
          z: (min: -0.179, max: 0.441),
        ),
      );
      vertices.add(vert);
    }

    final List<ModelTriangle> triangles = [];
    final triangleByteArray = convertToByteArray(trianglesTest);
    for (int i = 0; i < triangleByteArray.length; i += 6) {
      final List<int> indices = [];

      indices.add(int.parse(triangleByteArray[i + 1] + triangleByteArray[i],
          radix: 16));
      indices.add(int.parse(triangleByteArray[i + 3] + triangleByteArray[i + 2],
          radix: 16));
      indices.add(int.parse(triangleByteArray[i + 5] + triangleByteArray[i + 4],
          radix: 16));
      triangles.add(ModelTriangle(indices: indices, points: [
        vertices[indices[0]],
        vertices[indices[1]],
        vertices[indices[2]],
      ]));
    }

    final model = Model(
      name: 'test',
      vertices: vertices,
      triangles: triangles,
    );

    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 4.5 / 6,
          width: MediaQuery.of(context).size.width,
          child: MouseMovementNotifier(
            mouseListener: (mouseNotifier) => GSFLoader(
              builder: (gsf) => ImageTextureLoader(
                textureBuilder: (texture) {
                  return ShowNormalWrapper(
                    builder: (showNormals) => CustomPaint(
                      painter: ModelDrawer(
                        mousePosition: mouseNotifier,
                        model: model,
                        texture: texture,
                        showNormals: showNormals,
                      ),
                      child: const SizedBox.expand(),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        ConvertToObjCta(
          vertices: vertices,
          triangles: triangles,
        ),
      ],
    );
  }
}

typedef ShowNormalsBuilder = Widget Function(bool);

class ShowNormalWrapper extends ConsumerWidget {
  const ShowNormalWrapper({super.key, required this.builder});

  final ShowNormalsBuilder builder;

  @override
  Widget build(BuildContext context, ref) {
    return builder(ref.watch(showNormalsProvider));
  }
}
