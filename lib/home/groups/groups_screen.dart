import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/home/chat/chat_screen.dart';
import 'package:flutter_chat_app/home/groups/chat_group_screen.dart';
import 'package:flutter_chat_app/home/groups/create_group.dart';
import 'package:flutter_chat_app/models/chat_group_model.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class GroupsScreen extends StatelessWidget {
  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Iconsax.message_add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateGroup()),
          );
        },
      ),
      appBar: AppBar(title: const Text('Groups'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance
                        .collection('groups')
                        .orderBy('last_message_time', descending: true)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox();
                  }
                  List<ChatGroupModel> groups =
                      snapshot.data!.docs
                          .map((doc) => ChatGroupModel.fromJson(doc.data()))
                          .where(
                            (element) => element.members!.contains(
                              FirebaseAuth.instance.currentUser!.uid,
                            ),
                          )
                          .toList();
                  return ListView.builder(
                    itemCount: groups.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => ChatGroupScreen(
                                      chatGroupModel: groups[index],
                                    ),
                              ),
                            ),
                        child: Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundImage: CachedNetworkImageProvider(
                                groups[index].image.toString(),
                              ),
                            ),
                            title: Text(groups[index].name.toString()),
                            subtitle: Text(
                              groups[index].lastMessage! == ''
                                  ? 'Clik to start chat 😊'
                                  : groups[index].lastMessage!,
                            ),
                            trailing:
                                1 == 1
                                    ? Text(
                                      groups[index].lastMessageTime == null
                                          ? ''
                                          : DateFormat.jm().format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                              int.parse(
                                                groups[index].lastMessageTime
                                                    .toString(),
                                              ),
                                            ),
                                          ),
                                      style:
                                          Theme.of(
                                            context,
                                          ).textTheme.labelSmall,
                                    )
                                    : Badge(label: const Text('1')),
                          ),
                        ),
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
