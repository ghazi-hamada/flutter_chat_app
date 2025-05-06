import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_app/home/chat/chat_cubit/chat_cubit.dart';
import 'package:flutter_chat_app/home/chat/widgets/card_chat.dart';
import 'package:flutter_chat_app/models/chat_user_model.dart';
import 'package:flutter_chat_app/models/message_model.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key, required this.user, required this.roomId});
  final ChatUser user;
  final String roomId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.name.toString()),
            Text('Online', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Iconsax.copy), onPressed: () {}),
          IconButton(icon: const Icon(Iconsax.trash), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance
                        .collection('rooms')
                        .doc(roomId)
                        .collection('messages')
                        .orderBy('time', descending: true)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  List<MessageModel> messages = [];
                  for (var doc in snapshot.data!.docs) {
                    messages.add(MessageModel.fromJson(doc.data()));
                    print(messages);
                  }
                  return messages.isEmpty
                      ? InkWell(
                        onTap: () {
                          context.read<ChatCubit>().sendMessage(
                            user,
                            roomId,
                            'AlSalam alaikum',
                          );
                        },
                        child: Center(
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '👋',
                                    style:
                                        Theme.of(
                                          context,
                                        ).textTheme.displayMedium,
                                  ),
                                  Text(
                                    'Sey Alsalam alaikum',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                      : ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        reverse: true,
                        itemBuilder: (context, idnex) {
                          return CardChat(messageModel: messages[idnex]);
                        },
                      );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: TextFormField(
                      controller: context.read<ChatCubit>().messageController,
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
                                  print(image.path);
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
  }
}
