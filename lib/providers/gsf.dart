import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/gsf.dart';

/// Provider that holds the path of the gsf file
final gsfPathStateProvider = StateProvider<PlatformFile?>((ref) => null);

/// Provider that reads a gsf model file and returns the GSF object
final gsfProvider = FutureProvider<GSF?>(
  (ref) async {
    final file = ref.watch(gsfPathStateProvider);
    if (file == null) {
      return null;
    }
    if (file.bytes != null) {
      return GSF.fromBytes(file.bytes!);
    }
    if (file.path != null) {
      final data = File(file.path!);
      final bytes = await data.readAsBytes();
      return GSF.fromBytes(bytes);
    }
    return null;
  },
);