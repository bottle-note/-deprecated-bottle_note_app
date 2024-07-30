import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

final Uri uri = Uri.parse("https://bottle-note-deploy.vercel.app/");

class WebView extends StatefulWidget {
  const WebView({super.key});

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  WebViewController controller = WebViewController()
    ..loadRequest(uri)
    ..setJavaScriptMode(JavaScriptMode.unrestricted); // 자바스크립트 허용

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE58257),
      body: SafeArea(
        top: true,
        bottom: true,
        child: WebViewWidget(
          controller: controller,
        ),
      ),
    );
  }
}
