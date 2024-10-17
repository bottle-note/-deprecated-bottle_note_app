import 'package:bottle_note_app/web_view/web_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  // Flutter 엔진과 관련된 바인딩을 초기화합니다.
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase를 초기화합니다.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseMessaging.instance.requestPermission(
    badge: true, // 앱 아이콘에 배지를 표시할지 여부를 설정합니다.
    alert: true, // 알림을 표시할지 여부를 설정합니다.
    sound: true, // 알림 소리를 재생할지 여부를 설정합니다.
  );

  String? _fcmToken = await FirebaseMessaging.instance.getToken();
  print('FCM Token: $_fcmToken');

  // 앱을 실행합니다.
  runApp(
    const MaterialApp(
      home: BottleNoteWebView(),
    ),
  );
}
