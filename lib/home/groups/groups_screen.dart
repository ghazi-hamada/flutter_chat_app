import 'package:flutter/material.dart';
import 'package:flutter_chat_app/home/chat/chat_screen.dart';
import 'package:flutter_chat_app/home/groups/chat_group_screen.dart';
import 'package:flutter_chat_app/home/groups/create_group.dart';
import 'package:iconsax/iconsax.dart';

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
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    ChatGroupScreen(),
                          ),
                        ),
                    child: Card(
                      child: ListTile(
                        leading: CircleAvatar(),
                        title: Text('Group ${index + 1}'),
                        subtitle: const Text('Hello'),
                        trailing: Badge(label: const Text('1')),
                      ),
                    ),
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
