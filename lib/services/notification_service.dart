import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  log('Message Received ${message.notification?.title}');
}

class NotificationService {
  static Future<void> initializeNotification() async {
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onBackgroundMessage(backgroundHandler);
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        log("Token : $token");
      }
    }
    log('Notification Initialized');
  }
}
