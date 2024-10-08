import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BottleNoteWebView extends StatefulWidget {
  const BottleNoteWebView({super.key});

  @override
  State<BottleNoteWebView> createState() => _BottleNoteWebViewState();
}

class _BottleNoteWebViewState extends State<BottleNoteWebView> {
  late final WebViewController _controller;
  bool _backButtonPressedOnce = false;
  final String _initialUrl = "https://bottle-note-deploy.vercel.app/";

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00e58257))
      ..setNavigationDelegate(navigationDelegate())
      //..addJavaScriptChannel() 자바 스크립트 채널 필요할 경우 해당 메소드 관련 학습 필요
      ..loadRequest(Uri.parse(_initialUrl));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        _myCondition();
      },
      child: SafeArea(
        child: Scaffold(
          body: WebViewWidget(
            controller: _controller,
          ),
        ),
      ),
    );
  }

  NavigationDelegate navigationDelegate() {
    return NavigationDelegate(
      // 네비게이션 이벤트를 처리하는 콜백을 설정합니다.
      onProgress: (int progress) {
        debugPrint("onProgress {}", wrapWidth: progress);
      },
      // 페이지 로딩 진행도 이벤트 핸들러를 설정합니다.
      onPageStarted: (String url) {},
      // 페이지 로딩 시작 이벤트 핸들러를 설정합니다.
      onPageFinished: (String url) {},
      // 페이지 로딩 완료 이벤트 핸들러를 설정합니다.
      onWebResourceError: (WebResourceError error) {},
      // 웹 리소스 에러 핸들러를 설정합니다.
      onNavigationRequest: (NavigationRequest request) {
        //페이지 이동할때 호출됩니다.
        return NavigationDecision
            .navigate; //페이지 이동 항상 허용 , 특정 url경우 허용 불가하게 할 수 있습니다.
      },
    );
  }

  _myCondition() async {
    if (await _controller.canGoBack()) {
      //_controller 에서 뒤로 갈 곳이 있는지 확인합니다. bool형태로 나옵니다
      _controller
          .goBack(); //갈곳이 있는경우 true이기 때문에 이 코드가 실행됩니다. _controller 의 이전 페이지로 이동합니다.
      return false;
    } else {
      //만약 _controller 에서 뒤로 갈 곳이 없는 경우~
      if (_backButtonPressedOnce) {
        //_backButtonPressedOnce 가 true 인 경우
        SystemNavigator.pop(); //앱 종료
      } else {
        _backButtonPressedOnce = true; //_backButtonPressedOnce 를 true로 바꾸고
        ScaffoldMessenger.of(context).showSnackBar(
          //하단에 스낵바를 생성합니다.
          const SnackBar(
            content: Text('한 번 더 누르시면 앱이 종료됩니다.'),
            duration: Duration(seconds: 2),
          ),
        );
        Timer(const Duration(seconds: 2), () {
          //그리고 2초 뒤 _backButtonPressedOnce 값을 다시 false로 변환합니다.
          _backButtonPressedOnce = false;
        });
        return false;
      }
    }
    return true;
  }
}
