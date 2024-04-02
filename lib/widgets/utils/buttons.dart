import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({
    super.key,
    this.child,
    this.isOutlined = false,
    this.disabled = false,
    this.isPrimary = false,
    this.color,
    this.disabledColor,
    this.innerPadding,
    this.onPressed,
  });

  final Widget? child;
  final bool isOutlined;
  final bool disabled;
  final bool isPrimary;
  final Color? color;
  final Color? disabledColor;
  final EdgeInsets? innerPadding;
  final void Function()? onPressed;

  const Button.primary({
    super.key,
    this.child,
    this.isOutlined = false,
    this.disabled = false,
    this.color,
    this.disabledColor,
    this.innerPadding,
    this.onPressed,
  }) : isPrimary = true;

  const Button.outlinedPrimary({
    super.key,
    this.child,
    this.color,
    this.disabledColor,
    this.disabled = false,
    this.innerPadding,
    this.onPressed,
  })  : isPrimary = true,
        isOutlined = true;

  const Button.secondary({
    super.key,
    this.child,
    this.isOutlined = false,
    this.disabled = false,
    this.color,
    this.disabledColor,
    this.innerPadding,
    this.onPressed,
  }) : isPrimary = false;

  const Button.outlinedSecondary({
    super.key,
    this.child,
    this.color,
    this.disabledColor,
    this.disabled = false,
    this.innerPadding,
    this.onPressed,
  })  : isPrimary = false,
        isOutlined = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonChild = Padding(
      padding: innerPadding ?? const EdgeInsets.all(0),
      child: child,
    );
    final colorToUse = color ??
        (isPrimary
            ? theme.colorScheme.secondary
            : theme.colorScheme.secondary);
    return isOutlined
        ? OutlinedButton(
            onPressed: !disabled ? onPressed : null,
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: disabled && disabledColor != null
                    ? disabledColor!
                    : colorToUse,
              ),
            ),
            child: buttonChild,
          )
        : ElevatedButton(
            onPressed: !disabled ? onPressed : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: disabled ? disabledColor : colorToUse,
            ),
            child: buttonChild,
          );
  }
}
