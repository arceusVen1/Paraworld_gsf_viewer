import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paraworld_gsf_viewer/theme.dart';
import 'package:paraworld_gsf_viewer/widgets/header/display.dart';
import 'package:paraworld_gsf_viewer/widgets/header2/display.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/drawer_menu.dart';
import 'package:paraworld_gsf_viewer/widgets/viewer/viewer.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
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
    final themeMode = ref.watch(themeModeProvider);

    const tabs = [
      Tab(text: "Contents Table", icon: Icon(Icons.info)),
      Tab(text: "Mesh Viewer", icon: Icon(Icons.info)),
      Tab(text: "Model Viewer", icon: Icon(Icons.hub)),
    ];
    return MaterialApp(
      title: 'ParaWorld GSF viewer',
      theme: CustomTheme.lightThemeData(),
      darkTheme: CustomTheme.darkThemeData(),
      themeMode: themeMode,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
              bottom: const TabBar(
                tabs: tabs,
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
                  ModelViewerPageLayout(),
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
