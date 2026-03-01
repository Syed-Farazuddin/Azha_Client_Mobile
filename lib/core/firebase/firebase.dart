import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobile/routes/app_router.dart';

class FirebaseMessagingService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initFlutterLocalNotifications(RemoteMessage message) async {
    var androidInitialization = const AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    var iosInitialization = const DarwinInitializationSettings();

    var initializationSettings = InitializationSettings(
      android: androidInitialization,
      iOS: iosInitialization,
    );

    localNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload) {
        debugPrint("payload is $payload");
        if (message.data['route'] != null) {
          router.pushNamed('${message.data['route']}');
        }
      },
      onDidReceiveBackgroundNotificationResponse: (details) =>
          debugPrint(details.payload.toString()),
    );
    showNotifications(message);
  }

  Future<void> showNotifications(RemoteMessage message) async {
    debugPrint("Show notification function is called");

    // Create the Android notification channel
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(10000).toString(),
      "HIGH_IMPORTANT_NOTIFICATION",
      importance: Importance.max,
    );

    // Android notification details
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: "This is your channel's description",
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
          icon: '@mipmap/ic_launcher',
        );

    // iOS notification details
    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    // Show the notification
    Future.delayed(Duration.zero, () {
      localNotificationsPlugin.show(
        0,
        message.notification!.title.toString(),
        message.notification!.body.toString(),
        notificationDetails,
      );
    });
  }

  Future<String?> getToken() async {
    // String? apnsToken = await messaging.getAPNSToken();
    // debugPrint("APNS Token: $apnsToken");
    String? token = await FirebaseMessaging.instance.getToken();
    return token;
  }

  Future<void> initialize() async {
    await messaging.requestPermission(alert: true, badge: true, sound: true);

    // Listen for foreground messages and show notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint("It's a foreground message");
      debugPrint("New message: ${message.notification?.body}");

      // Check if the message contains a notification
      if (message.notification != null) {
        // Call showNotifications to display the notification while app is in foreground
        // if (message.data['route'] != null) {
        //   String route = message.data['route'];
        //   debugPrint("Route path is $route");
        //   redirect(data: message.data);
        // }
        initFlutterLocalNotifications(message);
        // redirect(data: message.data);
        await showNotifications(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("It's a background message");

      debugPrint('Notification clicked: ${message.notification?.title}');

      if (message.data['route'] != null) {
        router.pushNamed('${message.data['route']}');
      }
    });
  }
}
