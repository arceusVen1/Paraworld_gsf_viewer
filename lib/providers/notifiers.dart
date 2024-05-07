import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paraworld_gsf_viewer/providers/state.dart';

const kPwDataBasePath = 'Data/Base';
const kPwModsInfoPath = 'Data/Info';
const modMaxPriority = 100;

typedef PathGetter = String? Function(String);

class PwLinkFolderNotifier extends Notifier<PwLinkState> {
  @override
  PwLinkState build() {
    return const PwLinkState.notLinked();
  }

  void link(String folderPath, String? selectedGsf) {
    state = PwLinkState.loading(pwFolderPath: folderPath);
    try {
      final ModPrioritiesPerPath modPrioritiesPerPath =
          _initModPrioritiesPerPath(folderPath);
      state = PwLinkState.success(
        pwFolderPath: folderPath,
        modPrioritiesPerPath: modPrioritiesPerPath,
        detailTable: _initDetailTable(folderPath, modPrioritiesPerPath),
        gsfs: _initGsfFilesList(folderPath, modPrioritiesPerPath),
        selectedGsf: selectedGsf,
      );
    } catch (e) {
      state = PwLinkState.failed(error: e, pwFolderPath: folderPath);
    }
  }

  void setSelectedGsf(String? gsfName) {
    state = state.maybeMap(
      success: (linked) => linked.copyWith(selectedGsf: gsfName),
      orElse: () => state,
    );
  }

  void refresh() {
    state.mapOrNull(
      success: (success) {
        link(success.pwFolderPath, success.selectedGsf);
      },
      failed: (failed) => link(failed.pwFolderPath, null),
    );
  }

  List<String> _initGsfFilesList(
      String pwFolderPath, ModPrioritiesPerPath modPrioritiesPerPath) {
    const gsfRelativePath = '$kPwDataBasePath/GSF';
    final List<String> gsfDirs = _getListOfDirstoScan(
      gsfRelativePath,
      pwFolderPath,
      modPrioritiesPerPath,
    );
    gsfDirs.add('$pwFolderPath/$gsfRelativePath');
    final Map<String, String> gsfs = {};
    for (final path in gsfDirs) {
      final Directory directory = Directory(path);
      for (final file
          in directory.listSync().where((file) => file.path.endsWith('.gsf'))) {
        final fileName = file.path.split("/").last;
        if (gsfs.containsKey(fileName)) {
          continue;
        }
        gsfs[fileName] = file.path;
      }
    }
    return gsfs.values.toList()
      ..sort((a, b) => a.split("/").last.compareTo(b.split("/").last));
  }

  ModPrioritiesPerPath _initModPrioritiesPerPath(String pwFolderPath) {
    final ModPrioritiesPerPath modPrioritiesPerPath = {};
    final Directory modInfoDirectory =
        Directory('$pwFolderPath/$kPwModsInfoPath');
    for (final info in modInfoDirectory.listSync()) {
      final file = File(info.path);
      final lines = file.readAsLinesSync();
      if (lines.isEmpty) {
        continue;
      }
      int priority = modMaxPriority;
      final splitRegExp = RegExp(r'\s+');
      for (final line in lines) {
        if (line.startsWith('priority')) {
          final parts = line.split(splitRegExp);
          priority = int.parse(parts[1]);
        } else if (line.startsWith("tryfilereplace")) {
          final parts = line.split(splitRegExp);
          final modOverride = (
            override: parts[3],
            priority: priority,
          );
          modPrioritiesPerPath.containsKey(parts[2])
              ? modPrioritiesPerPath[parts[2]]!.add(modOverride)
              : modPrioritiesPerPath[parts[2]] = [modOverride];
        }
      }
    }
    modPrioritiesPerPath.forEach((key, value) {
      value.sort((a, b) => a.priority.compareTo(b.priority));
    });
    return modPrioritiesPerPath;
  }

