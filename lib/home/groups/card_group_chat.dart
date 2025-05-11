import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/chat_group_model.dart';
import 'package:flutter_chat_app/models/message_model.dart';
import 'package:flutter_chat_app/widgets/open_image.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';

class CardGroupChat extends StatelessWidget {
  final MessageModel messageModel;

  const CardGroupChat({super.key, required this.messageModel});

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
                  isMe
                      ? SizedBox()
                      : StreamBuilder(
                        stream:
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(messageModel.senderId)
                                .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Text(
                            snapshot.data!['name'].toString(),
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(color: Colors.amber),
                          );
                        },
                      ),
                  SizedBox(height: 5),
                  messageModel.type == 'image'
                      ? ChatImageWidget(
                        imageUrl: messageModel.message.toString(),
                      )
                      : Text(messageModel.message.toString()),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(int.parse(messageModel.time!)))} ',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      const SizedBox(width: 5),
                      isMe
                          ? Icon(
                            Iconsax.tick_circle,
                            size: 12,
                            color:
                                messageModel.read == ''
                                    ? Colors.grey
                                    : Colors.blue,
                          )
                          : SizedBox(),
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
