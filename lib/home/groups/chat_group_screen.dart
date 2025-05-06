import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/home/chat/widgets/card_chat.dart';
import 'package:flutter_chat_app/home/groups/card_group_chat.dart';
import 'package:flutter_chat_app/home/groups/group_%20member_screen.dart';
import 'package:iconsax/iconsax.dart';

class ChatGroupScreen extends StatelessWidget {
  const ChatGroupScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Group Name'),
            Text(
              'Ghazi, Tamer, Ata...',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.people),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GroupMemberScreen()),
              );
            },
          ),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                reverse: true,
                itemBuilder: (context, idnex) {
                  return CardGroupChat(idnex: idnex);
                },
              ),
              // child: Center(
              //   child: Card(
              //     child: Padding(
              //       padding: const EdgeInsets.all(16.0),
              //       child: Column(
              //         mainAxisSize: MainAxisSize.min,
              //         crossAxisAlignment: CrossAxisAlignment.center,
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           Text(
              //             '👋',
              //             style: Theme.of(context).textTheme.displayMedium,
              //           ),
              //           Text(
              //             'Sey Alsalam alaikum',
              //             style: Theme.of(context).textTheme.bodyMedium,
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
            ),
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: TextFormField(
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
                              onPressed: () {},
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
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
