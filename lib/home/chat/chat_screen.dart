import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_app/firebase/fire_database.dart';
import 'package:flutter_chat_app/firebase/fire_storage.dart';
import 'package:flutter_chat_app/home/chat/CallPage.dart';
import 'package:flutter_chat_app/home/chat/chat_cubit/chat_cubit.dart';
import 'package:flutter_chat_app/home/chat/widgets/card_chat.dart';
import 'package:flutter_chat_app/home/chat/widgets/chat_messages_view.dart';
import 'package:flutter_chat_app/models/chat_user_model.dart';
import 'package:flutter_chat_app/models/message_model.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:timeago/timeago.dart' as timeago_ar;

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key, required this.user, required this.roomId});
  final ChatUser user;
  final String roomId;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: Row(
              children: [
                CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                    user.image.toString(),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.name.toString()),

                    Text(
                      user.online!
                          ? 'Online'
                          : 'Last Activated ${timeago.format(DateTime.fromMillisecondsSinceEpoch(int.parse(user.lastActivated!)), locale: 'en')}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Iconsax.call),
                onPressed: () {
                  // Call user
                },
              ),
              IconButton(
                icon: const Icon(Iconsax.video),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CallPage(callID: roomId),
                    ),
                  );
                },
              ),
              context.read<ChatCubit>().messagesTextSelected.isEmpty
                  ? SizedBox()
                  : IconButton(
                    icon: const Icon(Iconsax.copy),
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(
                          text: context
                              .read<ChatCubit>()
                              .messagesTextSelected
                              .join('\n'),
                        ),
                      );
                      context.read<ChatCubit>().clean();
                    },
                  ),

              context.read<ChatCubit>().messagesIdSelected.isEmpty
                  ? SizedBox()
                  : IconButton(
                    icon: const Icon(Iconsax.trash),
                    onPressed: () {
                      context.read<ChatCubit>().deleteMessage(roomId);
                    },
                  ),
              // IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ChatMessagesView(roomId: roomId, user: user),
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        child: TextFormField(
                          controller:
                              context.read<ChatCubit>().messageController,
                          maxLines: 5,
                          minLines: 1,
                          decoration: InputDecoration(
                            suffixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Iconsax.emoji_happy),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    ImagePicker picker = ImagePicker();
                                    XFile? image = await picker.pickImage(
                                      source: ImageSource.camera,
                                    );
                                    if (image != null) {
                                      FireDatabase().sendImageMessage(
                                        user.id!,
                                        File(image.path),
                                        roomId,
                                      );
                                    }
                                  },
                                  icon: Icon(Iconsax.camera),
                                ),
                              ],
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            hintText: 'Type a message',
                          ),
                        ),
                      ),
                    ),
                    IconButton.filled(
                      icon: const Icon(Iconsax.send_1),
                      onPressed: () {
                        context.read<ChatCubit>().sendMessage(user, roomId);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
