import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; 

class FcmService {
  static Future<void> init() async {
    await FirebaseMessaging.instance.requestPermission();
    FirebaseMessaging.instance.subscribeToTopic(
      'user_${FirebaseAuth.instance.currentUser!.uid}',
    );
  }
}
