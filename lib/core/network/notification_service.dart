import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Must be a top‐level function to handle taps when the app is terminated.
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  print('🔔 Notification tapped [background]: ${response.payload}');
}

class NotificationService {
  final FlutterLocalNotificationsPlugin _localNotif =
  FlutterLocalNotificationsPlugin();

  /// Call once, **after** FirebaseService.init().
  Future<void> init() async {
    // 1️⃣ Initialize the local notifications plugin.
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);

    await _localNotif.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse resp) {
        print('🔔 Notification tapped [foreground]: ${resp.payload}');
        // TODO: navigate in your app based on resp.payload
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    // 2️⃣ When a push arrives **in the foreground**, show a local notification:
    FirebaseMessaging.onMessage.listen(_showLocalNotification);

    // 3️⃣ When the user taps a notification while the app is in the background
    //    (but not terminated), this stream will fire:
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('🔔 onMessageOpenedApp: ${message.data}');
      // TODO: navigate based on message.data
    });
  }

  void _showLocalNotification(RemoteMessage message) {
    final notif = message.notification;
    if (notif == null) return;

    _localNotif.show(
      notif.hashCode,
      notif.title,
      notif.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'default_channel',
          'General',
          channelDescription: 'General alerts',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      payload: message.data['payload'] as String?,
    );
  }
}
