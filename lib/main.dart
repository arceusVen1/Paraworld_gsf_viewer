import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paraworld_gsf_viewer/widgets/header/display.dart';
import 'package:paraworld_gsf_viewer/widgets/header2/display.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/drawer_menu.dart';
import 'package:paraworld_gsf_viewer/widgets/viewer/viewer.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

const kPrimaryColor = Color(0xff5c7ca4);
const kSecondaryColor = Color(0xffc23a31);
const kSecondaryContainerColor = Color(0xffd08f8a);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ParaWorld GSF viewer',
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: kPrimaryColor,
            secondary: kSecondaryColor,
            secondaryContainer: kSecondaryContainerColor,
          )),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
              bottom: const TabBar(
                tabs: [
                  Tab(text: "header 1", icon: Icon(Icons.info)),
                  Tab(text: "header 2", icon: Icon(Icons.info)),
                  Tab(text: "model", icon: Icon(Icons.hub)),
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
                HeaderDisplay(),
                Header2Display(),
                Viewer(
                  model: null,
                ),
              ],
            ),
          ),
          drawer: const Menu(),
        ),
      ),
    );
  }
}
