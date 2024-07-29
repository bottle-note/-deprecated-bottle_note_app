import 'package:bottle_note_app/screen/web_view.dart';
import 'package:flutter/material.dart';

void main() {
  //Flutter Framework will run the app
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const MaterialApp(
      home: WebView(),
    ),
  );
}
