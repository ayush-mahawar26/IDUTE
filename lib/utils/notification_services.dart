import 'dart:math';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:idute_app/components/constants/firebase_constants.dart';
import 'package:idute_app/controller/push_notification_controller.dart';
import 'package:idute_app/model/message.dart';

class NotificationServices {
  final FirebaseMessaging _firebaseMessaging =
      FirebaseConstants.firebaseMessaging;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void requestNotificationPermissions() async {
    NotificationSettings notificationSettings =
        await _firebaseMessaging.requestPermission(
            alert: true,
            badge: true,
            criticalAlert: true,
            provisional: true,
            sound: true,
            announcement: true,
            carPlay: true);

    if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized) {
      print("Permission given");
    } else if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("provisinal ");
    } else {
      print("User denied permission");
    }
  }

  void initLocalNotifications(
      BuildContext context, RemoteMessage message) async {
    var androidInitialization =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    var iosInitialization = DarwinInitializationSettings();

    var initializationSettings = InitializationSettings(
        android: androidInitialization, iOS: iosInitialization);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (payload) {
      PushNotification().handleNotificationNavigation(context, message);
    });
  }

  void showNotification(RemoteMessage message) async {
    AndroidNotificationChannel androidNotificationChannel =
        AndroidNotificationChannel(
            Random.secure().nextInt(100000).toString(), "High Importance");

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            androidNotificationChannel.id, androidNotificationChannel.name,
            channelDescription: "Your channel desciption",
            icon: "@mipmap/ic_launcher",
            importance: Importance.high,
            priority: Priority.high,
            ticker: "ticker");
    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails(
            presentAlert: true, presentBadge: true, presentSound: true);

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);

    Future.delayed(Duration.zero, () {
      flutterLocalNotificationsPlugin.show(0, message.notification!.title,
          message.notification!.body, notificationDetails);
    });
  }

  void firebaseNotificationInit(BuildContext context) async {
    FirebaseMessaging.onMessage.listen((message) {
      initLocalNotifications(context, message);

      showNotification(message);
    });
  }

  Future<String> getToken() async {
    String? deviceToken = await _firebaseMessaging.getToken();
    return deviceToken!;
  }

  void isTokenRefresh() async {
    _firebaseMessaging.onTokenRefresh.listen((event) {
      event.toString();
    });
  }
}