  DetailTable _initDetailTable(
      String pwFolderPath, ModPrioritiesPerPath modPrioritiesPerPath) {
    const String detailtablePath = '$kPwDataBasePath/Texture/detailtable.txt';

    final File detailTable = File(_getLinkedPathOfFile(
            detailtablePath, pwFolderPath, modPrioritiesPerPath) ??
        '$kPwDataBasePath/Texture/detailtable.txt');
    final lines = detailTable.readAsLinesSync();
    final DetailTable map = {};
    for (final line in lines) {
      final trimmedLine = line.trim();
      final escapeRegex = RegExp(r'[#]|[-]');
      if (trimmedLine.isEmpty || trimmedLine.startsWith(escapeRegex)) {
        continue;
      }
      final parts = trimmedLine.split(RegExp(r'\s+'));
      final key = parts[0].toLowerCase();
      final List<int> resolutions = [];
      bool overrideWithResolution = true;
      for (final part in parts.sublist(2)) {
        // skip the first two parts (key and some code)
        final trimmed = part.trim();
        if (trimmed == "-dontchange") {
          overrideWithResolution = false;
        }
        if (trimmed.startsWith("#")) {
          break;
        } else if (trimmed.startsWith(escapeRegex)) {
          continue;
        } else {
          resolutions.add(int.parse(trimmed));
        }
      }
      map[key] = (
        availableResolutions: resolutions,
        overrideNameWithResolution: overrideWithResolution
      );
    }
    return map;
  }

  String? getModdedPathForFile(String ogPath) {
    return state.maybeMap(
      success: (linked) {
        ogPath = ogPath.toLowerCase();
        if (ogPath.startsWith(linked.pwFolderPath.toLowerCase())) {
          // remove trailing / too
          ogPath = ogPath.substring(linked.pwFolderPath.length + 1);
        }
        return _getLinkedPathOfFile(
          ogPath,
          linked.pwFolderPath,
          linked.modPrioritiesPerPath,
        );
      },
      orElse: () => ogPath,
    );
  }

  List<String> _getListOfDirstoScan(
    String relativePath,
    String pwFolderPath,
    ModPrioritiesPerPath modPrioritiesPerPath,
  ) {
    final List<String> dirsToScan = [];
    _crawlModPathTable(
      relativePath,
      pwFolderPath,
      modPrioritiesPerPath,
      (overridePath) {
        dirsToScan.add(overridePath);
      },
      isDirectory: true,
      stopOnFirst: false,
    );
    return dirsToScan;
  }

  void _crawlModPathTable(
    String relativePath,
    String pwFolderPath,
    ModPrioritiesPerPath modPrioritiesPerPath,
    void Function(String) onExistsCallback, {
    required bool isDirectory,
    required bool stopOnFirst,
  }) {
    relativePath = relativePath.toLowerCase();
    for (final pathPrefix in modPrioritiesPerPath.keys) {
      if (relativePath.startsWith(pathPrefix.toLowerCase())) {
        final modOverrides = modPrioritiesPerPath[pathPrefix]!;
        final path = relativePath.substring(pathPrefix.length);
        for (final modOverride in modOverrides) {
          final modPath = '$pwFolderPath/${modOverride.override}$path';
          if (isDirectory) {
            final modDir = Directory(modPath);
            if (modDir.existsSync()) {
              onExistsCallback(modDir.path);
              if (stopOnFirst) {
                return;
              }
            }
          } else {
            final modFile = File(modPath);
            if (modFile.existsSync()) {
              onExistsCallback(modFile.path);
              if (stopOnFirst) {
                return;
              }
            }
          }
        }
      }
    }
  }

  String? _getLinkedPathOfFile(
    String relativePath,
    String pwFolderPath,
    ModPrioritiesPerPath modPrioritiesPerPath,
  ) {
    String? path;
    _crawlModPathTable(
      relativePath,
      pwFolderPath,
      modPrioritiesPerPath,
      (overridePath) {
        path = overridePath;
      },
      isDirectory: false,
      stopOnFirst: true,
    );
    return path;
  }
}
