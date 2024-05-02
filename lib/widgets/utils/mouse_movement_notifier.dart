import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/buttons.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/label.dart';

typedef MousePositionDrag = ({
  Offset pos,
  double lastX,
  double lastY,
});

typedef MouseEventData = ({
  MousePositionDrag mousePositionPrimary,
  MousePositionDrag mousePositionSecondary,
  double zoom,
});

typedef MouseListener = Widget Function(ValueNotifier<MouseEventData> notifier);

class MouseMovementNotifier extends StatefulWidget {
  const MouseMovementNotifier({super.key, required this.mouseListener});

  final MouseListener mouseListener;

  @override
  State<MouseMovementNotifier> createState() => _MouseMovementNotifierState();
}

class _MouseMovementNotifierState extends State<MouseMovementNotifier> {
  (double, double) _lastXs = (0, 0);
  (double, double) _lastYs = (0, 0);
  double _refX = 0;
  double _refY = 0;
  bool _isPrimary = false;

  final MousePositionDrag defaultPos =
      (pos: const Offset(0, 0), lastX: 0, lastY: 0);
  late ValueNotifier<MouseEventData> mousePosNotifier;

  @override
  void initState() {
    mousePosNotifier = ValueNotifier<MouseEventData>((
      mousePositionPrimary: defaultPos,
      mousePositionSecondary: defaultPos,
      zoom: 1.0,
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Listener(
      onPointerUp: (event) {
        final currentLastX = _isPrimary ? _lastXs.$1 : _lastXs.$2;
        final currentLastY = _isPrimary ? _lastYs.$1 : _lastYs.$2;
        final MousePositionDrag newPosData = (
          pos: Offset(event.position.dx - _refX, event.position.dy - _refY),
          lastX: currentLastX,
          lastY: currentLastY,
        );
        mousePosNotifier.value = (
          mousePositionPrimary: _isPrimary
              ? newPosData
              : mousePosNotifier.value.mousePositionPrimary,
          mousePositionSecondary: _isPrimary
              ? mousePosNotifier.value.mousePositionSecondary
              : newPosData,
          zoom: mousePosNotifier.value.zoom,
        );
        final newLastX = event.position.dx - _refX + currentLastX;
        final newLastY = event.position.dy - _refY + currentLastY;
        _lastXs = _isPrimary ? (newLastX, _lastXs.$2) : (_lastXs.$1, newLastX);
        _lastYs = _isPrimary ? (newLastY, _lastYs.$2) : (_lastYs.$1, newLastY);
      },
      onPointerDown: (event) {
        _refX = event.position.dx;
        _refY = event.position.dy;
        _isPrimary = event.buttons == kPrimaryMouseButton;
        final MousePositionDrag newPosData = (
          pos: const Offset(0, 0),
          lastX: _isPrimary ? _lastXs.$1 : _lastXs.$2,
          lastY: _isPrimary ? _lastYs.$1 : _lastYs.$2,
        );
        mousePosNotifier.value = (
          mousePositionPrimary: _isPrimary
              ? newPosData
              : mousePosNotifier.value.mousePositionPrimary,
          mousePositionSecondary: _isPrimary
              ? mousePosNotifier.value.mousePositionSecondary
              : newPosData,
          zoom: mousePosNotifier.value.zoom,
        );
      },
      onPointerMove: (event) {
        final MousePositionDrag newPosData = (
          pos: Offset(event.position.dx - _refX, event.position.dy - _refY),
          lastX: _isPrimary ? _lastXs.$1 : _lastXs.$2,
          lastY: _isPrimary ? _lastYs.$1 : _lastYs.$2,
        );
        mousePosNotifier.value = (
          mousePositionPrimary: _isPrimary
              ? newPosData
              : mousePosNotifier.value.mousePositionPrimary,
          mousePositionSecondary: _isPrimary
              ? mousePosNotifier.value.mousePositionSecondary
              : newPosData,
          zoom: mousePosNotifier.value.zoom,
        );
      },
      onPointerSignal: (event) {
        if (event is PointerScrollEvent) {
          final delta =
              event.scrollDelta.dy / MediaQuery.of(context).size.height;
          mousePosNotifier.value = (
            mousePositionPrimary: mousePosNotifier.value.mousePositionPrimary,
            mousePositionSecondary:
                mousePosNotifier.value.mousePositionSecondary,
            zoom: delta < 0
                ? max(mousePosNotifier.value.zoom + delta, 1)
                : mousePosNotifier.value.zoom + delta,
          );
        }
      },
      child: Column(
        children: [
          Expanded(child: widget.mouseListener(mousePosNotifier)),
          Button.outlinedPrimary(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Label.regular(
                  "Reset transformations",
                  isBold: true,
                  color: colorScheme.onBackground,
                ),
                Icon(
                  Icons.refresh,
                  color: colorScheme.onBackground,
                )
              ],
            ),
            onPressed: () {
              _lastXs = (0, 0);
              _lastYs = (0, 0);
              _refX = 0;
              _refY = 0;
              mousePosNotifier.value = (
                mousePositionPrimary: defaultPos,
                mousePositionSecondary: defaultPos,
                zoom: 1.0,
              );
            },
          ),
          const Gap(8.0),
        ],
      ),
    );
  }
}
