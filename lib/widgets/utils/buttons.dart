import 'package:flutter/material.dart';

const primaryColor = Color.fromARGB(255, 252, 0, 92);
const secondaryColor = Color.fromARGB(255, 228, 228, 228);

class Button extends StatelessWidget {
  const Button({
    super.key,
    this.child,
    this.isOutlined = false,
    this.disabled = false,
    required this.color,
    this.disabledColor,
    this.innerPadding,
    this.onPressed,
  });

  final Widget? child;
  final bool isOutlined;
  final bool disabled;
  final Color color;
  final Color? disabledColor;
  final EdgeInsets? innerPadding;
  final void Function()? onPressed;

  const Button.primary({
    super.key,
    this.child,
    this.isOutlined = false,
    this.disabled = false,
    this.disabledColor,
    this.innerPadding,
    this.onPressed,
  }) : color = primaryColor;

  const Button.outlinedPrimary({
    super.key,
    this.child,
    this.disabledColor,
    this.disabled = false,
    this.innerPadding,
    this.onPressed,
  })  : color = primaryColor,
        isOutlined = true;

  const Button.secondary({
    super.key,
    this.child,
    this.isOutlined = false,
    this.disabled = false,
    this.disabledColor,
    this.innerPadding,
    this.onPressed,
  }) : color = secondaryColor;

  const Button.outlinedSecondary({
    super.key,
    this.child,
    this.disabledColor,
    this.disabled = false,
    this.innerPadding,
    this.onPressed,
  })  : color = secondaryColor,
        isOutlined = true;

  @override
  Widget build(BuildContext context) {
    final buttonChild = Padding(
      padding: innerPadding ?? const EdgeInsets.all(0),
      child: child,
    );
    return isOutlined
        ? OutlinedButton(
            onPressed: !disabled ? onPressed : null,
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                  color: disabled && disabledColor != null
                      ? disabledColor!
                      : color),
            ),
            child: buttonChild,
          )
        : ElevatedButton(
            onPressed: !disabled ? onPressed : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: disabled ? disabledColor : color,
            ),
            child: buttonChild,
          );
  }
}
