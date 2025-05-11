import 'package:firebase_auth/firebase_auth.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
class CallServices {
  /// on App's user login
void onUserLogin() {
  /// 1.2.1. initialized ZegoUIKitPrebuiltCallInvitationService
  /// when app's user is logged in or re-logged in
  /// We recommend calling this method as soon as the user logs in to your app.
  ZegoUIKitPrebuiltCallInvitationService().init(
     appID: 1673848169, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
      appSign: '90b8ef8262a004e6f21e3898acb54cbf52d8d6789e420b7f7c3ba13de7d71570', // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
    userID: FirebaseAuth.instance.currentUser!.uid,
    userName: FirebaseAuth.instance.currentUser!.displayName!,
    plugins: [ZegoUIKitSignalingPlugin()],
  );
}

/// on App's user logout
void onUserLogout() {
  /// 1.2.2. de-initialization ZegoUIKitPrebuiltCallInvitationService
  /// when app's user is logged out
  ZegoUIKitPrebuiltCallInvitationService().uninit();
}

}