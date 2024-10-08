import 'package:bottle_note_app/web_view/web_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: SafeArea(
        bottom: false,
        child: BottleNoteWebView(),
      ),
    ),
  );
}
