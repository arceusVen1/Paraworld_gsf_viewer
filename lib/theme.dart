import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paraworld_gsf_viewer/color_schemes.g.dart';

const kWhiteColor = Color(0xffffffff);
const kBlackColor = Color(0xff000000);
const kTransparentColor = Color(0x00ffffff);
const kBlueColor = Color(0xff5a78a0);
const kRedColor = Color(0xffd73d33);

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);

class CustomTheme {
  static ThemeData lightThemeData() {
    return ThemeData(
      colorScheme: lightColorScheme,
    );
  }

  static ThemeData darkThemeData() {
    return ThemeData(
      colorScheme: darkColorScheme,
    );
  }
}

class ThemeModeSwitcher extends ConsumerWidget {
  const ThemeModeSwitcher({super.key});
  void _toggleTheme(ThemeMode themeMode, WidgetRef ref) {
    ref.read(themeModeProvider.notifier).state = themeMode;
  }

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    bool isDarkMode = ref.watch(themeModeProvider) == ThemeMode.dark;
    return Row(
      children: [
        Icon(
          isDarkMode ? Icons.dark_mode : Icons.light_mode,
          color: theme.colorScheme.onBackground,
        ),
        Switch.adaptive(
		  inactiveTrackColor: theme.colorScheme.tertiary,
          activeColor: theme.colorScheme.surfaceVariant,
          value: isDarkMode,
          onChanged: (isOn) {
            isOn
                ? _toggleTheme(ThemeMode.dark, ref)
                : _toggleTheme(ThemeMode.light, ref);
          },
        ),
      ],
    );
  }
}
