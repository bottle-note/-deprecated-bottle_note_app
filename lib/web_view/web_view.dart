import 'dart:io';

import 'package:bottle_note_app/web_view/custom_vertical_gesture_recognizer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BottleNoteWebView extends StatefulWidget {
  const BottleNoteWebView({super.key});

  @override
  State<BottleNoteWebView> createState() => _WebViewState();
}

class _WebViewState extends State<BottleNoteWebView>
    with WidgetsBindingObserver {
  late WebViewController controller;
  late Future<String> webviewDeviceInfoUrl;

  @override
  void initState() {
    super.initState();
    webviewDeviceInfoUrl =
        Future.value("https://bottle-note-deploy.vercel.app/");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: webviewDeviceInfoUrl,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          controller = WebViewController()
            ..setBackgroundColor(Colors.white)
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..loadRequest(Uri.parse(snapshot.data!));

          return Platform.isAndroid
              ? androidBackHandling(context)
              : iosBackHandling(context);
        } else {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  Future<bool> goBack(BuildContext context) async {
    if (await controller.canGoBack()) {
      controller.goBack();
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  Widget androidBackHandling(BuildContext context) {
    return WillPopScope(
      onWillPop: () => goBack(context),
      child: Scaffold(
        body: WebViewWidget(
          controller: controller,
        ),
      ),
    );
  }

  Widget iosBackHandling(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque, // 터치 이벤트가 WebView로 전달되도록 설정
      onVerticalDragUpdate: (details) {},
      onHorizontalDragUpdate: (details) {
        if (details.delta.dx > 10) {
          debugPrint("goBack");
          goBack(context);
        }
      },
      child: SafeArea(
        child: WebViewWidget(
          controller: controller,
          gestureRecognizers: {
            Factory(() => CustomVerticalGestureRecognizer()),
          },
        ),
      ),
    );
  }
}
