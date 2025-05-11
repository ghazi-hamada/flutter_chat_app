import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_app/home/groups/create_group/create_group_cubit.dart';
import 'package:flutter_chat_app/models/chat_user_model.dart';
import 'package:flutter_chat_app/widgets/custom_feild.dart';
import 'package:iconsax/iconsax.dart';

class CreateGroup extends StatelessWidget {
  const CreateGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateGroupCubit, CreateGroupState>(
      listener: (context, state) {
        if (state is CreateGroupCreated) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          floatingActionButton:
              context.read<CreateGroupCubit>().membersId.isEmpty
                  ? null
                  : FloatingActionButton.extended(
                    onPressed: () {
                      context.read<CreateGroupCubit>().createGroup();
                    },
                    icon: const Icon(Iconsax.people),
                    label: const Text('Create Group'),
                  ),

          appBar: AppBar(title: const Text('Create Group'), centerTitle: true),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
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
                          child: Icon(Iconsax.camera, size: 30),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Form(
                        key: context.read<CreateGroupCubit>().formKey,
                        child: customFeild(
                          controller:
                              context
                                  .read<CreateGroupCubit>()
                                  .nameGroupController,
                          labelText: 'Group Name',
                          icon: Iconsax.people,
                          validator: (value) {
                            return value!.isEmpty ? 'Enter Group Name' : null;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Divider(),
                SizedBox(height: 20),

                Expanded(
                  child: StreamBuilder(
                    stream:
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final myContacts = snapshot.data!.data()!['my_contacts'];
                      return StreamBuilder(
                        stream:
                            FirebaseFirestore.instance
                                .collection('users')
                                .where('id', whereIn: myContacts)
                                .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          List<ChatUser> users =
                              snapshot.data!.docs
                                  .map((e) => ChatUser.fromJson(e.data()))
                                  .toList()
                                ..sort(
                                  (e1, e2) => e1.name!.compareTo(e2.name!),
                                );
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Members (${context.read<CreateGroupCubit>().membersId.length})',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const Spacer(),
                                  TextButton(
                                    onPressed: () {
                                      context.read<CreateGroupCubit>().clean();
                                    },
                                    child: const Text('Clear'),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: users.length,
                                  itemBuilder: (context, index) {
                                    return CheckboxListTile(
                                      title: Text(users[index].name!),
                                      value: context
                                          .read<CreateGroupCubit>()
                                          .membersId
                                          .contains(users[index].id),
                                      onChanged: (value) {
                                        context
                                            .read<CreateGroupCubit>()
                                            .addMember(users[index].id!);
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
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
      },
    );
  }
}
