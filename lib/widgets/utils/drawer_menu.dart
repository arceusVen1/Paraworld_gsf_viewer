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
    String? path;
    bool isLoadingTable = false;
    ref.watch(pwLinkStateNotifierProvider).maybeMap(
        loading: (_) {
          isLoadingTable = true;
        },
        success: (success) {
          path = success.pwFolderPath;
          isLoadingTable = false;
        },
        orElse: () => false);
    final scaffold = ScaffoldMessenger.of(context);
    ref.listen(pwLinkStateNotifierProvider, (_, next) {
      next.maybeMap(
          failed: (failed) {
            scaffold.clearSnackBars();
            scaffold.showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 15),
                content: Label.regular(
                  "Linking ${failed.pwFolderPath} failed with err: ${failed.error}",
                  isBold: true,
                  color: theme.colorScheme.error,
                ),
                backgroundColor: theme.colorScheme.errorContainer,
              ),
            );
          },
          orElse: () {});
      {}
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
              ref.read(pwLinkStateNotifierProvider.notifier).link(result, null);
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
                ref
                    .read(pwLinkStateNotifierProvider.notifier)
                    .refresh(); // force update
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
    final pwLinkState = ref.watch(pwLinkStateNotifierProvider);
    final entries = pwLinkState.mapOrNull(
          success: (linked) => linked.gsfs
              .map(
                (gsf) => DropdownMenuItem(
                  value: gsf,
                  child: Label.regular(
                    gsf.split("/").last,
                    isBold: linked.selectedGsf == gsf,
                  ),
                ),
              )
              .toList(),
        ) ??
        [];
    entries.insert(
      0,
      DropdownMenuItem(
        value: null,
        child: Label.regular(
          entries.isNotEmpty ? "Select a .gsf" : "Link to PW folder to use GSF",
        ),
      ),
    );
    return ListTile(
      title: DropdownButton<String?>(
        focusColor: Theme.of(context).colorScheme.surface,
        isExpanded: true,
        value: pwLinkState.mapOrNull(
          success: (linked) => linked.selectedGsf,
        ),
        items: entries,
        onChanged: pwLinkState.mapOrNull(
            success: (_) => (value) {
                  ref
                      .read(pwLinkStateNotifierProvider.notifier)
                      .setSelectedGsf(value);
                }),
      ),
    );
  }
}
