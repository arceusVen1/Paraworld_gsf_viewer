import 'package:flutter/material.dart';
import 'package:paraworld_gsf_viewer/classes/enums.dart';

class Label extends StatelessWidget {
  const Label(
    this.label, {
    super.key,
    required this.size,
    this.color,
    this.maxLines,
    this.isBold = false,
  });

  final ThemeSize size;
  final String label;
  final Color? color;
  final int? maxLines;
  final bool isBold;

  const Label.extraTiny(
    this.label, {
    super.key,
    this.color,
    this.maxLines,
    this.isBold = false,
  }) : size = ThemeSize.extraTiny;

  const Label.tiny(
    this.label, {
    super.key,
    this.color,
    this.maxLines,
    this.isBold = false,
  }) : size = ThemeSize.extraTiny;

  const Label.small(
    this.label, {
    super.key,
    this.color,
    this.maxLines,
    this.isBold = false,
  }) : size = ThemeSize.small;

  const Label.regular(
    this.label, {
    super.key,
    this.color,
    this.maxLines,
    this.isBold = false,
  }) : size = ThemeSize.regular;

  const Label.medium(
    this.label, {
    super.key,
    this.color,
    this.maxLines,
    this.isBold = false,
  }) : size = ThemeSize.medium;

  const Label.large(
    this.label, {
    super.key,
    this.color,
    this.maxLines,
    this.isBold = false,
  }) : size = ThemeSize.large;

  const Label.extraLarge(
    this.label, {
    super.key,
    this.color,
    this.maxLines,
    this.isBold = false,
  }) : size = ThemeSize.extraLarge;

  double getFontSize(ThemeSize size) {
    switch (size) {
      case ThemeSize.extraTiny:
        return 8;
      case ThemeSize.tiny:
        return 10;
      case ThemeSize.small:
        return 12;
      case ThemeSize.regular:
        return 13;
      case ThemeSize.medium:
        return 14;
      case ThemeSize.large:
        return 16;
      case ThemeSize.extraLarge:
        return 18;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FittedBox(
      fit: BoxFit.scaleDown, // this will force the text to be resized to fit
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        maxLines: maxLines,
        style: TextStyle(
          color: color ?? theme.colorScheme.onBackground,
          fontSize: getFontSize(size),
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
