import 'package:bottle_note_app/screen/web_view.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const MaterialApp(
      home: WebView(),
    ),
  );
}
