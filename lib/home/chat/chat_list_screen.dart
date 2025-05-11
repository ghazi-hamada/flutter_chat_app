import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_app/home/chat/chat_list_cubit/chat_list_cubit.dart';
import 'package:flutter_chat_app/home/chat/chat_screen.dart';
import 'package:flutter_chat_app/models/chat_room_model.dart';
import 'package:flutter_chat_app/models/chat_user_model.dart';
import 'package:flutter_chat_app/models/message_model.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class ChatList extends StatelessWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Iconsax.message_add),
        onPressed: () {
          showBottomSheet(
            context: context,
            builder:
                (context) => Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text('Enter Friend Email'),
                          Spacer(),
                          IconButton.filled(
                            onPressed: () {},
                            icon: Icon(Iconsax.scan_barcode),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Form(
                        key: context.read<ChatListCubit>().formKey,
                        child: TextFormField(
                          controller:
                              context.read<ChatListCubit>().emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(Iconsax.direct),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter an email';
                            } else if (value ==
                                FirebaseAuth.instance.currentUser!.email)
                              return 'You can not add yourself';
                            return null;
                          },
                        ),
                      ),

                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                        ),
                        child: BlocConsumer<ChatListCubit, ChatListState>(
                          listener: (context, state) {
                            if (state is ChatListCreated) {
                              Navigator.pop(context);
                            }
                          },
                          builder: (context, state) {
                            if (state is ChatListLoading) {
                              return const CircularProgressIndicator(
                                color: Colors.white,
                              );
                            }
                            return const Text('create chat');
                          },
                        ),
                        onPressed: () {
                          context.read<ChatListCubit>().sendInvitation();
                        },
                      ),
                    ],
                  ),
                ),
          );
        },
      ),
      appBar: AppBar(title: const Text('Chat'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance
                        .collection('rooms')
                        .where(
                          'members',
                          arrayContains: FirebaseAuth.instance.currentUser!.uid,
                        )
                        .where('last_message_time', isNotEqualTo: null)
                        .orderBy('last_message_time', descending: true)
                        .snapshots(),

                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  List<QueryDocumentSnapshot> docs = snapshot.data!.docs;

                  List<ChatRoom> rooms =
                      docs
                          .map(
                            (e) => ChatRoom.fromJson(
                              e.data() as Map<String, dynamic>,
                            ),
                          )
                          .toList();

                  // ترتيب الغرف حسب آخر رسالة
                  rooms.sort((a, b) {
                    if (a.lastMessageTime == null) return 1;
                    if (b.lastMessageTime == null) return -1;
                    return b.lastMessageTime!.compareTo(a.lastMessageTime!);
                  });

                  // اجمع الـuids بدون تكرار
                  Set<String> userIds = {};
                  for (var room in rooms) {
                    final otherId = room.members!.firstWhere(
                      (e) => e != FirebaseAuth.instance.currentUser!.uid,
                    );
                    userIds.add(otherId);
                  }

                  return userIds.isEmpty
                      ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Iconsax.message_remove,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Not have any chat yet',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                      : FutureBuilder(
                        future:
                            FirebaseFirestore.instance
                                .collection('users')
                                .where(
                                  FieldPath.documentId,
                                  whereIn: userIds.toList(),
                                )
                                .get(),
                        builder: (context, userSnapshot) {
                          if (!userSnapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          final userMap = {
                            for (var doc in userSnapshot.data!.docs)
                              doc.id: ChatUser.fromJson(doc.data()),
                          };

                          return ListView.builder(
                            itemCount: rooms.length,
                            itemBuilder: (context, index) {
                              final room = rooms[index];
                              final otherUserId = room.members!.firstWhere(
                                (e) =>
                                    e != FirebaseAuth.instance.currentUser!.uid,
                              );
                              final user = userMap[otherUserId];

                              if (user == null) return const SizedBox();

                              return ChatCard(
                                rooms: room,
                                roomId: docs[index].id,
                                user: user,
                              );
                            },
                          );
                        },
                      );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatCard extends StatelessWidget {
  const ChatCard({
    super.key,
    required this.rooms,
    this.roomId,
    required this.user,
  });

  final ChatRoom rooms;
  final String? roomId;
  final ChatUser user;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) =>
                        ChatScreen(user: user, roomId: roomId.toString()),
              ),
            ),
        leading: CircleAvatar(
          radius: 25,
          backgroundImage:
              user.image == ''
                  ? null
                  : CachedNetworkImageProvider(user.image.toString()),
        ),
        title: Text(user.name.toString()),
        subtitle: Text(
          rooms.lastMessage.toString() == ''
              ? 'Clik to start chat 😊'
              : rooms.lastMessage.toString(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: StreamBuilder(
          stream:
              FirebaseFirestore.instance
                  .collection('rooms')
                  .doc(roomId)
                  .collection('messages')
                  .snapshots(),
          builder: (context, snapshot) {
            final unReadList =
                snapshot.data?.docs
                    .map((e) => MessageModel.fromJson(e.data()))
                    .where((e) => e.read == '')
                    .where(
                      (e) =>
                          e.reciverId == FirebaseAuth.instance.currentUser!.uid,
                    )
                    .toList() ??
                [];

            return unReadList.isNotEmpty
                ? Badge(label: Text(unReadList.length.toString()))
                : Text(
                  rooms.lastMessageTime == null
                      ? ''
                      : DateFormat.jm().format(
                        DateTime.fromMillisecondsSinceEpoch(
                          int.parse(rooms.lastMessageTime.toString()),
                        ),
                      ),
                  style: Theme.of(context).textTheme.labelSmall,
                );
          },
        ),
      ),
    );
  }
}
