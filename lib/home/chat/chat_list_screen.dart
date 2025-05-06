import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_app/home/chat/chat_list_cubit/chat_list_cubit.dart';
import 'package:flutter_chat_app/home/chat/chat_screen.dart';
import 'package:flutter_chat_app/models/chat_room_model.dart';
import 'package:flutter_chat_app/models/chat_user_model.dart';
import 'package:iconsax/iconsax.dart';

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
                          validator:
                              (value) =>
                                  value!.isEmpty ? 'Enter an email' : null,
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
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection('rooms')
                        .where(
                          'members',
                          arrayContains: FirebaseAuth.instance.currentUser!.uid,
                        )
                        .snapshots(),

                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  List<ChatRoom> rooms =
                      snapshot.data!.docs
                          .map(
                            (e) => ChatRoom.fromJson(
                              e.data() as Map<String, dynamic>,
                            ),
                          )
                          .toList()
                        ..sort(
                          (a, b) =>
                              a.lastMessageTime!.compareTo(b.lastMessageTime!),
                        );
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return ChatCard(
                        rooms: rooms[index],
                        roomId: snapshot.data!.docs[index].id,
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
  const ChatCard({super.key, required this.rooms, this.roomId});

  final ChatRoom rooms;

  final String? roomId;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:
          FirebaseFirestore.instance
              .collection('users')
              .doc(
                rooms.members!.firstWhere(
                  (e) => e != FirebaseAuth.instance.currentUser!.uid,
                ),
              )
              .snapshots(),

      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        ChatUser user = ChatUser.fromJson(snapshot.data!.data()!);
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
            leading: CircleAvatar(),
            title: Text(user.name.toString()),
            subtitle: Text(user.online! ? 'Online' : 'Offline'),
            trailing: Badge(label: Text('2')),
          ),
        );
      },
    );
  }
}
