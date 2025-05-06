import 'package:flutter/material.dart';
import 'package:flutter_chat_app/widgets/custom_feild.dart';
import 'package:iconsax/iconsax.dart';

class CreateGroup extends StatelessWidget {
  const CreateGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Group'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(radius: 40),
                    Positioned(
                      bottom: -5,
                      right: -5,
                      child: Icon(
                        Iconsax.camera,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: customFeild(
                    controller: TextEditingController(),
                    labelText: 'Group Name',
                    icon: Iconsax.people,
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Divider(),
            SizedBox(height: 20),
            Row(children: [Text('Members'), Spacer(), Text('0')]),

            CheckboxListTile(
              value: false,
              onChanged: (value) {},
              title: Text('Public'),
            ),
          ],
        ),
      ),
    );
  }
}
