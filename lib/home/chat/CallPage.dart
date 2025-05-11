import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallPage extends StatelessWidget {
  const CallPage({Key? key, required this.id, required this.name, }) : super(key: key);
  final String id;
  final String name;

  @override
  Widget build(BuildContext context) {
    return ZegoSendCallInvitationButton(
      invitees: [ZegoUIKitUser(id: id, name: name)],
      isVideoCall: false,
      resourceID: 'chatApp',
    );
  }
}
