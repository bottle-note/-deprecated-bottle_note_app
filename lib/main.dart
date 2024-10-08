import 'dart:io';

import 'package:bottle_note_app/web_view/web_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: const SafeArea(bottom: false, child: BottleNoteWebView()),
    onGenerateRoute: (settings) {
      if (Platform.isIOS) {
        return CupertinoPageRoute(builder: (_) => const BottleNoteWebView());
      } else {
        return MaterialPageRoute(builder: (_) => const BottleNoteWebView());
      }
    },
  ));
}
