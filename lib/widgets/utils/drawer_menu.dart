import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paraworld_gsf_viewer/providers/gsf.dart';
import 'package:paraworld_gsf_viewer/providers/normals.dart';
import 'package:paraworld_gsf_viewer/providers/texture.dart';
import 'package:paraworld_gsf_viewer/theme.dart';
import 'package:paraworld_gsf_viewer/widgets/header/providers.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/buttons.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/label.dart';

class Menu extends ConsumerWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final showNormals = ref.watch(showNormalsProvider);
    final theme = Theme.of(context);
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
            ),
            child: Wrap(
              direction: Axis.vertical,
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.start,
              spacing: 8,
              children: [
                const ThemeModeSwitcher(),
                Label.extraLarge(
                  "Options",
                  color: theme.colorScheme.onBackground,
                ),
              ],
            ),
          ),
          _FileLoaderTile(
            title: "Select a .gsf",
            allowedExtensions: const ["gsf"],
            filePathStateProvider: gsfPathStateProvider,
            onDelete: () =>
                ref.read(headerStateNotifierProvider.notifier).reset(),
          ),
          _FileLoaderTile(
            title: "Select a texture",
            allowedExtensions: const ["jpg", "jpeg", "png", "dds"],
            filePathStateProvider: texturePathStateProvider,
          ),
          ListTile(
            title: const Label.medium("Show normals"),
            trailing: Switch.adaptive(
              // This bool value toggles the switch.
              value: showNormals,
              inactiveTrackColor: theme.colorScheme.tertiary,
              activeColor: theme.colorScheme.surfaceVariant,
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
    this.onFileSelected,
    this.onDelete,
  });

  final String title;
  final List<String> allowedExtensions;
  final StateProvider<PlatformFile?> filePathStateProvider;
  final void Function(PlatformFile)? onFileSelected;
  final void Function()? onDelete;

  @override
  Widget build(BuildContext context, ref) {
    final file = ref.watch(filePathStateProvider);
    return ListTile(
      title: Button.secondary(
        onPressed: () async {
          FilePickerResult? result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: allowedExtensions,
          );

          if (result != null) {
            ref.read(filePathStateProvider.notifier).state =
                result.files.single;
            onFileSelected?.call(result.files.single);
          }
        },
        child: Label.small(
          file != null ? file.name : title,
        ),
      ),
      trailing: file != null
          ? IconButton(
              onPressed: () {
                ref.read(filePathStateProvider.notifier).state = null;
                onDelete?.call();
              },
              icon: Icon(
                Icons.delete_forever,
                color: Theme.of(context).colorScheme.secondary,
              ))
          : null,
      onTap: () {
        // Update the state of the app.
        // ...
      },
    );
  }
}
