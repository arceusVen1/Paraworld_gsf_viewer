import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

typedef MousePositionDrag = ({
  Offset pos,
  double lastX,
  double lastY,
  double zoom
});

typedef MouseListener = Widget Function(
    ValueNotifier<MousePositionDrag> notifier);

class MouseMovementNotifier extends StatelessWidget {
  const MouseMovementNotifier(
      {super.key, required this.mouseListener});

  final MouseListener mouseListener;

  @override
  Widget build(BuildContext context) {
    double lastX = 0;
    double lastY = 0;
    double refX = 0;
    double refY = 0;

    final mousePosNotifier = ValueNotifier<MousePositionDrag>(
        (pos: const Offset(0, 0), lastX: 0, lastY: 0, zoom: 1));

    return Listener(
      onPointerUp: (event) {
        mousePosNotifier.value = (
          pos: Offset(event.position.dx - refX, event.position.dy - refY),
          lastX: lastX,
          lastY: lastY,
          zoom: mousePosNotifier.value.zoom
        );
        lastX = event.position.dx - refX + lastX;
        lastY = event.position.dy - refY + lastY;
      },
      onPointerDown: (event) {
        if (event.buttons == kPrimaryMouseButton) {
          refX = event.position.dx;
          refY = event.position.dy;
          mousePosNotifier.value = (
            pos: const Offset(0, 0),
            lastX: lastX,
            lastY: lastY,
            zoom: mousePosNotifier.value.zoom
          );
        }
      },
      onPointerMove: (event) {
        if (event.buttons == kPrimaryMouseButton) {
          mousePosNotifier.value = (
            pos: Offset(event.position.dx - refX, event.position.dy - refY),
            lastX: lastX,
            lastY: lastY,
            zoom: mousePosNotifier.value.zoom
          );
        }
      },
      onPointerSignal: (event) {
        if (event is PointerScrollEvent) {
          mousePosNotifier.value = (
            pos: mousePosNotifier.value.pos,
            lastX: mousePosNotifier.value.lastX,
            lastY: mousePosNotifier.value.lastY,
            zoom:
                event.scrollDelta.dy.abs() / MediaQuery.of(context).size.height,
          );
        }
      },
      child: mouseListener(mousePosNotifier),
    );
  }
}
