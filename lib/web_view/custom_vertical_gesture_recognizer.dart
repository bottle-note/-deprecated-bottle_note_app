import 'package:flutter/gestures.dart';

class CustomVerticalGestureRecognizer extends VerticalDragGestureRecognizer {
  @override
  void handleEvent(PointerEvent event) {
    if (event is PointerMoveEvent) {
      final dy = event.delta.dy.abs();
      final dx = event.delta.dx.abs();
      if (dy > dx) {
        resolve(GestureDisposition.accepted);
      } else {
        resolve(GestureDisposition.rejected);
      }
    }
  }
}
