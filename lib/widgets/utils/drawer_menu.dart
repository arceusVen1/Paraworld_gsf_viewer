import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paraworld_gsf_viewer/providers/gsf.dart';
import 'package:paraworld_gsf_viewer/providers/texture.dart';
import 'package:paraworld_gsf_viewer/theme.dart';
import 'package:paraworld_gsf_viewer/widgets/header/providers.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/buttons.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/label.dart';

class Menu extends ConsumerWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context, ref) {
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
          const _PwFolderLink(),
          const _SelectableGsfFiles(),
          _FileLoaderTile(
            title: "Select a .gsf",
            allowedExtensions: const ["gsf"],
            filePathStateProvider: overridingGsfPathStateProvider,
            onDelete: () =>
                ref.read(headerStateNotifierProvider.notifier).reset(),
          ),
          _FileLoaderTile(
            title: "Select a texture",
            allowedExtensions: const ["jpg", "jpeg", "png", "dds"],
            filePathStateProvider: texturePathStateProvider,
          ),
        ],
      ),
    );
  }
}

class _PwFolderLink extends ConsumerWidget {
  const _PwFolderLink({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final path = ref.watch(pwFolderPathStateProvider);
    final isLoadingTable = ref.watch(detailTableStateProvider).isLoading;
    final scaffold = ScaffoldMessenger.of(context);
    ref.listen(detailTableStateProvider, (_, next) {
      if (next.asError != null) {
        scaffold.clearSnackBars();
        scaffold.showSnackBar(
          SnackBar(
            content: Label.regular(
              "Parsing detail table failed with err: ${next.error}",
              isBold: true,
              color: theme.colorScheme.error,
            ),
            backgroundColor: theme.colorScheme.errorContainer,
          ),
        );
      }
    });
    return ListTile(
      title: Tooltip(
        message: path ?? "Must be your Paraworld game folder",
        child: Button.secondary(
          disabled: isLoadingTable,
          onPressed: () async {
            String? result = await FilePicker.platform.getDirectoryPath(
              dialogTitle: "select your ParaWorld folder",
            );
            if (result != null) {
              ref.read(pwFolderPathStateProvider.notifier).state = result;
            }
          },
          child: isLoadingTable
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Label.small(
                  path != null ? "PW Folder linked" : "Link a ParaWorld folder",
                ),
        ),
      ),
      trailing: path != null
          ? IconButton(
              onPressed: () {
                ref.read(pwFolderPathStateProvider.notifier).state =
                    path + ''; // force update
              },
              icon: Icon(
                Icons.refresh,
                color: Theme.of(context).colorScheme.secondary,
              ))
          : null,
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

class _SelectableGsfFiles extends ConsumerWidget {
  const _SelectableGsfFiles({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final gsfs = ref.watch(gsfFilesListProvider);
    final selected = ref.watch(gsfSelectedFileInPwFolderProvider);
    final entries = gsfs.whenOrNull(
          data: (gsfs) => gsfs
              .map(
                (gsf) => DropdownMenuItem(
                  value: gsf,
                  child: Label.regular(
                    gsf.split("/").last,
                    isBold: selected == gsf,
                  ),
                ),
              )
              .toList(),
        ) ??
        [];
    entries.insert(
      0,
      DropdownMenuItem(
        value: "",
        child: Label.regular(
          gsfs.asData?.value.isNotEmpty ?? false
              ? "Select a .gsf"
              : "Link to PW folder to use GSF",
        ),
      ),
    );
    return ListTile(
      title: DropdownButton<String?>(
        focusColor: Theme.of(context).colorScheme.surface,
        isExpanded: true,
        value: selected ?? "",
        items: entries,
        onChanged: gsfs.asData?.value.isNotEmpty ?? false
            ? (value) {
                ref.read(gsfSelectedFileInPwFolderProvider.notifier).state =
                    value != null && value.isNotEmpty ? value : null;
              }
            : null,
      ),
    );
  }
}
