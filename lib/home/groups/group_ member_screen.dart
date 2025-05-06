import 'package:flutter/material.dart';
import 'package:flutter_chat_app/home/groups/edit_group.dart';
import 'package:iconsax/iconsax.dart';

class GroupMemberScreen extends StatelessWidget {
  const GroupMemberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Members'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Iconsax.user_edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditGroup()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: const CircleAvatar(),
                  title: const Text('User Name'),
                  subtitle: const Text('User Email'),
                  trailing:
                      true
                          ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Iconsax.user_remove),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: const Icon(Iconsax.user_tick),
                                onPressed: () {},
                              ),
                            ],
                          )
                          : IconButton(
                            icon: const Icon(Iconsax.message),
                            onPressed: () {},
                          ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
