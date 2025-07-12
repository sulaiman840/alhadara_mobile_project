import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// Top‐level background message handler. Must be a top‐level function.
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('📥 [bg] messageId=${message.messageId}');
}

class FirebaseService {
  late final FirebaseMessaging _messaging;

  /// Call once at app startup.
  Future<void> init() async {
    // 1️⃣ Initialize Firebase core.
    await Firebase.initializeApp();

    // 2️⃣ Grab the messaging instance.
    _messaging = FirebaseMessaging.instance;

    // 3️⃣ Ask user for notification permissions (Android 13+ / iOS).
    final settings = await _messaging.requestPermission(
      alert: true, badge: true, sound: true,
    );
    print('🔔 Permission status: ${settings.authorizationStatus}');

    // 4️⃣ Register background handler.
    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

    // 5️⃣ Print the FCM token so you can paste it into the console for testing.
    final token = await _messaging.getToken();
    print('🔑 FCM token: $token');

    // 6️⃣ Watch for token refreshes and re‐send to your server
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      print('🔄 FCM token refreshed: $newToken');
      // TODO: call your repository endpoint to update the server with this newToken
    });

  }

  /// If you need to re-ask for permission later:
  Future<AuthorizationStatus> requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true, badge: true, sound: true,
    );
    return settings.authorizationStatus;
  }

  /// Handy getter if you need the token elsewhere in your app.
  Future<String?> getToken() => _messaging.getToken();
}
