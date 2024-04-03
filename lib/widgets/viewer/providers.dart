import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paraworld_gsf_viewer/widgets/viewer/notifier.dart';
import 'package:paraworld_gsf_viewer/widgets/viewer/state.dart';

final modelSelectionStateNotifierProvider =
    NotifierProvider<ModelSelectionStateNotifier, ModelViewerSelectionState>(
  ModelSelectionStateNotifier.new,
);
