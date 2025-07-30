import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('  messageId=${message.messageId}');
}

class FirebaseService {
  late final FirebaseMessaging _messaging;

  Future<void> init() async {
    await Firebase.initializeApp();

    _messaging = FirebaseMessaging.instance;

    final settings = await _messaging.requestPermission(
      alert: true, badge: true, sound: true,
    );
    print('🔔 Permission status: ${settings.authorizationStatus}');

    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

    final token = await _messaging.getToken();
    print('🔑 FCM token: $token');

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      print('🔄 FCM token refreshed: $newToken');
    });

  }

  Future<AuthorizationStatus> requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true, badge: true, sound: true,
    );
    return settings.authorizationStatus;
  }

  Future<String?> getToken() => _messaging.getToken();
}
