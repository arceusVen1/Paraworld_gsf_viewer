import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/gsf.dart';

final gsfPathStateProvider = StateProvider<PlatformFile?>((ref) => null);

final gsfProvider = FutureProvider<GSF?>(
  (ref) async {
    final file = ref.watch(gsfPathStateProvider);
    if (file == null || file.bytes == null) {
      return null;
    }
    return GSF.fromBytes(file.bytes!);
  },
);
