import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

final Uri uri = Uri.parse("https://bottle-note-deploy.vercel.app/");

class WebView extends StatefulWidget {
  const WebView({super.key});

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  WebViewController controller = WebViewController()..loadRequest(uri);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
