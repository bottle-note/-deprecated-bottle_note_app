import 'dart:io';

import 'package:bottle_note_app/web_view/custom_vertical_gesture_recognizer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  // MethodChannel
  static const platform = MethodChannel('intent.channel');

  @override
  void initState() {
    super.initState();
    print('build !!!');
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
            ..setNavigationDelegate(NavigationDelegate(
                onNavigationRequest: (NavigationRequest request) async {
              print('navigation !!!');

              if (request.url.startsWith('intent')) {
                handleIntentURI(request.url);
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            }))
            ..setBackgroundColor(Colors.white)
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..loadRequest(Uri.parse(snapshot.data!));

          return Platform.isAndroid
              ? androidBackHandling(context)
              : iosBackHandling(context);
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  // Intent URI 처리 로직
  Future<void> handleIntentURI(String url) async {
    try {
      final result =
          await platform.invokeMapMethod('handleIntentURI', {'url': url});
      print('intetn URI 처리 성공: $result');
    } catch (e) {
      print('intent URI 처리 실패: $e');
    }
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
