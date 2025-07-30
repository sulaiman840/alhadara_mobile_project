import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  print(' Notification tapped [background]: ${response.payload}');
}

class NotificationService {
  final FlutterLocalNotificationsPlugin _localNotif =
  FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);

    await _localNotif.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse resp) {
        print('🔔 Notification tapped [foreground]: ${resp.payload}');
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    FirebaseMessaging.onMessage.listen(_showLocalNotification);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('🔔 onMessageOpenedApp: ${message.data}');
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
