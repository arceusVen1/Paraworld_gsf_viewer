import 'package:flutter/material.dart';
import 'package:paraworld_gsf_viewer/classes/enums.dart';

class Label extends StatelessWidget {
  const Label(
    this.label, {
    super.key,
    required this.size,
    this.color,
    this.maxLines,
    this.fontWeight,
  });

  final ThemeSize size;
  final String label;
  final Color? color;
  final int? maxLines;
  final FontWeight? fontWeight;

  const Label.extraTiny(
    this.label, {
    super.key,
    this.color,
    this.maxLines,
    this.fontWeight,
  }) : size = ThemeSize.extraTiny;

  const Label.tiny(
    this.label, {
    super.key,
    this.color,
    this.maxLines,
    this.fontWeight,
  }) : size = ThemeSize.extraTiny;

  const Label.small(
    this.label, {
    super.key,
    this.color,
    this.maxLines,
    this.fontWeight,
  }) : size = ThemeSize.small;

  const Label.regular(
    this.label, {
    super.key,
    this.color,
    this.maxLines,
    this.fontWeight,
  }) : size = ThemeSize.regular;

  const Label.medium(
    this.label, {
    super.key,
    this.color,
    this.maxLines,
    this.fontWeight,
  }) : size = ThemeSize.medium;

  const Label.large(
    this.label, {
    super.key,
    this.color,
    this.maxLines,
    this.fontWeight,
  }) : size = ThemeSize.large;

  const Label.extraLarge(
    this.label, {
    super.key,
    this.color,
    this.maxLines,
    this.fontWeight,
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
    return FittedBox(
      fit: BoxFit.scaleDown, // this will force the text to be resized to fit
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        maxLines: maxLines,
        style: TextStyle(
          color: color ?? Colors.black,
          fontSize: getFontSize(size),
          fontWeight: fontWeight,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
