import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/drawer_menu.dart';
import 'package:paraworld_gsf_viewer/widgets/viewer/viewer.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text("Paraworld Gsf viewer")),
        body: const Padding(
          padding: EdgeInsets.all(50),
          child: Viewer(),
        ),
        drawer: const Menu(),
      ),
    );
  }
}
