import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paraworld_gsf_viewer/providers/normals.dart';
import 'package:paraworld_gsf_viewer/providers/texture.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/buttons.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/label.dart';

class Menu extends ConsumerWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final texturePath = ref.watch(texturePathProvider);
    final showNormals = ref.watch(showNormalsProvider);
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Label.extraLarge("Options"),
          ),
          ListTile(
            title: Button.secondary(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ["jpg", "jpeg", "png"]);

                if (result != null) {
                  ref.read(texturePathProvider.notifier).state =
                      result.files.single.path;
                }
              },
              child: Label.small(
                texturePath != null
                    ? texturePath.split('/').last
                    : "Select a texture",
              ),
            ),
            trailing: texturePath != null
                ? IconButton(
                    onPressed: () {
                      ref.read(texturePathProvider.notifier).state = null;
                    },
                    icon: const Icon(
                      Icons.delete_forever,
                      color: Colors.red,
                    ))
                : null,
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            title: Label.medium(
              showNormals ? "normals visible" : "normals hidden",
            ),
            trailing: Switch(
              // This bool value toggles the switch.
              value: showNormals,
              activeColor: Colors.red,
              onChanged: (bool value) {
                // This is called when the user toggles the switch.
                ref.read(showNormalsProvider.notifier).state = value;
              },
            ),
          ),
        ],
      ),
    );
  }
}
