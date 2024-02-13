import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/gsf.dart';

final gsfPathStateProvider = StateProvider<String?>((ref) => null);

final gsfProvider = FutureProvider<GSF?>(
  (ref) async {
    final path = ref.watch(gsfPathStateProvider);
    if (path == null) {
      return null;
    }
    final data = File(path);
    final bytes = await data.readAsBytes();
    return GSF.fromBytes(bytes);
  },
);
