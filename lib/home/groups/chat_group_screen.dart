import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_app/core/bottom_sheet.dart';
import 'package:flutter_chat_app/firebase/fire_database.dart';
import 'package:flutter_chat_app/home/chat/widgets/card_chat.dart';
import 'package:flutter_chat_app/home/groups/card_group_chat.dart';
import 'package:flutter_chat_app/home/groups/group_member_screen.dart';
import 'package:flutter_chat_app/home/groups/groups_cubit/groups_cubit.dart';
import 'package:flutter_chat_app/models/chat_group_model.dart';
import 'package:flutter_chat_app/models/chat_user_model.dart';
import 'package:flutter_chat_app/models/message_model.dart';
import 'package:iconsax/iconsax.dart';

class ChatGroupScreen extends StatelessWidget {
  final ChatGroupModel chatGroupModel;
  const ChatGroupScreen({super.key, required this.chatGroupModel});
  @override
  Widget build(BuildContext context) {
    context.read<GroupsCubit>().subscribeToGroupTopic(chatGroupModel.id!);
    return StreamBuilder(
      stream:
          FirebaseFirestore.instance
              .collection('users')
              .where('id', whereIn: chatGroupModel.members)
              .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        List<String> names =
            snapshot.data!.docs.map((doc) => doc['name'] as String).toList();
        List<ChatUser> users =
            snapshot.data!.docs
                .map((doc) => ChatUser.fromJson(doc.data()))
                .toList();
        return BlocBuilder<GroupsCubit, GroupsState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                centerTitle: false,
                title: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                        chatGroupModel.image.toString(),
                      ),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(chatGroupModel.name.toString()),

                        Text(
                          names.join(', '),
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
                actions: [
                  context.read<GroupsCubit>().messagesTextSelected.isEmpty
                      ? SizedBox.shrink()
                      : IconButton(
                        icon: const Icon(Iconsax.copy),
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(
                              text: context
                                  .read<GroupsCubit>()
                                  .messagesTextSelected
                                  .join('\n'),
                            ),
                          );
                          context.read<GroupsCubit>().clean();
                        },
                      ),
                  context.read<GroupsCubit>().messagesId.isEmpty ||
                          context.read<GroupsCubit>().isSelectMessageNotme
                      ? SizedBox.shrink()
                      : IconButton(
                        icon: const Icon(Iconsax.trash),
                        onPressed: () {
                          context.read<GroupsCubit>().deleteMessage(
                            chatGroupModel.id!,
                          );
                          context.read<GroupsCubit>().clean();
                        },
                      ),

                  IconButton(
                    icon:
                        context.watch<GroupsCubit>().messagesId.isNotEmpty ||
                                context
                                    .watch<GroupsCubit>()
                                    .messagesTextSelected
                                    .isNotEmpty
                            ? const Icon(Iconsax.close_circle) // إغلاق التحديد
                            : const Icon(Iconsax.people), // عرض الأعضاء
                    onPressed: () {
                      if (context.read<GroupsCubit>().messagesId.isNotEmpty ||
                          context
                              .read<GroupsCubit>()
                              .messagesTextSelected
                              .isNotEmpty) {
                        context.read<GroupsCubit>().clean();
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => GroupMemberScreen(
                                  users: users,
                                  chatGroupModel: chatGroupModel,
                                ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: StreamBuilder(
                        stream:
                            FirebaseFirestore.instance
                                .collection('groups')
                                .doc(chatGroupModel.id)
                                .collection('messages')
                                .orderBy('time', descending: true)
                                .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }
                          List<MessageModel> messages =
                              snapshot.data!.docs
                                  .map(
                                    (doc) => MessageModel.fromJson(doc.data()),
                                  )
                                  .toList();
                          return messages.isEmpty
                              ? Center(
                                child: GestureDetector(
                                  onTap: () {
                                    FireDatabase().sendMessageToGroup(
                                      chatGroupModel.id!,
                                      'Sey Alsalam alaikum',
                                      chatGroupModel.name,
                                    );
                                  },
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '👋',
                                            style:
                                                Theme.of(
                                                  context,
                                                ).textTheme.displayMedium,
                                          ),
                                          Text(
                                            'Alsalam alaikum 👋',
                                            style:
                                                Theme.of(
                                                  context,
                                                ).textTheme.bodyMedium,
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
                                  return GestureDetector(
                                    onLongPress: () {
                                      context.read<GroupsCubit>().selectMessage(
                                        messageId:
                                            snapshot.data!.docs[idnex].id,
                                        senderId:
                                            snapshot.data!.docs[idnex]
                                                .data()['sender_id'],
                                      );
                                      context
                                          .read<GroupsCubit>()
                                          .selectMessageText(
                                            messages[idnex].type == 'image'
                                                ? 'image'
                                                : messages[idnex].message!,
                                          );
                                    },
                                    onTap: () {
                                      context
                                              .read<GroupsCubit>()
                                              .messagesId
                                              .isNotEmpty
                                          ? context
                                              .read<GroupsCubit>()
                                              .selectMessage(
                                                messageId:
                                                    snapshot
                                                        .data!
                                                        .docs[idnex]
                                                        .id,
                                                senderId:
                                                    snapshot.data!.docs[idnex]
                                                        .data()['sender_id'],
                                              )
                                          : null;

                                      context
                                              .read<GroupsCubit>()
                                              .messagesTextSelected
                                              .isNotEmpty
                                          ? context
                                              .read<GroupsCubit>()
                                              .selectMessageText(
                                                messages[idnex].type == 'image'
                                                    ? 'image'
                                                    : messages[idnex].message!,
                                              )
                                          : null;
                                    },
                                    child: Container(
                                      color:
                                          context
                                                  .read<GroupsCubit>()
                                                  .messagesId
                                                  .contains(
                                                    snapshot
                                                        .data!
                                                        .docs[idnex]
                                                        .id,
                                                  )
                                              ? Colors.grey
                                              : Colors.transparent,
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 1.5,
                                      ),
                                      child: CardGroupChat(
                                        messageModel: messages[idnex],
                                      ),
                                    ),
                                  );
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
                              controller:
                                  context.read<GroupsCubit>().messageController,
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
                                      onPressed: () {
                                        showCameraOrGallerySheet(
                                          context,
                                          onCameraSelected: () async {
                                            await context
                                                .read<GroupsCubit>()
                                                .chooseImage(
                                                  isGallery: false,
                                                  chatGroupModel:
                                                      chatGroupModel,
                                                );
                                          },
                                          onGallerySelected: () async {
                                            await context
                                                .read<GroupsCubit>()
                                                .chooseImage(
                                                  isGallery: true,
                                                  chatGroupModel:
                                                      chatGroupModel,
                                                );
                                          },
                                        );
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
                            context.read<GroupsCubit>().sendMessage(
                              chatGroupModel.id!,
                              chatGroupModel.name,
                            );
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
      },
    );
  }
}
