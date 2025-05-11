import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/firebase/fire_database.dart';
import 'package:flutter_chat_app/home/chat/chat_screen.dart';
import 'package:flutter_chat_app/home/groups/edit_group.dart';
import 'package:flutter_chat_app/models/chat_group_model.dart';
import 'package:flutter_chat_app/models/chat_user_model.dart';
import 'package:iconsax/iconsax.dart';

class GroupMemberScreen extends StatelessWidget {
  const GroupMemberScreen({
    super.key,
    required this.users,
    required this.chatGroupModel,
  });
  final List<ChatUser> users;
  final ChatGroupModel chatGroupModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Members'),
        centerTitle: true,
        actions: [
          chatGroupModel.admins!.contains(
                FirebaseAuth.instance.currentUser!.uid,
              )
              ? IconButton(
                icon: const Icon(Iconsax.user_edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              EditGroup(chatGroupModel: chatGroupModel),
                    ),
                  );
                },
              )
              : SizedBox(),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (BuildContext context, int index) {
                return StreamBuilder(
                  stream:
                      FirebaseFirestore.instance
                          .collection('users')
                          .where('id', isEqualTo: users[index].id)
                          .snapshots(),
                  builder: (context, snapshot) {
                    return ListTile(
                      leading: const CircleAvatar(),
                      title: Text(users[index].name!),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(users[index].email!),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  chatGroupModel.admins!.contains(
                                        users[index].id,
                                      )
                                      ? Theme.of(
                                        context,
                                      ).colorScheme.secondary.withOpacity(0.2)
                                      : Theme.of(
                                        context,
                                      ).colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              chatGroupModel.admins!.contains(users[index].id)
                                  ? 'Admin'
                                  : 'Member',
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),

                      trailing:
                          FirebaseAuth.instance.currentUser!.uid ==
                                  users[index].id
                              ? null
                              : chatGroupModel.admins!.contains(
                                FirebaseAuth.instance.currentUser!.uid,
                              )
                              ? PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == 'remove') {
                                    FireDatabase().removeMemberFromGroup(
                                      groupId: chatGroupModel.id!,
                                      memberId: users[index].id!,
                                    );
                                  } else if (value == 'make_admin') {
                                    FireDatabase().setMemberAsAdmin(
                                      groupId: chatGroupModel.id!,
                                      memberId: users[index].id!,
                                    );
                                  } else if (value == 'message') {
                                    List<String> usersId = [
                                      users[index].id!,
                                      FirebaseAuth.instance.currentUser!.uid,
                                    ]..sort((e1, e2) => e1.compareTo(e2));
                                    FireDatabase()
                                        .createRoom(email: users[index].email!)
                                        .then((value) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) => ChatScreen(
                                                    roomId: usersId.toString(),
                                                    user: users[index],
                                                  ),
                                            ),
                                          );
                                        });
                                  } else if (value == 'remove_admin') {
                                    FireDatabase().removeAdminFromGroup(
                                      groupId: chatGroupModel.id!,
                                      memberId: users[index].id!,
                                    );
                                  }
                                },
                                itemBuilder: (context) {
                                  final isAdmin = chatGroupModel.admins!
                                      .contains(users[index].id);
                                  return [
                                    const PopupMenuItem(
                                      value: 'remove',
                                      child: Text('إزالة من المجموعة'),
                                    ),
                                    PopupMenuItem(
                                      value:
                                          isAdmin
                                              ? 'remove_admin'
                                              : 'make_admin',
                                      child: Text(
                                        isAdmin
                                            ? 'إلغاء المسؤولية'
                                            : 'تعيين كمسؤول',
                                      ),
                                    ),
                                    const PopupMenuItem(
                                      value: 'message',
                                      child: Text('إرسال رسالة'),
                                    ),
                                  ];
                                },

                                icon: const Icon(Icons.more_vert),
                              )
                              : IconButton(
                                icon: const Icon(Iconsax.message),
                                onPressed: () {
                                  List<String> usersId = [
                                    users[index].id!,
                                    FirebaseAuth.instance.currentUser!.uid,
                                  ]..sort((e1, e2) => e1.compareTo(e2));
                                  FireDatabase()
                                      .createRoom(email: users[index].email!)
                                      .then((value) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => ChatScreen(
                                                  roomId: usersId.toString(),
                                                  user: users[index],
                                                ),
                                          ),
                                        );
                                      });
                                },
                              ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
