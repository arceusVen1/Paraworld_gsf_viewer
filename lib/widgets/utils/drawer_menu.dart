import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paraworld_gsf_viewer/providers/gsf.dart';
import 'package:paraworld_gsf_viewer/providers/normals.dart';
import 'package:paraworld_gsf_viewer/providers/texture.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/buttons.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/label.dart';

class Menu extends ConsumerWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context, ref) {
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
          _FileLoaderTile(
            title: "Select a .gsf",
            allowedExtensions: const ["gsf"],
            filePathStateProvider: gsfPathStateProvider,
          ),
          _FileLoaderTile(
            title: "Select a texture",
            allowedExtensions: const ["jpg", "jpeg", "png"],
            filePathStateProvider: texturePathStateProvider,
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

class _FileLoaderTile extends ConsumerWidget {
  const _FileLoaderTile({
    required this.title,
    required this.allowedExtensions,
    required this.filePathStateProvider,
  });

  final String title;
  final List<String> allowedExtensions;
  final StateProvider<String?> filePathStateProvider;

  @override
  Widget build(BuildContext context, ref) {
    final path = ref.watch(filePathStateProvider);
    return ListTile(
      title: Button.secondary(
        onPressed: () async {
          FilePickerResult? result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: allowedExtensions,
          );

          if (result != null) {
            ref.read(filePathStateProvider.notifier).state =
                result.files.single.path;
          }
        },
        child: Label.small(
          path != null ? path.split('/').last : title,
        ),
      ),
      trailing: path != null
          ? IconButton(
              onPressed: () {
                ref.read(filePathStateProvider.notifier).state = null;
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
    );
  }
}
