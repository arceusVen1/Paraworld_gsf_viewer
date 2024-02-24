import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paraworld_gsf_viewer/widgets/header/display.dart';
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
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
              bottom: const TabBar(
                tabs: [
                  Tab(text: "model", icon: Icon(Icons.hub)),
                  Tab(text: "header", icon: Icon(Icons.info)),
                ],
              ),
              title: const Text(
                "Paraworld Gsf viewer",
              )),
          body: const Padding(
            padding: EdgeInsets.symmetric(vertical: 25),
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                Viewer(),
                HeaderDisplay(),
              ],
            ),
          ),
          drawer: const Menu(),
        ),
      ),
    );
  }
}
