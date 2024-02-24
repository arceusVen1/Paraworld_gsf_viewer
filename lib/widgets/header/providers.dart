import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paraworld_gsf_viewer/widgets/header/notifier.dart';
import 'package:paraworld_gsf_viewer/widgets/header/state.dart';

final headerStateNotifierProvider =
    NotifierProvider<HeaderStateNotifier, HeaderState>(HeaderStateNotifier.new);
