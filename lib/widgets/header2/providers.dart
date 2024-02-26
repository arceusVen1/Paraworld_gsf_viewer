import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paraworld_gsf_viewer/widgets/header2/notifier.dart';
import 'package:paraworld_gsf_viewer/widgets/header2/state.dart';

final header2StateNotifierProvider =
    NotifierProvider<Header2StateNotifier, Header2State>(Header2StateNotifier.new);
