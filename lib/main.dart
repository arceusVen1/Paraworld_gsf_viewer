import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paraworld_gsf_viewer/widgets/header/display.dart';
import 'package:paraworld_gsf_viewer/widgets/header2/display.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/drawer_menu.dart';
import 'package:paraworld_gsf_viewer/widgets/viewer/viewer.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

const kWhiteColor = Color(0xffffffff);
const kBlackColor = Color(0xff000000);
const kTransparentColor = Color(0x00ffffff);
const kBlueColor = Color(0xff5a78a0);
const kRedColor = Color(0xffd73d33);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  @override
  void initState() {
    if (kIsWeb) {
      BrowserContextMenu.disableContextMenu();
    }
    super.initState();
  }

  @override
  void dispose() {
    if (kIsWeb) {
      BrowserContextMenu.enableContextMenu();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ParaWorld GSF viewer',
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: kBlueColor,

			primary: kRedColor,

			primaryContainer: kRedColor,

			outline: kBlueColor,
			outlineVariant: kBlueColor,
			
			background: kWhiteColor,

			surface: kWhiteColor,
			onSurface: kBlueColor,
			
			surfaceVariant: kWhiteColor,
			onSurfaceVariant: kBlueColor,

			shadow: kBlackColor,
			scrim: kBlackColor,
			surfaceTint: kTransparentColor,

			inversePrimary: kRedColor,
			secondary: kRedColor,
			onSecondary: kRedColor,

			error: kRedColor,
			onError: kRedColor,
			errorContainer: kRedColor,
			onErrorContainer: kRedColor,

          )),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
              bottom: const TabBar(
                tabs: [
                  Tab(text: "Contents Table", icon: Icon(Icons.info)),
                  Tab(text: "Mesh Viewer", icon: Icon(Icons.info)),
                  Tab(text: "Model Viewer", icon: Icon(Icons.hub)),
                ],
              ),
              title: const Text(
                "Options",
              )),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25),
            child: GestureDetector(
              onTap: () => ContextMenuController.removeAny(),
              child: const TabBarView(
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
          ),
          drawer: const Menu(),
        ),
      ),
    );
  }
}
