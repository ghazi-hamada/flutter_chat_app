import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_app/models/chat_user_model.dart';

class FireAuth {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static User? user = auth.currentUser;
  static Future createUser({required String name}) async {
    ChatUser chatUser = ChatUser(
      id: user!.uid,
      name: name,
      email: user!.email ?? '',
      image: user!.photoURL ?? '',
      createAt: DateTime.now().millisecondsSinceEpoch.toString(),
      lastActivated: DateTime.now().millisecondsSinceEpoch.toString(),
      pushToken: '',
      abuot: '',
      online: true,
      myContacts: [],
    );

    user?.updateDisplayName(name);
    await firestore.collection('users').doc(user!.uid).set(chatUser.toJson());
  }

  Future<void> getToken(String token) async {
    await firestore.collection('users').doc(user!.uid).update({
      'push_token': token,
    });
  }

  Future updateActivatedTime(bool online) async {
    print('User is ${online ? 'ONLINE' : 'OFFLINE'}');
    await firestore.collection('users').doc(user!.uid).update({
      'online': online,
      'last_activated': DateTime.now().millisecondsSinceEpoch.toString(),
    });
  }
}
