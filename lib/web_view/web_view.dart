import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BottleNoteWebView extends StatefulWidget {
  const BottleNoteWebView({super.key});

  @override
  State<BottleNoteWebView> createState() => _BottleNoteWebViewState();
}

class _BottleNoteWebViewState extends State<BottleNoteWebView> {
  late final WebViewController _controller;
  final String _initialUrl = "https://bottle-note-deploy.vercel.app/";

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(_initialUrl));
  }

  @override
  Widget build(BuildContext context) {
    Widget webView = WebViewWidget(controller: _controller);

    if (Platform.isAndroid) {
      // 안드로이드: 하드웨어 뒤로 가기 버튼 처리
      return BackButtonListener(
        onBackButtonPressed: () async {
          if (await _controller.canGoBack()) {
            _controller.goBack();
            return true; // 뒤로 가기 버튼을 처리했음을 알림
          } else {
            return false; // 앱 종료 허용
          }
        },
        child: Scaffold(
          body: webView,
        ),
      );
    } else {
      // iOS: 웹사이트 내부에서 뒤로 가기 버튼 구현
      return Scaffold(
        body: webView,
      );
    }
  }
}