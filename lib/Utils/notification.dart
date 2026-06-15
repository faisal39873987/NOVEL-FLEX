import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notifications {
  static final Notifications _notificationService = Notifications._internal();

  factory Notifications() {
    return _notificationService;
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Notifications._internal();

  final NotificationDetails notificationDetails = const NotificationDetails(
    android: AndroidNotificationDetails(
      'main_channel',
      'Main Channel',
      importance: Importance.max,
      priority: Priority.max,
      icon: '@drawable/launcher_icon',
      color: Colors.red,
      enableVibration: true,
    ),
    iOS: DarwinNotificationDetails(
      sound: 'default.wav',
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    ),
  );

  Future<void> cancelIdNotifications(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> showNotification(
    FlutterLocalNotificationsPlugin localNotifications,
    int id,
    String title,
    String body,
    String payload,
  ) async {
    await localNotifications.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  Future<void> scheduleNotification(
    FlutterLocalNotificationsPlugin localNotifications,
    int id,
    String title,
    String body,
    DateTime dateTime,
    String payload,
  ) async {
    await showNotification(localNotifications, id, title, body, payload);
  }

  Future<void> zonedScheduleNotification(
    FlutterLocalNotificationsPlugin localNotifications,
    int id,
    String title,
    String body,
    int seconds,
    String payload,
  ) async {
    await showNotification(localNotifications, id, title, body, payload);
  }

  Future<void> periodicallyShowNotification(
    FlutterLocalNotificationsPlugin localNotifications,
    int id,
    String title,
    String body,
    RepeatInterval repeatInterval,
    String payload,
  ) async {
    await showNotification(localNotifications, id, title, body, payload);
  }

  Future<void> showDailyAtTimeNotification(
    FlutterLocalNotificationsPlugin localNotifications,
    int id,
    String title,
    String body,
    dynamic time,
    String payload,
  ) async {
    await showNotification(localNotifications, id, title, body, payload);
  }

  Future<void> showWeeklyAtDayAndTimeNotification(
    FlutterLocalNotificationsPlugin localNotifications,
    int id,
    String title,
    String body,
    dynamic day,
    dynamic time,
    String payload,
  ) async {
    await showNotification(localNotifications, id, title, body, payload);
  }
}
