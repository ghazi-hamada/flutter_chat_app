import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/message_model.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class CardChat extends StatelessWidget {
  final MessageModel messageModel;
  const CardChat({super.key, required this.messageModel});

  @override
  Widget build(BuildContext context) {
    bool isMe = messageModel.senderId == FirebaseAuth.instance.currentUser!.uid;
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        isMe
            ? IconButton(onPressed: () {}, icon: Icon(Iconsax.message_edit))
            : SizedBox(),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(isMe ? 16 : 0),
              topRight: Radius.circular(isMe ? 0 : 16),
              bottomRight: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
          ),
          color:
              isMe
                  ? Theme.of(context).colorScheme.onSecondary
                  : Theme.of(context).colorScheme.onPrimary,
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width / 2,
              ),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  messageModel.type == 'text'
                      ? Text(messageModel.message.toString())
                      : Image.network(
                        messageModel.message.toString(),
                        height: 200,
                        width: 200,
                      ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(int.parse(messageModel.time!)))} ',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      const SizedBox(width: 5),
                      isMe ? Icon(Iconsax.tick_circle, size: 12) : SizedBox(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
